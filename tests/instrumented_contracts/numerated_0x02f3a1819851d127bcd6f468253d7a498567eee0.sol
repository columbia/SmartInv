1 // SPDX-License-Identifier: MIT 
2 pragma solidity 0.8.0;
3 
4 /*
5  * @dev Provides information about the current execution context, including the
6  * sender of the transaction and its data. While these are generally available
7  * via msg.sender and msg.data, they should not be accessed in such a direct
8  * manner, since when dealing with GSN meta-transactions the account sending and
9  * paying for execution may not be the actual sender (as far as an application
10  * is concerned).
11  *
12  * This contract is only required for intermediate, library-like contracts.
13  */
14 abstract contract Context {
15     function _msgSender() internal view virtual returns (address) {
16         return msg.sender;
17     }
18 
19     function _msgData() internal view virtual returns (bytes calldata) {
20         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
21         return msg.data;
22     }
23 }
24 
25 /**
26  * @dev Interface of the ERC20 standard as defined in the EIP.
27  */
28 interface IERC20 {
29     /**
30      * @dev Returns the amount of tokens in existence.
31      */
32     function totalSupply() external view returns (uint256);
33 
34     /**
35      * @dev Returns the amount of tokens owned by `account`.
36      */
37     function balanceOf(address account) external view returns (uint256);
38 
39     /**
40      * @dev Moves `amount` tokens from the caller's account to `recipient`.
41      *
42      * Returns a boolean value indicating whether the operation succeeded.
43      *
44      * Emits a {Transfer} event.
45      */
46     function transfer(address recipient, uint256 amount) external returns (bool);
47 
48     /**
49      * @dev Returns the remaining number of tokens that `spender` will be
50      * allowed to spend on behalf of `owner` through {transferFrom}. This is
51      * zero by default.
52      *
53      * This value changes when {approve} or {transferFrom} are called.
54      */
55     function allowance(address owner, address spender) external view returns (uint256);
56 
57     /**
58      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
59      *
60      * Returns a boolean value indicating whether the operation succeeded.
61      *
62      * IMPORTANT: Beware that changing an allowance with this method brings the risk
63      * that someone may use both the old and the new allowance by unfortunate
64      * transaction ordering. One possible solution to mitigate this race
65      * condition is to first reduce the spender's allowance to 0 and set the
66      * desired value afterwards:
67      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
68      *
69      * Emits an {Approval} event.
70      */
71     function approve(address spender, uint256 amount) external returns (bool);
72 
73     /**
74      * @dev Moves `amount` tokens from `sender` to `recipient` using the
75      * allowance mechanism. `amount` is then deducted from the caller's
76      * allowance.
77      *
78      * Returns a boolean value indicating whether the operation succeeded.
79      *
80      * Emits a {Transfer} event.
81      */
82     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
83 
84     /**
85      * @dev Emitted when `value` tokens are moved from one account (`from`) to
86      * another (`to`).
87      *
88      * Note that `value` may be zero.
89      */
90     event Transfer(address indexed from, address indexed to, uint256 value);
91 
92     /**
93      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
94      * a call to {approve}. `value` is the new allowance.
95      */
96     event Approval(address indexed owner, address indexed spender, uint256 value);
97 }
98 
99 /**
100  * @dev Contract module which provides a basic access control mechanism, where
101  * there is an account (an owner) that can be granted exclusive access to
102  * specific functions.
103  *
104  * By default, the owner account will be the one that deploys the contract. This
105  * can later be changed with {transferOwnership}.
106  *
107  * This module is used through inheritance. It will make available the modifier
108  * `onlyOwner`, which can be applied to your functions to restrict their use to
109  * the owner.
110  */
111 abstract contract Ownable is Context {
112     address private _owner;
113 
114     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
115 
116     /**
117      * @dev Initializes the contract setting the deployer as the initial owner.
118      */
119     constructor () {
120         address msgSender = _msgSender();
121         _owner = msgSender;
122         emit OwnershipTransferred(address(0), msgSender);
123     }
124 
125     /**
126      * @dev Returns the address of the current owner.
127      */
128     function owner() public view virtual returns (address) {
129         return _owner;
130     }
131 
132     /**
133      * @dev Throws if called by any account other than the owner.
134      */
135     modifier onlyOwner() {
136         require(owner() == _msgSender(), "Ownable: caller is not the owner");
137         _;
138     }
139 
140     /**
141      * @dev Leaves the contract without owner. It will not be possible to call
142      * `onlyOwner` functions anymore. Can only be called by the current owner.
143      *
144      * NOTE: Renouncing ownership will leave the contract without an owner,
145      * thereby removing any functionality that is only available to the owner.
146      */
147     function renounceOwnership() public virtual onlyOwner {
148         emit OwnershipTransferred(_owner, address(0));
149         _owner = address(0);
150     }
151 
152     /**
153      * @dev Transfers ownership of the contract to a new account (`newOwner`).
154      * Can only be called by the current owner.
155      */
156     function transferOwnership(address newOwner) public virtual onlyOwner {
157         require(newOwner != address(0), "Ownable: new owner is the zero address");
158         emit OwnershipTransferred(_owner, newOwner);
159         _owner = newOwner;
160     }
161 }
162 
163 /**
164  * @dev Implementation of the {IERC20} interface.
165  *
166  * This implementation is agnostic to the way tokens are created. This means
167  * that a supply mechanism has to be added in a derived contract using {_mint}.
168  * For a generic mechanism see {ERC20PresetMinterPauser}.
169  *
170  * TIP: For a detailed writeup see our guide
171  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
172  * to implement supply mechanisms].
173  *
174  * We have followed general OpenZeppelin guidelines: functions revert instead
175  * of returning `false` on failure. This behavior is nonetheless conventional
176  * and does not conflict with the expectations of ERC20 applications.
177  *
178  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
179  * This allows applications to reconstruct the allowance for all accounts just
180  * by listening to said events. Other implementations of the EIP may not emit
181  * these events, as it isn't required by the specification.
182  *
183  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
184  * functions have been added to mitigate the well-known issues around setting
185  * allowances. See {IERC20-approve}.
186  */
187 contract GasifyToken is Ownable, IERC20 {
188     mapping (address => uint256) private _balances;
189 
190     mapping (address => mapping (address => uint256)) private _allowances;
191 
192     uint256 private _totalSupply;
193 
194     string private _name;
195     string private _symbol;
196     address public rewardsWallet;
197     
198     event Unlocked(address owner, uint256 amount);
199 
200     /**
201      * @dev Sets the values for {name} and {symbol}.
202      *
203      * The defaut value of {decimals} is 18. To select a different value for
204      * {decimals} you should overload it.
205      *
206      * All three of these values are immutable: they can only be set once during
207      * construction.
208      */
209     constructor (string memory name_, string memory symbol_, address _rewardsWallet) {
210         _name = name_;
211         _symbol = symbol_;
212         rewardsWallet = _rewardsWallet;
213         
214         uint256 _amount = 10000000 ether;
215         uint256 _circulatingSupply = 5000000 ether;
216         _mint(address(this), _amount);
217         _balances[address(this)] -= _circulatingSupply;
218         _balances[_msgSender()] += _circulatingSupply;
219     }
220 
221     /**
222      * @dev Returns the name of the token.
223      */
224     function name() public view virtual returns (string memory) {
225         return _name;
226     }
227 
228     /**
229      * @dev Returns the symbol of the token, usually a shorter version of the
230      * name.
231      */
232     function symbol() public view virtual returns (string memory) {
233         return _symbol;
234     }
235 
236     /**
237      * @dev Returns the number of decimals used to get its user representation.
238      * For example, if `decimals` equals `2`, a balance of `505` tokens should
239      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
240      *
241      * Tokens usually opt for a value of 18, imitating the relationship between
242      * Ether and Wei. This is the value {ERC20} uses, unless this function is
243      * overloaded;
244      *
245      * NOTE: This information is only used for _display_ purposes: it in
246      * no way affects any of the arithmetic of the contract, including
247      * {IERC20-balanceOf} and {IERC20-transfer}.
248      */
249     function decimals() public view virtual returns (uint8) {
250         return 18;
251     }
252 
253     /**
254      * @dev See {IERC20-totalSupply}.
255      */
256     function totalSupply() public view virtual override returns (uint256) {
257         return _totalSupply;
258     }
259 
260     /**
261      * @dev See {IERC20-balanceOf}.
262      */
263     function balanceOf(address account) public view virtual override returns (uint256) {
264         return _balances[account];
265     }
266 
267     /**
268      * @dev See {IERC20-transfer}.
269      *
270      * Requirements:
271      *
272      * - `recipient` cannot be the zero address.
273      * - the caller must have a balance of at least `amount`.
274      */
275     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
276         _transfer(_msgSender(), recipient, amount);
277         return true;
278     }
279 
280     /**
281      * @dev See {IERC20-allowance}.
282      */
283     function allowance(address owner, address spender) public view virtual override returns (uint256) {
284         return _allowances[owner][spender];
285     }
286 
287     /**
288      * @dev See {IERC20-approve}.
289      *
290      * Requirements:
291      *
292      * - `spender` cannot be the zero address.
293      */
294     function approve(address spender, uint256 amount) public virtual override returns (bool) {
295         _approve(_msgSender(), spender, amount);
296         return true;
297     }
298 
299     /**
300      * @dev See {IERC20-transferFrom}.
301      *
302      * Emits an {Approval} event indicating the updated allowance. This is not
303      * required by the EIP. See the note at the beginning of {ERC20}.
304      *
305      * Requirements:
306      *
307      * - `sender` and `recipient` cannot be the zero address.
308      * - `sender` must have a balance of at least `amount`.
309      * - the caller must have allowance for ``sender``'s tokens of at least
310      * `amount`.
311      */
312     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
313         _transfer(sender, recipient, amount);
314 
315         require(_allowances[sender][_msgSender()] >= amount, "ERC20: transfer amount exceeds allowance");
316         _approve(sender, _msgSender(), _allowances[sender][_msgSender()] - amount);
317 
318         return true;
319     }
320 
321     /**
322      * @dev Atomically increases the allowance granted to `spender` by the caller.
323      *
324      * This is an alternative to {approve} that can be used as a mitigation for
325      * problems described in {IERC20-approve}.
326      *
327      * Emits an {Approval} event indicating the updated allowance.
328      *
329      * Requirements:
330      *
331      * - `spender` cannot be the zero address.
332      */
333     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
334         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
335         return true;
336     }
337 
338     /**
339      * @dev Atomically decreases the allowance granted to `spender` by the caller.
340      *
341      * This is an alternative to {approve} that can be used as a mitigation for
342      * problems described in {IERC20-approve}.
343      *
344      * Emits an {Approval} event indicating the updated allowance.
345      *
346      * Requirements:
347      *
348      * - `spender` cannot be the zero address.
349      * - `spender` must have allowance for the caller of at least
350      * `subtractedValue`.
351      */
352     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
353         require(_allowances[_msgSender()][spender] >= subtractedValue, "ERC20: decreased allowance below zero");
354         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] - subtractedValue);
355 
356         return true;
357     }
358 
359     /**
360      * @dev Moves tokens `amount` from `sender` to `recipient`.
361      *
362      * This is internal function is equivalent to {transfer}, and can be used to
363      * e.g. implement automatic token fees, slashing mechanisms, etc.
364      *
365      * Emits a {Transfer} event.
366      *
367      * Requirements:
368      *
369      * - `sender` cannot be the zero address.
370      * - `recipient` cannot be the zero address.
371      * - `sender` must have a balance of at least `amount`.
372      */
373     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
374         require(sender != address(0), "ERC20: transfer from the zero address");
375         require(recipient != address(0), "ERC20: transfer to the zero address");
376 
377         (uint256 _finalAmount, uint256 _tax) =_beforeTokenTransfer(sender, recipient, amount);
378 
379         require(_balances[sender] >= amount, "ERC20: transfer amount exceeds balance");
380         _balances[sender] -= amount;
381         _balances[recipient] += _finalAmount;
382         _balances[rewardsWallet] += _tax;
383 
384         emit Transfer(sender, recipient, amount);
385     }
386 
387     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
388      * the total supply.
389      *
390      * Emits a {Transfer} event with `from` set to the zero address.
391      *
392      * Requirements:
393      *
394      * - `to` cannot be the zero address.
395      */
396     function _mint(address account, uint256 amount) internal virtual {
397         require(account != address(0), "ERC20: mint to the zero address");
398 
399         _beforeTokenTransfer(address(0), account, amount);
400 
401         _totalSupply += amount;
402         _balances[account] += amount;
403         emit Transfer(address(0), account, amount);
404     }
405 
406     /**
407      * @dev Destroys `amount` tokens from `account`, reducing the
408      * total supply.
409      *
410      * Emits a {Transfer} event with `to` set to the zero address.
411      *
412      * Requirements:
413      *
414      * - `account` cannot be the zero address.
415      * - `account` must have at least `amount` tokens.
416      */
417     function _burn(address account, uint256 amount) internal virtual {
418         require(account != address(0), "ERC20: burn from the zero address");
419 
420         _beforeTokenTransfer(account, address(0), amount);
421 
422         require(_balances[account] >= amount, "ERC20: burn amount exceeds balance");
423         _balances[account] -= amount;
424         _totalSupply -= amount;
425 
426         emit Transfer(account, address(0), amount);
427     }
428 
429     /**
430      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
431      *
432      * This internal function is equivalent to `approve`, and can be used to
433      * e.g. set automatic allowances for certain subsystems, etc.
434      *
435      * Emits an {Approval} event.
436      *
437      * Requirements:
438      *
439      * - `owner` cannot be the zero address.
440      * - `spender` cannot be the zero address.
441      */
442     function _approve(address owner, address spender, uint256 amount) internal virtual {
443         require(owner != address(0), "ERC20: approve from the zero address");
444         require(spender != address(0), "ERC20: approve to the zero address");
445 
446         _allowances[owner][spender] = amount;
447         emit Approval(owner, spender, amount);
448     }
449     
450     
451     function unlockRemainingToken() public onlyOwner {
452         uint256 _lockedBalance = _balances[address(this)];
453         require(_lockedBalance > 0, "GasifyToken: Token have already been unlocked");
454         
455         _balances[address(this)] = 0;
456         _balances[_msgSender()] += _lockedBalance;
457         emit Unlocked(_msgSender(), _lockedBalance);
458     }
459 
460     /**
461      * @dev Hook that is called before any transfer of tokens. This includes
462      * minting and burning.
463      *
464      * Calling conditions:
465      *
466      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
467      * will be to transferred to `to`.
468      * - when `from` is zero, `amount` tokens will be minted for `to`.
469      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
470      * - `from` and `to` are never both zero.
471      *
472      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
473      */
474     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual returns(uint256, uint256) {
475         uint256 _tax = (amount * 4) / 100;
476         uint256 _availableBalance = amount - _tax;
477         return (_availableBalance, _tax);
478     }
479 }