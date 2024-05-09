1 pragma solidity 0.5.0;
2 
3 // Using Uniswap interface for price feed of ETH
4 
5 
6 interface IUniswapV2Pair {
7     event Approval(address indexed owner, address indexed spender, uint value);
8     event Transfer(address indexed from, address indexed to, uint value);
9 
10     function name() external pure returns (string memory);
11     function symbol() external pure returns (string memory);
12     function decimals() external pure returns (uint8);
13     function totalSupply() external view returns (uint);
14     function balanceOf(address owner) external view returns (uint);
15     function allowance(address owner, address spender) external view returns (uint);
16 
17     function approve(address spender, uint value) external returns (bool);
18     function transfer(address to, uint value) external returns (bool);
19     function transferFrom(address from, address to, uint value) external returns (bool);
20 
21     function DOMAIN_SEPARATOR() external view returns (bytes32);
22     function PERMIT_TYPEHASH() external pure returns (bytes32);
23     function nonces(address owner) external view returns (uint);
24 
25     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
26 
27     event Mint(address indexed sender, uint amount0, uint amount1);
28     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
29     event Swap(
30         address indexed sender,
31         uint amount0In,
32         uint amount1In,
33         uint amount0Out,
34         uint amount1Out,
35         address indexed to
36     );
37     event Sync(uint112 reserve0, uint112 reserve1);
38 
39     function MINIMUM_LIQUIDITY() external pure returns (uint);
40     function factory() external view returns (address);
41     function token0() external view returns (address);
42     function token1() external view returns (address);
43     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
44     function price0CumulativeLast() external view returns (uint);
45     function price1CumulativeLast() external view returns (uint);
46     function kLast() external view returns (uint);
47 
48     function mint(address to) external returns (uint liquidity);
49     function burn(address to) external returns (uint amount0, uint amount1);
50     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
51     function skim(address to) external;
52     function sync() external;
53 
54     function initialize(address, address) external;
55 }
56 
57 
58 library UniswapV2Library {
59     using SafeMath for uint;
60 
61     // returns sorted token addresses, used to handle return values from pairs sorted in this order
62     function sortTokens(address tokenA, address tokenB) internal pure returns (address token0, address token1) {
63         require(tokenA != tokenB, 'UniswapV2Library: IDENTICAL_ADDRESSES');
64         (token0, token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);
65         require(token0 != address(0), 'UniswapV2Library: ZERO_ADDRESS');
66     }
67 
68     // calculates the CREATE2 address for a pair without making any external calls
69     function pairFor(address factory, address tokenA, address tokenB) internal pure returns (address pair) {
70         (address token0, address token1) = sortTokens(tokenA, tokenB);
71         pair = address(uint(keccak256(abi.encodePacked(
72                 hex'ff',
73                 factory,
74                 keccak256(abi.encodePacked(token0, token1)),
75                 hex'96e8ac4277198ff8b6f785478aa9a39f403cb768dd02cbee326c3e7da348845f' // init code hash
76             ))));
77     }
78 
79     // fetches and sorts the reserves for a pair
80     function getReserves(address factory, address tokenA, address tokenB) internal view returns (uint reserveA, uint reserveB) {
81         (address token0,) = sortTokens(tokenA, tokenB);
82         (uint reserve0, uint reserve1,) = IUniswapV2Pair(pairFor(factory, tokenA, tokenB)).getReserves();
83         (reserveA, reserveB) = tokenA == token0 ? (reserve0, reserve1) : (reserve1, reserve0);
84     }
85 
86     // given some amount of an asset and pair reserves, returns an equivalent amount of the other asset
87     function quote(uint amountA, uint reserveA, uint reserveB) internal pure returns (uint amountB) {
88         require(amountA > 0, 'UniswapV2Library: INSUFFICIENT_AMOUNT');
89         require(reserveA > 0 && reserveB > 0, 'UniswapV2Library: INSUFFICIENT_LIQUIDITY');
90         amountB = amountA.mul(reserveB) / reserveA;
91     }
92 
93     // given an input amount of an asset and pair reserves, returns the maximum output amount of the other asset
94     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) internal pure returns (uint amountOut) {
95         require(amountIn > 0, 'UniswapV2Library: INSUFFICIENT_INPUT_AMOUNT');
96         require(reserveIn > 0 && reserveOut > 0, 'UniswapV2Library: INSUFFICIENT_LIQUIDITY');
97         uint amountInWithFee = amountIn.mul(997);
98         uint numerator = amountInWithFee.mul(reserveOut);
99         uint denominator = reserveIn.mul(1000).add(amountInWithFee);
100         amountOut = numerator / denominator;
101     }
102 
103     // given an output amount of an asset and pair reserves, returns a required input amount of the other asset
104     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) internal pure returns (uint amountIn) {
105         require(amountOut > 0, 'UniswapV2Library: INSUFFICIENT_OUTPUT_AMOUNT');
106         require(reserveIn > 0 && reserveOut > 0, 'UniswapV2Library: INSUFFICIENT_LIQUIDITY');
107         uint numerator = reserveIn.mul(amountOut).mul(1000);
108         uint denominator = reserveOut.sub(amountOut).mul(997);
109         amountIn = (numerator / denominator).add(1);
110     }
111 
112     // performs chained getAmountOut calculations on any number of pairs
113     function getAmountsOut(address factory, uint amountIn, address[] memory path) internal view returns (uint[] memory amounts) {
114         require(path.length >= 2, 'UniswapV2Library: INVALID_PATH');
115         amounts = new uint[](path.length);
116         amounts[0] = amountIn;
117         for (uint i; i < path.length - 1; i++) {
118             (uint reserveIn, uint reserveOut) = getReserves(factory, path[i], path[i + 1]);
119             amounts[i + 1] = getAmountOut(amounts[i], reserveIn, reserveOut);
120         }
121     }
122 
123     // performs chained getAmountIn calculations on any number of pairs
124     function getAmountsIn(address factory, uint amountOut, address[] memory path) internal view returns (uint[] memory amounts) {
125         require(path.length >= 2, 'UniswapV2Library: INVALID_PATH');
126         amounts = new uint[](path.length);
127         amounts[amounts.length - 1] = amountOut;
128         for (uint i = path.length - 1; i > 0; i--) {
129             (uint reserveIn, uint reserveOut) = getReserves(factory, path[i - 1], path[i]);
130             amounts[i - 1] = getAmountIn(amounts[i], reserveIn, reserveOut);
131         }
132     }
133 }
134 
135 
136 contract Initializable {
137 
138   bool private initialized;
139   bool private initializing;
140 
141   modifier initializer() {
142     require(initializing || isConstructor() || !initialized, "Contract instance has already been initialized");
143 
144     bool wasInitializing = initializing;
145     initializing = true;
146     initialized = true;
147 
148     _;
149 
150     initializing = wasInitializing;
151   }
152 
153   function isConstructor() private view returns (bool) {
154     uint256 cs;
155     assembly { cs := extcodesize(address) }
156     return cs == 0;
157   }
158 
159   uint256[50] private ______gap;
160 }
161 
162 contract Ownable is Initializable {
163 
164   address private _owner;
165   uint256 private _ownershipLocked;
166 
167   event OwnershipLocked(address lockedOwner);
168   event OwnershipRenounced(address indexed previousOwner);
169   event OwnershipTransferred(
170     address indexed previousOwner,
171     address indexed newOwner
172   );
173 
174 
175   function initialize(address sender) internal initializer {
176     _owner = sender;
177 	_ownershipLocked = 0;
178   }
179 
180   function owner() public view returns(address) {
181     return _owner;
182   }
183 
184   modifier onlyOwner() {
185     require(isOwner());
186     _;
187   }
188 
189   function isOwner() public view returns(bool) {
190     return msg.sender == _owner;
191   }
192 
193   function transferOwnership(address newOwner) public onlyOwner {
194     _transferOwnership(newOwner);
195   }
196 
197   function _transferOwnership(address newOwner) internal {
198     require(_ownershipLocked == 0);
199     require(newOwner != address(0));
200     emit OwnershipTransferred(_owner, newOwner);
201     _owner = newOwner;
202   }
203 
204   // Set _ownershipLocked flag to lock contract owner forever
205   function lockOwnership() public onlyOwner {
206 	require(_ownershipLocked == 0);
207 	emit OwnershipLocked(_owner);
208     _ownershipLocked = 1;
209   }
210 
211   uint256[50] private ______gap;
212 }
213 
214 interface IERC20 {
215   function totalSupply() external view returns (uint256);
216 
217   function balanceOf(address who) external view returns (uint256);
218 
219   function allowance(address owner, address spender)
220     external view returns (uint256);
221 
222   function transfer(address to, uint256 value) external returns (bool);
223 
224   function approve(address spender, uint256 value)
225     external returns (bool);
226 
227   function transferFrom(address from, address to, uint256 value)
228     external returns (bool);
229 
230   event Transfer(
231     address indexed from,
232     address indexed to,
233     uint256 value
234   );
235 
236   event Approval(
237     address indexed owner,
238     address indexed spender,
239     uint256 value
240   );
241 }
242 
243 contract ERC20Detailed is Initializable, IERC20 {
244   string private _name;
245   string private _symbol;
246   uint8 private _decimals;
247 
248   function initialize(string memory name, string memory symbol, uint8 decimals) internal initializer {
249     _name = name;
250     _symbol = symbol;
251     _decimals = decimals;
252   }
253 
254   function name() public view returns(string memory) {
255     return _name;
256   }
257 
258   function symbol() public view returns(string memory) {
259     return _symbol;
260   }
261 
262   function decimals() public view returns(uint8) {
263     return _decimals;
264   }
265 
266   uint256[50] private ______gap;
267 }
268 
269 library SafeMath {
270 
271     function add(uint256 a, uint256 b) internal pure returns (uint256) {
272         uint256 c = a + b;
273         require(c >= a, "SafeMath: addition overflow");
274 
275         return c;
276     }
277 
278     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
279         return sub(a, b, "SafeMath: subtraction overflow");
280     }
281 
282     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
283         require(b <= a, errorMessage);
284         uint256 c = a - b;
285 
286         return c;
287     }
288 
289     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
290         if (a == 0) {
291             return 0;
292         }
293 
294         uint256 c = a * b;
295         require(c / a == b, "SafeMath: multiplication overflow");
296 
297         return c;
298     }
299 
300     function div(uint256 a, uint256 b) internal pure returns (uint256) {
301         return div(a, b, "SafeMath: division by zero");
302     }
303 
304     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
305         require(b > 0, errorMessage);
306         uint256 c = a / b;
307 
308         return c;
309     }
310 
311     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
312         return mod(a, b, "SafeMath: modulo by zero");
313     }
314 
315     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
316         require(b != 0, errorMessage);
317         return a % b;
318     }
319 }
320 
321 /*
322 MIT License
323 Copyright (c) 2018 requestnetwork
324 Copyright (c) 2018 Fragments, Inc.
325 Permission is hereby granted, free of charge, to any person obtaining a copy
326 of this software and associated documentation files (the "Software"), to deal
327 in the Software without restriction, including without limitation the rights
328 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
329 copies of the Software, and to permit persons to whom the Software is
330 furnished to do so, subject to the following conditions:
331 The above copyright notice and this permission notice shall be included in all
332 copies or substantial portions of the Software.
333 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
334 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
335 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
336 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
337 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
338 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
339 SOFTWARE.
340 */
341 
342 
343 library SafeMathInt {
344 
345     int256 private constant MIN_INT256 = int256(1) << 255;
346     int256 private constant MAX_INT256 = ~(int256(1) << 255);
347 
348     function mul(int256 a, int256 b)
349         internal
350         pure
351         returns (int256)
352     {
353         int256 c = a * b;
354 
355         // Detect overflow when multiplying MIN_INT256 with -1
356         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
357         require((b == 0) || (c / b == a));
358         return c;
359     }
360 
361     function div(int256 a, int256 b)
362         internal
363         pure
364         returns (int256)
365     {
366         // Prevent overflow when dividing MIN_INT256 by -1
367         require(b != -1 || a != MIN_INT256);
368 
369         // Solidity already throws when dividing by 0.
370         return a / b;
371     }
372 
373     function sub(int256 a, int256 b)
374         internal
375         pure
376         returns (int256)
377     {
378         int256 c = a - b;
379         require((b >= 0 && c <= a) || (b < 0 && c > a));
380         return c;
381     }
382 
383     function add(int256 a, int256 b)
384         internal
385         pure
386         returns (int256)
387     {
388         int256 c = a + b;
389         require((b >= 0 && c >= a) || (b < 0 && c < a));
390         return c;
391     }
392 
393     function abs(int256 a)
394         internal
395         pure
396         returns (int256)
397     {
398         require(a != MIN_INT256);
399         return a < 0 ? -a : a;
400     }
401 }
402 
403 library UInt256Lib {
404 
405     uint256 private constant MAX_INT256 = ~(uint256(1) << 255);
406 
407     /**
408      * @dev Safely converts a uint256 to an int256.
409      */
410     function toInt256Safe(uint256 a)
411         internal
412         pure
413         returns (int256)
414     {
415         require(a <= MAX_INT256);
416         return int256(a);
417     }
418 }
419 
420 contract EBULL is Ownable, ERC20Detailed {
421 
422 
423 
424 
425     using SafeMath for uint256;
426     using SafeMathInt for int256;
427 	using UInt256Lib for uint256;
428 
429 	struct Transaction {
430         bool enabled;
431         address destination;
432         bytes data;
433     }
434 
435 
436     event TransactionFailed(address indexed destination, uint index, bytes data);
437 
438 	// Stable ordering is not guaranteed.
439 
440     Transaction[] public transactions;
441 
442 
443     modifier validRecipient(address to) {
444         require(to != address(0x0));
445         require(to != address(this));
446         _;
447     }
448 
449 
450 
451     IUniswapV2Pair private _pairUSD;
452     uint256 private constant ETH_DECIMALS = 18;
453     //Currently using USDC
454     uint256 private constant USD_DECIMALS = 6;
455 
456 	uint256 private constant PRICE_PRECISION = 10**9;
457 
458 
459   uint256 public EthNow;
460   uint256 public EthOld;
461   uint256 public LevUp;
462   uint256 public LevDown;
463   uint256 public TokenBurn;
464   uint256 public TokenAdd;
465   uint256 public Change;
466   uint256 public DLimit;
467   uint256 public EnableReb;
468   uint256 public EnableFee;
469   address public UniAdd;
470   address public Collector;
471   address public UniLP;
472   uint256 public Collect;
473   uint256 public Rvalue;
474   uint256 public Fee;
475   uint256 public constant PrPrecision = 1000000;
476 
477 
478     uint256 public constant DECIMALS = 9;
479     uint256 public constant MAX_UINT256 = ~uint256(0);
480     uint256 public constant INITIAL_SUPPLY = 200 * 10**4 * 10**DECIMALS;
481 
482 
483 
484     uint256 public _totalSupply;
485 
486 
487 
488     mapping(address => uint256) public _updatedBalance;
489     mapping(address => uint256) public blacklist;
490 
491 
492 
493     mapping (address => mapping (address => uint256)) public _allowance;
494 
495 	constructor() public {
496 
497 		Ownable.initialize(msg.sender);
498 		ERC20Detailed.initialize("Ethereum Bull", "EBULL", uint8(DECIMALS));
499 
500         _totalSupply = INITIAL_SUPPLY;
501         _updatedBalance[msg.sender] = _totalSupply;
502 
503         emit Transfer(address(0x0), msg.sender, _totalSupply);
504     }
505 
506 
507     //Set value for address to 1 for blacklisting
508     //Blacklisting is created for protection against front run bots on uniswap
509     function Addblacklist(address _blackadd, uint256 _blackvalue)
510     external
511     onlyOwner
512     {
513         blacklist[_blackadd] = _blackvalue;
514     }
515 
516 
517     function totalSupply()
518         public
519         view
520         returns (uint256)
521     {
522         return _totalSupply;
523     }
524 
525 	/**
526      * @param who The address to query.
527      * @return The balance of the specified address.
528      */
529 
530     function balanceOf(address who)
531         public
532         view
533         returns (uint256)
534     {
535         return _updatedBalance[who];
536     }
537 
538 	/**
539      * @dev Transfer tokens to a specified address.
540      * @param to The address to transfer to.
541      * @param value The amount to be transferred.
542      * @return True on success, false otherwise.
543      */
544 
545     function transfer(address to, uint256 value)
546         public
547         validRecipient(to)
548         returns (bool)
549     {
550       require(blacklist[msg.sender]!=1);
551 
552         _updatedBalance[msg.sender] = _updatedBalance[msg.sender].sub(value);
553 
554         if(EnableFee==1)
555         {
556           Rvalue=TransferFee(value);
557           emit Transfer(msg.sender, Collector, Collect);
558         }
559         else
560         {
561         Rvalue=value;
562 
563         }
564         _updatedBalance[to] = _updatedBalance[to].add(Rvalue);
565 
566 
567         emit Transfer(msg.sender, to, value);
568 
569 
570         return true;
571     }
572 
573 
574 
575 
576 	/**
577      * @dev Function to check the amount of tokens that an owner has allowed to a spender.
578      * @param owner_ The address which owns the funds.
579      * @param spender The address which will spend the funds.
580      * @return The number of tokens still available for the spender.
581      */
582 
583     function allowance(address owner_, address spender)
584         public
585         view
586         returns (uint256)
587     {
588         return _allowance[owner_][spender];
589     }
590 
591 	/**
592      * @dev Transfer tokens from one address to another.
593      * @param from The address you want to send tokens from.
594      * @param to The address you want to transfer to.
595      * @param value The amount of tokens to be transferred.
596      */
597 
598     function transferFrom(address from, address to, uint256 value)
599         public
600         validRecipient(to)
601         returns (bool)
602     {
603        require(blacklist[from]!=1);
604 
605         _allowance[from][msg.sender] = _allowance[from][msg.sender].sub(value);
606 
607         _updatedBalance[from] = _updatedBalance[from].sub(value);
608 
609         if(EnableFee==1)
610         {
611           Rvalue=TransferFee(value);
612           emit Transfer(from, Collector, Collect);
613         }
614         else
615         {
616         Rvalue=value;
617         }
618         _updatedBalance[to] = _updatedBalance[to].add(Rvalue);
619 
620 
621         emit Transfer(from, to, Rvalue);
622 
623 
624         return true;
625     }
626 
627 
628 	/**
629      * @dev Approve the passed address to spend the specified amount of tokens on behalf of
630      * msg.sender. This method is included for ERC20 compatibility.
631      * increaseAllowance and decreaseAllowance should be used instead.
632      * Changing an allowance with this method brings the risk that someone may transfer both
633      * the old and the new allowance - if they are both greater than zero - if a transfer
634      * transaction is mined before the later approve() call is mined.
635      *
636      * @param spender The address which will spend the funds.
637      * @param value The amount of tokens to be spent.
638      */
639 
640     function approve(address spender, uint256 value)
641         public
642         returns (bool)
643     {
644         _allowance[msg.sender][spender] = value;
645         emit Approval(msg.sender, spender, value);
646         return true;
647     }
648 
649 	/**
650      * @dev Increase the amount of tokens that an owner has allowed to a spender.
651      * This method should be used instead of approve() to avoid the double approval vulnerability
652      * described above.
653      * @param spender The address which will spend the funds.
654      * @param addedValue The amount of tokens to increase the allowance by.
655      */
656 
657     function increaseAllowance(address spender, uint256 addedValue)
658         public
659         returns (bool)
660     {
661         _allowance[msg.sender][spender] = _allowance[msg.sender][spender].add(addedValue);
662         emit Approval(msg.sender, spender, _allowance[msg.sender][spender]);
663         return true;
664     }
665 
666 	/**
667      * @dev Decrease the amount of tokens that an owner has allowed to a spender.
668      *
669      * @param spender The address which will spend the funds.
670      * @param subtractedValue The amount of tokens to decrease the allowance by.
671      */
672 
673     function decreaseAllowance(address spender, uint256 subtractedValue)
674         public
675         returns (bool)
676     {
677         uint256 oldValue = _allowance[msg.sender][spender];
678         if (subtractedValue >= oldValue) {
679             _allowance[msg.sender][spender] = 0;
680         } else {
681             _allowance[msg.sender][spender] = oldValue.sub(subtractedValue);
682         }
683         emit Approval(msg.sender, spender, _allowance[msg.sender][spender]);
684         return true;
685     }
686 
687 // Transction fee collection
688     function TransferFee(uint256 value) internal returns (uint256)
689 
690     {
691       Collect = value.mul(Fee).div(100000);  // fee is the percentage value * 1000
692       Rvalue=value.sub(Collect);
693       _updatedBalance[Collector] = _updatedBalance[Collector].add(Collect);
694 
695 
696 
697       return Rvalue;
698     }
699 
700 /// Set fee collector
701         function setCollector(address _Collector)
702               external
703             onlyOwner
704             {
705             Collector = _Collector;
706             }
707 
708 /// Set EnableFee==1 for enabling transaction fees
709          function setEnablefee(uint256 _EnableFee)
710                   external
711                   onlyOwner
712               {
713               EnableFee = _EnableFee;
714               }
715   /// Set Transaction fee %, example, if 1% is the fee then set fee= 1000;
716          function setTransfee(uint256 _TransFee)
717             external
718           onlyOwner
719           {
720           Fee = _TransFee;
721           }
722 
723 /// Set EnableReb==1 for enabling rebalance function
724           function setEnableReb(uint256 _EnableReb)
725               external
726               onlyOwner
727           {
728           EnableReb = _EnableReb;
729           }
730 
731 /// Set Uniswap pair of ETH/USD for price input
732       function setPairUSD(address factory, address token0, address token1)
733           external
734           onlyOwner
735       {
736       _pairUSD = IUniswapV2Pair(UniswapV2Library.pairFor(factory, token0, token1));
737       }
738 
739 // Get price of above set pair
740       function getPriceETH_USD() public view returns (uint256) {
741 
742           require(address(_pairUSD) != address(0));
743 
744   	    (uint256 reserves0, uint256 reserves1,) = _pairUSD.getReserves();
745 
746   	    // reserves0 = USDC (8 decimals) ETH
747   	    // reserves1 = ETH (18 decimals) USD
748 
749           uint256 price = reserves0.mul(10**(18-USD_DECIMALS)).mul(PRICE_PRECISION).div(reserves1);
750 
751           return price;
752       }
753 
754 
755 
756 // Set the address of Ebull uniswap Liquidity contract to be used in rebalance function
757       function InputUniLP(address _UniLP)
758        onlyOwner
759           external
760       {
761           UniLP= _UniLP;
762       }
763 
764       function UniLPAddress()
765           public
766           view
767           returns (address)
768       {
769           return UniLP;
770       }
771 
772 /// Set the upside leverage
773       function setLevUp(uint256 _LevUp) //  set integer values like 1,2,3...etc.
774           external
775           onlyOwner
776       {
777       LevUp = _LevUp;
778       }
779 
780 /// Set the Downside leverage
781       function setLevDown(uint256 _LevDown) //  set integer values like 1,2,3...etc.
782           external
783           onlyOwner
784         {
785           LevDown = _LevDown;
786         }
787 // Set Downside limit per rebalance call. This limit is needed as price cannot go down more than 100%,
788       function setDLimit(uint256 _DLimit) //  Example, for 50% down limit, set value to 0.5*e6
789             external
790             onlyOwner
791           {
792             DLimit = _DLimit;
793           }
794 
795 // Initialise the price of ETHOld for the first rebalance call
796   function InitialETHPrice()
797     external
798     onlyOwner
799   {
800     EthOld = getPriceETH_USD();
801   }
802 
803 
804 
805 
806 // Rebalance function changes the price of ebull in uniswap depending on the leveraged fluctuation in Eth Price
807     function ReBalance()
808       public
809     returns (bool)
810     { require(EnableReb==1,"Rebalance not enabled");
811 
812         EthNow = getPriceETH_USD();
813 
814         if(EthNow >= EthOld)
815         {
816          Change= PrPrecision.add(LevUp.mul(PrPrecision).mul(EthNow.sub(EthOld)).div(EthOld));  // LevUp is upside leverage = 3
817           TokenBurn = _updatedBalance[UniLP].sub(_updatedBalance[UniLP].mul(PrPrecision).div(Change));
818           TokenBurn=TokenBurn.div(10**DECIMALS);
819           _updatedBalance[UniLP] = _updatedBalance[UniLP].sub(TokenBurn.mul(10**DECIMALS));
820           _totalSupply = _totalSupply.sub(TokenBurn.mul(10**DECIMALS));
821         }
822         else
823         {
824           Change= LevDown.mul(PrPrecision).mul(EthOld.sub(EthNow)).div(EthOld);  // LevDown is downside leverage = 2
825 
826           if(Change>DLimit) // downside limit per transaction = 0.5*10**6
827           {
828           Change = DLimit;
829           }
830 
831           Change= PrPrecision.sub(Change);
832           TokenAdd = _updatedBalance[UniLP].mul(PrPrecision).div(Change);
833           TokenAdd = TokenAdd.sub(_updatedBalance[UniLP]);
834           TokenAdd=TokenAdd.div(10**DECIMALS);
835           _updatedBalance[UniLP] = _updatedBalance[UniLP].add(TokenAdd.mul(10**DECIMALS));
836           _totalSupply = _totalSupply.add(TokenAdd.mul(10**DECIMALS));
837         }
838 
839 
840 
841     IUniswapV2Pair(UniLP).sync();
842     EthOld = EthNow;
843     return true;
844 }
845 
846 
847 
848 }