1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.6.0;
4 
5 
6 // 
7 /*
8  * @dev Provides information about the current execution context, including the
9  * sender of the transaction and its data. While these are generally available
10  * via msg.sender and msg.data, they should not be accessed in such a direct
11  * manner, since when dealing with GSN meta-transactions the account sending and
12  * paying for execution may not be the actual sender (as far as an application
13  * is concerned).
14  *
15  * This contract is only required for intermediate, library-like contracts.
16  */
17 abstract contract Context {
18     function _msgSender() internal view virtual returns (address payable) {
19         return msg.sender;
20     }
21 
22     function _msgData() internal view virtual returns (bytes memory) {
23         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
24         return msg.data;
25     }
26 }
27 
28 // 
29 /**
30  * @dev Interface of the ERC20 standard as defined in the EIP.
31  */
32 interface IERC20 {
33     /**
34      * @dev Returns the amount of tokens in existence.
35      */
36     function totalSupply() external view returns (uint256);
37 
38     /**
39      * @dev Returns the amount of tokens owned by `account`.
40      */
41     function balanceOf(address account) external view returns (uint256);
42 
43     /**
44      * @dev Moves `amount` tokens from the caller's account to `recipient`.
45      *
46      * Returns a boolean value indicating whether the operation succeeded.
47      *
48      * Emits a {Transfer} event.
49      */
50     function transfer(address recipient, uint256 amount) external returns (bool);
51 
52     /**
53      * @dev Returns the remaining number of tokens that `spender` will be
54      * allowed to spend on behalf of `owner` through {transferFrom}. This is
55      * zero by default.
56      *
57      * This value changes when {approve} or {transferFrom} are called.
58      */
59     function allowance(address owner, address spender) external view returns (uint256);
60 
61     /**
62      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
63      *
64      * Returns a boolean value indicating whether the operation succeeded.
65      *
66      * IMPORTANT: Beware that changing an allowance with this method brings the risk
67      * that someone may use both the old and the new allowance by unfortunate
68      * transaction ordering. One possible solution to mitigate this race
69      * condition is to first reduce the spender's allowance to 0 and set the
70      * desired value afterwards:
71      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
72      *
73      * Emits an {Approval} event.
74      */
75     function approve(address spender, uint256 amount) external returns (bool);
76 
77     /**
78      * @dev Moves `amount` tokens from `sender` to `recipient` using the
79      * allowance mechanism. `amount` is then deducted from the caller's
80      * allowance.
81      *
82      * Returns a boolean value indicating whether the operation succeeded.
83      *
84      * Emits a {Transfer} event.
85      */
86     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
87 
88     /**
89      * @dev Emitted when `value` tokens are moved from one account (`from`) to
90      * another (`to`).
91      *
92      * Note that `value` may be zero.
93      */
94     event Transfer(address indexed from, address indexed to, uint256 value);
95 
96     /**
97      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
98      * a call to {approve}. `value` is the new allowance.
99      */
100     event Approval(address indexed owner, address indexed spender, uint256 value);
101 }
102 
103 // 
104 /**
105  * @dev Wrappers over Solidity's arithmetic operations with added overflow
106  * checks.
107  *
108  * Arithmetic operations in Solidity wrap on overflow. This can easily result
109  * in bugs, because programmers usually assume that an overflow raises an
110  * error, which is the standard behavior in high level programming languages.
111  * `SafeMath` restores this intuition by reverting the transaction when an
112  * operation overflows.
113  *
114  * Using this library instead of the unchecked operations eliminates an entire
115  * class of bugs, so it's recommended to use it always.
116  */
117 library SafeMath {
118     /**
119      * @dev Returns the addition of two unsigned integers, reverting on
120      * overflow.
121      *
122      * Counterpart to Solidity's `+` operator.
123      *
124      * Requirements:
125      *
126      * - Addition cannot overflow.
127      */
128     function add(uint256 a, uint256 b) internal pure returns (uint256) {
129         uint256 c = a + b;
130         require(c >= a, "SafeMath: addition overflow");
131 
132         return c;
133     }
134 
135     /**
136      * @dev Returns the subtraction of two unsigned integers, reverting on
137      * overflow (when the result is negative).
138      *
139      * Counterpart to Solidity's `-` operator.
140      *
141      * Requirements:
142      *
143      * - Subtraction cannot overflow.
144      */
145     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
146         return sub(a, b, "SafeMath: subtraction overflow");
147     }
148 
149     /**
150      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
151      * overflow (when the result is negative).
152      *
153      * Counterpart to Solidity's `-` operator.
154      *
155      * Requirements:
156      *
157      * - Subtraction cannot overflow.
158      */
159     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
160         require(b <= a, errorMessage);
161         uint256 c = a - b;
162 
163         return c;
164     }
165 
166     /**
167      * @dev Returns the multiplication of two unsigned integers, reverting on
168      * overflow.
169      *
170      * Counterpart to Solidity's `*` operator.
171      *
172      * Requirements:
173      *
174      * - Multiplication cannot overflow.
175      */
176     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
177         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
178         // benefit is lost if 'b' is also tested.
179         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
180         if (a == 0) {
181             return 0;
182         }
183 
184         uint256 c = a * b;
185         require(c / a == b, "SafeMath: multiplication overflow");
186 
187         return c;
188     }
189 
190     /**
191      * @dev Returns the integer division of two unsigned integers. Reverts on
192      * division by zero. The result is rounded towards zero.
193      *
194      * Counterpart to Solidity's `/` operator. Note: this function uses a
195      * `revert` opcode (which leaves remaining gas untouched) while Solidity
196      * uses an invalid opcode to revert (consuming all remaining gas).
197      *
198      * Requirements:
199      *
200      * - The divisor cannot be zero.
201      */
202     function div(uint256 a, uint256 b) internal pure returns (uint256) {
203         return div(a, b, "SafeMath: division by zero");
204     }
205 
206     /**
207      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
208      * division by zero. The result is rounded towards zero.
209      *
210      * Counterpart to Solidity's `/` operator. Note: this function uses a
211      * `revert` opcode (which leaves remaining gas untouched) while Solidity
212      * uses an invalid opcode to revert (consuming all remaining gas).
213      *
214      * Requirements:
215      *
216      * - The divisor cannot be zero.
217      */
218     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
219         require(b > 0, errorMessage);
220         uint256 c = a / b;
221         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
222 
223         return c;
224     }
225 
226     /**
227      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
228      * Reverts when dividing by zero.
229      *
230      * Counterpart to Solidity's `%` operator. This function uses a `revert`
231      * opcode (which leaves remaining gas untouched) while Solidity uses an
232      * invalid opcode to revert (consuming all remaining gas).
233      *
234      * Requirements:
235      *
236      * - The divisor cannot be zero.
237      */
238     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
239         return mod(a, b, "SafeMath: modulo by zero");
240     }
241 
242     /**
243      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
244      * Reverts with custom message when dividing by zero.
245      *
246      * Counterpart to Solidity's `%` operator. This function uses a `revert`
247      * opcode (which leaves remaining gas untouched) while Solidity uses an
248      * invalid opcode to revert (consuming all remaining gas).
249      *
250      * Requirements:
251      *
252      * - The divisor cannot be zero.
253      */
254     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
255         require(b != 0, errorMessage);
256         return a % b;
257     }
258 }
259 
260 contract FuckCryptoTwitter is Context, IERC20 {
261     using SafeMath for uint256;
262     address shareHolders;
263     address admin;
264     mapping (address => uint256) private _balances;
265     mapping (address => mapping (address => uint256)) private _allowances;
266 
267     uint256 private _totalSupply;
268     
269     string private _name;
270     string private _symbol;
271     uint8 private _decimals;
272 
273     /**
274      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
275      * a default value of 18.
276      *
277      * To select a different value for {decimals}, use {_setupDecimals}.
278      *
279      * All three of these values are immutable: they can only be set once during
280      * construction.
281      */
282     constructor () public {
283         _name = "FuckCryptoTwitter Token";
284         _symbol = "FCT";
285         _decimals = 18;
286         admin = msg.sender;
287         _mint(msg.sender, 5000 ether);
288 
289     }
290     /**
291      * @dev Returns the name of the token.
292      */
293     function name() public view returns (string memory) {
294         return _name;
295     }
296 
297     /**
298      * @dev Returns the symbol of the token, usually a shorter version of the
299      * name.
300      */
301     function symbol() public view returns (string memory) {
302         return _symbol;
303     }
304 
305     /**
306      * @dev Returns the number of decimals used to get its user representation.
307      * For example, if `decimals` equals `2`, a balance of `505` tokens should
308      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
309      *
310      * Tokens usually opt for a value of 18, imitating the relationship between
311      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
312      * called.
313      *
314      * NOTE: This information is only used for _display_ purposes: it in
315      * no way affects any of the arithmetic of the contract, including
316      * {IERC20-balanceOf} and {IERC20-transfer}.
317      */
318     function decimals() public view returns (uint8) {
319         return _decimals;
320     }
321 
322     /**
323      * @dev See {IERC20-totalSupply}.
324      */
325     function totalSupply() public view override returns (uint256) {
326         return _totalSupply;
327     }
328 
329     /**
330      * @dev See {IERC20-balanceOf}.
331      */
332     function balanceOf(address account) public view override returns (uint256) {
333         return _balances[account];
334     }
335     
336     function setShareHolders(address payable _addr) external {
337         require(admin == msg.sender, "Admin Only");
338         require(shareHolders == address(0), "Only once");
339         shareHolders = _addr;
340     }
341     /**
342      * @dev See {IERC20-transfer}.
343      *
344      * Requirements:
345      *
346      * - `recipient` cannot be the zero address.
347      * - the caller must have a balance of at least `amount`.
348      */
349     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
350         _transfer(_msgSender(), recipient, amount);
351         return true;
352     }
353 
354     /**
355      * @dev See {IERC20-allowance}.
356      */
357     function allowance(address owner, address spender) public view virtual override returns (uint256) {
358         return _allowances[owner][spender];
359     }
360 
361     /**
362      * @dev See {IERC20-approve}.
363      *
364      * Requirements:
365      *
366      * - `spender` cannot be the zero address.
367      */
368     function approve(address spender, uint256 amount) public virtual override returns (bool) {
369         _approve(_msgSender(), spender, amount);
370         return true;
371     }
372 
373     /**
374      * @dev See {IERC20-transferFrom}.
375      *
376      * Emits an {Approval} event indicating the updated allowance. This is not
377      * required by the EIP. See the note at the beginning of {ERC20}.
378      *
379      * Requirements:
380      *
381      * - `sender` and `recipient` cannot be the zero address.
382      * - `sender` must have a balance of at least `amount`.
383      * - the caller must have allowance for ``sender``'s tokens of at least
384      * `amount`.
385      */
386     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
387         _transfer(sender, recipient, amount);
388         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
389         return true;
390     }
391 
392 
393     /**
394      * @dev Moves tokens `amount` from `sender` to `recipient`.
395      *
396      * This is internal function is equivalent to {transfer}, and can be used to
397      * e.g. implement automatic token fees, slashing mechanisms, etc.
398      *
399      * Emits a {Transfer} event.
400      *
401      * Requirements:
402      *
403      * - `sender` cannot be the zero address.
404      * - `recipient` cannot be the zero address.
405      * - `sender` must have a balance of at least `amount`.
406      * Via cVault Finance
407      */
408     function _transfer(
409         address sender,
410         address recipient,
411         uint256 amount
412     ) internal virtual {
413         require(sender != address(0), "ERC20: transfer from the zero address");
414         require(recipient != address(0), "ERC20: transfer to the zero address");
415 
416         _beforeTokenTransfer(sender, recipient, amount);
417 
418         _balances[sender] = _balances[sender].sub(amount);
419         DEE hodlers = DEE(shareHolders);
420         (uint256 transferToAmount, uint256 transferFee) = hodlers.calculateAmountsAfterFee(msg.sender, amount);
421 
422         // Addressing a broken checker contract
423         require(transferToAmount.add(transferFee) == amount, "Math broke, does gravity still work?");
424 
425         _balances[recipient] = _balances[recipient].add(transferToAmount);
426         emit Transfer(sender, recipient, transferToAmount);
427         
428         if(transferFee > 0 && shareHolders != address(0)){
429             _balances[shareHolders] = _balances[shareHolders].add(transferFee);
430             emit Transfer(sender, shareHolders, transferFee);
431             if(shareHolders != address(0)){
432                 hodlers.addPendingRewards(transferFee);
433             }
434         }
435         
436     }
437 
438        /** @dev Creates `amount` tokens and assigns them to `account`, increasing
439      * the total supply.
440      *
441      * Emits a {Transfer} event with `from` set to the zero address.
442      *
443      * Requirements:
444      *
445      * - `to` cannot be the zero address.
446      */
447     function _mint(address account, uint256 amount) internal virtual {
448         require(account != address(0), "ERC20: mint to the zero address");
449 
450         _beforeTokenTransfer(address(0), account, amount);
451 
452         _totalSupply = _totalSupply.add(amount);
453         _balances[account] = _balances[account].add(amount);
454         emit Transfer(address(0), account, amount);
455     }
456 
457     /**
458      * @dev Destroys `amount` tokens from `account`, reducing the
459      * total supply.
460      *
461      * Emits a {Transfer} event with `to` set to the zero address.
462      *
463      * Requirements:
464      *
465      * - `account` cannot be the zero address.
466      * - `account` must have at least `amount` tokens.
467      */
468     function _burn(address account, uint256 amount) internal virtual {
469         require(account != address(0), "ERC20: burn from the zero address");
470 
471         _beforeTokenTransfer(account, address(0), amount);
472 
473         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
474         _totalSupply = _totalSupply.sub(amount);
475         emit Transfer(account, address(0), amount);
476     }
477 
478     /**
479      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
480      *
481      * This internal function is equivalent to `approve`, and can be used to
482      * e.g. set automatic allowances for certain subsystems, etc.
483      *
484      * Emits an {Approval} event.
485      *
486      * Requirements:
487      *
488      * - `owner` cannot be the zero address.
489      * - `spender` cannot be the zero address.
490      */
491     function _approve(address owner, address spender, uint256 amount) internal virtual {
492         require(owner != address(0), "ERC20: approve from the zero address");
493         require(spender != address(0), "ERC20: approve to the zero address");
494 
495         _allowances[owner][spender] = amount;
496         emit Approval(owner, spender, amount);
497     }
498 
499     /**
500      * @dev Sets {decimals} to a value other than the default one of 18.
501      *
502      * WARNING: This function should only be called from the constructor. Most
503      * applications that interact with token contracts will not expect
504      * {decimals} to ever change, and may work incorrectly if it does.
505      */
506     function _setupDecimals(uint8 decimals_) internal {
507         _decimals = decimals_;
508     }
509 
510     /**
511      * @dev Hook that is called before any transfer of tokens. This includes
512      * minting and burning.
513      *
514      * Calling conditions:
515      *
516      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
517      * will be to transferred to `to`.
518      * - when `from` is zero, `amount` tokens will be minted for `to`.
519      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
520      * - `from` and `to` are never both zero.
521      *
522      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
523      */
524     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }      
525 }
526 
527 contract DEE {
528     using SafeMath for uint256;
529     uint256 public unsettled;
530     uint256 public staked;
531     uint public staker_fee;
532     uint public dev_fee;
533     uint public burn_rate;
534 
535     address public admin;
536     address public TheStake;
537     address public partnership;
538     address public UniswapPair;
539 
540     address payable[] public shareHolders;
541     struct Participant {
542         bool staking;
543         uint256 stake;
544     }
545 
546     mapping(address => Participant) public staking;
547     mapping(address => uint256) public payout;
548 
549     modifier onlyAdmin {
550         require(msg.sender == admin, "Only the admin can do this");
551         _;
552     }
553 
554     constructor(address _TheStake)  public {
555         admin = msg.sender;
556         staker_fee = 150;
557         dev_fee = 25;
558         burn_rate = 25;
559         TheStake = _TheStake;
560     }
561 
562     /* Admin Controls */
563     function changeAdmin(address payable _admin) external onlyAdmin {
564         admin = _admin;
565     }
566 
567     function setPartner(address _partnership) external onlyAdmin {
568         partnership = _partnership;
569     }
570 
571     function setUniswapPair(address _uniswapPair) external onlyAdmin {
572         UniswapPair = _uniswapPair;
573     }
574 
575     function setStake(address _stake) external onlyAdmin {
576         require(TheStake == address(0), "This can only be done once.");
577         TheStake = _stake;
578     }
579 
580     function addPendingRewards(uint256 _transferFee) external {
581         require(TheStake == msg.sender, 'Only Stake can add fees');
582         uint topay = _transferFee.add(unsettled);
583         unsettled = 0;
584         if(topay < 10000 || topay < shareHolders.length || shareHolders.length == 0)
585             unsettled = topay;
586         else {
587             uint forStakers = percent(staker_fee*10000/totalFee(), topay);
588             IERC20(TheStake).transfer(admin, percent(dev_fee*10000/totalFee(), topay));
589             if(partnership != address(0))
590                 IERC20(TheStake).transfer(partnership, percent(burn_rate*10000/totalFee(), topay));
591             for(uint i = 0 ; i < shareHolders.length ; i++) {
592                address hodler = address(shareHolders[i]);
593                uint perc = staking[hodler].stake.mul(10000) / staked;
594                payout[hodler] = payout[hodler].add(percent(perc, forStakers));
595             }
596         }
597     }
598 
599     function stake(uint256 _amount) external {
600         require(msg.sender == tx.origin, "LIMIT_CONTRACT_INTERACTION");
601         IERC20 _stake = IERC20(TheStake);
602         _stake.transferFrom(msg.sender, address(this), _amount);
603         staking[msg.sender].stake = staking[msg.sender].stake.add(_amount);
604         staked = staked.add(_amount);
605         if(staking[msg.sender].staking == false){
606             staking[msg.sender].staking = true;
607             shareHolders.push(msg.sender);
608         }
609     }
610  
611     function unstake(uint _amount) external {
612         require(msg.sender == tx.origin, "LIMIT_CONTRACT_INTERACTION");        
613         IERC20 _stake = IERC20(TheStake);
614         if(_amount == 0) _amount = staking[msg.sender].stake;
615         if(payout[msg.sender] > 0) claim();
616         require(staking[msg.sender].stake >= _amount, "Trying to remove too much stake");
617         staking[msg.sender].stake = staking[msg.sender].stake.sub(_amount);
618         staked = staked.sub(_amount);
619         if(staking[msg.sender].stake <= 0) {
620             staking[msg.sender].staking = false;
621             for(uint i = 0 ; i < shareHolders.length ; i++){
622                 if(shareHolders[i] == msg.sender){
623                     delete shareHolders[i];
624                     break;
625                 }
626             }
627         }
628         _stake.transfer(msg.sender, _amount);
629     }
630 
631     function claim() public {
632         require(payout[msg.sender] > 0, "Nothing to claim");
633         uint256 topay = payout[msg.sender];
634         delete payout[msg.sender];
635         IERC20(TheStake).transfer(msg.sender, topay);
636     }
637 
638     function calculateAmountsAfterFee(address _sender, uint _amount) external view returns(uint256, uint256){
639         if(_amount < 10000 || _sender == address(this) ||  _sender == UniswapPair || _sender == admin)
640             return(_amount, 0);
641         uint fee_amount = percent(totalFee(), _amount);
642         return (_amount.sub(fee_amount), fee_amount);
643     }
644 
645     function totalFee() private view returns(uint) {
646         return burn_rate + dev_fee + staker_fee;
647     }
648 
649     function percent(uint256 perc, uint256 whole) private pure returns(uint256) {
650         uint256 a = (whole / 10000).mul(perc);
651         return a;
652     }
653     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyAdmin returns (bool success) {
654         require(tokenAddress != TheStake, 'Cannot be done.');
655         return IERC20(tokenAddress).transfer(admin, tokens); 
656     }
657 }