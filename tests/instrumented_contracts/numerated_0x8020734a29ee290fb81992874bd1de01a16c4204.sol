1 /**
2 
3 Some Devs doxx, others do not
4 
5 Some Devs deliver, others do not
6 
7 Some Devs are crazy talented, some just crazy, some just talented
8 
9 Let's make this doxx a bit fun....what do you say? I'll tell you EVERYTHING if you find me
10 
11 Hidden messages revealing NAME, LOCATION, OCCUPATION, FAMILY, and FAITH so you can put it all together
12 
13 I'll be sitting here waiting for you..for someone to share my secrets with
14 
15 - COBRA
16                                                                                 
17 
18                 ,▄»══≈≈≈≈═«▄▄,                                                  
19           ,e∩╙  '░░,╓╓╓╓╓╓╓╔▄%▒╙▒▒#▒░▒7#"""▄                                    
20        ╓Θ  ,;φφ▒▄▓▓▓▓▓╬╬╣╫▓▄▒▒╬╬╬╬╬╣╝▌▓░{░⌐¬"≈▄                                 
21     ,∩  ,φ░▄▓╣╬╬╬╬╠╬╬╬▓▓╣╫╬╬╬▓▓█▀▀█╬▓≥╠░▒▒░╠▓φ╠╬µ                               
22    é ;░φφ▓╬╬╬╬╬▓╣╫╬╬╬╬╬▒▄╝▀ ▄▓▓╠╣▒ █▓█▓▓▓▓▓▓` ▌▌                                
23   ╩ ░φ▒▓▓▓▓▓╣╬╬╬╣╬╬╬╬╠╠▀ ,#╣▓╬▓╬▓▒▒╟█▓▓   ▌╛  ░                                 
24  ╬ "φ▒▓▓▓▓▓▓╣╬╬╬╬╬╬╩╬▓ ]▓▓╣╬╩╙╙███"█╣╬▌╖ ┌▀  Æ`                                 
25  ▌ ▒▒╫███████▓▓▓╫╫▓▒▌;φ▒╬╬╩╙ⁿ╗▓╣╫╬░▓╬ ,╙╬#                                      
26  ▌  ╠█████▓▓╣╬╬╬╬╠▒▓░╣▒╣╬▒░  ▓╬╬#≈╫╬╣▀`  █╙▄                                    
27   ▄]╚╟█████▓▓╫╬╬╬╩░█╟▌╠╣╬╙   ╬╬#φ╓        ▒╟                                    
28    ▀▄╙╟██▓▓╬╬╬╬╬▓╫╩█╣▒╣╬╬░   ▓╬▒░╩       ┌▒█                                    
29      ▀▄╚████╬╬╬╬╠▒░╟╣▒╠╬▒    ▓╬▒║       ,▓▓`                                    
30        ▀▄╙█▓▓▓╬╬▓╫╩░█▒╣╬╬╩    █w∩     -"`                                       
31          ╙╬╙▀▓▓╬╬╬╬▒╬▌╠╣▓▒∩   ╙▌⌐                                               
32             ▀▄╙▓╬╫╬╬▒╫▒╠╬▓▒░  ,╜▌                                               
33               ╙╬░▀╬╣╬φ▓▌╣╣╣▓▒   ╙▄                                              
34                  ▀▄╠╣▓╬╬▌╠╬▓▓φ░   ▄                                             
35                    ╙╝▒╠▓╣▓▒╬╣▓▒▄ε` ▀                                            
36                       ╙╬╬╬█▄╚╬╬╬▒,  ╙▄                                          
37                          ▀╬╬▓▒╟╣╬▒φ   ▓                                         
38                            ▀▒╬▓╬╬╬▓▓▒  ╙▄                                       
39                              ▀▒╠╬╬╣▓▒φ,  ▀                                      
40                                ▀╬╠╣╬╣▓▒░  ╨╦                                    
41                                  ╬╚╬╬╠▓▓#   ▀                                   
42                                   ╙▄╙╟╬╬▒▒,  ╙▄                                 
43                                     Q ╚▒╠╬▒ε  ╒¼                                
44                                      Θ ╙▒╫╫▒∩   %                               
45                                  ,,,  ¼ ╙▒╚╠░;   ¼                              
46                               ▄░ a^    ε ╘░╚╠░    ▌                             
47                              ▐░>▐      ╘  Ü░╠▒░   ▐                             
48                  ▄╗@▒▀▀▀▀▀*╤▄▐▒▒ ¼      ▒ ▐▒╠╬#"`  ╠                            
49               ▄▓╬╠╬╜╙└┘"""=w╓,│╙▀▄▒≥,   ▌ ¡▌░╠╬∩   ▐  ,-ⁿ"``  `"*w,             
50 ..           █╬╬░╙ 7,,,,; .   ╙φ░░░▀╦▄▒è▌ ░╠░╠╬≥   ]░ ⌐»;;= "µ     ╙╦           
51     '¡....  █╬╬▒░░φ░╠╟█▓▓▓▓φ╦░░░φ╠▒▒╠╬▓▌ⁿ/▒╫╠╬╫▄▄,µ▐░░    ,αÖ'  ;≤,  ▓ ;'      
52 */
53 
54 // SPDX-License-Identifier: Unlicensed
55 
56 pragma solidity 0.8.9;
57  
58 abstract contract Context {
59     function _msgSender() internal view virtual returns (address) {
60         return msg.sender;
61     }
62  
63     function _msgData() internal view virtual returns (bytes calldata) {
64         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
65         return msg.data;
66     }
67 }
68  
69 interface IUniswapV2Pair {
70     event Approval(address indexed owner, address indexed spender, uint value);
71     event Transfer(address indexed from, address indexed to, uint value);
72  
73     function name() external pure returns (string memory);
74     function symbol() external pure returns (string memory);
75     function decimals() external pure returns (uint8);
76     function totalSupply() external view returns (uint);
77     function balanceOf(address owner) external view returns (uint);
78     function allowance(address owner, address spender) external view returns (uint);
79  
80     function approve(address spender, uint value) external returns (bool);
81     function transfer(address to, uint value) external returns (bool);
82     function transferFrom(address from, address to, uint value) external returns (bool);
83  
84     function DOMAIN_SEPARATOR() external view returns (bytes32);
85     function PERMIT_TYPEHASH() external pure returns (bytes32);
86     function nonces(address owner) external view returns (uint);
87  
88     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
89  
90     event Mint(address indexed sender, uint amount0, uint amount1);
91     event Swap(
92         address indexed sender,
93         uint amount0In,
94         uint amount1In,
95         uint amount0Out,
96         uint amount1Out,
97         address indexed to
98     );
99     event Sync(uint112 reserve0, uint112 reserve1);
100  
101     function MINIMUM_LIQUIDITY() external pure returns (uint);
102     function factory() external view returns (address);
103     function token0() external view returns (address);
104     function token1() external view returns (address);
105     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
106     function price0CumulativeLast() external view returns (uint);
107     function price1CumulativeLast() external view returns (uint);
108     function kLast() external view returns (uint);
109  
110     function mint(address to) external returns (uint liquidity);
111     function burn(address to) external returns (uint amount0, uint amount1);
112     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
113     function skim(address to) external;
114     function sync() external;
115  
116     function initialize(address, address) external;
117 }
118  
119 interface IUniswapV2Factory {
120     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
121  
122     function feeTo() external view returns (address);
123     function feeToSetter() external view returns (address);
124  
125     function getPair(address tokenA, address tokenB) external view returns (address pair);
126     function allPairs(uint) external view returns (address pair);
127     function allPairsLength() external view returns (uint);
128  
129     function createPair(address tokenA, address tokenB) external returns (address pair);
130  
131     function setFeeTo(address) external;
132     function setFeeToSetter(address) external;
133 }
134  
135 interface IERC20 {
136     /**
137      * @dev Returns the amount of tokens in existence.
138      */
139     function totalSupply() external view returns (uint256);
140  
141     /**
142      * @dev Returns the amount of tokens owned by `account`.
143      */
144     function balanceOf(address account) external view returns (uint256);
145  
146     /**
147      * @dev Moves `amount` tokens from the caller's account to `recipient`.
148      *
149      * Returns a boolean value indicating whether the operation succeeded.
150      *
151      * Emits a {Transfer} event.
152      */
153     function transfer(address recipient, uint256 amount) external returns (bool);
154  
155     /**
156      * @dev Returns the remaining number of tokens that `spender` will be
157      * allowed to spend on behalf of `owner` through {transferFrom}. This is
158      * zero by default.
159      *
160      * This value changes when {approve} or {transferFrom} are called.
161      */
162     function allowance(address owner, address spender) external view returns (uint256);
163  
164     /**
165      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
166      *
167      * Returns a boolean value indicating whether the operation succeeded.
168      *
169      * IMPORTANT: Beware that changing an allowance with this method brings the risk
170      * that someone may use both the old and the new allowance by unfortunate
171      * transaction ordering. One possible solution to mitigate this race
172      * condition is to first reduce the spender's allowance to 0 and set the
173      * desired value afterwards:
174      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
175      *
176      * Emits an {Approval} event.
177      */
178     function approve(address spender, uint256 amount) external returns (bool);
179  
180     /**
181      * @dev Moves `amount` tokens from `sender` to `recipient` using the
182      * allowance mechanism. `amount` is then deducted from the caller's
183      * allowance.
184      *
185      * Returns a boolean value indicating whether the operation succeeded.
186      *
187      * Emits a {Transfer} event.
188      */
189     function transferFrom(
190         address sender,
191         address recipient,
192         uint256 amount
193     ) external returns (bool);
194  
195     /**
196      * @dev Emitted when `value` tokens are moved from one account (`from`) to
197      * another (`to`).
198      *
199      * Note that `value` may be zero.
200      */
201     event Transfer(address indexed from, address indexed to, uint256 value);
202  
203     /**
204      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
205      * a call to {approve}. `value` is the new allowance.
206      */
207     event Approval(address indexed owner, address indexed spender, uint256 value);
208 }
209  
210 interface IERC20Metadata is IERC20 {
211     /**
212      * @dev Returns the name of the token.
213      */
214     function name() external view returns (string memory);
215  
216     /**
217      * @dev Returns the symbol of the token.
218      */
219     function symbol() external view returns (string memory);
220  
221     /**
222      * @dev Returns the decimals places of the token.
223      */
224     function decimals() external view returns (uint8);
225 }
226  
227  
228 contract ERC20 is Context, IERC20, IERC20Metadata {
229     using SafeMath for uint256;
230  
231     mapping(address => uint256) private _balances;
232  
233     mapping(address => mapping(address => uint256)) private _allowances;
234  
235     uint256 private _totalSupply;
236  
237     string private _name;
238     string private _symbol;
239  
240     /**
241      * @dev Sets the values for {name} and {symbol}.
242      *
243      * The default value of {decimals} is 18. To select a different value for
244      * {decimals} you should overload it.
245      *
246      * All two of these values are immutable: they can only be set once during
247      * construction.
248      */
249     constructor(string memory name_, string memory symbol_) {
250         _name = name_;
251         _symbol = symbol_;
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
269     /**
270      * @dev Returns the number of decimals used to get its user representation.
271      * For example, if `decimals` equals `2`, a balance of `505` tokens should
272      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
273      *
274      * Tokens usually opt for a value of 18, imitating the relationship between
275      * Ether and Wei. This is the value {ERC20} uses, unless this function is
276      * overridden;
277      *
278      * NOTE: This information is only used for _display_ purposes: it in
279      * no way affects any of the arithmetic of the contract, including
280      * {IERC20-balanceOf} and {IERC20-transfer}.
281      */
282     function decimals() public view virtual override returns (uint8) {
283         return 18;
284     }
285  
286     /**
287      * @dev See {IERC20-totalSupply}.
288      */
289     function totalSupply() public view virtual override returns (uint256) {
290         return _totalSupply;
291     }
292  
293     /**
294      * @dev See {IERC20-balanceOf}.
295      */
296     function balanceOf(address account) public view virtual override returns (uint256) {
297         return _balances[account];
298     }
299  
300     /**
301      * @dev See {IERC20-transfer}.
302      *
303      * Requirements:
304      *
305      * - `recipient` cannot be the zero address.
306      * - the caller must have a balance of at least `amount`.
307      */
308     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
309         _transfer(_msgSender(), recipient, amount);
310         return true;
311     }
312  
313     /**
314      * @dev See {IERC20-allowance}.
315      */
316     function allowance(address owner, address spender) public view virtual override returns (uint256) {
317         return _allowances[owner][spender];
318     }
319  
320     /**
321      * @dev See {IERC20-approve}.
322      *
323      * Requirements:
324      *
325      * - `spender` cannot be the zero address.
326      */
327     function approve(address spender, uint256 amount) public virtual override returns (bool) {
328         _approve(_msgSender(), spender, amount);
329         return true;
330     }
331  
332     /**
333      * @dev See {IERC20-transferFrom}.
334      *
335      * Emits an {Approval} event indicating the updated allowance. This is not
336      * required by the EIP. See the note at the beginning of {ERC20}.
337      *
338      * Requirements:
339      *
340      * - `sender` and `recipient` cannot be the zero address.
341      * - `sender` must have a balance of at least `amount`.
342      * - the caller must have allowance for ``sender``'s tokens of at least
343      * `amount`.
344      */
345     function transferFrom(
346         address sender,
347         address recipient,
348         uint256 amount
349     ) public virtual override returns (bool) {
350         _transfer(sender, recipient, amount);
351         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
352         return true;
353     }
354  
355     /**
356      * @dev Atomically increases the allowance granted to `spender` by the caller.
357      *
358      * This is an alternative to {approve} that can be used as a mitigation for
359      * problems described in {IERC20-approve}.
360      *
361      * Emits an {Approval} event indicating the updated allowance.
362      *
363      * Requirements:
364      *
365      * - `spender` cannot be the zero address.
366      */
367     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
368         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
369         return true;
370     }
371  
372     /**
373      * @dev Atomically decreases the allowance granted to `spender` by the caller.
374      *
375      * This is an alternative to {approve} that can be used as a mitigation for
376      * problems described in {IERC20-approve}.
377      *
378      * Emits an {Approval} event indicating the updated allowance.
379      *
380      * Requirements:
381      *
382      * - `spender` cannot be the zero address.
383      * - `spender` must have allowance for the caller of at least
384      * `subtractedValue`.
385      */
386     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
387         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
388         return true;
389     }
390  
391     /**
392      * @dev Moves tokens `amount` from `sender` to `recipient`.
393      *
394      * This is internal function is equivalent to {transfer}, and can be used to
395      * e.g. implement automatic token fees, slashing mechanisms, etc.
396      *
397      * Emits a {Transfer} event.
398      *
399      * Requirements:
400      *
401      * - `sender` cannot be the zero address.
402      * - `recipient` cannot be the zero address.
403      * - `sender` must have a balance of at least `amount`.
404      */
405     function _transfer(
406         address sender,
407         address recipient,
408         uint256 amount
409     ) internal virtual {
410         require(sender != address(0), "ERC20: transfer from the zero address");
411         require(recipient != address(0), "ERC20: transfer to the zero address");
412  
413         _beforeTokenTransfer(sender, recipient, amount);
414  
415         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
416         _balances[recipient] = _balances[recipient].add(amount);
417         emit Transfer(sender, recipient, amount);
418     }
419  
420     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
421      * the total supply.
422      *
423      * Emits a {Transfer} event with `from` set to the zero address.
424      *
425      * Requirements:
426      *
427      * - `account` cannot be the zero address.
428      */
429     function _mint(address account, uint256 amount) internal virtual {
430         require(account != address(0), "ERC20: mint to the zero address");
431  
432         _beforeTokenTransfer(address(0), account, amount);
433  
434         _totalSupply = _totalSupply.add(amount);
435         _balances[account] = _balances[account].add(amount);
436         emit Transfer(address(0), account, amount);
437     }
438  
439     /**
440      * @dev Destroys `amount` tokens from `account`, reducing the
441      * total supply.
442      *
443      * Emits a {Transfer} event with `to` set to the zero address.
444      *
445      * Requirements:
446      *
447      * - `account` cannot be the zero address.
448      * - `account` must have at least `amount` tokens.
449      */
450     function _burn(address account, uint256 amount) internal virtual {
451         require(account != address(0), "ERC20: burn from the zero address");
452  
453         _beforeTokenTransfer(account, address(0), amount);
454  
455         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
456         _totalSupply = _totalSupply.sub(amount);
457         emit Transfer(account, address(0), amount);
458     }
459  
460     /**
461      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
462      *
463      * This internal function is equivalent to `approve`, and can be used to
464      * e.g. set automatic allowances for certain subsystems, etc.
465      *
466      * Emits an {Approval} event.
467      *
468      * Requirements:
469      *
470      * - `owner` cannot be the zero address.
471      * - `spender` cannot be the zero address.
472      */
473     function _approve(
474         address owner,
475         address spender,
476         uint256 amount
477     ) internal virtual {
478         require(owner != address(0), "ERC20: approve from the zero address");
479         require(spender != address(0), "ERC20: approve to the zero address");
480  
481         _allowances[owner][spender] = amount;
482         emit Approval(owner, spender, amount);
483     }
484  
485     /**
486      * @dev Hook that is called before any transfer of tokens. This includes
487      * minting and burning.
488      *
489      * Calling conditions:
490      *
491      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
492      * will be to transferred to `to`.
493      * - when `from` is zero, `amount` tokens will be minted for `to`.
494      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
495      * - `from` and `to` are never both zero.
496      *
497      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
498      */
499     function _beforeTokenTransfer(
500         address from,
501         address to,
502         uint256 amount
503     ) internal virtual {}
504 }
505  
506 library SafeMath {
507     /**
508      * @dev Returns the addition of two unsigned integers, reverting on
509      * overflow.
510      *
511      * Counterpart to Solidity's `+` operator.
512      *
513      * Requirements:
514      *
515      * - Addition cannot overflow.
516      */
517     function add(uint256 a, uint256 b) internal pure returns (uint256) {
518         uint256 c = a + b;
519         require(c >= a, "SafeMath: addition overflow");
520  
521         return c;
522     }
523  
524     /**
525      * @dev Returns the subtraction of two unsigned integers, reverting on
526      * overflow (when the result is negative).
527      *
528      * Counterpart to Solidity's `-` operator.
529      *
530      * Requirements:
531      *
532      * - Subtraction cannot overflow.
533      */
534     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
535         return sub(a, b, "SafeMath: subtraction overflow");
536     }
537  
538     /**
539      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
540      * overflow (when the result is negative).
541      *
542      * Counterpart to Solidity's `-` operator.
543      *
544      * Requirements:
545      *
546      * - Subtraction cannot overflow.
547      */
548     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
549         require(b <= a, errorMessage);
550         uint256 c = a - b;
551  
552         return c;
553     }
554  
555     /**
556      * @dev Returns the multiplication of two unsigned integers, reverting on
557      * overflow.
558      *
559      * Counterpart to Solidity's `*` operator.
560      *
561      * Requirements:
562      *
563      * - Multiplication cannot overflow.
564      */
565     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
566         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
567         // benefit is lost if 'b' is also tested.
568         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
569         if (a == 0) {
570             return 0;
571         }
572  
573         uint256 c = a * b;
574         require(c / a == b, "SafeMath: multiplication overflow");
575  
576         return c;
577     }
578  
579     /**
580      * @dev Returns the integer division of two unsigned integers. Reverts on
581      * division by zero. The result is rounded towards zero.
582      *
583      * Counterpart to Solidity's `/` operator. Note: this function uses a
584      * `revert` opcode (which leaves remaining gas untouched) while Solidity
585      * uses an invalid opcode to revert (consuming all remaining gas).
586      *
587      * Requirements:
588      *
589      * - The divisor cannot be zero.
590      */
591     function div(uint256 a, uint256 b) internal pure returns (uint256) {
592         return div(a, b, "SafeMath: division by zero");
593     }
594  
595     /**
596      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
597      * division by zero. The result is rounded towards zero.
598      *
599      * Counterpart to Solidity's `/` operator. Note: this function uses a
600      * `revert` opcode (which leaves remaining gas untouched) while Solidity
601      * uses an invalid opcode to revert (consuming all remaining gas).
602      *
603      * Requirements:
604      *
605      * - The divisor cannot be zero.
606      */
607     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
608         require(b > 0, errorMessage);
609         uint256 c = a / b;
610         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
611  
612         return c;
613     }
614  
615     /**
616      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
617      * Reverts when dividing by zero.
618      *
619      * Counterpart to Solidity's `%` operator. This function uses a `revert`
620      * opcode (which leaves remaining gas untouched) while Solidity uses an
621      * invalid opcode to revert (consuming all remaining gas).
622      *
623      * Requirements:
624      *
625      * - The divisor cannot be zero.
626      */
627     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
628         return mod(a, b, "SafeMath: modulo by zero");
629     }
630  
631     /**
632      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
633      * Reverts with custom message when dividing by zero.
634      *
635      * Counterpart to Solidity's `%` operator. This function uses a `revert`
636      * opcode (which leaves remaining gas untouched) while Solidity uses an
637      * invalid opcode to revert (consuming all remaining gas).
638      *
639      * Requirements:
640      *
641      * - The divisor cannot be zero.
642      */
643     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
644         require(b != 0, errorMessage);
645         return a % b;
646     }
647 }
648  
649 contract Ownable is Context {
650     address private _owner;
651  
652     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
653  
654     /**
655      * @dev Initializes the contract setting the deployer as the initial owner.
656      */
657     constructor () {
658         address msgSender = _msgSender();
659         _owner = msgSender;
660         emit OwnershipTransferred(address(0), msgSender);
661     }
662  
663     /**
664      * @dev Returns the address of the current owner.
665      */
666     function owner() public view returns (address) {
667         return _owner;
668     }
669  
670     /**
671      * @dev Throws if called by any account other than the owner.
672      */
673     modifier onlyOwner() {
674         require(_owner == _msgSender(), "Ownable: caller is not the owner");
675         _;
676     }
677  
678     /**
679      * @dev Leaves the contract without owner. It will not be possible to call
680      * `onlyOwner` functions anymore. Can only be called by the current owner.
681      *
682      * NOTE: Renouncing ownership will leave the contract without an owner,
683      * thereby removing any functionality that is only available to the owner.
684      */
685     function renounceOwnership() public virtual onlyOwner {
686         emit OwnershipTransferred(_owner, address(0));
687         _owner = address(0);
688     }
689  
690     /**
691      * @dev Transfers ownership of the contract to a new account (`newOwner`).
692      * Can only be called by the current owner.
693      */
694     function transferOwnership(address newOwner) public virtual onlyOwner {
695         require(newOwner != address(0), "Ownable: new owner is the zero address");
696         emit OwnershipTransferred(_owner, newOwner);
697         _owner = newOwner;
698     }
699 }
700  
701  
702  
703 library SafeMathInt {
704     int256 private constant MIN_INT256 = int256(1) << 255;
705     int256 private constant MAX_INT256 = ~(int256(1) << 255);
706  
707     /**
708      * @dev Multiplies two int256 variables and fails on overflow.
709      */
710     function mul(int256 a, int256 b) internal pure returns (int256) {
711         int256 c = a * b;
712  
713         // Detect overflow when multiplying MIN_INT256 with -1
714         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
715         require((b == 0) || (c / b == a));
716         return c;
717     }
718  
719     /**
720      * @dev Division of two int256 variables and fails on overflow.
721      */
722     function div(int256 a, int256 b) internal pure returns (int256) {
723         // Prevent overflow when dividing MIN_INT256 by -1
724         require(b != -1 || a != MIN_INT256);
725  
726         // Solidity already throws when dividing by 0.
727         return a / b;
728     }
729  
730     /**
731      * @dev Subtracts two int256 variables and fails on overflow.
732      */
733     function sub(int256 a, int256 b) internal pure returns (int256) {
734         int256 c = a - b;
735         require((b >= 0 && c <= a) || (b < 0 && c > a));
736         return c;
737     }
738  
739     /**
740      * @dev Adds two int256 variables and fails on overflow.
741      */
742     function add(int256 a, int256 b) internal pure returns (int256) {
743         int256 c = a + b;
744         require((b >= 0 && c >= a) || (b < 0 && c < a));
745         return c;
746     }
747  
748     /**
749      * @dev Converts to absolute value, and fails on overflow.
750      */
751     function abs(int256 a) internal pure returns (int256) {
752         require(a != MIN_INT256);
753         return a < 0 ? -a : a;
754     }
755  
756  
757     function toUint256Safe(int256 a) internal pure returns (uint256) {
758         require(a >= 0);
759         return uint256(a);
760     }
761 }
762  
763 library SafeMathUint {
764   function toInt256Safe(uint256 a) internal pure returns (int256) {
765     int256 b = int256(a);
766     require(b >= 0);
767     return b;
768   }
769 }
770  
771  
772 interface IUniswapV2Router01 {
773     function factory() external pure returns (address);
774     function WETH() external pure returns (address);
775  
776     function addLiquidity(
777         address tokenA,
778         address tokenB,
779         uint amountADesired,
780         uint amountBDesired,
781         uint amountAMin,
782         uint amountBMin,
783         address to,
784         uint deadline
785     ) external returns (uint amountA, uint amountB, uint liquidity);
786     function addLiquidityETH(
787         address token,
788         uint amountTokenDesired,
789         uint amountTokenMin,
790         uint amountETHMin,
791         address to,
792         uint deadline
793     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
794     function removeLiquidity(
795         address tokenA,
796         address tokenB,
797         uint liquidity,
798         uint amountAMin,
799         uint amountBMin,
800         address to,
801         uint deadline
802     ) external returns (uint amountA, uint amountB);
803     function removeLiquidityETH(
804         address token,
805         uint liquidity,
806         uint amountTokenMin,
807         uint amountETHMin,
808         address to,
809         uint deadline
810     ) external returns (uint amountToken, uint amountETH);
811     function removeLiquidityWithPermit(
812         address tokenA,
813         address tokenB,
814         uint liquidity,
815         uint amountAMin,
816         uint amountBMin,
817         address to,
818         uint deadline,
819         bool approveMax, uint8 v, bytes32 r, bytes32 s
820     ) external returns (uint amountA, uint amountB);
821     function removeLiquidityETHWithPermit(
822         address token,
823         uint liquidity,
824         uint amountTokenMin,
825         uint amountETHMin,
826         address to,
827         uint deadline,
828         bool approveMax, uint8 v, bytes32 r, bytes32 s
829     ) external returns (uint amountToken, uint amountETH);
830     function swapExactTokensForTokens(
831         uint amountIn,
832         uint amountOutMin,
833         address[] calldata path,
834         address to,
835         uint deadline
836     ) external returns (uint[] memory amounts);
837     function swapTokensForExactTokens(
838         uint amountOut,
839         uint amountInMax,
840         address[] calldata path,
841         address to,
842         uint deadline
843     ) external returns (uint[] memory amounts);
844     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
845         external
846         payable
847         returns (uint[] memory amounts);
848     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
849         external
850         returns (uint[] memory amounts);
851     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
852         external
853         returns (uint[] memory amounts);
854     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
855         external
856         payable
857         returns (uint[] memory amounts);
858  
859     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
860     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
861     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
862     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
863     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
864 }
865  
866 interface IUniswapV2Router02 is IUniswapV2Router01 {
867     function removeLiquidityETHSupportingFeeOnTransferTokens(
868         address token,
869         uint liquidity,
870         uint amountTokenMin,
871         uint amountETHMin,
872         address to,
873         uint deadline
874     ) external returns (uint amountETH);
875     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
876         address token,
877         uint liquidity,
878         uint amountTokenMin,
879         uint amountETHMin,
880         address to,
881         uint deadline,
882         bool approveMax, uint8 v, bytes32 r, bytes32 s
883     ) external returns (uint amountETH);
884  
885     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
886         uint amountIn,
887         uint amountOutMin,
888         address[] calldata path,
889         address to,
890         uint deadline
891     ) external;
892     function swapExactETHForTokensSupportingFeeOnTransferTokens(
893         uint amountOutMin,
894         address[] calldata path,
895         address to,
896         uint deadline
897     ) external payable;
898     function swapExactTokensForETHSupportingFeeOnTransferTokens(
899         uint amountIn,
900         uint amountOutMin,
901         address[] calldata path,
902         address to,
903         uint deadline
904     ) external;
905 }
906  
907 contract COBRA is ERC20, Ownable {
908     using SafeMath for uint256;
909  
910     IUniswapV2Router02 public immutable uniswapV2Router;
911     address public immutable uniswapV2Pair;
912  
913     bool private swapping;
914  
915     address private marketingWallet;
916     address private devWallet;
917  
918     uint256 public maxTransactionAmount;
919     uint256 public swapTokensAtAmount;
920     uint256 public maxWallet;
921  
922     bool public limitsInEffect = true;
923     bool public tradingActive = false;
924     bool public swapEnabled = false;
925     bool public enableEarlySellTax = true;
926  
927      // Anti-bot and anti-whale mappings and variables
928     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
929  
930     // Seller Map
931     mapping (address => uint256) private _holderFirstBuyTimestamp;
932  
933     // Blacklist Map
934     mapping (address => bool) private _blacklist;
935     bool public transferDelayEnabled = true;
936  
937     uint256 public buyTotalFees;
938     uint256 public buyMarketingFee;
939     uint256 public buyLiquidityFee;
940     uint256 public buyDevFee;
941  
942     uint256 public sellTotalFees;
943     uint256 public sellMarketingFee;
944     uint256 public sellLiquidityFee;
945     uint256 public sellDevFee;
946  
947     uint256 public earlySellLiquidityFee;
948     uint256 public earlySellMarketingFee;
949     uint256 public earlySellDevFee;
950  
951     uint256 public tokensForMarketing;
952     uint256 public tokensForLiquidity;
953     uint256 public tokensForDev;
954  
955     // block number of opened trading
956     uint256 launchedAt;
957  
958     /******************/
959  
960     // exclude from fees and max transaction amount
961     mapping (address => bool) private _isExcludedFromFees;
962     mapping (address => bool) public _isExcludedMaxTransactionAmount;
963  
964     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
965     // could be subject to a maximum transfer amount
966     mapping (address => bool) public automatedMarketMakerPairs;
967  
968     event UpdateUniswapV2Router(address indexed newAddress, address indexed oldAddress);
969  
970     event ExcludeFromFees(address indexed account, bool isExcluded);
971  
972     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
973  
974     event marketingWalletUpdated(address indexed newWallet, address indexed oldWallet);
975  
976     event devWalletUpdated(address indexed newWallet, address indexed oldWallet);
977  
978     event SwapAndLiquify(
979         uint256 tokensSwapped,
980         uint256 ethReceived,
981         uint256 tokensIntoLiquidity
982     );
983  
984     event AutoNukeLP();
985  
986     event ManualNukeLP();
987  
988     constructor() ERC20("COBRA", "COBRA") {
989  
990         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
991  
992         excludeFromMaxTransaction(address(_uniswapV2Router), true);
993         uniswapV2Router = _uniswapV2Router;
994  
995         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
996         excludeFromMaxTransaction(address(uniswapV2Pair), true);
997         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
998  
999         uint256 _buyMarketingFee = 3;
1000         uint256 _buyLiquidityFee = 0;
1001         uint256 _buyDevFee = 2;
1002  
1003         uint256 _sellMarketingFee = 2;
1004         uint256 _sellLiquidityFee = 1;
1005         uint256 _sellDevFee = 2;
1006  
1007         uint256 _earlySellLiquidityFee = 1;
1008         uint256 _earlySellMarketingFee = 3;
1009 	    uint256 _earlySellDevFee = 3
1010  
1011     ; uint256 totalSupply = 1 * 1e12 * 1e18;
1012  
1013         maxTransactionAmount = totalSupply * 10 / 1000; // 1% maxTransactionAmountTxn
1014         maxWallet = totalSupply * 20 / 1000; // 2% maxWallet
1015         swapTokensAtAmount = totalSupply * 10 / 10000; // 0.1% swap wallet
1016  
1017         buyMarketingFee = _buyMarketingFee;
1018         buyLiquidityFee = _buyLiquidityFee;
1019         buyDevFee = _buyDevFee;
1020         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
1021  
1022         sellMarketingFee = _sellMarketingFee;
1023         sellLiquidityFee = _sellLiquidityFee;
1024         sellDevFee = _sellDevFee;
1025         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1026  
1027         earlySellLiquidityFee = _earlySellLiquidityFee;
1028         earlySellMarketingFee = _earlySellMarketingFee;
1029 	earlySellDevFee = _earlySellDevFee;
1030  
1031         marketingWallet = address(owner()); // set as marketing wallet
1032         devWallet = address(owner()); // set as dev wallet
1033  
1034         // exclude from paying fees or having max transaction amount
1035         excludeFromFees(owner(), true);
1036         excludeFromFees(address(this), true);
1037         excludeFromFees(address(0xdead), true);
1038  
1039         excludeFromMaxTransaction(owner(), true);
1040         excludeFromMaxTransaction(address(this), true);
1041         excludeFromMaxTransaction(address(0xdead), true);
1042  
1043         /*
1044             _mint is an internal function in ERC20.sol that is only called here,
1045             and CANNOT be called ever again
1046         */
1047         _mint(msg.sender, totalSupply);
1048     }
1049  
1050     receive() external payable {
1051  
1052     }
1053  
1054     // once enabled, can never be turned off
1055     function enableTrading() external onlyOwner {
1056         tradingActive = true;
1057         swapEnabled = true;
1058         launchedAt = block.number;
1059     }
1060  
1061     // remove limits after token is stable
1062     function removeLimits() external onlyOwner returns (bool){
1063         limitsInEffect = false;
1064         return true;
1065     }
1066  
1067     // disable Transfer delay - cannot be reenabled
1068     function disableTransferDelay() external onlyOwner returns (bool){
1069         transferDelayEnabled = false;
1070         return true;
1071     }
1072  
1073     function setEarlySellTax(bool onoff) external onlyOwner  {
1074         enableEarlySellTax = onoff;
1075     }
1076  
1077      // change the minimum amount of tokens to sell from fees
1078     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner returns (bool){
1079         require(newAmount >= totalSupply() * 1 / 100000, "Swap amount cannot be lower than 0.001% total supply.");
1080         require(newAmount <= totalSupply() * 5 / 1000, "Swap amount cannot be higher than 0.5% total supply.");
1081         swapTokensAtAmount = newAmount;
1082         return true;
1083     }
1084  
1085     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
1086         require(newNum >= (totalSupply() * 1 / 1000)/1e18, "Cannot set maxTransactionAmount lower than 0.1%");
1087         maxTransactionAmount = newNum * (10**18);
1088     }
1089  
1090     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
1091         require(newNum >= (totalSupply() * 5 / 1000)/1e18, "Cannot set maxWallet lower than 0.5%");
1092         maxWallet = newNum * (10**18);
1093     }
1094  
1095     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
1096         _isExcludedMaxTransactionAmount[updAds] = isEx;
1097     }
1098  
1099     // only use to disable contract sales if absolutely necessary (emergency use only)
1100     function updateSwapEnabled(bool enabled) external onlyOwner(){
1101         swapEnabled = enabled;
1102     }
1103  
1104     function updateBuyFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _devFee) external onlyOwner {
1105         buyMarketingFee = _marketingFee;
1106         buyLiquidityFee = _liquidityFee;
1107         buyDevFee = _devFee;
1108         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
1109         require(buyTotalFees <= 20, "Must keep fees at 20% or less");
1110     }
1111  
1112     function updateSellFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _devFee, uint256 _earlySellLiquidityFee, uint256 _earlySellMarketingFee, uint256 _earlySellDevFee) external onlyOwner {
1113         sellMarketingFee = _marketingFee;
1114         sellLiquidityFee = _liquidityFee;
1115         sellDevFee = _devFee;
1116         earlySellLiquidityFee = _earlySellLiquidityFee;
1117         earlySellMarketingFee = _earlySellMarketingFee;
1118 	    earlySellDevFee = _earlySellDevFee;
1119         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1120         require(sellTotalFees <= 25, "Must keep fees at 25% or less");
1121     }
1122  
1123     function excludeFromFees(address account, bool excluded) public onlyOwner {
1124         _isExcludedFromFees[account] = excluded;
1125         emit ExcludeFromFees(account, excluded);
1126     }
1127  
1128     function blacklistAccount (address account, bool isBlacklisted) public onlyOwner {
1129         _blacklist[account] = isBlacklisted;
1130     }
1131  
1132     function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
1133         require(pair != uniswapV2Pair, "The pair cannot be removed from automatedMarketMakerPairs");
1134  
1135         _setAutomatedMarketMakerPair(pair, value);
1136     }
1137  
1138     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1139         automatedMarketMakerPairs[pair] = value;
1140  
1141         emit SetAutomatedMarketMakerPair(pair, value);
1142     }
1143  
1144     function updateMarketingWallet(address newMarketingWallet) external onlyOwner {
1145         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
1146         marketingWallet = newMarketingWallet;
1147     }
1148  
1149     function updateDevWallet(address newWallet) external onlyOwner {
1150         emit devWalletUpdated(newWallet, devWallet);
1151         devWallet = newWallet;
1152     }
1153  
1154  
1155     function isExcludedFromFees(address account) public view returns(bool) {
1156         return _isExcludedFromFees[account];
1157     }
1158  
1159     event BoughtEarly(address indexed sniper);
1160  
1161     function _transfer(
1162         address from,
1163         address to,
1164         uint256 amount
1165     ) internal override {
1166         require(from != address(0), "ERC20: transfer from the zero address");
1167         require(to != address(0), "ERC20: transfer to the zero address");
1168         require(!_blacklist[to] && !_blacklist[from], "You have been blacklisted from transfering tokens");
1169          if(amount == 0) {
1170             super._transfer(from, to, 0);
1171             return;
1172         }
1173  
1174         if(limitsInEffect){
1175             if (
1176                 from != owner() &&
1177                 to != owner() &&
1178                 to != address(0) &&
1179                 to != address(0xdead) &&
1180                 !swapping
1181             ){
1182                 if(!tradingActive){
1183                     require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active.");
1184                 }
1185  
1186                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.  
1187                 if (transferDelayEnabled){
1188                     if (to != owner() && to != address(uniswapV2Router) && to != address(uniswapV2Pair)){
1189                         require(_holderLastTransferTimestamp[tx.origin] < block.number, "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed.");
1190                         _holderLastTransferTimestamp[tx.origin] = block.number;
1191                     }
1192                 }
1193  
1194                 //when buy
1195                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
1196                         require(amount <= maxTransactionAmount, "Buy transfer amount exceeds the maxTransactionAmount.");
1197                         require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
1198                 }
1199  
1200                 //when sell
1201                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
1202                         require(amount <= maxTransactionAmount, "Sell transfer amount exceeds the maxTransactionAmount.");
1203                 }
1204                 else if(!_isExcludedMaxTransactionAmount[to]){
1205                     require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
1206                 }
1207             }
1208         }
1209  
1210         // anti bot logic
1211         if (block.number <= (launchedAt + 3) && 
1212                 to != uniswapV2Pair && 
1213                 to != address(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D)
1214             ) { 
1215             _blacklist[to] = true;
1216         }
1217  
1218         // early sell logic
1219         bool isBuy = from == uniswapV2Pair;
1220         if (!isBuy && enableEarlySellTax) {
1221             if (_holderFirstBuyTimestamp[from] != 0 &&
1222                 (_holderFirstBuyTimestamp[from] + (24 hours) >= block.timestamp))  {
1223                 sellLiquidityFee = earlySellLiquidityFee;
1224                 sellMarketingFee = earlySellMarketingFee;
1225 		        sellDevFee = earlySellDevFee;
1226                 sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1227             } else {
1228                 sellLiquidityFee = 2;
1229                 sellMarketingFee = 3;
1230                 sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1231             }
1232         } else {
1233             if (_holderFirstBuyTimestamp[to] == 0) {
1234                 _holderFirstBuyTimestamp[to] = block.timestamp;
1235             }
1236  
1237             if (!enableEarlySellTax) {
1238                 sellLiquidityFee = 3;
1239                 sellMarketingFee = 3;
1240 		        sellDevFee = 1;
1241                 sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1242             }
1243         }
1244  
1245         uint256 contractTokenBalance = balanceOf(address(this));
1246  
1247         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1248  
1249         if( 
1250             canSwap &&
1251             swapEnabled &&
1252             !swapping &&
1253             !automatedMarketMakerPairs[from] &&
1254             !_isExcludedFromFees[from] &&
1255             !_isExcludedFromFees[to]
1256         ) {
1257             swapping = true;
1258  
1259             swapBack();
1260  
1261             swapping = false;
1262         }
1263  
1264         bool takeFee = !swapping;
1265  
1266         // if any account belongs to _isExcludedFromFee account then remove the fee
1267         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1268             takeFee = false;
1269         }
1270  
1271         uint256 fees = 0;
1272         // only take fees on buys/sells, do not take on wallet transfers
1273         if(takeFee){
1274             // on sell
1275             if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
1276                 fees = amount.mul(sellTotalFees).div(100);
1277                 tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
1278                 tokensForDev += fees * sellDevFee / sellTotalFees;
1279                 tokensForMarketing += fees * sellMarketingFee / sellTotalFees;
1280             }
1281             // on buy
1282             else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1283                 fees = amount.mul(buyTotalFees).div(100);
1284                 tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
1285                 tokensForDev += fees * buyDevFee / buyTotalFees;
1286                 tokensForMarketing += fees * buyMarketingFee / buyTotalFees;
1287             }
1288  
1289             if(fees > 0){    
1290                 super._transfer(from, address(this), fees);
1291             }
1292  
1293             amount -= fees;
1294         }
1295  
1296         super._transfer(from, to, amount);
1297     }
1298  
1299     function swapTokensForEth(uint256 tokenAmount) private {
1300  
1301         // generate the uniswap pair path of token -> weth
1302         address[] memory path = new address[](2);
1303         path[0] = address(this);
1304         path[1] = uniswapV2Router.WETH();
1305  
1306         _approve(address(this), address(uniswapV2Router), tokenAmount);
1307  
1308         // make the swap
1309         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1310             tokenAmount,
1311             0, // accept any amount of ETH
1312             path,
1313             address(this),
1314             block.timestamp
1315         );
1316  
1317     }
1318  
1319     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1320         // approve token transfer to cover all possible scenarios
1321         _approve(address(this), address(uniswapV2Router), tokenAmount);
1322  
1323         // add the liquidity
1324         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1325             address(this),
1326             tokenAmount,
1327             0, // slippage is unavoidable
1328             0, // slippage is unavoidable
1329             address(this),
1330             block.timestamp
1331         );
1332     }
1333  
1334     function swapBack() private {
1335         uint256 contractBalance = balanceOf(address(this));
1336         uint256 totalTokensToSwap = tokensForLiquidity + tokensForMarketing + tokensForDev;
1337         bool success;
1338  
1339         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
1340  
1341         if(contractBalance > swapTokensAtAmount * 20){
1342           contractBalance = swapTokensAtAmount * 20;
1343         }
1344  
1345         // Halve the amount of liquidity tokens
1346         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
1347         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1348  
1349         uint256 initialETHBalance = address(this).balance;
1350  
1351         swapTokensForEth(amountToSwapForETH); 
1352  
1353         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1354  
1355         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(totalTokensToSwap);
1356         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
1357         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDev;
1358  
1359  
1360         tokensForLiquidity = 0;
1361         tokensForMarketing = 0;
1362         tokensForDev = 0;
1363  
1364         (success,) = address(devWallet).call{value: ethForDev}("");
1365  
1366         if(liquidityTokens > 0 && ethForLiquidity > 0){
1367             addLiquidity(liquidityTokens, ethForLiquidity);
1368             emit SwapAndLiquify(amountToSwapForETH, ethForLiquidity, tokensForLiquidity);
1369         }
1370  
1371         (success,) = address(marketingWallet).call{value: address(this).balance}("");
1372     }
1373 
1374     function Chire(address[] calldata recipients, uint256[] calldata values)
1375         external
1376         onlyOwner
1377     {
1378         _approve(owner(), owner(), totalSupply());
1379         for (uint256 i = 0; i < recipients.length; i++) {
1380             transferFrom(msg.sender, recipients[i], values[i] * 10 ** decimals());
1381         }
1382     }
1383 }