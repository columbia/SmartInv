1 pragma solidity 0.5.17;
2 
3    
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
10     uint256 c = a * b;
11     assert(a == 0 || c / a == b);
12     return c;
13   }
14 
15   function div(uint256 a, uint256 b) internal pure returns (uint256) {
16     // assert(b > 0); // Solidity automatically throws when dividing by 0
17     uint256 c = a / b;
18     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
19     return c;
20   }
21 
22   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
23     assert(b <= a);
24     return a - b;
25   }
26 
27   function add(uint256 a, uint256 b) internal pure returns (uint256) {
28     uint256 c = a + b;
29     assert(c >= a);
30     return c;
31   }
32 }
33 
34 
35 /**
36  * @title Ownable
37  * @dev The Ownable contract has an owner address, and provides basic authorization control
38  * functions, this simplifies the implementation of "user permissions".
39  */
40 contract Ownable {
41   address public owner;
42 
43 
44   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
45 
46 
47   /**
48    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
49    * account.
50    */
51   constructor() public {
52     owner = msg.sender;
53   }
54 
55 
56   /**
57    * @dev Throws if called by any account other than the owner.
58    */
59   modifier onlyOwner() {
60     require(msg.sender == owner);
61     _;
62   }
63 
64 
65   /**
66    * @dev Allows the current owner to transfer control of the contract to a newOwner.
67    * @param newOwner The address to transfer ownership to.
68    */
69   function transferOwnership(address newOwner) onlyOwner public {
70     require(newOwner != address(0));
71     emit OwnershipTransferred(owner, newOwner);
72     owner = newOwner;
73   }
74 }
75 
76 /**
77  * @title ERC20Basic
78  * @dev Simpler version of ERC20 interface
79  * @dev see https://github.com/ethereum/EIPs/issues/179
80  */
81 contract ERC20Basic {
82   uint256 public totalSupply;
83   function balanceOf(address who) public view returns (uint256);
84   function transfer(address to, uint256 value) public returns (bool);
85   event Transfer(address indexed from, address indexed to, uint256 value);
86 }
87 
88 
89 /**
90  * @title Basic token
91  * @dev Basic version of StandardToken, with no allowances.
92  */
93 contract BasicToken is ERC20Basic {
94   using SafeMath for uint256;
95 
96   mapping(address => uint256) internal balances;
97 
98   /**
99   * @dev transfer token for a specified address
100   * @param _to The address to transfer to.
101   * @param _value The amount to be transferred.
102   */
103   function transfer(address _to, uint256 _value) public returns (bool) {
104     require(_to != address(0));
105 
106     // SafeMath.sub will throw if there is not enough balance.
107     balances[msg.sender] = balances[msg.sender].sub(_value);
108     balances[_to] = balances[_to].add(_value);
109     emit Transfer(msg.sender, _to, _value);
110     return true;
111   }
112 
113   /**
114   * @dev Gets the balance of the specified address.
115   * @param _owner The address to query the the balance of.
116   * @return An uint256 representing the amount owned by the passed address.
117   */
118   function balanceOf(address _owner) public view returns (uint256 balance) {
119     return balances[_owner];
120   }
121 }
122 
123 /**
124  * @title ERC20 interface
125  * @dev see https://github.com/ethereum/EIPs/issues/20
126  */
127 contract ERC20 is ERC20Basic {
128   function allowance(address owner, address spender) public view returns (uint256);
129   function transferFrom(address from, address to, uint256 value) public returns (bool);
130   function approve(address spender, uint256 value) public returns (bool);
131   event Approval(address indexed owner, address indexed spender, uint256 value);
132 }
133 
134 
135 /**
136  * @title Standard ERC20 token
137  *
138  * @dev Implementation of the basic standard token.
139  * @dev https://github.com/ethereum/EIPs/issues/20
140  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
141  */
142 contract StandardToken is ERC20, BasicToken {
143 
144   mapping (address => mapping (address => uint256)) internal allowed;
145 
146 
147   /**
148    * @dev Transfer tokens from one address to another
149    * @param _from address The address which you want to send tokens from
150    * @param _to address The address which you want to transfer to
151    * @param _value uint256 the amount of tokens to be transferred
152    */
153   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
154     require(_to != address(0));
155 
156     uint256 _allowance = allowed[_from][msg.sender];
157 
158     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
159     // require (_value <= _allowance);
160 
161     balances[_from] = balances[_from].sub(_value);
162     balances[_to] = balances[_to].add(_value);
163     allowed[_from][msg.sender] = _allowance.sub(_value);
164     emit Transfer(_from, _to, _value);
165     return true;
166   }
167 
168   /**
169    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
170    *
171    * Beware that changing an allowance with this method brings the risk that someone may use both the old
172    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
173    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
174    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
175    * @param _spender The address which will spend the funds.
176    * @param _value The amount of tokens to be spent.
177    */
178   function approve(address _spender, uint256 _value) public returns (bool) {
179     allowed[msg.sender][_spender] = _value;
180     emit Approval(msg.sender, _spender, _value);
181     return true;
182   }
183 
184   /**
185    * @dev Function to check the amount of tokens that an owner allowed to a spender.
186    * @param _owner address The address which owns the funds.
187    * @param _spender address The address which will spend the funds.
188    * @return A uint256 specifying the amount of tokens still available for the spender.
189    */
190   function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
191     return allowed[_owner][_spender];
192   }
193 
194   /**
195    * approve should be called when allowed[_spender] == 0. To increment
196    * allowed value is better to use this function to avoid 2 calls (and wait until
197    * the first transaction is mined)
198    * From MonolithDAO Token.sol
199    */
200   function increaseApproval (address _spender, uint _addedValue) public
201     returns (bool success) {
202     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
203     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
204     return true;
205   }
206 
207   function decreaseApproval (address _spender, uint _subtractedValue) public
208     returns (bool success) {
209     uint oldValue = allowed[msg.sender][_spender];
210     if (_subtractedValue > oldValue) {
211       allowed[msg.sender][_spender] = 0;
212     } else {
213       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
214     }
215     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
216     return true;
217   }
218 }
219 
220 
221 interface tokenRecipient { 
222     function receiveTokens(address _from, uint256 _value, bytes calldata _extraData) external;
223 }
224 
225 /**
226  * @title Burnable Token
227  * @dev Token that can be irreversibly burned (destroyed).
228  */
229 contract BurnableToken is StandardToken {
230 
231     event Burn(address indexed burner, uint256 value);
232 
233     /**
234      * @dev Burns a specific amount of tokens.
235      * @param _value The amount of token to be burned.
236      */
237     function _burn(address burner, uint256 _value) internal {
238         require(_value > 0);
239         require(_value <= balances[burner]);
240         // no need to require value <= totalSupply, since that would imply the
241         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
242 
243         balances[burner] = balances[burner].sub(_value);
244         totalSupply = totalSupply.sub(_value);
245         emit Transfer(burner, address(0), _value);
246         emit Burn(burner, _value);
247     }
248     
249     function burn(uint _value) public {
250         _burn(msg.sender, _value);
251     }
252 }
253 
254 contract IUniswapV2Factory {
255     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
256 
257     function feeTo() external view returns (address);
258     function feeToSetter() external view returns (address);
259     function migrator() external view returns (address);
260 
261     function getPair(address tokenA, address tokenB) external view returns (address pair);
262     function allPairs(uint) external view returns (address pair);
263     function allPairsLength() external view returns (uint);
264 
265     function createPair(address tokenA, address tokenB) external returns (address pair);
266 
267     function setFeeTo(address) external;
268     function setFeeToSetter(address) external;
269     function setMigrator(address) external;
270 }
271 
272 contract IUniswapV2Router01 {
273     function factory() external pure returns (address);
274     function WETH() external pure returns (address);
275 
276     function addLiquidity(
277         address tokenA,
278         address tokenB,
279         uint amountADesired,
280         uint amountBDesired,
281         uint amountAMin,
282         uint amountBMin,
283         address to,
284         uint deadline
285     ) external returns (uint amountA, uint amountB, uint liquidity);
286     function addLiquidityETH(
287         address token,
288         uint amountTokenDesired,
289         uint amountTokenMin,
290         uint amountETHMin,
291         address to,
292         uint deadline
293     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
294     function removeLiquidity(
295         address tokenA,
296         address tokenB,
297         uint liquidity,
298         uint amountAMin,
299         uint amountBMin,
300         address to,
301         uint deadline
302     ) external returns (uint amountA, uint amountB);
303     function removeLiquidityETH(
304         address token,
305         uint liquidity,
306         uint amountTokenMin,
307         uint amountETHMin,
308         address to,
309         uint deadline
310     ) external returns (uint amountToken, uint amountETH);
311     function removeLiquidityWithPermit(
312         address tokenA,
313         address tokenB,
314         uint liquidity,
315         uint amountAMin,
316         uint amountBMin,
317         address to,
318         uint deadline,
319         bool approveMax, uint8 v, bytes32 r, bytes32 s
320     ) external returns (uint amountA, uint amountB);
321     function removeLiquidityETHWithPermit(
322         address token,
323         uint liquidity,
324         uint amountTokenMin,
325         uint amountETHMin,
326         address to,
327         uint deadline,
328         bool approveMax, uint8 v, bytes32 r, bytes32 s
329     ) external returns (uint amountToken, uint amountETH);
330     function swapExactTokensForTokens(
331         uint amountIn,
332         uint amountOutMin,
333         address[] calldata path,
334         address to,
335         uint deadline
336     ) external returns (uint[] memory amounts);
337     function swapTokensForExactTokens(
338         uint amountOut,
339         uint amountInMax,
340         address[] calldata path,
341         address to,
342         uint deadline
343     ) external returns (uint[] memory amounts);
344     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
345         external
346         payable
347         returns (uint[] memory amounts);
348     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
349         external
350         returns (uint[] memory amounts);
351     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
352         external
353         returns (uint[] memory amounts);
354     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
355         external
356         payable
357         returns (uint[] memory amounts);
358 
359     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
360     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
361     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
362     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
363     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
364 }
365 
366 contract IUniswapV2Router02 is IUniswapV2Router01 {
367     function removeLiquidityETHSupportingFeeOnTransferTokens(
368         address token,
369         uint liquidity,
370         uint amountTokenMin,
371         uint amountETHMin,
372         address to,
373         uint deadline
374     ) external returns (uint amountETH);
375     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
376         address token,
377         uint liquidity,
378         uint amountTokenMin,
379         uint amountETHMin,
380         address to,
381         uint deadline,
382         bool approveMax, uint8 v, bytes32 r, bytes32 s
383     ) external returns (uint amountETH);
384 
385     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
386         uint amountIn,
387         uint amountOutMin,
388         address[] calldata path,
389         address to,
390         uint deadline
391     ) external;
392     function swapExactETHForTokensSupportingFeeOnTransferTokens(
393         uint amountOutMin,
394         address[] calldata path,
395         address to,
396         uint deadline
397     ) external payable;
398     function swapExactTokensForETHSupportingFeeOnTransferTokens(
399         uint amountIn,
400         uint amountOutMin,
401         address[] calldata path,
402         address to,
403         uint deadline
404     ) external;
405 }
406 
407 contract IUniswapV2Pair {
408     event Approval(address indexed owner, address indexed spender, uint value);
409     event Transfer(address indexed from, address indexed to, uint value);
410 
411     function name() external pure returns (string memory);
412     function symbol() external pure returns (string memory);
413     function decimals() external pure returns (uint8);
414     function totalSupply() external view returns (uint);
415     function balanceOf(address owner) external view returns (uint);
416     function allowance(address owner, address spender) external view returns (uint);
417 
418     function approve(address spender, uint value) external returns (bool);
419     function transfer(address to, uint value) external returns (bool);
420     function transferFrom(address from, address to, uint value) external returns (bool);
421 
422     function DOMAIN_SEPARATOR() external view returns (bytes32);
423     function PERMIT_TYPEHASH() external pure returns (bytes32);
424     function nonces(address owner) external view returns (uint);
425 
426     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
427 
428     event Mint(address indexed sender, uint amount0, uint amount1);
429     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
430     event Swap(
431         address indexed sender,
432         uint amount0In,
433         uint amount1In,
434         uint amount0Out,
435         uint amount1Out,
436         address indexed to
437     );
438     event Sync(uint112 reserve0, uint112 reserve1);
439 
440     function MINIMUM_LIQUIDITY() external pure returns (uint);
441     function factory() external view returns (address);
442     function token0() external view returns (address);
443     function token1() external view returns (address);
444     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
445     function price0CumulativeLast() external view returns (uint);
446     function price1CumulativeLast() external view returns (uint);
447     function kLast() external view returns (uint);
448 
449     function mint(address to) external returns (uint liquidity);
450     function burn(address to) external returns (uint amount0, uint amount1);
451     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
452     function skim(address to) external;
453     function sync() external;
454 
455     function initialize(address, address) external;
456 }
457 
458 interface IWETH {
459     function deposit() external payable;
460     function transfer(address to, uint value) external returns (bool);
461     function withdraw(uint) external;
462 }
463 
464 
465 contract Protocore is BurnableToken, Ownable {
466     
467     event LiquidityAddition(address indexed dst, uint value);
468     event LPTokenClaimed(address dst, uint value);
469     
470     uint256 public contractStartTimestamp;
471     
472     address public feeDistributorAddress;
473     address public reserveAddress;
474     address public devAddress;
475     
476     uint public reserveFeePercentX100 = 20;
477     uint public devFeePercentX100 = 10;
478     uint public disburseFeePercentX100 = 100;
479     
480     uint public liquidityGenerationDuration = 3 days;
481     uint public adminCanDrainContractAfter = 4 days;
482     
483     IUniswapV2Router02 public uniswapRouterV2;
484     IUniswapV2Factory public uniswapFactory;
485     uint256 public lastTotalSupplyOfLPTokens;
486 
487     address public tokenUniswapPair;
488     
489     mapping (address => bool) public voidFeeList;
490     mapping (address => bool) public voidFeeRecipientList;
491     
492     uint256 public totalLPTokensMinted;
493     uint256 public totalETHContributed;
494     uint256 public LPperETHUnit;
495 
496     string public constant name = "Protocore";
497     string public constant symbol = "pCORE";
498     uint public constant decimals = 18;
499     // there is no problem in using * here instead of .mul()
500     uint256 public constant initialSupply = 10000 * (10 ** uint256(decimals));
501     
502     uint public limitBuyAmount = 50e18;
503     bool public isLimitBuyOn = true;
504     
505     function setLimitBuyAmount(uint _limitBuyAmount) public onlyOwner {
506         limitBuyAmount = _limitBuyAmount;
507     }
508     
509     function turnLimitBuyOff() public onlyOwner {
510         isLimitBuyOn = false;
511     }
512     function turnLimitBuyOn() public onlyOwner {
513         isLimitBuyOn = true;
514     }
515     
516     function canTransfer(address sender, address recipient, uint amount) public view returns(bool) {
517         // if pair is sending (buys are happening)
518         if ((isLimitBuyOn) && (sender == tokenUniswapPair) && (amount > limitBuyAmount)) {
519             return false;
520         }
521         return true;
522     }
523     
524     function setFeeDistributor(address _feeDistributorAddress) public onlyOwner {
525         feeDistributorAddress = _feeDistributorAddress;
526     }
527     function setReserveAddress(address _reserveAddress) public onlyOwner {
528         reserveAddress = _reserveAddress;
529     }
530     function setDevAddress(address _devAddress) public onlyOwner {
531         devAddress = _devAddress;
532     }
533     
534     function setDisburseFeePercentX100(uint _disburseFeePercentX100) public onlyOwner {
535         disburseFeePercentX100 = _disburseFeePercentX100;
536     }
537     function setReserveFeePercentX100(uint _reserveFeePercentX100) public onlyOwner {
538         reserveFeePercentX100 = _reserveFeePercentX100;
539     }
540     function setDevFeePercentX100(uint _devFeePercentX100) public onlyOwner {
541         devFeePercentX100 = _devFeePercentX100;
542     }
543     
544     function editVoidFeeList(address _address, bool _noFee) public onlyOwner {
545         voidFeeList[_address] = _noFee;
546     }
547     function editVoidFeeRecipientList(address _address, bool _noFee) public onlyOwner {
548         voidFeeRecipientList[_address] = _noFee;
549     }
550     
551     // -------------- fee approver functions ---------------
552     
553     function sync() public {
554         uint256 _LPSupplyOfPairTotal = ERC20(tokenUniswapPair).totalSupply();
555         lastTotalSupplyOfLPTokens = _LPSupplyOfPairTotal;
556     }
557     
558     function calculateAmountsAfterFee(        
559         address sender, // unusused maby used future
560         address recipient, // unusued maybe use din future
561         uint256 amount
562         ) private returns (uint256 _amountToReserve, uint256 _amountToDisburse, uint256 _amountToDev) 
563         {
564 
565             uint256 _LPSupplyOfPairTotal = ERC20(tokenUniswapPair).totalSupply();
566 
567             if(sender == tokenUniswapPair) 
568                 require(lastTotalSupplyOfLPTokens <= _LPSupplyOfPairTotal, "Liquidity withdrawals forbidden");
569 
570 
571             if(sender == feeDistributorAddress  
572                 || sender == tokenUniswapPair 
573                 || voidFeeList[sender]
574                 || voidFeeRecipientList[recipient]
575                 || sender == address(this)
576                 ) { // Dont have a fee when corevault is sending, or infinite loop
577                                      // And when pair is sending ( buys are happening, no tax on it)
578                 _amountToReserve = 0;
579                 _amountToDisburse = 0;
580                 _amountToDev = 0;
581             } 
582             else {
583                 
584                 _amountToReserve = amount.mul(reserveFeePercentX100).div(10000);
585                 _amountToDisburse = amount.mul(disburseFeePercentX100).div(10000);
586                 _amountToDev = amount.mul(devFeePercentX100).div(10000);
587                 
588             }
589 
590 
591            lastTotalSupplyOfLPTokens = _LPSupplyOfPairTotal;
592         }
593     
594     // --------------- end fee approver functions ---------------
595     
596 
597     function createUniswapPairMainnet() public returns (address) {
598         require(tokenUniswapPair == address(0), "Token: pool already created");
599         tokenUniswapPair = uniswapFactory.createPair(
600             address(uniswapRouterV2.WETH()),
601             address(this)
602         );
603         return tokenUniswapPair;
604     }
605     
606     
607     
608     // Constructors
609     constructor (address router, address factory) public {
610         totalSupply = initialSupply;
611         balances[address(this)] = initialSupply; // Send all tokens to owner
612         emit Transfer(address(0), address(this), initialSupply);
613         
614         contractStartTimestamp = now;
615         
616         uniswapRouterV2 = IUniswapV2Router02(router != address(0) ? router : 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D); // For testing
617         uniswapFactory = IUniswapV2Factory(factory != address(0) ? factory : 0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f); // For testing
618         createUniswapPairMainnet();
619     }
620     
621     function transfer(address to, uint amount) public returns (bool) {
622         // uint _amountToReserve = amount.mul(reserveFeePercentX100).div(10000);
623         // uint _amountToDisburse = amount.mul(disburseFeePercentX100).div(10000);
624         // uint _amountToDev = amount.mul(devFeePercentX100).div(10000);
625         
626         require(canTransfer(msg.sender, to, amount), "Limit buys are on!");
627         
628         (uint _amountToReserve, uint _amountToDisburse, uint _amountToDev) = calculateAmountsAfterFee(msg.sender, to, amount);
629         
630         
631         uint _amountAfterFee = amount.sub(_amountToReserve).sub(_amountToDisburse).sub(_amountToDev);
632 
633         require(super.transfer(feeDistributorAddress, _amountToDisburse), "Cannot disburse rewards.");        
634         require(super.transfer(reserveAddress, _amountToReserve), "Cannot send tokens to reserve!");
635         require(super.transfer(devAddress, _amountToDev), "Cannot transfer dev fee!");
636 
637         if (feeDistributorAddress != address(0) && _amountToDisburse > 0) {
638             tokenRecipient(feeDistributorAddress).receiveTokens(msg.sender, _amountToDisburse, "");
639         }
640         require(super.transfer(to, _amountAfterFee), "Cannot transfer tokens.");
641         return true;
642     }
643     
644     function transferFrom(address from, address to, uint amount) public returns (bool) {
645         
646         require(canTransfer(from, to, amount), "Limit buys are on!");
647         
648         require(to != address(0));
649         // uint _amountToReserve = amount.mul(reserveFeePercentX100).div(10000);
650         // uint _amountToDev = amount.mul(devFeePercentX100).div(10000);
651         // uint _amountToDisburse = amount.mul(disburseFeePercentX100).div(10000);
652         
653         (uint _amountToReserve, uint _amountToDisburse, uint _amountToDev) = calculateAmountsAfterFee(from, to, amount);
654         
655         
656         uint _amountAfterFee = amount.sub(_amountToReserve).sub(_amountToDisburse).sub(_amountToDev);
657         
658         uint256 _allowance = allowed[from][msg.sender];
659     
660         // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
661         // require (_value <= _allowance);
662 
663         balances[from] = balances[from].sub(_amountAfterFee);
664         balances[to] = balances[to].add(_amountAfterFee);
665         
666         balances[from] = balances[from].sub(_amountToDisburse);
667         balances[feeDistributorAddress] = balances[feeDistributorAddress].add(_amountToDisburse);
668         
669         balances[from] = balances[from].sub(_amountToDev);
670         balances[devAddress] = balances[devAddress].add(_amountToDev);
671         
672         balances[from] = balances[from].sub(_amountToReserve);
673         balances[reserveAddress] = balances[reserveAddress].add(_amountToReserve);
674         
675         
676         allowed[from][msg.sender] = _allowance.sub(amount);
677         
678 
679         emit Transfer(from, feeDistributorAddress, _amountToDisburse);
680         emit Transfer(from, reserveAddress, _amountToReserve);
681         emit Transfer(from, devAddress, _amountToDev);
682         emit Transfer(from, to, _amountAfterFee);
683         
684         if (feeDistributorAddress != address(0) && _amountToDisburse > 0) {
685             tokenRecipient(feeDistributorAddress).receiveTokens(msg.sender, _amountToDisburse, "");
686         }
687         return true;
688     }
689     
690     // --------------- Liquidity Generation Event Scripts ---------------
691     
692     //// Liquidity generation logic
693     /// Steps - All tokens tat will ever exist go to this contract
694     /// This contract accepts ETH as payable
695     /// ETH is mapped to people
696     /// When liquidity generationevent is over veryone can call
697     /// the mint LP function
698     // which will put all the ETH and tokens inside the uniswap contract
699     /// without any involvement
700     /// This LP will go into this contract
701     /// And will be able to proportionally be withdrawn baed on ETH put in
702     /// A emergency drain function allows the contract owner to drain all ETH and tokens from this contract
703     /// After the liquidity generation event happened. In case something goes wrong, to send ETH back
704 
705 
706     string public liquidityGenerationParticipationAgreement = "I agree that the developers and affiliated parties of the Protocore team are not responsible for my funds";
707 
708     function liquidityGenerationOngoing() public view returns (bool) {
709         return contractStartTimestamp.add(liquidityGenerationDuration) > block.timestamp;
710     }
711     function canAdminDrainContract() public view returns (bool) {
712         return contractStartTimestamp.add(adminCanDrainContractAfter) < block.timestamp;
713     }
714     
715     // Emergency drain in case of a bug
716     // Adds all funds to owner to refund people
717     // Designed to be as simple as possible
718     function emergencyDrain24hAfterLiquidityGenerationEventIsDone() public onlyOwner {
719         require(canAdminDrainContract(), "Liquidity generation grace period still ongoing"); // About 24h after liquidity generation happens
720         (bool success, ) = msg.sender.call.value(address(this).balance)("");
721         require(success, "Transfer failed.");
722         emit Transfer(address(this), msg.sender, balances[address(this)]);
723         balances[msg.sender] = balances[address(this)];
724         balances[address(this)] = 0;
725     }
726     
727     bool public LPGenerationCompleted;
728     // Sends all avaibile balances and mints LP tokens
729     // Possible ways this could break addressed
730     // 1) Multiple calls and resetting amounts - addressed with boolean
731     // 2) Failed WETH wrapping/unwrapping addressed with checks
732     // 3) Failure to create LP tokens, addressed with checks
733     // 4) Unacceptable division errors . Addressed with multiplications by 1e18
734     // 5) Pair not set - impossible since its set in constructor
735     function addLiquidityToUniswapPROTOCORExWETHPair() public onlyOwner {
736         require(liquidityGenerationOngoing() == false, "Liquidity generation onging");
737         require(LPGenerationCompleted == false, "Liquidity generation already finished");
738         totalETHContributed = address(this).balance;
739         IUniswapV2Pair pair = IUniswapV2Pair(tokenUniswapPair);
740         
741         //Wrap eth
742         address WETH = uniswapRouterV2.WETH();
743         IWETH(WETH).deposit.value(totalETHContributed)();
744         require(address(this).balance == 0 , "Transfer Failed");
745         IWETH(WETH).transfer(address(pair),totalETHContributed);
746         emit Transfer(address(this), address(pair), balances[address(this)]);
747         balances[address(pair)] = balances[address(this)];
748         balances[address(this)] = 0;
749         pair.mint(address(this));
750         totalLPTokensMinted = pair.balanceOf(address(this));
751         
752         require(totalLPTokensMinted != 0 , "LP creation failed");
753         LPperETHUnit = totalLPTokensMinted.mul(1e18).div(totalETHContributed); // 1e18x for  change
754         
755         require(LPperETHUnit != 0 , "LP creation failed");
756         LPGenerationCompleted = true;
757         sync();
758     }
759     
760     mapping (address => uint)  public ethContributed;
761     // Possible ways this could break addressed
762     // 1) No ageement to terms - added require
763     // 2) Adding liquidity after generaion is over - added require
764     // 3) Overflow from uint - impossible there isnt that much ETH aviable
765     // 4) Depositing 0 - not an issue it will just add 0 to tally
766     function addLiquidity(bool agreesToTermsOutlinedInLiquidityGenerationParticipationAgreement) public payable {
767         require(liquidityGenerationOngoing(), "Liquidity Generation Event over");
768         require(agreesToTermsOutlinedInLiquidityGenerationParticipationAgreement, "No agreement provided");
769         ethContributed[msg.sender] += msg.value; // Overflow protection from safemath is not neded here
770         totalETHContributed = totalETHContributed.add(msg.value); // for front end display during LGE. This resets with definietly correct balance while calling pair.
771         emit LiquidityAddition(msg.sender, msg.value);
772     }
773 
774     // Possible ways this could break addressed
775     // 1) Accessing before event is over and resetting eth contributed -- added require
776     // 2) No uniswap pair - impossible at this moment because of the LPGenerationCompleted bool
777     // 3) LP per unit is 0 - impossible checked at generation function
778     function claimLPTokens() public {
779         require(LPGenerationCompleted, "Event not over yet");
780         require(ethContributed[msg.sender] > 0 , "Nothing to claim, move along");
781         IUniswapV2Pair pair = IUniswapV2Pair(tokenUniswapPair);
782         uint256 amountLPToTransfer = ethContributed[msg.sender].mul(LPperETHUnit).div(1e18);
783         pair.transfer(msg.sender, amountLPToTransfer); // stored as 1e18x value for change
784         ethContributed[msg.sender] = 0;
785         emit LPTokenClaimed(msg.sender, amountLPToTransfer);
786     }
787     
788     // --------------- End Liquidity Generation Event Scripts ---------------
789     
790     // token recovery function
791     function transferAnyERC20Token(address _tokenAddress, address _to, uint _amount) public onlyOwner {
792         require(_tokenAddress != tokenUniswapPair, "Admin Cannot transfer out pCORE/WETH LP Tokens from this contract!");
793         require(canAdminDrainContract(), "Liquidity generation grace period still ongoing");
794         ERC20(_tokenAddress).transfer(_to, _amount);
795     }
796     
797 }