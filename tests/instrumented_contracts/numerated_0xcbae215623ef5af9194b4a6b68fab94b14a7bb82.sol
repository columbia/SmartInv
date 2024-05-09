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
31                
32 */
33 
34 // File contracts/openzeppelin_contracts/utils/Context.sol
35 
36 // SPDX-License-Identifier: MIT
37 
38 pragma solidity ^0.8.0;
39 
40 /*
41  * @dev Provides information about the current execution context, including the
42  * sender of the transaction and its data. While these are generally available
43  * via msg.sender and msg.data, they should not be accessed in such a direct
44  * manner, since when dealing with meta-transactions the account sending and
45  * paying for execution may not be the actual sender (as far as an application
46  * is concerned).
47  *
48  * This contract is only required for intermediate, library-like contracts.
49  */
50 abstract contract Context {
51     function _msgSender() internal view virtual returns (address) {
52         return msg.sender;
53     }
54 
55     function _msgData() internal view virtual returns (bytes calldata) {
56         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
57         return msg.data;
58     }
59 }
60 
61 
62 // File contracts/openzeppelin_contracts/access/Ownable.sol
63 
64 
65 pragma solidity ^0.8.0;
66 
67 /**
68  * @dev Contract module which provides a basic access control mechanism, where
69  * there is an account (an owner) that can be granted exclusive access to
70  * specific functions.
71  *
72  * By default, the owner account will be the one that deploys the contract. This
73  * can later be changed with {transferOwnership}.
74  *
75  * This module is used through inheritance. It will make available the modifier
76  * `onlyOwner`, which can be applied to your functions to restrict their use to
77  * the owner.
78  */
79 abstract contract Ownable is Context {
80     address private _owner;
81 
82     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
83 
84     /**
85      * @dev Initializes the contract setting the deployer as the initial owner.
86      */
87     constructor () {
88         address msgSender = _msgSender();
89         _owner = msgSender;
90         emit OwnershipTransferred(address(0), msgSender);
91     }
92 
93     /**
94      * @dev Returns the address of the current owner.
95      */
96     function owner() public view virtual returns (address) {
97         return _owner;
98     }
99 
100     /**
101      * @dev Throws if called by any account other than the owner.
102      */
103     modifier onlyOwner() {
104         require(owner() == _msgSender(), "Ownable: caller is not the owner");
105         _;
106     }
107 
108     /**
109      * @dev Leaves the contract without owner. It will not be possible to call
110      * `onlyOwner` functions anymore. Can only be called by the current owner.
111      *
112      * NOTE: Renouncing ownership will leave the contract without an owner,
113      * thereby removing any functionality that is only available to the owner.
114      */
115     function renounceOwnership() public virtual onlyOwner {
116         revert("Cannot renounceOwnership with this contract");
117         //not possible for these contracts
118     }
119 
120     /**
121      * @dev Transfers ownership of the contract to a new account (`newOwner`).
122      * Can only be called by the current owner.
123      */
124     function transferOwnership(address newOwner) public virtual onlyOwner {
125         require(newOwner != address(0), "Ownable: new owner is the zero address");
126         emit OwnershipTransferred(_owner, newOwner);
127         _owner = newOwner;
128     }
129 }
130 
131 
132 // File contracts/openzeppelin_contracts/token/ERC20/IERC20.sol
133 
134 
135 pragma solidity ^0.8.0;
136 
137 /**
138  * @dev Interface of the ERC20 standard as defined in the EIP.
139  */
140 interface IERC20 {
141     /**
142      * @dev Returns the amount of tokens in existence.
143      */
144     function totalSupply() external view returns (uint256);
145 
146     /**
147      * @dev Returns the amount of tokens owned by `account`.
148      */
149     function balanceOf(address account) external view returns (uint256);
150 
151     /**
152      * @dev Moves `amount` tokens from the caller's account to `recipient`.
153      *
154      * Returns a boolean value indicating whether the operation succeeded.
155      *
156      * Emits a {Transfer} event.
157      */
158     function transfer(address recipient, uint256 amount) external returns (bool);
159 
160     /**
161      * @dev Returns the remaining number of tokens that `spender` will be
162      * allowed to spend on behalf of `owner` through {transferFrom}. This is
163      * zero by default.
164      *
165      * This value changes when {approve} or {transferFrom} are called.
166      */
167     function allowance(address owner, address spender) external view returns (uint256);
168 
169     /**
170      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
171      *
172      * Returns a boolean value indicating whether the operation succeeded.
173      *
174      * IMPORTANT: Beware that changing an allowance with this method brings the risk
175      * that someone may use both the old and the new allowance by unfortunate
176      * transaction ordering. One possible solution to mitigate this race
177      * condition is to first reduce the spender's allowance to 0 and set the
178      * desired value afterwards:
179      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
180      *
181      * Emits an {Approval} event.
182      */
183     function approve(address spender, uint256 amount) external returns (bool);
184 
185     /**
186      * @dev Moves `amount` tokens from `sender` to `recipient` using the
187      * allowance mechanism. `amount` is then deducted from the caller's
188      * allowance.
189      *
190      * Returns a boolean value indicating whether the operation succeeded.
191      *
192      * Emits a {Transfer} event.
193      */
194     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
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
211 
212 // File contracts/openzeppelin_contracts/token/ERC20/ERC20.sol
213 
214 
215 pragma solidity ^0.8.0;
216 
217 
218 /**
219  * @dev Implementation of the {IERC20} interface.
220  *
221  * This implementation is agnostic to the way tokens are created. This means
222  * that a supply mechanism has to be added in a derived contract using {_mint}.
223  * For a generic mechanism see {ERC20PresetMinterPauser}.
224  *
225  * TIP: For a detailed writeup see our guide
226  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
227  * to implement supply mechanisms].
228  *
229  * We have followed general OpenZeppelin guidelines: functions revert instead
230  * of returning `false` on failure. This behavior is nonetheless conventional
231  * and does not conflict with the expectations of ERC20 applications.
232  *
233  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
234  * This allows applications to reconstruct the allowance for all accounts just
235  * by listening to said events. Other implementations of the EIP may not emit
236  * these events, as it isn't required by the specification.
237  *
238  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
239  * functions have been added to mitigate the well-known issues around setting
240  * allowances. See {IERC20-approve}.
241  */
242 contract ERC20 is Context, IERC20 {
243     mapping (address => uint256) private _balances;
244 
245     mapping (address => mapping (address => uint256)) private _allowances;
246 
247     uint256 private _totalSupply;
248 
249     string private _name;
250     string private _symbol;
251 
252     /**
253      * @dev Sets the values for {name} and {symbol}.
254      *
255      * The defaut value of {decimals} is 18. To select a different value for
256      * {decimals} you should overload it.
257      *
258      * All three of these values are immutable: they can only be set once during
259      * construction.
260      */
261     constructor (string memory name_, string memory symbol_) {
262         _name = name_;
263         _symbol = symbol_;
264     }
265 
266     /**
267      * @dev Returns the name of the token.
268      */
269     function name() public view virtual returns (string memory) {
270         return _name;
271     }
272 
273     /**
274      * @dev Returns the symbol of the token, usually a shorter version of the
275      * name.
276      */
277     function symbol() public view virtual returns (string memory) {
278         return _symbol;
279     }
280 
281     /**
282      * @dev Returns the number of decimals used to get its user representation.
283      * For example, if `decimals` equals `2`, a balance of `505` tokens should
284      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
285      *
286      * Tokens usually opt for a value of 18, imitating the relationship between
287      * Ether and Wei. This is the value {ERC20} uses, unless this function is
288      * overloaded;
289      *
290      * NOTE: This information is only used for _display_ purposes: it in
291      * no way affects any of the arithmetic of the contract, including
292      * {IERC20-balanceOf} and {IERC20-transfer}.
293      */
294     function decimals() public view virtual returns (uint8) {
295         return 18;
296     }
297 
298     /**
299      * @dev See {IERC20-totalSupply}.
300      */
301     function totalSupply() public view virtual override returns (uint256) {
302         return _totalSupply;
303     }
304 
305     /**
306      * @dev See {IERC20-balanceOf}.
307      */
308     function balanceOf(address account) public view virtual override returns (uint256) {
309         return _balances[account];
310     }
311 
312     /**
313      * @dev See {IERC20-transfer}.
314      *
315      * Requirements:
316      *
317      * - `recipient` cannot be the zero address.
318      * - the caller must have a balance of at least `amount`.
319      */
320     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
321         _transfer(_msgSender(), recipient, amount);
322         return true;
323     }
324 
325     /**
326      * @dev See {IERC20-allowance}.
327      */
328     function allowance(address owner, address spender) public view virtual override returns (uint256) {
329         return _allowances[owner][spender];
330     }
331 
332     /**
333      * @dev See {IERC20-approve}.
334      *
335      * Requirements:
336      *
337      * - `spender` cannot be the zero address.
338      */
339     function approve(address spender, uint256 amount) public virtual override returns (bool) {
340         _approve(_msgSender(), spender, amount);
341         return true;
342     }
343 
344     /**
345      * @dev See {IERC20-transferFrom}.
346      *
347      * Emits an {Approval} event indicating the updated allowance. This is not
348      * required by the EIP. See the note at the beginning of {ERC20}.
349      *
350      * Requirements:
351      *
352      * - `sender` and `recipient` cannot be the zero address.
353      * - `sender` must have a balance of at least `amount`.
354      * - the caller must have allowance for ``sender``'s tokens of at least
355      * `amount`.
356      */
357     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
358         _transfer(sender, recipient, amount);
359 
360         uint256 currentAllowance = _allowances[sender][_msgSender()];
361         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
362         _approve(sender, _msgSender(), currentAllowance - amount);
363 
364         return true;
365     }
366 
367     /**
368      * @dev Atomically increases the allowance granted to `spender` by the caller.
369      *
370      * This is an alternative to {approve} that can be used as a mitigation for
371      * problems described in {IERC20-approve}.
372      *
373      * Emits an {Approval} event indicating the updated allowance.
374      *
375      * Requirements:
376      *
377      * - `spender` cannot be the zero address.
378      */
379     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
380         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
381         return true;
382     }
383 
384     /**
385      * @dev Atomically decreases the allowance granted to `spender` by the caller.
386      *
387      * This is an alternative to {approve} that can be used as a mitigation for
388      * problems described in {IERC20-approve}.
389      *
390      * Emits an {Approval} event indicating the updated allowance.
391      *
392      * Requirements:
393      *
394      * - `spender` cannot be the zero address.
395      * - `spender` must have allowance for the caller of at least
396      * `subtractedValue`.
397      */
398     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
399         uint256 currentAllowance = _allowances[_msgSender()][spender];
400         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
401         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
402 
403         return true;
404     }
405 
406     /**
407      * @dev Moves tokens `amount` from `sender` to `recipient`.
408      *
409      * This is internal function is equivalent to {transfer}, and can be used to
410      * e.g. implement automatic token fees, slashing mechanisms, etc.
411      *
412      * Emits a {Transfer} event.
413      *
414      * Requirements:
415      *
416      * - `sender` cannot be the zero address.
417      * - `recipient` cannot be the zero address.
418      * - `sender` must have a balance of at least `amount`.
419      */
420     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
421         require(sender != address(0), "ERC20: transfer from the zero address");
422         require(recipient != address(0), "ERC20: transfer to the zero address");
423 
424         _beforeTokenTransfer(sender, recipient, amount);
425 
426         uint256 senderBalance = _balances[sender];
427         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
428         _balances[sender] = senderBalance - amount;
429         _balances[recipient] += amount;
430 
431         emit Transfer(sender, recipient, amount);
432     }
433 
434     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
435      * the total supply.
436      *
437      * Emits a {Transfer} event with `from` set to the zero address.
438      *
439      * Requirements:
440      *
441      * - `to` cannot be the zero address.
442      */
443     function _mint(address account, uint256 amount) internal virtual {
444         require(account != address(0), "ERC20: mint to the zero address");
445 
446         _beforeTokenTransfer(address(0), account, amount);
447 
448         _totalSupply += amount;
449         _balances[account] += amount;
450         emit Transfer(address(0), account, amount);
451     }
452 
453     /**
454      * @dev Destroys `amount` tokens from `account`, reducing the
455      * total supply.
456      *
457      * Emits a {Transfer} event with `to` set to the zero address.
458      *
459      * Requirements:
460      *
461      * - `account` cannot be the zero address.
462      * - `account` must have at least `amount` tokens.
463      */
464     function _burn(address account, uint256 amount) internal virtual {
465         require(account != address(0), "ERC20: burn from the zero address");
466 
467         _beforeTokenTransfer(account, address(0), amount);
468 
469         uint256 accountBalance = _balances[account];
470         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
471         _balances[account] = accountBalance - amount;
472         _totalSupply -= amount;
473 
474         emit Transfer(account, address(0), amount);
475     }
476 
477     /**
478      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
479      *
480      * This internal function is equivalent to `approve`, and can be used to
481      * e.g. set automatic allowances for certain subsystems, etc.
482      *
483      * Emits an {Approval} event.
484      *
485      * Requirements:
486      *
487      * - `owner` cannot be the zero address.
488      * - `spender` cannot be the zero address.
489      */
490     function _approve(address owner, address spender, uint256 amount) internal virtual {
491         require(owner != address(0), "ERC20: approve from the zero address");
492         require(spender != address(0), "ERC20: approve to the zero address");
493 
494         _allowances[owner][spender] = amount;
495         emit Approval(owner, spender, amount);
496     }
497 
498     /**
499      * @dev Hook that is called before any transfer of tokens. This includes
500      * minting and burning.
501      *
502      * Calling conditions:
503      *
504      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
505      * will be to transferred to `to`.
506      * - when `from` is zero, `amount` tokens will be minted for `to`.
507      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
508      * - `from` and `to` are never both zero.
509      *
510      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
511      */
512     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
513 }
514 
515 
516 // File contracts/Vault.sol
517 
518 pragma solidity 0.8.4;
519 contract Vault is Ownable {
520     address private dispatcherAddress;
521     address private multiSigAddress;
522     address[] private tokens;
523 
524     struct supportedToken {
525         ERC20 token;
526         bool active;
527     }
528 
529     mapping(address => supportedToken) private tokensStore;
530 
531     constructor(address _multiSigAddress) Ownable() {
532         require(_multiSigAddress != address(0), "Cannot set address to 0");
533         multiSigAddress = _multiSigAddress;
534     }
535 
536     /*****************  Getters **************** */
537 
538     function getDispatcherAddress() public view returns (address) {
539         return dispatcherAddress;
540     }
541 
542     function getMultiSigAddress() public view returns (address) {
543         return multiSigAddress;
544     }
545 
546     function getTokenAddresses() public view returns (address[] memory) {
547         return tokens;
548     }
549 
550     /***************** Calls **************** */
551     function transferFunds(address _tokenAddress, address _recipient, uint256 _amount) external onlyDispatcher {
552         require(tokensStore[_tokenAddress].active == true, "Token not supported");
553         require(_amount > 0, "Cannot transfer 0 tokens");
554         ERC20(_tokenAddress).transfer(_recipient, _amount);
555         emit ReleasedFundsEvent(_recipient, _amount);
556     }
557 
558     function newMultiSig(address _multiSigAddress) external onlyMultiSig {
559         require(_multiSigAddress != address(0), "Cannot set address to 0");
560         multiSigAddress = _multiSigAddress;
561         emit NewMultiSigEvent(_multiSigAddress);
562     }
563 
564     function newDispatcher(address _dispatcherAddress) external onlyMultiSig {
565         require(_dispatcherAddress != address(0), "Can't set address to 0");
566         dispatcherAddress = _dispatcherAddress;
567         emit NewDispatcherEvent(dispatcherAddress);
568     }
569 
570     function addToken(address _tokenAddress) external onlyMultiSig {
571         require(tokensStore[_tokenAddress].active != true, "Token already supported");
572         tokensStore[_tokenAddress].token = ERC20(_tokenAddress);
573         tokensStore[_tokenAddress].active = true;
574         tokens.push(_tokenAddress);
575         emit AddTokenEvent(_tokenAddress);
576     }
577 
578     function removeToken(address _tokenAddress) external onlyMultiSig {
579         require(tokensStore[_tokenAddress].active == true, "Token not supported already");
580         tokensStore[_tokenAddress].active = false;
581         popTokenArray(_tokenAddress);
582         emit RemoveTokenEvent(_tokenAddress);
583     }
584 
585     /*****************  Internal **************** */
586 
587     function popTokenArray(address _tokenAddress) private {
588         for(uint256 i = 0; i <= tokens.length; i++)
589         {
590             if(_tokenAddress == tokens[i])
591             {
592                 tokens[i] = tokens[tokens.length - 1];
593                 tokens.pop();
594                 break;
595             }
596         }
597     }
598 
599     /*****************  Modifiers **************** */
600 
601     modifier onlyDispatcher() {
602         require(dispatcherAddress == msg.sender, "Not the disptacher");
603         _;
604     }
605 
606     modifier onlyMultiSig() {
607         require(multiSigAddress == msg.sender, "Not the multisig");
608         _;
609     }
610 
611     /*****************  Events **************** */
612     event NewMultiSigEvent(address newMultiSigAddress);
613     event AddTokenEvent(address newTokenAddress);
614     event RemoveTokenEvent(address removedTokenAddress);
615     event NewDispatcherEvent(address newdDspatcherAddress);
616     event ReleasedFundsEvent(address indexed recipient, uint256 amount);
617 }
618 
619 
620 // File contracts/Dispatcher.sol
621 
622 pragma solidity 0.8.4;
623 contract Dispatcher is Ownable {
624 
625     Vault private vault;
626 
627     address private multiSigAddress;
628     address private bridgeControllerAddress;
629     address[] private validators;
630 
631     uint256 private valThreshold = 1;
632     uint256 private uuid = 0;
633 
634     uint256[] private outstandingTransferProposalsIndex;
635 
636     struct transferProposal {
637         address recipientAddress;
638         uint256 amount;
639         address tokenAddress;
640         address[] signatures;
641         string note;
642         bool signed;
643     }
644     mapping(uint256 => transferProposal) private transferProposalStore;
645 
646     mapping(string => string) private transactions;
647 
648     constructor(address _vaultAddress, address _multiSigAddress) Ownable() {
649         require(_multiSigAddress != address(0), "Cannot set address to 0");
650         multiSigAddress = _multiSigAddress;
651         vault = Vault(_vaultAddress);
652         bridgeControllerAddress = msg.sender;
653     }
654 
655     /*****************  Getters **************** */
656     function getBridgeController() public view returns (address) 
657     {
658         return bridgeControllerAddress;
659     }
660 
661     function getValidators() public view returns (address[] memory) 
662     {
663         return validators;
664     }
665 
666     function getVaultAddress() public view returns (Vault) 
667     {
668         return vault;
669     }
670 
671     function getMultiSig() public view returns (address) 
672     {
673         return multiSigAddress;
674     }
675     
676     function getOutstandingTransferProposals() public view returns (uint256[] memory) {
677         return outstandingTransferProposalsIndex;
678     }
679 
680     function getValThreshold() public view returns (uint256) 
681     {
682         return valThreshold;
683     }
684     function getCreatedTransanction(string memory txID) public view returns (string memory)
685     {
686         return transactions[txID];
687     }
688 
689     function getUUID() public view returns (uint256)
690     {
691         return uuid;
692     }
693 
694     /*****************  Setters **************** */
695     function newThreshold(uint256 _threshold) external onlyMultiSig {
696         require(_threshold <= validators.length, "Validation threshold cannot exceed amount of validators");
697         require(_threshold > 0, "Threshold must be greater than 0");
698         valThreshold = _threshold;
699         emit NewThresholdEvent(_threshold);
700     }
701 
702     function newMultiSig(address _multiSigAddress) external onlyMultiSig {
703         require(_multiSigAddress != address(0), "Cannot set address to 0");
704         multiSigAddress = _multiSigAddress;
705         emit NewMultiSigEvent(_multiSigAddress);
706     }
707 
708 
709     function newVault(address _vaultAddress) external onlyMultiSig {
710         require(_vaultAddress != address(0), "Vault address cannot be 0");
711         vault = Vault(_vaultAddress);
712         emit NewVault(_vaultAddress);
713     }
714 
715     function newBridgeController(address _bridgeControllerAddress) external onlyMultiSig {
716         require(_bridgeControllerAddress != address(0), "Bridge controller address cannot be 0");
717         bridgeControllerAddress = _bridgeControllerAddress;
718         emit NewBridgeController(_bridgeControllerAddress);
719     }
720 
721     function addNewValidator(address _validatorAddress) external onlyMultiSig {
722         require(_validatorAddress != address(0), "Validator cannot be 0");
723         validators.push(_validatorAddress);
724         emit AddedNewValidator(_validatorAddress);
725     }
726 
727     function removeValidator(address _validatorAddress) external onlyMultiSig {
728         //Remove a validator threshold count in order to avoid not having enough validators
729         for(uint256 i = 0; i <= validators.length; i++)
730         {
731             if(validators[i] == _validatorAddress)
732             {
733                 validators[i] = validators[validators.length - 1];
734                 validators.pop();
735                 if(valThreshold > 1)
736                 {
737                     valThreshold = valThreshold - 1;
738                 }
739                 break;
740             }
741         }
742         emit RemovedValidator(_validatorAddress);
743     }
744 
745 
746     /***************** Calls **************** */
747 
748     function proposeNewTxn(address _userAddress, address _tokenAddress, uint256 _amount, string memory _note) external onlyBridgeController{
749         transferProposalStore[uuid].recipientAddress = _userAddress;
750         transferProposalStore[uuid].amount = _amount;
751         transferProposalStore[uuid].tokenAddress = _tokenAddress;
752         transferProposalStore[uuid].note = _note;
753         if(valThreshold == 1)
754         {
755             vault.transferFunds(transferProposalStore[uuid].tokenAddress, transferProposalStore[uuid].recipientAddress, transferProposalStore[uuid].amount);
756             emit ApprovedTransaction(transferProposalStore[uuid].recipientAddress, transferProposalStore[uuid].amount, uuid);
757             emit proposalCreated(uuid);
758             transferProposalStore[uuid].signed = true;
759         }
760         else
761         {
762             transferProposalStore[uuid].signatures.push(msg.sender);
763             outstandingTransferProposalsIndex.push(uuid);
764             emit proposalCreated(uuid);
765         }
766         uuid += 1;
767     }
768 
769     function approveTxn(uint256 _proposal) external onlyValidators oneVoteTransfer(_proposal){
770         require(transferProposalStore[_proposal].signed == false, "Already Signed");
771 
772         transferProposalStore[_proposal].signatures.push(msg.sender);
773 
774         if (transferProposalStore[_proposal].signatures.length >= valThreshold) {
775             vault.transferFunds(transferProposalStore[_proposal].tokenAddress, transferProposalStore[_proposal].recipientAddress, transferProposalStore[_proposal].amount);
776             popTransferProposal(_proposal);
777             emit ApprovedTransaction(transferProposalStore[_proposal].recipientAddress, transferProposalStore[_proposal].amount, _proposal);
778         }
779     }
780 
781     function createTxn(
782     string memory _id, 
783     string memory _note,
784     address _tokenAddress,
785     uint256 _calculatedFee,
786     uint256 _amount
787     ) external payable{
788         require(_amount > 0, "Must send an amount");
789         require(msg.value == _calculatedFee, "Calculated fee sent wrong");
790         require(bytes(transactions[_id]).length == 0, "Must be a new transaction");
791         transactions[_id] = _note;
792         ERC20(_tokenAddress).transferFrom(msg.sender, address(vault), _amount);
793         payable(bridgeControllerAddress).transfer(msg.value);
794         emit NewTransactionCreated(msg.sender, _tokenAddress, _amount);
795     }
796 
797 
798     /*****************  Internal **************** */
799 
800     function popTransferProposal(uint256 _uuid) private {
801         for(uint256 i = 0; i <= outstandingTransferProposalsIndex.length; i++)
802         {
803             if(outstandingTransferProposalsIndex[i] == _uuid)
804             {
805                 outstandingTransferProposalsIndex[i] = outstandingTransferProposalsIndex[outstandingTransferProposalsIndex.length - 1];
806                 outstandingTransferProposalsIndex.pop();
807                 break;
808             }
809         }
810     }
811 
812     /*****************  Modifiers **************** */
813     modifier onlyBridgeController() {
814         require(bridgeControllerAddress == msg.sender, "Only the controller can create new transactions");
815         _;
816     }
817     
818     modifier onlyMultiSig() {
819         require(multiSigAddress == msg.sender, "Not the multisig");
820         _;
821     }
822 
823     modifier onlyValidators() {
824         for (uint256 i = 0; i < validators.length; i++) {
825             if (validators[i] == msg.sender) {
826                 _;
827             }
828         }
829     }
830 
831     modifier oneVoteTransfer (uint256 _proposal) {
832         for(uint256 i = 0; i < transferProposalStore[_proposal].signatures.length; i++){
833             require(transferProposalStore[_proposal].signatures[i] != msg.sender, "You have already voted");
834         }
835 
836         _;
837     }
838 
839         /*****************  Events **************** */
840     event NewVault(address newAddress); 
841     event NewMultiSigEvent(address newMultiSigAddress);
842     event AddedNewValidator(address newValidator);
843     event RemovedValidator(address oldValidator);
844     event NewBridgeController(address newBridgeController);
845     event NewThresholdEvent(uint256 newThreshold);
846     event proposalCreated(uint256 UUID);
847     event ApprovedTransaction(address indexed recipient, uint256 amount, uint256 UUID);
848     event NewTransactionCreated(address indexed sender, address tokenAddress, uint256 amount);
849     event ReleasedFunds(address indexed recipient, uint256 amount);
850 }
