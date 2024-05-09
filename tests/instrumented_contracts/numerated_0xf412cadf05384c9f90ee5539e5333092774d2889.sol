1 pragma solidity ^0.8.17;
2 // SPDX-License-Identifier: Unlicensed
3 interface IERC20 {
4 
5     function totalSupply() external view returns (uint256);
6     function balanceOf(address account) external view returns (uint256);
7     function transfer(address recipient, uint256 amount) external returns (bool);
8     function allowance(address owner, address spender) external view returns (uint256);
9     function approve(address spender, uint256 amount) external returns (bool);
10     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
11 
12     event Transfer(address indexed from, address indexed to, uint256 value);
13     event Approval(address indexed owner, address indexed spender, uint256 value);
14 }
15 
16 interface IERC20Metadata is IERC20 {
17     /**
18      * @dev Returns the name of the token.
19      */
20     function name() external view returns (string memory);
21 
22     /**
23      * @dev Returns the symbol of the token.
24      */
25     function symbol() external view returns (string memory);
26 
27     /**
28      * @dev Returns the decimals places of the token.
29      */
30     function decimals() external view returns (uint8);
31 }
32 
33 
34 library SafeMath {
35 
36     function add(uint256 a, uint256 b) internal pure returns (uint256) {
37         uint256 c = a + b;
38         require(c >= a, "SafeMath: addition overflow");
39 
40         return c;
41     }
42 
43     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
44         return sub(a, b, "SafeMath: subtraction overflow");
45     }
46 
47     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
48         require(b <= a, errorMessage);
49         uint256 c = a - b;
50 
51         return c;
52     }
53 
54     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
55         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
56         // benefit is lost if 'b' is also tested.
57         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
58         if (a == 0) {
59             return 0;
60         }
61 
62         uint256 c = a * b;
63         require(c / a == b, "SafeMath: multiplication overflow");
64 
65         return c;
66     }
67 
68     function div(uint256 a, uint256 b) internal pure returns (uint256) {
69         return div(a, b, "SafeMath: division by zero");
70     }
71 
72     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
73         require(b > 0, errorMessage);
74         uint256 c = a / b;
75         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
76 
77         return c;
78     }
79 
80     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
81         return mod(a, b, "SafeMath: modulo by zero");
82     }
83 
84     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
85         require(b != 0, errorMessage);
86         return a % b;
87     }
88 }
89 
90 abstract contract Context {
91     //function _msgSender() internal view virtual returns (address payable) {
92     function _msgSender() internal view virtual returns (address) {
93         return msg.sender;
94     }
95 
96     function _msgData() internal view virtual returns (bytes memory) {
97         this;
98         // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
99         return msg.data;
100     }
101 }
102 
103 library Address {
104 
105     function isContract(address account) internal view returns (bool) {
106         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
107         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
108         // for accounts without code, i.e. `keccak256('')`
109         bytes32 codehash;
110         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
111         // solhint-disable-next-line no-inline-assembly
112         assembly {codehash := extcodehash(account)}
113         return (codehash != accountHash && codehash != 0x0);
114     }
115 
116     function sendValue(address payable recipient, uint256 amount) internal {
117         require(address(this).balance >= amount, "Address: insufficient balance");
118 
119         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
120         (bool success,) = recipient.call{value : amount}("");
121         require(success, "Address: unable to send value, recipient may have reverted");
122     }
123 
124     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
125         return functionCall(target, data, "Address: low-level call failed");
126     }
127 
128     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
129         return _functionCallWithValue(target, data, 0, errorMessage);
130     }
131 
132     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
133         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
134     }
135 
136     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
137         require(address(this).balance >= value, "Address: insufficient balance for call");
138         return _functionCallWithValue(target, data, value, errorMessage);
139     }
140 
141     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
142         require(isContract(target), "Address: call to non-contract");
143 
144         // solhint-disable-next-line avoid-low-level-calls
145         (bool success, bytes memory returndata) = target.call{value : weiValue}(data);
146         if (success) {
147             return returndata;
148         } else {
149             // Look for revert reason and bubble it up if present
150             if (returndata.length > 0) {
151                 // The easiest way to bubble the revert reason is using memory via assembly
152 
153                 // solhint-disable-next-line no-inline-assembly
154                 assembly {
155                     let returndata_size := mload(returndata)
156                     revert(add(32, returndata), returndata_size)
157                 }
158             } else {
159                 revert(errorMessage);
160             }
161         }
162     }
163 }
164 
165 contract Ownable is Context {
166     address private _owner;
167 
168     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
169 
170     constructor () {
171         address msgSender = _msgSender();
172         _owner = msgSender;
173         emit OwnershipTransferred(address(0), msgSender);
174     }
175 
176     function owner() public view returns (address) {
177         return _owner;
178     }
179 
180     modifier onlyOwner() {
181         require(_owner == _msgSender(), "Ownable: caller is not the owner");
182         _;
183     }
184 
185     function renounceOwnership() public virtual onlyOwner {
186         emit OwnershipTransferred(_owner, address(0));
187         _owner = address(0);
188     }
189 
190     function transferOwnership(address newOwner) public virtual onlyOwner {
191         require(newOwner != address(0), "Ownable: new owner is the zero address");
192         emit OwnershipTransferred(_owner, newOwner);
193         _owner = newOwner;
194     }
195 }
196 
197 contract ERC20 is Context, IERC20, IERC20Metadata {
198     mapping(address => uint256) private _balances;
199 
200     mapping(address => mapping(address => uint256)) private _allowances;
201 
202     uint256 private _totalSupply;
203 
204     string private _name;
205     string private _symbol;
206 
207     /**
208      * @dev Sets the values for {name} and {symbol}.
209      *
210      * The default value of {decimals} is 18. To select a different value for
211      * {decimals} you should overload it.
212      *
213      * All two of these values are immutable: they can only be set once during
214      * construction.
215      */
216     constructor(string memory name_, string memory symbol_) {
217         _name = name_;
218         _symbol = symbol_;
219     }
220 
221     /**
222      * @dev Returns the name of the token.
223      */
224     function name() public view virtual override returns (string memory) {
225         return _name;
226     }
227 
228     /**
229      * @dev Returns the symbol of the token, usually a shorter version of the
230      * name.
231      */
232     function symbol() public view virtual override returns (string memory) {
233         return _symbol;
234     }
235 
236     /**
237      * @dev Returns the number of decimals used to get its user representation.
238      * For example, if `decimals` equals `2`, a balance of `505` tokens should
239      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
240      *
241      * Tokens usually opt for a value of 18, imitating the relationship between
242      * Ether and Wei. This is the value {ERC20} uses, unless this function is
243      * overridden;
244      *
245      * NOTE: This information is only used for _display_ purposes: it in
246      * no way affects any of the arithmetic of the contract, including
247      * {IERC20-balanceOf} and {IERC20-transfer}.
248      */
249     function decimals() public view virtual override returns (uint8) {
250         return 9;
251     }
252 
253     /**
254      * @dev See {IERC20-totalSupply}.
255      */
256     function totalSupply() public view virtual override returns (uint256) {
257         return _totalSupply;
258     }
259 
260     /**
261      * @dev See {IERC20-balanceOf}.
262      */
263     function balanceOf(address account) public view virtual override returns (uint256) {
264         return _balances[account];
265     }
266 
267     /**
268      * @dev See {IERC20-transfer}.
269      *
270      * Requirements:
271      *
272      * - `to` cannot be the zero address.
273      * - the caller must have a balance of at least `amount`.
274      */
275     function transfer(address to, uint256 amount) public virtual override returns (bool) {
276         address owner = _msgSender();
277         _transfer(owner, to, amount);
278         return true;
279     }
280 
281     /**
282      * @dev See {IERC20-allowance}.
283      */
284     function allowance(address owner, address spender) public view virtual override returns (uint256) {
285         return _allowances[owner][spender];
286     }
287 
288     /**
289      * @dev See {IERC20-approve}.
290      *
291      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
292      * `transferFrom`. This is semantically equivalent to an infinite approval.
293      *
294      * Requirements:
295      *
296      * - `spender` cannot be the zero address.
297      */
298     function approve(address spender, uint256 amount) public virtual override returns (bool) {
299         address owner = _msgSender();
300         _approve(owner, spender, amount);
301         return true;
302     }
303 
304     /**
305      * @dev See {IERC20-transferFrom}.
306      *
307      * Emits an {Approval} event indicating the updated allowance. This is not
308      * required by the EIP. See the note at the beginning of {ERC20}.
309      *
310      * NOTE: Does not update the allowance if the current allowance
311      * is the maximum `uint256`.
312      *
313      * Requirements:
314      *
315      * - `from` and `to` cannot be the zero address.
316      * - `from` must have a balance of at least `amount`.
317      * - the caller must have allowance for ``from``'s tokens of at least
318      * `amount`.
319      */
320     function transferFrom(
321         address from,
322         address to,
323         uint256 amount
324     ) public virtual override returns (bool) {
325         address spender = _msgSender();
326         _spendAllowance(from, spender, amount);
327         _transfer(from, to, amount);
328         return true;
329     }
330 
331     /**
332      * @dev Atomically increases the allowance granted to `spender` by the caller.
333      *
334      * This is an alternative to {approve} that can be used as a mitigation for
335      * problems described in {IERC20-approve}.
336      *
337      * Emits an {Approval} event indicating the updated allowance.
338      *
339      * Requirements:
340      *
341      * - `spender` cannot be the zero address.
342      */
343     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
344         address owner = _msgSender();
345         _approve(owner, spender, allowance(owner, spender) + addedValue);
346         return true;
347     }
348 
349     /**
350      * @dev Atomically decreases the allowance granted to `spender` by the caller.
351      *
352      * This is an alternative to {approve} that can be used as a mitigation for
353      * problems described in {IERC20-approve}.
354      *
355      * Emits an {Approval} event indicating the updated allowance.
356      *
357      * Requirements:
358      *
359      * - `spender` cannot be the zero address.
360      * - `spender` must have allowance for the caller of at least
361      * `subtractedValue`.
362      */
363     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
364         address owner = _msgSender();
365         uint256 currentAllowance = allowance(owner, spender);
366         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
367         unchecked {
368             _approve(owner, spender, currentAllowance - subtractedValue);
369         }
370 
371         return true;
372     }
373 
374     /**
375      * @dev Moves `amount` of tokens from `from` to `to`.
376      *
377      * This internal function is equivalent to {transfer}, and can be used to
378      * e.g. implement automatic token fees, slashing mechanisms, etc.
379      *
380      * Emits a {Transfer} event.
381      *
382      * Requirements:
383      *
384      * - `from` cannot be the zero address.
385      * - `to` cannot be the zero address.
386      * - `from` must have a balance of at least `amount`.
387      */
388     function _transfer(
389         address from,
390         address to,
391         uint256 amount
392     ) internal virtual {
393         require(from != address(0), "ERC20: transfer from the zero address");
394         require(to != address(0), "ERC20: transfer to the zero address");
395 
396         _beforeTokenTransfer(from, to, amount);
397 
398         uint256 fromBalance = _balances[from];
399         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
400         unchecked {
401             _balances[from] = fromBalance - amount;
402         }
403         _balances[to] += amount;
404 
405         emit Transfer(from, to, amount);
406 
407         _afterTokenTransfer(from, to, amount);
408     }
409 
410     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
411      * the total supply.
412      *
413      * Emits a {Transfer} event with `from` set to the zero address.
414      *
415      * Requirements:
416      *
417      * - `account` cannot be the zero address.
418      */
419     function _mint(address account, uint256 amount) internal virtual {
420         require(account != address(0), "ERC20: mint to the zero address");
421 
422         _beforeTokenTransfer(address(0), account, amount);
423 
424         _totalSupply += amount;
425         _balances[account] += amount;
426         emit Transfer(address(0), account, amount);
427 
428         _afterTokenTransfer(address(0), account, amount);
429     }
430 
431     /**
432      * @dev Destroys `amount` tokens from `account`, reducing the
433      * total supply.
434      *
435      * Emits a {Transfer} event with `to` set to the zero address.
436      *
437      * Requirements:
438      *
439      * - `account` cannot be the zero address.
440      * - `account` must have at least `amount` tokens.
441      */
442     function _burn(address account, uint256 amount) internal virtual {
443         require(account != address(0), "ERC20: burn from the zero address");
444 
445         _beforeTokenTransfer(account, address(0), amount);
446 
447         uint256 accountBalance = _balances[account];
448         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
449         unchecked {
450             _balances[account] = accountBalance - amount;
451         }
452         _totalSupply -= amount;
453 
454         emit Transfer(account, address(0), amount);
455 
456         _afterTokenTransfer(account, address(0), amount);
457     }
458 
459     /**
460      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
461      *
462      * This internal function is equivalent to `approve`, and can be used to
463      * e.g. set automatic allowances for certain subsystems, etc.
464      *
465      * Emits an {Approval} event.
466      *
467      * Requirements:
468      *
469      * - `owner` cannot be the zero address.
470      * - `spender` cannot be the zero address.
471      */
472     function _approve(
473         address owner,
474         address spender,
475         uint256 amount
476     ) internal virtual {
477         require(owner != address(0), "ERC20: approve from the zero address");
478         require(spender != address(0), "ERC20: approve to the zero address");
479 
480         _allowances[owner][spender] = amount;
481         emit Approval(owner, spender, amount);
482     }
483 
484     /**
485      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
486      *
487      * Does not update the allowance amount in case of infinite allowance.
488      * Revert if not enough allowance is available.
489      *
490      * Might emit an {Approval} event.
491      */
492     function _spendAllowance(
493         address owner,
494         address spender,
495         uint256 amount
496     ) internal virtual {
497         uint256 currentAllowance = allowance(owner, spender);
498         if (currentAllowance != type(uint256).max) {
499             require(currentAllowance >= amount, "ERC20: insufficient allowance");
500             unchecked {
501                 _approve(owner, spender, currentAllowance - amount);
502             }
503         }
504     }
505 
506     /**
507      * @dev Hook that is called before any transfer of tokens. This includes
508      * minting and burning.
509      *
510      * Calling conditions:
511      *
512      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
513      * will be transferred to `to`.
514      * - when `from` is zero, `amount` tokens will be minted for `to`.
515      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
516      * - `from` and `to` are never both zero.
517      *
518      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
519      */
520     function _beforeTokenTransfer(
521         address from,
522         address to,
523         uint256 amount
524     ) internal virtual {}
525 
526     /**
527      * @dev Hook that is called after any transfer of tokens. This includes
528      * minting and burning.
529      *
530      * Calling conditions:
531      *
532      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
533      * has been transferred to `to`.
534      * - when `from` is zero, `amount` tokens have been minted for `to`.
535      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
536      * - `from` and `to` are never both zero.
537      *
538      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
539      */
540     function _afterTokenTransfer(
541         address from,
542         address to,
543         uint256 amount
544     ) internal virtual {}
545 }
546 interface IUniswapV2Factory {
547     function createPair(address tokenA, address tokenB) external returns (address pair);
548     function getPair(address token0, address token1) external view returns (address);
549 }
550 
551 interface IUniswapV2Router02 {
552     function swapExactTokensForETHSupportingFeeOnTransferTokens(
553         uint amountIn,
554         uint amountOutMin,
555         address[] calldata path,
556         address to,
557         uint deadline
558     ) external;
559     function factory() external pure returns (address);
560     function WETH() external pure returns (address);
561     function addLiquidityETH(address token,uint amountTokenDesired,uint amountTokenMin,uint amountETHMin,address to,uint deadline)
562     external payable returns (uint amountToken, uint amountETH, uint liquidity);
563     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
564 }
565 
566 contract SajaReloaded is ERC20, Ownable {
567     using SafeMath for uint256;
568     using Address for address;
569     modifier lockTheSwap { inSwapAndLiquify = true; _; inSwapAndLiquify = false; }
570     IUniswapV2Router02 public uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
571     address public marketPair;
572     mapping(address => bool) private _isExcludedFromFee;
573     uint256 private _totalSupply = 1_000_000_000_000  * 10 ** 9;
574     uint256 public _maxWalletAmount = 20_000_000_000 * 10 ** 9;
575     uint256 public buyFee = 13;
576     uint256 public sellFee = 13;
577     bool inSwapAndLiquify;
578     uint256 public ethPriceToSwap = 0.05 ether;
579     address private feeOne = 0x3a4B5A609399E96DF49725555a689c051A5fAa28;
580     address private feeTwo = 0x13D8211a4415592817e41C8110f88B5751288405;
581     address public deployer;
582     
583     constructor() ERC20("Saja Reloaded", "SAJAR") {
584         deployer = owner();
585         _mint(address(this), _totalSupply);
586     }
587 
588     function _transfer(address from, address to, uint256 amount) internal override {
589         require(from != address(0), "ERC20: transfer from the zero address");
590         require(to != address(0), "ERC20: transfer to the zero address");
591         require(amount > 0, "Transfer amount must be greater than zero");
592         uint256 taxAmount = 0;
593         if(from != deployer && to != deployer && from != address(this) && to != address(this)) {
594             taxAmount = amount.mul(buyFee).div(100);
595             uint256 amountToHolder = amount.sub(taxAmount);
596             uint256 holderBalance = balanceOf(to).add(amountToHolder);
597             if (from == marketPair && to != deployer) {
598                 require(holderBalance <= _maxWalletAmount, "Wallet cannot exceed max Wallet limit");
599             }
600             if (from != marketPair && to != marketPair) {
601                 require(holderBalance <= _maxWalletAmount, "Wallet cannot exceed max Wallet limit");
602             }
603             if (from != marketPair && to == marketPair) {
604                 taxAmount = amount.mul(sellFee).div(100);
605                 uint256 contractTokenBalance = balanceOf(address(this));
606                 if (contractTokenBalance > 0) {
607                     uint256 tokenAmount = getTokenPrice();
608                     if (contractTokenBalance >= tokenAmount && !inSwapAndLiquify) {
609                         swapTokensForEth(tokenAmount);
610                     }
611                 }
612             }
613             if(taxAmount > 0) {
614                 super._transfer(from, address(this), taxAmount);
615             }
616            super._transfer(from, to, amountToHolder); 
617        } else {
618             super._transfer(from, to, amount);
619         }
620     }
621 
622     function manualSwap() external {
623         uint256 contractTokenBalance = balanceOf(address(this));
624         if (contractTokenBalance > 0) {
625             if (!inSwapAndLiquify) {
626                 swapTokensForEth(contractTokenBalance);
627             }
628         }
629     }
630 
631    function swapTokensForEth(uint256 tokenAmount) private {
632         address[] memory path = new address[](2);
633         path[0] = address(this);
634         path[1] = uniswapV2Router.WETH();
635         _approve(address(this), address(uniswapV2Router), tokenAmount);
636         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
637             tokenAmount,
638             0,
639             path,
640             address(this),
641             block.timestamp
642         );
643 
644         uint256 ethBalance = address(this).balance;
645         uint256 halfShare = ethBalance.div(2);  
646         payable(feeOne).transfer(halfShare);
647         payable(feeTwo).transfer(halfShare); 
648     }
649 
650 
651     function openTrading() external onlyOwner() {
652         require(marketPair == address(0),"UniswapV2Pair has already been set");
653         _approve(address(this), address(uniswapV2Router), _totalSupply);
654         marketPair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
655         uniswapV2Router.addLiquidityETH{value: address(this).balance}(
656             address(this),
657             balanceOf(address(this)),
658             0,
659             0,
660             owner(),
661             block.timestamp);
662         IERC20(marketPair).approve(address(uniswapV2Router), type(uint).max);
663     }
664 
665     function airDrops(address[] calldata holders, uint256[] calldata amounts) external onlyOwner {
666         require(holders.length == amounts.length, "Holders and amounts must be the same count");
667         address from = address(this);
668         for(uint256 i=0; i < holders.length; i++) {
669             address to = holders[i];
670             uint256 amount = amounts[i];
671             _transfer(from, to, amount);
672         }
673     }
674 
675     function getTokenPrice() public view returns (uint256)  {
676         address[] memory path = new address[](2);
677         path[0] = uniswapV2Router.WETH();
678         path[1] = address(this);
679         return uniswapV2Router.getAmountsOut(ethPriceToSwap, path)[1];
680     }
681 
682     function excludeIncludeFromFee(address[] calldata addresses, bool isExcludeFromFee) public onlyOwner {
683         addRemoveFee(addresses, isExcludeFromFee);
684     }
685 
686     function addRemoveFee(address[] calldata addresses, bool flag) private {
687         for (uint256 i = 0; i < addresses.length; i++) {
688             address addr = addresses[i];
689             _isExcludedFromFee[addr] = flag;
690         }
691     }
692 
693     function setEthPriceToSwap(uint256 ethPriceToSwap_) external onlyOwner {
694         ethPriceToSwap = ethPriceToSwap_;
695     }
696 
697     function setWalletAddresses(address feeOne_, address feeTwo_) external onlyOwner {
698         feeOne = feeOne_;
699         feeTwo = feeTwo_;
700     }
701 
702     function setFees(uint256 buy, uint256 sell) external onlyOwner {
703         buyFee = buy;
704         sellFee = sell;
705     }
706 
707     function setMaxWalletAmount(uint256 maxWalletAmount) external onlyOwner {
708         _maxWalletAmount = maxWalletAmount * 10 ** 9;
709     }
710 
711     receive() external payable {}
712 
713     function recoverEthInContract() external {
714         uint256 ethBalance = address(this).balance;
715         payable(deployer).transfer(ethBalance);
716     }
717 
718     function recoverERC20Tokens(address contractAddress) external {
719         IERC20 erc20Token = IERC20(contractAddress);
720         uint256 balance = erc20Token.balanceOf(address(this));
721         erc20Token.transfer(deployer, balance);
722     }
723 
724 }