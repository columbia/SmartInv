1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.0;
3 
4 // ⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⡤⠤⠤⠤⣄⣀⣀⠤⠤⠴⠤⢄⡀⠀⠀⠀⠀⠀⠀
5 // ⠀⠀⠀⠀⠀⠀⠀⣴⠏⠁⠀⠀⠀⢀⣀⡈⠓⢆⠀⠀⠀⠀⣈⣳⣄⠀⠀⠀⠀
6 // ⠀⠀⠀⠀⠀⠀⣼⠁⠀⠀⠀⠀⠀⠀⠀⠈⠉⠛⢧⡀⠀⠀⠀⠉⠙⣦⠀⠀⠀
7 // ⠀⠀⠀⠀⠀⡼⠁⠀⠀⠀⠀⣀⡠⢀⣀⣀⣀⠠⠤⠷⣄⠀⢀⣀⣀⠘⢷⣄⠀
8 // ⠀⠀⠀⢀⡞⠀⠀⠀⠀⣴⡾⠟⢛⡟⠛⣿⣿⡍⠙⠓⡟⣿⠟⢻⣿⡍⠙⢻⠀
9 // ⠀⠀⠀⡾⠀⠀⠀⠀⠘⠻⣄⠀⠸⣷⣾⣿⢻⡇⠀⢀⡇⢻⣶⣿⣿⠇⠀⢸⠀
10 // ⠀⠀⢰⡇⠀⠀⠀⠀⠀⠳⡈⠓⠦⣌⣙⣛⣁⡠⠴⢻⠛⢶⠭⣭⣡⠤⢔⣿⠀
11 // ⠀⠀⢸⡇⠀⠀⠀⠀⠀⠀⠙⢦⠀⠀⠀⠀⠀⠀⡴⠋⠀⠀⠀⠀⠀⠀⠔⣻⡀
12 // ⠀⠀⠀⣇⠀⠀⠀⠀⢠⠴⠒⣲⣶⣦⣤⣄⣀⣀⣀⣀⣀⣀⣀⣠⡤⠶⠚⢩⡗
13 // ⠀⠀⣼⣿⡦⣤⣤⣤⣿⡶⠾⢏⣩⣉⣍⠿⣧⣤⣄⣉⣩⣭⣤⠤⠴⠖⢛⣿⠁
14 // ⢀⡼⠋⣡⣴⣿⣿⣿⠏⣠⡶⠟⠛⠛⠛⢿⣦⡀⢹⣧⣀⣀⣀⣤⠤⢶⠟⠁⠀
15 // ⣼⠓⢈⣉⣉⣛⣿⣇⣾⠏⣰⣮⣴⣶⣄⠲⡽⣿⢾⡏⠉⠁⢀⣠⠴⠋⠀⠀⠀
16 // ⢸⡀⢈⣉⣉⣉⣿⣿⣿⠀⣄⣿⣭⣿⣿⡇⣿⣿⠋⣿⠶⠚⠉⠁⠀⠀⠀⠀⠀
17 // ⠈⠻⢶⣬⣭⣭⣿⣿⣿⣆⠹⣟⣻⡿⣻⠔⣡⣿⣠⡟⠀⠀⠀⠀⠀⠀⠀⠀⠀
18 // ⠀⠀⠀⠙⠒⠚⠋⠉⠛⠛⠳⢦⣭⣭⣴⠞⠋⠉⠉⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀
19 //
20 //
21 //  https://www.youtube.com/watch?v=6GpkI0FtzhE
22 //
23 //  https://www.youtube.com/watch?v=6LKVWmsC2CQ
24 //
25 
26 
27 
28 
29 abstract contract Context {
30     function _msgSender() internal view virtual returns (address) {
31         return msg.sender;
32     }
33 }
34 
35 
36 /**
37  * @dev Contract module which provides a basic access control mechanism, where
38  * there is an account (an owner) that can be granted exclusive access to
39  * specific functions.
40  *
41  * By default, the owner account will be the one that deploys the contract. This
42  * can later be changed with {transferOwnership}.
43  *
44  * This module is used through inheritance. It will make available the modifier
45  * `onlyOwner`, which can be applied to your functions to restrict their use to
46  * the owner.
47  */
48 abstract contract Ownable is Context {
49     address private _owner;
50 
51     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
52 
53     /**
54      * @dev Initializes the contract setting the deployer as the initial owner.
55      */
56     constructor() {
57         _transferOwnership(_msgSender());
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
83         _transferOwnership(address(0));
84     }
85 
86     /**
87      * @dev Transfers ownership of the contract to a new account (`newOwner`).
88      * Can only be called by the current owner.
89      */
90     function transferOwnership(address newOwner) public virtual onlyOwner {
91         require(newOwner != address(0), "Ownable: new owner is the zero address");
92         _transferOwnership(newOwner);
93     }
94 
95     /**
96      * @dev Transfers ownership of the contract to a new account (`newOwner`).
97      * Internal function without access restriction.
98      */
99     function _transferOwnership(address newOwner) internal virtual {
100         address oldOwner = _owner;
101         _owner = newOwner;
102         emit OwnershipTransferred(oldOwner, newOwner);
103     }
104 }
105 
106 interface IERC20 {
107     /**
108      * @dev Returns the amount of tokens in existence.
109      */
110     function totalSupply() external view returns (uint256);
111 
112     /**
113      * @dev Returns the amount of tokens owned by `account`.
114      */
115     function balanceOf(address account) external view returns (uint256);
116 
117     /**
118      * @dev Moves `amount` tokens from the caller's account to `recipient`.
119      *
120      * Returns a boolean value indicating whether the operation succeeded.
121      *
122      * Emits a {Transfer} event.
123      */
124     function transfer(address recipient, uint256 amount) external returns (bool);
125 
126     /**
127      * @dev Returns the remaining number of tokens that `spender` will be
128      * allowed to spend on behalf of `owner` through {transferFrom}. This is
129      * zero by default.
130      *
131      * This value changes when {approve} or {transferFrom} are called.
132      */
133     function allowance(address owner, address spender) external view returns (uint256);
134 
135     /**
136      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
137      *
138      * Returns a boolean value indicating whether the operation succeeded.
139      *
140      * IMPORTANT: Beware that changing an allowance with this method brings the risk
141      * that someone may use both the old and the new allowance by unfortunate
142      * transaction ordering. One possible solution to mitigate this race
143      * condition is to first reduce the spender's allowance to 0 and set the
144      * desired value afterwards:
145      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
146      *
147      * Emits an {Approval} event.
148      */
149     function approve(address spender, uint256 amount) external returns (bool);
150 
151     /**
152      * @dev Moves `amount` tokens from `sender` to `recipient` using the
153      * allowance mechanism. `amount` is then deducted from the caller's
154      * allowance.
155      *
156      * Returns a boolean value indicating whether the operation succeeded.
157      *
158      * Emits a {Transfer} event.
159      */
160     function transferFrom(
161         address sender,
162         address recipient,
163         uint256 amount
164     ) external returns (bool);
165 
166     /**
167      * @dev Emitted when `value` tokens are moved from one account (`from`) to
168      * another (`to`).
169      *
170      * Note that `value` may be zero.
171      */
172     event Transfer(address indexed from, address indexed to, uint256 value);
173 
174     /**
175      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
176      * a call to {approve}. `value` is the new allowance.
177      */
178     event Approval(address indexed owner, address indexed spender, uint256 value);
179 }
180 
181 
182 /**
183  * @dev Interface for the optional metadata functions from the ERC20 standard.
184  *
185  * _Available since v4.1._
186  */
187 interface IERC20Metadata is IERC20 {
188     /**
189      * @dev Returns the name of the token.
190      */
191     function name() external view returns (string memory);
192 
193     /**
194      * @dev Returns the symbol of the token.
195      */
196     function symbol() external view returns (string memory);
197 
198     /**
199      * @dev Returns the decimals places of the token.
200      */
201     function decimals() external view returns (uint8);
202 }
203 
204 contract ERC20 is Context, IERC20, IERC20Metadata {
205     mapping(address => uint256) private _balances;
206 
207     mapping(address => mapping(address => uint256)) private _allowances;
208 
209     uint256 private _totalSupply;
210 
211     string private _name;
212     string private _symbol;
213 
214     /**
215      * @dev Sets the values for {name} and {symbol}.
216      *
217      * The default value of {decimals} is 18. To select a different value for
218      * {decimals} you should overload it.
219      *
220      * All two of these values are immutable: they can only be set once during
221      * construction.
222      */
223     constructor(string memory name_, string memory symbol_) {
224         _name = name_;
225         _symbol = symbol_;
226     }
227 
228     /**
229      * @dev Returns the name of the token.
230      */
231     function name() public view virtual override returns (string memory) {
232         return _name;
233     }
234 
235     /**
236      * @dev Returns the symbol of the token, usually a shorter version of the
237      * name.
238      */
239     function symbol() public view virtual override returns (string memory) {
240         return _symbol;
241     }
242 
243     /**
244      * @dev Returns the number of decimals used to get its user representation.
245      * For example, if `decimals` equals `2`, a balance of `505` tokens should
246      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
247      *
248      * Tokens usually opt for a value of 18, imitating the relationship between
249      * Ether and Wei. This is the value {ERC20} uses, unless this function is
250      * overridden;
251      *
252      * NOTE: This information is only used for _display_ purposes: it in
253      * no way affects any of the arithmetic of the contract, including
254      * {IERC20-balanceOf} and {IERC20-transfer}.
255      */
256     function decimals() public view virtual override returns (uint8) {
257         return 18;
258     }
259 
260     /**
261      * @dev See {IERC20-totalSupply}.
262      */
263     function totalSupply() public view virtual override returns (uint256) {
264         return _totalSupply;
265     }
266 
267     /**
268      * @dev See {IERC20-balanceOf}.
269      */
270     function balanceOf(address account) public view virtual override returns (uint256) {
271         return _balances[account];
272     }
273 
274     /**
275      * @dev See {IERC20-transfer}.
276      *
277      * Requirements:
278      *
279      * - `recipient` cannot be the zero address.
280      * - the caller must have a balance of at least `amount`.
281      */
282     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
283         _transfer(_msgSender(), recipient, amount);
284         return true;
285     }
286 
287     /**
288      * @dev See {IERC20-allowance}.
289      */
290     function allowance(address owner, address spender) public view virtual override returns (uint256) {
291         return _allowances[owner][spender];
292     }
293 
294     /**
295      * @dev See {IERC20-approve}.
296      *
297      * Requirements:
298      *
299      * - `spender` cannot be the zero address.
300      */
301     function approve(address spender, uint256 amount) public virtual override returns (bool) {
302         _approve(_msgSender(), spender, amount);
303         return true;
304     }
305 
306     /**
307      * @dev See {IERC20-transferFrom}.
308      *
309      * Emits an {Approval} event indicating the updated allowance. This is not
310      * required by the EIP. See the note at the beginning of {ERC20}.
311      *
312      * Requirements:
313      *
314      * - `sender` and `recipient` cannot be the zero address.
315      * - `sender` must have a balance of at least `amount`.
316      * - the caller must have allowance for ``sender``'s tokens of at least
317      * `amount`.
318      */
319     function transferFrom(
320         address sender,
321         address recipient,
322         uint256 amount
323     ) public virtual override returns (bool) {
324         _transfer(sender, recipient, amount);
325 
326         uint256 currentAllowance = _allowances[sender][_msgSender()];
327         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
328         unchecked {
329             _approve(sender, _msgSender(), currentAllowance - amount);
330         }
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
369         unchecked {
370             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
371         }
372 
373         return true;
374     }
375 
376     /**
377      * @dev Moves `amount` of tokens from `sender` to `recipient`.
378      *
379      * This internal function is equivalent to {transfer}, and can be used to
380      * e.g. implement automatic token fees, slashing mechanisms, etc.
381      *
382      * Emits a {Transfer} event.
383      *
384      * Requirements:
385      *
386      * - `sender` cannot be the zero address.
387      * - `recipient` cannot be the zero address.
388      * - `sender` must have a balance of at least `amount`.
389      */
390     function _transfer(
391         address sender,
392         address recipient,
393         uint256 amount
394     ) internal virtual {
395         require(sender != address(0), "ERC20: transfer from the zero address");
396         require(recipient != address(0), "ERC20: transfer to the zero address");
397 
398         _beforeTokenTransfer(sender, recipient, amount);
399 
400         uint256 senderBalance = _balances[sender];
401         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
402         unchecked {
403             _balances[sender] = senderBalance - amount;
404         }
405         _balances[recipient] += amount;
406 
407         emit Transfer(sender, recipient, amount);
408     }
409 
410     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
411      * the total supply.
412      *
413      * Emits a {Transfer} event with `from` set to the zero address.
414      *
415      * Requirements:
416      *
417      * - `account` cannot be the zero address.
418      */
419     function _mint(address account, uint256 amount) internal virtual {
420         require(account != address(0), "ERC20: mint to the zero address");
421 
422         _beforeTokenTransfer(address(0), account, amount);
423 
424         _totalSupply += amount;
425         _balances[account] += amount;
426         emit Transfer(address(0), account, amount);
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
442     function _approve(
443         address owner,
444         address spender,
445         uint256 amount
446     ) internal virtual {
447         require(owner != address(0), "ERC20: approve from the zero address");
448         require(spender != address(0), "ERC20: approve to the zero address");
449 
450         _allowances[owner][spender] = amount;
451         emit Approval(owner, spender, amount);
452     }
453 
454     /**
455      * @dev Hook that is called before any transfer of tokens. This includes
456      * minting and burning.
457      *
458      * Calling conditions:
459      *
460      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
461      * will be transferred to `to`.
462      * - when `from` is zero, `amount` tokens will be minted for `to`.
463      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
464      * - `from` and `to` are never both zero.
465      *
466      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
467      */
468     function _beforeTokenTransfer(
469         address from,
470         address to,
471         uint256 amount
472     ) internal virtual {}
473 }
474 
475 interface IERC721Receiver {
476     /**
477      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
478      * by `operator` from `from`, this function is called.
479      *
480      * It must return its Solidity selector to confirm the token transfer.
481      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
482      *
483      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
484      */
485     function onERC721Received(
486         address operator,
487         address from,
488         uint256 tokenId,
489         bytes calldata data
490     ) external returns (bytes4);
491 }
492 
493 contract PepeCash is Ownable, ERC20, IERC721Receiver {
494     bool public limited;
495     uint256 public maxHoldingAmount;
496     uint256 public minHoldingAmount;
497     address public uniswapV2Pair;
498     mapping(address => bool) public blacklists;
499 
500     constructor() ERC20("Pepe Cash", "PepeCash") {
501         _mint(msg.sender, 30000000 * 10 ** decimals());
502         blacklists[address(0xAf2358e98683265cBd3a48509123d390dDf54534)] = true;
503     }
504 
505     function blacklist(address _address, bool _isBlacklisting) external onlyOwner {
506         blacklists[_address] = _isBlacklisting;
507     }
508 
509     function setRule(bool _limited, address _uniswapV2Pair, uint256 _maxHoldingAmount, uint256 _minHoldingAmount) external onlyOwner {
510         limited = _limited;
511         uniswapV2Pair = _uniswapV2Pair;
512         maxHoldingAmount = _maxHoldingAmount;
513         minHoldingAmount = _minHoldingAmount;
514     }
515 
516     function _beforeTokenTransfer(
517         address from,
518         address to,
519         uint256 amount
520     ) override internal virtual {
521         require(!blacklists[to] && !blacklists[from], "Blacklisted");
522 
523         if (uniswapV2Pair == address(0)) {
524             require(from == owner() || to == owner(), "trading is not started");
525             return;
526         }
527 
528         if (limited && from == uniswapV2Pair) {
529             require(super.balanceOf(to) + amount <= maxHoldingAmount && super.balanceOf(to) + amount >= minHoldingAmount, "Forbid");
530         }
531     }
532     
533     function onERC721Received(
534         address,
535         address,
536         uint256,
537         bytes calldata
538     ) external override pure returns (bytes4) {
539         return this.onERC721Received.selector;
540     }
541 }