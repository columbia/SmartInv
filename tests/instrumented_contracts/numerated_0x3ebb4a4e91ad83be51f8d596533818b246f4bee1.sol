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
102 /**
103  * @dev Implementation of the {IERC20} interface.
104  *
105  * This implementation is agnostic to the way tokens are created. This means
106  * that a supply mechanism has to be added in a derived contract using {_mint}.
107  * For a generic mechanism see {ERC20PresetMinterPauser}.
108  *
109  * TIP: For a detailed writeup see our guide
110  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
111  * to implement supply mechanisms].
112  *
113  * We have followed general OpenZeppelin guidelines: functions revert instead
114  * of returning `false` on failure. This behavior is nonetheless conventional
115  * and does not conflict with the expectations of ERC20 applications.
116  *
117  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
118  * This allows applications to reconstruct the allowance for all accounts just
119  * by listening to said events. Other implementations of the EIP may not emit
120  * these events, as it isn't required by the specification.
121  *
122  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
123  * functions have been added to mitigate the well-known issues around setting
124  * allowances. See {IERC20-approve}.
125  */
126 contract ERC20 is Context, IERC20 {
127     mapping (address => uint256) private _balances;
128 
129     mapping (address => mapping (address => uint256)) private _allowances;
130 
131     uint256 private _totalSupply;
132 
133     string private _name;
134     string private _symbol;
135 
136     /**
137      * @dev Sets the values for {name} and {symbol}.
138      *
139      * The defaut value of {decimals} is 18. To select a different value for
140      * {decimals} you should overload it.
141      *
142      * All three of these values are immutable: they can only be set once during
143      * construction.
144      */
145     constructor (string memory name_, string memory symbol_) {
146         _name = name_;
147         _symbol = symbol_;
148     }
149 
150     /**
151      * @dev Returns the name of the token.
152      */
153     function name() public view virtual returns (string memory) {
154         return _name;
155     }
156 
157     /**
158      * @dev Returns the symbol of the token, usually a shorter version of the
159      * name.
160      */
161     function symbol() public view virtual returns (string memory) {
162         return _symbol;
163     }
164 
165     /**
166      * @dev Returns the number of decimals used to get its user representation.
167      * For example, if `decimals` equals `2`, a balance of `505` tokens should
168      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
169      *
170      * Tokens usually opt for a value of 18, imitating the relationship between
171      * Ether and Wei. This is the value {ERC20} uses, unless this function is
172      * overloaded;
173      *
174      * NOTE: This information is only used for _display_ purposes: it in
175      * no way affects any of the arithmetic of the contract, including
176      * {IERC20-balanceOf} and {IERC20-transfer}.
177      */
178     function decimals() public view virtual returns (uint8) {
179         return 18;
180     }
181 
182     /**
183      * @dev See {IERC20-totalSupply}.
184      */
185     function totalSupply() public view virtual override returns (uint256) {
186         return _totalSupply;
187     }
188 
189     /**
190      * @dev See {IERC20-balanceOf}.
191      */
192     function balanceOf(address account) public view virtual override returns (uint256) {
193         return _balances[account];
194     }
195 
196     /**
197      * @dev See {IERC20-transfer}.
198      *
199      * Requirements:
200      *
201      * - `recipient` cannot be the zero address.
202      * - the caller must have a balance of at least `amount`.
203      */
204     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
205         _transfer(_msgSender(), recipient, amount);
206         return true;
207     }
208 
209     /**
210      * @dev See {IERC20-allowance}.
211      */
212     function allowance(address owner, address spender) public view virtual override returns (uint256) {
213         return _allowances[owner][spender];
214     }
215 
216     /**
217      * @dev See {IERC20-approve}.
218      *
219      * Requirements:
220      *
221      * - `spender` cannot be the zero address.
222      */
223     function approve(address spender, uint256 amount) public virtual override returns (bool) {
224         _approve(_msgSender(), spender, amount);
225         return true;
226     }
227 
228     /**
229      * @dev See {IERC20-transferFrom}.
230      *
231      * Emits an {Approval} event indicating the updated allowance. This is not
232      * required by the EIP. See the note at the beginning of {ERC20}.
233      *
234      * Requirements:
235      *
236      * - `sender` and `recipient` cannot be the zero address.
237      * - `sender` must have a balance of at least `amount`.
238      * - the caller must have allowance for ``sender``'s tokens of at least
239      * `amount`.
240      */
241     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
242         _transfer(sender, recipient, amount);
243 
244         uint256 currentAllowance = _allowances[sender][_msgSender()];
245         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
246         _approve(sender, _msgSender(), currentAllowance - amount);
247 
248         return true;
249     }
250 
251     /**
252      * @dev Atomically increases the allowance granted to `spender` by the caller.
253      *
254      * This is an alternative to {approve} that can be used as a mitigation for
255      * problems described in {IERC20-approve}.
256      *
257      * Emits an {Approval} event indicating the updated allowance.
258      *
259      * Requirements:
260      *
261      * - `spender` cannot be the zero address.
262      */
263     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
264         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
265         return true;
266     }
267 
268     /**
269      * @dev Atomically decreases the allowance granted to `spender` by the caller.
270      *
271      * This is an alternative to {approve} that can be used as a mitigation for
272      * problems described in {IERC20-approve}.
273      *
274      * Emits an {Approval} event indicating the updated allowance.
275      *
276      * Requirements:
277      *
278      * - `spender` cannot be the zero address.
279      * - `spender` must have allowance for the caller of at least
280      * `subtractedValue`.
281      */
282     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
283         uint256 currentAllowance = _allowances[_msgSender()][spender];
284         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
285         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
286 
287         return true;
288     }
289 
290     /**
291      * @dev Moves tokens `amount` from `sender` to `recipient`.
292      *
293      * This is internal function is equivalent to {transfer}, and can be used to
294      * e.g. implement automatic token fees, slashing mechanisms, etc.
295      *
296      * Emits a {Transfer} event.
297      *
298      * Requirements:
299      *
300      * - `sender` cannot be the zero address.
301      * - `recipient` cannot be the zero address.
302      * - `sender` must have a balance of at least `amount`.
303      */
304     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
305         require(sender != address(0), "ERC20: transfer from the zero address");
306         require(recipient != address(0), "ERC20: transfer to the zero address");
307 
308         _beforeTokenTransfer(sender, recipient, amount);
309 
310         uint256 senderBalance = _balances[sender];
311         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
312         _balances[sender] = senderBalance - amount;
313         _balances[recipient] += amount;
314 
315         emit Transfer(sender, recipient, amount);
316     }
317 
318     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
319      * the total supply.
320      *
321      * Emits a {Transfer} event with `from` set to the zero address.
322      *
323      * Requirements:
324      *
325      * - `to` cannot be the zero address.
326      */
327     function _mint(address account, uint256 amount) internal virtual {
328         require(account != address(0), "ERC20: mint to the zero address");
329 
330         _beforeTokenTransfer(address(0), account, amount);
331 
332         _totalSupply += amount;
333         _balances[account] += amount;
334         emit Transfer(address(0), account, amount);
335     }
336 
337     /**
338      * @dev Destroys `amount` tokens from `account`, reducing the
339      * total supply.
340      *
341      * Emits a {Transfer} event with `to` set to the zero address.
342      *
343      * Requirements:
344      *
345      * - `account` cannot be the zero address.
346      * - `account` must have at least `amount` tokens.
347      */
348     function _burn(address account, uint256 amount) internal virtual {
349         require(account != address(0), "ERC20: burn from the zero address");
350 
351         _beforeTokenTransfer(account, address(0), amount);
352 
353         uint256 accountBalance = _balances[account];
354         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
355         _balances[account] = accountBalance - amount;
356         _totalSupply -= amount;
357 
358         emit Transfer(account, address(0), amount);
359     }
360 
361     /**
362      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
363      *
364      * This internal function is equivalent to `approve`, and can be used to
365      * e.g. set automatic allowances for certain subsystems, etc.
366      *
367      * Emits an {Approval} event.
368      *
369      * Requirements:
370      *
371      * - `owner` cannot be the zero address.
372      * - `spender` cannot be the zero address.
373      */
374     function _approve(address owner, address spender, uint256 amount) internal virtual {
375         require(owner != address(0), "ERC20: approve from the zero address");
376         require(spender != address(0), "ERC20: approve to the zero address");
377 
378         _allowances[owner][spender] = amount;
379         emit Approval(owner, spender, amount);
380     }
381 
382     /**
383      * @dev Hook that is called before any transfer of tokens. This includes
384      * minting and burning.
385      *
386      * Calling conditions:
387      *
388      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
389      * will be to transferred to `to`.
390      * - when `from` is zero, `amount` tokens will be minted for `to`.
391      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
392      * - `from` and `to` are never both zero.
393      *
394      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
395      */
396     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
397 }
398 
399 /**
400  * @dev Contract module which provides a basic access control mechanism, where
401  * there is an account (an owner) that can be granted exclusive access to
402  * specific functions.
403  *
404  * By default, the owner account will be the one that deploys the contract. This
405  * can later be changed with {transferOwnership}.
406  *
407  * This module is used through inheritance. It will make available the modifier
408  * `onlyOwner`, which can be applied to your functions to restrict their use to
409  * the owner.
410  */
411 abstract contract Ownable is Context {
412     address private _owner;
413 
414     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
415 
416     /**
417      * @dev Initializes the contract setting the deployer as the initial owner.
418      */
419     constructor () {
420         address msgSender = _msgSender();
421         _owner = msgSender;
422         emit OwnershipTransferred(address(0), msgSender);
423     }
424 
425     /**
426      * @dev Returns the address of the current owner.
427      */
428     function owner() public view virtual returns (address) {
429         return _owner;
430     }
431 
432     /**
433      * @dev Throws if called by any account other than the owner.
434      */
435     modifier onlyOwner() {
436         require(owner() == _msgSender(), "Ownable: caller is not the owner");
437         _;
438     }
439 
440     /**
441      * @dev Leaves the contract without owner. It will not be possible to call
442      * `onlyOwner` functions anymore. Can only be called by the current owner.
443      *
444      * NOTE: Renouncing ownership will leave the contract without an owner,
445      * thereby removing any functionality that is only available to the owner.
446      */
447     function renounceOwnership() public virtual onlyOwner {
448         emit OwnershipTransferred(_owner, address(0));
449         _owner = address(0);
450     }
451 
452     /**
453      * @dev Transfers ownership of the contract to a new account (`newOwner`).
454      * Can only be called by the current owner.
455      */
456     function transferOwnership(address newOwner) public virtual onlyOwner {
457         require(newOwner != address(0), "Ownable: new owner is the zero address");
458         emit OwnershipTransferred(_owner, newOwner);
459         _owner = newOwner;
460     }
461 }
462 
463 contract SATAToken is ERC20, Ownable {
464   bool private airdropMinted = false;
465 
466   constructor(
467     string memory name_,
468     string memory symbol_,
469     address reserveAddress,
470     uint256 reserveAmount,
471     address integrationAddress,
472     uint256 integrationAmount,
473     uint256 remainderAmount
474   )
475     ERC20(name_, symbol_)
476   {
477     // allocate the reserves
478     _mint(reserveAddress, reserveAmount);
479     _mint(integrationAddress, integrationAmount);
480     // allocate the remainder to the contract
481     _mint(msg.sender, remainderAmount);
482   }
483 
484   function mintAirdrop(address contractAddress, uint256 airdropAmount) external onlyOwner {
485     require(!airdropMinted, "Airdrop already minted.");
486     airdropMinted = true;
487     _mint(contractAddress, airdropAmount);
488   }
489 }