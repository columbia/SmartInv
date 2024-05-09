1 /*
2 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣠⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
3 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣸⣝⣧⣀⣠⡶⢿⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
4 ⠀⠀⢀⣀⣠⠤⠤⠖⠚⠛⠉⢙⠁⠈⢈⠟⢽⢿⣄⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
5 ⠀⣴⠋⣍⣠⡄⠀⠀⠀⠶⠶⣿⡷⡆⠘⠀⠈⠀⠉⠻⢦⣀⠀⠀⠀⠀⠀⠀⠀⣀⣀⣀⣀⣤⣤⠦⠦⠦⠤⠤⢤⣤⣤⣀⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
6 ⢰⠇⠀⢸⠋⠀⠀⠀⠀⠀⠀⠈⠁⠀⠀⠀⠀⠀⠀⠀⠀⠙⠓⠲⠤⠴⠖⠒⠛⠉⠉⢉⡀⠀⠀⠙⢧⡤⡄⠀⢲⡖⠀⠈⠉⠛⠲⢦⣀⠀⠀⠀⠀⠀⠀
7 ⢸⠀⠀⢸⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⠉⠡⠤⠀⠀⠰⠾⠧⠀⠀⠿⠦⠉⠉⠀⠶⢭⡉⠃⠀⣉⠳⣤⡀⠀⠀⠀
8 ⠸⣆⢠⡾⢦⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⡘⠇⢠⣄⠀⠦⣌⠛⠂⠻⣆⠀⠀
9 ⠀⠹⣦⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣇⠀⢠⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠉⠁⠀⠈⣹⠀⠀⡀⠐⣄⠙⣧⡀
10 ⠀⠀⠀⠉⠙⠒⠒⠒⠒⠒⠶⣦⣀⡽⠆⠀⢳⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⢲⠀⠙⠦⠈⠀⢹⡇
11 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠻⣞⢧⠐⢷⠀⢰⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢦⡀⠈⢳⠀⣿
12 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⢯⢇⡀⠃⠈⢳⠀⢳⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠃⠀⡈⠀⣻
13 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⢳⡝⠶⢦⡀⣆⠀⠛⠀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠠⠇⢀⡟
14 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⢦⡠⣄⠙⠀⠸⠄⢻⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⡤⠀⠀⠀⠀⠀⠀⠀⠀⣠⠆⠀⡼⠃
15 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⢳⣌⠠⣄⠰⡆⢸⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⠏⣾⡽⡀⠀⠀⠀⠀⢠⡴⠊⠉⢠⡾⠁⠀
16 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣄⡈⡀⠀⣾⣥⣤⣀⣀⠀⠀⠀⠀⠀⠀⠀⠀⢀⡏⣠⠈⢡⡇⠀⠀⡀⠀⠘⠞⣠⡴⠋⠀⠀⠀
17 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠨⣧⠃⠑⠀⣷⡏⠉⠈⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⢳⠿⢢⡈⣇⠀⢸⣿⣧⣦⠾⣿⠉⠀⠀⠀⠀
18 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⠦⠰⢾⢻⡇⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⢧⠈⠣⠸⠄⣴⢿⠋⠁⠀⠻⣦⠀⠀⠀⠀
19 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣸⡀⡆⠸⢸⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⢳⡆⢀⣀⡈⢫⣷⠀⢀⣴⠟⠀⠀⠀⠀
20 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣠⡤⠞⠉⠃⢠⣧⡾⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣾⣧⠎⠉⡽⢋⠏⠀⣼⠏⠀⠀⠀⠀⠀
21 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣽⡿⣭⣿⣏⡴⠞⠋⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣠⡴⣶⡞⠋⢩⣏⣴⠯⠴⠋⠀⣰⠋⠀⠀⠀⠀⠀⠀
22 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⠻⠿⠿⣺⡧⠶⠚⠉⠙⠓⠒⠒⠚⠁⠀⠀⠀⠀⠀⠀⠀
23 */
24 
25 // SPDX-License-Identifier: MIT
26 
27 // File: @openzeppelin/contracts/utils/Context.sol
28 
29 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
30 
31 pragma solidity ^0.8.0;
32 
33 /**
34  * @dev Provides information about the current execution context, including the
35  * sender of the transaction and its data. While these are generally available
36  * via msg.sender and msg.data, they should not be accessed in such a direct
37  * manner, since when dealing with meta-transactions the account sending and
38  * paying for execution may not be the actual sender (as far as an application
39  * is concerned).
40  *
41  * This contract is only required for intermediate, library-like contracts.
42  */
43 abstract contract Context {
44     function _msgSender() internal view virtual returns (address) {
45         return msg.sender;
46     }
47 
48     function _msgData() internal view virtual returns (bytes calldata) {
49         return msg.data;
50     }
51 }
52 
53 // File: @openzeppelin/contracts/access/Ownable.sol
54 
55 
56 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
57 
58 pragma solidity ^0.8.0;
59 
60 
61 /**
62  * @dev Contract module which provides a basic access control mechanism, where
63  * there is an account (an owner) that can be granted exclusive access to
64  * specific functions.
65  *
66  * By default, the owner account will be the one that deploys the contract. This
67  * can later be changed with {transferOwnership}.
68  *
69  * This module is used through inheritance. It will make available the modifier
70  * `onlyOwner`, which can be applied to your functions to restrict their use to
71  * the owner.
72  */
73 abstract contract Ownable is Context {
74     address private _owner;
75 
76     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
77 
78     /**
79      * @dev Initializes the contract setting the deployer as the initial owner.
80      */
81     constructor() {
82         _transferOwnership(_msgSender());
83     }
84 
85     /**
86      * @dev Throws if called by any account other than the owner.
87      */
88     modifier onlyOwner() {
89         _checkOwner();
90         _;
91     }
92 
93     /**
94      * @dev Returns the address of the current owner.
95      */
96     function owner() public view virtual returns (address) {
97         return _owner;
98     }
99 
100     /**
101      * @dev Throws if the sender is not the owner.
102      */
103     function _checkOwner() internal view virtual {
104         require(owner() == _msgSender(), "Ownable: caller is not the owner");
105     }
106 
107     /**
108      * @dev Leaves the contract without owner. It will not be possible to call
109      * `onlyOwner` functions anymore. Can only be called by the current owner.
110      *
111      * NOTE: Renouncing ownership will leave the contract without an owner,
112      * thereby removing any functionality that is only available to the owner.
113      */
114     function renounceOwnership() public virtual onlyOwner {
115         _transferOwnership(address(0));
116     }
117 
118     /**
119      * @dev Transfers ownership of the contract to a new account (`newOwner`).
120      * Can only be called by the current owner.
121      */
122     function transferOwnership(address newOwner) public virtual onlyOwner {
123         require(newOwner != address(0), "Ownable: new owner is the zero address");
124         _transferOwnership(newOwner);
125     }
126 
127     /**
128      * @dev Transfers ownership of the contract to a new account (`newOwner`).
129      * Internal function without access restriction.
130      */
131     function _transferOwnership(address newOwner) internal virtual {
132         address oldOwner = _owner;
133         _owner = newOwner;
134         emit OwnershipTransferred(oldOwner, newOwner);
135     }
136 }
137 
138 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
139 
140 
141 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
142 
143 pragma solidity ^0.8.0;
144 
145 /**
146  * @dev Interface of the ERC20 standard as defined in the EIP.
147  */
148 interface IERC20 {
149     /**
150      * @dev Emitted when `value` tokens are moved from one account (`from`) to
151      * another (`to`).
152      *
153      * Note that `value` may be zero.
154      */
155     event Transfer(address indexed from, address indexed to, uint256 value);
156 
157     /**
158      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
159      * a call to {approve}. `value` is the new allowance.
160      */
161     event Approval(address indexed owner, address indexed spender, uint256 value);
162 
163     /**
164      * @dev Returns the amount of tokens in existence.
165      */
166     function totalSupply() external view returns (uint256);
167 
168     /**
169      * @dev Returns the amount of tokens owned by `account`.
170      */
171     function balanceOf(address account) external view returns (uint256);
172 
173     /**
174      * @dev Moves `amount` tokens from the caller's account to `to`.
175      *
176      * Returns a boolean value indicating whether the operation succeeded.
177      *
178      * Emits a {Transfer} event.
179      */
180     function transfer(address to, uint256 amount) external returns (bool);
181 
182     /**
183      * @dev Returns the remaining number of tokens that `spender` will be
184      * allowed to spend on behalf of `owner` through {transferFrom}. This is
185      * zero by default.
186      *
187      * This value changes when {approve} or {transferFrom} are called.
188      */
189     function allowance(address owner, address spender) external view returns (uint256);
190 
191     /**
192      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
193      *
194      * Returns a boolean value indicating whether the operation succeeded.
195      *
196      * IMPORTANT: Beware that changing an allowance with this method brings the risk
197      * that someone may use both the old and the new allowance by unfortunate
198      * transaction ordering. One possible solution to mitigate this race
199      * condition is to first reduce the spender's allowance to 0 and set the
200      * desired value afterwards:
201      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
202      *
203      * Emits an {Approval} event.
204      */
205     function approve(address spender, uint256 amount) external returns (bool);
206 
207     /**
208      * @dev Moves `amount` tokens from `from` to `to` using the
209      * allowance mechanism. `amount` is then deducted from the caller's
210      * allowance.
211      *
212      * Returns a boolean value indicating whether the operation succeeded.
213      *
214      * Emits a {Transfer} event.
215      */
216     function transferFrom(
217         address from,
218         address to,
219         uint256 amount
220     ) external returns (bool);
221 }
222 
223 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
224 
225 
226 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
227 
228 pragma solidity ^0.8.0;
229 
230 
231 /**
232  * @dev Interface for the optional metadata functions from the ERC20 standard.
233  *
234  * _Available since v4.1._
235  */
236 interface IERC20Metadata is IERC20 {
237     /**
238      * @dev Returns the name of the token.
239      */
240     function name() external view returns (string memory);
241 
242     /**
243      * @dev Returns the symbol of the token.
244      */
245     function symbol() external view returns (string memory);
246 
247     /**
248      * @dev Returns the decimals places of the token.
249      */
250     function decimals() external view returns (uint8);
251 }
252 
253 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
254 
255 
256 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC20/ERC20.sol)
257 
258 pragma solidity ^0.8.0;
259 
260 
261 
262 
263 /**
264  * @dev Implementation of the {IERC20} interface.
265  *
266  * This implementation is agnostic to the way tokens are created. This means
267  * that a supply mechanism has to be added in a derived contract using {_mint}.
268  * For a generic mechanism see {ERC20PresetMinterPauser}.
269  *
270  * TIP: For a detailed writeup see our guide
271  * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
272  * to implement supply mechanisms].
273  *
274  * We have followed general OpenZeppelin Contracts guidelines: functions revert
275  * instead returning `false` on failure. This behavior is nonetheless
276  * conventional and does not conflict with the expectations of ERC20
277  * applications.
278  *
279  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
280  * This allows applications to reconstruct the allowance for all accounts just
281  * by listening to said events. Other implementations of the EIP may not emit
282  * these events, as it isn't required by the specification.
283  *
284  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
285  * functions have been added to mitigate the well-known issues around setting
286  * allowances. See {IERC20-approve}.
287  */
288 contract ERC20 is Context, IERC20, IERC20Metadata {
289     mapping(address => uint256) private _balances;
290 
291     mapping(address => mapping(address => uint256)) private _allowances;
292 
293     uint256 private _totalSupply;
294 
295     string private _name;
296     string private _symbol;
297 
298     /**
299      * @dev Sets the values for {name} and {symbol}.
300      *
301      * The default value of {decimals} is 18. To select a different value for
302      * {decimals} you should overload it.
303      *
304      * All two of these values are immutable: they can only be set once during
305      * construction.
306      */
307     constructor(string memory name_, string memory symbol_) {
308         _name = name_;
309         _symbol = symbol_;
310     }
311 
312     /**
313      * @dev Returns the name of the token.
314      */
315     function name() public view virtual override returns (string memory) {
316         return _name;
317     }
318 
319     /**
320      * @dev Returns the symbol of the token, usually a shorter version of the
321      * name.
322      */
323     function symbol() public view virtual override returns (string memory) {
324         return _symbol;
325     }
326 
327     /**
328      * @dev Returns the number of decimals used to get its user representation.
329      * For example, if `decimals` equals `2`, a balance of `505` tokens should
330      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
331      *
332      * Tokens usually opt for a value of 18, imitating the relationship between
333      * Ether and Wei. This is the value {ERC20} uses, unless this function is
334      * overridden;
335      *
336      * NOTE: This information is only used for _display_ purposes: it in
337      * no way affects any of the arithmetic of the contract, including
338      * {IERC20-balanceOf} and {IERC20-transfer}.
339      */
340     function decimals() public view virtual override returns (uint8) {
341         return 18;
342     }
343 
344     /**
345      * @dev See {IERC20-totalSupply}.
346      */
347     function totalSupply() public view virtual override returns (uint256) {
348         return _totalSupply;
349     }
350 
351     /**
352      * @dev See {IERC20-balanceOf}.
353      */
354     function balanceOf(address account) public view virtual override returns (uint256) {
355         return _balances[account];
356     }
357 
358     /**
359      * @dev See {IERC20-transfer}.
360      *
361      * Requirements:
362      *
363      * - `to` cannot be the zero address.
364      * - the caller must have a balance of at least `amount`.
365      */
366     function transfer(address to, uint256 amount) public virtual override returns (bool) {
367         address owner = _msgSender();
368         _transfer(owner, to, amount);
369         return true;
370     }
371 
372     /**
373      * @dev See {IERC20-allowance}.
374      */
375     function allowance(address owner, address spender) public view virtual override returns (uint256) {
376         return _allowances[owner][spender];
377     }
378 
379     /**
380      * @dev See {IERC20-approve}.
381      *
382      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
383      * `transferFrom`. This is semantically equivalent to an infinite approval.
384      *
385      * Requirements:
386      *
387      * - `spender` cannot be the zero address.
388      */
389     function approve(address spender, uint256 amount) public virtual override returns (bool) {
390         address owner = _msgSender();
391         _approve(owner, spender, amount);
392         return true;
393     }
394 
395     /**
396      * @dev See {IERC20-transferFrom}.
397      *
398      * Emits an {Approval} event indicating the updated allowance. This is not
399      * required by the EIP. See the note at the beginning of {ERC20}.
400      *
401      * NOTE: Does not update the allowance if the current allowance
402      * is the maximum `uint256`.
403      *
404      * Requirements:
405      *
406      * - `from` and `to` cannot be the zero address.
407      * - `from` must have a balance of at least `amount`.
408      * - the caller must have allowance for ``from``'s tokens of at least
409      * `amount`.
410      */
411     function transferFrom(
412         address from,
413         address to,
414         uint256 amount
415     ) public virtual override returns (bool) {
416         address spender = _msgSender();
417         _spendAllowance(from, spender, amount);
418         _transfer(from, to, amount);
419         return true;
420     }
421 
422     /**
423      * @dev Atomically increases the allowance granted to `spender` by the caller.
424      *
425      * This is an alternative to {approve} that can be used as a mitigation for
426      * problems described in {IERC20-approve}.
427      *
428      * Emits an {Approval} event indicating the updated allowance.
429      *
430      * Requirements:
431      *
432      * - `spender` cannot be the zero address.
433      */
434     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
435         address owner = _msgSender();
436         _approve(owner, spender, allowance(owner, spender) + addedValue);
437         return true;
438     }
439 
440     /**
441      * @dev Atomically decreases the allowance granted to `spender` by the caller.
442      *
443      * This is an alternative to {approve} that can be used as a mitigation for
444      * problems described in {IERC20-approve}.
445      *
446      * Emits an {Approval} event indicating the updated allowance.
447      *
448      * Requirements:
449      *
450      * - `spender` cannot be the zero address.
451      * - `spender` must have allowance for the caller of at least
452      * `subtractedValue`.
453      */
454     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
455         address owner = _msgSender();
456         uint256 currentAllowance = allowance(owner, spender);
457         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
458         unchecked {
459             _approve(owner, spender, currentAllowance - subtractedValue);
460         }
461 
462         return true;
463     }
464 
465     /**
466      * @dev Moves `amount` of tokens from `from` to `to`.
467      *
468      * This internal function is equivalent to {transfer}, and can be used to
469      * e.g. implement automatic token fees, slashing mechanisms, etc.
470      *
471      * Emits a {Transfer} event.
472      *
473      * Requirements:
474      *
475      * - `from` cannot be the zero address.
476      * - `to` cannot be the zero address.
477      * - `from` must have a balance of at least `amount`.
478      */
479     function _transfer(
480         address from,
481         address to,
482         uint256 amount
483     ) internal virtual {
484         require(from != address(0), "ERC20: transfer from the zero address");
485         require(to != address(0), "ERC20: transfer to the zero address");
486 
487         _beforeTokenTransfer(from, to, amount);
488 
489         uint256 fromBalance = _balances[from];
490         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
491         unchecked {
492             _balances[from] = fromBalance - amount;
493             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
494             // decrementing then incrementing.
495             _balances[to] += amount;
496         }
497 
498         emit Transfer(from, to, amount);
499 
500         _afterTokenTransfer(from, to, amount);
501     }
502 
503     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
504      * the total supply.
505      *
506      * Emits a {Transfer} event with `from` set to the zero address.
507      *
508      * Requirements:
509      *
510      * - `account` cannot be the zero address.
511      */
512     function _mint(address account, uint256 amount) internal virtual {
513         require(account != address(0), "ERC20: mint to the zero address");
514 
515         _beforeTokenTransfer(address(0), account, amount);
516 
517         _totalSupply += amount;
518         unchecked {
519             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
520             _balances[account] += amount;
521         }
522         emit Transfer(address(0), account, amount);
523 
524         _afterTokenTransfer(address(0), account, amount);
525     }
526 
527     /**
528      * @dev Destroys `amount` tokens from `account`, reducing the
529      * total supply.
530      *
531      * Emits a {Transfer} event with `to` set to the zero address.
532      *
533      * Requirements:
534      *
535      * - `account` cannot be the zero address.
536      * - `account` must have at least `amount` tokens.
537      */
538     function _burn(address account, uint256 amount) internal virtual {
539         require(account != address(0), "ERC20: burn from the zero address");
540 
541         _beforeTokenTransfer(account, address(0), amount);
542 
543         uint256 accountBalance = _balances[account];
544         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
545         unchecked {
546             _balances[account] = accountBalance - amount;
547             // Overflow not possible: amount <= accountBalance <= totalSupply.
548             _totalSupply -= amount;
549         }
550 
551         emit Transfer(account, address(0), amount);
552 
553         _afterTokenTransfer(account, address(0), amount);
554     }
555 
556     /**
557      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
558      *
559      * This internal function is equivalent to `approve`, and can be used to
560      * e.g. set automatic allowances for certain subsystems, etc.
561      *
562      * Emits an {Approval} event.
563      *
564      * Requirements:
565      *
566      * - `owner` cannot be the zero address.
567      * - `spender` cannot be the zero address.
568      */
569     function _approve(
570         address owner,
571         address spender,
572         uint256 amount
573     ) internal virtual {
574         require(owner != address(0), "ERC20: approve from the zero address");
575         require(spender != address(0), "ERC20: approve to the zero address");
576 
577         _allowances[owner][spender] = amount;
578         emit Approval(owner, spender, amount);
579     }
580 
581     /**
582      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
583      *
584      * Does not update the allowance amount in case of infinite allowance.
585      * Revert if not enough allowance is available.
586      *
587      * Might emit an {Approval} event.
588      */
589     function _spendAllowance(
590         address owner,
591         address spender,
592         uint256 amount
593     ) internal virtual {
594         uint256 currentAllowance = allowance(owner, spender);
595         if (currentAllowance != type(uint256).max) {
596             require(currentAllowance >= amount, "ERC20: insufficient allowance");
597             unchecked {
598                 _approve(owner, spender, currentAllowance - amount);
599             }
600         }
601     }
602 
603     /**
604      * @dev Hook that is called before any transfer of tokens. This includes
605      * minting and burning.
606      *
607      * Calling conditions:
608      *
609      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
610      * will be transferred to `to`.
611      * - when `from` is zero, `amount` tokens will be minted for `to`.
612      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
613      * - `from` and `to` are never both zero.
614      *
615      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
616      */
617     function _beforeTokenTransfer(
618         address from,
619         address to,
620         uint256 amount
621     ) internal virtual {}
622 
623     /**
624      * @dev Hook that is called after any transfer of tokens. This includes
625      * minting and burning.
626      *
627      * Calling conditions:
628      *
629      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
630      * has been transferred to `to`.
631      * - when `from` is zero, `amount` tokens have been minted for `to`.
632      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
633      * - `from` and `to` are never both zero.
634      *
635      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
636      */
637     function _afterTokenTransfer(
638         address from,
639         address to,
640         uint256 amount
641     ) internal virtual {}
642 }
643 
644 // File: capybara.sol
645 
646 pragma solidity ^0.8.4;
647 
648 contract Capybara is ERC20, Ownable {
649 	
650     uint _totalSupply = 100_000_000*10**18;
651 	
652     bool public PAUSED;
653 
654     constructor() ERC20("Capybara", "BARA") {
655 		_mint(msg.sender, _totalSupply);
656 	}
657 	
658 	function burn(uint256 value) external {
659         _burn(_msgSender(), value);
660     }
661 
662     function togglePause() external onlyOwner {
663         PAUSED = !PAUSED;
664     }
665 
666     function _beforeTokenTransfer(
667         address from,
668         address to,
669         uint256 amount
670     ) internal virtual override {
671 		super._beforeTokenTransfer(from, to, amount); // Call parent hook
672         require(!PAUSED, "Contract paused");
673     }
674 
675 }