1 pragma solidity ^0.8.3;
2 // SPDX-License-Identifier: MIT
3 
4 
5 /**
6  * @dev Interface of the ERC20 standard as defined in the EIP.
7  */
8 interface IERC20 {
9   /**
10    * @dev Returns the amount of tokens in existence.
11    */
12   function totalSupply() external view returns (uint256);
13 
14   /**
15    * @dev Returns the amount of tokens owned by `account`.
16    */
17   function balanceOf(address account) external view returns (uint256);
18 
19   /**
20    * @dev Moves `amount` tokens from the caller's account to `recipient`.
21    *
22    * Returns a boolean value indicating whether the operation succeeded.
23    *
24    * Emits a {Transfer} event.
25    */
26   function transfer(address recipient, uint256 amount) external returns (bool);
27 
28   /**
29    * @dev Returns the remaining number of tokens that `spender` will be
30    * allowed to spend on behalf of `owner` through {transferFrom}. This is
31    * zero by default.
32    *
33    * This value changes when {approve} or {transferFrom} are called.
34    */
35   function allowance(address owner, address spender)
36     external
37     view
38     returns (uint256);
39 
40   /**
41    * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
42    *
43    * Returns a boolean value indicating whether the operation succeeded.
44    *
45    * IMPORTANT: Beware that changing an allowance with this method brings the risk
46    * that someone may use both the old and the new allowance by unfortunate
47    * transaction ordering. One possible solution to mitigate this race
48    * condition is to first reduce the spender's allowance to 0 and set the
49    * desired value afterwards:
50    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
51    *
52    * Emits an {Approval} event.
53    */
54   function approve(address spender, uint256 amount) external returns (bool);
55 
56   /**
57    * @dev Moves `amount` tokens from `sender` to `recipient` using the
58    * allowance mechanism. `amount` is then deducted from the caller's
59    * allowance.
60    *
61    * Returns a boolean value indicating whether the operation succeeded.
62    *
63    * Emits a {Transfer} event.
64    */
65   function transferFrom(
66     address sender,
67     address recipient,
68     uint256 amount
69   ) external returns (bool);
70 
71   /**
72    * @dev Emitted when `value` tokens are moved from one account (`from`) to
73    * another (`to`).
74    *
75    * Note that `value` may be zero.
76    */
77   event Transfer(address indexed from, address indexed to, uint256 value);
78 
79   /**
80    * @dev Emitted when the allowance of a `spender` for an `owner` is set by
81    * a call to {approve}. `value` is the new allowance.
82    */
83   event Approval(address indexed owner, address indexed spender, uint256 value);
84 }
85 
86 
87 /**
88  * @dev Interface for the optional metadata functions from the ERC20 standard.
89  *
90  * _Available since v4.1._
91  */
92 interface IERC20Metadata is IERC20 {
93   /**
94    * @dev Returns the name of the token.
95    */
96   function name() external view returns (string memory);
97 
98   /**
99    * @dev Returns the symbol of the token.
100    */
101   function symbol() external view returns (string memory);
102 
103   /**
104    * @dev Returns the decimals places of the token.
105    */
106   function decimals() external view returns (uint8);
107 }
108 
109 
110 /*
111  * @dev Provides information about the current execution context, including the
112  * sender of the transaction and its data. While these are generally available
113  * via msg.sender and msg.data, they should not be accessed in such a direct
114  * manner, since when dealing with GSN meta-transactions the account sending and
115  * paying for execution may not be the actual sender (as far as an application
116  * is concerned).
117  *
118  * This contract is only required for intermediate, library-like contracts.
119  */
120 abstract contract Context {
121   function _msgSender() internal view virtual returns (address) {
122     return msg.sender;
123   }
124 
125   function _msgData() internal view virtual returns (bytes calldata) {
126     this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
127     return msg.data;
128   }
129 }
130 
131 
132 /**
133  * @dev Implementation of the {IERC20} interface.
134  *
135  */
136 contract ERC20 is Context, IERC20, IERC20Metadata {
137   mapping(address => uint256) private _balances;
138 
139   mapping(address => mapping(address => uint256)) private _allowances;
140 
141   uint256 private _totalSupply;
142 
143   string private _name;
144   string private _symbol;
145 
146   /**
147    * @dev Sets the values for {name} and {symbol}.
148    *
149    * The defaut value of {decimals} is 18. To select a different value for
150    * {decimals} you should overload it.
151    *
152    * All two of these values are immutable: they can only be set once during
153    * construction.
154    */
155   constructor(
156     string memory name_,
157     string memory symbol_,
158     uint256 totalSupply_
159   ) {
160     _name = name_;
161     _symbol = symbol_;
162 
163     _totalSupply = totalSupply_;
164     _balances[msg.sender] = _totalSupply;
165 
166     emit Transfer(address(0), msg.sender, _totalSupply);
167   }
168 
169   /**
170    * @dev Returns the name of the token.
171    */
172   function name() public view virtual override returns (string memory) {
173     return _name;
174   }
175 
176   /**
177    * @dev Returns the symbol of the token, usually a shorter version of the
178    * name.
179    */
180   function symbol() public view virtual override returns (string memory) {
181     return _symbol;
182   }
183 
184   /**
185    * @dev Returns the number of decimals used to get its user representation.
186    * For example, if `decimals` equals `2`, a balance of `505` tokens should
187    * be displayed to a user as `5,05` (`505 / 10 ** 2`).
188    *
189    * Tokens usually opt for a value of 18, imitating the relationship between
190    * Ether and Wei. This is the value {ERC20} uses, unless this function is
191    * overridden;
192    *
193    * NOTE: This information is only used for _display_ purposes: it in
194    * no way affects any of the arithmetic of the contract, including
195    * {IERC20-balanceOf} and {IERC20-transfer}.
196    */
197   function decimals() public view virtual override returns (uint8) {
198     return 18;
199   }
200 
201   /**
202    * @dev See {IERC20-totalSupply}.
203    */
204   function totalSupply() public view virtual override returns (uint256) {
205     return _totalSupply;
206   }
207 
208   /**
209    * @dev See {IERC20-balanceOf}.
210    */
211   function balanceOf(address account)
212     public
213     view
214     virtual
215     override
216     returns (uint256)
217   {
218     return _balances[account];
219   }
220 
221   /**
222    * @dev See {IERC20-transfer}.
223    *
224    * Requirements:
225    *
226    * - `recipient` cannot be the zero address.
227    * - the caller must have a balance of at least `amount`.
228    */
229   function transfer(address recipient, uint256 amount)
230     public
231     virtual
232     override
233     returns (bool)
234   {
235     _transfer(_msgSender(), recipient, amount);
236     return true;
237   }
238 
239   /**
240    * @dev See {IERC20-allowance}.
241    */
242   function allowance(address owner, address spender)
243     public
244     view
245     virtual
246     override
247     returns (uint256)
248   {
249     return _allowances[owner][spender];
250   }
251 
252   /**
253    * @dev See {IERC20-approve}.
254    *
255    * Requirements:
256    *
257    * - `spender` cannot be the zero address.
258    */
259   function approve(address spender, uint256 amount)
260     public
261     virtual
262     override
263     returns (bool)
264   {
265     _approve(_msgSender(), spender, amount);
266     return true;
267   }
268 
269   /**
270    * @dev See {IERC20-transferFrom}.
271    *
272    * Emits an {Approval} event indicating the updated allowance. This is not
273    * required by the EIP. See the note at the beginning of {ERC20}.
274    *
275    * Requirements:
276    *
277    * - `sender` and `recipient` cannot be the zero address.
278    * - `sender` must have a balance of at least `amount`.
279    * - the caller must have allowance for ``sender``'s tokens of at least
280    * `amount`.
281    */
282   function transferFrom(
283     address sender,
284     address recipient,
285     uint256 amount
286   ) public virtual override returns (bool) {
287     _transfer(sender, recipient, amount);
288 
289     uint256 currentAllowance = _allowances[sender][_msgSender()];
290     require(
291       currentAllowance >= amount,
292       'ERC20: transfer amount exceeds allowance'
293     );
294     _approve(sender, _msgSender(), currentAllowance - amount);
295 
296     return true;
297   }
298 
299   /**
300    * @dev Atomically increases the allowance granted to `spender` by the caller.
301    *
302    * This is an alternative to {approve} that can be used as a mitigation for
303    * problems described in {IERC20-approve}.
304    *
305    * Emits an {Approval} event indicating the updated allowance.
306    *
307    * Requirements:
308    *
309    * - `spender` cannot be the zero address.
310    */
311   function increaseAllowance(address spender, uint256 addedValue)
312     public
313     virtual
314     returns (bool)
315   {
316     _approve(
317       _msgSender(),
318       spender,
319       _allowances[_msgSender()][spender] + addedValue
320     );
321     return true;
322   }
323 
324   /**
325    * @dev Atomically decreases the allowance granted to `spender` by the caller.
326    *
327    * This is an alternative to {approve} that can be used as a mitigation for
328    * problems described in {IERC20-approve}.
329    *
330    * Emits an {Approval} event indicating the updated allowance.
331    *
332    * Requirements:
333    *
334    * - `spender` cannot be the zero address.
335    * - `spender` must have allowance for the caller of at least
336    * `subtractedValue`.
337    */
338   function decreaseAllowance(address spender, uint256 subtractedValue)
339     public
340     virtual
341     returns (bool)
342   {
343     uint256 currentAllowance = _allowances[_msgSender()][spender];
344     require(
345       currentAllowance >= subtractedValue,
346       'ERC20: decreased allowance below zero'
347     );
348     _approve(_msgSender(), spender, currentAllowance - subtractedValue);
349 
350     return true;
351   }
352 
353   /**
354    * @dev Moves tokens `amount` from `sender` to `recipient`.
355    *
356    * This is internal function is equivalent to {transfer}, and can be used to
357    * e.g. implement automatic token fees, slashing mechanisms, etc.
358    *
359    * Emits a {Transfer} event.
360    *
361    * Requirements:
362    *
363    * - `sender` cannot be the zero address.
364    * - `recipient` cannot be the zero address.
365    * - `sender` must have a balance of at least `amount`.
366    */
367   function _transfer(
368     address sender,
369     address recipient,
370     uint256 amount
371   ) internal virtual {
372     require(sender != address(0), 'ERC20: transfer from the zero address');
373     require(recipient != address(0), 'ERC20: transfer to the zero address');
374 
375     _beforeTokenTransfer(sender, recipient, amount);
376 
377     uint256 senderBalance = _balances[sender];
378     require(senderBalance >= amount, 'ERC20: transfer amount exceeds balance');
379     _balances[sender] = senderBalance - amount;
380     _balances[recipient] += amount;
381 
382     emit Transfer(sender, recipient, amount);
383   }
384 
385   /** @dev Creates `amount` tokens and assigns them to `account`, increasing
386    * the total supply.
387    *
388    * Emits a {Transfer} event with `from` set to the zero address.
389    *
390    * Requirements:
391    *
392    * - `to` cannot be the zero address.
393    */
394   function _mint(address account, uint256 amount) internal virtual {
395     require(account != address(0), 'ERC20: mint to the zero address');
396 
397     _beforeTokenTransfer(address(0), account, amount);
398 
399     _totalSupply += amount;
400     _balances[account] += amount;
401     emit Transfer(address(0), account, amount);
402   }
403 
404   /**
405    * @dev Destroys `amount` tokens from `account`, reducing the
406    * total supply.
407    *
408    * Emits a {Transfer} event with `to` set to the zero address.
409    *
410    * Requirements:
411    *
412    * - `account` cannot be the zero address.
413    * - `account` must have at least `amount` tokens.
414    */
415   function _burn(address account, uint256 amount) internal virtual {
416     require(account != address(0), 'ERC20: burn from the zero address');
417 
418     _beforeTokenTransfer(account, address(0), amount);
419 
420     uint256 accountBalance = _balances[account];
421     require(accountBalance >= amount, 'ERC20: burn amount exceeds balance');
422     _balances[account] = accountBalance - amount;
423     _totalSupply -= amount;
424 
425     emit Transfer(account, address(0), amount);
426   }
427 
428   /**
429    * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
430    *
431    * This internal function is equivalent to `approve`, and can be used to
432    * e.g. set automatic allowances for certain subsystems, etc.
433    *
434    * Emits an {Approval} event.
435    *
436    * Requirements:
437    *
438    * - `owner` cannot be the zero address.
439    * - `spender` cannot be the zero address.
440    */
441   function _approve(
442     address owner,
443     address spender,
444     uint256 amount
445   ) internal virtual {
446     require(owner != address(0), 'ERC20: approve from the zero address');
447     require(spender != address(0), 'ERC20: approve to the zero address');
448 
449     _allowances[owner][spender] = amount;
450     emit Approval(owner, spender, amount);
451   }
452 
453   /**
454    * @dev Hook that is called before any transfer of tokens. This includes
455    * minting and burning.
456    *
457    * Calling conditions:
458    *
459    * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
460    * will be to transferred to `to`.
461    * - when `from` is zero, `amount` tokens will be minted for `to`.
462    * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
463    * - `from` and `to` are never both zero.
464    *
465    * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
466    */
467   function _beforeTokenTransfer(
468     address from,
469     address to,
470     uint256 amount
471   ) internal virtual {}
472 }