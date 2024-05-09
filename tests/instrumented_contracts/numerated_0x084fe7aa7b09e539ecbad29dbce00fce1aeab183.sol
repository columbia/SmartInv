1 // File: contracts/BFF.sol
2 
3 /**
4  *Submitted for verification at Etherscan.io on 2022-06-21
5 */
6 
7 // SPDX-License-Identifier: MIT
8 
9 pragma solidity ^0.8.11;
10 
11 interface IERC20 {
12     function totalSupply() external view returns (uint256);
13 
14     function balanceOf(address account) external view returns (uint256);
15 
16     function transfer(address to, uint256 amount) external returns (bool);
17 
18     function allowance(address owner, address spender)
19         external
20         view
21         returns (uint256);
22 
23     function approve(address spender, uint256 amount) external returns (bool);
24 
25     function transferFrom(
26         address from,
27         address to,
28         uint256 amount
29     ) external returns (bool);
30 
31     event Transfer(address indexed from, address indexed to, uint256 value);
32     event Approval(
33         address indexed owner,
34         address indexed spender,
35         uint256 value
36     );
37 }
38 
39 interface IERC20Metadata is IERC20 {
40     function name() external view returns (string memory);
41 
42     function symbol() external view returns (string memory);
43 
44     function decimals() external view returns (uint8);
45 }
46 
47 abstract contract Context {
48     function _msgSender() internal view virtual returns (address) {
49         return msg.sender;
50     }
51 
52     function _msgData() internal view virtual returns (bytes calldata) {
53         return msg.data;
54     }
55 }
56 
57 contract ERC20 is Context, IERC20, IERC20Metadata {
58     mapping(address => uint256) private _balances;
59 
60     mapping(address => mapping(address => uint256)) private _allowances;
61 
62     uint256 private _totalSupply;
63 
64     string private _name;
65     string private _symbol;
66 
67     constructor(string memory name_, string memory symbol_) {
68         _name = name_;
69         _symbol = symbol_;
70     }
71 
72     function name() public view virtual override returns (string memory) {
73         return _name;
74     }
75 
76     function symbol() public view virtual override returns (string memory) {
77         return _symbol;
78     }
79 
80     function decimals() public view virtual override returns (uint8) {
81         return 18;
82     }
83 
84     function totalSupply() public view virtual override returns (uint256) {
85         return _totalSupply;
86     }
87 
88     function balanceOf(address account)
89         public
90         view
91         virtual
92         override
93         returns (uint256)
94     {
95         return _balances[account];
96     }
97 
98     function transfer(address to, uint256 amount)
99         public
100         virtual
101         override
102         returns (bool)
103     {
104         address owner = _msgSender();
105         _transfer(owner, to, amount);
106         return true;
107     }
108 
109     function allowance(address owner, address spender)
110         public
111         view
112         virtual
113         override
114         returns (uint256)
115     {
116         return _allowances[owner][spender];
117     }
118 
119     function approve(address spender, uint256 amount)
120         public
121         virtual
122         override
123         returns (bool)
124     {
125         address owner = _msgSender();
126         _approve(owner, spender, amount);
127         return true;
128     }
129 
130     function transferFrom(
131         address from,
132         address to,
133         uint256 amount
134     ) public virtual override returns (bool) {
135         address spender = _msgSender();
136         _spendAllowance(from, spender, amount);
137         _transfer(from, to, amount);
138         return true;
139     }
140 
141     function increaseAllowance(address spender, uint256 addedValue)
142         public
143         virtual
144         returns (bool)
145     {
146         address owner = _msgSender();
147         _approve(owner, spender, _allowances[owner][spender] + addedValue);
148         return true;
149     }
150 
151     function decreaseAllowance(address spender, uint256 subtractedValue)
152         public
153         virtual
154         returns (bool)
155     {
156         address owner = _msgSender();
157         uint256 currentAllowance = _allowances[owner][spender];
158         require(
159             currentAllowance >= subtractedValue,
160             "ERC20: decreased allowance below zero"
161         );
162         unchecked {
163             _approve(owner, spender, currentAllowance - subtractedValue);
164         }
165 
166         return true;
167     }
168 
169     function _transfer(
170         address from,
171         address to,
172         uint256 amount
173     ) internal virtual {
174         require(from != address(0), "ERC20: transfer from the zero address");
175         require(to != address(0), "ERC20: transfer to the zero address");
176 
177         _beforeTokenTransfer(from, to, amount);
178 
179         uint256 fromBalance = _balances[from];
180         require(
181             fromBalance >= amount,
182             "ERC20: transfer amount exceeds balance"
183         );
184         unchecked {
185             _balances[from] = fromBalance - amount;
186         }
187         _balances[to] += amount;
188 
189         emit Transfer(from, to, amount);
190 
191         _afterTokenTransfer(from, to, amount);
192     }
193 
194     function _mint(address account, uint256 amount) internal virtual {
195         require(account != address(0), "ERC20: mint to the zero address");
196 
197         _beforeTokenTransfer(address(0), account, amount);
198 
199         _totalSupply += amount;
200         _balances[account] += amount;
201         emit Transfer(address(0), account, amount);
202 
203         _afterTokenTransfer(address(0), account, amount);
204     }
205 
206     function _burn(address account, uint256 amount) internal virtual {
207         require(account != address(0), "ERC20: burn from the zero address");
208 
209         _beforeTokenTransfer(account, address(0), amount);
210 
211         uint256 accountBalance = _balances[account];
212         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
213         unchecked {
214             _balances[account] = accountBalance - amount;
215         }
216         _totalSupply -= amount;
217 
218         emit Transfer(account, address(0), amount);
219 
220         _afterTokenTransfer(account, address(0), amount);
221     }
222 
223     function _approve(
224         address owner,
225         address spender,
226         uint256 amount
227     ) internal virtual {
228         require(owner != address(0), "ERC20: approve from the zero address");
229         require(spender != address(0), "ERC20: approve to the zero address");
230 
231         _allowances[owner][spender] = amount;
232         emit Approval(owner, spender, amount);
233     }
234 
235     function _spendAllowance(
236         address owner,
237         address spender,
238         uint256 amount
239     ) internal virtual {
240         uint256 currentAllowance = allowance(owner, spender);
241         if (currentAllowance != type(uint256).max) {
242             require(
243                 currentAllowance >= amount,
244                 "ERC20: insufficient allowance"
245             );
246             unchecked {
247                 _approve(owner, spender, currentAllowance - amount);
248             }
249         }
250     }
251 
252     function _beforeTokenTransfer(
253         address from,
254         address to,
255         uint256 amount
256     ) internal virtual {}
257 
258     function _afterTokenTransfer(
259         address from,
260         address to,
261         uint256 amount
262     ) internal virtual {}
263 }
264 
265 library SafeMath {
266     function tryAdd(uint256 a, uint256 b)
267         internal
268         pure
269         returns (bool, uint256)
270     {
271         unchecked {
272             uint256 c = a + b;
273             if (c < a) return (false, 0);
274             return (true, c);
275         }
276     }
277 
278     function trySub(uint256 a, uint256 b)
279         internal
280         pure
281         returns (bool, uint256)
282     {
283         unchecked {
284             if (b > a) return (false, 0);
285             return (true, a - b);
286         }
287     }
288 
289     function tryMul(uint256 a, uint256 b)
290         internal
291         pure
292         returns (bool, uint256)
293     {
294         unchecked {
295             if (a == 0) return (true, 0);
296             uint256 c = a * b;
297             if (c / a != b) return (false, 0);
298             return (true, c);
299         }
300     }
301 
302     function tryDiv(uint256 a, uint256 b)
303         internal
304         pure
305         returns (bool, uint256)
306     {
307         unchecked {
308             if (b == 0) return (false, 0);
309             return (true, a / b);
310         }
311     }
312 
313     function tryMod(uint256 a, uint256 b)
314         internal
315         pure
316         returns (bool, uint256)
317     {
318         unchecked {
319             if (b == 0) return (false, 0);
320             return (true, a % b);
321         }
322     }
323 
324     function add(uint256 a, uint256 b) internal pure returns (uint256) {
325         return a + b;
326     }
327 
328     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
329         return a - b;
330     }
331 
332     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
333         return a * b;
334     }
335 
336     function div(uint256 a, uint256 b) internal pure returns (uint256) {
337         return a / b;
338     }
339 
340     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
341         return a % b;
342     }
343 
344     function sub(
345         uint256 a,
346         uint256 b,
347         string memory errorMessage
348     ) internal pure returns (uint256) {
349         unchecked {
350             require(b <= a, errorMessage);
351             return a - b;
352         }
353     }
354 
355     function div(
356         uint256 a,
357         uint256 b,
358         string memory errorMessage
359     ) internal pure returns (uint256) {
360         unchecked {
361             require(b > 0, errorMessage);
362             return a / b;
363         }
364     }
365 
366     function mod(
367         uint256 a,
368         uint256 b,
369         string memory errorMessage
370     ) internal pure returns (uint256) {
371         unchecked {
372             require(b > 0, errorMessage);
373             return a % b;
374         }
375     }
376 }
377 
378 library Counters {
379     struct Counter {
380         uint256 _value;
381     }
382 
383     function current(Counter storage counter) internal view returns (uint256) {
384         return counter._value;
385     }
386 
387     function increment(Counter storage counter) internal {
388         unchecked {
389             counter._value += 1;
390         }
391     }
392 
393     function decrement(Counter storage counter) internal {
394         uint256 value = counter._value;
395         require(value > 0, "Counter: decrement overflow");
396         unchecked {
397             counter._value = value - 1;
398         }
399     }
400 
401     function reset(Counter storage counter) internal {
402         counter._value = 0;
403     }
404 }
405 
406 contract Ownable {
407     address private _owner;
408     address private _previousOwner;
409     event OwnershipTransferred(
410         address indexed previousOwner,
411         address indexed newOwner
412     );
413 
414     constructor() {
415         _owner = msg.sender;
416         emit OwnershipTransferred(address(0), _owner);
417     }
418 
419     function owner() public view returns (address) {
420         return _owner;
421     }
422 
423     modifier onlyOwner() {
424         require(_owner == msg.sender, "Ownable: caller is not the owner");
425         _;
426     }
427 
428     function renounceOwnership() public virtual onlyOwner {
429         emit OwnershipTransferred(_owner, address(0));
430         _owner = address(0);
431     }
432 }
433 
434 interface IUniswapV2Factory {
435     function getPair(address tokenA, address tokenB) external view returns (address pair);
436     function allPairs(uint) external view returns (address pair);
437     function allPairsLength() external view returns (uint);
438      
439     function createPair(address tokenA, address tokenB) external returns (address pair);
440  }
441 
442 interface IUniswapV2Pair {
443     event Approval(address indexed owner, address indexed spender, uint value);
444     event Transfer(address indexed from, address indexed to, uint value);
445 
446     function name() external pure returns (string memory);
447     function symbol() external pure returns (string memory);
448     function decimals() external pure returns (uint8);
449     function totalSupply() external view returns (uint);
450     function balanceOf(address owner) external view returns (uint);
451     function allowance(address owner, address spender) external view returns (uint);
452 
453     function approve(address spender, uint value) external returns (bool);
454     function transfer(address to, uint value) external returns (bool);
455     function transferFrom(address from, address to, uint value) external returns (bool);
456 
457     function DOMAIN_SEPARATOR() external view returns (bytes32);
458     function PERMIT_TYPEHASH() external pure returns (bytes32);
459     function nonces(address owner) external view returns (uint);
460 
461     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
462 
463     event Mint(address indexed sender, uint amount0, uint amount1);
464     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
465     event Swap(
466         address indexed sender,
467         uint amount0In,
468         uint amount1In,
469         uint amount0Out,
470         uint amount1Out,
471         address indexed to
472     );
473     event Sync(uint112 reserve0, uint112 reserve1);
474 
475     function MINIMUM_LIQUIDITY() external pure returns (uint);
476     function factory() external view returns (address);
477     function token0() external view returns (address);
478     function token1() external view returns (address);
479     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
480     function price0CumulativeLast() external view returns (uint);
481     function price1CumulativeLast() external view returns (uint);
482     function kLast() external view returns (uint);
483 
484     function mint(address to) external returns (uint liquidity);
485     function burn(address to) external returns (uint amount0, uint amount1);
486     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
487     function skim(address to) external;
488     function sync() external;
489 
490     function initialize(address, address) external;
491 }
492 
493 interface IUniswapV2Router02 {
494     function swapExactTokensForETHSupportingFeeOnTransferTokens(
495         uint256 amountIn,
496         uint256 amountOutMin,
497         address[] calldata path,
498         address to,
499         uint256 deadline
500     ) external;
501 
502     function swapExactETHForTokensSupportingFeeOnTransferTokens(
503         uint256 amountOutMin,
504         address[] calldata path,
505         address to,
506         uint256 deadline
507     ) external payable;
508 
509     function factory() external pure returns (address);
510 
511     function WETH() external pure returns (address);
512 
513     function addLiquidityETH(
514         address token,
515         uint256 amountTokenDesired,
516         uint256 amountTokenMin,
517         uint256 amountETHMin,
518         address to,
519         uint256 deadline
520     ) external payable returns (uint256 amountToken, uint256 amountETH, uint256 liquidity);
521     function removeLiquidityETH(
522       address token,
523       uint liquidity,
524       uint amountTokenMin,
525       uint amountETHMin,
526       address to,
527       uint deadline
528     ) external returns (uint amountToken, uint amountETH); 
529 }
530 
531 library Referrals {
532 
533     struct Data {
534         uint256 tokensNeededForRefferalNumber;
535         mapping(uint256 => address) registeredReferrersByCode;
536         mapping(address => uint256) registeredReferrersByAddress;
537         uint256 currentRefferralCode;
538     }
539 
540     event RefferalCodeGenerated(address account, uint256 code, uint256 inc1, uint256 inc2);
541 
542 
543     event UpdateTokensNeededForReferralNumber(uint256 value);
544 
545 
546     function init(Data storage data) public {
547         updateTokensNeededForReferralNumber(data, 10000 * (10**18)); //10000 tokens needed
548 
549         data.currentRefferralCode = 10000;
550     }
551 
552     function updateTokensNeededForReferralNumber(Data storage data, uint256 value) public {
553         data.tokensNeededForRefferalNumber = value;
554         emit UpdateTokensNeededForReferralNumber(value);
555     }
556 
557     function random(Data storage data, uint256 min, uint256 max) private view returns (uint256) {
558         return min + uint256(keccak256(abi.encodePacked(block.difficulty, block.timestamp, data.currentRefferralCode))) % (max - min + 1);
559     }
560 
561     function handleNewBalance(Data storage data, address account, uint256 balance) public {
562         //already registered
563         if(data.registeredReferrersByAddress[account] != 0) {
564             return;
565         }
566         //not enough tokens
567         if(balance < data.tokensNeededForRefferalNumber) {
568             return;
569         }
570         //randomly increment referral code 
571         //cannot be guessed easily
572         uint256 inc1 = random(data, 1, 7);
573         uint256 inc2 = random(data, 1, 9);
574         data.currentRefferralCode += inc1;
575 
576         //don't allow referral code to end in 0,
577         //so that ambiguous codes do not exist (ie, 420 and 4200)
578         if(data.currentRefferralCode % 10 == 0) {
579             data.currentRefferralCode += inc2;
580         }
581 
582         if(data.currentRefferralCode < 10000) {
583             uint256 inc3 = random(data, 51, 35156);
584             data.currentRefferralCode = 10000;
585             data.currentRefferralCode += inc3;
586 
587             if(data.currentRefferralCode % 10 == 0) {
588             data.currentRefferralCode += inc2;
589         }
590         }
591         
592         if(data.currentRefferralCode > 99999) {
593             uint256 inc4 = random(data, 111, 65644);
594             data.currentRefferralCode = 10000;
595             data.currentRefferralCode += inc4;
596 
597             if(data.currentRefferralCode % 10 == 0) {
598             data.currentRefferralCode += inc2;
599         }
600         }
601 
602         if(data.registeredReferrersByCode[data.currentRefferralCode] != address(0)) {
603             data.currentRefferralCode += inc2;
604         }
605         
606         data.registeredReferrersByCode[data.currentRefferralCode] = account;
607         data.registeredReferrersByAddress[account] = data.currentRefferralCode;
608 
609         emit RefferalCodeGenerated(account, data.currentRefferralCode, inc1, inc2);
610     }
611 
612     function getReferralCode(Data storage referrals, address account) public view returns (uint256) {
613         return referrals.registeredReferrersByAddress[account];
614     }
615 
616     function getReferrer(Data storage referrals, uint256 referralCode) public view returns (address) {
617         return referrals.registeredReferrersByCode[referralCode];
618     }
619 
620     function getReferralCodeFromTokenAmount(uint256 tokenAmount) private pure returns (uint256) {
621 
622         return (tokenAmount % (10**18))/(10**(13));
623 
624     }
625 
626     function getReferrerFromTokenAmount(Data storage referrals, uint256 tokenAmount) public view returns (address) {
627         uint256 referralCode = getReferralCodeFromTokenAmount(tokenAmount);
628 
629         return referrals.registeredReferrersByCode[referralCode];
630     }
631 
632     function isValidReferrer(Data storage referrals, address referrer, uint256 referrerBalance, address transferTo) public view returns (bool) {
633         if(referrer == address(0)) {
634             return false;
635         }
636 
637         uint256 tokensNeeded = referrals.tokensNeededForRefferalNumber;
638 
639         return referrerBalance >= tokensNeeded && referrer != transferTo;
640     }
641 }
642 
643 library SignedSafeMath {
644     function mul(int256 a, int256 b) internal pure returns (int256) {
645         return a * b;
646     }
647 
648     function div(int256 a, int256 b) internal pure returns (int256) {
649         return a / b;
650     }
651 
652     function sub(int256 a, int256 b) internal pure returns (int256) {
653         return a - b;
654     }
655 
656     function add(int256 a, int256 b) internal pure returns (int256) {
657         return a + b;
658     }
659 }
660 
661 library UniswapV2PriceImpactCalculator {
662     function calculateSellPriceImpact(address tokenAddress, address pairAddress, uint256 value) public view returns (uint256) {
663         value = value * 998 / 1000;
664 
665         IUniswapV2Pair pair = IUniswapV2Pair(pairAddress);
666 
667         (uint256 r0, uint256 r1,) = pair.getReserves();
668 
669         IERC20Metadata token0 = IERC20Metadata(pair.token0());
670         IERC20Metadata token1 = IERC20Metadata(pair.token1());
671 
672         if(address(token1) == tokenAddress) {
673             IERC20Metadata tokenTemp = token0;
674             token0 = token1;
675             token1 = tokenTemp;
676 
677             uint256 rTemp = r0;
678             r0 = r1;
679             r1 = rTemp;
680         }
681 
682         uint256 product = r0 * r1;
683 
684         uint256 r0After = r0 + value;
685         uint256 r1After = product / r0After;
686 
687         return (10000 - (r1After * 10000 / r1)) * 998 / 1000;
688     }
689 }
690 
691 library SafeCast {
692     function toUint224(uint256 value) internal pure returns (uint224) {
693         require(
694             value <= type(uint224).max,
695             "SafeCast: value doesn't fit in 224 bits"
696         );
697         return uint224(value);
698     }
699 
700     function toUint128(uint256 value) internal pure returns (uint128) {
701         require(
702             value <= type(uint128).max,
703             "SafeCast: value doesn't fit in 128 bits"
704         );
705         return uint128(value);
706     }
707 
708     function toUint96(uint256 value) internal pure returns (uint96) {
709         require(
710             value <= type(uint96).max,
711             "SafeCast: value doesn't fit in 96 bits"
712         );
713         return uint96(value);
714     }
715 
716     function toUint64(uint256 value) internal pure returns (uint64) {
717         require(
718             value <= type(uint64).max,
719             "SafeCast: value doesn't fit in 64 bits"
720         );
721         return uint64(value);
722     }
723 
724     function toUint32(uint256 value) internal pure returns (uint32) {
725         require(
726             value <= type(uint32).max,
727             "SafeCast: value doesn't fit in 32 bits"
728         );
729         return uint32(value);
730     }
731 
732     function toUint16(uint256 value) internal pure returns (uint16) {
733         require(
734             value <= type(uint16).max,
735             "SafeCast: value doesn't fit in 16 bits"
736         );
737         return uint16(value);
738     }
739 
740     function toUint8(uint256 value) internal pure returns (uint8) {
741         require(
742             value <= type(uint8).max,
743             "SafeCast: value doesn't fit in 8 bits"
744         );
745         return uint8(value);
746     }
747 
748     function toUint256(int256 value) internal pure returns (uint256) {
749         require(value >= 0, "SafeCast: value must be positive");
750         return uint256(value);
751     }
752 
753     function toInt128(int256 value) internal pure returns (int128) {
754         require(
755             value >= type(int128).min && value <= type(int128).max,
756             "SafeCast: value doesn't fit in 128 bits"
757         );
758         return int128(value);
759     }
760 
761     function toInt64(int256 value) internal pure returns (int64) {
762         require(
763             value >= type(int64).min && value <= type(int64).max,
764             "SafeCast: value doesn't fit in 64 bits"
765         );
766         return int64(value);
767     }
768 
769     function toInt32(int256 value) internal pure returns (int32) {
770         require(
771             value >= type(int32).min && value <= type(int32).max,
772             "SafeCast: value doesn't fit in 32 bits"
773         );
774         return int32(value);
775     }
776 
777     function toInt16(int256 value) internal pure returns (int16) {
778         require(
779             value >= type(int16).min && value <= type(int16).max,
780             "SafeCast: value doesn't fit in 16 bits"
781         );
782         return int16(value);
783     }
784 
785     function toInt8(int256 value) internal pure returns (int8) {
786         require(
787             value >= type(int8).min && value <= type(int8).max,
788             "SafeCast: value doesn't fit in 8 bits"
789         );
790         return int8(value);
791     }
792 
793     function toInt256(uint256 value) internal pure returns (int256) {
794         require(
795             value <= uint256(type(int256).max),
796             "SafeCast: value doesn't fit in an int256"
797         );
798         return int256(value);
799     }
800 }
801 
802 interface DividendPayingTokenInterface {
803     function dividendOf(address _owner) external view returns (uint256);
804 
805     function distributeDividends() external payable;
806 
807     function withdrawDividend() external;
808 
809     event DividendsDistributed(address indexed from, uint256 weiAmount);
810     event DividendWithdrawn(
811         address indexed to,
812         uint256 weiAmount,
813         address received
814     );
815 }
816 
817 interface DividendPayingTokenOptionalInterface {
818     function withdrawableDividendOf(address _owner)
819         external
820         view
821         returns (uint256);
822 
823     function withdrawnDividendOf(address _owner)
824         external
825         view
826         returns (uint256);
827 
828     function accumulativeDividendOf(address _owner)
829         external
830         view
831         returns (uint256);
832 }
833 
834 abstract contract DividendPayingToken is
835     ERC20,
836     DividendPayingTokenInterface,
837     DividendPayingTokenOptionalInterface
838 {
839     using SafeMath for uint256;
840     using SignedSafeMath for int256;
841     using SafeCast for uint256;
842     using SafeCast for int256;
843     uint256 internal constant magnitude = 2**128;
844 
845     uint256 internal magnifiedDividendPerShare;
846 
847     mapping(address => int256) internal magnifiedDividendCorrections;
848     mapping(address => uint256) internal withdrawnDividends;
849 
850     uint256 public totalDividendsDistributed;
851 
852     constructor(string memory _name, string memory _symbol)
853         ERC20(_name, _symbol)
854     {}
855 
856     receive() external payable {
857         distributeDividends();
858     }
859 
860     function distributeDividends() public payable override {
861         require(totalSupply() > 0);
862 
863         if (msg.value > 0) {
864             magnifiedDividendPerShare = magnifiedDividendPerShare.add(
865                 (msg.value).mul(magnitude) / totalSupply()
866             );
867             emit DividendsDistributed(msg.sender, msg.value);
868 
869             totalDividendsDistributed = totalDividendsDistributed.add(
870                 msg.value
871             );
872         }
873     }
874 
875     function withdrawDividend() public virtual override {
876         _withdrawDividendOfUser(payable(msg.sender), payable(msg.sender));
877     }
878 
879     function _withdrawDividendOfUser(address payable user, address payable to)
880         internal
881         returns (uint256)
882     {
883         uint256 _withdrawableDividend = withdrawableDividendOf(user);
884         if (_withdrawableDividend > 0) {
885             withdrawnDividends[user] = withdrawnDividends[user].add(
886                 _withdrawableDividend
887             );
888             emit DividendWithdrawn(user, _withdrawableDividend, to);
889             (bool success, ) = to.call{value: _withdrawableDividend}("");
890 
891             if (!success) {
892                 withdrawnDividends[user] = withdrawnDividends[user].sub(
893                     _withdrawableDividend
894                 );
895                 return 0;
896             }
897 
898             return _withdrawableDividend;
899         }
900 
901         return 0;
902     }
903 
904     function dividendOf(address _owner) public view override returns (uint256) {
905         return withdrawableDividendOf(_owner);
906     }
907 
908     function withdrawableDividendOf(address _owner)
909         public
910         view
911         override
912         returns (uint256)
913     {
914         return accumulativeDividendOf(_owner).sub(withdrawnDividends[_owner]);
915     }
916 
917     function withdrawnDividendOf(address _owner)
918         public
919         view
920         override
921         returns (uint256)
922     {
923         return withdrawnDividends[_owner];
924     }
925 
926     function accumulativeDividendOf(address _owner)
927         public
928         view
929         override
930         returns (uint256)
931     {
932         return
933             magnifiedDividendPerShare
934                 .mul(balanceOf(_owner))
935                 .toInt256()
936                 .add(magnifiedDividendCorrections[_owner])
937                 .toUint256() / magnitude;
938     }
939 
940     function _mint(address account, uint256 value) internal override {
941         super._mint(account, value);
942 
943         magnifiedDividendCorrections[account] = magnifiedDividendCorrections[
944             account
945         ].sub((magnifiedDividendPerShare.mul(value)).toInt256());
946     }
947 
948     function _burn(address account, uint256 value) internal override {
949         super._burn(account, value);
950         magnifiedDividendCorrections[account] = magnifiedDividendCorrections[
951             account
952         ].add((magnifiedDividendPerShare.mul(value)).toInt256());
953     }
954 
955     function _setBalance(address account, uint256 newBalance) internal {
956         uint256 currentBalance = balanceOf(account);
957 
958         if (newBalance > currentBalance) {
959             uint256 mintAmount = newBalance.sub(currentBalance);
960             _mint(account, mintAmount);
961         } else if (newBalance < currentBalance) {
962             uint256 burnAmount = currentBalance.sub(newBalance);
963             _burn(account, burnAmount);
964         }
965     }
966 
967     function getAccount(address _account)
968         public
969         view
970         returns (uint256 _withdrawableDividends, uint256 _withdrawnDividends)
971     {
972         _withdrawableDividends = withdrawableDividendOf(_account);
973         _withdrawnDividends = withdrawnDividends[_account];
974     }
975 }
976 
977 contract BFFDividendTracker is DividendPayingToken, Ownable {
978     using SafeMath for uint256;
979     using Counters for Counters.Counter;
980 
981     Counters.Counter private tokenHoldersCount;
982     mapping(address => bool) private tokenHoldersMap;
983 
984     mapping(address => bool) public excludedFromDividends;
985 
986     uint256 public immutable minimumTokenBalanceForDividends;
987 
988     event ExcludeFromDividends(address indexed account);
989 
990     constructor()
991         DividendPayingToken(
992             "BFF_Dividend_Tracker",
993             "BFF_Dividend_Tracker"
994         )
995     {
996         minimumTokenBalanceForDividends = 10000 * 10**18;
997     }
998 
999     function decimals() public view virtual override returns (uint8) {
1000         return 18;
1001     }
1002 
1003     function _approve(
1004         address,
1005         address,
1006         uint256
1007     ) internal pure override {
1008         require(false, "BFF_Dividend_Tracker: No approvals allowed");
1009     }
1010 
1011     function _transfer(
1012         address,
1013         address,
1014         uint256
1015     ) internal pure override {
1016         require(false, "BFF_Dividend_Tracker: No transfers allowed");
1017     }
1018 
1019     function withdrawDividend() public pure override {
1020         require(
1021             false,
1022             "BFF_Dividend_Tracker: withdrawDividend disabled. Use the 'claim' function on the main BFF contract."
1023         );
1024     }
1025 
1026     function excludeFromDividends(address account) external onlyOwner {
1027         excludedFromDividends[account] = true;
1028 
1029         _setBalance(account, 0);
1030 
1031         if (tokenHoldersMap[account] == true) {
1032             tokenHoldersMap[account] = false;
1033             tokenHoldersCount.decrement();
1034         }
1035 
1036         emit ExcludeFromDividends(account);
1037     }
1038 
1039     function includeFromDividends(address account, uint256 balance)
1040         external
1041         onlyOwner
1042     {
1043         excludedFromDividends[account] = false;
1044 
1045         if (balance >= minimumTokenBalanceForDividends) {
1046             _setBalance(account, balance);
1047 
1048             if (tokenHoldersMap[account] == false) {
1049                 tokenHoldersMap[account] = true;
1050                 tokenHoldersCount.increment();
1051             }
1052         }
1053 
1054         emit ExcludeFromDividends(account);
1055     }
1056 
1057     function isExcludeFromDividends(address account)
1058         external
1059         view
1060         onlyOwner
1061         returns (bool)
1062     {
1063         return excludedFromDividends[account];
1064     }
1065 
1066     function getNumberOfTokenHolders() external view returns (uint256) {
1067         return tokenHoldersCount.current();
1068     }
1069 
1070     function setBalance(address payable account, uint256 newBalance)
1071         external
1072         onlyOwner
1073     {
1074         if (excludedFromDividends[account]) {
1075             return;
1076         }
1077 
1078         if (newBalance >= minimumTokenBalanceForDividends) {
1079             _setBalance(account, newBalance);
1080 
1081             if (tokenHoldersMap[account] == false) {
1082                 tokenHoldersMap[account] = true;
1083                 tokenHoldersCount.increment();
1084             }
1085         } else {
1086             _setBalance(account, 0);
1087 
1088             if (tokenHoldersMap[account] == true) {
1089                 tokenHoldersMap[account] = false;
1090                 tokenHoldersCount.decrement();
1091             }
1092         }
1093     }
1094 
1095     function processAccount(address account, address toAccount)
1096         public
1097         onlyOwner
1098         returns (uint256)
1099     {
1100         uint256 amount = _withdrawDividendOfUser(
1101             payable(account),
1102             payable(toAccount)
1103         );
1104         return amount;
1105     }
1106 }
1107 
1108 contract BFF is ERC20, Ownable {
1109     using SafeMath for uint256;
1110     using Counters for Counters.Counter;
1111     using Referrals for Referrals.Data;
1112 
1113     string private constant _name = "By Frens For Frens";
1114     string private constant _symbol = "BFF";
1115     uint8 private constant _decimals = 18;
1116     uint256 private constant _tTotal = 1e12 * 10**18;
1117 
1118     IUniswapV2Router02 private uniswapV2Router =
1119         IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
1120     bool private tradingOpen = false;
1121     bool private allowClaims = false;
1122     uint256 private launchBlock = 0;
1123     address private uniswapV2Pair;
1124 
1125     IERC20 private PreSaleTokenAddress;
1126     uint256 private minimumPreSaleTokens;
1127     uint256 private preSaleTimestamp;
1128     uint256 private minutesForPreSale;
1129     uint256 private publicSaleTimestamp;
1130     bool private preSaleActive = false;
1131 
1132     mapping(address => bool) private automatedMarketMakerPairs;
1133     mapping(address => bool) public isExcludeFromFee;
1134     mapping(address => bool) public isBlacklist;
1135     mapping(address => bool) public isAllowedToClaim;
1136     mapping(address => bool) public isBot;
1137     mapping(address => bool) public isExcludeFromMaxWalletAmount;
1138 
1139     uint256 public maxWalletAmount;
1140 
1141     uint256 public baseBuyTax = 10;
1142     uint256 public baseSellTax = 5;
1143     uint256 public referralBuyTax = 5;
1144     uint256 public referrerBonus = 25; // 2.5% division in tenths to support
1145     uint256 public referredBonus = 25; // 2.5% division in tenths to support
1146 
1147     uint256 private autoLP = 20;
1148     uint256 private devFee = 10;
1149     uint256 private marketingFee = 70;
1150 
1151     uint256 public minContractTokensToSwap = 2e9 * 10**18;
1152 
1153     struct PriceImpactRangeTax {
1154         uint256 from;
1155         uint256 to;
1156         uint256 tax;
1157     }
1158 
1159     mapping(address => uint256) public initialBuyTimestamp;
1160     mapping(uint256 => PriceImpactRangeTax) public priceImpactRangeTaxes;
1161     uint8 public maxIndexImpactRange;
1162 
1163     address private devWalletAddress;
1164     address private marketingWalletAddress;
1165 
1166     BFFDividendTracker public dividendTracker;
1167     uint256 minimumTokenBalanceForDividends = 1000 * 10**18;
1168     mapping(address => uint256) public lastTransfer;
1169 
1170     uint256 public pendingTokensForReward;
1171     uint256 public minRewardTokensToSwap = 10000 * 10**18;
1172 
1173     uint256 public pendingEthReward;
1174 
1175     struct ClaimedEth {
1176         uint256 ethAmount;
1177         uint256 tokenAmount;
1178         uint256 timestamp;
1179     }
1180 
1181     Counters.Counter private claimedHistoryIds;
1182     Referrals.Data private _storage;
1183 
1184     mapping(uint256 => ClaimedEth) private claimedEthMap;
1185     mapping(address => uint256[]) private userClaimedIds;
1186 
1187     event BuyFees(address from, address to, uint256 amountTokens);
1188     event SellFees(address from, address to, uint256 amountTokens);
1189     event AddLiquidity(uint256 amountTokens, uint256 amountEth);
1190     event SwapTokensForEth(uint256 sentTokens, uint256 receivedEth);
1191     event SwapEthForTokens(uint256 sentEth, uint256 receivedTokens);
1192     event DistributeFees(uint256 devEth, uint256 remarketingEth);
1193     event AddRewardPool(uint256 _ethAmount);
1194 
1195     event SendDividends(uint256 amount);
1196 
1197     event DividendClaimed(
1198         uint256 ethAmount,
1199         uint256 tokenAmount,
1200         address account
1201     );
1202 
1203     constructor(
1204         address _devWalletAddress,
1205         address _marketingWalletAddress
1206     ) ERC20(_name, _symbol) {
1207         devWalletAddress = _devWalletAddress;
1208         marketingWalletAddress = _marketingWalletAddress;
1209 
1210         maxWalletAmount = (_tTotal * 25) / 10000; // 0.25% maxWalletAmount (initial limit)
1211 
1212         dividendTracker = new BFFDividendTracker();
1213         dividendTracker.excludeFromDividends(address(dividendTracker));
1214         dividendTracker.excludeFromDividends(address(this));
1215         dividendTracker.excludeFromDividends(owner());
1216         dividendTracker.excludeFromDividends(address(uniswapV2Router));
1217 
1218         isExcludeFromFee[owner()] = true;
1219         isExcludeFromFee[address(this)] = true;
1220         isExcludeFromFee[address(dividendTracker)] = true;
1221         isExcludeFromFee[devWalletAddress] = true;
1222         isExcludeFromFee[marketingWalletAddress] = true;
1223         isExcludeFromMaxWalletAmount[owner()] = true;
1224         isExcludeFromMaxWalletAmount[address(this)] = true;
1225         isExcludeFromMaxWalletAmount[address(uniswapV2Router)] = true;
1226         isExcludeFromMaxWalletAmount[devWalletAddress] = true;
1227         isExcludeFromMaxWalletAmount[marketingWalletAddress] = true;
1228         priceImpactRangeTaxes[1].from = 0;
1229         priceImpactRangeTaxes[1].to = 99;
1230         priceImpactRangeTaxes[1].tax = 5;
1231         priceImpactRangeTaxes[2].from = 100;
1232         priceImpactRangeTaxes[2].to = 149;
1233         priceImpactRangeTaxes[2].tax = 10;
1234         priceImpactRangeTaxes[3].from = 150;
1235         priceImpactRangeTaxes[3].to = 199;
1236         priceImpactRangeTaxes[3].tax = 15;
1237         priceImpactRangeTaxes[4].from = 200;
1238         priceImpactRangeTaxes[4].to = 249;
1239         priceImpactRangeTaxes[4].tax = 20;
1240         priceImpactRangeTaxes[5].from = 250;
1241         priceImpactRangeTaxes[5].to = 5000;
1242         priceImpactRangeTaxes[5].tax = 25;
1243 
1244         maxIndexImpactRange = 5;
1245 
1246         _mint(owner(), _tTotal);
1247 
1248         _storage.init();
1249 
1250     }
1251 
1252     // withdraw ETH if stuck before launch
1253     function withdrawStuckETH() external onlyOwner {
1254         require(!tradingOpen, "Can only withdraw if trading hasn't started");
1255         bool success;
1256         (success, ) = address(msg.sender).call{ value: address(this).balance }(
1257             ""
1258         );
1259     }
1260 
1261     function enablePreSale (uint256 _minutesForPreSale, address _preSaleTokenAddress, uint256 _minimumPreSaleTokens) external onlyOwner {
1262         require(!tradingOpen, "BFF: Can only enable PreSale before Trading has been opened.");
1263         minutesForPreSale = _minutesForPreSale;
1264         PreSaleTokenAddress = IERC20(_preSaleTokenAddress);
1265         minimumPreSaleTokens = _minimumPreSaleTokens * 10**18;
1266         preSaleActive = true;
1267     }
1268 
1269     function openTrading()
1270         external
1271         onlyOwner
1272     {
1273         require(!tradingOpen, "BFF: Trading is already open");
1274         
1275         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(
1276                 address(this),
1277                 uniswapV2Router.WETH()
1278             );
1279         isExcludeFromMaxWalletAmount[address(uniswapV2Pair)] = true;
1280 
1281         automatedMarketMakerPairs[uniswapV2Pair] = true;
1282         dividendTracker.excludeFromDividends(uniswapV2Pair);
1283 
1284         addLiquidity(balanceOf(address(this)), address(this).balance);
1285         IERC20(uniswapV2Pair).approve(
1286             address(uniswapV2Router),
1287             type(uint256).max
1288         );
1289 
1290         tradingOpen = true;
1291         if (preSaleActive) {
1292             uint256 _launchTime;
1293             _launchTime = block.timestamp;
1294 
1295             preSaleTimestamp = _launchTime;
1296             publicSaleTimestamp = _launchTime.add(
1297                 minutesForPreSale.mul(1 minutes)
1298             );
1299         }
1300         launchBlock = block.number;
1301     }
1302 
1303     function alowClaims(bool _alowClaims) external onlyOwner{
1304         allowClaims = _alowClaims;
1305     }
1306 
1307     function updateReferrals(uint256 _referralBuyTax, uint256 _referrerBonus, uint256 _referredBonus, uint256 tokensNeeded) public onlyOwner {
1308         referralBuyTax = _referralBuyTax;
1309         referrerBonus = _referrerBonus;
1310         referredBonus = _referredBonus;
1311         _storage.updateTokensNeededForReferralNumber(tokensNeeded);
1312     }
1313     
1314     function getReferralCode(address account) public view returns (uint256 referralCode) {
1315         referralCode = _storage.getReferralCode(account);
1316     }
1317 
1318     function getReferralCodeAddress(uint256 referralCode) public view returns (address referrerAddress) {
1319         referrerAddress = _storage.getReferrer(referralCode);
1320     }
1321 
1322     function getReferralAddressByTokenAmount(uint256 _amount) public view returns (address referrerAddress) {
1323         referrerAddress = _storage.getReferrerFromTokenAmount(_amount);
1324     }
1325 
1326     function isReferralValid(address referrer, address _to) public view returns (bool) {
1327         if(referrer == address(0)) {
1328             return false;
1329         }
1330         uint256 neededTokens = _storage.tokensNeededForRefferalNumber;
1331 
1332         return balanceOf(referrer) >= neededTokens && referrer != _to;
1333     }
1334 
1335     function handleNewBalanceForReferrals(address account) private {
1336         if(isExcludeFromFee[account] || isBlacklist[account]) {
1337             return;
1338         }
1339 
1340         if(account == address(uniswapV2Pair)) {
1341             return;
1342         }
1343 
1344         _storage.handleNewBalance(account, balanceOf(account));
1345     }
1346 
1347     function manualSwap() external onlyOwner {
1348         uint256 totalTokens = balanceOf(address(this)).sub(
1349             pendingTokensForReward
1350         );
1351 
1352         swapTokensForEth(totalTokens);
1353     }
1354 
1355     function manualSend() external onlyOwner {
1356         uint256 totalEth = address(this).balance.sub(pendingEthReward);
1357 
1358         uint256 devFeesToSend = totalEth.mul(devFee).div(
1359             uint256(100).sub(autoLP)
1360         );
1361         uint256 marketingFeesToSend = totalEth.mul(marketingFee).div(
1362             uint256(100).sub(autoLP)
1363         );
1364         uint256 remainingEthForFees = totalEth.sub(devFeesToSend).sub(
1365             marketingFeesToSend);
1366         devFeesToSend = devFeesToSend.add(remainingEthForFees);
1367 
1368         sendEthToWallets(devFeesToSend, marketingFeesToSend);
1369     }
1370 
1371     function getPriceImpactTax(address _ad, uint256 _amount) public view returns (uint256) {
1372         uint256 tax = baseSellTax;
1373 
1374         uint256 priceImpact = UniswapV2PriceImpactCalculator.calculateSellPriceImpact(address(_ad), uniswapV2Pair, _amount);
1375 
1376         for (uint8 x =1; x <= maxIndexImpactRange; x++) {
1377             if (
1378                 (priceImpact >= priceImpactRangeTaxes[x].from &&
1379                     priceImpact <= priceImpactRangeTaxes[x].to)
1380             ) {
1381                 tax = priceImpactRangeTaxes[x].tax;
1382                 return tax;
1383             }
1384         }
1385         return tax;
1386     }
1387 
1388     function getTotalDividendsDistributed() external view returns (uint256) {
1389         return dividendTracker.totalDividendsDistributed();
1390     }
1391 
1392     function withdrawableDividendOf(address _account)
1393         public
1394         view
1395         returns (uint256)
1396     {
1397         return dividendTracker.withdrawableDividendOf(_account);
1398     }
1399 
1400     function dividendTokenBalanceOf(address _account)
1401         public
1402         view
1403         returns (uint256)
1404     {
1405         return dividendTracker.balanceOf(_account);
1406     }
1407 
1408     function claim() external {
1409         _claim(payable(msg.sender), false);
1410     }
1411 
1412     function reinvest() external {
1413         _claim(payable(msg.sender), true);
1414     }
1415 
1416     function _claim(address payable _account, bool _reinvest) private {
1417         uint256 withdrawableAmount = dividendTracker.withdrawableDividendOf(
1418             _account
1419         );
1420         require(
1421             withdrawableAmount > 0,
1422             "BFF: Claimer has no withdrawable dividends"
1423         );
1424         uint256 ethAmount;
1425         uint256 tokenAmount;
1426 
1427         if (!_reinvest) {
1428             require(
1429                 allowClaims || isAllowedToClaim[_account],
1430                 "BFF: Claimer not allowed to claim dividends, can only re-invest."
1431             );
1432             ethAmount = dividendTracker.processAccount(_account, _account);
1433         } else if (_reinvest) {
1434             ethAmount = dividendTracker.processAccount(_account, address(this));
1435             if (ethAmount > 0) {
1436                 tokenAmount = swapEthForTokens(ethAmount, _account);
1437             }
1438         }
1439         if (ethAmount > 0) {
1440             claimedHistoryIds.increment();
1441             uint256 hId = claimedHistoryIds.current();
1442             claimedEthMap[hId].ethAmount = ethAmount;
1443             claimedEthMap[hId].tokenAmount = tokenAmount;
1444             claimedEthMap[hId].timestamp = block.timestamp;
1445 
1446             userClaimedIds[_account].push(hId);
1447 
1448             emit DividendClaimed(ethAmount, tokenAmount, _account);
1449         }
1450     }
1451 
1452     function getNumberOfDividendTokenHolders() external view returns (uint256) {
1453         return dividendTracker.getNumberOfTokenHolders();
1454     }
1455 
1456     function getAccount(address _account)
1457         public
1458         view
1459         returns (
1460             uint256 withdrawableDividends,
1461             uint256 withdrawnDividends,
1462             uint256 balance
1463         )
1464     {
1465         (withdrawableDividends, withdrawnDividends) = dividendTracker
1466             .getAccount(_account);
1467         return (withdrawableDividends, withdrawnDividends, balanceOf(_account));
1468     }
1469 
1470     function decimals() public view virtual override returns (uint8) {
1471         return _decimals;
1472     }
1473 
1474     function _transfer(
1475         address _from,
1476         address _to,
1477         uint256 _amount
1478     ) internal virtual override {
1479         require(!isBot[_from] && !isBot[_to]);
1480         require(!isBlacklist[_from] && !isBlacklist[_to]);
1481 
1482         uint256 transferAmount = _amount;
1483         if (
1484             tradingOpen &&
1485             (automatedMarketMakerPairs[_from] ||
1486                 automatedMarketMakerPairs[_to]) &&
1487             !isExcludeFromFee[_from] &&
1488             !isExcludeFromFee[_to]
1489         ) {
1490             if (preSaleActive &&
1491                 preSaleTimestamp <= block.timestamp &&
1492                 publicSaleTimestamp > block.timestamp
1493             ) {
1494                 require(
1495                     PreSaleTokenAddress.balanceOf(_to) >= minimumPreSaleTokens,
1496                     "PreSale: Not enough PreSale token balance."
1497                 );
1498             }
1499 
1500             address _referrer; 
1501             _referrer = _storage.getReferrerFromTokenAmount(_amount);
1502 
1503             if(!_storage.isValidReferrer(_referrer, balanceOf(_referrer), _to)) {
1504                 _referrer = address(0);
1505             }
1506             
1507             transferAmount = takeFees(_from, _to, _amount, _referrer);
1508             
1509         }
1510         if (initialBuyTimestamp[_to] == 0) {
1511             initialBuyTimestamp[_to] = block.timestamp;
1512         }
1513         if (!automatedMarketMakerPairs[_to] && !isExcludeFromMaxWalletAmount[_to]) {
1514             require(balanceOf(_to) + transferAmount <= maxWalletAmount,
1515                 "BFF: Wallet balance limit reached"
1516             );
1517         }
1518 
1519         super._transfer(_from, _to, transferAmount);
1520 
1521         handleNewBalanceForReferrals(_to);
1522 
1523         if (!dividendTracker.isExcludeFromDividends(_from)) {
1524             try
1525                 dividendTracker.setBalance(payable(_from), balanceOf(_from))
1526             {} catch {}
1527         }
1528         if (!dividendTracker.isExcludeFromDividends(_to)) {
1529             try
1530                 dividendTracker.setBalance(payable(_to), balanceOf(_to))
1531             {} catch {}
1532         }
1533     }
1534 
1535     function _setAutomatedMarketMakerPair(address _pair, bool _value) private {
1536         require(
1537             automatedMarketMakerPairs[_pair] != _value,
1538             "BFF: Automated market maker pair is already set to that value"
1539         );
1540         automatedMarketMakerPairs[_pair] = _value;
1541 
1542         if (_value) {
1543             dividendTracker.excludeFromDividends(_pair);
1544         }
1545     }
1546 
1547     function setBlacklist(address _address, bool _isBlaklist)
1548         external onlyOwner {
1549         isBlacklist[_address] = _isBlaklist;
1550     }
1551 
1552     function isAlowedToClaim(address _address, bool _isAlowedToClaim)
1553         external onlyOwner {
1554         isAllowedToClaim[_address] = _isAlowedToClaim;
1555     }
1556 
1557     function setExcludeFromFee(address _address, bool _isExludeFromFee)
1558         external onlyOwner {
1559         isExcludeFromFee[_address] = _isExludeFromFee;
1560     }
1561 
1562     function setExcludeFromMaxWalletAmount(address _address, bool _isExludeFromMaxWalletAmount)
1563         external onlyOwner {
1564         isExcludeFromMaxWalletAmount[_address] = _isExludeFromMaxWalletAmount;
1565     }
1566 
1567     function setExludeFromDividends(address _address, bool _isExludeFromDividends)
1568         external onlyOwner {
1569         if (_isExludeFromDividends) {
1570             dividendTracker.excludeFromDividends(_address);
1571         } else {
1572             dividendTracker.includeFromDividends(_address, balanceOf(_address));
1573         }
1574     }
1575 
1576     function setMultipleExludeFromDividends(address[] calldata _isMultipleExludeFromDividends) public onlyOwner {
1577         for (uint256 i = 0; i < _isMultipleExludeFromDividends.length; i++) {
1578                 dividendTracker.excludeFromDividends(_isMultipleExludeFromDividends[i]);
1579             }
1580     }
1581 
1582     function setMaxWallet(uint256 newMaxWallet) external onlyOwner {
1583         require(newMaxWallet >= (totalSupply() * 1 / 1000)/1e18, "Cannot set maxWallet lower than 0.1%");
1584         maxWalletAmount = newMaxWallet * (10**18);
1585     }
1586     
1587 
1588     function setTaxes(
1589         uint256 _baseBuyTax,
1590         uint256 _baseSellTax,
1591         uint256 _autoLP,
1592         uint256 _devFee,
1593         uint256 _marketingFee
1594     ) external onlyOwner {
1595         require(_baseBuyTax <= 10 && baseSellTax <= 10);
1596 
1597         baseBuyTax = _baseBuyTax;
1598         baseSellTax = _baseSellTax;
1599         autoLP = _autoLP;
1600         devFee = _devFee;
1601         marketingFee = _marketingFee;
1602     }
1603 
1604     function setMinContractTokensToSwap(uint256 _numToken) public onlyOwner {
1605         minContractTokensToSwap = _numToken;
1606     }
1607 
1608     function setMinRewardTokensToSwap(uint256 _numToken) public onlyOwner {
1609         minRewardTokensToSwap = _numToken;
1610     }
1611 
1612     function setPriceImpactRangeTax(
1613         uint8 _index,
1614         uint256 _from,
1615         uint256 _to,
1616         uint256 _tax
1617     ) external onlyOwner {
1618         priceImpactRangeTaxes[_index].from = _from;
1619         priceImpactRangeTaxes[_index].to = _to;
1620         priceImpactRangeTaxes[_index].tax = _tax;
1621     }
1622 
1623     function setMaxIndexImpactRange(uint8 _maxIndex) external onlyOwner {
1624         maxIndexImpactRange = _maxIndex;
1625     }
1626 
1627     function setBots(address[] calldata _bots) public onlyOwner {
1628         for (uint256 i = 0; i < _bots.length; i++) {
1629             if (
1630                 _bots[i] != uniswapV2Pair &&
1631                 _bots[i] != address(uniswapV2Router)
1632             ) {
1633                 isBot[_bots[i]] = true;
1634             }
1635         }
1636     }
1637 
1638     function setWalletAddress(address _devWallet, address _marketingWallet)
1639         external
1640         onlyOwner
1641     {
1642         devWalletAddress = _devWallet;
1643         marketingWalletAddress = _marketingWallet;
1644     }
1645 
1646     function takeFees(
1647         address _from,
1648         address _to,
1649         uint256 _amount,
1650         address _referrer
1651     ) private returns (uint256) {
1652         uint256 fees;
1653         uint256 remainingAmount;
1654         require(
1655             automatedMarketMakerPairs[_from] || automatedMarketMakerPairs[_to],
1656             "BFF: No market makers found"
1657         );
1658 
1659         if (automatedMarketMakerPairs[_from]) {
1660             uint256 totalBuyTax;
1661             uint256 referrerFees;
1662             uint256 referredFees;
1663             if (block.number == launchBlock && !preSaleActive) {
1664                 totalBuyTax = 90;
1665             } else if (block.number == launchBlock + 1 && !preSaleActive) {
1666                 totalBuyTax = 50;
1667             } else if (_referrer != address(0)) {
1668                 totalBuyTax = referralBuyTax.add(referrerBonus.add(referredBonus).div(10));
1669             } else {
1670                 totalBuyTax = baseBuyTax;
1671             }
1672 
1673             fees = _amount.mul(totalBuyTax).div(100);
1674             
1675             if(_referrer != address(0)) {
1676                 fees = _amount.mul(referralBuyTax).div(100);
1677 
1678                 referrerFees = _amount.mul(referrerBonus).div(1000);
1679                 referredFees = _amount.mul(referredBonus).div(1000);
1680 
1681                 uint256 totalReferralFees = referrerFees.add(referredFees);
1682 
1683                 remainingAmount = _amount.sub(fees).sub(totalReferralFees).add(referredFees);
1684 
1685                 super._transfer(_from, address(this), fees);
1686 
1687                 super._transfer(_from, _referrer, referrerFees);
1688 
1689                 emit BuyFees(_from, address(this), fees);
1690 
1691                 emit BuyFees(_from, _referrer, referrerFees);
1692 
1693             } else {
1694 
1695             remainingAmount = _amount.sub(fees);
1696 
1697             super._transfer(_from, address(this), fees);
1698 
1699             emit BuyFees(_from, address(this), fees);
1700             }
1701         } else {
1702             uint256 totalSellTax;
1703             if (block.number == launchBlock) {
1704                 totalSellTax = 90;
1705             } else if (block.number == launchBlock + 1) {
1706                 totalSellTax = 50;
1707             } else {
1708                 uint256 increaseSellFee = getPriceImpactTax(address(this), _amount);
1709 
1710                 totalSellTax = baseSellTax + increaseSellFee;
1711 
1712                 if(totalSellTax >= 30) {
1713                     totalSellTax = 30;
1714                 }
1715             }
1716 
1717             fees = _amount.mul(totalSellTax).div(100);
1718             uint256 rewardTokens = _amount
1719                 .mul(totalSellTax.sub(baseSellTax))
1720                 .div(100);
1721             pendingTokensForReward = pendingTokensForReward.add(rewardTokens);
1722 
1723             remainingAmount = _amount.sub(fees);
1724 
1725             super._transfer(_from, address(this), fees);
1726             uint256 tokensToSwap = balanceOf(address(this)).sub(
1727                 pendingTokensForReward);
1728 
1729             if (tokensToSwap > minContractTokensToSwap) {
1730                 distributeTokensEth(tokensToSwap);
1731             }
1732             if (pendingTokensForReward > minRewardTokensToSwap) {
1733                 swapAndSendDividends(pendingTokensForReward);
1734             }
1735 
1736             emit SellFees(_from, address(this), fees);
1737         }
1738 
1739         return remainingAmount;
1740     }
1741 
1742     function distributeTokensEth(uint256 _tokenAmount) private {
1743         uint256 tokensForLiquidity = _tokenAmount.mul(autoLP).div(100);
1744 
1745         uint256 halfLiquidity = tokensForLiquidity.div(2);
1746         uint256 tokensForSwap = _tokenAmount.sub(halfLiquidity);
1747 
1748         uint256 totalEth = swapTokensForEth(tokensForSwap);
1749 
1750         uint256 ethForAddLP = totalEth.mul(autoLP).div(100);
1751         uint256 devFeesToSend = totalEth.mul(devFee).div(100);
1752         uint256 marketingFeesToSend = totalEth.mul(marketingFee).div(100);
1753         uint256 remainingEthForFees = totalEth
1754             .sub(ethForAddLP)
1755             .sub(devFeesToSend)
1756             .sub(marketingFeesToSend);
1757         devFeesToSend = devFeesToSend.add(remainingEthForFees);
1758 
1759         sendEthToWallets(devFeesToSend, marketingFeesToSend);
1760 
1761         if (halfLiquidity > 0 && ethForAddLP > 0) {
1762             addLiquidity(halfLiquidity, ethForAddLP);
1763         }
1764     }
1765 
1766     function sendEthToWallets(uint256 _devFees, uint256 _marketingFees)
1767         private
1768     {
1769         if (_devFees > 0) {
1770             payable(devWalletAddress).transfer(_devFees);
1771         }
1772         if (_marketingFees > 0) {
1773             payable(marketingWalletAddress).transfer(_marketingFees);
1774         }
1775         emit DistributeFees(_devFees, _marketingFees);
1776     }
1777 
1778     function swapTokensForEth(uint256 _tokenAmount) private returns (uint256) {
1779         uint256 initialEthBalance = address(this).balance;
1780         address[] memory path = new address[](2);
1781         path[0] = address(this);
1782         path[1] = uniswapV2Router.WETH();
1783         _approve(address(this), address(uniswapV2Router), _tokenAmount);
1784         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1785             _tokenAmount,
1786             0,
1787             path,
1788             address(this),
1789             block.timestamp
1790         );
1791 
1792         uint256 receivedEth = address(this).balance.sub(initialEthBalance);
1793 
1794         emit SwapTokensForEth(_tokenAmount, receivedEth);
1795         return receivedEth;
1796     }
1797 
1798     function swapEthForTokens(uint256 _ethAmount, address _to)
1799         private
1800         returns (uint256)
1801     {
1802         uint256 initialTokenBalance = balanceOf(address(this));
1803         address[] memory path = new address[](2);
1804         path[0] = uniswapV2Router.WETH();
1805         path[1] = address(this);
1806 
1807         uniswapV2Router.swapExactETHForTokensSupportingFeeOnTransferTokens{
1808             value: _ethAmount
1809         }(0, path, _to, block.timestamp);
1810 
1811         uint256 receivedTokens = balanceOf(address(this)).sub(
1812             initialTokenBalance
1813         );
1814 
1815         emit SwapEthForTokens(_ethAmount, receivedTokens);
1816         return receivedTokens;
1817     }
1818 
1819     function addLiquidity(uint256 _tokenAmount, uint256 _ethAmount) private {
1820         _approve(address(this), address(uniswapV2Router), _tokenAmount);
1821         uniswapV2Router.addLiquidityETH{value: _ethAmount}(
1822             address(this),
1823             _tokenAmount,
1824             0,
1825             0,
1826             owner(),
1827             block.timestamp
1828         );
1829         emit AddLiquidity(_tokenAmount, _ethAmount);
1830     }
1831 
1832     function swapAndSendDividends(uint256 _tokenAmount) private {
1833         uint256 dividends = swapTokensForEth(_tokenAmount);
1834 
1835         pendingTokensForReward = pendingTokensForReward.sub(_tokenAmount);
1836         uint256 totalEthToSend = dividends.add(pendingEthReward);
1837 
1838         (bool success, ) = address(dividendTracker).call{value: totalEthToSend}(
1839             ""
1840         );
1841 
1842         if (success) {
1843             emit SendDividends(dividends);
1844         } else {
1845             pendingEthReward = pendingEthReward.add(dividends);
1846         }
1847     }
1848 
1849     function canHolderClaim(address _address) public view returns (uint256) {
1850         uint256 holderCanClaim;
1851         if(isAllowedToClaim[_address] || allowClaims) {
1852             holderCanClaim = 1000000;
1853         } else {
1854             holderCanClaim = 0;
1855         }
1856 
1857         return holderCanClaim;
1858     }
1859 
1860     function availableContractTokenBalance() public view returns (uint256) {
1861         return balanceOf(address(this)).sub(pendingTokensForReward);
1862     }
1863 
1864     function getHistory(
1865         address _account,
1866         uint256 _limit,
1867         uint256 _pageNumber
1868     ) external view returns (ClaimedEth[] memory) {
1869         require(_limit > 0 && _pageNumber > 0, "BFF: Invalid arguments");
1870         uint256 userClaimedCount = userClaimedIds[_account].length;
1871         uint256 end = _pageNumber * _limit;
1872         uint256 start = end - _limit;
1873         require(start < userClaimedCount, "BFF: Out of range");
1874         uint256 limit = _limit;
1875         if (end > userClaimedCount) {
1876             end = userClaimedCount;
1877             limit = userClaimedCount % _limit;
1878         }
1879 
1880         ClaimedEth[] memory myClaimedEth = new ClaimedEth[](limit);
1881         uint256 currentIndex = 0;
1882         for (uint256 i = start; i < end; i++) {
1883             uint256 hId = userClaimedIds[_account][i];
1884             myClaimedEth[currentIndex] = claimedEthMap[hId];
1885             currentIndex += 1;
1886         }
1887         return myClaimedEth;
1888     }
1889 
1890     function getHistoryCount(address _account) external view returns (uint256) {
1891         return userClaimedIds[_account].length;
1892     }
1893 
1894     receive() external payable {}
1895     
1896 }