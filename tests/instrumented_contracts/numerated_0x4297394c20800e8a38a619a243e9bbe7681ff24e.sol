1 // File: @openzeppelin/contracts/utils/Context.sol
2 
3 // SPDX-License-Identifier: MIT
4 
5 pragma solidity ^0.8.0;
6 
7 /*
8  * @dev Provides information about the current execution context, including the
9  * sender of the transaction and its data. While these are generally available
10  * via msg.sender and msg.data, they should not be accessed in such a direct
11  * manner, since when dealing with meta-transactions the account sending and
12  * paying for execution may not be the actual sender (as far as an application
13  * is concerned).
14  *
15  * This contract is only required for intermediate, library-like contracts.
16  */
17 abstract contract Context {
18     function _msgSender() internal view virtual returns (address) {
19         return msg.sender;
20     }
21 
22     function _msgData() internal view virtual returns (bytes calldata) {
23         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
24         return msg.data;
25     }
26 }
27 
28 // File: @openzeppelin/contracts/access/Ownable.sol
29 
30 
31 
32 pragma solidity ^0.8.0;
33 
34 /**
35  * @dev Contract module which provides a basic access control mechanism, where
36  * there is an account (an owner) that can be granted exclusive access to
37  * specific functions.
38  *
39  * By default, the owner account will be the one that deploys the contract. This
40  * can later be changed with {transferOwnership}.
41  *
42  * This module is used through inheritance. It will make available the modifier
43  * `onlyOwner`, which can be applied to your functions to restrict their use to
44  * the owner.
45  */
46 abstract contract Ownable is Context {
47     address private _owner;
48 
49     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
50 
51     /**
52      * @dev Initializes the contract setting the deployer as the initial owner.
53      */
54     constructor () {
55         address msgSender = _msgSender();
56         _owner = msgSender;
57         emit OwnershipTransferred(address(0), msgSender);
58     }
59 
60     /**
61      * @dev Returns the address of the current owner.
62      */
63     function owner() public view virtual returns (address) {
64         return _owner;
65     }
66 
67     /**
68      * @dev Throws if called by any account other than the owner.
69      */
70     modifier onlyOwner() {
71         require(owner() == _msgSender(), "Ownable: caller is not the owner");
72         _;
73     }
74 
75     /**
76      * @dev Leaves the contract without owner. It will not be possible to call
77      * `onlyOwner` functions anymore. Can only be called by the current owner.
78      *
79      * NOTE: Renouncing ownership will leave the contract without an owner,
80      * thereby removing any functionality that is only available to the owner.
81      */
82     function renounceOwnership() public virtual onlyOwner {
83         emit OwnershipTransferred(_owner, address(0));
84         _owner = address(0);
85     }
86 
87     /**
88      * @dev Transfers ownership of the contract to a new account (`newOwner`).
89      * Can only be called by the current owner.
90      */
91     function transferOwnership(address newOwner) public virtual onlyOwner {
92         require(newOwner != address(0), "Ownable: new owner is the zero address");
93         emit OwnershipTransferred(_owner, newOwner);
94         _owner = newOwner;
95     }
96 }
97 
98 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
99 
100 
101 
102 pragma solidity ^0.8.0;
103 
104 /**
105  * @dev Interface of the ERC20 standard as defined in the EIP.
106  */
107 interface IERC20 {
108     /**
109      * @dev Returns the amount of tokens in existence.
110      */
111     function totalSupply() external view returns (uint256);
112 
113     /**
114      * @dev Returns the amount of tokens owned by `account`.
115      */
116     function balanceOf(address account) external view returns (uint256);
117 
118     /**
119      * @dev Moves `amount` tokens from the caller's account to `recipient`.
120      *
121      * Returns a boolean value indicating whether the operation succeeded.
122      *
123      * Emits a {Transfer} event.
124      */
125     function transfer(address recipient, uint256 amount) external returns (bool);
126 
127     /**
128      * @dev Returns the remaining number of tokens that `spender` will be
129      * allowed to spend on behalf of `owner` through {transferFrom}. This is
130      * zero by default.
131      *
132      * This value changes when {approve} or {transferFrom} are called.
133      */
134     function allowance(address owner, address spender) external view returns (uint256);
135 
136     /**
137      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
138      *
139      * Returns a boolean value indicating whether the operation succeeded.
140      *
141      * IMPORTANT: Beware that changing an allowance with this method brings the risk
142      * that someone may use both the old and the new allowance by unfortunate
143      * transaction ordering. One possible solution to mitigate this race
144      * condition is to first reduce the spender's allowance to 0 and set the
145      * desired value afterwards:
146      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
147      *
148      * Emits an {Approval} event.
149      */
150     function approve(address spender, uint256 amount) external returns (bool);
151 
152     /**
153      * @dev Moves `amount` tokens from `sender` to `recipient` using the
154      * allowance mechanism. `amount` is then deducted from the caller's
155      * allowance.
156      *
157      * Returns a boolean value indicating whether the operation succeeded.
158      *
159      * Emits a {Transfer} event.
160      */
161     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
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
178 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
179 
180 
181 
182 pragma solidity ^0.8.0;
183 
184 
185 
186 /**
187  * @dev Implementation of the {IERC20} interface.
188  *
189  * This implementation is agnostic to the way tokens are created. This means
190  * that a supply mechanism has to be added in a derived contract using {_mint}.
191  * For a generic mechanism see {ERC20PresetMinterPauser}.
192  *
193  * TIP: For a detailed writeup see our guide
194  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
195  * to implement supply mechanisms].
196  *
197  * We have followed general OpenZeppelin guidelines: functions revert instead
198  * of returning `false` on failure. This behavior is nonetheless conventional
199  * and does not conflict with the expectations of ERC20 applications.
200  *
201  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
202  * This allows applications to reconstruct the allowance for all accounts just
203  * by listening to said events. Other implementations of the EIP may not emit
204  * these events, as it isn't required by the specification.
205  *
206  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
207  * functions have been added to mitigate the well-known issues around setting
208  * allowances. See {IERC20-approve}.
209  */
210 contract ERC20 is Context, IERC20 {
211     mapping (address => uint256) private _balances;
212 
213     mapping (address => mapping (address => uint256)) private _allowances;
214 
215     uint256 private _totalSupply;
216 
217     string private _name;
218     string private _symbol;
219 
220     /**
221      * @dev Sets the values for {name} and {symbol}.
222      *
223      * The defaut value of {decimals} is 18. To select a different value for
224      * {decimals} you should overload it.
225      *
226      * All three of these values are immutable: they can only be set once during
227      * construction.
228      */
229     constructor (string memory name_, string memory symbol_) {
230         _name = name_;
231         _symbol = symbol_;
232     }
233 
234     /**
235      * @dev Returns the name of the token.
236      */
237     function name() public view virtual returns (string memory) {
238         return _name;
239     }
240 
241     /**
242      * @dev Returns the symbol of the token, usually a shorter version of the
243      * name.
244      */
245     function symbol() public view virtual returns (string memory) {
246         return _symbol;
247     }
248 
249     /**
250      * @dev Returns the number of decimals used to get its user representation.
251      * For example, if `decimals` equals `2`, a balance of `505` tokens should
252      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
253      *
254      * Tokens usually opt for a value of 18, imitating the relationship between
255      * Ether and Wei. This is the value {ERC20} uses, unless this function is
256      * overloaded;
257      *
258      * NOTE: This information is only used for _display_ purposes: it in
259      * no way affects any of the arithmetic of the contract, including
260      * {IERC20-balanceOf} and {IERC20-transfer}.
261      */
262     function decimals() public view virtual returns (uint8) {
263         return 18;
264     }
265 
266     /**
267      * @dev See {IERC20-totalSupply}.
268      */
269     function totalSupply() public view virtual override returns (uint256) {
270         return _totalSupply;
271     }
272 
273     /**
274      * @dev See {IERC20-balanceOf}.
275      */
276     function balanceOf(address account) public view virtual override returns (uint256) {
277         return _balances[account];
278     }
279 
280     /**
281      * @dev See {IERC20-transfer}.
282      *
283      * Requirements:
284      *
285      * - `recipient` cannot be the zero address.
286      * - the caller must have a balance of at least `amount`.
287      */
288     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
289         _transfer(_msgSender(), recipient, amount);
290         return true;
291     }
292 
293     /**
294      * @dev See {IERC20-allowance}.
295      */
296     function allowance(address owner, address spender) public view virtual override returns (uint256) {
297         return _allowances[owner][spender];
298     }
299 
300     /**
301      * @dev See {IERC20-approve}.
302      *
303      * Requirements:
304      *
305      * - `spender` cannot be the zero address.
306      */
307     function approve(address spender, uint256 amount) public virtual override returns (bool) {
308         _approve(_msgSender(), spender, amount);
309         return true;
310     }
311 
312     /**
313      * @dev See {IERC20-transferFrom}.
314      *
315      * Emits an {Approval} event indicating the updated allowance. This is not
316      * required by the EIP. See the note at the beginning of {ERC20}.
317      *
318      * Requirements:
319      *
320      * - `sender` and `recipient` cannot be the zero address.
321      * - `sender` must have a balance of at least `amount`.
322      * - the caller must have allowance for ``sender``'s tokens of at least
323      * `amount`.
324      */
325     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
326         _transfer(sender, recipient, amount);
327 
328         uint256 currentAllowance = _allowances[sender][_msgSender()];
329         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
330         _approve(sender, _msgSender(), currentAllowance - amount);
331 
332         return true;
333     }
334 
335     /**
336      * @dev Atomically increases the allowance granted to `spender` by the caller.
337      *
338      * This is an alternative to {approve} that can be used as a mitigation for
339      * problems described in {IERC20-approve}.
340      *
341      * Emits an {Approval} event indicating the updated allowance.
342      *
343      * Requirements:
344      *
345      * - `spender` cannot be the zero address.
346      */
347     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
348         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
349         return true;
350     }
351 
352     /**
353      * @dev Atomically decreases the allowance granted to `spender` by the caller.
354      *
355      * This is an alternative to {approve} that can be used as a mitigation for
356      * problems described in {IERC20-approve}.
357      *
358      * Emits an {Approval} event indicating the updated allowance.
359      *
360      * Requirements:
361      *
362      * - `spender` cannot be the zero address.
363      * - `spender` must have allowance for the caller of at least
364      * `subtractedValue`.
365      */
366     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
367         uint256 currentAllowance = _allowances[_msgSender()][spender];
368         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
369         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
370 
371         return true;
372     }
373 
374     /**
375      * @dev Moves tokens `amount` from `sender` to `recipient`.
376      *
377      * This is internal function is equivalent to {transfer}, and can be used to
378      * e.g. implement automatic token fees, slashing mechanisms, etc.
379      *
380      * Emits a {Transfer} event.
381      *
382      * Requirements:
383      *
384      * - `sender` cannot be the zero address.
385      * - `recipient` cannot be the zero address.
386      * - `sender` must have a balance of at least `amount`.
387      */
388     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
389         require(sender != address(0), "ERC20: transfer from the zero address");
390         require(recipient != address(0), "ERC20: transfer to the zero address");
391 
392         _beforeTokenTransfer(sender, recipient, amount);
393 
394         uint256 senderBalance = _balances[sender];
395         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
396         _balances[sender] = senderBalance - amount;
397         _balances[recipient] += amount;
398 
399         emit Transfer(sender, recipient, amount);
400     }
401 
402     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
403      * the total supply.
404      *
405      * Emits a {Transfer} event with `from` set to the zero address.
406      *
407      * Requirements:
408      *
409      * - `to` cannot be the zero address.
410      */
411     function _mint(address account, uint256 amount) internal virtual {
412         require(account != address(0), "ERC20: mint to the zero address");
413 
414         _beforeTokenTransfer(address(0), account, amount);
415 
416         _totalSupply += amount;
417         _balances[account] += amount;
418         emit Transfer(address(0), account, amount);
419     }
420 
421     /**
422      * @dev Destroys `amount` tokens from `account`, reducing the
423      * total supply.
424      *
425      * Emits a {Transfer} event with `to` set to the zero address.
426      *
427      * Requirements:
428      *
429      * - `account` cannot be the zero address.
430      * - `account` must have at least `amount` tokens.
431      */
432     function _burn(address account, uint256 amount) internal virtual {
433         require(account != address(0), "ERC20: burn from the zero address");
434 
435         _beforeTokenTransfer(account, address(0), amount);
436 
437         uint256 accountBalance = _balances[account];
438         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
439         _balances[account] = accountBalance - amount;
440         _totalSupply -= amount;
441 
442         emit Transfer(account, address(0), amount);
443     }
444 
445     /**
446      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
447      *
448      * This internal function is equivalent to `approve`, and can be used to
449      * e.g. set automatic allowances for certain subsystems, etc.
450      *
451      * Emits an {Approval} event.
452      *
453      * Requirements:
454      *
455      * - `owner` cannot be the zero address.
456      * - `spender` cannot be the zero address.
457      */
458     function _approve(address owner, address spender, uint256 amount) internal virtual {
459         require(owner != address(0), "ERC20: approve from the zero address");
460         require(spender != address(0), "ERC20: approve to the zero address");
461 
462         _allowances[owner][spender] = amount;
463         emit Approval(owner, spender, amount);
464     }
465 
466     /**
467      * @dev Hook that is called before any transfer of tokens. This includes
468      * minting and burning.
469      *
470      * Calling conditions:
471      *
472      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
473      * will be to transferred to `to`.
474      * - when `from` is zero, `amount` tokens will be minted for `to`.
475      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
476      * - `from` and `to` are never both zero.
477      *
478      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
479      */
480     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
481 }
482 
483 // File: contracts/token/HotCross.sol
484 
485 
486 pragma solidity 0.8.3;
487 
488 
489 
490 contract HotCrossToken is Ownable, ERC20 {
491   uint256 constant MILLION = 1_000_000 * 10**uint256(18);
492 
493   constructor() ERC20('Hot Cross Token', 'HOTCROSS') {
494     _mint(msg.sender, 500 * MILLION);
495   }
496 
497 
498   /**
499    * Allows the owner of the contract to release tokens that were erronously sent to this  
500    * ERC20 smart contract. This covers any mistakes from the end-user side
501    * @param token the token that we want to withdraw
502    * @param recipient the address that will receive the tokens
503    * @param amount the amount of tokens
504    */
505   function tokenRescue(
506     IERC20 token,
507     address recipient,
508     uint256 amount
509   ) onlyOwner external {
510     token.transfer(recipient, amount);
511   }
512 }