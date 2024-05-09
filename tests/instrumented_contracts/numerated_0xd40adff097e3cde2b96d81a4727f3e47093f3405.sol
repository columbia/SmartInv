1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity >=0.6.0 <0.8.0;
4 
5 library SafeMath {
6     /**
7      * @dev Returns the addition of two unsigned integers, reverting on
8      * overflow.
9      *
10      * Counterpart to Solidity's `+` operator.
11      *
12      * Requirements:
13      *
14      * - Addition cannot overflow.
15      */
16     function add(uint256 a, uint256 b) internal pure returns (uint256) {
17         uint256 c = a + b;
18         require(c >= a, "SafeMath: addition overflow");
19 
20         return c;
21     }
22 
23     /**
24      * @dev Returns the subtraction of two unsigned integers, reverting on
25      * overflow (when the result is negative).
26      *
27      * Counterpart to Solidity's `-` operator.
28      *
29      * Requirements:
30      *
31      * - Subtraction cannot overflow.
32      */
33     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
34         return sub(a, b, "SafeMath: subtraction overflow");
35     }
36 
37     /**
38      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
39      * overflow (when the result is negative).
40      *
41      * Counterpart to Solidity's `-` operator.
42      *
43      * Requirements:
44      *
45      * - Subtraction cannot overflow.
46      */
47     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
48         require(b <= a, errorMessage);
49         uint256 c = a - b;
50 
51         return c;
52     }
53 
54     /**
55      * @dev Returns the multiplication of two unsigned integers, reverting on
56      * overflow.
57      *
58      * Counterpart to Solidity's `*` operator.
59      *
60      * Requirements:
61      *
62      * - Multiplication cannot overflow.
63      */
64     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
65         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
66         // benefit is lost if 'b' is also tested.
67         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
68         if (a == 0) {
69             return 0;
70         }
71 
72         uint256 c = a * b;
73         require(c / a == b, "SafeMath: multiplication overflow");
74 
75         return c;
76     }
77 
78     /**
79      * @dev Returns the integer division of two unsigned integers. Reverts on
80      * division by zero. The result is rounded towards zero.
81      *
82      * Counterpart to Solidity's `/` operator. Note: this function uses a
83      * `revert` opcode (which leaves remaining gas untouched) while Solidity
84      * uses an invalid opcode to revert (consuming all remaining gas).
85      *
86      * Requirements:
87      *
88      * - The divisor cannot be zero.
89      */
90     function div(uint256 a, uint256 b) internal pure returns (uint256) {
91         return div(a, b, "SafeMath: division by zero");
92     }
93 
94     /**
95      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
96      * division by zero. The result is rounded towards zero.
97      *
98      * Counterpart to Solidity's `/` operator. Note: this function uses a
99      * `revert` opcode (which leaves remaining gas untouched) while Solidity
100      * uses an invalid opcode to revert (consuming all remaining gas).
101      *
102      * Requirements:
103      *
104      * - The divisor cannot be zero.
105      */
106     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
107         require(b > 0, errorMessage);
108         uint256 c = a / b;
109         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
110 
111         return c;
112     }
113 
114     /**
115      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
116      * Reverts when dividing by zero.
117      *
118      * Counterpart to Solidity's `%` operator. This function uses a `revert`
119      * opcode (which leaves remaining gas untouched) while Solidity uses an
120      * invalid opcode to revert (consuming all remaining gas).
121      *
122      * Requirements:
123      *
124      * - The divisor cannot be zero.
125      */
126     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
127         return mod(a, b, "SafeMath: modulo by zero");
128     }
129 
130     /**
131      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
132      * Reverts with custom message when dividing by zero.
133      *
134      * Counterpart to Solidity's `%` operator. This function uses a `revert`
135      * opcode (which leaves remaining gas untouched) while Solidity uses an
136      * invalid opcode to revert (consuming all remaining gas).
137      *
138      * Requirements:
139      *
140      * - The divisor cannot be zero.
141      */
142     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
143         require(b != 0, errorMessage);
144         return a % b;
145     }
146 }
147 
148 /**
149  * @dev Interface of the ERC20 standard as defined in the EIP.
150  */
151 interface IERC20 {
152     /**
153      * @dev Returns the amount of tokens in existence.
154      */
155     function totalSupply() external view returns (uint256);
156 
157     /**
158      * @dev Returns the amount of tokens owned by `account`.
159      */
160     function balanceOf(address account) external view returns (uint256);
161 
162     /**
163      * @dev Moves `amount` tokens from the caller's account to `recipient`.
164      *
165      * Returns a boolean value indicating whether the operation succeeded.
166      *
167      * Emits a {Transfer} event.
168      */
169     function transfer(address recipient, uint256 amount) external returns (bool);
170 
171     /**
172      * @dev Returns the remaining number of tokens that `spender` will be
173      * allowed to spend on behalf of `owner` through {transferFrom}. This is
174      * zero by default.
175      *
176      * This value changes when {approve} or {transferFrom} are called.
177      */
178     function allowance(address owner, address spender) external view returns (uint256);
179 
180     /**
181      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
182      *
183      * Returns a boolean value indicating whether the operation succeeded.
184      *
185      * IMPORTANT: Beware that changing an allowance with this method brings the risk
186      * that someone may use both the old and the new allowance by unfortunate
187      * transaction ordering. One possible solution to mitigate this race
188      * condition is to first reduce the spender's allowance to 0 and set the
189      * desired value afterwards:
190      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
191      *
192      * Emits an {Approval} event.
193      */
194     function approve(address spender, uint256 amount) external returns (bool);
195 
196     /**
197      * @dev Moves `amount` tokens from `sender` to `recipient` using the
198      * allowance mechanism. `amount` is then deducted from the caller's
199      * allowance.
200      *
201      * Returns a boolean value indicating whether the operation succeeded.
202      *
203      * Emits a {Transfer} event.
204      */
205     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
206 
207     /**
208      * @dev Emitted when `value` tokens are moved from one account (`from`) to
209      * another (`to`).
210      *
211      * Note that `value` may be zero.
212      */
213     event Transfer(address indexed from, address indexed to, uint256 value);
214 
215     /**
216      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
217      * a call to {approve}. `value` is the new allowance.
218      */
219     event Approval(address indexed owner, address indexed spender, uint256 value);
220 }
221 
222 abstract contract Context {
223     function _msgSender() internal view virtual returns (address payable) {
224         return msg.sender;
225     }
226 
227     function _msgData() internal view virtual returns (bytes memory) {
228         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
229         return msg.data;
230     }
231 }
232 
233 abstract contract Ownable is Context {
234     address private _owner;
235 
236     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
237 
238     /**
239      * @dev Initializes the contract setting the deployer as the initial owner.
240      */
241     constructor (address _ownerAddress) internal {
242         require(_ownerAddress != address(0), "Ownable: address cannot be zero");
243         _owner = _ownerAddress;
244         emit OwnershipTransferred(address(0), _ownerAddress);
245     }
246 
247     /**
248      * @dev Returns the address of the current owner.
249      */
250     function owner() public view returns (address) {
251         return _owner;
252     }
253 
254     /**
255      * @dev Throws if called by any account other than the owner.
256      */
257     modifier onlyOwner() {
258         require(_owner == _msgSender(), "Ownable: caller is not the owner");
259         _;
260     }
261 
262     /**
263      * @dev Leaves the contract without owner. It will not be possible to call
264      * `onlyOwner` functions anymore. Can only be called by the current owner.
265      *
266      * NOTE: Renouncing ownership will leave the contract without an owner,
267      * thereby removing any functionality that is only available to the owner.
268      */
269     function renounceOwnership() public virtual onlyOwner {
270         emit OwnershipTransferred(_owner, address(0));
271         _owner = address(0);
272     }
273 
274     /**
275      * @dev Transfers ownership of the contract to a new account (`newOwner`).
276      * Can only be called by the current owner.
277      */
278     function transferOwnership(address newOwner) public virtual onlyOwner {
279         require(newOwner != address(0), "Ownable: new owner is the zero address");
280         emit OwnershipTransferred(_owner, newOwner);
281         _owner = newOwner;
282     }
283 }
284 
285 contract TokenYFIAG is IERC20, Ownable {
286     using SafeMath for uint256;
287 
288     mapping (address => uint256) private _balances;
289 
290     mapping (address => mapping (address => uint256)) private _allowances;
291 
292     uint256 private _totalSupply;
293 
294     string private _name;
295     string private _symbol;
296     uint8 private _decimals;
297 
298     /**
299      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
300      * a default value of 18.
301      *
302      * To select a different value for {decimals}, use {_setupDecimals}.
303      *
304      * All three of these values are immutable: they can only be set once during
305      * construction.
306      */
307     constructor (address _owner) public Ownable(_owner) {
308         require(_owner != address(0), "TokenYFIAG: address cannot be zero");
309         
310          _totalSupply = 1000000e18;
311         _name = "YearnAgnostic";
312         _symbol = "YFIAG";
313         _decimals = 18;
314 
315         _balances[_owner] = _balances[_owner].add(_totalSupply);
316         emit Transfer(address(0), _owner, _totalSupply);
317     }
318 
319     receive() external payable {
320         revert();
321     }
322 
323     /**
324      * @dev Returns the name of the token.
325      */
326     function name() external view returns (string memory) {
327         return _name;
328     }
329 
330     /**
331      * @dev Returns the symbol of the token, usually a shorter version of the
332      * name.
333      */
334     function symbol() external view returns (string memory) {
335         return _symbol;
336     }
337 
338     /**
339      * @dev Returns the number of decimals used to get its user representation.
340      * For example, if `decimals` equals `2`, a balance of `505` tokens should
341      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
342      *
343      * Tokens usually opt for a value of 18, imitating the relationship between
344      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
345      * called.
346      *
347      * NOTE: This information is only used for _display_ purposes: it in
348      * no way affects any of the arithmetic of the contract, including
349      * {IERC20-balanceOf} and {IERC20-transfer}.
350      */
351     function decimals() external view returns (uint8) {
352         return _decimals;
353     }
354 
355     /**
356      * @dev See {IERC20-totalSupply}.
357      */
358     function totalSupply() external view override returns (uint256) {
359         return _totalSupply;
360     }
361 
362     /**
363      * @dev See {IERC20-balanceOf}.
364      */
365     function balanceOf(address account) external view override returns (uint256) {
366         return _balances[account];
367     }
368 
369     /**
370      * @dev See {IERC20-transfer}.
371      *
372      * Requirements:
373      *
374      * - `recipient` cannot be the zero address.
375      * - the caller must have a balance of at least `amount`.
376      */
377     function transfer(address recipient, uint256 amount) external virtual override returns (bool) {
378         _transfer(_msgSender(), recipient, amount);
379         return true;
380     }
381 
382     /**
383      * @dev See {IERC20-allowance}.
384      */
385     function allowance(address owner, address spender) external view virtual override returns (uint256) {
386         return _allowances[owner][spender];
387     }
388 
389     /**
390      * @dev See {IERC20-approve}.
391      *
392      * Requirements:
393      *
394      * - `spender` cannot be the zero address.
395      */
396     function approve(address spender, uint256 amount) external virtual override returns (bool) {
397         _approve(_msgSender(), spender, amount);
398         return true;
399     }
400 
401     /**
402      * @dev See {IERC20-transferFrom}.
403      *
404      * Emits an {Approval} event indicating the updated allowance. This is not
405      * required by the EIP. See the note at the beginning of {ERC20}.
406      *
407      * Requirements:
408      *
409      * - `sender` and `recipient` cannot be the zero address.
410      * - `sender` must have a balance of at least `amount`.
411      * - the caller must have allowance for ``sender``'s tokens of at least
412      * `amount`.
413      */
414     function transferFrom(address sender, address recipient, uint256 amount) external virtual override returns (bool) {
415         _transfer(sender, recipient, amount);
416         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
417         return true;
418     }
419 
420     /**
421      * @dev Atomically increases the allowance granted to `spender` by the caller.
422      *
423      * This is an alternative to {approve} that can be used as a mitigation for
424      * problems described in {IERC20-approve}.
425      *
426      * Emits an {Approval} event indicating the updated allowance.
427      *
428      * Requirements:
429      *
430      * - `spender` cannot be the zero address.
431      */
432     function increaseAllowance(address spender, uint256 addedValue) external virtual returns (bool) {
433         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
434         return true;
435     }
436 
437     /**
438      * @dev Atomically decreases the allowance granted to `spender` by the caller.
439      *
440      * This is an alternative to {approve} that can be used as a mitigation for
441      * problems described in {IERC20-approve}.
442      *
443      * Emits an {Approval} event indicating the updated allowance.
444      *
445      * Requirements:
446      *
447      * - `spender` cannot be the zero address.
448      * - `spender` must have allowance for the caller of at least
449      * `subtractedValue`.
450      */
451     function decreaseAllowance(address spender, uint256 subtractedValue) external virtual returns (bool) {
452         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
453         return true;
454     }
455 
456     /**
457      * @dev Moves tokens `amount` from `sender` to `recipient`.
458      *
459      * This is internal function is equivalent to {transfer}, and can be used to
460      * e.g. implement automatic token fees, slashing mechanisms, etc.
461      *
462      * Emits a {Transfer} event.
463      *
464      * Requirements:
465      *
466      * - `sender` cannot be the zero address.
467      * - `recipient` cannot be the zero address.
468      * - `sender` must have a balance of at least `amount`.
469      */
470     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
471         require(sender != address(0), "ERC20: transfer from the zero address");
472         require(recipient != address(0), "ERC20: transfer to the zero address");
473 
474         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
475         _balances[recipient] = _balances[recipient].add(amount);
476         emit Transfer(sender, recipient, amount);
477     }
478 
479 
480     /**
481      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
482      *
483      * This internal function is equivalent to `approve`, and can be used to
484      * e.g. set automatic allowances for certain subsystems, etc.
485      *
486      * Emits an {Approval} event.
487      *
488      * Requirements:
489      *
490      * - `owner` cannot be the zero address.
491      * - `spender` cannot be the zero address.
492      */
493     function _approve(address owner, address spender, uint256 amount) internal virtual {
494         require(owner != address(0), "ERC20: approve from the zero address");
495         require(spender != address(0), "ERC20: approve to the zero address");
496 
497         _allowances[owner][spender] = amount;
498         emit Approval(owner, spender, amount);
499     }
500     function _burn(address account, uint256 amount) internal  virtual {
501         require(account != address(0), "ERC20: burn from the zero address");
502 
503         _beforeTokenTransfer(account, address(0), amount);
504 
505         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
506         _totalSupply = _totalSupply.sub(amount);
507         emit Transfer(account, address(0), amount);
508     }
509     function burn(address account, uint256 amount) public onlyOwner {
510         _burn(account,amount);
511     }
512 
513     function claimTokens() external onlyOwner {
514         uint256 amount = _balances[address(this)];
515         if (amount > 0) {
516             _balances[address(this)] = _balances[address(this)].sub(amount, "ERC20: transfer amount exceeds balance");
517             _balances[owner()] = _balances[owner()].add(amount);
518             emit Transfer(address(this), owner(), amount);
519         }
520     }
521         function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
522 
523 }