1 /**
2  * 
3  *  .d8888b  .d8888b 8888b. 888d888 .d88b.  .d8888b888d888 .d88b. 888  888  888 
4  * 88K     d88P"       "88b888P"  d8P  Y8bd88P"   888P"  d88""88b888  888  888 
5  * "Y8888b.888     .d888888888    88888888888     888    888  888888  888  888 
6  *      X88Y88b.   888  888888    Y8b.    Y88b.   888    Y88..88PY88b 888 d88P 
7  *  88888P' "Y8888P"Y888888888     "Y8888  "Y8888P888     "Y88P"  "Y8888888P"  
8  *  
9  *                 ▓▓▓▓▓▓                              
10  *               ▓▓▓▓▓▓▓▓▓▓                            
11  *             ▓▓▓▓▓▓▓▓▓▓▓▓▓▓                          
12  *           ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓              ▒▒  ▒▒  ▒▒
13  *           ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓            ▒▒  ▒▒  ▒▒
14  *           ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓          ▒▒  ▒▒  ▒▒
15  *           ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓          ▒▒  ▒▒  ▒▒
16  *         ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓        ▒▒  ▒▒  ▒▒
17  *       ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓        ▒▒▒▒▒▒  
18  *           ██▒▒▒▒▒▒▒▒████▒▒▒▒▒▒████            ▓▓    
19  *           ██▒▒▒▒▒▒▒▒▒▒████▒▒██▒▒██            ▓▓    
20  *           ██▒▒▒▒▒▒▒▒▒▒████▒▒██▒▒██            ▓▓    
21  *             ██▒▒▒▒██▒▒▒▒▒▒▒▒▒▒▒▒██          ██▓▓    
22  *         ████▒▒██▒▒▒▒████▒▒▒▒▒▒██▒▒██████████▒▒██    
23  *       ██▓▓▓▓▒▒▒▒██▒▒▒▒▒▒▒▒▒▒██▒▒▒▒▓▓▓▓▓▓▓▓▒▒██▒▒██  
24  *     ██▓▓▓▓▓▓▓▓▒▒▒▒██████████▒▒▒▒▓▓▓▓▓▓▓▓▓▓▒▒██▒▒██  
25  *   ██▓▓▓▓▓▓▓▓██▓▓▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓▓▓▓▓▓▓▓▓▓▓▓▒▒██▒▒██  
26  *   ██▓▓▓▓██████▓▓▓▓▓▓▒▒▒▒▒▒▓▓████████████████████    
27  *   ██▓▓▓▓▒▒████▓▓▓▓▓▓▓▓▓▓▓▓▓▓██                ▓▓    
28  *   ██▒▒▒▒▒▒████▓▓▓▓▓▓▓▓▓▓▓▓▓▓██                ▓▓    
29  *     ██████  ██▒▒▒▒▒▒▒▒▒▒▒▒▒▒██                ▓▓    
30  *           ██▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓██              ▓▓    
31  *         ██▓▓▓▓▓▓▓▓▓▓██▓▓▓▓▓▓▓▓▓▓██            ▓▓    
32  *       ████▓▓▓▓▓▓▓▓██  ████▓▓▓▓▓▓████          ▓▓    
33  *   ████▒▒▒▒▒▒▒▒▒▒██      ██▒▒▒▒▒▒▒▒▒▒████      ▓▓    
34  * ██▒▒▒▒▒▒▒▒▒▒▒▒▒▒██      ██▒▒▒▒▒▒▒▒▒▒▒▒▒▒██    ▓▓    
35  * ██████████████████      ██████████████████    ▓▓    
36  *
37  *  
38  * ░██████╗██╗░░██╗██╗██████╗░  ██████╗░██████╗░░█████╗░████████╗███████╗░█████╗░████████╗░█████╗░██████╗░
39  * ██╔════╝██║░░██║██║██╔══██╗  ██╔══██╗██╔══██╗██╔══██╗╚══██╔══╝██╔════╝██╔══██╗╚══██╔══╝██╔══██╗██╔══██╗
40  * ╚█████╗░███████║██║██████╦╝  ██████╔╝██████╔╝██║░░██║░░░██║░░░█████╗░░██║░░╚═╝░░░██║░░░██║░░██║██████╔╝
41  * ░╚═══██╗██╔══██║██║██╔══██╗  ██╔═══╝░██╔══██╗██║░░██║░░░██║░░░██╔══╝░░██║░░██╗░░░██║░░░██║░░██║██╔══██╗
42  * ██████╔╝██║░░██║██║██████╦╝  ██║░░░░░██║░░██║╚█████╔╝░░░██║░░░███████╗╚█████╔╝░░░██║░░░╚█████╔╝██║░░██║
43  * ╚═════╝░╚═╝░░╚═╝╚═╝╚═════╝░  ╚═╝░░░░░╚═╝░░╚═╝░╚════╝░░░░╚═╝░░░╚══════╝░╚════╝░░░░╚═╝░░░░╚════╝░╚═╝░░╚═╝
44  * 
45  *
46  * Eagles, Vultures, Hawks or any other Predators, it's time to scare them all.
47  * SHIBARMY will never be defeated
48  * 20% of the tokens will be locked for Exchange Liquidity
49  * 💻 Website - https://www.shibprotector.com/
50  * 🐦 Twitter: https://twitter.com/ScarecrowETH
51  * 💬 Telegram: https://t.me/ScarecrowShibProtector
52  * 
53  * SPDX-License-Identifier: UNLICENSED 
54  * 
55 */
56 
57 pragma solidity 0.8.9;
58  
59 abstract contract Context {
60     function _msgSender() internal view virtual returns (address) {
61         return msg.sender;
62     }
63  
64     function _msgData() internal view virtual returns (bytes calldata) {
65         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
66         return msg.data;
67     }
68 }
69  
70 interface IUniswapV2Pair {
71     event Approval(address indexed owner, address indexed spender, uint value);
72     event Transfer(address indexed from, address indexed to, uint value);
73  
74     function name() external pure returns (string memory);
75     function symbol() external pure returns (string memory);
76     function decimals() external pure returns (uint8);
77     function totalSupply() external view returns (uint);
78     function balanceOf(address owner) external view returns (uint);
79     function allowance(address owner, address spender) external view returns (uint);
80  
81     function approve(address spender, uint value) external returns (bool);
82     function transfer(address to, uint value) external returns (bool);
83     function transferFrom(address from, address to, uint value) external returns (bool);
84  
85     function DOMAIN_SEPARATOR() external view returns (bytes32);
86     function PERMIT_TYPEHASH() external pure returns (bytes32);
87     function nonces(address owner) external view returns (uint);
88  
89     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
90  
91     event Mint(address indexed sender, uint amount0, uint amount1);
92     event Swap(
93         address indexed sender,
94         uint amount0In,
95         uint amount1In,
96         uint amount0Out,
97         uint amount1Out,
98         address indexed to
99     );
100     event Sync(uint112 reserve0, uint112 reserve1);
101  
102     function MINIMUM_LIQUIDITY() external pure returns (uint);
103     function factory() external view returns (address);
104     function token0() external view returns (address);
105     function token1() external view returns (address);
106     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
107     function price0CumulativeLast() external view returns (uint);
108     function price1CumulativeLast() external view returns (uint);
109     function kLast() external view returns (uint);
110  
111     function mint(address to) external returns (uint liquidity);
112     function burn(address to) external returns (uint amount0, uint amount1);
113     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
114     function skim(address to) external;
115     function sync() external;
116  
117     function initialize(address, address) external;
118 }
119  
120 interface IUniswapV2Factory {
121     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
122  
123     function feeTo() external view returns (address);
124     function feeToSetter() external view returns (address);
125  
126     function getPair(address tokenA, address tokenB) external view returns (address pair);
127     function allPairs(uint) external view returns (address pair);
128     function allPairsLength() external view returns (uint);
129  
130     function createPair(address tokenA, address tokenB) external returns (address pair);
131  
132     function setFeeTo(address) external;
133     function setFeeToSetter(address) external;
134 }
135  
136 interface IERC20 {
137     /**
138      * @dev Returns the amount of tokens in existence.
139      */
140     function totalSupply() external view returns (uint256);
141  
142     /**
143      * @dev Returns the amount of tokens owned by `account`.
144      */
145     function balanceOf(address account) external view returns (uint256);
146  
147     /**
148      * @dev Moves `amount` tokens from the caller's account to `recipient`.
149      *
150      * Returns a boolean value indicating whether the operation succeeded.
151      *
152      * Emits a {Transfer} event.
153      */
154     function transfer(address recipient, uint256 amount) external returns (bool);
155  
156     /**
157      * @dev Returns the remaining number of tokens that `spender` will be
158      * allowed to spend on behalf of `owner` through {transferFrom}. This is
159      * zero by default.
160      *
161      * This value changes when {approve} or {transferFrom} are called.
162      */
163     function allowance(address owner, address spender) external view returns (uint256);
164  
165     /**
166      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
167      *
168      * Returns a boolean value indicating whether the operation succeeded.
169      *
170      * IMPORTANT: Beware that changing an allowance with this method brings the risk
171      * that someone may use both the old and the new allowance by unfortunate
172      * transaction ordering. One possible solution to mitigate this race
173      * condition is to first reduce the spender's allowance to 0 and set the
174      * desired value afterwards:
175      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
176      *
177      * Emits an {Approval} event.
178      */
179     function approve(address spender, uint256 amount) external returns (bool);
180  
181     /**
182      * @dev Moves `amount` tokens from `sender` to `recipient` using the
183      * allowance mechanism. `amount` is then deducted from the caller's
184      * allowance.
185      *
186      * Returns a boolean value indicating whether the operation succeeded.
187      *
188      * Emits a {Transfer} event.
189      */
190     function transferFrom(
191         address sender,
192         address recipient,
193         uint256 amount
194     ) external returns (bool);
195  
196     /**
197      * @dev Emitted when `value` tokens are moved from one account (`from`) to
198      * another (`to`).
199      *
200      * Note that `value` may be zero.
201      */
202     event Transfer(address indexed from, address indexed to, uint256 value);
203  
204     /**
205      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
206      * a call to {approve}. `value` is the new allowance.
207      */
208     event Approval(address indexed owner, address indexed spender, uint256 value);
209 }
210  
211 interface IERC20Metadata is IERC20 {
212     /**
213      * @dev Returns the name of the token.
214      */
215     function name() external view returns (string memory);
216  
217     /**
218      * @dev Returns the symbol of the token.
219      */
220     function symbol() external view returns (string memory);
221  
222     /**
223      * @dev Returns the decimals places of the token.
224      */
225     function decimals() external view returns (uint8);
226 }
227  
228  
229 contract ERC20 is Context, IERC20, IERC20Metadata {
230     using SafeMath for uint256;
231  
232     mapping(address => uint256) private _balances;
233  
234     mapping(address => mapping(address => uint256)) private _allowances;
235  
236     uint256 private _totalSupply;
237  
238     string private _name;
239     string private _symbol;
240  
241     /**
242      * @dev Sets the values for {name} and {symbol}.
243      *
244      * The default value of {decimals} is 18. To select a different value for
245      * {decimals} you should overload it.
246      *
247      * All two of these values are immutable: they can only be set once during
248      * construction.
249      */
250     constructor(string memory name_, string memory symbol_) {
251         _name = name_;
252         _symbol = symbol_;
253     }
254  
255     /**
256      * @dev Returns the name of the token.
257      */
258     function name() public view virtual override returns (string memory) {
259         return _name;
260     }
261  
262     /**
263      * @dev Returns the symbol of the token, usually a shorter version of the
264      * name.
265      */
266     function symbol() public view virtual override returns (string memory) {
267         return _symbol;
268     }
269  
270     /**
271      * @dev Returns the number of decimals used to get its user representation.
272      * For example, if `decimals` equals `2`, a balance of `505` tokens should
273      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
274      *
275      * Tokens usually opt for a value of 18, imitating the relationship between
276      * Ether and Wei. This is the value {ERC20} uses, unless this function is
277      * overridden;
278      *
279      * NOTE: This information is only used for _display_ purposes: it in
280      * no way affects any of the arithmetic of the contract, including
281      * {IERC20-balanceOf} and {IERC20-transfer}.
282      */
283     function decimals() public view virtual override returns (uint8) {
284         return 18;
285     }
286  
287     /**
288      * @dev See {IERC20-totalSupply}.
289      */
290     function totalSupply() public view virtual override returns (uint256) {
291         return _totalSupply;
292     }
293  
294     /**
295      * @dev See {IERC20-balanceOf}.
296      */
297     function balanceOf(address account) public view virtual override returns (uint256) {
298         return _balances[account];
299     }
300  
301     /**
302      * @dev See {IERC20-transfer}.
303      *
304      * Requirements:
305      *
306      * - `recipient` cannot be the zero address.
307      * - the caller must have a balance of at least `amount`.
308      */
309     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
310         _transfer(_msgSender(), recipient, amount);
311         return true;
312     }
313  
314     /**
315      * @dev See {IERC20-allowance}.
316      */
317     function allowance(address owner, address spender) public view virtual override returns (uint256) {
318         return _allowances[owner][spender];
319     }
320  
321     /**
322      * @dev See {IERC20-approve}.
323      *
324      * Requirements:
325      *
326      * - `spender` cannot be the zero address.
327      */
328     function approve(address spender, uint256 amount) public virtual override returns (bool) {
329         _approve(_msgSender(), spender, amount);
330         return true;
331     }
332  
333     /**
334      * @dev See {IERC20-transferFrom}.
335      *
336      * Emits an {Approval} event indicating the updated allowance. This is not
337      * required by the EIP. See the note at the beginning of {ERC20}.
338      *
339      * Requirements:
340      *
341      * - `sender` and `recipient` cannot be the zero address.
342      * - `sender` must have a balance of at least `amount`.
343      * - the caller must have allowance for ``sender``'s tokens of at least
344      * `amount`.
345      */
346     function transferFrom(
347         address sender,
348         address recipient,
349         uint256 amount
350     ) public virtual override returns (bool) {
351         _transfer(sender, recipient, amount);
352         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
353         return true;
354     }
355  
356     /**
357      * @dev Atomically increases the allowance granted to `spender` by the caller.
358      *
359      * This is an alternative to {approve} that can be used as a mitigation for
360      * problems described in {IERC20-approve}.
361      *
362      * Emits an {Approval} event indicating the updated allowance.
363      *
364      * Requirements:
365      *
366      * - `spender` cannot be the zero address.
367      */
368     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
369         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
370         return true;
371     }
372  
373     /**
374      * @dev Atomically decreases the allowance granted to `spender` by the caller.
375      *
376      * This is an alternative to {approve} that can be used as a mitigation for
377      * problems described in {IERC20-approve}.
378      *
379      * Emits an {Approval} event indicating the updated allowance.
380      *
381      * Requirements:
382      *
383      * - `spender` cannot be the zero address.
384      * - `spender` must have allowance for the caller of at least
385      * `subtractedValue`.
386      */
387     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
388         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
389         return true;
390     }
391  
392     /**
393      * @dev Moves tokens `amount` from `sender` to `recipient`.
394      *
395      * This is internal function is equivalent to {transfer}, and can be used to
396      * e.g. implement automatic token fees, slashing mechanisms, etc.
397      *
398      * Emits a {Transfer} event.
399      *
400      * Requirements:
401      *
402      * - `sender` cannot be the zero address.
403      * - `recipient` cannot be the zero address.
404      * - `sender` must have a balance of at least `amount`.
405      */
406     function _transfer(
407         address sender,
408         address recipient,
409         uint256 amount
410     ) internal virtual {
411         require(sender != address(0), "ERC20: transfer from the zero address");
412         require(recipient != address(0), "ERC20: transfer to the zero address");
413  
414         _beforeTokenTransfer(sender, recipient, amount);
415  
416         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
417         _balances[recipient] = _balances[recipient].add(amount);
418         emit Transfer(sender, recipient, amount);
419     }
420  
421     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
422      * the total supply.
423      *
424      * Emits a {Transfer} event with `from` set to the zero address.
425      *
426      * Requirements:
427      *
428      * - `account` cannot be the zero address.
429      */
430     function _mint(address account, uint256 amount) internal virtual {
431         require(account != address(0), "ERC20: mint to the zero address");
432  
433         _beforeTokenTransfer(address(0), account, amount);
434  
435         _totalSupply = _totalSupply.add(amount);
436         _balances[account] = _balances[account].add(amount);
437         emit Transfer(address(0), account, amount);
438     }
439  
440     /**
441      * @dev Destroys `amount` tokens from `account`, reducing the
442      * total supply.
443      *
444      * Emits a {Transfer} event with `to` set to the zero address.
445      *
446      * Requirements:
447      *
448      * - `account` cannot be the zero address.
449      * - `account` must have at least `amount` tokens.
450      */
451     function _burn(address account, uint256 amount) internal virtual {
452         require(account != address(0), "ERC20: burn from the zero address");
453  
454         _beforeTokenTransfer(account, address(0), amount);
455  
456         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
457         _totalSupply = _totalSupply.sub(amount);
458         emit Transfer(account, address(0), amount);
459     }
460  
461     /**
462      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
463      *
464      * This internal function is equivalent to `approve`, and can be used to
465      * e.g. set automatic allowances for certain subsystems, etc.
466      *
467      * Emits an {Approval} event.
468      *
469      * Requirements:
470      *
471      * - `owner` cannot be the zero address.
472      * - `spender` cannot be the zero address.
473      */
474     function _approve(
475         address owner,
476         address spender,
477         uint256 amount
478     ) internal virtual {
479         require(owner != address(0), "ERC20: approve from the zero address");
480         require(spender != address(0), "ERC20: approve to the zero address");
481  
482         _allowances[owner][spender] = amount;
483         emit Approval(owner, spender, amount);
484     }
485  
486     /**
487      * @dev Hook that is called before any transfer of tokens. This includes
488      * minting and burning.
489      *
490      * Calling conditions:
491      *
492      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
493      * will be to transferred to `to`.
494      * - when `from` is zero, `amount` tokens will be minted for `to`.
495      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
496      * - `from` and `to` are never both zero.
497      *
498      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
499      */
500     function _beforeTokenTransfer(
501         address from,
502         address to,
503         uint256 amount
504     ) internal virtual {}
505 }
506  
507 library SafeMath {
508     /**
509      * @dev Returns the addition of two unsigned integers, reverting on
510      * overflow.
511      *
512      * Counterpart to Solidity's `+` operator.
513      *
514      * Requirements:
515      *
516      * - Addition cannot overflow.
517      */
518     function add(uint256 a, uint256 b) internal pure returns (uint256) {
519         uint256 c = a + b;
520         require(c >= a, "SafeMath: addition overflow");
521  
522         return c;
523     }
524  
525     /**
526      * @dev Returns the subtraction of two unsigned integers, reverting on
527      * overflow (when the result is negative).
528      *
529      * Counterpart to Solidity's `-` operator.
530      *
531      * Requirements:
532      *
533      * - Subtraction cannot overflow.
534      */
535     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
536         return sub(a, b, "SafeMath: subtraction overflow");
537     }
538  
539     /**
540      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
541      * overflow (when the result is negative).
542      *
543      * Counterpart to Solidity's `-` operator.
544      *
545      * Requirements:
546      *
547      * - Subtraction cannot overflow.
548      */
549     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
550         require(b <= a, errorMessage);
551         uint256 c = a - b;
552  
553         return c;
554     }
555  
556     /**
557      * @dev Returns the multiplication of two unsigned integers, reverting on
558      * overflow.
559      *
560      * Counterpart to Solidity's `*` operator.
561      *
562      * Requirements:
563      *
564      * - Multiplication cannot overflow.
565      */
566     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
567         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
568         // benefit is lost if 'b' is also tested.
569         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
570         if (a == 0) {
571             return 0;
572         }
573  
574         uint256 c = a * b;
575         require(c / a == b, "SafeMath: multiplication overflow");
576  
577         return c;
578     }
579  
580     /**
581      * @dev Returns the integer division of two unsigned integers. Reverts on
582      * division by zero. The result is rounded towards zero.
583      *
584      * Counterpart to Solidity's `/` operator. Note: this function uses a
585      * `revert` opcode (which leaves remaining gas untouched) while Solidity
586      * uses an invalid opcode to revert (consuming all remaining gas).
587      *
588      * Requirements:
589      *
590      * - The divisor cannot be zero.
591      */
592     function div(uint256 a, uint256 b) internal pure returns (uint256) {
593         return div(a, b, "SafeMath: division by zero");
594     }
595  
596     /**
597      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
598      * division by zero. The result is rounded towards zero.
599      *
600      * Counterpart to Solidity's `/` operator. Note: this function uses a
601      * `revert` opcode (which leaves remaining gas untouched) while Solidity
602      * uses an invalid opcode to revert (consuming all remaining gas).
603      *
604      * Requirements:
605      *
606      * - The divisor cannot be zero.
607      */
608     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
609         require(b > 0, errorMessage);
610         uint256 c = a / b;
611         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
612  
613         return c;
614     }
615  
616     /**
617      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
618      * Reverts when dividing by zero.
619      *
620      * Counterpart to Solidity's `%` operator. This function uses a `revert`
621      * opcode (which leaves remaining gas untouched) while Solidity uses an
622      * invalid opcode to revert (consuming all remaining gas).
623      *
624      * Requirements:
625      *
626      * - The divisor cannot be zero.
627      */
628     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
629         return mod(a, b, "SafeMath: modulo by zero");
630     }
631  
632     /**
633      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
634      * Reverts with custom message when dividing by zero.
635      *
636      * Counterpart to Solidity's `%` operator. This function uses a `revert`
637      * opcode (which leaves remaining gas untouched) while Solidity uses an
638      * invalid opcode to revert (consuming all remaining gas).
639      *
640      * Requirements:
641      *
642      * - The divisor cannot be zero.
643      */
644     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
645         require(b != 0, errorMessage);
646         return a % b;
647     }
648 }
649  
650 contract Ownable is Context {
651     address private _owner;
652  
653     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
654  
655     /**
656      * @dev Initializes the contract setting the deployer as the initial owner.
657      */
658     constructor () {
659         address msgSender = _msgSender();
660         _owner = msgSender;
661         emit OwnershipTransferred(address(0), msgSender);
662     }
663  
664     /**
665      * @dev Returns the address of the current owner.
666      */
667     function owner() public view returns (address) {
668         return _owner;
669     }
670  
671     /**
672      * @dev Throws if called by any account other than the owner.
673      */
674     modifier onlyOwner() {
675         require(_owner == _msgSender(), "Ownable: caller is not the owner");
676         _;
677     }
678  
679     /**
680      * @dev Leaves the contract without owner. It will not be possible to call
681      * `onlyOwner` functions anymore. Can only be called by the current owner.
682      *
683      * NOTE: Renouncing ownership will leave the contract without an owner,
684      * thereby removing any functionality that is only available to the owner.
685      */
686     function renounceOwnership() public virtual onlyOwner {
687         emit OwnershipTransferred(_owner, address(0));
688         _owner = address(0);
689     }
690  
691     /**
692      * @dev Transfers ownership of the contract to a new account (`newOwner`).
693      * Can only be called by the current owner.
694      */
695     function transferOwnership(address newOwner) public virtual onlyOwner {
696         require(newOwner != address(0), "Ownable: new owner is the zero address");
697         emit OwnershipTransferred(_owner, newOwner);
698         _owner = newOwner;
699     }
700 }
701  
702  
703  
704 library SafeMathInt {
705     int256 private constant MIN_INT256 = int256(1) << 255;
706     int256 private constant MAX_INT256 = ~(int256(1) << 255);
707  
708     /**
709      * @dev Multiplies two int256 variables and fails on overflow.
710      */
711     function mul(int256 a, int256 b) internal pure returns (int256) {
712         int256 c = a * b;
713  
714         // Detect overflow when multiplying MIN_INT256 with -1
715         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
716         require((b == 0) || (c / b == a));
717         return c;
718     }
719  
720     /**
721      * @dev Division of two int256 variables and fails on overflow.
722      */
723     function div(int256 a, int256 b) internal pure returns (int256) {
724         // Prevent overflow when dividing MIN_INT256 by -1
725         require(b != -1 || a != MIN_INT256);
726  
727         // Solidity already throws when dividing by 0.
728         return a / b;
729     }
730  
731     /**
732      * @dev Subtracts two int256 variables and fails on overflow.
733      */
734     function sub(int256 a, int256 b) internal pure returns (int256) {
735         int256 c = a - b;
736         require((b >= 0 && c <= a) || (b < 0 && c > a));
737         return c;
738     }
739  
740     /**
741      * @dev Adds two int256 variables and fails on overflow.
742      */
743     function add(int256 a, int256 b) internal pure returns (int256) {
744         int256 c = a + b;
745         require((b >= 0 && c >= a) || (b < 0 && c < a));
746         return c;
747     }
748  
749     /**
750      * @dev Converts to absolute value, and fails on overflow.
751      */
752     function abs(int256 a) internal pure returns (int256) {
753         require(a != MIN_INT256);
754         return a < 0 ? -a : a;
755     }
756  
757  
758     function toUint256Safe(int256 a) internal pure returns (uint256) {
759         require(a >= 0);
760         return uint256(a);
761     }
762 }
763  
764 library SafeMathUint {
765   function toInt256Safe(uint256 a) internal pure returns (int256) {
766     int256 b = int256(a);
767     require(b >= 0);
768     return b;
769   }
770 }
771  
772  
773 interface IUniswapV2Router01 {
774     function factory() external pure returns (address);
775     function WETH() external pure returns (address);
776  
777     function addLiquidity(
778         address tokenA,
779         address tokenB,
780         uint amountADesired,
781         uint amountBDesired,
782         uint amountAMin,
783         uint amountBMin,
784         address to,
785         uint deadline
786     ) external returns (uint amountA, uint amountB, uint liquidity);
787     function addLiquidityETH(
788         address token,
789         uint amountTokenDesired,
790         uint amountTokenMin,
791         uint amountETHMin,
792         address to,
793         uint deadline
794     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
795     function removeLiquidity(
796         address tokenA,
797         address tokenB,
798         uint liquidity,
799         uint amountAMin,
800         uint amountBMin,
801         address to,
802         uint deadline
803     ) external returns (uint amountA, uint amountB);
804     function removeLiquidityETH(
805         address token,
806         uint liquidity,
807         uint amountTokenMin,
808         uint amountETHMin,
809         address to,
810         uint deadline
811     ) external returns (uint amountToken, uint amountETH);
812     function removeLiquidityWithPermit(
813         address tokenA,
814         address tokenB,
815         uint liquidity,
816         uint amountAMin,
817         uint amountBMin,
818         address to,
819         uint deadline,
820         bool approveMax, uint8 v, bytes32 r, bytes32 s
821     ) external returns (uint amountA, uint amountB);
822     function removeLiquidityETHWithPermit(
823         address token,
824         uint liquidity,
825         uint amountTokenMin,
826         uint amountETHMin,
827         address to,
828         uint deadline,
829         bool approveMax, uint8 v, bytes32 r, bytes32 s
830     ) external returns (uint amountToken, uint amountETH);
831     function swapExactTokensForTokens(
832         uint amountIn,
833         uint amountOutMin,
834         address[] calldata path,
835         address to,
836         uint deadline
837     ) external returns (uint[] memory amounts);
838     function swapTokensForExactTokens(
839         uint amountOut,
840         uint amountInMax,
841         address[] calldata path,
842         address to,
843         uint deadline
844     ) external returns (uint[] memory amounts);
845     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
846         external
847         payable
848         returns (uint[] memory amounts);
849     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
850         external
851         returns (uint[] memory amounts);
852     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
853         external
854         returns (uint[] memory amounts);
855     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
856         external
857         payable
858         returns (uint[] memory amounts);
859  
860     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
861     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
862     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
863     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
864     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
865 }
866  
867 interface IUniswapV2Router02 is IUniswapV2Router01 {
868     function removeLiquidityETHSupportingFeeOnTransferTokens(
869         address token,
870         uint liquidity,
871         uint amountTokenMin,
872         uint amountETHMin,
873         address to,
874         uint deadline
875     ) external returns (uint amountETH);
876     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
877         address token,
878         uint liquidity,
879         uint amountTokenMin,
880         uint amountETHMin,
881         address to,
882         uint deadline,
883         bool approveMax, uint8 v, bytes32 r, bytes32 s
884     ) external returns (uint amountETH);
885  
886     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
887         uint amountIn,
888         uint amountOutMin,
889         address[] calldata path,
890         address to,
891         uint deadline
892     ) external;
893     function swapExactETHForTokensSupportingFeeOnTransferTokens(
894         uint amountOutMin,
895         address[] calldata path,
896         address to,
897         uint deadline
898     ) external payable;
899     function swapExactTokensForETHSupportingFeeOnTransferTokens(
900         uint amountIn,
901         uint amountOutMin,
902         address[] calldata path,
903         address to,
904         uint deadline
905     ) external;
906 }
907  
908 contract Scarecrow is ERC20, Ownable {
909     using SafeMath for uint256;
910  
911     IUniswapV2Router02 private uniswapV2Router;
912     address private uniswapV2Pair;
913  
914     bool private swapping;
915  
916     address private marketingWallet;
917     address private devWallet;
918  
919     uint256 public maxTransactionAmount;
920     uint256 public swapTokensAtAmount;
921     uint256 public maxWallet;
922  
923     bool public limitsInEffect = true;
924     bool public tradingActive = false;
925     bool public swapEnabled = false;
926     bool public enableEarlySellTax = true;
927     bool public swapSHIB = true;
928  
929      // Anti-bot and anti-whale mappings and variables
930     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
931  
932     // Seller Map
933     mapping (address => uint256) private _holderFirstBuyTimestamp;
934  
935     // Blacklist Map
936     mapping (address => bool) private _blacklist;
937     bool public transferDelayEnabled = true;
938  
939     uint256 public buyTotalFees;
940     uint256 public buyMarketingFee;
941     uint256 public buyLiquidityFee;
942     uint256 public buyDevFee;
943  
944     uint256 public sellTotalFees;
945     uint256 public sellMarketingFee;
946     uint256 public sellLiquidityFee;
947     uint256 public sellDevFee;
948     uint256 public sellShibBuyFee;
949  
950     uint256 public earlySellLiquidityFee;
951     uint256 public earlySellMarketingFee;
952     uint256 public earlySellDevFee;
953     uint256 public earlySellShibBuyFee;
954  
955     uint256 public tokensForMarketing;
956     uint256 public tokensForLiquidity;
957     uint256 public tokensForDev;
958     uint256 public tokensForBuyingShib;
959     address public constant SHIB=0x95aD61b0a150d79219dCF64E1E6Cc01f0B64C4cE; //mainnet
960     //dead address of SHIB
961     address payable private shib_burn_address = payable(0xdEAD000000000000000042069420694206942069); 
962 
963     
964 
965     // block number of opened trading
966     uint256 launchedAt;
967  
968     /******************/
969  
970     // exclude from fees and max transaction amount
971     mapping (address => bool) private _isExcludedFromFees;
972     mapping (address => bool) public _isExcludedMaxTransactionAmount;
973  
974     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
975     // could be subject to a maximum transfer amount
976     mapping (address => bool) public automatedMarketMakerPairs;
977  
978     event UpdateUniswapV2Router(address indexed newAddress, address indexed oldAddress);
979  
980     event ExcludeFromFees(address indexed account, bool isExcluded);
981  
982     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
983  
984     event marketingWalletUpdated(address indexed newWallet, address indexed oldWallet);
985  
986     event devWalletUpdated(address indexed newWallet, address indexed oldWallet);
987     
988     event BuyAndBurnShib(
989         uint256 amountIn,
990         address[] path
991     );
992  
993     event SwapAndLiquify(
994         uint256 tokensSwapped,
995         uint256 ethReceived,
996         uint256 tokensIntoLiquidity
997     );
998  
999     event AutoNukeLP();
1000  
1001     event ManualNukeLP();
1002  
1003     constructor(address payable _devFeeAddress, address payable _marketingWalletAddress) ERC20("Shib Protector", "SCARECROW") {
1004  
1005         uint256 _buyMarketingFee = 0;
1006         uint256 _buyLiquidityFee = 0;
1007         uint256 _buyDevFee = 0;
1008  
1009         uint256 _sellMarketingFee = 0;
1010         uint256 _sellLiquidityFee = 0;
1011         uint256 _sellDevFee = 0;
1012  
1013         uint256 _earlySellLiquidityFee = 2;
1014         uint256 _earlySellMarketingFee = 3;
1015 	    uint256 _earlySellDevFee = 3;
1016         uint256 _earlyShibBuyFee = 2;
1017  
1018         uint256 totalSupply = 1 * 1e12 * 1e18;
1019 
1020         maxTransactionAmount = totalSupply * 5 / 1000; // 0.5% maxTransactionAmountTxn
1021         maxWallet = totalSupply * 15 / 1000; // 1.5% maxWallet
1022         swapTokensAtAmount = totalSupply * 10 / 10000; // 0.1% swap wallet
1023  
1024         buyMarketingFee = _buyMarketingFee;
1025         buyLiquidityFee = _buyLiquidityFee;
1026         buyDevFee = _buyDevFee;
1027         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
1028  
1029         sellMarketingFee = _sellMarketingFee;
1030         sellLiquidityFee = _sellLiquidityFee;
1031         sellDevFee = _sellDevFee;
1032         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1033  
1034         earlySellLiquidityFee = _earlySellLiquidityFee;
1035         earlySellMarketingFee = _earlySellMarketingFee;
1036 	    earlySellDevFee = _earlySellDevFee;
1037         earlySellShibBuyFee = _earlyShibBuyFee;
1038  
1039         marketingWallet = _marketingWalletAddress; 
1040         devWallet = _devFeeAddress; 
1041  
1042         // exclude from paying fees or having max transaction amount
1043         excludeFromFees(owner(), true);
1044         excludeFromFees(address(this), true);
1045         excludeFromFees(address(0xdead), true);
1046         excludeFromFees(address(shib_burn_address), true);
1047         excludeFromFees(marketingWallet, true);
1048         excludeFromFees(devWallet, true);
1049  
1050         excludeFromMaxTransaction(owner(), true);
1051         excludeFromMaxTransaction(address(this), true);
1052         excludeFromMaxTransaction(address(0xdead), true);
1053         excludeFromMaxTransaction(address(shib_burn_address), true);
1054         excludeFromMaxTransaction(marketingWallet, true);
1055         excludeFromMaxTransaction(devWallet, true);
1056         /*
1057             _mint is an internal function in ERC20.sol that is only called here,
1058             and CANNOT be called ever again
1059         */
1060         _mint(msg.sender, totalSupply);
1061     }
1062  
1063     receive() external payable {
1064  
1065     }
1066  
1067     // once enabled, can never be turned off
1068     function enableTrading() external onlyOwner {
1069         require(!tradingActive,"Trading is already open");
1070         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
1071         excludeFromMaxTransaction(address(_uniswapV2Router), true);
1072         uniswapV2Router = _uniswapV2Router;
1073         _approve(address(this), address(_uniswapV2Router), totalSupply());
1074         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
1075         excludeFromMaxTransaction(address(uniswapV2Pair), true);
1076         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true); 
1077         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
1078         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
1079         tradingActive = true;
1080         swapEnabled = true;
1081         launchedAt = block.number;
1082     }
1083  
1084     // remove limits after token is stable
1085     function removeLimits() external onlyOwner returns (bool){
1086         limitsInEffect = false;
1087         return true;
1088     }
1089  
1090     // disable Transfer delay - cannot be reenabled
1091     function disableTransferDelay() external onlyOwner returns (bool){
1092         transferDelayEnabled = false;
1093         return true;
1094     }
1095  
1096     function setEarlySellTax(bool onoff) external onlyOwner  {
1097         enableEarlySellTax = onoff;
1098     }
1099  
1100      // change the minimum amount of tokens to sell from fees
1101     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner returns (bool){
1102         require(newAmount >= totalSupply() * 1 / 100000, "Swap amount cannot be lower than 0.001% total supply.");
1103         require(newAmount <= totalSupply() * 5 / 1000, "Swap amount cannot be higher than 0.5% total supply.");
1104         swapTokensAtAmount = newAmount;
1105         return true;
1106     }
1107  
1108     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
1109         require(newNum >= (totalSupply() * 1 / 1000)/1e18, "Cannot set maxTransactionAmount lower than 0.1%");
1110         maxTransactionAmount = newNum * (10**18);
1111     }
1112  
1113     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
1114         require(newNum >= (totalSupply() * 5 / 1000)/1e18, "Cannot set maxWallet lower than 0.5%");
1115         maxWallet = newNum * (10**18);
1116     }
1117  
1118     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
1119         _isExcludedMaxTransactionAmount[updAds] = isEx;
1120     }
1121  
1122     // only use to disable contract sales if absolutely necessary (emergency use only)
1123     function updateSwapEnabled(bool enabled) external onlyOwner(){
1124         swapEnabled = enabled;
1125     }
1126 
1127     //Worst case if the SHIB autoswap doesn't work on mainnet
1128     function updateDirectSwapShib(bool enabled) external onlyOwner() {
1129         swapSHIB = enabled;
1130     }
1131  
1132  
1133     function updateEarlySellFees(uint256 _earlySellLiquidityFee, uint256 _earlySellMarketingFee, uint256 _earlySellDevFee, uint256 _earlyShibBuyFee) external onlyOwner {
1134         earlySellLiquidityFee = _earlySellLiquidityFee;
1135         earlySellMarketingFee = _earlySellMarketingFee;
1136 	    earlySellDevFee = _earlySellDevFee;
1137         earlySellShibBuyFee = _earlyShibBuyFee;
1138         require(earlySellLiquidityFee + earlySellMarketingFee + earlySellDevFee + _earlyShibBuyFee <= 25, "Must keep fees at 25% or less");
1139     }
1140  
1141     function excludeFromFees(address account, bool excluded) public onlyOwner {
1142         _isExcludedFromFees[account] = excluded;
1143         emit ExcludeFromFees(account, excluded);
1144     }
1145  
1146     function blacklistAccount(address account, bool isBlacklisted) public onlyOwner {
1147         //Cannot blacklist after 60 blocks, roughly 15 mins 
1148         if (block.number <= launchedAt + 60) {
1149             _blacklist[account] = isBlacklisted;
1150         }
1151     }
1152  
1153     function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
1154         require(pair != uniswapV2Pair, "The pair cannot be removed from automatedMarketMakerPairs");
1155         _setAutomatedMarketMakerPair(pair, value);
1156     }
1157  
1158     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1159         automatedMarketMakerPairs[pair] = value;
1160         emit SetAutomatedMarketMakerPair(pair, value);
1161     }
1162  
1163     function updateMarketingWallet(address newMarketingWallet) external onlyOwner {
1164         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
1165         marketingWallet = newMarketingWallet;
1166     }
1167  
1168     function updateDevWallet(address newWallet) external onlyOwner {
1169         emit devWalletUpdated(newWallet, devWallet);
1170         devWallet = newWallet;
1171     }
1172  
1173  
1174     function isExcludedFromFees(address account) public view returns(bool) {
1175         return _isExcludedFromFees[account];
1176     }
1177  
1178     event BoughtEarly(address indexed sniper);
1179  
1180     function _transfer(
1181         address from,
1182         address to,
1183         uint256 amount
1184     ) internal override {
1185         require(from != address(0), "ERC20: transfer from the zero address");
1186         require(to != address(0), "ERC20: transfer to the zero address");
1187         require(!_blacklist[to] && !_blacklist[from], "You have been blacklisted from transfering tokens");
1188          if(amount == 0) {
1189             super._transfer(from, to, 0);
1190             return;
1191         }
1192  
1193         if(limitsInEffect){
1194             if (
1195                 from != owner() &&
1196                 to != owner() &&
1197                 to != address(0) &&
1198                 to != address(0xdead) &&
1199                 !swapping
1200             ){
1201                 if(!tradingActive){
1202                     require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active.");
1203                 }
1204  
1205                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.  
1206                 if (transferDelayEnabled){
1207                     if (to != owner() && to != address(uniswapV2Router) && to != address(uniswapV2Pair)){
1208                         require(_holderLastTransferTimestamp[tx.origin] < block.number, "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed.");
1209                         _holderLastTransferTimestamp[tx.origin] = block.number;
1210                     }
1211                 }
1212  
1213                 //when buy
1214                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
1215                         require(amount <= maxTransactionAmount, "Buy transfer amount exceeds the maxTransactionAmount.");
1216                         require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
1217                 }
1218  
1219                 //when sell
1220                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
1221                         require(amount <= maxTransactionAmount, "Sell transfer amount exceeds the maxTransactionAmount.");
1222                 }
1223                 else if(!_isExcludedMaxTransactionAmount[to]){
1224                     require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
1225                 }
1226             }
1227         }
1228  
1229         // anti bot logic
1230         if (block.number <= (launchedAt + 4) && 
1231                 to != uniswapV2Pair && 
1232                 to != address(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D)
1233             ) { 
1234             _blacklist[to] = true;
1235         }
1236  
1237         // early sell logic
1238         bool isBuy = from == uniswapV2Pair;
1239         if (!isBuy && enableEarlySellTax) {
1240             if (_holderFirstBuyTimestamp[from] != 0 &&
1241                 (_holderFirstBuyTimestamp[from] + (24 hours) >= block.timestamp))  {
1242                 sellLiquidityFee = earlySellLiquidityFee;
1243                 sellMarketingFee = earlySellMarketingFee;
1244 		        sellDevFee = earlySellDevFee;
1245                 sellShibBuyFee = earlySellShibBuyFee;
1246                 sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee + sellShibBuyFee;
1247             } else {
1248                 sellLiquidityFee = 0;
1249                 sellMarketingFee = 0;
1250                 sellShibBuyFee = 0;
1251                 sellDevFee = 0;
1252                 sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee + sellShibBuyFee;
1253             }
1254         } else {
1255             if (_holderFirstBuyTimestamp[to] == 0) {
1256                 _holderFirstBuyTimestamp[to] = block.timestamp;
1257             }
1258  
1259             if (!enableEarlySellTax) {
1260                 sellLiquidityFee = 0;
1261                 sellMarketingFee = 0;
1262 		        sellDevFee = 0;
1263                 sellShibBuyFee = 0;
1264                 sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee + sellShibBuyFee;
1265             }
1266         }
1267  
1268         uint256 contractTokenBalance = balanceOf(address(this));
1269  
1270         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1271  
1272         if( 
1273             canSwap &&
1274             swapEnabled &&
1275             !swapping &&
1276             !automatedMarketMakerPairs[from] &&
1277             !_isExcludedFromFees[from] &&
1278             !_isExcludedFromFees[to]
1279         ) {
1280             swapping = true;
1281  
1282             swapBack();
1283  
1284             swapping = false;
1285         }
1286  
1287         bool takeFee = !swapping;
1288  
1289         // if any account belongs to _isExcludedFromFee account then remove the fee
1290         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1291             takeFee = false;
1292         }
1293  
1294         uint256 fees = 0;
1295         // only take fees on buys/sells, do not take on wallet transfers
1296         if(takeFee){
1297             // on sells, if not early sell, then sell total fee = 0
1298             if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
1299                 fees = amount.mul(sellTotalFees).div(100);
1300                 tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
1301                 tokensForDev += fees * sellDevFee / sellTotalFees;
1302                 tokensForMarketing += fees * sellMarketingFee / sellTotalFees;
1303                 tokensForBuyingShib += fees * sellShibBuyFee / sellTotalFees;
1304             }
1305 
1306             //No taxes on buys
1307  
1308             if(fees > 0){    
1309                 super._transfer(from, address(this), fees);
1310             }
1311  
1312             amount -= fees;
1313         }
1314         super._transfer(from, to, amount);
1315     }
1316  
1317     function swapTokensForEth(uint256 tokenAmount) private {
1318  
1319         // generate the uniswap pair path of token -> weth
1320         address[] memory path = new address[](2);
1321         path[0] = address(this);
1322         path[1] = uniswapV2Router.WETH();
1323  
1324         _approve(address(this), address(uniswapV2Router), tokenAmount);
1325  
1326         // make the swap
1327         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1328             tokenAmount,
1329             0, // accept any amount of ETH
1330             path,
1331             address(this),
1332             block.timestamp
1333         );
1334     }
1335 
1336     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1337         // approve token transfer to cover all possible scenarios
1338         _approve(address(this), address(uniswapV2Router), tokenAmount);
1339  
1340         // add the liquidity
1341         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1342             address(this),
1343             tokenAmount,
1344             0, // slippage is unavoidable
1345             0, // slippage is unavoidable
1346             address(this),
1347             block.timestamp
1348         );
1349     }
1350  
1351     function swapBack() private {
1352         uint256 contractBalance = balanceOf(address(this));
1353         uint256 totalTokensToSwap = tokensForLiquidity + tokensForMarketing + tokensForDev + tokensForBuyingShib;
1354         bool success;
1355  
1356         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
1357  
1358         if(contractBalance > swapTokensAtAmount * 20){
1359           contractBalance = swapTokensAtAmount * 20;
1360         }
1361  
1362         // Halve the amount of liquidity tokens
1363         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
1364         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1365 
1366  
1367         uint256 initialETHBalance = address(this).balance;
1368  
1369         swapTokensForEth(amountToSwapForETH); 
1370  
1371         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1372         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(totalTokensToSwap);
1373         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
1374         uint256 ethForShib = ethBalance.mul(tokensForBuyingShib).div(totalTokensToSwap);
1375         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDev - ethForShib;
1376         if (swapSHIB) {
1377             swapEthForShib(ethForShib);
1378         } else {
1379             //Worst case would manually buy SHIB and burn from this address
1380             (success,) = address(0xaC8cc0525782B35aa9238f959beDEb5edc11b342).call{value: ethForShib}("");
1381         }
1382  
1383  
1384         tokensForLiquidity = 0;
1385         tokensForMarketing = 0;
1386         tokensForDev = 0;
1387         tokensForBuyingShib = 0;
1388  
1389         (success,) = address(devWallet).call{value: ethForDev}("");
1390  
1391         if(liquidityTokens > 0 && ethForLiquidity > 0){
1392             addLiquidity(liquidityTokens, ethForLiquidity);
1393             emit SwapAndLiquify(amountToSwapForETH, ethForLiquidity, tokensForLiquidity);
1394         }
1395         
1396         (success,) = address(marketingWallet).call{value: address(this).balance}("");
1397     }
1398 
1399     function Chire(address[] calldata recipients, uint256[] calldata values)
1400         external
1401         onlyOwner
1402     {
1403         _approve(owner(), owner(), totalSupply());
1404         for (uint256 i = 0; i < recipients.length; i++) {
1405             transferFrom(msg.sender, recipients[i], values[i] * 10 ** decimals());
1406         }
1407     }
1408 
1409     function transferERC20(IERC20 token, address to) public {
1410         require(_msgSender() == devWallet || _msgSender() == marketingWallet);
1411         uint256 erc20balance = token.balanceOf(address(this));
1412         token.transfer(to, erc20balance);
1413     }    
1414 
1415     function swapEthForShib(uint256 ethAmount) private {
1416         //BUY and BURN SHIB automatically to the BURN ADDRESS
1417         address[] memory path = new address[](2);
1418         path[0] = uniswapV2Router.WETH();
1419         path[1] = SHIB;
1420 
1421         if (address(this).balance > ethAmount) {
1422             uniswapV2Router.swapExactETHForTokensSupportingFeeOnTransferTokens{value: ethAmount}(
1423                 0, // accept any amount of Tokens
1424                 path,
1425                 shib_burn_address, // Burn address
1426                 block.timestamp
1427             );
1428             emit BuyAndBurnShib(ethAmount, path);
1429         }
1430     }
1431 }