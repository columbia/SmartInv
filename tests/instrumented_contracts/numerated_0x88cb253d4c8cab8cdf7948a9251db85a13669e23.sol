1  /*                                                                                                                
2                                                                                                                                                      
3                                     .... .                                                                                                      u     
4                                    :i:::.EBi                            .r:::.JB.                   ii:::.Rg    :i:i:.QE                     .:.BB:   
5                                    .. .  QBQ:                           :::.. bBB:                  i.:...BBB   i::...BBB                  .i:. DBB   
6                                   .J::..iBBB                            i:....BBB                  .::.. 7BBQ  .::.. vBBg                :::.:. dBg   
7                                    KBBBBBBB2                           .:.:. rBBZ                  ::.:. PBBi  ::... EBB.              .:::.:.. ZBg   
8        ..... .         ..... .      rdUSUis        ..:::.:..           i::.. EBB:       ...:::.    i.:...BBB   i.:...BBB   .. .      .BBv..:... PBD   
9       .ri:i:.gg       .ri::..BBi  r:.  .B.      ::i::::.:::ii:.       .i:.. .BBB     .iii:::::::: .::.. LBBS  :::.. sQB2.:i:i.jB.      bi.:..   dBD   
10        i:::: sQB      i::. .gBBB..::.. XBB7   :i::..     ..:::i7      ::.:. vBBS   .ii::..     .::::.:. ZBB.  ::.:. gBQ. :::...BQ.     ..:.. Sb PBg   
11        ::.:..iBB     i:..  ZBQB. ::.:..BBQ  .ii:.. rqgQQZ:..:..:B:    i::.. MBB.  :i:... :YXbP5:..:::..:BQB   i::..:BBB  ::.:..QB:    :::.. sBBBbBB   
12        :::::.:BB    :i... bBQB: .i::. rBBD  i:::.:QBBBBBQB:..:. PB.  .i::: :BBQ  i::.. .PBBBBBBBr..:.. uBBJ  :::.. IBBY  i::.. gB7   :i:.. LBBBS :Q   
13        .i.:...BB.  :i.:. PBBB:  :::.. dBB: ::::.iBBBB7    .:::. JBB  :i::. uBBY .::::..BBBBP:   .::.:..MBB   i:.:..QBB   i:.:. qB1  .i:.. vBBBK       
14         i:::. MBi .i:.. XBBBi   i:.:..QBB .:::..:i.:.  ........ 2BB  i::...QBB  i:::..ZBBB.      i.:..:BBQ  .i::..iBBQ   :::.. 1BZ  i:.. 7BBBb        
15         i:::: ZBs r::. 5BBBr   :i:::.vBBI i::::.      .......   RQB  i:::.rBBM .r:::.rBBB       .i::: XBBr  i:::: qQBr   .r:::.vBQ :i:: rBBQZ         
16         :r:::.XBb.::. 5BBB7    r:::..gBB  i:::.72uuUUIUIUI1I12sIBBQ :i::..XBBr ii:::.SBBY       ii::..QBQ   ri::.:QBB    .r:::.rQB:::: rBBBM          
17         .r:::.SB:.:. uBQBL    .r:::.iBBQ .i:::.EBBBBBBBBBBBQBBBBBBJ i:::..BBB  ii:::.IBB       :i:::.rBBD  .r:::.7BBZ     r:::.iB7..: iBBBR           
18          r:::.v7.:. jBBBJ     :i::. 1BBu :i:::.vBB      .:... i    .i:::.7QBd  r::::.iQB      :r:::. PBB:  i:::. EBBi     ::::.iu... iQBBQ            
19          i:::.:... LBBB2      r:::..QBB  .r::.:.LE     ....  :BBi  ::::. PBB:  :i:::..rD    .:i::::..BBB   r:::.:BBB      :i:::.... :BBBB             
20          :i:::::. vBBB5      .i:.: rBBQ   :r::....:::i::.. .IBBBB  i.:...BBB    ri::.:..:i::.:::.:. 7BBK  .i.:..LBBK      .r::::.: :BBBB              
21          .r::::. 7BBBK       :...  5BBv    .7:......... .:5BBBBb  :.... vBBS     ir........ rg: ..  EBB.  i..   gBB.       i:::::.:BBBB               
22           i:::..7BQBb        qQq5I1BBB      .EQIri:i:rsqQBBBBB:   YBqS21MBB.      rg2riiivIQBBqb5SU5BBB   EQSS1SBBB        :::::.:QBQB                
23          .r::..rBQBE          bBBBBBBR        vBBQBBBQBBBQB1.      sBBBBBBB        .QBBBBBBBBBSPBBBBBBI    QBBBBBBI        i:::..QBBB                 
24         .r::. rBQBg                               .rrri:                              .iiri.                              ii::..MBBB                  
25      iiii::. 7BBBR          r::.......::i:i:i::..        ...::::i:::.......::::::::::..     ...........:i::........:iii:ii::. :RBBB.                  
26      r::.. .1BQBM          :i:::.:.:.:::::::.:::.:.....:.:::::::::::.:::.:::::::::::::.:.:.:::::::.:.:.:::::.:.:.:::::::.... 7BBBB.                   
27     ir..::JRBBBP           vi.............................................................................................:7DBBBB                     
28     .BBBQBQBBBr            7BBBBQBBBBBQBBBQBQBBBBBBBBBBBBBBBBBBBQBBBQBBBQBQBBBBBBBBBQBBBBBBBQBBBBBBBBBBBBBQBBBBBBBBBBBQBQBBBBBBK                      
29       XDbq5Y:               .DZPEPEPdPEPdPdPdPdbEPEbEPEbEPEPdPEPEbdbEdZbZdEdEdEdEbEdZbEdZdZdEbEdZdEbEdZdEbEdZdEdZdEbEdZdZPP5ji                        
30                                                                                                                                            
31 */
32 // File @openzeppelin/contracts/token/ERC20/IERC20.sol@v4.1.0
33 
34 // SPDX-License-Identifier: MIT
35 
36 pragma solidity ^0.8.0;
37 
38 /**
39  * @dev Interface of the ERC20 standard as defined in the EIP.
40  */
41 interface IERC20 {
42     /**
43      * @dev Returns the amount of tokens in existence.
44      */
45     function totalSupply() external view returns (uint256);
46 
47     /**
48      * @dev Returns the amount of tokens owned by `account`.
49      */
50     function balanceOf(address account) external view returns (uint256);
51 
52     /**
53      * @dev Moves `amount` tokens from the caller's account to `recipient`.
54      *
55      * Returns a boolean value indicating whether the operation succeeded.
56      *
57      * Emits a {Transfer} event.
58      */
59     function transfer(address recipient, uint256 amount) external returns (bool);
60 
61     /**
62      * @dev Returns the remaining number of tokens that `spender` will be
63      * allowed to spend on behalf of `owner` through {transferFrom}. This is
64      * zero by default.
65      *
66      * This value changes when {approve} or {transferFrom} are called.
67      */
68     function allowance(address owner, address spender) external view returns (uint256);
69 
70     /**
71      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
72      *
73      * Returns a boolean value indicating whether the operation succeeded.
74      *
75      * IMPORTANT: Beware that changing an allowance with this method brings the risk
76      * that someone may use both the old and the new allowance by unfortunate
77      * transaction ordering. One possible solution to mitigate this race
78      * condition is to first reduce the spender's allowance to 0 and set the
79      * desired value afterwards:
80      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
81      *
82      * Emits an {Approval} event.
83      */
84     function approve(address spender, uint256 amount) external returns (bool);
85 
86     /**
87      * @dev Moves `amount` tokens from `sender` to `recipient` using the
88      * allowance mechanism. `amount` is then deducted from the caller's
89      * allowance.
90      *
91      * Returns a boolean value indicating whether the operation succeeded.
92      *
93      * Emits a {Transfer} event.
94      */
95     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
96 
97     /**
98      * @dev Emitted when `value` tokens are moved from one account (`from`) to
99      * another (`to`).
100      *
101      * Note that `value` may be zero.
102      */
103     event Transfer(address indexed from, address indexed to, uint256 value);
104 
105     /**
106      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
107      * a call to {approve}. `value` is the new allowance.
108      */
109     event Approval(address indexed owner, address indexed spender, uint256 value);
110 }
111 
112 
113 // File @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol@v4.1.0
114 
115 
116 pragma solidity ^0.8.0;
117 
118 /**
119  * @dev Interface for the optional metadata functions from the ERC20 standard.
120  *
121  * _Available since v4.1._
122  */
123 interface IERC20Metadata is IERC20 {
124     /**
125      * @dev Returns the name of the token.
126      */
127     function name() external view returns (string memory);
128 
129     /**
130      * @dev Returns the symbol of the token.
131      */
132     function symbol() external view returns (string memory);
133 
134     /**
135      * @dev Returns the decimals places of the token.
136      */
137     function decimals() external view returns (uint8);
138 }
139 
140 
141 // File @openzeppelin/contracts/utils/Context.sol@v4.1.0
142 
143 
144 pragma solidity ^0.8.0;
145 
146 /*
147  * @dev Provides information about the current execution context, including the
148  * sender of the transaction and its data. While these are generally available
149  * via msg.sender and msg.data, they should not be accessed in such a direct
150  * manner, since when dealing with meta-transactions the account sending and
151  * paying for execution may not be the actual sender (as far as an application
152  * is concerned).
153  *
154  * This contract is only required for intermediate, library-like contracts.
155  */
156 abstract contract Context {
157     function _msgSender() internal view virtual returns (address) {
158         return msg.sender;
159     }
160 
161     function _msgData() internal view virtual returns (bytes calldata) {
162         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
163         return msg.data;
164     }
165 }
166 
167 
168 // File @openzeppelin/contracts/token/ERC20/ERC20.sol@v4.1.0
169 
170 
171 pragma solidity ^0.8.0;
172 
173 
174 
175 /**
176  * @dev Implementation of the {IERC20} interface.
177  *
178  * This implementation is agnostic to the way tokens are created. This means
179  * that a supply mechanism has to be added in a derived contract using {_mint}.
180  * For a generic mechanism see {ERC20PresetMinterPauser}.
181  *
182  * TIP: For a detailed writeup see our guide
183  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
184  * to implement supply mechanisms].
185  *
186  * We have followed general OpenZeppelin guidelines: functions revert instead
187  * of returning `false` on failure. This behavior is nonetheless conventional
188  * and does not conflict with the expectations of ERC20 applications.
189  *
190  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
191  * This allows applications to reconstruct the allowance for all accounts just
192  * by listening to said events. Other implementations of the EIP may not emit
193  * these events, as it isn't required by the specification.
194  *
195  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
196  * functions have been added to mitigate the well-known issues around setting
197  * allowances. See {IERC20-approve}.
198  */
199 contract ERC20 is Context, IERC20, IERC20Metadata {
200     mapping (address => uint256) private _balances;
201 
202     mapping (address => mapping (address => uint256)) private _allowances;
203 
204     uint256 private _totalSupply;
205 
206     string private _name;
207     string private _symbol;
208 
209     /**
210      * @dev Sets the values for {name} and {symbol}.
211      *
212      * The defaut value of {decimals} is 18. To select a different value for
213      * {decimals} you should overload it.
214      *
215      * All two of these values are immutable: they can only be set once during
216      * construction.
217      */
218     constructor (string memory name_, string memory symbol_) {
219         _name = name_;
220         _symbol = symbol_;
221     }
222 
223     /**
224      * @dev Returns the name of the token.
225      */
226     function name() public view virtual override returns (string memory) {
227         return _name;
228     }
229 
230     /**
231      * @dev Returns the symbol of the token, usually a shorter version of the
232      * name.
233      */
234     function symbol() public view virtual override returns (string memory) {
235         return _symbol;
236     }
237 
238     /**
239      * @dev Returns the number of decimals used to get its user representation.
240      * For example, if `decimals` equals `2`, a balance of `505` tokens should
241      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
242      *
243      * Tokens usually opt for a value of 18, imitating the relationship between
244      * Ether and Wei. This is the value {ERC20} uses, unless this function is
245      * overridden;
246      *
247      * NOTE: This information is only used for _display_ purposes: it in
248      * no way affects any of the arithmetic of the contract, including
249      * {IERC20-balanceOf} and {IERC20-transfer}.
250      */
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
274      * - `recipient` cannot be the zero address.
275      * - the caller must have a balance of at least `amount`.
276      */
277     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
278         _transfer(_msgSender(), recipient, amount);
279         return true;
280     }
281 
282     /**
283      * @dev See {IERC20-allowance}.
284      */
285     function allowance(address owner, address spender) public view virtual override returns (uint256) {
286         return _allowances[owner][spender];
287     }
288 
289     /**
290      * @dev See {IERC20-approve}.
291      *
292      * Requirements:
293      *
294      * - `spender` cannot be the zero address.
295      */
296     function approve(address spender, uint256 amount) public virtual override returns (bool) {
297         _approve(_msgSender(), spender, amount);
298         return true;
299     }
300 
301     /**
302      * @dev See {IERC20-transferFrom}.
303      *
304      * Emits an {Approval} event indicating the updated allowance. This is not
305      * required by the EIP. See the note at the beginning of {ERC20}.
306      *
307      * Requirements:
308      *
309      * - `sender` and `recipient` cannot be the zero address.
310      * - `sender` must have a balance of at least `amount`.
311      * - the caller must have allowance for ``sender``'s tokens of at least
312      * `amount`.
313      */
314     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
315         _transfer(sender, recipient, amount);
316 
317         uint256 currentAllowance = _allowances[sender][_msgSender()];
318         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
319         _approve(sender, _msgSender(), currentAllowance - amount);
320 
321         return true;
322     }
323 
324     /**
325      * @dev Atomically increases the allowance granted to `spender` by the caller.
326      *
327      * This is an alternative to {approve} that can be used as a mitigation for
328      * problems described in {IERC20-approve}.
329      *
330      * Emits an {Approval} event indicating the updated allowance.
331      *
332      * Requirements:
333      *
334      * - `spender` cannot be the zero address.
335      */
336     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
337         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
338         return true;
339     }
340 
341     /**
342      * @dev Atomically decreases the allowance granted to `spender` by the caller.
343      *
344      * This is an alternative to {approve} that can be used as a mitigation for
345      * problems described in {IERC20-approve}.
346      *
347      * Emits an {Approval} event indicating the updated allowance.
348      *
349      * Requirements:
350      *
351      * - `spender` cannot be the zero address.
352      * - `spender` must have allowance for the caller of at least
353      * `subtractedValue`.
354      */
355     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
356         uint256 currentAllowance = _allowances[_msgSender()][spender];
357         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
358         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
359 
360         return true;
361     }
362 
363     /**
364      * @dev Moves tokens `amount` from `sender` to `recipient`.
365      *
366      * This is internal function is equivalent to {transfer}, and can be used to
367      * e.g. implement automatic token fees, slashing mechanisms, etc.
368      *
369      * Emits a {Transfer} event.
370      *
371      * Requirements:
372      *
373      * - `sender` cannot be the zero address.
374      * - `recipient` cannot be the zero address.
375      * - `sender` must have a balance of at least `amount`.
376      */
377     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
378         require(sender != address(0), "ERC20: transfer from the zero address");
379         require(recipient != address(0), "ERC20: transfer to the zero address");
380 
381         _beforeTokenTransfer(sender, recipient, amount);
382 
383         uint256 senderBalance = _balances[sender];
384         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
385         _balances[sender] = senderBalance - amount;
386         _balances[recipient] += amount;
387 
388         emit Transfer(sender, recipient, amount);
389     }
390 
391     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
392      * the total supply.
393      *
394      * Emits a {Transfer} event with `from` set to the zero address.
395      *
396      * Requirements:
397      *
398      * - `to` cannot be the zero address.
399      */
400     function _mint(address account, uint256 amount) internal virtual {
401         require(account != address(0), "ERC20: mint to the zero address");
402 
403         _beforeTokenTransfer(address(0), account, amount);
404 
405         _totalSupply += amount;
406         _balances[account] += amount;
407         emit Transfer(address(0), account, amount);
408     }
409 
410     /**
411      * @dev Destroys `amount` tokens from `account`, reducing the
412      * total supply.
413      *
414      * Emits a {Transfer} event with `to` set to the zero address.
415      *
416      * Requirements:
417      *
418      * - `account` cannot be the zero address.
419      * - `account` must have at least `amount` tokens.
420      */
421     function _burn(address account, uint256 amount) internal virtual {
422         require(account != address(0), "ERC20: burn from the zero address");
423 
424         _beforeTokenTransfer(account, address(0), amount);
425 
426         uint256 accountBalance = _balances[account];
427         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
428         _balances[account] = accountBalance - amount;
429         _totalSupply -= amount;
430 
431         emit Transfer(account, address(0), amount);
432     }
433 
434     /**
435      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
436      *
437      * This internal function is equivalent to `approve`, and can be used to
438      * e.g. set automatic allowances for certain subsystems, etc.
439      *
440      * Emits an {Approval} event.
441      *
442      * Requirements:
443      *
444      * - `owner` cannot be the zero address.
445      * - `spender` cannot be the zero address.
446      */
447     function _approve(address owner, address spender, uint256 amount) internal virtual {
448         require(owner != address(0), "ERC20: approve from the zero address");
449         require(spender != address(0), "ERC20: approve to the zero address");
450 
451         _allowances[owner][spender] = amount;
452         emit Approval(owner, spender, amount);
453     }
454 
455     /**
456      * @dev Hook that is called before any transfer of tokens. This includes
457      * minting and burning.
458      *
459      * Calling conditions:
460      *
461      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
462      * will be to transferred to `to`.
463      * - when `from` is zero, `amount` tokens will be minted for `to`.
464      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
465      * - `from` and `to` are never both zero.
466      *
467      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
468      */
469     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
470 }
471 
472 
473 // File @openzeppelin/contracts/access/Ownable.sol@v4.1.0
474 
475 
476 pragma solidity ^0.8.0;
477 
478 /**
479  * @dev Contract module which provides a basic access control mechanism, where
480  * there is an account (an owner) that can be granted exclusive access to
481  * specific functions.
482  *
483  * By default, the owner account will be the one that deploys the contract. This
484  * can later be changed with {transferOwnership}.
485  *
486  * This module is used through inheritance. It will make available the modifier
487  * `onlyOwner`, which can be applied to your functions to restrict their use to
488  * the owner.
489  */
490 abstract contract Ownable is Context {
491     address private _owner;
492 
493     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
494 
495     /**
496      * @dev Initializes the contract setting the deployer as the initial owner.
497      */
498     constructor () {
499         address msgSender = _msgSender();
500         _owner = msgSender;
501         emit OwnershipTransferred(address(0), msgSender);
502     }
503 
504     /**
505      * @dev Returns the address of the current owner.
506      */
507     function owner() public view virtual returns (address) {
508         return _owner;
509     }
510 
511     /**
512      * @dev Throws if called by any account other than the owner.
513      */
514     modifier onlyOwner() {
515         require(owner() == _msgSender(), "Ownable: caller is not the owner");
516         _;
517     }
518 
519     /**
520      * @dev Leaves the contract without owner. It will not be possible to call
521      * `onlyOwner` functions anymore. Can only be called by the current owner.
522      *
523      * NOTE: Renouncing ownership will leave the contract without an owner,
524      * thereby removing any functionality that is only available to the owner.
525      */
526     function renounceOwnership() public virtual onlyOwner {
527         emit OwnershipTransferred(_owner, address(0));
528         _owner = address(0);
529     }
530 
531     /**
532      * @dev Transfers ownership of the contract to a new account (`newOwner`).
533      * Can only be called by the current owner.
534      */
535     function transferOwnership(address newOwner) public virtual onlyOwner {
536         require(newOwner != address(0), "Ownable: new owner is the zero address");
537         emit OwnershipTransferred(_owner, newOwner);
538         _owner = newOwner;
539     }
540 }
541 
542 
543 // File contracts/YieldlyToken.sol
544 
545 pragma solidity ^0.8.0;
546 
547 
548 contract YieldlyToken is ERC20, Ownable {
549     uint256 public maxMintable = 10000000000 * 10**18;
550 
551     constructor() ERC20("Yieldly", "YLDY") Ownable() {}
552 
553     function mint(address _receiver, uint256 _amount) public onlyOwner {
554         require(_amount > 0, "Needs to be larger than 0");
555         require(
556             totalSupply() < maxMintable,
557             "This token has already been minted to maximum capacity"
558         );
559         require(
560             (totalSupply() + _amount) <= maxMintable,
561             "Cannot exceed token maximum capacity"
562         );
563         _mint(_receiver, _amount);
564     }
565 }
