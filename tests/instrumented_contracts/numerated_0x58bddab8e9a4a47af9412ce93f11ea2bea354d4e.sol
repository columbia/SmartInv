1 /*********************
2      * www.publicoin.info *
3      **********************/
4 
5 // File: @openzeppelin/contracts/utils/Context.sol
6  
7  
8 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
9  
10 pragma solidity ^0.8.0;
11  
12 /**
13 * @dev Provides information about the current execution context, including the
14 * sender of the transaction and its data. While these are generally available
15 * via msg.sender and msg.data, they should not be accessed in such a direct
16 * manner, since when dealing with meta-transactions the account sending and
17 * paying for execution may not be the actual sender (as far as an application
18 * is concerned).
19 *
20 * This contract is only required for intermediate, library-like contracts.
21 */
22 abstract contract Context {
23    function _msgSender() internal view virtual returns (address) {
24        return msg.sender;
25    }
26  
27    function _msgData() internal view virtual returns (bytes calldata) {
28        return msg.data;
29    }
30 }
31  
32 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
33  
34  
35 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
36  
37 pragma solidity ^0.8.0;
38  
39 /**
40 * @dev Interface of the ERC20 standard as defined in the EIP.
41 */
42 interface IERC20 {
43    /**
44     * @dev Emitted when `value` tokens are moved from one account (`from`) to
45     * another (`to`).
46     *
47     * Note that `value` may be zero.
48     */
49    event Transfer(address indexed from, address indexed to, uint256 value);
50  
51    /**
52     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
53     * a call to {approve}. `value` is the new allowance.
54     */
55    event Approval(address indexed owner, address indexed spender, uint256 value);
56  
57    /**
58     * @dev Returns the amount of tokens in existence.
59     */
60    function totalSupply() external view returns (uint256);
61  
62    /**
63     * @dev Returns the amount of tokens owned by `account`.
64     */
65    function balanceOf(address account) external view returns (uint256);
66  
67    /**
68     * @dev Moves `amount` tokens from the caller's account to `to`.
69     *
70     * Returns a boolean value indicating whether the operation succeeded.
71     *
72     * Emits a {Transfer} event.
73     */
74    function transfer(address to, uint256 amount) external returns (bool);
75  
76    /**
77     * @dev Returns the remaining number of tokens that `spender` will be
78     * allowed to spend on behalf of `owner` through {transferFrom}. This is
79     * zero by default.
80     *
81     * This value changes when {approve} or {transferFrom} are called.
82     */
83    function allowance(address owner, address spender) external view returns (uint256);
84  
85    /**
86     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
87     *
88     * Returns a boolean value indicating whether the operation succeeded.
89     *
90     * IMPORTANT: Beware that changing an allowance with this method brings the risk
91     * that someone may use both the old and the new allowance by unfortunate
92     * transaction ordering. One possible solution to mitigate this race
93     * condition is to first reduce the spender's allowance to 0 and set the
94     * desired value afterwards:
95     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
96     *
97     * Emits an {Approval} event.
98     */
99    function approve(address spender, uint256 amount) external returns (bool);
100  
101    /**
102     * @dev Moves `amount` tokens from `from` to `to` using the
103     * allowance mechanism. `amount` is then deducted from the caller's
104     * allowance.
105     *
106     * Returns a boolean value indicating whether the operation succeeded.
107     *
108     * Emits a {Transfer} event.
109     */
110    function transferFrom(
111        address from,
112        address to,
113        uint256 amount
114    ) external returns (bool);
115 }
116  
117 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
118  
119  
120 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
121  
122 pragma solidity ^0.8.0;
123  
124  
125 /**
126 * @dev Interface for the optional metadata functions from the ERC20 standard.
127 *
128 * _Available since v4.1._
129 */
130 interface IERC20Metadata is IERC20 {
131    /**
132     * @dev Returns the name of the token.
133     */
134    function name() external view returns (string memory);
135  
136    /**
137     * @dev Returns the symbol of the token.
138     */
139    function symbol() external view returns (string memory);
140  
141    /**
142     * @dev Returns the decimals places of the token.
143     */
144    function decimals() external view returns (uint8);
145 }
146  
147 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
148  
149  
150 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC20/ERC20.sol)
151  
152 pragma solidity ^0.8.0;
153  
154  
155  
156  
157 /**
158 * @dev Implementation of the {IERC20} interface.
159 *
160 * This implementation is agnostic to the way tokens are created. This means
161 * that a supply mechanism has to be added in a derived contract using {_mint}.
162 * For a generic mechanism see {ERC20PresetMinterPauser}.
163 *
164 * TIP: For a detailed writeup see our guide
165 * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
166 * to implement supply mechanisms].
167 *
168 * We have followed general OpenZeppelin Contracts guidelines: functions revert
169 * instead returning `false` on failure. This behavior is nonetheless
170 * conventional and does not conflict with the expectations of ERC20
171 * applications.
172 *
173 * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
174 * This allows applications to reconstruct the allowance for all accounts just
175 * by listening to said events. Other implementations of the EIP may not emit
176 * these events, as it isn't required by the specification.
177 *
178 * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
179 * functions have been added to mitigate the well-known issues around setting
180 * allowances. See {IERC20-approve}.
181 */
182 contract ERC20 is Context, IERC20, IERC20Metadata {
183    mapping(address => uint256) private _balances;
184  
185    mapping(address => mapping(address => uint256)) private _allowances;
186  
187    uint256 private _totalSupply;
188  
189    string private _name;
190    string private _symbol;
191  
192    /**
193     * @dev Sets the values for {name} and {symbol}.
194     *
195     * The default value of {decimals} is 18. To select a different value for
196     * {decimals} you should overload it.
197     *
198     * All two of these values are immutable: they can only be set once during
199     * construction.
200     */
201    constructor(string memory name_, string memory symbol_) {
202        _name = name_;
203        _symbol = symbol_;
204    }
205  
206    /**
207     * @dev Returns the name of the token.
208     */
209    function name() public view virtual override returns (string memory) {
210        return _name;
211    }
212  
213    /**
214     * @dev Returns the symbol of the token, usually a shorter version of the
215     * name.
216     */
217    function symbol() public view virtual override returns (string memory) {
218        return _symbol;
219    }
220  
221    /**
222     * @dev Returns the number of decimals used to get its user representation.
223     * For example, if `decimals` equals `2`, a balance of `505` tokens should
224     * be displayed to a user as `5.05` (`505 / 10 ** 2`).
225     *
226     * Tokens usually opt for a value of 18, imitating the relationship between
227     * Ether and Wei. This is the value {ERC20} uses, unless this function is
228     * overridden;
229     *
230     * NOTE: This information is only used for _display_ purposes: it in
231     * no way affects any of the arithmetic of the contract, including
232     * {IERC20-balanceOf} and {IERC20-transfer}.
233     */
234    function decimals() public view virtual override returns (uint8) {
235        return 18;
236    }
237  
238    /**
239     * @dev See {IERC20-totalSupply}.
240     */
241    function totalSupply() public view virtual override returns (uint256) {
242        return _totalSupply;
243    }
244  
245    /**
246     * @dev See {IERC20-balanceOf}.
247     */
248    function balanceOf(address account) public view virtual override returns (uint256) {
249        return _balances[account];
250    }
251  
252    /**
253     * @dev See {IERC20-transfer}.
254     *
255     * Requirements:
256     *
257     * - `to` cannot be the zero address.
258     * - the caller must have a balance of at least `amount`.
259     */
260    function transfer(address to, uint256 amount) public virtual override returns (bool) {
261        address owner = _msgSender();
262        _transfer(owner, to, amount);
263        return true;
264    }
265  
266    /**
267     * @dev See {IERC20-allowance}.
268     */
269    function allowance(address owner, address spender) public view virtual override returns (uint256) {
270        return _allowances[owner][spender];
271    }
272  
273    /**
274     * @dev See {IERC20-approve}.
275     *
276     * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
277     * `transferFrom`. This is semantically equivalent to an infinite approval.
278     *
279     * Requirements:
280     *
281     * - `spender` cannot be the zero address.
282     */
283    function approve(address spender, uint256 amount) public virtual override returns (bool) {
284        address owner = _msgSender();
285        _approve(owner, spender, amount);
286        return true;
287    }
288  
289    /**
290     * @dev See {IERC20-transferFrom}.
291     *
292     * Emits an {Approval} event indicating the updated allowance. This is not
293     * required by the EIP. See the note at the beginning of {ERC20}.
294     *
295     * NOTE: Does not update the allowance if the current allowance
296     * is the maximum `uint256`.
297     *
298     * Requirements:
299     *
300     * - `from` and `to` cannot be the zero address.
301     * - `from` must have a balance of at least `amount`.
302     * - the caller must have allowance for ``from``'s tokens of at least
303     * `amount`.
304     */
305    function transferFrom(
306        address from,
307        address to,
308        uint256 amount
309    ) public virtual override returns (bool) {
310        address spender = _msgSender();
311        _spendAllowance(from, spender, amount);
312        _transfer(from, to, amount);
313        return true;
314    }
315  
316    /**
317     * @dev Atomically increases the allowance granted to `spender` by the caller.
318     *
319     * This is an alternative to {approve} that can be used as a mitigation for
320     * problems described in {IERC20-approve}.
321     *
322     * Emits an {Approval} event indicating the updated allowance.
323     *
324     * Requirements:
325     *
326     * - `spender` cannot be the zero address.
327     */
328    function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
329        address owner = _msgSender();
330        _approve(owner, spender, allowance(owner, spender) + addedValue);
331        return true;
332    }
333  
334    /**
335     * @dev Atomically decreases the allowance granted to `spender` by the caller.
336     *
337     * This is an alternative to {approve} that can be used as a mitigation for
338     * problems described in {IERC20-approve}.
339     *
340     * Emits an {Approval} event indicating the updated allowance.
341     *
342     * Requirements:
343     *
344     * - `spender` cannot be the zero address.
345     * - `spender` must have allowance for the caller of at least
346     * `subtractedValue`.
347     */
348    function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
349        address owner = _msgSender();
350        uint256 currentAllowance = allowance(owner, spender);
351        require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
352        unchecked {
353            _approve(owner, spender, currentAllowance - subtractedValue);
354        }
355  
356        return true;
357    }
358  
359    /**
360     * @dev Moves `amount` of tokens from `from` to `to`.
361     *
362     * This internal function is equivalent to {transfer}, and can be used to
363     * e.g. implement automatic token fees, slashing mechanisms, etc.
364     *
365     * Emits a {Transfer} event.
366     *
367     * Requirements:
368     *
369     * - `from` cannot be the zero address.
370     * - `to` cannot be the zero address.
371     * - `from` must have a balance of at least `amount`.
372     */
373    function _transfer(
374        address from,
375        address to,
376        uint256 amount
377    ) internal virtual {
378        require(from != address(0), "ERC20: transfer from the zero address");
379        require(to != address(0), "ERC20: transfer to the zero address");
380  
381        _beforeTokenTransfer(from, to, amount);
382  
383        uint256 fromBalance = _balances[from];
384        require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
385        unchecked {
386            _balances[from] = fromBalance - amount;
387        }
388        _balances[to] += amount;
389  
390        emit Transfer(from, to, amount);
391  
392        _afterTokenTransfer(from, to, amount);
393    }
394  
395    /** @dev Creates `amount` tokens and assigns them to `account`, increasing
396     * the total supply.
397     *
398     * Emits a {Transfer} event with `from` set to the zero address.
399     *
400     * Requirements:
401     *
402     * - `account` cannot be the zero address.
403     */
404    function _mint(address account, uint256 amount) internal virtual {
405        require(account != address(0), "ERC20: mint to the zero address");
406  
407        _beforeTokenTransfer(address(0), account, amount);
408  
409        _totalSupply += amount;
410        _balances[account] += amount;
411        emit Transfer(address(0), account, amount);
412  
413        _afterTokenTransfer(address(0), account, amount);
414    }
415  
416    /**
417     * @dev Destroys `amount` tokens from `account`, reducing the
418     * total supply.
419     *
420     * Emits a {Transfer} event with `to` set to the zero address.
421     *
422     * Requirements:
423     *
424     * - `account` cannot be the zero address.
425     * - `account` must have at least `amount` tokens.
426     */
427    function _burn(address account, uint256 amount) internal virtual {
428        require(account != address(0), "ERC20: burn from the zero address");
429  
430        _beforeTokenTransfer(account, address(0), amount);
431  
432        uint256 accountBalance = _balances[account];
433        require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
434        unchecked {
435            _balances[account] = accountBalance - amount;
436        }
437        _totalSupply -= amount;
438  
439        emit Transfer(account, address(0), amount);
440  
441        _afterTokenTransfer(account, address(0), amount);
442    }
443  
444    /**
445     * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
446     *
447     * This internal function is equivalent to `approve`, and can be used to
448     * e.g. set automatic allowances for certain subsystems, etc.
449     *
450     * Emits an {Approval} event.
451     *
452     * Requirements:
453     *
454     * - `owner` cannot be the zero address.
455     * - `spender` cannot be the zero address.
456     */
457    function _approve(
458        address owner,
459        address spender,
460        uint256 amount
461    ) internal virtual {
462        require(owner != address(0), "ERC20: approve from the zero address");
463        require(spender != address(0), "ERC20: approve to the zero address");
464  
465        _allowances[owner][spender] = amount;
466        emit Approval(owner, spender, amount);
467    }
468  
469    /**
470     * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
471     *
472     * Does not update the allowance amount in case of infinite allowance.
473     * Revert if not enough allowance is available.
474     *
475     * Might emit an {Approval} event.
476     */
477    function _spendAllowance(
478        address owner,
479        address spender,
480        uint256 amount
481    ) internal virtual {
482        uint256 currentAllowance = allowance(owner, spender);
483        if (currentAllowance != type(uint256).max) {
484            require(currentAllowance >= amount, "ERC20: insufficient allowance");
485            unchecked {
486                _approve(owner, spender, currentAllowance - amount);
487            }
488        }
489    }
490  
491    /**
492     * @dev Hook that is called before any transfer of tokens. This includes
493     * minting and burning.
494     *
495     * Calling conditions:
496     *
497     * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
498     * will be transferred to `to`.
499     * - when `from` is zero, `amount` tokens will be minted for `to`.
500     * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
501     * - `from` and `to` are never both zero.
502     *
503     * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
504     */
505    function _beforeTokenTransfer(
506        address from,
507        address to,
508        uint256 amount
509    ) internal virtual {}
510  
511    /**
512     * @dev Hook that is called after any transfer of tokens. This includes
513     * minting and burning.
514     *
515     * Calling conditions:
516     *
517     * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
518     * has been transferred to `to`.
519     * - when `from` is zero, `amount` tokens have been minted for `to`.
520     * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
521     * - `from` and `to` are never both zero.
522     *
523     * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
524     */
525    function _afterTokenTransfer(
526        address from,
527        address to,
528        uint256 amount
529    ) internal virtual {}
530 }
531  
532 // File: publicoin.sol
533  
534  
535  
536 pragma solidity 0.8.16;
537  
538  
539 contract Proof_of_transaction is ERC20 {
540    mapping(uint => uint) public _startsubsidy;
541    mapping(uint => uint) public _endsubsidy;
542    mapping(uint => uint) public _subsidy;
543  
544    constructor() ERC20("Publicoin", "Pcoin") {
545        _mint(address(this), 21000000000000000000000000);
546       
547        _startsubsidy[1] = 21000000000000000000000000;   
548        _endsubsidy[1] = 20000100000000000000000000;       
549        _subsidy[1] = 100000000000000000000;          
550  
551        _startsubsidy[2] = 20000100000000000000000000;    
552        _endsubsidy[2] = 19000050000000000000000000;      
553        _subsidy[2] = 50000000000000000000;           
554  
555        _startsubsidy[3] = 19000050000000000000000000;    
556        _endsubsidy[3] = 18000025000000000000000000;     
557        _subsidy[3] = 25000000000000000000;          
558  
559        _startsubsidy[4] = 18000025000000000000000000;     
560        _endsubsidy[4] = 17000012500000000000000000;     
561        _subsidy[4] = 12500000000000000000;          
562  
563        _startsubsidy[5] = 17000012500000000000000000;   
564        _endsubsidy[5] = 16000006250000000000000000;
565        _subsidy[5] = 6250000000000000000;          
566  
567        _startsubsidy[6] = 16000006250000000000000000;    
568        _endsubsidy[6] = 15000003125000000000000000;      
569        _subsidy[6] = 3125000000000000000;           
570  
571        _startsubsidy[7] = 15000003125000000000000000;   
572        _endsubsidy[7] = 14000001562500000000000000;     
573        _subsidy[7] = 1562500000000000000;          
574  
575        _startsubsidy[8] = 14000001562500000000000000;   
576        _endsubsidy[8] = 13000000781250000000000000;     
577        _subsidy[8] = 781250000000000000;          
578  
579        _startsubsidy[9] = 13000000781250000000000000;   
580        _endsubsidy[9] = 12000000390625000000000000;      
581        _subsidy[9] =  390625000000000000;          
582  
583        _startsubsidy[10] = 12000000390625000000000000;    
584        _endsubsidy[10] =  11000000195312500000000000;      
585        _subsidy[10] = 195312500000000000;           
586  
587        _startsubsidy[11] = 11000000195312500000000000;   
588        _endsubsidy[11] = 10000000097656250000000000;     
589        _subsidy[11] =  97656250000000000;          
590  
591        _startsubsidy[12] = 10000000097656250000000000;     
592        _endsubsidy[12] = 9000000048828125000000000;    
593        _subsidy[12] = 48828125000000000;  
594 
595        _startsubsidy[13] = 9000000048828125000000000;   
596        _endsubsidy[13] = 8000000024414062500000000;     
597        _subsidy[13] = 24414062500000000;          
598  
599        _startsubsidy[14] = 8000000024414062500000000;    
600        _endsubsidy[14] = 7000000012207031250000000;      
601        _subsidy[14] = 12207031250000000;          
602  
603        _startsubsidy[15] = 7000000012207031250000000;    
604        _endsubsidy[15] = 6000000006103515625000000;     
605        _subsidy[15] = 6103515625000000;          
606  
607        _startsubsidy[16] = 6000000006103515625000000;    
608        _endsubsidy[16] = 5000000003051757812500000;     
609        _subsidy[16] = 3051757812500000; 
610 
611        _startsubsidy[17] = 5000000003051757812500000;     
612        _endsubsidy[17] = 4000000001525878906250000;    
613        _subsidy[17] = 1525878906250000; 
614 
615        _startsubsidy[18] = 4000000001525878906250000;   
616        _endsubsidy[18] = 3000000000762939453125000;     
617        _subsidy[18] = 762939453125000;          
618  
619        _startsubsidy[19] = 3000000000762939453125000;    
620        _endsubsidy[19] = 2000000000381469726562500;      
621        _subsidy[19] = 381469726562500;          
622  
623        _startsubsidy[20] = 2000000000381469726562500;    
624        _endsubsidy[20] = 1000000000190734863281250;     
625        _subsidy[20] = 190734863281250;          
626  
627        _startsubsidy[21] = 1000000000190734863281250;    
628        _endsubsidy[21] = 95367431640624;     
629        _subsidy[21] = 95367431640625;          
630  
631        _startsubsidy[0] = 95367431640624;    
632        _endsubsidy[0] = 0;     
633        _subsidy[0] = 0;
634  
635    }
636  
637    function transfer(address recipient, uint256 amount) public override returns (bool) {
638           _transferWithsubsidy(msg.sender, recipient, amount);
639        return true;
640    }
641  
642  
643    function transferFrom(
644        address sender,
645        address recipient,
646        uint256 amount
647    ) public override returns (bool) {
648        _transferWithsubsidy(sender, recipient, amount);
649        return true;
650    }
651  
652    function _transferWithsubsidy( address sender, address recipient, uint amount ) internal {
653        _transfer(sender, recipient, amount);
654         if(msg.sender == tx.origin) {
655          _distributesubsidy();
656        }
657    }
658  
659  
660    function _distributesubsidy() internal {
661        for(uint i = 0; i <= 21; i++){
662            if (
663                _startsubsidy[i] >= super.balanceOf(address(this))  &&
664                _endsubsidy[i] <= super.balanceOf(address(this))
665            ) {
666                _transfer(address(this), msg.sender, _subsidy[i]);
667                return;
668            }
669        }
670    }
671  
672    receive() external payable {
673        revert();
674    }
675 }