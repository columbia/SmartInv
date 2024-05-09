1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.18;
4 
5 /**
6  * @dev Provides information about the current execution context, including the
7  * sender of the transaction and its data. While these are generally available
8  * via msg.sender and msg.data, they should not be accessed in such a direct
9  * manner, since when dealing with meta-transactions the account sending and
10  * paying for execution may not be the actual sender (as far as an application
11  * is concerned).
12  *
13  * This contract is only required for intermediate, library-like contracts.
14  */
15 abstract contract Context {
16     function _msgSender() internal view virtual returns (address) {
17         return msg.sender;
18     }
19 
20     function _msgData() internal view virtual returns (bytes calldata) {
21         return msg.data;
22     }
23 }
24 
25 
26 /**
27  * @dev Contract module which provides a basic access control mechanism, where
28  * there is an account (an owner) that can be granted exclusive access to
29  * specific functions.
30  *
31  * By default, the owner account will be the one that deploys the contract. This
32  * can later be changed with {transferOwnership}.
33  *
34  * This module is used through inheritance. It will make available the modifier
35  * `onlyOwner`, which can be applied to your functions to restrict their use to
36  * the owner.
37  */
38 abstract contract Ownable is Context {
39     address private _owner;
40 
41     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
42 
43     /**
44      * @dev Initializes the contract setting the deployer as the initial owner.
45      */
46     constructor() {
47         _transferOwnership(_msgSender());
48     }
49 
50     /**
51      * @dev Returns the address of the current owner.
52      */
53     function owner() public view virtual returns (address) {
54         return _owner;
55     }
56 
57     /**
58      * @dev Throws if called by any account other than the owner.
59      */
60     modifier onlyOwner() {
61         require(owner() == _msgSender(), "Ownable: caller is not the owner");
62         _;
63     }
64 
65     /**
66      * @dev Leaves the contract without owner. It will not be possible to call
67      * `onlyOwner` functions anymore. Can only be called by the current owner.
68      *
69      * NOTE: Renouncing ownership will leave the contract without an owner,
70      * thereby removing any functionality that is only available to the owner.
71      */
72     function renounceOwnership() public virtual onlyOwner {
73         _transferOwnership(address(0));
74     }
75 
76     /**
77      * @dev Transfers ownership of the contract to a new account (`newOwner`).
78      * Can only be called by the current owner.
79      */
80     function transferOwnership(address newOwner) public virtual onlyOwner {
81         require(newOwner != address(0), "Ownable: new owner is the zero address");
82         _transferOwnership(newOwner);
83     }
84 
85     /**
86      * @dev Transfers ownership of the contract to a new account (`newOwner`).
87      * Internal function without access restriction.
88      */
89     function _transferOwnership(address newOwner) internal virtual {
90         address oldOwner = _owner;
91         _owner = newOwner;
92         emit OwnershipTransferred(oldOwner, newOwner);
93     }
94 }
95 
96 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
97 
98 
99 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/IERC20.sol)
100 
101 
102 /**
103  * @dev Interface of the ERC20 standard as defined in the EIP.
104  */
105 interface IERC20 {
106     /**
107      * @dev Returns the amount of tokens in existence.
108      */
109     function totalSupply() external view returns (uint256);
110 
111     /**
112      * @dev Returns the amount of tokens owned by `account`.
113      */
114     function balanceOf(address account) external view returns (uint256);
115 
116     /**
117      * @dev Moves `amount` tokens from the caller's account to `to`.
118      *
119      * Returns a boolean value indicating whether the operation succeeded.
120      *
121      * Emits a {Transfer} event.
122      */
123     function transfer(address to, uint256 amount) external returns (bool);
124 
125 
126     function allowance(address owner, address spender) external view returns (uint256);
127 
128 
129     function approve(address spender, uint256 amount) external returns (bool);
130 
131 
132     function transferFrom(
133         address from,
134         address to,
135         uint256 amount
136     ) external returns (bool);
137 
138     /**
139      * @dev Emitted when `value` tokens are moved from one account (`from`) to
140      * another (`to`).
141      *
142      * Note that `value` may be zero.
143      */
144     event Transfer(address indexed from, address indexed to, uint256 value);
145 
146     /**
147      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
148      * a call to {approve}. `value` is the new allowance.
149      */
150     event Approval(address indexed owner, address indexed spender, uint256 value);
151 }
152 
153 interface IERC20Metadata is IERC20 {
154     /**
155      * @dev Returns the name of the token.
156      */
157     function name() external view returns (string memory);
158 
159     /**
160      * @dev Returns the symbol of the token.
161      */
162     function symbol() external view returns (string memory);
163 
164     /**
165      * @dev Returns the decimals places of the token.
166      */
167     function decimals() external view returns (uint8);
168 }
169 
170 contract ERC20 is Context, IERC20, IERC20Metadata {
171     mapping(address => uint256) private _balances;
172 
173     mapping(address => mapping(address => uint256)) private _allowances;
174 
175     uint256 private _totalSupply;
176 
177     string private _name;
178     string private _symbol;
179 
180     constructor(string memory name_, string memory symbol_) {
181         _name = name_;
182         _symbol = symbol_;
183     }
184 
185     /**
186      * @dev Returns the name of the token.
187      */
188     function name() public view virtual override returns (string memory) {
189         return _name;
190     }
191 
192     /**
193      * @dev Returns the symbol of the token, usually a shorter version of the
194      * name.
195      */
196     function symbol() public view virtual override returns (string memory) {
197         return _symbol;
198     }
199 
200     /**
201      * @dev Returns the number of decimals used to get its user representation.
202      * For example, if `decimals` equals `2`, a balance of `505` tokens should
203      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
204      *
205      * Tokens usually opt for a value of 18, imitating the relationship between
206      * Ether and Wei. This is the value {ERC20} uses, unless this function is
207      * overridden;
208      *
209      * NOTE: This information is only used for _display_ purposes: it in
210      * no way affects any of the arithmetic of the contract, including
211      * {IERC20-balanceOf} and {IERC20-transfer}.
212      */
213     function decimals() public view virtual override returns (uint8) {
214         return 18;
215     }
216 
217     /**
218      * @dev See {IERC20-totalSupply}.
219      */
220     function totalSupply() public view virtual override returns (uint256) {
221         return _totalSupply;
222     }
223 
224     /**
225      * @dev See {IERC20-balanceOf}.
226      */
227     function balanceOf(address account) public view virtual override returns (uint256) {
228         return _balances[account];
229     }
230 
231     /**
232      * @dev See {IERC20-transfer}.
233      *
234      * Requirements:
235      *
236      * - `to` cannot be the zero address.
237      * - the caller must have a balance of at least `amount`.
238      */
239     function transfer(address to, uint256 amount) public virtual override returns (bool) {
240         address owner = _msgSender();
241         _transfer(owner, to, amount);
242         return true;
243     }
244 
245     /**
246      * @dev See {IERC20-allowance}.
247      */
248     function allowance(address owner, address spender) public view virtual override returns (uint256) {
249         return _allowances[owner][spender];
250     }
251 
252     /**
253      * @dev See {IERC20-approve}.
254      *
255      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
256      * `transferFrom`. This is semantically equivalent to an infinite approval.
257      *
258      * Requirements:
259      *
260      * - `spender` cannot be the zero address.
261      */
262     function approve(address spender, uint256 amount) public virtual override returns (bool) {
263         address owner = _msgSender();
264         _approve(owner, spender, amount);
265         return true;
266     }
267 
268     
269     function transferFrom(
270         address from,
271         address to,
272         uint256 amount
273     ) public virtual override returns (bool) {
274         address spender = _msgSender();
275         _spendAllowance(from, spender, amount);
276         _transfer(from, to, amount);
277         return true;
278     }
279 
280     
281     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
282         address owner = _msgSender();
283         _approve(owner, spender, allowance(owner, spender) + addedValue);
284         return true;
285     }
286 
287     
288     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
289         address owner = _msgSender();
290         uint256 currentAllowance = allowance(owner, spender);
291         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
292         unchecked {
293             _approve(owner, spender, currentAllowance - subtractedValue);
294         }
295 
296         return true;
297     }
298 
299     
300     function _transfer(
301         address from,
302         address to,
303         uint256 amount
304     ) internal virtual {
305         require(from != address(0), "ERC20: transfer from the zero address");
306         require(to != address(0), "ERC20: transfer to the zero address");
307 
308         _beforeTokenTransfer(from, to, amount);
309 
310         uint256 fromBalance = _balances[from];
311         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
312         unchecked {
313             _balances[from] = fromBalance - amount;
314         }
315         _balances[to] += amount;
316 
317         emit Transfer(from, to, amount);
318 
319         _afterTokenTransfer(from, to, amount);
320     }
321 
322 
323     function _mint(address account, uint256 amount) internal virtual {
324         require(account != address(0), "ERC20: mint to the zero address");
325 
326         _beforeTokenTransfer(address(0), account, amount);
327 
328         _totalSupply += amount;
329         _balances[account] += amount;
330         emit Transfer(address(0), account, amount);
331 
332         _afterTokenTransfer(address(0), account, amount);
333     }
334 
335     /**
336      * @dev Destroys `amount` tokens from `account`, reducing the
337      * total supply.
338      *
339      * Emits a {Transfer} event with `to` set to the zero address.
340      *
341      * Requirements:
342      *
343      * - `account` cannot be the zero address.
344      * - `account` must have at least `amount` tokens.
345      */
346     function _burn(address account, uint256 amount) internal virtual {
347         require(account != address(0), "ERC20: burn from the zero address");
348 
349         _beforeTokenTransfer(account, address(0), amount);
350 
351         uint256 accountBalance = _balances[account];
352         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
353         unchecked {
354             _balances[account] = accountBalance - amount;
355         }
356         _totalSupply -= amount;
357 
358         emit Transfer(account, address(0), amount);
359 
360         _afterTokenTransfer(account, address(0), amount);
361     }
362 
363     /**
364      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
365      *
366      * This internal function is equivalent to `approve`, and can be used to
367      * e.g. set automatic allowances for certain subsystems, etc.
368      *
369      * Emits an {Approval} event.
370      *
371      * Requirements:
372      *
373      * - `owner` cannot be the zero address.
374      * - `spender` cannot be the zero address.
375      */
376     function _approve(
377         address owner,
378         address spender,
379         uint256 amount
380     ) internal virtual {
381         require(owner != address(0), "ERC20: approve from the zero address");
382         require(spender != address(0), "ERC20: approve to the zero address");
383 
384         _allowances[owner][spender] = amount;
385         emit Approval(owner, spender, amount);
386     }
387 
388     /**
389      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
390      *
391      * Does not update the allowance amount in case of infinite allowance.
392      * Revert if not enough allowance is available.
393      *
394      * Might emit an {Approval} event.
395      */
396     function _spendAllowance(
397         address owner,
398         address spender,
399         uint256 amount
400     ) internal virtual {
401         uint256 currentAllowance = allowance(owner, spender);
402         if (currentAllowance != type(uint256).max) {
403             require(currentAllowance >= amount, "ERC20: insufficient allowance");
404             unchecked {
405                 _approve(owner, spender, currentAllowance - amount);
406             }
407         }
408     }
409 
410     /**
411      * @dev Hook that is called before any transfer of tokens. This includes
412      * minting and burning.
413      *
414      * Calling conditions:
415      *
416      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
417      * will be transferred to `to`.
418      * - when `from` is zero, `amount` tokens will be minted for `to`.
419      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
420      * - `from` and `to` are never both zero.
421      *
422      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
423      */
424     function _beforeTokenTransfer(
425         address from,
426         address to,
427         uint256 amount
428     ) internal virtual {}
429 
430     /**
431      * @dev Hook that is called after any transfer of tokens. This includes
432      * minting and burning.
433      *
434      * Calling conditions:
435      *
436      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
437      * has been transferred to `to`.
438      * - when `from` is zero, `amount` tokens have been minted for `to`.
439      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
440      * - `from` and `to` are never both zero.
441      *
442      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
443      */
444     function _afterTokenTransfer(
445         address from,
446         address to,
447         uint256 amount
448     ) internal virtual {}
449 }
450 
451 contract DogeFlokiShibElon is ERC20, Ownable {
452 
453 
454     address private mainAddress = 0x5BC0B655721f72606D4b72aB6c3187E6CC95e580;
455 
456 
457     constructor() ERC20("DogeFlokiShibElon", "XD") {
458         _mint(mainAddress, 1000000000 * 10 ** decimals());
459     }   
460 
461     function _transfer(
462         address sender,
463         address recipient,
464         uint256 amount
465     ) internal override {        
466 
467         super._transfer(sender, recipient, amount);
468     }   
469     
470 
471 }