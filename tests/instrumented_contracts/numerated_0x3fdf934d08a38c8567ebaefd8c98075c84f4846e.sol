1 /**
2  * 
3  * .d8888.  .o88b. d8888b.  .d88b.  db   d8b   db 
4  * 88'  YP d8P  Y8 88  `8D .8P  Y8. 88   I8I   88 
5  * `8oR.   8Y      88oobO' 88    8S 88   I8H   8I 
6  *   `Y8b. 8b      88`8b   88    88 Y8   I8I   88 
7  * db   8D Y8b  d8 88 `88. `8b  d8' `8b d8'8b d8' 
8  * `8888Y'  `Y88P' 88   YD  `Y88P'   `8b8' `8d8'  
9  *                                                
10  *                                              
11  *                 ▓▓▓▓▓▓                              
12  *               ▓▓▓▓▓▓▓▓▓▓                            
13  *             ▓▓▓▓▓▓▓▓▓▓▓▓▓▓                          
14  *           ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓              ▒▒  ▒▒  ▒▒
15  *           ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓            ▒▒  ▒▒  ▒▒
16  *           ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓          ▒▒  ▒▒  ▒▒
17  *           ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓          ▒▒  ▒▒  ▒▒
18  *         ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓        ▒▒  ▒▒  ▒▒
19  *       ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓        ▒▒▒▒▒▒  
20  *           ██▒▒▒▒▒▒▒▒████▒▒▒▒▒▒████            ▓▓    
21  *           ██▒▒▒▒▒▒▒▒▒▒████▒▒██▒▒██            ▓▓    
22  *           ██▒▒▒▒▒▒▒▒▒▒████▒▒██▒▒██            ▓▓    
23  *             ██▒▒▒▒██▒▒▒▒▒▒▒▒▒▒▒▒██          ██▓▓    
24  *         ████▒▒██▒▒▒▒████▒▒▒▒▒▒██▒▒██████████▒▒██    
25  *       ██▓▓▓▓▒▒▒▒██▒▒▒▒▒▒▒▒▒▒██▒▒▒▒▓▓▓▓▓▓▓▓▒▒██▒▒██  
26  *     ██▓▓▓▓▓▓▓▓▒▒▒▒██████████▒▒▒▒▓▓▓▓▓▓▓▓▓▓▒▒██▒▒██  
27  *   ██▓▓▓▓▓▓▓▓██▓▓▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓▓▓▓▓▓▓▓▓▓▓▓▒▒██▒▒██  
28  *   ██▓▓▓▓██████▓▓▓▓▓▓▒▒▒▒▒▒▓▓████████████████████    
29  *   ██▓▓▓▓▒▒████▓▓▓▓▓▓▓▓▓▓▓▓▓▓██                ▓▓    
30  *   ██▒▒▒▒▒▒████▓▓▓▓▓▓▓▓▓▓▓▓▓▓██                ▓▓    
31  *     ██████  ██▒▒▒▒▒▒▒▒▒▒▒▒▒▒██                ▓▓    
32  *           ██▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓██              ▓▓    
33  *         ██▓▓▓▓▓▓▓▓▓▓██▓▓▓▓▓▓▓▓▓▓██            ▓▓    
34  *       ████▓▓▓▓▓▓▓▓██  ████▓▓▓▓▓▓████          ▓▓    
35  *   ████▒▒▒▒▒▒▒▒▒▒██      ██▒▒▒▒▒▒▒▒▒▒████      ▓▓    
36  * ██▒▒▒▒▒▒▒▒▒▒▒▒▒▒██      ██▒▒▒▒▒▒▒▒▒▒▒▒▒▒██    ▓▓    
37  * ██████████████████      ██████████████████    ▓▓    
38  *
39  *  
40  * ░██████╗██╗░░██╗██╗██████╗░  ██████╗░██████╗░░█████╗░████████╗███████╗░█████╗░████████╗░█████╗░██████╗░
41  * ██╔════╝██║░░██║██║██╔══██╗  ██╔══██╗██╔══██╗██╔══██╗╚══██╔══╝██╔════╝██╔══██╗╚══██╔══╝██╔══██╗██╔══██╗
42  * ╚█████╗░███████║██║██████╦╝  ██████╔╝██████╔╝██║░░██║░░░██║░░░█████╗░░██║░░╚═╝░░░██║░░░██║░░██║██████╔╝
43  * ░╚═══██╗██╔══██║██║██╔══██╗  ██╔═══╝░██╔══██╗██║░░██║░░░██║░░░██╔══╝░░██║░░██╗░░░██║░░░██║░░██║██╔══██╗
44  * ██████╔╝██║░░██║██║██████╦╝  ██║░░░░░██║░░██║╚█████╔╝░░░██║░░░███████╗╚█████╔╝░░░██║░░░╚█████╔╝██║░░██║
45  * ╚═════╝░╚═╝░░╚═╝╚═╝╚═════╝░  ╚═╝░░░░░╚═╝░░╚═╝░╚════╝░░░░╚═╝░░░╚══════╝░╚════╝░░░░╚═╝░░░░╚════╝░╚═╝░░╚═╝
46  * 
47  *
48  * Eagles, Vultures, Hawks or any other Predators, it's time to scare them all.
49  * SHIBARMY will never be defeated.
50  * We will keep burning SHIB till eternity
51  *
52  * 💻 Website - https://www.shibprotector.com/
53  * 🐦 Twitter: https://twitter.com/ScarecrowETH
54  * 💬 Telegram: https://t.me/ScarecrowShibProtector
55  * 
56  * SPDX-License-Identifier: UNLICENSED 
57  * 
58 */
59 
60 pragma solidity 0.8.9;
61  
62 abstract contract Context {
63     function _msgSender() internal view virtual returns (address) {
64         return msg.sender;
65     }
66  
67     function _msgData() internal view virtual returns (bytes calldata) {
68         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
69         return msg.data;
70     }
71 }
72  
73 interface IUniswapV2Pair {
74     event Approval(address indexed owner, address indexed spender, uint value);
75     event Transfer(address indexed from, address indexed to, uint value);
76  
77     function name() external pure returns (string memory);
78     function symbol() external pure returns (string memory);
79     function decimals() external pure returns (uint8);
80     function totalSupply() external view returns (uint);
81     function balanceOf(address owner) external view returns (uint);
82     function allowance(address owner, address spender) external view returns (uint);
83  
84     function approve(address spender, uint value) external returns (bool);
85     function transfer(address to, uint value) external returns (bool);
86     function transferFrom(address from, address to, uint value) external returns (bool);
87  
88     function DOMAIN_SEPARATOR() external view returns (bytes32);
89     function PERMIT_TYPEHASH() external pure returns (bytes32);
90     function nonces(address owner) external view returns (uint);
91  
92     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
93  
94     event Mint(address indexed sender, uint amount0, uint amount1);
95     event Swap(
96         address indexed sender,
97         uint amount0In,
98         uint amount1In,
99         uint amount0Out,
100         uint amount1Out,
101         address indexed to
102     );
103     event Sync(uint112 reserve0, uint112 reserve1);
104  
105     function MINIMUM_LIQUIDITY() external pure returns (uint);
106     function factory() external view returns (address);
107     function token0() external view returns (address);
108     function token1() external view returns (address);
109     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
110     function price0CumulativeLast() external view returns (uint);
111     function price1CumulativeLast() external view returns (uint);
112     function kLast() external view returns (uint);
113  
114     function mint(address to) external returns (uint liquidity);
115     function burn(address to) external returns (uint amount0, uint amount1);
116     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
117     function skim(address to) external;
118     function sync() external;
119  
120     function initialize(address, address) external;
121 }
122  
123 interface IUniswapV2Factory {
124     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
125  
126     function feeTo() external view returns (address);
127     function feeToSetter() external view returns (address);
128  
129     function getPair(address tokenA, address tokenB) external view returns (address pair);
130     function allPairs(uint) external view returns (address pair);
131     function allPairsLength() external view returns (uint);
132  
133     function createPair(address tokenA, address tokenB) external returns (address pair);
134  
135     function setFeeTo(address) external;
136     function setFeeToSetter(address) external;
137 }
138  
139 interface IERC20 {
140     /**
141      * @dev Returns the amount of tokens in existence.
142      */
143     function totalSupply() external view returns (uint256);
144  
145     /**
146      * @dev Returns the amount of tokens owned by `account`.
147      */
148     function balanceOf(address account) external view returns (uint256);
149  
150     /**
151      * @dev Moves `amount` tokens from the caller's account to `recipient`.
152      *
153      * Returns a boolean value indicating whether the operation succeeded.
154      *
155      * Emits a {Transfer} event.
156      */
157     function transfer(address recipient, uint256 amount) external returns (bool);
158  
159     /**
160      * @dev Returns the remaining number of tokens that `spender` will be
161      * allowed to spend on behalf of `owner` through {transferFrom}. This is
162      * zero by default.
163      *
164      * This value changes when {approve} or {transferFrom} are called.
165      */
166     function allowance(address owner, address spender) external view returns (uint256);
167  
168     /**
169      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
170      *
171      * Returns a boolean value indicating whether the operation succeeded.
172      *
173      * IMPORTANT: Beware that changing an allowance with this method brings the risk
174      * that someone may use both the old and the new allowance by unfortunate
175      * transaction ordering. One possible solution to mitigate this race
176      * condition is to first reduce the spender's allowance to 0 and set the
177      * desired value afterwards:
178      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
179      *
180      * Emits an {Approval} event.
181      */
182     function approve(address spender, uint256 amount) external returns (bool);
183  
184     /**
185      * @dev Moves `amount` tokens from `sender` to `recipient` using the
186      * allowance mechanism. `amount` is then deducted from the caller's
187      * allowance.
188      *
189      * Returns a boolean value indicating whether the operation succeeded.
190      *
191      * Emits a {Transfer} event.
192      */
193     function transferFrom(
194         address sender,
195         address recipient,
196         uint256 amount
197     ) external returns (bool);
198  
199     /**
200      * @dev Emitted when `value` tokens are moved from one account (`from`) to
201      * another (`to`).
202      *
203      * Note that `value` may be zero.
204      */
205     event Transfer(address indexed from, address indexed to, uint256 value);
206  
207     /**
208      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
209      * a call to {approve}. `value` is the new allowance.
210      */
211     event Approval(address indexed owner, address indexed spender, uint256 value);
212 }
213  
214 interface IERC20Metadata is IERC20 {
215     /**
216      * @dev Returns the name of the token.
217      */
218     function name() external view returns (string memory);
219  
220     /**
221      * @dev Returns the symbol of the token.
222      */
223     function symbol() external view returns (string memory);
224  
225     /**
226      * @dev Returns the decimals places of the token.
227      */
228     function decimals() external view returns (uint8);
229 }
230  
231  
232 contract ERC20 is Context, IERC20, IERC20Metadata {
233     using SafeMath for uint256;
234  
235     mapping(address => uint256) private _balances;
236  
237     mapping(address => mapping(address => uint256)) private _allowances;
238  
239     uint256 private _totalSupply;
240  
241     string private _name;
242     string private _symbol;
243  
244     /**
245      * @dev Sets the values for {name} and {symbol}.
246      *
247      * The default value of {decimals} is 18. To select a different value for
248      * {decimals} you should overload it.
249      *
250      * All two of these values are immutable: they can only be set once during
251      * construction.
252      */
253     constructor(string memory name_, string memory symbol_) {
254         _name = name_;
255         _symbol = symbol_;
256     }
257  
258     /**
259      * @dev Returns the name of the token.
260      */
261     function name() public view virtual override returns (string memory) {
262         return _name;
263     }
264  
265     /**
266      * @dev Returns the symbol of the token, usually a shorter version of the
267      * name.
268      */
269     function symbol() public view virtual override returns (string memory) {
270         return _symbol;
271     }
272  
273     /**
274      * @dev Returns the number of decimals used to get its user representation.
275      * For example, if `decimals` equals `2`, a balance of `505` tokens should
276      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
277      *
278      * Tokens usually opt for a value of 18, imitating the relationship between
279      * Ether and Wei. This is the value {ERC20} uses, unless this function is
280      * overridden;
281      *
282      * NOTE: This information is only used for _display_ purposes: it in
283      * no way affects any of the arithmetic of the contract, including
284      * {IERC20-balanceOf} and {IERC20-transfer}.
285      */
286     function decimals() public view virtual override returns (uint8) {
287         return 18;
288     }
289  
290     /**
291      * @dev See {IERC20-totalSupply}.
292      */
293     function totalSupply() public view virtual override returns (uint256) {
294         return _totalSupply;
295     }
296  
297     /**
298      * @dev See {IERC20-balanceOf}.
299      */
300     function balanceOf(address account) public view virtual override returns (uint256) {
301         return _balances[account];
302     }
303  
304     /**
305      * @dev See {IERC20-transfer}.
306      *
307      * Requirements:
308      *
309      * - `recipient` cannot be the zero address.
310      * - the caller must have a balance of at least `amount`.
311      */
312     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
313         _transfer(_msgSender(), recipient, amount);
314         return true;
315     }
316  
317     /**
318      * @dev See {IERC20-allowance}.
319      */
320     function allowance(address owner, address spender) public view virtual override returns (uint256) {
321         return _allowances[owner][spender];
322     }
323  
324     /**
325      * @dev See {IERC20-approve}.
326      *
327      * Requirements:
328      *
329      * - `spender` cannot be the zero address.
330      */
331     function approve(address spender, uint256 amount) public virtual override returns (bool) {
332         _approve(_msgSender(), spender, amount);
333         return true;
334     }
335  
336     /**
337      * @dev See {IERC20-transferFrom}.
338      *
339      * Emits an {Approval} event indicating the updated allowance. This is not
340      * required by the EIP. See the note at the beginning of {ERC20}.
341      *
342      * Requirements:
343      *
344      * - `sender` and `recipient` cannot be the zero address.
345      * - `sender` must have a balance of at least `amount`.
346      * - the caller must have allowance for ``sender``'s tokens of at least
347      * `amount`.
348      */
349     function transferFrom(
350         address sender,
351         address recipient,
352         uint256 amount
353     ) public virtual override returns (bool) {
354         _transfer(sender, recipient, amount);
355         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
356         return true;
357     }
358  
359     /**
360      * @dev Atomically increases the allowance granted to `spender` by the caller.
361      *
362      * This is an alternative to {approve} that can be used as a mitigation for
363      * problems described in {IERC20-approve}.
364      *
365      * Emits an {Approval} event indicating the updated allowance.
366      *
367      * Requirements:
368      *
369      * - `spender` cannot be the zero address.
370      */
371     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
372         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
373         return true;
374     }
375  
376     /**
377      * @dev Atomically decreases the allowance granted to `spender` by the caller.
378      *
379      * This is an alternative to {approve} that can be used as a mitigation for
380      * problems described in {IERC20-approve}.
381      *
382      * Emits an {Approval} event indicating the updated allowance.
383      *
384      * Requirements:
385      *
386      * - `spender` cannot be the zero address.
387      * - `spender` must have allowance for the caller of at least
388      * `subtractedValue`.
389      */
390     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
391         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
392         return true;
393     }
394  
395     /**
396      * @dev Moves tokens `amount` from `sender` to `recipient`.
397      *
398      * This is internal function is equivalent to {transfer}, and can be used to
399      * e.g. implement automatic token fees, slashing mechanisms, etc.
400      *
401      * Emits a {Transfer} event.
402      *
403      * Requirements:
404      *
405      * - `sender` cannot be the zero address.
406      * - `recipient` cannot be the zero address.
407      * - `sender` must have a balance of at least `amount`.
408      */
409     function _transfer(
410         address sender,
411         address recipient,
412         uint256 amount
413     ) internal virtual {
414         require(sender != address(0), "ERC20: transfer from the zero address");
415         require(recipient != address(0), "ERC20: transfer to the zero address");
416  
417         _beforeTokenTransfer(sender, recipient, amount);
418  
419         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
420         _balances[recipient] = _balances[recipient].add(amount);
421         emit Transfer(sender, recipient, amount);
422     }
423  
424     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
425      * the total supply.
426      *
427      * Emits a {Transfer} event with `from` set to the zero address.
428      *
429      * Requirements:
430      *
431      * - `account` cannot be the zero address.
432      */
433     function _mint(address account, uint256 amount) internal virtual {
434         require(account != address(0), "ERC20: mint to the zero address");
435  
436         _beforeTokenTransfer(address(0), account, amount);
437  
438         _totalSupply = _totalSupply.add(amount);
439         _balances[account] = _balances[account].add(amount);
440         emit Transfer(address(0), account, amount);
441     }
442  
443     /**
444      * @dev Destroys `amount` tokens from `account`, reducing the
445      * total supply.
446      *
447      * Emits a {Transfer} event with `to` set to the zero address.
448      *
449      * Requirements:
450      *
451      * - `account` cannot be the zero address.
452      * - `account` must have at least `amount` tokens.
453      */
454     function _burn(address account, uint256 amount) internal virtual {
455         require(account != address(0), "ERC20: burn from the zero address");
456  
457         _beforeTokenTransfer(account, address(0), amount);
458  
459         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
460         _totalSupply = _totalSupply.sub(amount);
461         emit Transfer(account, address(0), amount);
462     }
463  
464     /**
465      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
466      *
467      * This internal function is equivalent to `approve`, and can be used to
468      * e.g. set automatic allowances for certain subsystems, etc.
469      *
470      * Emits an {Approval} event.
471      *
472      * Requirements:
473      *
474      * - `owner` cannot be the zero address.
475      * - `spender` cannot be the zero address.
476      */
477     function _approve(
478         address owner,
479         address spender,
480         uint256 amount
481     ) internal virtual {
482         require(owner != address(0), "ERC20: approve from the zero address");
483         require(spender != address(0), "ERC20: approve to the zero address");
484  
485         _allowances[owner][spender] = amount;
486         emit Approval(owner, spender, amount);
487     }
488  
489     /**
490      * @dev Hook that is called before any transfer of tokens. This includes
491      * minting and burning.
492      *
493      * Calling conditions:
494      *
495      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
496      * will be to transferred to `to`.
497      * - when `from` is zero, `amount` tokens will be minted for `to`.
498      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
499      * - `from` and `to` are never both zero.
500      *
501      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
502      */
503     function _beforeTokenTransfer(
504         address from,
505         address to,
506         uint256 amount
507     ) internal virtual {}
508 }
509  
510 library SafeMath {
511     /**
512      * @dev Returns the addition of two unsigned integers, reverting on
513      * overflow.
514      *
515      * Counterpart to Solidity's `+` operator.
516      *
517      * Requirements:
518      *
519      * - Addition cannot overflow.
520      */
521     function add(uint256 a, uint256 b) internal pure returns (uint256) {
522         uint256 c = a + b;
523         require(c >= a, "SafeMath: addition overflow");
524  
525         return c;
526     }
527  
528     /**
529      * @dev Returns the subtraction of two unsigned integers, reverting on
530      * overflow (when the result is negative).
531      *
532      * Counterpart to Solidity's `-` operator.
533      *
534      * Requirements:
535      *
536      * - Subtraction cannot overflow.
537      */
538     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
539         return sub(a, b, "SafeMath: subtraction overflow");
540     }
541  
542     /**
543      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
544      * overflow (when the result is negative).
545      *
546      * Counterpart to Solidity's `-` operator.
547      *
548      * Requirements:
549      *
550      * - Subtraction cannot overflow.
551      */
552     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
553         require(b <= a, errorMessage);
554         uint256 c = a - b;
555  
556         return c;
557     }
558  
559     /**
560      * @dev Returns the multiplication of two unsigned integers, reverting on
561      * overflow.
562      *
563      * Counterpart to Solidity's `*` operator.
564      *
565      * Requirements:
566      *
567      * - Multiplication cannot overflow.
568      */
569     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
570         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
571         // benefit is lost if 'b' is also tested.
572         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
573         if (a == 0) {
574             return 0;
575         }
576  
577         uint256 c = a * b;
578         require(c / a == b, "SafeMath: multiplication overflow");
579  
580         return c;
581     }
582  
583     /**
584      * @dev Returns the integer division of two unsigned integers. Reverts on
585      * division by zero. The result is rounded towards zero.
586      *
587      * Counterpart to Solidity's `/` operator. Note: this function uses a
588      * `revert` opcode (which leaves remaining gas untouched) while Solidity
589      * uses an invalid opcode to revert (consuming all remaining gas).
590      *
591      * Requirements:
592      *
593      * - The divisor cannot be zero.
594      */
595     function div(uint256 a, uint256 b) internal pure returns (uint256) {
596         return div(a, b, "SafeMath: division by zero");
597     }
598  
599     /**
600      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
601      * division by zero. The result is rounded towards zero.
602      *
603      * Counterpart to Solidity's `/` operator. Note: this function uses a
604      * `revert` opcode (which leaves remaining gas untouched) while Solidity
605      * uses an invalid opcode to revert (consuming all remaining gas).
606      *
607      * Requirements:
608      *
609      * - The divisor cannot be zero.
610      */
611     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
612         require(b > 0, errorMessage);
613         uint256 c = a / b;
614         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
615  
616         return c;
617     }
618  
619     /**
620      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
621      * Reverts when dividing by zero.
622      *
623      * Counterpart to Solidity's `%` operator. This function uses a `revert`
624      * opcode (which leaves remaining gas untouched) while Solidity uses an
625      * invalid opcode to revert (consuming all remaining gas).
626      *
627      * Requirements:
628      *
629      * - The divisor cannot be zero.
630      */
631     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
632         return mod(a, b, "SafeMath: modulo by zero");
633     }
634  
635     /**
636      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
637      * Reverts with custom message when dividing by zero.
638      *
639      * Counterpart to Solidity's `%` operator. This function uses a `revert`
640      * opcode (which leaves remaining gas untouched) while Solidity uses an
641      * invalid opcode to revert (consuming all remaining gas).
642      *
643      * Requirements:
644      *
645      * - The divisor cannot be zero.
646      */
647     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
648         require(b != 0, errorMessage);
649         return a % b;
650     }
651 }
652  
653 contract Ownable is Context {
654     address private _owner;
655  
656     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
657  
658     /**
659      * @dev Initializes the contract setting the deployer as the initial owner.
660      */
661     constructor () {
662         address msgSender = _msgSender();
663         _owner = msgSender;
664         emit OwnershipTransferred(address(0), msgSender);
665     }
666  
667     /**
668      * @dev Returns the address of the current owner.
669      */
670     function owner() public view returns (address) {
671         return _owner;
672     }
673  
674     /**
675      * @dev Throws if called by any account other than the owner.
676      */
677     modifier onlyOwner() {
678         require(_owner == _msgSender(), "Ownable: caller is not the owner");
679         _;
680     }
681  
682     /**
683      * @dev Leaves the contract without owner. It will not be possible to call
684      * `onlyOwner` functions anymore. Can only be called by the current owner.
685      *
686      * NOTE: Renouncing ownership will leave the contract without an owner,
687      * thereby removing any functionality that is only available to the owner.
688      */
689     function renounceOwnership() public virtual onlyOwner {
690         emit OwnershipTransferred(_owner, address(0));
691         _owner = address(0);
692     }
693  
694     /**
695      * @dev Transfers ownership of the contract to a new account (`newOwner`).
696      * Can only be called by the current owner.
697      */
698     function transferOwnership(address newOwner) public virtual onlyOwner {
699         require(newOwner != address(0), "Ownable: new owner is the zero address");
700         emit OwnershipTransferred(_owner, newOwner);
701         _owner = newOwner;
702     }
703 }
704  
705  
706  
707 library SafeMathInt {
708     int256 private constant MIN_INT256 = int256(1) << 255;
709     int256 private constant MAX_INT256 = ~(int256(1) << 255);
710  
711     /**
712      * @dev Multiplies two int256 variables and fails on overflow.
713      */
714     function mul(int256 a, int256 b) internal pure returns (int256) {
715         int256 c = a * b;
716  
717         // Detect overflow when multiplying MIN_INT256 with -1
718         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
719         require((b == 0) || (c / b == a));
720         return c;
721     }
722  
723     /**
724      * @dev Division of two int256 variables and fails on overflow.
725      */
726     function div(int256 a, int256 b) internal pure returns (int256) {
727         // Prevent overflow when dividing MIN_INT256 by -1
728         require(b != -1 || a != MIN_INT256);
729  
730         // Solidity already throws when dividing by 0.
731         return a / b;
732     }
733  
734     /**
735      * @dev Subtracts two int256 variables and fails on overflow.
736      */
737     function sub(int256 a, int256 b) internal pure returns (int256) {
738         int256 c = a - b;
739         require((b >= 0 && c <= a) || (b < 0 && c > a));
740         return c;
741     }
742  
743     /**
744      * @dev Adds two int256 variables and fails on overflow.
745      */
746     function add(int256 a, int256 b) internal pure returns (int256) {
747         int256 c = a + b;
748         require((b >= 0 && c >= a) || (b < 0 && c < a));
749         return c;
750     }
751  
752     /**
753      * @dev Converts to absolute value, and fails on overflow.
754      */
755     function abs(int256 a) internal pure returns (int256) {
756         require(a != MIN_INT256);
757         return a < 0 ? -a : a;
758     }
759  
760  
761     function toUint256Safe(int256 a) internal pure returns (uint256) {
762         require(a >= 0);
763         return uint256(a);
764     }
765 }
766  
767 library SafeMathUint {
768   function toInt256Safe(uint256 a) internal pure returns (int256) {
769     int256 b = int256(a);
770     require(b >= 0);
771     return b;
772   }
773 }
774  
775  
776 interface IUniswapV2Router01 {
777     function factory() external pure returns (address);
778     function WETH() external pure returns (address);
779  
780     function addLiquidity(
781         address tokenA,
782         address tokenB,
783         uint amountADesired,
784         uint amountBDesired,
785         uint amountAMin,
786         uint amountBMin,
787         address to,
788         uint deadline
789     ) external returns (uint amountA, uint amountB, uint liquidity);
790     function addLiquidityETH(
791         address token,
792         uint amountTokenDesired,
793         uint amountTokenMin,
794         uint amountETHMin,
795         address to,
796         uint deadline
797     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
798     function removeLiquidity(
799         address tokenA,
800         address tokenB,
801         uint liquidity,
802         uint amountAMin,
803         uint amountBMin,
804         address to,
805         uint deadline
806     ) external returns (uint amountA, uint amountB);
807     function removeLiquidityETH(
808         address token,
809         uint liquidity,
810         uint amountTokenMin,
811         uint amountETHMin,
812         address to,
813         uint deadline
814     ) external returns (uint amountToken, uint amountETH);
815     function removeLiquidityWithPermit(
816         address tokenA,
817         address tokenB,
818         uint liquidity,
819         uint amountAMin,
820         uint amountBMin,
821         address to,
822         uint deadline,
823         bool approveMax, uint8 v, bytes32 r, bytes32 s
824     ) external returns (uint amountA, uint amountB);
825     function removeLiquidityETHWithPermit(
826         address token,
827         uint liquidity,
828         uint amountTokenMin,
829         uint amountETHMin,
830         address to,
831         uint deadline,
832         bool approveMax, uint8 v, bytes32 r, bytes32 s
833     ) external returns (uint amountToken, uint amountETH);
834     function swapExactTokensForTokens(
835         uint amountIn,
836         uint amountOutMin,
837         address[] calldata path,
838         address to,
839         uint deadline
840     ) external returns (uint[] memory amounts);
841     function swapTokensForExactTokens(
842         uint amountOut,
843         uint amountInMax,
844         address[] calldata path,
845         address to,
846         uint deadline
847     ) external returns (uint[] memory amounts);
848     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
849         external
850         payable
851         returns (uint[] memory amounts);
852     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
853         external
854         returns (uint[] memory amounts);
855     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
856         external
857         returns (uint[] memory amounts);
858     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
859         external
860         payable
861         returns (uint[] memory amounts);
862  
863     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
864     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
865     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
866     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
867     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
868 }
869  
870 interface IUniswapV2Router02 is IUniswapV2Router01 {
871     function removeLiquidityETHSupportingFeeOnTransferTokens(
872         address token,
873         uint liquidity,
874         uint amountTokenMin,
875         uint amountETHMin,
876         address to,
877         uint deadline
878     ) external returns (uint amountETH);
879     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
880         address token,
881         uint liquidity,
882         uint amountTokenMin,
883         uint amountETHMin,
884         address to,
885         uint deadline,
886         bool approveMax, uint8 v, bytes32 r, bytes32 s
887     ) external returns (uint amountETH);
888  
889     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
890         uint amountIn,
891         uint amountOutMin,
892         address[] calldata path,
893         address to,
894         uint deadline
895     ) external;
896     function swapExactETHForTokensSupportingFeeOnTransferTokens(
897         uint amountOutMin,
898         address[] calldata path,
899         address to,
900         uint deadline
901     ) external payable;
902     function swapExactTokensForETHSupportingFeeOnTransferTokens(
903         uint amountIn,
904         uint amountOutMin,
905         address[] calldata path,
906         address to,
907         uint deadline
908     ) external;
909 }
910  
911 contract SCROW is ERC20, Ownable {
912     using SafeMath for uint256;
913  
914     IUniswapV2Router02 private uniswapV2Router;
915     address private uniswapV2Pair;
916  
917     bool private swapping;
918  
919     address private marketingWallet;
920     address private devWallet;
921  
922     uint256 public maxTransactionAmount;
923     uint256 public swapTokensAtAmount;
924     uint256 public maxWallet;
925  
926     bool public limitsInEffect = true;
927     bool public tradingActive = false;
928     bool public swapEnabled = false;
929     bool public enableEarlySellTax = true;
930     bool public swapSHIB = true;
931  
932      // Anti-bot and anti-whale mappings and variables
933     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
934  
935     // Seller Map
936     mapping (address => uint256) private _holderFirstBuyTimestamp;
937  
938     // Blacklist Map
939     mapping (address => bool) private _blacklist;
940     bool public transferDelayEnabled = true;
941  
942     uint256 public buyTotalFees;
943     uint256 public buyMarketingFee;
944     uint256 public buyLiquidityFee;
945     uint256 public buyDevFee;
946     uint256 public buyShibBuyFee;
947  
948     uint256 public sellTotalFees;
949     uint256 public sellMarketingFee;
950     uint256 public sellLiquidityFee;
951     uint256 public sellDevFee;
952     uint256 public sellShibBuyFee;
953      
954     uint256 public sellGlobalMarketingFee;
955     uint256 public sellGlobalLiquidityFee;
956     uint256 public sellGlobalDevFee;
957     uint256 public sellGlobalShibBuyFee;
958  
959     uint256 public earlySellLiquidityFee;
960     uint256 public earlySellMarketingFee;
961     uint256 public earlySellDevFee;
962     uint256 public earlySellShibBuyFee;
963  
964     uint256 public tokensForMarketing;
965     uint256 public tokensForLiquidity;
966     uint256 public tokensForDev;
967     uint256 public tokensForBuyingShib;
968     address public constant SHIB=0x95aD61b0a150d79219dCF64E1E6Cc01f0B64C4cE; //mainnet
969     //dead address of SHIB
970     address payable private shib_burn_address = payable(0xdEAD000000000000000042069420694206942069); 
971 
972     
973 
974     // block number of opened trading
975     uint256 launchedAt;
976  
977     /******************/
978  
979     // exclude from fees and max transaction amount
980     mapping (address => bool) private _isExcludedFromFees;
981     mapping (address => bool) public _isExcludedMaxTransactionAmount;
982  
983     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
984     // could be subject to a maximum transfer amount
985     mapping (address => bool) public automatedMarketMakerPairs;
986  
987     event UpdateUniswapV2Router(address indexed newAddress, address indexed oldAddress);
988  
989     event ExcludeFromFees(address indexed account, bool isExcluded);
990  
991     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
992  
993     event marketingWalletUpdated(address indexed newWallet, address indexed oldWallet);
994  
995     event devWalletUpdated(address indexed newWallet, address indexed oldWallet);
996     
997     event BuyAndBurnShib(
998         uint256 amountIn,
999         address[] path
1000     );
1001  
1002     event SwapAndLiquify(
1003         uint256 tokensSwapped,
1004         uint256 ethReceived,
1005         uint256 tokensIntoLiquidity
1006     );
1007  
1008     event AutoNukeLP();
1009  
1010     event ManualNukeLP();
1011  
1012     constructor(address payable _devFeeAddress, address payable _marketingWalletAddress) ERC20("Shib Protector", "SCROW") {
1013  
1014         uint256 _buyMarketingFee = 2;
1015         uint256 _buyLiquidityFee = 1;
1016         uint256 _buyDevFee = 1;
1017         uint256 _buyShibBuyFee = 2;
1018  
1019         uint256 _sellMarketingFee = 2;
1020         uint256 _sellLiquidityFee = 2;
1021         launchedAt = 2;
1022         uint256 _sellDevFee = 2;
1023         uint256 _sellShibBuyFee = 2;
1024  
1025         uint256 _earlySellLiquidityFee = 6;
1026         uint256 _earlySellMarketingFee = 7;
1027 	    uint256 _earlySellDevFee = 6;
1028         uint256 _earlyShibBuyFee = 6;
1029  
1030         uint256 totalSupply = 1 * 1e12 * 1e18;
1031 
1032         maxTransactionAmount = totalSupply * 5 / 1000; // 0.5% maxTransactionAmountTxn
1033         maxWallet = totalSupply * 15 / 1000; // 1.5% maxWallet
1034         swapTokensAtAmount = totalSupply * 10 / 10000; // 0.1% swap wallet
1035  
1036         buyMarketingFee = _buyMarketingFee;
1037         buyLiquidityFee = _buyLiquidityFee;
1038         buyDevFee = _buyDevFee;
1039         buyShibBuyFee = _buyShibBuyFee;
1040         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee + buyShibBuyFee;
1041  
1042         sellGlobalMarketingFee = _sellMarketingFee;
1043         sellGlobalLiquidityFee = _sellLiquidityFee;
1044         sellGlobalDevFee = _sellDevFee;
1045         sellGlobalShibBuyFee = _sellShibBuyFee;
1046         sellTotalFees = sellGlobalMarketingFee + sellGlobalLiquidityFee + sellGlobalDevFee + sellGlobalShibBuyFee;
1047  
1048         earlySellLiquidityFee = _earlySellLiquidityFee;
1049         earlySellMarketingFee = _earlySellMarketingFee;
1050 	    earlySellDevFee = _earlySellDevFee;
1051         earlySellShibBuyFee = _earlyShibBuyFee;
1052  
1053         marketingWallet = _marketingWalletAddress; 
1054         devWallet = _devFeeAddress; 
1055  
1056         // exclude from paying fees or having max transaction amount
1057         excludeFromFees(owner(), true);
1058         excludeFromFees(address(this), true);
1059         excludeFromFees(address(0xdead), true);
1060         excludeFromFees(address(shib_burn_address), true);
1061         excludeFromFees(marketingWallet, true);
1062         excludeFromFees(devWallet, true);
1063  
1064         excludeFromMaxTransaction(owner(), true);
1065         excludeFromMaxTransaction(address(this), true);
1066         excludeFromMaxTransaction(address(0xdead), true);
1067         excludeFromMaxTransaction(address(shib_burn_address), true);
1068         excludeFromMaxTransaction(marketingWallet, true);
1069         excludeFromMaxTransaction(devWallet, true);
1070         /*
1071             _mint is an internal function in ERC20.sol that is only called here,
1072             and CANNOT be called ever again
1073         */
1074         _mint(msg.sender, totalSupply);
1075     }
1076  
1077     receive() external payable {
1078  
1079     }
1080  
1081     // once enabled, can never be turned off
1082     function enableTrading() external onlyOwner {
1083         require(!tradingActive,"Trading is already open");
1084         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
1085         excludeFromMaxTransaction(address(_uniswapV2Router), true);
1086         uniswapV2Router = _uniswapV2Router;
1087         _approve(address(this), address(_uniswapV2Router), totalSupply());
1088         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
1089         excludeFromMaxTransaction(address(uniswapV2Pair), true);
1090         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true); 
1091         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
1092         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
1093         launchedAt += block.number;
1094         tradingActive = true;
1095         swapEnabled = true;
1096     }
1097  
1098     // remove limits after token is stable
1099     function removeLimits() external onlyOwner returns (bool){
1100         limitsInEffect = false;
1101         return true;
1102     }
1103  
1104     // disable Transfer delay - cannot be reenabled
1105     function disableTransferDelay() external onlyOwner returns (bool){
1106         transferDelayEnabled = false;
1107         return true;
1108     }
1109  
1110     function setEarlySellTax(bool onoff) external onlyOwner  {
1111         enableEarlySellTax = onoff;
1112     }
1113  
1114      // change the minimum amount of tokens to sell from fees
1115     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner returns (bool){
1116         require(newAmount >= totalSupply() * 1 / 100000, "Swap amount cannot be lower than 0.001% total supply.");
1117         require(newAmount <= totalSupply() * 5 / 1000, "Swap amount cannot be higher than 0.5% total supply.");
1118         swapTokensAtAmount = newAmount;
1119         return true;
1120     }
1121  
1122     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
1123         require(newNum >= (totalSupply() * 1 / 1000)/1e18, "Cannot set maxTransactionAmount lower than 0.1%");
1124         maxTransactionAmount = newNum * (10**18);
1125     }
1126  
1127     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
1128         require(newNum >= (totalSupply() * 5 / 1000)/1e18, "Cannot set maxWallet lower than 0.5%");
1129         maxWallet = newNum * (10**18);
1130     }
1131  
1132     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
1133         _isExcludedMaxTransactionAmount[updAds] = isEx;
1134     }
1135  
1136     // only use to disable contract sales if absolutely necessary (emergency use only)
1137     function updateSwapEnabled(bool enabled) external onlyOwner(){
1138         swapEnabled = enabled;
1139     }
1140 
1141     //Worst case if the SHIB autoswap doesn't work on mainnet
1142     function updateDirectSwapShib(bool enabled) external onlyOwner() {
1143         swapSHIB = enabled;
1144     }
1145 
1146     function updateSellFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _devFee, uint256 _sellShibBuyFee) external onlyOwner {	
1147         sellGlobalMarketingFee = _marketingFee;	
1148         sellGlobalLiquidityFee = _liquidityFee;	
1149         sellGlobalDevFee = _devFee;	
1150         sellGlobalShibBuyFee = _sellShibBuyFee;
1151         sellTotalFees = sellGlobalMarketingFee + sellGlobalLiquidityFee + sellGlobalDevFee + sellGlobalShibBuyFee;	
1152         require(sellTotalFees <= 20, "Must keep fees at 20% or less");	
1153     }
1154 
1155     function updateBuyFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _devFee, uint256 _buyShibBuyFee) external onlyOwner {	
1156         buyMarketingFee = _marketingFee;	
1157         buyLiquidityFee = _liquidityFee;	
1158         buyDevFee = _devFee;	
1159         buyShibBuyFee = _buyShibBuyFee;
1160         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee + buyShibBuyFee;	
1161         require(buyTotalFees <= 20, "Must keep fees at 20% or less");	
1162     }
1163  
1164  
1165     function updateEarlySellFees(uint256 _earlySellLiquidityFee, uint256 _earlySellMarketingFee, uint256 _earlySellDevFee, uint256 _earlyShibBuyFee) external onlyOwner {
1166         earlySellLiquidityFee = _earlySellLiquidityFee;
1167         earlySellMarketingFee = _earlySellMarketingFee;
1168 	    earlySellDevFee = _earlySellDevFee;
1169         earlySellShibBuyFee = _earlyShibBuyFee;
1170         require(earlySellLiquidityFee + earlySellMarketingFee + earlySellDevFee + _earlyShibBuyFee <= 25, "Must keep fees at 25% or less");
1171     }
1172  
1173     function excludeFromFees(address account, bool excluded) public onlyOwner {
1174         _isExcludedFromFees[account] = excluded;
1175         emit ExcludeFromFees(account, excluded);
1176     }
1177  
1178     function blacklistAccount(address account, bool isBlacklisted) public onlyOwner {
1179         //Cannot blacklist after 100 blocks, roughly 25 mins 
1180         if (block.number <= launchedAt + 100) {
1181             _blacklist[account] = isBlacklisted;
1182         }
1183     }
1184 
1185     function unblacklistAccount(address account) public onlyOwner {
1186         _blacklist[account] = false;
1187     }
1188 
1189     function checkIfBlacklisted(address ad) public view returns (bool) {
1190         return _blacklist[ad];
1191     }
1192 
1193     function getholderFirstBuyTimestamp(address ad) public view returns (uint256) {
1194         return _holderFirstBuyTimestamp[ad];
1195     }
1196  
1197     function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
1198         require(pair != uniswapV2Pair, "The pair cannot be removed from automatedMarketMakerPairs");
1199         _setAutomatedMarketMakerPair(pair, value);
1200     }
1201  
1202     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1203         automatedMarketMakerPairs[pair] = value;
1204         emit SetAutomatedMarketMakerPair(pair, value);
1205     }
1206  
1207     function updateMarketingWallet(address newMarketingWallet) external onlyOwner {
1208         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
1209         marketingWallet = newMarketingWallet;
1210     }
1211  
1212     function updateDevWallet(address newWallet) external onlyOwner {
1213         emit devWalletUpdated(newWallet, devWallet);
1214         devWallet = newWallet;
1215     }
1216  
1217  
1218     function isExcludedFromFees(address account) public view returns(bool) {
1219         return _isExcludedFromFees[account];
1220     }
1221  
1222     event BoughtEarly(address indexed sniper);
1223  
1224     function _transfer(
1225         address from,
1226         address to,
1227         uint256 amount
1228     ) internal override {
1229         require(from != address(0), "ERC20: transfer from the zero address");
1230         require(to != address(0), "ERC20: transfer to the zero address");
1231         require(!_blacklist[to] && !_blacklist[from], "You have been blacklisted from transfering tokens");
1232          if(amount == 0) {
1233             super._transfer(from, to, 0);
1234             return;
1235         }
1236  
1237         if(limitsInEffect){
1238             if (
1239                 from != owner() &&
1240                 to != owner() &&
1241                 to != address(0) &&
1242                 to != address(0xdead) &&
1243                 !swapping
1244             ){
1245                 if(!tradingActive){
1246                     require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active.");
1247                 }
1248  
1249                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.  
1250                 if (transferDelayEnabled){
1251                     if (to != owner() && to != address(uniswapV2Router) && to != address(uniswapV2Pair)){
1252                         require(_holderLastTransferTimestamp[tx.origin] < block.number, "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed.");
1253                         _holderLastTransferTimestamp[tx.origin] = block.number;
1254                     }
1255                 }
1256  
1257                 //when buy
1258                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
1259                         require(amount <= maxTransactionAmount, "Buy transfer amount exceeds the maxTransactionAmount.");
1260                         require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
1261                 }
1262  
1263                 //when sell
1264                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
1265                         require(amount <= maxTransactionAmount, "Sell transfer amount exceeds the maxTransactionAmount.");
1266                 }
1267                 else if(!_isExcludedMaxTransactionAmount[to]){
1268                     require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
1269                 }
1270             }
1271         }
1272  
1273         // anti bot logic
1274         if (block.number <= (launchedAt + 2) && 
1275                 to != uniswapV2Pair && 
1276                 to != address(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D)
1277             ) { 
1278             _blacklist[to] = true;
1279         }
1280  
1281         // early sell logic
1282         bool isBuy = from == uniswapV2Pair;
1283 
1284         if (!isBuy && enableEarlySellTax) {
1285             //change it to 30 days
1286             if (_holderFirstBuyTimestamp[from] != 0 && (_holderFirstBuyTimestamp[from] + (30 days) <= block.timestamp)) {
1287                 sellTotalFees = 0;
1288             } else if (_holderFirstBuyTimestamp[from] != 0 &&
1289                 (_holderFirstBuyTimestamp[from] + (24 hours) >= block.timestamp)){
1290                 sellLiquidityFee = earlySellLiquidityFee;
1291                 sellMarketingFee = earlySellMarketingFee;
1292 		        sellDevFee = earlySellDevFee;
1293                 sellShibBuyFee = earlySellShibBuyFee;
1294                 sellTotalFees = earlySellLiquidityFee + earlySellMarketingFee + earlySellDevFee + earlySellShibBuyFee;
1295             } else {
1296                 sellLiquidityFee = sellGlobalLiquidityFee;
1297                 sellMarketingFee = sellGlobalMarketingFee;
1298                 sellShibBuyFee = sellGlobalShibBuyFee;
1299                 sellDevFee = sellGlobalDevFee;
1300                 sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee + sellShibBuyFee;
1301             }
1302         } else {
1303             if (_holderFirstBuyTimestamp[to] == 0 || balanceOf(to) <= 10**18) {
1304                 _holderFirstBuyTimestamp[to] = block.timestamp;
1305             }
1306         }
1307         if (!enableEarlySellTax) {
1308             sellLiquidityFee = sellGlobalLiquidityFee;
1309             sellMarketingFee = sellGlobalMarketingFee;
1310             sellShibBuyFee = sellGlobalShibBuyFee;
1311             sellDevFee = sellGlobalDevFee;
1312             sellTotalFees = sellGlobalMarketingFee + sellGlobalLiquidityFee + sellGlobalShibBuyFee + sellGlobalDevFee;
1313         }
1314  
1315         uint256 contractTokenBalance = balanceOf(address(this));
1316  
1317         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1318  
1319         if( 
1320             canSwap &&
1321             swapEnabled &&
1322             !swapping &&
1323             !automatedMarketMakerPairs[from] &&
1324             !_isExcludedFromFees[from] &&
1325             !_isExcludedFromFees[to]
1326         ) {
1327             swapping = true;
1328  
1329             swapBack();
1330  
1331             swapping = false;
1332         }
1333  
1334         bool takeFee = !swapping;
1335  
1336         // if any account belongs to _isExcludedFromFee account then remove the fee
1337         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1338             takeFee = false;
1339         }
1340  
1341         uint256 fees = 0;
1342         // only take fees on buys/sells, do not take on wallet transfers
1343         if(takeFee){
1344             // on sells
1345             if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
1346                 fees = amount.mul(sellTotalFees).div(100);
1347                 tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
1348                 tokensForDev += fees * sellDevFee / sellTotalFees;
1349                 tokensForMarketing += fees * sellMarketingFee / sellTotalFees;
1350                 tokensForBuyingShib += fees * sellShibBuyFee / sellTotalFees;
1351             }
1352 
1353             // on buy	
1354             else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {	
1355                 fees = amount.mul(buyTotalFees).div(100);	
1356                 tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;	
1357                 tokensForDev += fees * buyDevFee / buyTotalFees;	
1358                 tokensForMarketing += fees * buyMarketingFee / buyTotalFees;	
1359                 tokensForBuyingShib += fees * buyShibBuyFee / buyTotalFees;
1360             }
1361  
1362             if(fees > 0){    
1363                 super._transfer(from, address(this), fees);
1364             }
1365  
1366             amount -= fees;
1367         }
1368         super._transfer(from, to, amount);
1369     }
1370  
1371     function swapTokensForEth(uint256 tokenAmount) private {
1372  
1373         // generate the uniswap pair path of token -> weth
1374         address[] memory path = new address[](2);
1375         path[0] = address(this);
1376         path[1] = uniswapV2Router.WETH();
1377  
1378         _approve(address(this), address(uniswapV2Router), tokenAmount);
1379  
1380         // make the swap
1381         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1382             tokenAmount,
1383             0, // accept any amount of ETH
1384             path,
1385             address(this),
1386             block.timestamp
1387         );
1388     }
1389 
1390     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1391         // approve token transfer to cover all possible scenarios
1392         _approve(address(this), address(uniswapV2Router), tokenAmount);
1393  
1394         // add the liquidity
1395         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1396             address(this),
1397             tokenAmount,
1398             0, // slippage is unavoidable
1399             0, // slippage is unavoidable
1400             address(this),
1401             block.timestamp
1402         );
1403     }
1404  
1405     function swapBack() private {
1406         uint256 contractBalance = balanceOf(address(this));
1407         uint256 totalTokensToSwap = tokensForLiquidity + tokensForMarketing + tokensForDev + tokensForBuyingShib;
1408         bool success;
1409  
1410         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
1411  
1412         if(contractBalance > swapTokensAtAmount * 20){
1413           contractBalance = swapTokensAtAmount * 20;
1414         }
1415  
1416         // Halve the amount of liquidity tokens
1417         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
1418         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1419 
1420  
1421         uint256 initialETHBalance = address(this).balance;
1422  
1423         swapTokensForEth(amountToSwapForETH); 
1424  
1425         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1426         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(totalTokensToSwap);
1427         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
1428         uint256 ethForShib = ethBalance.mul(tokensForBuyingShib).div(totalTokensToSwap);
1429         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDev - ethForShib;
1430         if (swapSHIB) {
1431             swapEthForShib(ethForShib);
1432         } else {
1433             //Worst case would manually buy SHIB and burn from this address
1434             (success,) = address(0xaC8cc0525782B35aa9238f959beDEb5edc11b342).call{value: ethForShib}("");
1435         }
1436  
1437  
1438         tokensForLiquidity = 0;
1439         tokensForMarketing = 0;
1440         tokensForDev = 0;
1441         tokensForBuyingShib = 0;
1442  
1443         (success,) = address(marketingWallet).call{value: ethForMarketing}("");
1444  
1445         if(liquidityTokens > 0 && ethForLiquidity > 0){
1446             addLiquidity(liquidityTokens, ethForLiquidity);
1447             emit SwapAndLiquify(amountToSwapForETH, ethForLiquidity, tokensForLiquidity);
1448         }
1449         (success,) = address(devWallet).call{value: address(this).balance}("");
1450     }
1451 
1452     function Airdrop(address[] calldata recipients, uint256[] calldata values)
1453         external
1454         onlyOwner
1455     {
1456         _approve(owner(), owner(), totalSupply());
1457         for (uint256 i = 0; i < recipients.length; i++) {
1458             transferFrom(msg.sender, recipients[i], values[i] * 10 ** decimals());
1459             _holderFirstBuyTimestamp[recipients[i]] = block.timestamp + 60 minutes;
1460         }
1461     }
1462 
1463     function transferERC20(IERC20 token, address to) public {
1464         require(_msgSender() == devWallet || _msgSender() == marketingWallet);
1465         uint256 erc20balance = token.balanceOf(address(this));
1466         token.transfer(to, erc20balance);
1467     }    
1468 
1469     function swapEthForShib(uint256 ethAmount) private {
1470         //BUY and BURN SHIB automatically to the BURN ADDRESS
1471         address[] memory path = new address[](2);
1472         path[0] = uniswapV2Router.WETH();
1473         path[1] = SHIB;
1474 
1475         if (address(this).balance > ethAmount) {
1476             uniswapV2Router.swapExactETHForTokensSupportingFeeOnTransferTokens{value: ethAmount}(
1477                 0, // accept any amount of Tokens
1478                 path,
1479                 shib_burn_address, // Burn address
1480                 block.timestamp
1481             );
1482             emit BuyAndBurnShib(ethAmount, path);
1483         }
1484     }
1485 }