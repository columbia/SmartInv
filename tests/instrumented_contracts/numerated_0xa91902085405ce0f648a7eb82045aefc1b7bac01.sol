1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.6.12;
4 
5 interface IERC20 {
6     function totalSupply() external view returns (uint256);
7 
8     function balanceOf(address account) external view returns (uint256);
9 
10     function allowance(address owner, address spender) external view returns (uint256);
11 
12     function approve(address spender, uint256 amount) external returns (bool);
13 
14     function transfer(address recipient, uint256 amount) external returns (bool);
15 
16     function transferFrom(
17         address sender,
18         address recipient,
19         uint256 amount
20     ) external returns (bool);
21 
22     function burn(uint256 value) external returns (bool);
23 }
24 
25 
26 pragma solidity 0.6.12;
27 
28 interface IFlashReceiver {
29     function receiveFlash(
30         bytes32 _id,
31         uint256 _amountIn,
32         uint256 _expireAfter,
33         uint256 _mintedAmount,
34         address _staker,
35         bytes calldata _data
36     ) external returns (uint256);
37 }
38 
39 
40 pragma solidity 0.6.12;
41 
42 interface IFlashProtocol {
43     function stake(
44         uint256 _amountIn,
45         uint256 _days,
46         address _receiver,
47         bytes calldata _data
48     )
49         external
50         returns (
51             uint256 mintedAmount,
52             uint256 matchedAmount,
53             bytes32 id
54         );
55 
56     function unstake(bytes32 _id)
57         external
58         returns (uint256 withdrawAmount);
59 
60     function getFPY(uint256 _amountIn) external view returns (uint256);
61 }
62 
63 
64 pragma solidity 0.6.12;
65 
66 // A library for performing overflow-safe math, courtesy of DappHub: https://github.com/dapphub/ds-math/blob/d0ef6d6a5f/src/math.sol
67 // Modified to include only the essentials
68 library SafeMath {
69     function add(uint256 x, uint256 y) internal pure returns (uint256 z) {
70         require((z = x + y) >= x, "MATH:: ADD_OVERFLOW");
71     }
72 
73     function sub(uint256 x, uint256 y) internal pure returns (uint256 z) {
74         require((z = x - y) <= x, "MATH:: SUB_UNDERFLOW");
75     }
76 
77     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
78         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
79         // benefit is lost if 'b' is also tested.
80         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
81         if (a == 0) {
82             return 0;
83         }
84 
85         uint256 c = a * b;
86         require(c / a == b, "MATH:: MUL_OVERFLOW");
87 
88         return c;
89     }
90 
91     function div(uint256 a, uint256 b) internal pure returns (uint256) {
92         require(b > 0, "MATH:: DIVISION_BY_ZERO");
93         uint256 c = a / b;
94         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
95 
96         return c;
97     }
98 
99     function min(uint x, uint y) internal pure returns (uint z) {
100         z = x < y ? x : y;
101     }
102 
103     // babylonian method (https://en.wikipedia.org/wiki/Methods_of_computing_square_roots#Babylonian_method)
104     function sqrt(uint y) internal pure returns (uint z) {
105         if (y > 3) {
106             z = y;
107             uint x = y / 2 + 1;
108             while (x < z) {
109                 z = x;
110                 x = (y / x + x) / 2;
111             }
112         } else if (y != 0) {
113             z = 1;
114         }
115     }
116 }
117 
118 
119 pragma solidity 0.6.12;
120 
121 /**
122  * @dev Collection of functions related to the address type
123  */
124 library Address {
125     /**
126      * @dev Returns true if `account` is a contract.
127      *
128      * [IMPORTANT]
129      * ====
130      * It is unsafe to assume that an address for which this function returns
131      * false is an externally-owned account (EOA) and not a contract.
132      *
133      * Among others, `isContract` will return false for the following
134      * types of addresses:
135      *
136      *  - an externally-owned account
137      *  - a contract in construction
138      *  - an address where a contract will be created
139      *  - an address where a contract lived, but was destroyed
140      * ====
141      */
142     function isContract(address account) internal view returns (bool) {
143         // This method relies on extcodesize, which returns 0 for contracts in
144         // construction, since the code is only stored at the end of the
145         // constructor execution.
146 
147         uint256 size;
148         // solhint-disable-next-line no-inline-assembly
149         assembly {
150             size := extcodesize(account)
151         }
152         return size > 0;
153     }
154 }
155 
156 
157 
158 pragma solidity ^0.6.0;
159 
160 /**
161  * @dev Helper to make usage of the `CREATE2` EVM opcode easier and safer.
162  * `CREATE2` can be used to compute in advance the address where a smart
163  * contract will be deployed, which allows for interesting new mechanisms known
164  * as 'counterfactual interactions'.
165  *
166  * See the https://eips.ethereum.org/EIPS/eip-1014#motivation[EIP] for more
167  * information.
168  */
169 library Create2 {
170     /**
171      * @dev Deploys a contract using `CREATE2`. The address where the contract
172      * will be deployed can be known in advance via {computeAddress}.
173      *
174      * The bytecode for a contract can be obtained from Solidity with
175      * `type(contractName).creationCode`.
176      *
177      * Requirements:
178      *
179      * - `bytecode` must not be empty.
180      * - `salt` must have not been used for `bytecode` already.
181      * - the factory must have a balance of at least `amount`.
182      * - if `amount` is non-zero, `bytecode` must have a `payable` constructor.
183      */
184     function deploy(uint256 amount, bytes32 salt, bytes memory bytecode) internal returns (address) {
185         address addr;
186         require(address(this).balance >= amount, "Create2: insufficient balance");
187         require(bytecode.length != 0, "Create2: bytecode length is zero");
188         // solhint-disable-next-line no-inline-assembly
189         assembly {
190             addr := create2(amount, add(bytecode, 0x20), mload(bytecode), salt)
191         }
192         require(addr != address(0), "Create2: Failed on deploy");
193         return addr;
194     }
195 
196     /**
197      * @dev Returns the address where a contract will be stored if deployed via {deploy}. Any change in the
198      * `bytecodeHash` or `salt` will result in a new destination address.
199      */
200     function computeAddress(bytes32 salt, bytes32 bytecodeHash) internal view returns (address) {
201         return computeAddress(salt, bytecodeHash, address(this));
202     }
203 
204     /**
205      * @dev Returns the address where a contract will be stored if deployed via {deploy} from a contract located at
206      * `deployer`. If `deployer` is this contract's address, returns the same value as {computeAddress}.
207      */
208     function computeAddress(bytes32 salt, bytes32 bytecodeHash, address deployer) internal pure returns (address) {
209         bytes32 _data = keccak256(
210             abi.encodePacked(bytes1(0xff), deployer, salt, bytecodeHash)
211         );
212         return address(uint256(_data));
213     }
214 }
215 
216 
217 pragma solidity 0.6.12;
218 
219 interface IPool {
220     function initialize(address _token) external;
221 
222     function stakeWithFeeRewardDistribution(
223         uint256 _amountIn,
224         address _staker,
225         uint256 _expectedOutput
226     ) external returns (uint256 result);
227 
228     function addLiquidity(
229         uint256 _amountFLASH,
230         uint256 _amountALT,
231         uint256 _amountFLASHMin,
232         uint256 _amountALTMin,
233         address _maker
234     )
235         external
236         returns (
237             uint256,
238             uint256,
239             uint256
240         );
241 
242     function removeLiquidity(address _maker) external returns (uint256, uint256);
243 
244     function swapWithFeeRewardDistribution(
245         uint256 _amountIn,
246         address _staker,
247         uint256 _expectedOutput
248     ) external returns (uint256 result);
249 }
250 
251 
252 pragma solidity 0.6.12;
253 
254 
255 
256 // Lightweight token modelled after UNI-LP:
257 // https://github.com/Uniswap/uniswap-v2-core/blob/v1.0.1/contracts/UniswapV2ERC20.sol
258 // Adds:
259 //   - An exposed `mint()` with minting role
260 //   - An exposed `burn()`
261 //   - ERC-3009 (`transferWithAuthorization()`)
262 //   - flashMint() - allows to flashMint an arbitrary amount of FLASH, with the
263 //     condition that it is burned before the end of the transaction.
264 contract PoolERC20 is IERC20 {
265     using SafeMath for uint256;
266 
267     // bytes32 private constant EIP712DOMAIN_HASH =
268     // keccak256("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)")
269     bytes32 private constant EIP712DOMAIN_HASH = 0x8b73c3c69bb8fe3d512ecc4cf759cc79239f7b179b0ffacaa9a75d522b39400f;
270 
271     // bytes32 private constant NAME_HASH = keccak256("FLASH-ALT-LP Token")
272     bytes32 private constant NAME_HASH = 0xfdde3a7807889787f51ab17062704a0d81341ba7debe5a9773b58a1b5e5f422c;
273 
274     // bytes32 private constant VERSION_HASH = keccak256("1")
275     bytes32 private constant VERSION_HASH = 0xc89efdaa54c0f20c7adf612882df0950f5a951637e0307cdcb4c672f298b8bc6;
276 
277     // bytes32 public constant PERMIT_TYPEHASH =
278     // keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");
279     bytes32 public constant PERMIT_TYPEHASH = 0x6e71edae12b1b97f4d1f60370fef10105fa2faae0126114a169c64845d6126c9;
280 
281     // bytes32 public constant TRANSFER_WITH_AUTHORIZATION_TYPEHASH =
282     // keccak256("TransferWithAuthorization(address from,address to,uint256 value,uint256 validAfter,uint256 validBefore,bytes32 nonce)");
283     bytes32
284         public constant TRANSFER_WITH_AUTHORIZATION_TYPEHASH = 0x7c7c6cdb67a18743f49ec6fa9b35f50d52ed05cbed4cc592e13b44501c1a2267;
285 
286     string public constant name = "FLASH-ALT-LP Token";
287     string public constant symbol = "FLASH-ALT-LP";
288     uint8 public constant decimals = 18;
289 
290     uint256 public override totalSupply;
291 
292     address public minter;
293 
294     mapping(address => uint256) public override balanceOf;
295     mapping(address => mapping(address => uint256)) public override allowance;
296 
297     // ERC-2612, ERC-3009 state
298     mapping(address => uint256) public nonces;
299     mapping(address => mapping(bytes32 => bool)) public authorizationState;
300 
301     event Approval(address indexed owner, address indexed spender, uint256 value);
302     event Transfer(address indexed from, address indexed to, uint256 value);
303     event AuthorizationUsed(address indexed authorizer, bytes32 indexed nonce);
304 
305     function _validateSignedData(
306         address signer,
307         bytes32 encodeData,
308         uint8 v,
309         bytes32 r,
310         bytes32 s
311     ) internal view {
312         bytes32 digest = keccak256(abi.encodePacked("\x19\x01", getDomainSeparator(), encodeData));
313         address recoveredAddress = ecrecover(digest, v, r, s);
314         // Explicitly disallow authorizations for address(0) as ecrecover returns address(0) on malformed messages
315         require(recoveredAddress != address(0) && recoveredAddress == signer, "FLASH-ALT-LP Token:: INVALID_SIGNATURE");
316     }
317 
318     function _mint(address to, uint256 value) internal {
319         totalSupply = totalSupply.add(value);
320         balanceOf[to] = balanceOf[to].add(value);
321         emit Transfer(address(0), to, value);
322     }
323 
324     function _burn(address from, uint256 value) internal {
325         // Balance is implicitly checked with SafeMath's underflow protection
326         balanceOf[from] = balanceOf[from].sub(value);
327         totalSupply = totalSupply.sub(value);
328         emit Transfer(from, address(0), value);
329     }
330 
331     function _approve(
332         address owner,
333         address spender,
334         uint256 value
335     ) private {
336         allowance[owner][spender] = value;
337         emit Approval(owner, spender, value);
338     }
339 
340     function _transfer(
341         address from,
342         address to,
343         uint256 value
344     ) private {
345         require(to != address(0), "FLASH-ALT-LP Token:: RECEIVER_IS_TOKEN_OR_ZERO");
346         // Balance is implicitly checked with SafeMath's underflow protection
347         balanceOf[from] = balanceOf[from].sub(value);
348         balanceOf[to] = balanceOf[to].add(value);
349         emit Transfer(from, to, value);
350     }
351 
352     function getChainId() public pure returns (uint256 chainId) {
353         // solhint-disable-next-line no-inline-assembly
354         assembly {
355             chainId := chainid()
356         }
357     }
358 
359     function getDomainSeparator() public view returns (bytes32) {
360         return keccak256(abi.encode(EIP712DOMAIN_HASH, NAME_HASH, VERSION_HASH, getChainId(), address(this)));
361     }
362 
363     function burn(uint256 value) external override returns (bool) {
364         _burn(msg.sender, value);
365         return true;
366     }
367 
368     function approve(address spender, uint256 value) external override returns (bool) {
369         _approve(msg.sender, spender, value);
370         return true;
371     }
372 
373     function transfer(address to, uint256 value) external override returns (bool) {
374         _transfer(msg.sender, to, value);
375         return true;
376     }
377 
378     function transferFrom(
379         address from,
380         address to,
381         uint256 value
382     ) external override returns (bool) {
383         uint256 fromAllowance = allowance[from][msg.sender];
384         if (fromAllowance != uint256(-1)) {
385             // Allowance is implicitly checked with SafeMath's underflow protection
386             allowance[from][msg.sender] = fromAllowance.sub(value);
387         }
388         _transfer(from, to, value);
389         return true;
390     }
391 
392     function permit(
393         address owner,
394         address spender,
395         uint256 value,
396         uint256 deadline,
397         uint8 v,
398         bytes32 r,
399         bytes32 s
400     ) external {
401         require(deadline >= block.timestamp, "FLASH-ALT-LP Token:: AUTH_EXPIRED");
402 
403         bytes32 encodeData = keccak256(abi.encode(PERMIT_TYPEHASH, owner, spender, value, nonces[owner], deadline));
404         nonces[owner] = nonces[owner].add(1);
405         _validateSignedData(owner, encodeData, v, r, s);
406 
407         _approve(owner, spender, value);
408     }
409 
410     function transferWithAuthorization(
411         address from,
412         address to,
413         uint256 value,
414         uint256 validAfter,
415         uint256 validBefore,
416         bytes32 nonce,
417         uint8 v,
418         bytes32 r,
419         bytes32 s
420     ) external {
421         require(block.timestamp > validAfter, "FLASH-ALT-LP Token:: AUTH_NOT_YET_VALID");
422         require(block.timestamp < validBefore, "FLASH-ALT-LP Token:: AUTH_EXPIRED");
423         require(!authorizationState[from][nonce], "FLASH-ALT-LP Token:: AUTH_ALREADY_USED");
424 
425         bytes32 encodeData = keccak256(
426             abi.encode(TRANSFER_WITH_AUTHORIZATION_TYPEHASH, from, to, value, validAfter, validBefore, nonce)
427         );
428         _validateSignedData(from, encodeData, v, r, s);
429 
430         authorizationState[from][nonce] = true;
431         emit AuthorizationUsed(from, nonce);
432 
433         _transfer(from, to, value);
434     }
435 }
436 
437 // File: ../../../../media/shakeib98/xio-flashapp-contracts/contracts/pool/contracts/Pool.sol
438 
439 pragma solidity 0.6.12;
440 
441 
442 
443 
444 
445 
446 contract Pool is PoolERC20, IPool {
447     using SafeMath for uint256;
448 
449     uint256 public constant MINIMUM_LIQUIDITY = 10**3;
450     bytes4 private constant TRANSFER_SELECTOR = bytes4(keccak256(bytes("transfer(address,uint256)")));
451     address public constant FLASH_TOKEN = 0xB4467E8D621105312a914F1D42f10770C0Ffe3c8;
452     address public constant FLASH_PROTOCOL = 0xEc02f813404656E2A2AEd5BaeEd41D785324E8D0;
453 
454     uint256 public reserveFlashAmount;
455     uint256 public reserveAltAmount;
456     uint256 private unlocked = 1;
457 
458     address public token;
459     address public factory;
460 
461     modifier lock() {
462         require(unlocked == 1, "Pool: LOCKED");
463         unlocked = 0;
464         _;
465         unlocked = 1;
466     }
467 
468     modifier onlyFactory() {
469         require(msg.sender == factory, "Pool:: ONLY_FACTORY");
470         _;
471     }
472 
473     constructor() public {
474         factory = msg.sender;
475     }
476 
477     function _safeTransfer(
478         address _token,
479         address _to,
480         uint256 _value
481     ) private {
482         (bool success, bytes memory data) = _token.call(abi.encodeWithSelector(TRANSFER_SELECTOR, _to, _value));
483         require(success && (data.length == 0 || abi.decode(data, (bool))), "Pool:: TRANSFER_FAILED");
484     }
485 
486     function initialize(address _token) public override onlyFactory {
487         token = _token;
488     }
489 
490     function swapWithFeeRewardDistribution(
491         uint256 _amountIn,
492         address _staker,
493         uint256 _expectedOutput
494     ) public override lock onlyFactory returns (uint256 result) {
495         result = getAPYSwap(_amountIn);
496         require(_expectedOutput <= result, "Pool:: EXPECTED_IS_GREATER");
497         calcNewReserveSwap(_amountIn, result);
498         _safeTransfer(FLASH_TOKEN, _staker, result);
499     }
500 
501     function stakeWithFeeRewardDistribution(
502         uint256 _amountIn,
503         address _staker,
504         uint256 _expectedOutput
505     ) public override lock onlyFactory returns (uint256 result) {
506         result = getAPYStake(_amountIn);
507         require(_expectedOutput <= result, "Pool:: EXPECTED_IS_GREATER");
508         calcNewReserveStake(_amountIn, result);
509         _safeTransfer(token, _staker, result);
510     }
511 
512     function addLiquidity(
513         uint256 _amountFLASH,
514         uint256 _amountALT,
515         uint256 _amountFLASHMin,
516         uint256 _amountALTMin,
517         address _maker
518     )
519         public
520         override
521         onlyFactory
522         returns (
523             uint256 amountFLASH,
524             uint256 amountALT,
525             uint256 liquidity
526         )
527     {
528         (amountFLASH, amountALT) = _addLiquidity(_amountFLASH, _amountALT, _amountFLASHMin, _amountALTMin);
529         liquidity = mintLiquidityTokens(_maker, amountFLASH, amountALT);
530         calcNewReserveAddLiquidity(amountFLASH, amountALT);
531     }
532 
533     function removeLiquidity(address _maker)
534         public
535         override
536         onlyFactory
537         returns (uint256 amountFLASH, uint256 amountALT)
538     {
539         (amountFLASH, amountALT) = burn(_maker);
540     }
541 
542     function getAPYStake(uint256 _amountIn) public view returns (uint256 result) {
543         uint256 amountInWithFee = _amountIn.mul(getLPFee());
544         uint256 num = amountInWithFee.mul(reserveAltAmount);
545         uint256 den = (reserveFlashAmount.mul(1000)).add(amountInWithFee);
546         result = num.div(den);
547     }
548 
549     function getAPYSwap(uint256 _amountIn) public view returns (uint256 result) {
550         uint256 amountInWithFee = _amountIn.mul(getLPFee());
551         uint256 num = amountInWithFee.mul(reserveFlashAmount);
552         uint256 den = (reserveAltAmount.mul(1000)).add(amountInWithFee);
553         result = num.div(den);
554     }
555 
556     function getLPFee() public view returns (uint256) {
557         uint256 fpy = IFlashProtocol(FLASH_PROTOCOL).getFPY(0);
558         return uint256(1000).sub(fpy.div(5e15));
559     }
560 
561     function quote(
562         uint256 _amountA,
563         uint256 _reserveA,
564         uint256 _reserveB
565     ) public pure returns (uint256 amountB) {
566         require(_amountA > 0, "Pool:: INSUFFICIENT_AMOUNT");
567         require(_reserveA > 0 && _reserveB > 0, "Pool:: INSUFFICIENT_LIQUIDITY");
568         amountB = _amountA.mul(_reserveB).div(_reserveA);
569     }
570 
571     function burn(address to) private lock returns (uint256 amountFLASH, uint256 amountALT) {
572         uint256 balanceFLASH = IERC20(FLASH_TOKEN).balanceOf(address(this));
573         uint256 balanceALT = IERC20(token).balanceOf(address(this));
574         uint256 liquidity = balanceOf[address(this)];
575 
576         amountFLASH = liquidity.mul(balanceFLASH) / totalSupply;
577         amountALT = liquidity.mul(balanceALT) / totalSupply;
578 
579         require(amountFLASH > 0 && amountALT > 0, "Pool:: INSUFFICIENT_LIQUIDITY_BURNED");
580 
581         _burn(address(this), liquidity);
582 
583         _safeTransfer(FLASH_TOKEN, to, amountFLASH);
584         _safeTransfer(token, to, amountALT);
585 
586         balanceFLASH = balanceFLASH.sub(IERC20(FLASH_TOKEN).balanceOf(address(this)));
587         balanceALT = balanceALT.sub(IERC20(token).balanceOf(address(this)));
588 
589         calcNewReserveRemoveLiquidity(balanceFLASH, balanceALT);
590     }
591 
592     function _addLiquidity(
593         uint256 _amountFLASH,
594         uint256 _amountALT,
595         uint256 _amountFLASHMin,
596         uint256 _amountALTMin
597     ) private view returns (uint256 amountFLASH, uint256 amountALT) {
598         if (reserveAltAmount == 0 && reserveFlashAmount == 0) {
599             (amountFLASH, amountALT) = (_amountFLASH, _amountALT);
600         } else {
601             uint256 amountALTQuote = quote(_amountFLASH, reserveFlashAmount, reserveAltAmount);
602             if (amountALTQuote <= _amountALT) {
603                 require(amountALTQuote >= _amountALTMin, "Pool:: INSUFFICIENT_B_AMOUNT");
604                 (amountFLASH, amountALT) = (_amountFLASH, amountALTQuote);
605             } else {
606                 uint256 amountFLASHQuote = quote(_amountALT, reserveAltAmount, reserveFlashAmount);
607                 require(
608                     (amountFLASHQuote <= _amountFLASH) && (amountFLASHQuote >= _amountFLASHMin),
609                     "Pool:: INSUFFICIENT_A_AMOUNT"
610                 );
611                 (amountFLASH, amountALT) = (amountFLASHQuote, _amountALT);
612             }
613         }
614     }
615 
616     function mintLiquidityTokens(
617         address _to,
618         uint256 _flashAmount,
619         uint256 _altAmount
620     ) private returns (uint256 liquidity) {
621         if (totalSupply == 0) {
622             liquidity = SafeMath.sqrt(_flashAmount.mul(_altAmount)).sub(MINIMUM_LIQUIDITY);
623             _mint(address(0), MINIMUM_LIQUIDITY);
624         } else {
625             liquidity = SafeMath.min(
626                 _flashAmount.mul(totalSupply) / reserveFlashAmount,
627                 _altAmount.mul(totalSupply) / reserveAltAmount
628             );
629         }
630         require(liquidity > 0, "Pool:: INSUFFICIENT_LIQUIDITY_MINTED");
631         _mint(_to, liquidity);
632     }
633 
634     function calcNewReserveStake(uint256 _amountIn, uint256 _amountOut) private {
635         reserveFlashAmount = reserveFlashAmount.add(_amountIn);
636         reserveAltAmount = reserveAltAmount.sub(_amountOut);
637     }
638 
639     function calcNewReserveSwap(uint256 _amountIn, uint256 _amountOut) private {
640         reserveFlashAmount = reserveFlashAmount.sub(_amountOut);
641         reserveAltAmount = reserveAltAmount.add(_amountIn);
642     }
643 
644     function calcNewReserveAddLiquidity(uint256 _amountFLASH, uint256 _amountALT) private {
645         reserveFlashAmount = reserveFlashAmount.add(_amountFLASH);
646         reserveAltAmount = reserveAltAmount.add(_amountALT);
647     }
648 
649     function calcNewReserveRemoveLiquidity(uint256 _amountFLASH, uint256 _amountALT) private {
650         reserveFlashAmount = reserveFlashAmount.sub(_amountFLASH);
651         reserveAltAmount = reserveAltAmount.sub(_amountALT);
652     }
653 }
654 
655 
656 pragma solidity 0.6.12;
657 
658 
659 
660 
661 
662 
663 
664 
665 
666 contract FlashApp is IFlashReceiver {
667     using SafeMath for uint256;
668 
669     address public constant FLASH_TOKEN = 0xB4467E8D621105312a914F1D42f10770C0Ffe3c8;
670     address public constant FLASH_PROTOCOL = 0xEc02f813404656E2A2AEd5BaeEd41D785324E8D0;
671 
672     mapping(bytes32 => uint256) public stakerReward;
673     mapping(address => address) public pools; // token -> pools
674 
675     event PoolCreated(address _pool, address _token);
676 
677     event Staked(bytes32 _id, uint256 _rewardAmount, address _pool);
678 
679     event LiquidityAdded(address _pool, uint256 _amountFLASH, uint256 _amountALT, uint256 _liquidity, address _sender);
680 
681     event LiquidityRemoved(
682         address _pool,
683         uint256 _amountFLASH,
684         uint256 _amountALT,
685         uint256 _liquidity,
686         address _sender
687     );
688 
689     event Swapped(address _sender, uint256 _swapAmount, uint256 _flashReceived, address _pool);
690 
691     modifier onlyProtocol() {
692         require(msg.sender == FLASH_PROTOCOL, "FlashApp:: ONLY_PROTOCOL");
693         _;
694     }
695 
696     function createPool(address _token) external returns (address poolAddress) {
697         require(_token != address(0), "FlashApp:: INVALID_TOKEN_ADDRESS");
698         require(pools[_token] == address(0), "FlashApp:: POOL_ALREADY_EXISTS");
699         bytes memory bytecode = type(Pool).creationCode;
700         bytes32 salt = keccak256(abi.encodePacked(block.timestamp, msg.sender));
701         poolAddress = Create2.deploy(0, salt, bytecode);
702         pools[_token] = poolAddress;
703         IPool(poolAddress).initialize(_token);
704         emit PoolCreated(poolAddress, _token);
705     }
706 
707     function receiveFlash(
708         bytes32 _id,
709         uint256 _amountIn, //unused
710         uint256 _expireAfter, //unused
711         uint256 _mintedAmount,
712         address _staker,
713         bytes calldata _data
714     ) external override onlyProtocol returns (uint256) {
715         (address token, uint256 expectedOutput) = abi.decode(_data, (address, uint256));
716         address pool = pools[token];
717         IERC20(FLASH_TOKEN).transfer(pool, _mintedAmount);
718         uint256 reward = IPool(pool).stakeWithFeeRewardDistribution(_mintedAmount, _staker, expectedOutput);
719         stakerReward[_id] = reward;
720         emit Staked(_id, reward, pool);
721     }
722 
723     function unstake(bytes32[] memory _expiredIds) public {
724         for (uint256 i = 0; i < _expiredIds.length; i = i.add(1)) {
725             IFlashProtocol(FLASH_PROTOCOL).unstake(_expiredIds[i]);
726         }
727     }
728 
729     function swap(
730         uint256 _altQuantity,
731         address _token,
732         uint256 _expectedOutput
733     ) public returns (uint256 result) {
734         address user = msg.sender;
735         address pool = pools[_token];
736 
737         require(pool != address(0), "FlashApp:: POOL_DOESNT_EXIST");
738         require(_altQuantity > 0, "FlashApp:: INVALID_AMOUNT");
739 
740         IERC20(_token).transferFrom(user, address(this), _altQuantity);
741         IERC20(_token).transfer(pool, _altQuantity);
742 
743         result = IPool(pool).swapWithFeeRewardDistribution(_altQuantity, user, _expectedOutput);
744 
745         emit Swapped(user, _altQuantity, result, pool);
746     }
747 
748     function addLiquidityInPool(
749         uint256 _amountFLASH,
750         uint256 _amountALT,
751         uint256 _amountFLASHMin,
752         uint256 _amountALTMin,
753         address _token
754     ) public {
755         address maker = msg.sender;
756         address pool = pools[_token];
757 
758         require(pool != address(0), "FlashApp:: POOL_DOESNT_EXIST");
759         require(_amountFLASH > 0 && _amountALT > 0, "FlashApp:: INVALID_AMOUNT");
760 
761         (uint256 amountFLASH, uint256 amountALT, uint256 liquidity) = IPool(pool).addLiquidity(
762             _amountFLASH,
763             _amountALT,
764             _amountFLASHMin,
765             _amountALTMin,
766             maker
767         );
768 
769         IERC20(FLASH_TOKEN).transferFrom(maker, address(this), amountFLASH);
770         IERC20(FLASH_TOKEN).transfer(pool, amountFLASH);
771         IERC20(_token).transferFrom(maker, address(this), amountALT);
772         IERC20(_token).transfer(pool, amountALT);
773 
774         emit LiquidityAdded(pool, amountFLASH, amountALT, liquidity, maker);
775     }
776 
777     function removeLiquidityInPool(uint256 _liquidity, address _token) public {
778         address maker = msg.sender;
779 
780         address pool = pools[_token];
781 
782         require(pool != address(0), "FlashApp:: POOL_DOESNT_EXIST");
783 
784         IERC20(pool).transferFrom(maker, address(this), _liquidity);
785         IERC20(pool).transfer(pool, _liquidity);
786 
787         (uint256 amountFLASH, uint256 amountALT) = IPool(pool).removeLiquidity(maker);
788 
789         emit LiquidityRemoved(pool, amountFLASH, amountALT, _liquidity, maker);
790     }
791 }