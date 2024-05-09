1 pragma solidity ^0.8.0;
2 
3 /**
4  * @dev Interface of the ERC20 standard as defined in the EIP.
5  */
6 interface IERC20 {
7     /**
8      * @dev Returns the amount of tokens in existence.
9      */
10     function totalSupply() external view returns (uint256);
11 
12     /**
13      * @dev Returns the amount of tokens owned by `account`.
14      */
15     function balanceOf(address account) external view returns (uint256);
16 
17     /**
18      * @dev Moves `amount` tokens from the caller's account to `recipient`.
19      *
20      * Returns a boolean value indicating whether the operation succeeded.
21      *
22      * Emits a {Transfer} event.
23      */
24     function transfer(address recipient, uint256 amount) external returns (bool);
25 
26     /**
27      * @dev Returns the remaining number of tokens that `spender` will be
28      * allowed to spend on behalf of `owner` through {transferFrom}. This is
29      * zero by default.
30      *
31      * This value changes when {approve} or {transferFrom} are called.
32      */
33     function allowance(address owner, address spender) external view returns (uint256);
34 
35     /**
36      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
37      *
38      * Returns a boolean value indicating whether the operation succeeded.
39      *
40      * IMPORTANT: Beware that changing an allowance with this method brings the risk
41      * that someone may use both the old and the new allowance by unfortunate
42      * transaction ordering. One possible solution to mitigate this race
43      * condition is to first reduce the spender's allowance to 0 and set the
44      * desired value afterwards:
45      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
46      *
47      * Emits an {Approval} event.
48      */
49     function approve(address spender, uint256 amount) external returns (bool);
50 
51     /**
52      * @dev Moves `amount` tokens from `sender` to `recipient` using the
53      * allowance mechanism. `amount` is then deducted from the caller's
54      * allowance.
55      *
56      * Returns a boolean value indicating whether the operation succeeded.
57      *
58      * Emits a {Transfer} event.
59      */
60     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
61 
62     /**
63      * @dev Emitted when `value` tokens are moved from one account (`from`) to
64      * another (`to`).
65      *
66      * Note that `value` may be zero.
67      */
68     event Transfer(address indexed from, address indexed to, uint256 value);
69 
70     /**
71      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
72      * a call to {approve}. `value` is the new allowance.
73      */
74     event Approval(address indexed owner, address indexed spender, uint256 value);
75 }
76 
77 // File: @openzeppelin/contracts/utils/Context.sol
78 
79 pragma solidity ^0.8.0;
80 
81 /*
82  * @dev Provides information about the current execution context, including the
83  * sender of the transaction and its data. While these are generally available
84  * via msg.sender and msg.data, they should not be accessed in such a direct
85  * manner, since when dealing with meta-transactions the account sending and
86  * paying for execution may not be the actual sender (as far as an application
87  * is concerned).
88  *
89  * This contract is only required for intermediate, library-like contracts.
90  */
91 abstract contract Context {
92     function _msgSender() internal view virtual returns (address) {
93         return msg.sender;
94     }
95 
96     function _msgData() internal view virtual returns (bytes calldata) {
97         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
98         return msg.data;
99     }
100 }
101 
102 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
103 
104 pragma solidity ^0.8.0;
105 
106 
107 
108 /**
109  * @dev Implementation of the {IERC20} interface.
110  *
111  * This implementation is agnostic to the way tokens are created. This means
112  * that a supply mechanism has to be added in a derived contract using {_mint}.
113  * For a generic mechanism see {ERC20PresetMinterPauser}.
114  *
115  * TIP: For a detailed writeup see our guide
116  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
117  * to implement supply mechanisms].
118  *
119  * We have followed general OpenZeppelin guidelines: functions revert instead
120  * of returning `false` on failure. This behavior is nonetheless conventional
121  * and does not conflict with the expectations of ERC20 applications.
122  *
123  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
124  * This allows applications to reconstruct the allowance for all accounts just
125  * by listening to said events. Other implementations of the EIP may not emit
126  * these events, as it isn't required by the specification.
127  *
128  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
129  * functions have been added to mitigate the well-known issues around setting
130  * allowances. See {IERC20-approve}.
131  */
132 contract ERC20 is Context, IERC20 {
133     mapping (address => uint256) private _balances;
134 
135     mapping (address => mapping (address => uint256)) private _allowances;
136 
137     uint256 private _totalSupply;
138 
139     string private _name;
140     string private _symbol;
141 
142     /**
143      * @dev Sets the values for {name} and {symbol}.
144      *
145      * The defaut value of {decimals} is 18. To select a different value for
146      * {decimals} you should overload it.
147      *
148      * All three of these values are immutable: they can only be set once during
149      * construction.
150      */
151     constructor (string memory name_, string memory symbol_) {
152         _name = name_;
153         _symbol = symbol_;
154     }
155 
156     /**
157      * @dev Returns the name of the token.
158      */
159     function name() public view virtual returns (string memory) {
160         return _name;
161     }
162 
163     /**
164      * @dev Returns the symbol of the token, usually a shorter version of the
165      * name.
166      */
167     function symbol() public view virtual returns (string memory) {
168         return _symbol;
169     }
170 
171     /**
172      * @dev Returns the number of decimals used to get its user representation.
173      * For example, if `decimals` equals `2`, a balance of `505` tokens should
174      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
175      *
176      * Tokens usually opt for a value of 18, imitating the relationship between
177      * Ether and Wei. This is the value {ERC20} uses, unless this function is
178      * overloaded;
179      *
180      * NOTE: This information is only used for _display_ purposes: it in
181      * no way affects any of the arithmetic of the contract, including
182      * {IERC20-balanceOf} and {IERC20-transfer}.
183      */
184     function decimals() public view virtual returns (uint8) {
185         return 18;
186     }
187 
188     /**
189      * @dev See {IERC20-totalSupply}.
190      */
191     function totalSupply() public view virtual override returns (uint256) {
192         return _totalSupply;
193     }
194 
195     /**
196      * @dev See {IERC20-balanceOf}.
197      */
198     function balanceOf(address account) public view virtual override returns (uint256) {
199         return _balances[account];
200     }
201 
202     /**
203      * @dev See {IERC20-transfer}.
204      *
205      * Requirements:
206      *
207      * - `recipient` cannot be the zero address.
208      * - the caller must have a balance of at least `amount`.
209      */
210     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
211         _transfer(_msgSender(), recipient, amount);
212         return true;
213     }
214 
215     /**
216      * @dev See {IERC20-allowance}.
217      */
218     function allowance(address owner, address spender) public view virtual override returns (uint256) {
219         return _allowances[owner][spender];
220     }
221 
222     /**
223      * @dev See {IERC20-approve}.
224      *
225      * Requirements:
226      *
227      * - `spender` cannot be the zero address.
228      */
229     function approve(address spender, uint256 amount) public virtual override returns (bool) {
230         _approve(_msgSender(), spender, amount);
231         return true;
232     }
233 
234     /**
235      * @dev See {IERC20-transferFrom}.
236      *
237      * Emits an {Approval} event indicating the updated allowance. This is not
238      * required by the EIP. See the note at the beginning of {ERC20}.
239      *
240      * Requirements:
241      *
242      * - `sender` and `recipient` cannot be the zero address.
243      * - `sender` must have a balance of at least `amount`.
244      * - the caller must have allowance for ``sender``'s tokens of at least
245      * `amount`.
246      */
247     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
248         _transfer(sender, recipient, amount);
249 
250         uint256 currentAllowance = _allowances[sender][_msgSender()];
251         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
252         _approve(sender, _msgSender(), currentAllowance - amount);
253 
254         return true;
255     }
256 
257     /**
258      * @dev Atomically increases the allowance granted to `spender` by the caller.
259      *
260      * This is an alternative to {approve} that can be used as a mitigation for
261      * problems described in {IERC20-approve}.
262      *
263      * Emits an {Approval} event indicating the updated allowance.
264      *
265      * Requirements:
266      *
267      * - `spender` cannot be the zero address.
268      */
269     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
270         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
271         return true;
272     }
273 
274     /**
275      * @dev Atomically decreases the allowance granted to `spender` by the caller.
276      *
277      * This is an alternative to {approve} that can be used as a mitigation for
278      * problems described in {IERC20-approve}.
279      *
280      * Emits an {Approval} event indicating the updated allowance.
281      *
282      * Requirements:
283      *
284      * - `spender` cannot be the zero address.
285      * - `spender` must have allowance for the caller of at least
286      * `subtractedValue`.
287      */
288     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
289         uint256 currentAllowance = _allowances[_msgSender()][spender];
290         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
291         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
292 
293         return true;
294     }
295 
296     /**
297      * @dev Moves tokens `amount` from `sender` to `recipient`.
298      *
299      * This is internal function is equivalent to {transfer}, and can be used to
300      * e.g. implement automatic token fees, slashing mechanisms, etc.
301      *
302      * Emits a {Transfer} event.
303      *
304      * Requirements:
305      *
306      * - `sender` cannot be the zero address.
307      * - `recipient` cannot be the zero address.
308      * - `sender` must have a balance of at least `amount`.
309      */
310     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
311         require(sender != address(0), "ERC20: transfer from the zero address");
312         require(recipient != address(0), "ERC20: transfer to the zero address");
313 
314         _beforeTokenTransfer(sender, recipient, amount);
315 
316         uint256 senderBalance = _balances[sender];
317         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
318         _balances[sender] = senderBalance - amount;
319         _balances[recipient] += amount;
320 
321         emit Transfer(sender, recipient, amount);
322     }
323 
324     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
325      * the total supply.
326      *
327      * Emits a {Transfer} event with `from` set to the zero address.
328      *
329      * Requirements:
330      *
331      * - `to` cannot be the zero address.
332      */
333     function _mint(address account, uint256 amount) internal virtual {
334         require(account != address(0), "ERC20: mint to the zero address");
335 
336         _beforeTokenTransfer(address(0), account, amount);
337 
338         _totalSupply += amount;
339         _balances[account] += amount;
340         emit Transfer(address(0), account, amount);
341     }
342 
343     /**
344      * @dev Destroys `amount` tokens from `account`, reducing the
345      * total supply.
346      *
347      * Emits a {Transfer} event with `to` set to the zero address.
348      *
349      * Requirements:
350      *
351      * - `account` cannot be the zero address.
352      * - `account` must have at least `amount` tokens.
353      */
354     function _burn(address account, uint256 amount) internal virtual {
355         require(account != address(0), "ERC20: burn from the zero address");
356 
357         _beforeTokenTransfer(account, address(0), amount);
358 
359         uint256 accountBalance = _balances[account];
360         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
361         _balances[account] = accountBalance - amount;
362         _totalSupply -= amount;
363 
364         emit Transfer(account, address(0), amount);
365     }
366 
367     /**
368      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
369      *
370      * This internal function is equivalent to `approve`, and can be used to
371      * e.g. set automatic allowances for certain subsystems, etc.
372      *
373      * Emits an {Approval} event.
374      *
375      * Requirements:
376      *
377      * - `owner` cannot be the zero address.
378      * - `spender` cannot be the zero address.
379      */
380     function _approve(address owner, address spender, uint256 amount) internal virtual {
381         require(owner != address(0), "ERC20: approve from the zero address");
382         require(spender != address(0), "ERC20: approve to the zero address");
383 
384         _allowances[owner][spender] = amount;
385         emit Approval(owner, spender, amount);
386     }
387 
388     /**
389      * @dev Hook that is called before any transfer of tokens. This includes
390      * minting and burning.
391      *
392      * Calling conditions:
393      *
394      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
395      * will be to transferred to `to`.
396      * - when `from` is zero, `amount` tokens will be minted for `to`.
397      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
398      * - `from` and `to` are never both zero.
399      *
400      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
401      */
402     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
403 }
404 
405 // File: @openzeppelin/contracts/access/Ownable.sol
406 
407 pragma solidity ^0.8.0;
408 
409 /**
410  * @dev Contract module which provides a basic access control mechanism, where
411  * there is an account (an owner) that can be granted exclusive access to
412  * specific functions.
413  *
414  * By default, the owner account will be the one that deploys the contract. This
415  * can later be changed with {transferOwnership}.
416  *
417  * This module is used through inheritance. It will make available the modifier
418  * `onlyOwner`, which can be applied to your functions to restrict their use to
419  * the owner.
420  */
421 abstract contract Ownable is Context {
422     address private _owner;
423 
424     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
425 
426     /**
427      * @dev Initializes the contract setting the deployer as the initial owner.
428      */
429     constructor () {
430         address msgSender = _msgSender();
431         _owner = msgSender;
432         emit OwnershipTransferred(address(0), msgSender);
433     }
434 
435     /**
436      * @dev Returns the address of the current owner.
437      */
438     function owner() public view virtual returns (address) {
439         return _owner;
440     }
441 
442     /**
443      * @dev Throws if called by any account other than the owner.
444      */
445     modifier onlyOwner() {
446         require(owner() == _msgSender(), "Ownable: caller is not the owner");
447         _;
448     }
449 
450     /**
451      * @dev Leaves the contract without owner. It will not be possible to call
452      * `onlyOwner` functions anymore. Can only be called by the current owner.
453      *
454      * NOTE: Renouncing ownership will leave the contract without an owner,
455      * thereby removing any functionality that is only available to the owner.
456      */
457     function renounceOwnership() public virtual onlyOwner {
458         emit OwnershipTransferred(_owner, address(0));
459         _owner = address(0);
460     }
461 
462     /**
463      * @dev Transfers ownership of the contract to a new account (`newOwner`).
464      * Can only be called by the current owner.
465      */
466     function transferOwnership(address newOwner) public virtual onlyOwner {
467         require(newOwner != address(0), "Ownable: new owner is the zero address");
468         emit OwnershipTransferred(_owner, newOwner);
469         _owner = newOwner;
470     }
471 }
472 
473 // File: contracts/WrappedNCG.sol
474 
475 pragma solidity >=0.8.0;
476 
477 
478 
479 contract WrappedNCG is ERC20, Ownable {
480     event Burn(address indexed _sender, bytes32 indexed _to, uint256 amount);
481 
482     constructor() ERC20("Wrapped NCG", "WNCG") {}
483 
484     function burn(uint256 amount, bytes32 to) public {
485         _burn(_msgSender(), amount);
486 
487         emit Burn(_msgSender(), to, amount);
488     }
489 
490     function mint(address account, uint256 amount) public onlyOwner {
491         _mint(account, amount);
492     }
493 
494     function decimals() public pure override returns (uint8) {
495         return 18;
496     }
497 }