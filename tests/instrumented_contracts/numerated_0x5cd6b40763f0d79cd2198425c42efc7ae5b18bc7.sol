1 // File: contracts/interfaces/IWeth.sol
2 
3 pragma solidity ^0.6.10;
4 
5 
6 interface IWeth {
7     function deposit() external payable;
8     function withdraw(uint) external;
9     function approve(address, uint) external returns (bool) ;
10     function transfer(address, uint) external returns (bool);
11     function transferFrom(address, address, uint) external returns (bool);
12 }
13 
14 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
15 
16 
17 pragma solidity ^0.6.0;
18 
19 /**
20  * @dev Interface of the ERC20 standard as defined in the EIP.
21  */
22 interface IERC20 {
23     /**
24      * @dev Returns the amount of tokens in existence.
25      */
26     function totalSupply() external view returns (uint256);
27 
28     /**
29      * @dev Returns the amount of tokens owned by `account`.
30      */
31     function balanceOf(address account) external view returns (uint256);
32 
33     /**
34      * @dev Moves `amount` tokens from the caller's account to `recipient`.
35      *
36      * Returns a boolean value indicating whether the operation succeeded.
37      *
38      * Emits a {Transfer} event.
39      */
40     function transfer(address recipient, uint256 amount) external returns (bool);
41 
42     /**
43      * @dev Returns the remaining number of tokens that `spender` will be
44      * allowed to spend on behalf of `owner` through {transferFrom}. This is
45      * zero by default.
46      *
47      * This value changes when {approve} or {transferFrom} are called.
48      */
49     function allowance(address owner, address spender) external view returns (uint256);
50 
51     /**
52      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
53      *
54      * Returns a boolean value indicating whether the operation succeeded.
55      *
56      * IMPORTANT: Beware that changing an allowance with this method brings the risk
57      * that someone may use both the old and the new allowance by unfortunate
58      * transaction ordering. One possible solution to mitigate this race
59      * condition is to first reduce the spender's allowance to 0 and set the
60      * desired value afterwards:
61      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
62      *
63      * Emits an {Approval} event.
64      */
65     function approve(address spender, uint256 amount) external returns (bool);
66 
67     /**
68      * @dev Moves `amount` tokens from `sender` to `recipient` using the
69      * allowance mechanism. `amount` is then deducted from the caller's
70      * allowance.
71      *
72      * Returns a boolean value indicating whether the operation succeeded.
73      *
74      * Emits a {Transfer} event.
75      */
76     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
77 
78     /**
79      * @dev Emitted when `value` tokens are moved from one account (`from`) to
80      * another (`to`).
81      *
82      * Note that `value` may be zero.
83      */
84     event Transfer(address indexed from, address indexed to, uint256 value);
85 
86     /**
87      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
88      * a call to {approve}. `value` is the new allowance.
89      */
90     event Approval(address indexed owner, address indexed spender, uint256 value);
91 }
92 
93 // File: contracts/interfaces/IDai.sol
94 
95 pragma solidity ^0.6.10;
96 
97 
98 interface IDai is IERC20 {
99     function nonces(address user) external view returns (uint256);
100     function permit(address holder, address spender, uint256 nonce, uint256 expiry,
101                     bool allowed, uint8 v, bytes32 r, bytes32 s) external;
102 }
103 
104 // File: contracts/interfaces/IGemJoin.sol
105 
106 pragma solidity ^0.6.10;
107 
108 
109 /// @dev Interface to interact with the `Join.sol` contract from MakerDAO using ERC20
110 interface IGemJoin {
111     function rely(address usr) external;
112     function deny(address usr) external;
113     function cage() external;
114     function join(address usr, uint WAD) external;
115     function exit(address usr, uint WAD) external;
116 }
117 
118 // File: contracts/interfaces/IDaiJoin.sol
119 
120 pragma solidity ^0.6.10;
121 
122 
123 /// @dev Interface to interact with the `Join.sol` contract from MakerDAO using Dai
124 interface IDaiJoin {
125     function rely(address usr) external;
126     function deny(address usr) external;
127     function cage() external;
128     function join(address usr, uint WAD) external;
129     function exit(address usr, uint WAD) external;
130 }
131 
132 // File: contracts/interfaces/IVat.sol
133 
134 pragma solidity ^0.6.10;
135 
136 
137 /// @dev Interface to interact with the vat contract from MakerDAO
138 /// Taken from https://github.com/makerdao/developerguides/blob/master/devtools/working-with-dsproxy/working-with-dsproxy.md
139 interface IVat {
140     // function can(address, address) external view returns (uint);
141     function hope(address) external;
142     function nope(address) external;
143     function live() external view returns (uint);
144     function ilks(bytes32) external view returns (uint, uint, uint, uint, uint);
145     function urns(bytes32, address) external view returns (uint, uint);
146     function gem(bytes32, address) external view returns (uint);
147     // function dai(address) external view returns (uint);
148     function frob(bytes32, address, address, address, int, int) external;
149     function fork(bytes32, address, address, int, int) external;
150     function move(address, address, uint) external;
151     function flux(bytes32, address, address, uint) external;
152 }
153 
154 // File: contracts/interfaces/IPot.sol
155 
156 pragma solidity ^0.6.10;
157 
158 
159 /// @dev interface for the pot contract from MakerDao
160 /// Taken from https://github.com/makerdao/developerguides/blob/master/dai/dsr-integration-guide/dsr.sol
161 interface IPot {
162     function chi() external view returns (uint256);
163     function pie(address) external view returns (uint256); // Not a function, but a public variable.
164     function rho() external returns (uint256);
165     function drip() external returns (uint256);
166     function join(uint256) external;
167     function exit(uint256) external;
168 }
169 
170 // File: contracts/interfaces/IDelegable.sol
171 
172 pragma solidity ^0.6.10;
173 
174 
175 interface IDelegable {
176     function addDelegate(address) external;
177     function addDelegateBySignature(address, address, uint, uint8, bytes32, bytes32) external;
178 }
179 
180 // File: contracts/interfaces/IERC2612.sol
181 
182 // Code adapted from https://github.com/OpenZeppelin/openzeppelin-contracts/pull/2237/
183 pragma solidity ^0.6.0;
184 
185 /**
186  * @dev Interface of the ERC2612 standard as defined in the EIP.
187  *
188  * Adds the {permit} method, which can be used to change one's
189  * {IERC20-allowance} without having to send a transaction, by signing a
190  * message. This allows users to spend tokens without having to hold Ether.
191  *
192  * See https://eips.ethereum.org/EIPS/eip-2612.
193  */
194 interface IERC2612 {
195     /**
196      * @dev Sets `amount` as the allowance of `spender` over `owner`'s tokens,
197      * given `owner`'s signed approval.
198      *
199      * IMPORTANT: The same issues {IERC20-approve} has related to transaction
200      * ordering also apply here.
201      *
202      * Emits an {Approval} event.
203      *
204      * Requirements:
205      *
206      * - `owner` cannot be the zero address.
207      * - `spender` cannot be the zero address.
208      * - `deadline` must be a timestamp in the future.
209      * - `v`, `r` and `s` must be a valid `secp256k1` signature from `owner`
210      * over the EIP712-formatted function arguments.
211      * - the signature must use ``owner``'s current nonce (see {nonces}).
212      *
213      * For more information on the signature format, see the
214      * https://eips.ethereum.org/EIPS/eip-2612#specification[relevant EIP
215      * section].
216      */
217     function permit(address owner, address spender, uint256 amount, uint256 deadline, uint8 v, bytes32 r, bytes32 s) external;
218 
219     /**
220      * @dev Returns the current ERC2612 nonce for `owner`. This value must be
221      * included whenever a signature is generated for {permit}.
222      *
223      * Every successful call to {permit} increases ``owner``'s nonce by one. This
224      * prevents a signature from being used multiple times.
225      */
226     function nonces(address owner) external view returns (uint256);
227 }
228 
229 // File: contracts/interfaces/IFYDai.sol
230 
231 pragma solidity ^0.6.10;
232 
233 
234 
235 interface IFYDai is IERC20, IERC2612 {
236     function isMature() external view returns(bool);
237     function maturity() external view returns(uint);
238     function chi0() external view returns(uint);
239     function rate0() external view returns(uint);
240     function chiGrowth() external view returns(uint);
241     function rateGrowth() external view returns(uint);
242     function mature() external;
243     function unlocked() external view returns (uint);
244     function mint(address, uint) external;
245     function burn(address, uint) external;
246     function flashMint(uint, bytes calldata) external;
247     function redeem(address, address, uint256) external returns (uint256);
248     // function transfer(address, uint) external returns (bool);
249     // function transferFrom(address, address, uint) external returns (bool);
250     // function approve(address, uint) external returns (bool);
251 }
252 
253 // File: contracts/interfaces/IPool.sol
254 
255 pragma solidity ^0.6.10;
256 
257 
258 
259 
260 
261 interface IPool is IDelegable, IERC20, IERC2612 {
262     function dai() external view returns(IERC20);
263     function fyDai() external view returns(IFYDai);
264     function getDaiReserves() external view returns(uint128);
265     function getFYDaiReserves() external view returns(uint128);
266     function sellDai(address from, address to, uint128 daiIn) external returns(uint128);
267     function buyDai(address from, address to, uint128 daiOut) external returns(uint128);
268     function sellFYDai(address from, address to, uint128 fyDaiIn) external returns(uint128);
269     function buyFYDai(address from, address to, uint128 fyDaiOut) external returns(uint128);
270     function sellDaiPreview(uint128 daiIn) external view returns(uint128);
271     function buyDaiPreview(uint128 daiOut) external view returns(uint128);
272     function sellFYDaiPreview(uint128 fyDaiIn) external view returns(uint128);
273     function buyFYDaiPreview(uint128 fyDaiOut) external view returns(uint128);
274     function mint(address from, address to, uint256 daiOffered) external returns (uint256);
275     function burn(address from, address to, uint256 tokensBurned) external returns (uint256, uint256);
276 }
277 
278 // File: contracts/interfaces/IChai.sol
279 
280 pragma solidity ^0.6.10;
281 
282 
283 /// @dev interface for the chai contract
284 /// Taken from https://github.com/makerdao/developerguides/blob/master/dai/dsr-integration-guide/dsr.sol
285 interface IChai {
286     function balanceOf(address account) external view returns (uint256);
287     function transfer(address dst, uint wad) external returns (bool);
288     function move(address src, address dst, uint wad) external returns (bool);
289     function transferFrom(address src, address dst, uint wad) external returns (bool);
290     function approve(address usr, uint wad) external returns (bool);
291     function dai(address usr) external returns (uint wad);
292     function join(address dst, uint wad) external;
293     function exit(address src, uint wad) external;
294     function draw(address src, uint wad) external;
295     function permit(address holder, address spender, uint256 nonce, uint256 expiry, bool allowed, uint8 v, bytes32 r, bytes32 s) external;
296     function nonces(address account) external view returns (uint256);
297 }
298 
299 // File: contracts/interfaces/ITreasury.sol
300 
301 pragma solidity ^0.6.10;
302 
303 
304 
305 
306 
307 
308 
309 
310 interface ITreasury {
311     function debt() external view returns(uint256);
312     function savings() external view returns(uint256);
313     function pushDai(address user, uint256 dai) external;
314     function pullDai(address user, uint256 dai) external;
315     function pushChai(address user, uint256 chai) external;
316     function pullChai(address user, uint256 chai) external;
317     function pushWeth(address to, uint256 weth) external;
318     function pullWeth(address to, uint256 weth) external;
319     function shutdown() external;
320     function live() external view returns(bool);
321 
322     function vat() external view returns (IVat);
323     function weth() external view returns (IWeth);
324     function dai() external view returns (IERC20);
325     function daiJoin() external view returns (IDaiJoin);
326     function wethJoin() external view returns (IGemJoin);
327     function pot() external view returns (IPot);
328     function chai() external view returns (IChai);
329 }
330 
331 // File: @openzeppelin/contracts/math/SafeMath.sol
332 
333 
334 pragma solidity ^0.6.0;
335 
336 /**
337  * @dev Wrappers over Solidity's arithmetic operations with added overflow
338  * checks.
339  *
340  * Arithmetic operations in Solidity wrap on overflow. This can easily result
341  * in bugs, because programmers usually assume that an overflow raises an
342  * error, which is the standard behavior in high level programming languages.
343  * `SafeMath` restores this intuition by reverting the transaction when an
344  * operation overflows.
345  *
346  * Using this library instead of the unchecked operations eliminates an entire
347  * class of bugs, so it's recommended to use it always.
348  */
349 library SafeMath {
350     /**
351      * @dev Returns the addition of two unsigned integers, reverting on
352      * overflow.
353      *
354      * Counterpart to Solidity's `+` operator.
355      *
356      * Requirements:
357      *
358      * - Addition cannot overflow.
359      */
360     function add(uint256 a, uint256 b) internal pure returns (uint256) {
361         uint256 c = a + b;
362         require(c >= a, "SafeMath: addition overflow");
363 
364         return c;
365     }
366 
367     /**
368      * @dev Returns the subtraction of two unsigned integers, reverting on
369      * overflow (when the result is negative).
370      *
371      * Counterpart to Solidity's `-` operator.
372      *
373      * Requirements:
374      *
375      * - Subtraction cannot overflow.
376      */
377     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
378         return sub(a, b, "SafeMath: subtraction overflow");
379     }
380 
381     /**
382      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
383      * overflow (when the result is negative).
384      *
385      * Counterpart to Solidity's `-` operator.
386      *
387      * Requirements:
388      *
389      * - Subtraction cannot overflow.
390      */
391     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
392         require(b <= a, errorMessage);
393         uint256 c = a - b;
394 
395         return c;
396     }
397 
398     /**
399      * @dev Returns the multiplication of two unsigned integers, reverting on
400      * overflow.
401      *
402      * Counterpart to Solidity's `*` operator.
403      *
404      * Requirements:
405      *
406      * - Multiplication cannot overflow.
407      */
408     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
409         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
410         // benefit is lost if 'b' is also tested.
411         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
412         if (a == 0) {
413             return 0;
414         }
415 
416         uint256 c = a * b;
417         require(c / a == b, "SafeMath: multiplication overflow");
418 
419         return c;
420     }
421 
422     /**
423      * @dev Returns the integer division of two unsigned integers. Reverts on
424      * division by zero. The result is rounded towards zero.
425      *
426      * Counterpart to Solidity's `/` operator. Note: this function uses a
427      * `revert` opcode (which leaves remaining gas untouched) while Solidity
428      * uses an invalid opcode to revert (consuming all remaining gas).
429      *
430      * Requirements:
431      *
432      * - The divisor cannot be zero.
433      */
434     function div(uint256 a, uint256 b) internal pure returns (uint256) {
435         return div(a, b, "SafeMath: division by zero");
436     }
437 
438     /**
439      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
440      * division by zero. The result is rounded towards zero.
441      *
442      * Counterpart to Solidity's `/` operator. Note: this function uses a
443      * `revert` opcode (which leaves remaining gas untouched) while Solidity
444      * uses an invalid opcode to revert (consuming all remaining gas).
445      *
446      * Requirements:
447      *
448      * - The divisor cannot be zero.
449      */
450     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
451         require(b > 0, errorMessage);
452         uint256 c = a / b;
453         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
454 
455         return c;
456     }
457 
458     /**
459      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
460      * Reverts when dividing by zero.
461      *
462      * Counterpart to Solidity's `%` operator. This function uses a `revert`
463      * opcode (which leaves remaining gas untouched) while Solidity uses an
464      * invalid opcode to revert (consuming all remaining gas).
465      *
466      * Requirements:
467      *
468      * - The divisor cannot be zero.
469      */
470     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
471         return mod(a, b, "SafeMath: modulo by zero");
472     }
473 
474     /**
475      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
476      * Reverts with custom message when dividing by zero.
477      *
478      * Counterpart to Solidity's `%` operator. This function uses a `revert`
479      * opcode (which leaves remaining gas untouched) while Solidity uses an
480      * invalid opcode to revert (consuming all remaining gas).
481      *
482      * Requirements:
483      *
484      * - The divisor cannot be zero.
485      */
486     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
487         require(b != 0, errorMessage);
488         return a % b;
489     }
490 }
491 
492 // File: contracts/helpers/DecimalMath.sol
493 
494 pragma solidity ^0.6.10;
495 
496 
497 
498 /// @dev Implements simple fixed point math mul and div operations for 27 decimals.
499 contract DecimalMath {
500     using SafeMath for uint256;
501 
502     uint256 constant public UNIT = 1e27;
503 
504     /// @dev Multiplies x and y, assuming they are both fixed point with 27 digits.
505     function muld(uint256 x, uint256 y) internal pure returns (uint256) {
506         return x.mul(y).div(UNIT);
507     }
508 
509     /// @dev Divides x between y, assuming they are both fixed point with 27 digits.
510     function divd(uint256 x, uint256 y) internal pure returns (uint256) {
511         return x.mul(UNIT).div(y);
512     }
513 
514     /// @dev Multiplies x and y, rounding up to the closest representable number.
515     /// Assumes x and y are both fixed point with `decimals` digits.
516     function muldrup(uint256 x, uint256 y) internal pure returns (uint256)
517     {
518         uint256 z = x.mul(y);
519         return z.mod(UNIT) == 0 ? z.div(UNIT) : z.div(UNIT).add(1);
520     }
521 
522     /// @dev Divides x between y, rounding up to the closest representable number.
523     /// Assumes x and y are both fixed point with `decimals` digits.
524     function divdrup(uint256 x, uint256 y) internal pure returns (uint256)
525     {
526         uint256 z = x.mul(UNIT);
527         return z.mod(y) == 0 ? z.div(y) : z.div(y).add(1);
528     }
529 }
530 
531 // File: contracts/peripheral/YieldProxy.sol
532 
533 pragma solidity ^0.6.10;
534 
535 
536 
537 
538 
539 
540 
541 
542 
543 
544 
545 
546 
547 
548 interface ControllerLike is IDelegable {
549     function treasury() external view returns (ITreasury);
550     function series(uint256) external view returns (IFYDai);
551     function seriesIterator(uint256) external view returns (uint256);
552     function totalSeries() external view returns (uint256);
553     function containsSeries(uint256) external view returns (bool);
554     function posted(bytes32, address) external view returns (uint256);
555     function locked(bytes32, address) external view returns (uint256);
556     function debtFYDai(bytes32, uint256, address) external view returns (uint256);
557     function debtDai(bytes32, uint256, address) external view returns (uint256);
558     function totalDebtDai(bytes32, address) external view returns (uint256);
559     function isCollateralized(bytes32, address) external view returns (bool);
560     function inDai(bytes32, uint256, uint256) external view returns (uint256);
561     function inFYDai(bytes32, uint256, uint256) external view returns (uint256);
562     function erase(bytes32, address) external returns (uint256, uint256);
563     function shutdown() external;
564     function post(bytes32, address, address, uint256) external;
565     function withdraw(bytes32, address, address, uint256) external;
566     function borrow(bytes32, uint256, address, address, uint256) external;
567     function repayFYDai(bytes32, uint256, address, address, uint256) external returns (uint256);
568     function repayDai(bytes32, uint256, address, address, uint256) external returns (uint256);
569 }
570 
571 library SafeCast {
572     /// @dev Safe casting from uint256 to uint128
573     function toUint128(uint256 x) internal pure returns(uint128) {
574         require(
575             x <= type(uint128).max,
576             "YieldProxy: Cast overflow"
577         );
578         return uint128(x);
579     }
580 
581     /// @dev Safe casting from uint256 to int256
582     function toInt256(uint256 x) internal pure returns(int256) {
583         require(
584             x <= uint256(type(int256).max),
585             "YieldProxy: Cast overflow"
586         );
587         return int256(x);
588     }
589 }
590 
591 contract YieldProxy is DecimalMath {
592     using SafeCast for uint256;
593 
594     IVat public vat;
595     IWeth public weth;
596     IDai public dai;
597     IGemJoin public wethJoin;
598     IDaiJoin public daiJoin;
599     IChai public chai;
600     ControllerLike public controller;
601     ITreasury public treasury;
602 
603     IPool[] public pools;
604     mapping (address => bool) public poolsMap;
605 
606     bytes32 public constant CHAI = "CHAI";
607     bytes32 public constant WETH = "ETH-A";
608     bool constant public MTY = true;
609     bool constant public YTM = false;
610 
611 
612     constructor(address controller_, IPool[] memory _pools) public {
613         controller = ControllerLike(controller_);
614         treasury = controller.treasury();
615 
616         weth = treasury.weth();
617         dai = IDai(address(treasury.dai()));
618         chai = treasury.chai();
619         daiJoin = treasury.daiJoin();
620         wethJoin = treasury.wethJoin();
621         vat = treasury.vat();
622 
623         // for repaying debt
624         dai.approve(address(treasury), uint(-1));
625 
626         // for posting to the controller
627         chai.approve(address(treasury), uint(-1));
628         weth.approve(address(treasury), uint(-1));
629 
630         // for converting DAI to CHAI
631         dai.approve(address(chai), uint(-1));
632 
633         vat.hope(address(daiJoin));
634         vat.hope(address(wethJoin));
635 
636         dai.approve(address(daiJoin), uint(-1));
637         weth.approve(address(wethJoin), uint(-1));
638         weth.approve(address(treasury), uint(-1));
639 
640         // allow all the pools to pull FYDai/dai from us for LPing
641         for (uint i = 0 ; i < _pools.length; i++) {
642             dai.approve(address(_pools[i]), uint(-1));
643             _pools[i].fyDai().approve(address(_pools[i]), uint(-1));
644             poolsMap[address(_pools[i])]= true;
645         }
646 
647         pools = _pools;
648     }
649 
650     /// @dev Unpack r, s and v from a `bytes` signature
651     function unpack(bytes memory signature) private pure returns (bytes32 r, bytes32 s, uint8 v) {
652         assembly {
653             r := mload(add(signature, 0x20))
654             s := mload(add(signature, 0x40))
655             v := byte(0, mload(add(signature, 0x60)))
656         }
657     }
658 
659     /// @dev Performs the initial onboarding of the user. It `permit`'s DAI to be used by the proxy, and adds the proxy as a delegate in the controller
660     function onboard(address from, bytes memory daiSignature, bytes memory controllerSig) external {
661         bytes32 r;
662         bytes32 s;
663         uint8 v;
664 
665         (r, s, v) = unpack(daiSignature);
666         dai.permit(from, address(this), dai.nonces(from), uint(-1), true, v, r, s);
667 
668         (r, s, v) = unpack(controllerSig);
669         controller.addDelegateBySignature(from, address(this), uint(-1), v, r, s);
670     }
671 
672     /// @dev Given a pool and 3 signatures, it `permit`'s dai and fyDai for that pool and adds it as a delegate
673     function authorizePool(IPool pool, address from, bytes memory daiSig, bytes memory fyDaiSig, bytes memory poolSig) public {
674         onlyKnownPool(pool);
675         bytes32 r;
676         bytes32 s;
677         uint8 v;
678 
679         (r, s, v) = unpack(daiSig);
680         dai.permit(from, address(pool), dai.nonces(from), uint(-1), true, v, r, s);
681 
682         (r, s, v) = unpack(fyDaiSig);
683         pool.fyDai().permit(from, address(this), uint(-1), uint(-1), v, r, s);
684 
685         (r, s, v) = unpack(poolSig);
686         pool.addDelegateBySignature(from, address(this), uint(-1), v, r, s);
687     }
688 
689     /// @dev The WETH9 contract will send ether to YieldProxy on `weth.withdraw` using this function.
690     receive() external payable { }
691 
692     /// @dev Users use `post` in YieldProxy to post ETH to the Controller (amount = msg.value), which will be converted to Weth here.
693     /// @param to Yield Vault to deposit collateral in.
694     function post(address to)
695         public payable {
696         weth.deposit{ value: msg.value }();
697         controller.post(WETH, address(this), to, msg.value);
698     }
699 
700     /// @dev Users wishing to withdraw their Weth as ETH from the Controller should use this function.
701     /// Users must have called `controller.addDelegate(yieldProxy.address)` to authorize YieldProxy to act in their behalf.
702     /// @param to Wallet to send Eth to.
703     /// @param amount Amount of weth to move.
704     function withdraw(address payable to, uint256 amount)
705         public {
706         controller.withdraw(WETH, msg.sender, address(this), amount);
707         weth.withdraw(amount);
708         to.transfer(amount);
709     }
710 
711     /// @dev Mints liquidity with provided Dai by borrowing fyDai with some of the Dai.
712     /// Caller must have approved the proxy using`controller.addDelegate(yieldProxy)`
713     /// Caller must have approved the dai transfer with `dai.approve(daiUsed)`
714     /// @param daiUsed amount of Dai to use to mint liquidity. 
715     /// @param maxFYDai maximum amount of fyDai to be borrowed to mint liquidity. 
716     /// @return The amount of liquidity tokens minted.  
717     function addLiquidity(IPool pool, uint256 daiUsed, uint256 maxFYDai) external returns (uint256) {
718         onlyKnownPool(pool);
719         IFYDai fyDai = pool.fyDai();
720         require(fyDai.isMature() != true, "YieldProxy: Only before maturity");
721         require(dai.transferFrom(msg.sender, address(this), daiUsed), "YieldProxy: Transfer Failed");
722 
723         // calculate needed fyDai
724         uint256 daiReserves = dai.balanceOf(address(pool));
725         uint256 fyDaiReserves = fyDai.balanceOf(address(pool));
726         uint256 daiToAdd = daiUsed.mul(daiReserves).div(fyDaiReserves.add(daiReserves));
727         uint256 daiToConvert = daiUsed.sub(daiToAdd);
728         require(
729             daiToConvert <= maxFYDai,
730             "YieldProxy: maxFYDai exceeded"
731         ); // 1 Dai == 1 fyDai
732 
733         // convert dai to chai and borrow needed fyDai
734         chai.join(address(this), daiToConvert);
735         // look at the balance of chai in dai to avoid rounding issues
736         uint256 toBorrow = chai.dai(address(this));
737         controller.post(CHAI, address(this), msg.sender, chai.balanceOf(address(this)));
738         controller.borrow(CHAI, fyDai.maturity(), msg.sender, address(this), toBorrow);
739         
740         // mint liquidity tokens
741         return pool.mint(address(this), msg.sender, daiToAdd);
742     }
743 
744     /// @dev Burns tokens and sells Dai proceedings for fyDai. Pays as much debt as possible, then sells back any remaining fyDai for Dai. Then returns all Dai, and if there is no debt in the Controller, all posted Chai.
745     /// Caller must have approved the proxy using`controller.addDelegate(yieldProxy)` and `pool.addDelegate(yieldProxy)`
746     /// Caller must have approved the liquidity burn with `pool.approve(poolTokens)`
747     /// @param poolTokens amount of pool tokens to burn. 
748     /// @param minimumDaiPrice minimum fyDai/Dai price to be accepted when internally selling Dai.
749     /// @param minimumFYDaiPrice minimum Dai/fyDai price to be accepted when internally selling fyDai.
750     function removeLiquidityEarlyDaiPool(IPool pool, uint256 poolTokens, uint256 minimumDaiPrice, uint256 minimumFYDaiPrice) external {
751         onlyKnownPool(pool);
752         IFYDai fyDai = pool.fyDai();
753         uint256 maturity = fyDai.maturity();
754         (uint256 daiObtained, uint256 fyDaiObtained) = pool.burn(msg.sender, address(this), poolTokens);
755 
756         // Exchange Dai for fyDai to pay as much debt as possible
757         uint256 fyDaiBought = pool.sellDai(address(this), address(this), daiObtained.toUint128());
758         require(
759             fyDaiBought >= muld(daiObtained, minimumDaiPrice),
760             "YieldProxy: minimumDaiPrice not reached"
761         );
762         fyDaiObtained = fyDaiObtained.add(fyDaiBought);
763         
764         uint256 fyDaiUsed;
765         if (fyDaiObtained > 0 && controller.debtFYDai(CHAI, maturity, msg.sender) > 0) {
766             fyDaiUsed = controller.repayFYDai(CHAI, maturity, address(this), msg.sender, fyDaiObtained);
767         }
768         uint256 fyDaiRemaining = fyDaiObtained.sub(fyDaiUsed);
769 
770         if (fyDaiRemaining > 0) {// There is fyDai left, so exchange it for Dai to withdraw only Dai and Chai
771             require(
772                 pool.sellFYDai(address(this), address(this), uint128(fyDaiRemaining)) >= muld(fyDaiRemaining, minimumFYDaiPrice),
773                 "YieldProxy: minimumFYDaiPrice not reached"
774             );
775         }
776         withdrawAssets(fyDai);
777     }
778 
779     /// @dev Burns tokens and repays debt with proceedings. Sells any excess fyDai for Dai, then returns all Dai, and if there is no debt in the Controller, all posted Chai.
780     /// Caller must have approved the proxy using`controller.addDelegate(yieldProxy)` and `pool.addDelegate(yieldProxy)`
781     /// Caller must have approved the liquidity burn with `pool.approve(poolTokens)`
782     /// @param poolTokens amount of pool tokens to burn. 
783     /// @param minimumFYDaiPrice minimum Dai/fyDai price to be accepted when internally selling fyDai.
784     function removeLiquidityEarlyDaiFixed(IPool pool, uint256 poolTokens, uint256 minimumFYDaiPrice) external {
785         onlyKnownPool(pool);
786         IFYDai fyDai = pool.fyDai();
787         uint256 maturity = fyDai.maturity();
788         (uint256 daiObtained, uint256 fyDaiObtained) = pool.burn(msg.sender, address(this), poolTokens);
789 
790         uint256 fyDaiUsed;
791         if (fyDaiObtained > 0 && controller.debtFYDai(CHAI, maturity, msg.sender) > 0) {
792             fyDaiUsed = controller.repayFYDai(CHAI, maturity, address(this), msg.sender, fyDaiObtained);
793         }
794 
795         uint256 fyDaiRemaining = fyDaiObtained.sub(fyDaiUsed);
796         if (fyDaiRemaining == 0) { // We used all the fyDai, so probably there is debt left, so pay with Dai
797             if (daiObtained > 0 && controller.debtFYDai(CHAI, maturity, msg.sender) > 0) {
798                 controller.repayDai(CHAI, maturity, address(this), msg.sender, daiObtained);
799             }
800         } else { // Exchange remaining fyDai for Dai to withdraw only Dai and Chai
801             require(
802                 pool.sellFYDai(address(this), address(this), uint128(fyDaiRemaining)) >= muld(fyDaiRemaining, minimumFYDaiPrice),
803                 "YieldProxy: minimumFYDaiPrice not reached"
804             );
805         }
806         withdrawAssets(fyDai);
807     }
808 
809     /// @dev Burns tokens and repays fyDai debt after Maturity. 
810     /// Caller must have approved the proxy using`controller.addDelegate(yieldProxy)`
811     /// Caller must have approved the liquidity burn with `pool.approve(poolTokens)`
812     /// @param poolTokens amount of pool tokens to burn.
813     function removeLiquidityMature(IPool pool, uint256 poolTokens) external {
814         onlyKnownPool(pool);
815         IFYDai fyDai = pool.fyDai();
816         uint256 maturity = fyDai.maturity();
817         (uint256 daiObtained, uint256 fyDaiObtained) = pool.burn(msg.sender, address(this), poolTokens);
818         if (fyDaiObtained > 0) {
819             daiObtained = daiObtained.add(fyDai.redeem(address(this), address(this), fyDaiObtained));
820         }
821         
822         // Repay debt
823         if (daiObtained > 0 && controller.debtFYDai(CHAI, maturity, msg.sender) > 0) {
824             controller.repayDai(CHAI, maturity, address(this), msg.sender, daiObtained);
825         }
826         withdrawAssets(fyDai);
827     }
828 
829     /// @dev Return to caller all posted chai if there is no debt, converted to dai, plus any dai remaining in the contract.
830     function withdrawAssets(IFYDai fyDai) internal {
831         if (controller.debtFYDai(CHAI, fyDai.maturity(), msg.sender) == 0) {
832             uint256 posted = controller.posted(CHAI, msg.sender);
833             uint256 locked = controller.locked(CHAI, msg.sender);
834             require (posted >= locked, "YieldProxy: Undercollateralized");
835             controller.withdraw(CHAI, msg.sender, address(this), posted - locked);
836             chai.exit(address(this), chai.balanceOf(address(this)));
837         }
838         require(dai.transfer(msg.sender, dai.balanceOf(address(this))), "YieldProxy: Dai Transfer Failed");
839     }
840 
841     /// @dev Borrow fyDai from Controller and sell it immediately for Dai, for a maximum fyDai debt.
842     /// Must have approved the operator with `controller.addDelegate(yieldProxy.address)`.
843     /// @param collateral Valid collateral type.
844     /// @param maturity Maturity of an added series
845     /// @param to Wallet to send the resulting Dai to.
846     /// @param maximumFYDai Maximum amount of FYDai to borrow.
847     /// @param daiToBorrow Exact amount of Dai that should be obtained.
848     function borrowDaiForMaximumFYDai(
849         IPool pool,
850         bytes32 collateral,
851         uint256 maturity,
852         address to,
853         uint256 maximumFYDai,
854         uint256 daiToBorrow
855     )
856         public
857         returns (uint256)
858     {
859         onlyKnownPool(pool);
860         uint256 fyDaiToBorrow = pool.buyDaiPreview(daiToBorrow.toUint128());
861         require (fyDaiToBorrow <= maximumFYDai, "YieldProxy: Too much fyDai required");
862 
863         // The collateral for this borrow needs to have been posted beforehand
864         controller.borrow(collateral, maturity, msg.sender, address(this), fyDaiToBorrow);
865         pool.buyDai(address(this), to, daiToBorrow.toUint128());
866 
867         return fyDaiToBorrow;
868     }
869 
870     /// @dev Borrow fyDai from Controller and sell it immediately for Dai, if a minimum amount of Dai can be obtained such.
871     /// Must have approved the operator with `controller.addDelegate(yieldProxy.address)`.
872     /// @param collateral Valid collateral type.
873     /// @param maturity Maturity of an added series
874     /// @param to Wallet to sent the resulting Dai to.
875     /// @param fyDaiToBorrow Amount of fyDai to borrow.
876     /// @param minimumDaiToBorrow Minimum amount of Dai that should be borrowed.
877     function borrowMinimumDaiForFYDai(
878         IPool pool,
879         bytes32 collateral,
880         uint256 maturity,
881         address to,
882         uint256 fyDaiToBorrow,
883         uint256 minimumDaiToBorrow
884     )
885         public
886         returns (uint256)
887     {
888         onlyKnownPool(pool);
889         // The collateral for this borrow needs to have been posted beforehand
890         controller.borrow(collateral, maturity, msg.sender, address(this), fyDaiToBorrow);
891         uint256 boughtDai = pool.sellFYDai(address(this), to, fyDaiToBorrow.toUint128());
892         require (boughtDai >= minimumDaiToBorrow, "YieldProxy: Not enough Dai obtained");
893 
894         return boughtDai;
895     }
896 
897     /// @dev Repay an amount of fyDai debt in Controller using Dai exchanged for fyDai at pool rates, up to a maximum amount of Dai spent.
898     /// Must have approved the operator with `pool.addDelegate(yieldProxy.address)`.
899     /// If `fyDaiRepayment` exceeds the existing debt, only the necessary fyDai will be used.
900     /// @param collateral Valid collateral type.
901     /// @param maturity Maturity of an added series
902     /// @param to Yield Vault to repay fyDai debt for.
903     /// @param fyDaiRepayment Amount of fyDai debt to repay.
904     /// @param maximumRepaymentInDai Maximum amount of Dai that should be spent on the repayment.
905     function repayFYDaiDebtForMaximumDai(
906         IPool pool,
907         bytes32 collateral,
908         uint256 maturity,
909         address to,
910         uint256 fyDaiRepayment,
911         uint256 maximumRepaymentInDai
912     )
913         public
914         returns (uint256)
915     {
916         onlyKnownPool(pool);
917         uint256 fyDaiDebt = controller.debtFYDai(collateral, maturity, to);
918         uint256 fyDaiToUse = fyDaiDebt < fyDaiRepayment ? fyDaiDebt : fyDaiRepayment; // Use no more fyDai than debt
919         uint256 repaymentInDai = pool.buyFYDai(msg.sender, address(this), fyDaiToUse.toUint128());
920         require (repaymentInDai <= maximumRepaymentInDai, "YieldProxy: Too much Dai required");
921         controller.repayFYDai(collateral, maturity, address(this), to, fyDaiToUse);
922 
923         return repaymentInDai;
924     }
925 
926     /// @dev Repay an amount of fyDai debt in Controller using a given amount of Dai exchanged for fyDai at pool rates, with a minimum of fyDai debt required to be paid.
927     /// Must have approved the operator with `pool.addDelegate(yieldProxy.address)`.
928     /// If `repaymentInDai` exceeds the existing debt, only the necessary Dai will be used.
929     /// @param collateral Valid collateral type.
930     /// @param maturity Maturity of an added series
931     /// @param to Yield Vault to repay fyDai debt for.
932     /// @param minimumFYDaiRepayment Minimum amount of fyDai debt to repay.
933     /// @param repaymentInDai Exact amount of Dai that should be spent on the repayment.
934     function repayMinimumFYDaiDebtForDai(
935         IPool pool,
936         bytes32 collateral,
937         uint256 maturity,
938         address to,
939         uint256 minimumFYDaiRepayment,
940         uint256 repaymentInDai
941     )
942         public
943         returns (uint256)
944     {
945         onlyKnownPool(pool);
946         uint256 fyDaiRepayment = pool.sellDaiPreview(repaymentInDai.toUint128());
947         uint256 fyDaiDebt = controller.debtFYDai(collateral, maturity, to);
948         if(fyDaiRepayment <= fyDaiDebt) { // Sell no more Dai than needed to cancel all the debt
949             pool.sellDai(msg.sender, address(this), repaymentInDai.toUint128());
950         } else { // If we have too much Dai, then don't sell it all and buy the exact amount of fyDai needed instead.
951             pool.buyFYDai(msg.sender, address(this), fyDaiDebt.toUint128());
952             fyDaiRepayment = fyDaiDebt;
953         }
954         require (fyDaiRepayment >= minimumFYDaiRepayment, "YieldProxy: Not enough fyDai debt repaid");
955         controller.repayFYDai(collateral, maturity, address(this), to, fyDaiRepayment);
956 
957         return fyDaiRepayment;
958     }
959 
960     /// @dev Sell Dai for fyDai
961     /// @param to Wallet receiving the fyDai being bought
962     /// @param daiIn Amount of dai being sold
963     /// @param minFYDaiOut Minimum amount of fyDai being bought
964     function sellDai(IPool pool, address to, uint128 daiIn, uint128 minFYDaiOut)
965         external
966         returns(uint256)
967     {
968         onlyKnownPool(pool);
969         uint256 fyDaiOut = pool.sellDai(msg.sender, to, daiIn);
970         require(
971             fyDaiOut >= minFYDaiOut,
972             "YieldProxy: Limit not reached"
973         );
974         return fyDaiOut;
975     }
976 
977     /// @dev Buy Dai for fyDai
978     /// @param to Wallet receiving the dai being bought
979     /// @param daiOut Amount of dai being bought
980     /// @param maxFYDaiIn Maximum amount of fyDai being sold
981     function buyDai(IPool pool, address to, uint128 daiOut, uint128 maxFYDaiIn)
982         public
983         returns(uint256)
984     {
985         onlyKnownPool(pool);
986         uint256 fyDaiIn = pool.buyDai(msg.sender, to, daiOut);
987         require(
988             maxFYDaiIn >= fyDaiIn,
989             "YieldProxy: Limit exceeded"
990         );
991         return fyDaiIn;
992     }
993 
994     /// @dev Buy Dai for fyDai and permits infinite fyDai to the pool
995     /// @param to Wallet receiving the dai being bought
996     /// @param daiOut Amount of dai being bought
997     /// @param maxFYDaiIn Maximum amount of fyDai being sold
998     /// @param signature The `permit` call's signature
999     function buyDaiWithSignature(IPool pool, address to, uint128 daiOut, uint128 maxFYDaiIn, bytes memory signature)
1000         external
1001         returns(uint256)
1002     {
1003         onlyKnownPool(pool);
1004         (bytes32 r, bytes32 s, uint8 v) = unpack(signature);
1005         pool.fyDai().permit(msg.sender, address(pool), uint(-1), uint(-1), v, r, s);
1006 
1007         return buyDai(pool, to, daiOut, maxFYDaiIn);
1008     }
1009 
1010     /// @dev Sell fyDai for Dai
1011     /// @param to Wallet receiving the dai being bought
1012     /// @param fyDaiIn Amount of fyDai being sold
1013     /// @param minDaiOut Minimum amount of dai being bought
1014     function sellFYDai(IPool pool, address to, uint128 fyDaiIn, uint128 minDaiOut)
1015         public
1016         returns(uint256)
1017     {
1018         onlyKnownPool(pool);
1019         uint256 daiOut = pool.sellFYDai(msg.sender, to, fyDaiIn);
1020         require(
1021             daiOut >= minDaiOut,
1022             "YieldProxy: Limit not reached"
1023         );
1024         return daiOut;
1025     }
1026 
1027     /// @dev Sell fyDai for Dai and permits infinite Dai to the pool
1028     /// @param to Wallet receiving the dai being bought
1029     /// @param fyDaiIn Amount of fyDai being sold
1030     /// @param minDaiOut Minimum amount of dai being bought
1031     /// @param signature The `permit` call's signature
1032     function sellFYDaiWithSignature(IPool pool, address to, uint128 fyDaiIn, uint128 minDaiOut, bytes memory signature)
1033         external
1034         returns(uint256)
1035     {
1036         onlyKnownPool(pool);
1037         (bytes32 r, bytes32 s, uint8 v) = unpack(signature);
1038         pool.fyDai().permit(msg.sender, address(pool), uint(-1), uint(-1), v, r, s);
1039 
1040         return sellFYDai(pool, to, fyDaiIn, minDaiOut);
1041     }
1042 
1043     /// @dev Buy fyDai for dai
1044     /// @param to Wallet receiving the fyDai being bought
1045     /// @param fyDaiOut Amount of fyDai being bought
1046     /// @param maxDaiIn Maximum amount of dai being sold
1047     function buyFYDai(IPool pool, address to, uint128 fyDaiOut, uint128 maxDaiIn)
1048         external
1049         returns(uint256)
1050     {
1051         onlyKnownPool(pool);
1052         uint256 daiIn = pool.buyFYDai(msg.sender, to, fyDaiOut);
1053         require(
1054             maxDaiIn >= daiIn,
1055             "YieldProxy: Limit exceeded"
1056         );
1057         return daiIn;
1058     }
1059 
1060     /// @dev Burns Dai from caller to repay debt in a Yield Vault.
1061     /// User debt is decreased for the given collateral and fyDai series, in Yield vault `to`.
1062     /// The amount of debt repaid changes according to series maturity and MakerDAO rate and chi, depending on collateral type.
1063     /// `A signature is provided as a parameter to this function, so that `dai.approve()` doesn't need to be called.
1064     /// @param collateral Valid collateral type.
1065     /// @param maturity Maturity of an added series
1066     /// @param to Yield vault to repay debt for.
1067     /// @param daiAmount Amount of Dai to use for debt repayment.
1068     /// @param signature The `permit` call's signature
1069     function repayDaiWithSignature(bytes32 collateral, uint256 maturity, address to, uint256 daiAmount, bytes memory signature)
1070         external
1071         returns(uint256)
1072     {
1073         (bytes32 r, bytes32 s, uint8 v) = unpack(signature);
1074         dai.permit(msg.sender, address(treasury), dai.nonces(msg.sender), uint(-1), true, v, r, s);
1075         controller.repayDai(collateral, maturity, msg.sender, to, daiAmount);
1076     }
1077 
1078     function onlyKnownPool(IPool pool) private view {
1079         require(poolsMap[address(pool)], "YieldProxy: Unknown pool");
1080     }
1081 }