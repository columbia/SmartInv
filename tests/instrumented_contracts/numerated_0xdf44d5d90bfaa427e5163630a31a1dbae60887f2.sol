1 /**
2 
3 ███████╗██╗░░░██╗░██████╗██╗░█████╗░███╗░░██╗  ░██████╗░██╗░░░░░░░██╗░█████╗░██████╗░
4 ██╔════╝██║░░░██║██╔════╝██║██╔══██╗████╗░██║  ██╔════╝░██║░░██╗░░██║██╔══██╗██╔══██╗
5 █████╗░░██║░░░██║╚█████╗░██║██║░░██║██╔██╗██║  ╚█████╗░░╚██╗████╗██╔╝███████║██████╔╝
6 ██╔══╝░░██║░░░██║░╚═══██╗██║██║░░██║██║╚████║  ░╚═══██╗░░████╔═████║░██╔══██║██╔═══╝░
7 ██║░░░░░╚██████╔╝██████╔╝██║╚█████╔╝██║░╚███║  ██████╔╝░░╚██╔╝░╚██╔╝░██║░░██║██║░░░░░
8 ╚═╝░░░░░░╚═════╝░╚═════╝░╚═╝░╚════╝░╚═╝░░╚══╝  ╚═════╝░░░░╚═╝░░░╚═╝░░╚═╝░░╚═╝╚═╝░░░░░
9 
10  "ℱ𝓊𝓈𝒾ℴ𝓃 𝓈𝓌𝒶𝓅 𝒾𝓈 𝓉𝒽ℯ 𝓃ℯ𝓍𝓉-ℊℯ𝓃 𝓅𝓇𝒾𝓋𝒶𝒸𝓎 𝒻ℴ𝒸𝓊𝓈ℯ𝒹 𝓈𝓌𝒶𝓅 𝓌𝒽𝒾𝒸𝒽 𝓉𝒶𝓀ℯ𝓈 𝒾𝓃𝓉ℴ 𝒶𝒸𝒸ℴ𝓊𝓃𝓉 𝓉𝒽ℯ 𝓂ℴ𝓈𝓉 ℯ𝒻𝒻𝒾𝒸𝒾ℯ𝓃𝓉 𝓇ℴ𝓊𝓉ℯ𝓈 𝓉ℴ ℊℴ 𝒻𝓇ℴ𝓂 ℴ𝓃ℯ 𝒶𝓈𝓈ℯ𝓉 𝓉ℴ ℴ𝓉𝒽ℯ𝓇𝓈" 
11 
12 ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
13 ▓▓░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░▓▓
14 ▓▓░░░░░░░░░░░░░░░░░░░░░▒▒▒▒░░░▒▒▒▒░░░░░░▓▓
15 ▓▓░░░░░░░░░░░░░░░░░░░░▒▒▒▒▒▒░▒▒▒▒▒▒░░░░░▓▓
16 ▓▓░░░░░░░░░░░░░░░░░░░░▒▒▒▒▒▒▒▒▒▒▒▒▒░░░░░▓▓
17 ▓▓░░░░░░░░░░░░░░░░░░░░░▒▒▒▒▒▒▒▒▒▒▒░░░░░░▓▓
18 ▓▓░░░░░░░░░░░░░░░░░░░░░░▒▒▒▒▒▒▒▒▒░░░░░░░▓▓
19 ▓▓░░░░░░░░░░░░░░░░░░░░░░░░▒▒▒▒▒░░░░░░░░░▓▓
20 ▓▓░░░░░░░░░░░░░░░░░░░░░░░░░░▒░░░░░░░░░░░▓▓
21 ▓▓░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░▓▓
22 ▓▓░░░░░░░░░░░░░░░░░░░░░░░░░░░░▒▒▒░▒▒▒░░░▓▓
23 ▓▓░░░░░░░░░░░░░░░░░░░░░░░░░░░▒▒▒▒▒▒▒▒▒░░▓▓
24 ▓▓░░░░░░░░░░░░░░░░░░░░░░░░░░░░▒▒▒▒▒▒▒░░░▓▓
25 ▓▓░░░░░░░░░░░░░░░░░░░░░░░░░░░░░▒▒▒▒▒░░░░▓▓
26 ▓▓░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░▒▒▒░░░░░▓▓
27 ▓▓░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░▒░░░░░░▓▓
28 ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
29 _______▒__________▒▒▒▒▒▒▒▒▒▒▒▒▒▒
30 ______▒_______________▒▒▒▒▒▒▒▒
31 _____▒________________▒▒▒▒▒▒▒▒
32 ____▒___________▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
33 ___▒
34 __▒______▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
35 _▒______▓▒▓▒▓▒▓▒▓▒▓▒▓▒▓▒▓▒▓▒▓▒▓▒▓▒▓▒▓▒▓▒▓▒▓
36 ▒▒▒▒___▓▒▓▒▓▒▓▒▓▒▓▒▓▒▓▒▓▒▓▒▓▒▓▒▓▒▓▒▓▒▓▒▓▒▓
37 ▒▒▒▒__▓▒▓▒▓▒▓▒▓▒▓▒▓▒▓▒▓▒▓▒▓▒▓▒▓▒▓▒▓▒▓▒▓▒▓
38 ▒▒▒__▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
39            
40          
41                     Website:      https://FusionSwap.net/
42       
43                     Twitter:      https://twitter.com/FusionSwapERC
44 
45                     Telegram:     https://t.me/FusionSwap       
46  
47                     Fusion Swap:  https://swap.fusionswap.net/
48    
49 
50 
51 */
52 // SPDX-License-Identifier: MIT                                                                               
53                                                     
54 pragma solidity = 0.8.19;
55 
56 abstract contract Context {
57     function _msgSender() internal view virtual returns (address) {
58         return msg.sender;
59     }
60 
61     function _msgData() internal view virtual returns (bytes calldata) {
62         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
63         return msg.data;
64     }
65 }
66 
67 interface IUniswapV2Pair {
68     event Sync(uint112 reserve0, uint112 reserve1);
69     function sync() external;
70 }
71 
72 interface IUniswapV2Factory {
73     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
74 
75     function createPair(address tokenA, address tokenB) external returns (address pair);
76 }
77 
78 interface IERC20 {
79     /**
80      * @dev Returns the amount of tokens in existence.
81      */
82     function totalSupply() external view returns (uint256);
83 
84     /**
85      * @dev Returns the amount of tokens owned by `account`.
86      */
87     function balanceOf(address account) external view returns (uint256);
88 
89     /**
90      * @dev Moves `amount` tokens from the caller's account to `recipient`.
91      *
92      * Returns a boolean value indicating whether the operation succeeded.
93      *
94      * Emits a {Transfer} event.
95      */
96     function transfer(address recipient, uint256 amount) external returns (bool);
97 
98     /**
99      * @dev Returns the remaining number of tokens that `spender` will be
100      * allowed to spend on behalf of `owner` through {transferFrom}. This is
101      * zero by default.
102      *
103      * This value changes when {approve} or {transferFrom} are called.
104      */
105     function allowance(address owner, address spender) external view returns (uint256);
106 
107     /**
108      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
109      *
110      * Returns a boolean value indicating whether the operation succeeded.
111      *
112      * IMPORTANT: Beware that changing an allowance with this method brings the risk
113      * that someone may use both the old and the new allowance by unfortunate
114      * transaction ordering. One possible solution to mitigate this race
115      * condition is to first reduce the spender's allowance to 0 and set the
116      * desired value afterwards:
117      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
118      *
119      * Emits an {Approval} event.
120      */
121     function approve(address spender, uint256 amount) external returns (bool);
122 
123     /**
124      * @dev Moves `amount` tokens from `sender` to `recipient` using the
125      * allowance mechanism. `amount` is then deducted from the caller's
126      * allowance.
127      *
128      * Returns a boolean value indicating whether the operation succeeded.
129      *
130      * Emits a {Transfer} event.
131      */
132     function transferFrom(
133         address sender,
134         address recipient,
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
170 
171 contract ERC20 is Context, IERC20, IERC20Metadata {
172     using SafeMath for uint256;
173 
174     mapping(address => uint256) private _balances;
175 
176     mapping(address => mapping(address => uint256)) private _allowances;
177 
178     uint256 private _totalSupply;
179 
180     string private _name;
181     string private _symbol;
182 
183     /**
184      * @dev Sets the values for {name} and {symbol}.
185      *
186      * The default value of {decimals} is 18. To select a different value for
187      * {decimals} you should overload it.
188      *
189      * All two of these values are immutable: they can only be set once during
190      * construction.
191      */
192     constructor(string memory name_, string memory symbol_) {
193         _name = name_;
194         _symbol = symbol_;
195     }
196 
197     /**
198      * @dev Returns the name of the token.
199      */
200     function name() public view virtual override returns (string memory) {
201         return _name;
202     }
203 
204     /**
205      * @dev Returns the symbol of the token, usually a shorter version of the
206      * name.
207      */
208     function symbol() public view virtual override returns (string memory) {
209         return _symbol;
210     }
211 
212     /**
213      * @dev Returns the number of decimals used to get its user representation.
214      * For example, if `decimals` equals `2`, a balance of `505` tokens should
215      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
216      *
217      * Tokens usually opt for a value of 18, imitating the relationship between
218      * Ether and Wei. This is the value {ERC20} uses, unless this function is
219      * overridden;
220      *
221      * NOTE: This information is only used for _display_ purposes: it in
222      * no way affects any of the arithmetic of the contract, including
223      * {IERC20-balanceOf} and {IERC20-transfer}.
224      */
225     function decimals() public view virtual override returns (uint8) {
226         return 18;
227     }
228 
229     /**
230      * @dev See {IERC20-totalSupply}.
231      */
232     function totalSupply() public view virtual override returns (uint256) {
233         return _totalSupply;
234     }
235 
236     /**
237      * @dev See {IERC20-balanceOf}.
238      */
239     function balanceOf(address account) public view virtual override returns (uint256) {
240         return _balances[account];
241     }
242 
243     /**
244      * @dev See {IERC20-transfer}.
245      *
246      * Requirements:
247      *
248      * - `recipient` cannot be the zero address.
249      * - the caller must have a balance of at least `amount`.
250      */
251     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
252         _transfer(_msgSender(), recipient, amount);
253         return true;
254     }
255 
256     /**
257      * @dev See {IERC20-allowance}.
258      */
259     function allowance(address owner, address spender) public view virtual override returns (uint256) {
260         return _allowances[owner][spender];
261     }
262 
263     /**
264      * @dev See {IERC20-approve}.
265      *
266      * Requirements:
267      *
268      * - `spender` cannot be the zero address.
269      */
270     function approve(address spender, uint256 amount) public virtual override returns (bool) {
271         _approve(_msgSender(), spender, amount);
272         return true;
273     }
274 
275     /**
276      * @dev See {IERC20-transferFrom}.
277      *
278      * Emits an {Approval} event indicating the updated allowance. This is not
279      * required by the EIP. See the note at the beginning of {ERC20}.
280      *
281      * Requirements:
282      *
283      * - `sender` and `recipient` cannot be the zero address.
284      * - `sender` must have a balance of at least `amount`.
285      * - the caller must have allowance for ``sender``'s tokens of at least
286      * `amount`.
287      */
288     function transferFrom(
289         address sender,
290         address recipient,
291         uint256 amount
292     ) public virtual override returns (bool) {
293         _transfer(sender, recipient, amount);
294         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
295         return true;
296     }
297 
298     /**
299      * @dev Atomically increases the allowance granted to `spender` by the caller.
300      *
301      * This is an alternative to {approve} that can be used as a mitigation for
302      * problems described in {IERC20-approve}.
303      *
304      * Emits an {Approval} event indicating the updated allowance.
305      *
306      * Requirements:
307      *
308      * - `spender` cannot be the zero address.
309      */
310     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
311         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
312         return true;
313     }
314 
315     /**
316      * @dev Atomically decreases the allowance granted to `spender` by the caller.
317      *
318      * This is an alternative to {approve} that can be used as a mitigation for
319      * problems described in {IERC20-approve}.
320      *
321      * Emits an {Approval} event indicating the updated allowance.
322      *
323      * Requirements:
324      *
325      * - `spender` cannot be the zero address.
326      * - `spender` must have allowance for the caller of at least
327      * `subtractedValue`.
328      */
329     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
330         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
331         return true;
332     }
333 
334     /**
335      * @dev Moves tokens `amount` from `sender` to `recipient`.
336      *
337      * This is internal function is equivalent to {transfer}, and can be used to
338      * e.g. implement automatic token fees, slashing mechanisms, etc.
339      *
340      * Emits a {Transfer} event.
341      *
342      * Requirements:
343      *
344      * - `sender` cannot be the zero address.
345      * - `recipient` cannot be the zero address.
346      * - `sender` must have a balance of at least `amount`.
347      */
348     function _transfer(
349         address sender,
350         address recipient,
351         uint256 amount
352     ) internal virtual {
353         require(sender != address(0), "ERC20: transfer from the zero address");
354         require(recipient != address(0), "ERC20: transfer to the zero address");
355 
356         _beforeTokenTransfer(sender, recipient, amount);
357 
358         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
359         _balances[recipient] = _balances[recipient].add(amount);
360         emit Transfer(sender, recipient, amount);
361     }
362 
363     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
364      * the total supply.
365      *
366      * Emits a {Transfer} event with `from` set to the zero address.
367      *
368      * Requirements:
369      *
370      * - `account` cannot be the zero address.
371      */
372     function _mint(address account, uint256 amount) internal virtual {
373         require(account != address(0), "ERC20: mint to the zero address");
374 
375         _beforeTokenTransfer(address(0), account, amount);
376 
377         _totalSupply = _totalSupply.add(amount);
378         _balances[account] = _balances[account].add(amount);
379         emit Transfer(address(0), account, amount);
380     }
381 
382     /**
383      * @dev Destroys `amount` tokens from `account`, reducing the
384      * total supply.
385      *
386      * Emits a {Transfer} event with `to` set to the zero address.
387      *
388      * Requirements:
389      *
390      * - `account` cannot be the zero address.
391      * - `account` must have at least `amount` tokens.
392      */
393     function _burn(address account, uint256 amount) internal virtual {
394         require(account != address(0), "ERC20: burn from the zero address");
395 
396         _beforeTokenTransfer(account, address(0), amount);
397 
398         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
399         _totalSupply = _totalSupply.sub(amount);
400         emit Transfer(account, address(0), amount);
401     }
402 
403     /**
404      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
405      *
406      * This internal function is equivalent to `approve`, and can be used to
407      * e.g. set automatic allowances for certain subsystems, etc.
408      *
409      * Emits an {Approval} event.
410      *
411      * Requirements:
412      *
413      * - `owner` cannot be the zero address.
414      * - `spender` cannot be the zero address.
415      */
416     function _approve(
417         address owner,
418         address spender,
419         uint256 amount
420     ) internal virtual {
421         require(owner != address(0), "ERC20: approve from the zero address");
422         require(spender != address(0), "ERC20: approve to the zero address");
423 
424         _allowances[owner][spender] = amount;
425         emit Approval(owner, spender, amount);
426     }
427 
428     /**
429      * @dev Hook that is called before any transfer of tokens. This includes
430      * minting and burning.
431      *
432      * Calling conditions:
433      *
434      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
435      * will be to transferred to `to`.
436      * - when `from` is zero, `amount` tokens will be minted for `to`.
437      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
438      * - `from` and `to` are never both zero.
439      *
440      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
441      */
442     function _beforeTokenTransfer(
443         address from,
444         address to,
445         uint256 amount
446     ) internal virtual {}
447 }
448 
449 library SafeMath {
450     /**
451      * @dev Returns the addition of two unsigned integers, reverting on
452      * overflow.
453      *
454      * Counterpart to Solidity's `+` operator.
455      *
456      * Requirements:
457      *
458      * - Addition cannot overflow.
459      */
460     function add(uint256 a, uint256 b) internal pure returns (uint256) {
461         uint256 c = a + b;
462         require(c >= a, "SafeMath: addition overflow");
463 
464         return c;
465     }
466 
467     /**
468      * @dev Returns the subtraction of two unsigned integers, reverting on
469      * overflow (when the result is negative).
470      *
471      * Counterpart to Solidity's `-` operator.
472      *
473      * Requirements:
474      *
475      * - Subtraction cannot overflow.
476      */
477     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
478         return sub(a, b, "SafeMath: subtraction overflow");
479     }
480 
481     /**
482      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
483      * overflow (when the result is negative).
484      *
485      * Counterpart to Solidity's `-` operator.
486      *
487      * Requirements:
488      *
489      * - Subtraction cannot overflow.
490      */
491     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
492         require(b <= a, errorMessage);
493         uint256 c = a - b;
494 
495         return c;
496     }
497 
498     /**
499      * @dev Returns the multiplication of two unsigned integers, reverting on
500      * overflow.
501      *
502      * Counterpart to Solidity's `*` operator.
503      *
504      * Requirements:
505      *
506      * - Multiplication cannot overflow.
507      */
508     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
509         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
510         // benefit is lost if 'b' is also tested.
511         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
512         if (a == 0) {
513             return 0;
514         }
515 
516         uint256 c = a * b;
517         require(c / a == b, "SafeMath: multiplication overflow");
518 
519         return c;
520     }
521 
522     /**
523      * @dev Returns the integer division of two unsigned integers. Reverts on
524      * division by zero. The result is rounded towards zero.
525      *
526      * Counterpart to Solidity's `/` operator. Note: this function uses a
527      * `revert` opcode (which leaves remaining gas untouched) while Solidity
528      * uses an invalid opcode to revert (consuming all remaining gas).
529      *
530      * Requirements:
531      *
532      * - The divisor cannot be zero.
533      */
534     function div(uint256 a, uint256 b) internal pure returns (uint256) {
535         return div(a, b, "SafeMath: division by zero");
536     }
537 
538     /**
539      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
540      * division by zero. The result is rounded towards zero.
541      *
542      * Counterpart to Solidity's `/` operator. Note: this function uses a
543      * `revert` opcode (which leaves remaining gas untouched) while Solidity
544      * uses an invalid opcode to revert (consuming all remaining gas).
545      *
546      * Requirements:
547      *
548      * - The divisor cannot be zero.
549      */
550     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
551         require(b > 0, errorMessage);
552         uint256 c = a / b;
553         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
554 
555         return c;
556     }
557 
558     /**
559      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
560      * Reverts when dividing by zero.
561      *
562      * Counterpart to Solidity's `%` operator. This function uses a `revert`
563      * opcode (which leaves remaining gas untouched) while Solidity uses an
564      * invalid opcode to revert (consuming all remaining gas).
565      *
566      * Requirements:
567      *
568      * - The divisor cannot be zero.
569      */
570     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
571         return mod(a, b, "SafeMath: modulo by zero");
572     }
573 
574     /**
575      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
576      * Reverts with custom message when dividing by zero.
577      *
578      * Counterpart to Solidity's `%` operator. This function uses a `revert`
579      * opcode (which leaves remaining gas untouched) while Solidity uses an
580      * invalid opcode to revert (consuming all remaining gas).
581      *
582      * Requirements:
583      *
584      * - The divisor cannot be zero.
585      */
586     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
587         require(b != 0, errorMessage);
588         return a % b;
589     }
590 }
591 
592 contract Ownable is Context {
593     address private _owner;
594 
595     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
596     
597     /**
598      * @dev Initializes the contract setting the deployer as the initial owner.
599      */
600     constructor () {
601         address msgSender = _msgSender();
602         _owner = msgSender;
603         emit OwnershipTransferred(address(0), msgSender);
604     }
605 
606     /**
607      * @dev Returns the address of the current owner.
608      */
609     function owner() public view returns (address) {
610         return _owner;
611     }
612 
613     /**
614      * @dev Throws if called by any account other than the owner.
615      */
616     modifier onlyOwner() {
617         require(_owner == _msgSender(), "Ownable: caller is not the owner");
618         _;
619     }
620 
621     /**
622      * @dev Leaves the contract without owner. It will not be possible to call
623      * `onlyOwner` functions anymore. Can only be called by the current owner.
624      *
625      * NOTE: Renouncing ownership will leave the contract without an owner,
626      * thereby removing any functionality that is only available to the owner.
627      */
628     function renounceOwnership() public virtual onlyOwner {
629         emit OwnershipTransferred(_owner, address(0));
630         _owner = address(0);
631     }
632 
633     /**
634      * @dev Transfers ownership of the contract to a new account (`newOwner`).
635      * Can only be called by the current owner.
636      */
637     function transferOwnership(address newOwner) public virtual onlyOwner {
638         require(newOwner != address(0), "Ownable: new owner is the zero address");
639         emit OwnershipTransferred(_owner, newOwner);
640         _owner = newOwner;
641     }
642 }
643 
644 
645 
646 library SafeMathInt {
647     int256 private constant MIN_INT256 = int256(1) << 255;
648     int256 private constant MAX_INT256 = ~(int256(1) << 255);
649 
650     /**
651      * @dev Multiplies two int256 variables and fails on overflow.
652      */
653     function mul(int256 a, int256 b) internal pure returns (int256) {
654         int256 c = a * b;
655 
656         // Detect overflow when multiplying MIN_INT256 with -1
657         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
658         require((b == 0) || (c / b == a));
659         return c;
660     }
661 
662     /**
663      * @dev Division of two int256 variables and fails on overflow.
664      */
665     function div(int256 a, int256 b) internal pure returns (int256) {
666         // Prevent overflow when dividing MIN_INT256 by -1
667         require(b != -1 || a != MIN_INT256);
668 
669         // Solidity already throws when dividing by 0.
670         return a / b;
671     }
672 
673     /**
674      * @dev Subtracts two int256 variables and fails on overflow.
675      */
676     function sub(int256 a, int256 b) internal pure returns (int256) {
677         int256 c = a - b;
678         require((b >= 0 && c <= a) || (b < 0 && c > a));
679         return c;
680     }
681 
682     /**
683      * @dev Adds two int256 variables and fails on overflow.
684      */
685     function add(int256 a, int256 b) internal pure returns (int256) {
686         int256 c = a + b;
687         require((b >= 0 && c >= a) || (b < 0 && c < a));
688         return c;
689     }
690 
691     /**
692      * @dev Converts to absolute value, and fails on overflow.
693      */
694     function abs(int256 a) internal pure returns (int256) {
695         require(a != MIN_INT256);
696         return a < 0 ? -a : a;
697     }
698 
699 
700     function toUint256Safe(int256 a) internal pure returns (uint256) {
701         require(a >= 0);
702         return uint256(a);
703     }
704 }
705 
706 library SafeMathUint {
707   function toInt256Safe(uint256 a) internal pure returns (int256) {
708     int256 b = int256(a);
709     require(b >= 0);
710     return b;
711   }
712 }
713 
714 
715 interface IUniswapV2Router01 {
716     function factory() external pure returns (address);
717     function WETH() external pure returns (address);
718 
719     function addLiquidityETH(
720         address token,
721         uint amountTokenDesired,
722         uint amountTokenMin,
723         uint amountETHMin,
724         address to,
725         uint deadline
726     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
727 }
728 
729 interface IUniswapV2Router02 is IUniswapV2Router01 {
730     function swapExactTokensForETHSupportingFeeOnTransferTokens(
731         uint amountIn,
732         uint amountOutMin,
733         address[] calldata path,
734         address to,
735         uint deadline
736     ) external;
737 }
738 
739 contract Fusion is ERC20, Ownable {
740 
741     IUniswapV2Router02 public immutable uniswapV2Router;
742     address public immutable uniswapV2Pair;
743     address public constant deadAddress = address(0xdead);
744 
745     bool private swapping;
746 
747     address public marketingWallet;
748     address public devWallet;
749     
750     uint256 public maxTransactionAmount;
751     uint256 public swapTokensAtAmount;
752     uint256 public maxWallet;
753     
754     uint256 public percentForLPBurn = 25; // 25 = .25%
755     bool public lpBurnEnabled = false;
756     uint256 public lpBurnFrequency = 3600 seconds;
757     uint256 public lastLpBurnTime;
758     
759     uint256 public manualBurnFrequency = 30 minutes;
760     uint256 public lastManualLpBurnTime;
761 
762     bool public limitsInEffect = true;
763     bool public tradingActive = false;
764     bool public swapEnabled = false;
765     
766      // Anti-bot and anti-whale mappings and variables
767     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
768     mapping (address => bool) public isBlacklisted;
769     bool public transferDelayEnabled = true;
770 
771     uint256 public buyTotalFees;
772     uint256 public buyMarketingFee;
773     uint256 public buyLiquidityFee;
774     uint256 public buyDevFee;
775     
776     uint256 public sellTotalFees;
777     uint256 public sellMarketingFee;
778     uint256 public sellLiquidityFee;
779     uint256 public sellDevFee;
780     
781     uint256 public tokensForMarketing;
782     uint256 public tokensForLiquidity;
783     uint256 public tokensForDev;
784 
785     // exlcude from fees and max transaction amount
786     mapping (address => bool) private _isExcludedFromFees;
787     mapping (address => bool) public _isExcludedMaxTransactionAmount;
788 
789     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
790     // could be subject to a maximum transfer amount
791     mapping (address => bool) public automatedMarketMakerPairs;
792 
793     constructor() ERC20("Fusion Swap", "FUSION") {
794         
795         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
796         
797         excludeFromMaxTransaction(address(_uniswapV2Router), true);
798         uniswapV2Router = _uniswapV2Router;
799         
800         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
801         excludeFromMaxTransaction(address(uniswapV2Pair), true);
802         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
803         
804         uint256 _buyMarketingFee = 25;
805         uint256 _buyLiquidityFee = 0;
806         uint256 _buyDevFee = 0;
807 
808         uint256 _sellMarketingFee = 35;
809         uint256 _sellLiquidityFee = 0;
810         uint256 _sellDevFee = 0;
811         
812         uint256 totalSupply = 1000000000000 * 1e18; 
813         
814         maxTransactionAmount = totalSupply * 2 / 100; 
815         maxWallet = totalSupply * 2 / 100; 
816         swapTokensAtAmount = totalSupply * 5 / 1000; 
817 
818         buyMarketingFee = _buyMarketingFee;
819         buyLiquidityFee = _buyLiquidityFee;
820         buyDevFee = _buyDevFee;
821         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
822         
823         sellMarketingFee = _sellMarketingFee;
824         sellLiquidityFee = _sellLiquidityFee;
825         sellDevFee = _sellDevFee;
826         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
827         
828         marketingWallet = address(owner()); 
829         devWallet = address(owner()); // 
830 
831         // exclude from paying fees or having max transaction amount
832         excludeFromFees(owner(), true);
833         excludeFromFees(address(this), true);
834         excludeFromFees(address(0xdead), true);
835         
836         excludeFromMaxTransaction(owner(), true);
837         excludeFromMaxTransaction(address(this), true);
838         excludeFromMaxTransaction(address(0xdead), true);
839         
840         _mint(msg.sender, totalSupply);
841     }
842 
843     receive() external payable {
844 
845   	}
846 
847     // once enabled, can never be turned off
848     function openTrading() external onlyOwner {
849         tradingActive = true;
850         swapEnabled = true;
851         lastLpBurnTime = block.timestamp;
852     }
853     
854     // remove limits after token is stable
855     function removefusionlimits() external onlyOwner returns (bool){
856         limitsInEffect = false;
857         transferDelayEnabled = false;
858         return true;
859     }
860     
861     // change the minimum amount of tokens to sell from fees
862     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner returns (bool){
863   	    require(newAmount <= 1, "Swap amount cannot be higher than 1% total supply.");
864   	    swapTokensAtAmount = totalSupply() * newAmount / 100;
865   	    return true;
866   	}
867     
868     function updateMaxTxnAmount(uint256 txNum, uint256 walNum) external onlyOwner {
869         require(txNum >= 1, "Cannot set maxTransactionAmount lower than 1%");
870         maxTransactionAmount = (totalSupply() * txNum / 100)/1e18;
871         require(walNum >= 1, "Cannot set maxWallet lower than 1%");
872         maxWallet = (totalSupply() * walNum / 100)/1e18;
873     }
874 
875     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
876         _isExcludedMaxTransactionAmount[updAds] = isEx;
877     }
878     
879     // only use to disable contract sales if absolutely necessary (emergency use only)
880     function updateSwapEnabled(bool enabled) external onlyOwner(){
881         swapEnabled = enabled;
882     }
883     
884     function updateBuyFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _devFee) external onlyOwner {
885         buyMarketingFee = _marketingFee;
886         buyLiquidityFee = _liquidityFee;
887         buyDevFee = _devFee;
888         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
889         require(buyTotalFees <= 35, "Must keep fees at 20% or less");
890     }
891     
892     function updateSellFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _devFee) external onlyOwner {
893         sellMarketingFee = _marketingFee;
894         sellLiquidityFee = _liquidityFee;
895         sellDevFee = _devFee;
896         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
897         require(sellTotalFees <= 50, "Must keep fees at 25% or less");
898     }
899 
900     function excludeFromFees(address account, bool excluded) public onlyOwner {
901         _isExcludedFromFees[account] = excluded;
902     }
903 
904     function _setAutomatedMarketMakerPair(address pair, bool value) private {
905         automatedMarketMakerPairs[pair] = value;
906     }
907 
908     function updatemarketingWallet(address newMarketingWallet) external onlyOwner {
909         marketingWallet = newMarketingWallet;
910     }
911     
912     function updateDevelopmentWallet(address newWallet) external onlyOwner {
913         devWallet = newWallet;
914     }
915 
916     function isExcludedFromFees(address account) public view returns(bool) {
917         return _isExcludedFromFees[account];
918     }
919 
920     function updatefusion_bots(address _address, bool status) external onlyOwner {
921         require(_address != address(0),"Address should not be 0");
922         isBlacklisted[_address] = status;
923     }
924 
925     function _transfer(
926         address from,
927         address to,
928         uint256 amount
929     ) internal override {
930         require(from != address(0), "ERC20: transfer from the zero address");
931         require(to != address(0), "ERC20: transfer to the zero address");
932         require(!isBlacklisted[from] && !isBlacklisted[to],"Blacklisted");
933         
934          if(amount == 0) {
935             super._transfer(from, to, 0);
936             return;
937         }
938         
939         if(limitsInEffect){
940             if (
941                 from != owner() &&
942                 to != owner() &&
943                 to != address(0) &&
944                 to != address(0xdead) &&
945                 !swapping
946             ){
947                 if(!tradingActive){
948                     require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active.");
949                 }
950 
951                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.  
952                 if (transferDelayEnabled){
953                     if (to != owner() && to != address(uniswapV2Router) && to != address(uniswapV2Pair)){
954                         require(_holderLastTransferTimestamp[tx.origin] < block.number, "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed.");
955                         _holderLastTransferTimestamp[tx.origin] = block.number;
956                     }
957                 }
958                  
959                 //when buy
960                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
961                         require(amount <= maxTransactionAmount, "Buy transfer amount exceeds the maxTransactionAmount.");
962                         require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
963                 }
964                 
965                 //when sell
966                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
967                         require(amount <= maxTransactionAmount, "Sell transfer amount exceeds the maxTransactionAmount.");
968                 }
969                 else if(!_isExcludedMaxTransactionAmount[to]){
970                     require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
971                 }
972             }
973         }
974         
975 		uint256 contractTokenBalance = balanceOf(address(this));
976         
977         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
978 
979         if( 
980             canSwap &&
981             swapEnabled &&
982             !swapping &&
983             !automatedMarketMakerPairs[from] &&
984             !_isExcludedFromFees[from] &&
985             !_isExcludedFromFees[to]
986         ) {
987             swapping = true;
988             
989             swapBack();
990 
991             swapping = false;
992         }
993 
994         bool takeFee = !swapping;
995 
996         // if any account belongs to _isExcludedFromFee account then remove the fee
997         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
998             takeFee = false;
999         }
1000         
1001         uint256 fees = 0;
1002         // only take fees on buys/sells, do not take on wallet transfers
1003         if(takeFee){
1004             // on sell
1005             if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
1006                 fees = amount * sellTotalFees/100;
1007                 tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
1008                 tokensForDev += fees * sellDevFee / sellTotalFees;
1009                 tokensForMarketing += fees * sellMarketingFee / sellTotalFees;
1010             }
1011             // on buy
1012             else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1013         	    fees = amount * buyTotalFees/100;
1014         	    tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
1015                 tokensForDev += fees * buyDevFee / buyTotalFees;
1016                 tokensForMarketing += fees * buyMarketingFee / buyTotalFees;
1017             }
1018             
1019             if(fees > 0){    
1020                 super._transfer(from, address(this), fees);
1021             }
1022         	
1023         	amount -= fees;
1024         }
1025 
1026         super._transfer(from, to, amount);
1027     }
1028 
1029     function swapTokensForEth(uint256 tokenAmount) private {
1030 
1031         // generate the uniswap pair path of token -> weth
1032         address[] memory path = new address[](2);
1033         path[0] = address(this);
1034         path[1] = uniswapV2Router.WETH();
1035 
1036         _approve(address(this), address(uniswapV2Router), tokenAmount);
1037 
1038         // make the swap
1039         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1040             tokenAmount,
1041             0, // accept any amount of ETH
1042             path,
1043             address(this),
1044             block.timestamp
1045         );
1046         
1047     }
1048     
1049     
1050     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1051         // approve token transfer to cover all possible scenarios
1052         _approve(address(this), address(uniswapV2Router), tokenAmount);
1053 
1054         // add the liquidity
1055         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1056             address(this),
1057             tokenAmount,
1058             0, // slippage is unavoidable
1059             0, // slippage is unavoidable
1060             deadAddress,
1061             block.timestamp
1062         );
1063     }
1064 
1065     function swapBack() private {
1066         uint256 contractBalance = balanceOf(address(this));
1067         uint256 totalTokensToSwap = tokensForLiquidity + tokensForMarketing + tokensForDev;
1068         bool success;
1069         
1070         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
1071 
1072         if(contractBalance > swapTokensAtAmount * 20){
1073           contractBalance = swapTokensAtAmount * 20;
1074         }
1075         
1076         
1077         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
1078         uint256 amountToSwapForETH = contractBalance - liquidityTokens;
1079         
1080         uint256 initialETHBalance = address(this).balance;
1081 
1082         swapTokensForEth(amountToSwapForETH); 
1083         
1084         uint256 ethBalance = address(this).balance - initialETHBalance;
1085         
1086         uint256 ethForMarketing = ethBalance * tokensForMarketing/totalTokensToSwap;
1087         uint256 ethForDev = ethBalance * tokensForDev/totalTokensToSwap;
1088         
1089         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDev;
1090         
1091         tokensForLiquidity = 0;
1092         tokensForMarketing = 0;
1093         tokensForDev = 0;
1094         
1095         (success,) = address(devWallet).call{value: ethForDev}("");
1096         
1097         if(liquidityTokens > 0 && ethForLiquidity > 0){
1098             addLiquidity(liquidityTokens, ethForLiquidity);
1099         }
1100         
1101         (success,) = address(marketingWallet).call{value: address(this).balance}("");
1102     }
1103 
1104     function manualBurnLiquidityPairTokens(uint256 percent) external onlyOwner returns (bool){
1105         require(block.timestamp > lastManualLpBurnTime + manualBurnFrequency , "Must wait for cooldown to finish");
1106         require(percent <= 1000, "May not nuke more than 10% of tokens in LP");
1107         lastManualLpBurnTime = block.timestamp;
1108         
1109         
1110         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1111         
1112       
1113         uint256 amountToBurn = liquidityPairBalance * percent/10000;
1114         
1115         
1116         if (amountToBurn > 0){
1117             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1118         }
1119         
1120         
1121         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1122         pair.sync();
1123         return true;
1124     }
1125 }