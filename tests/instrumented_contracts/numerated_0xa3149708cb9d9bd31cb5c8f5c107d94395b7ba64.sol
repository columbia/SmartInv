1 // ███████╗░█████╗░██████╗░██████╗░███████╗██████╗░░░░███████╗██╗
2 // ╚════██║██╔══██╗██╔══██╗██╔══██╗██╔════╝██╔══██╗░░░██╔════╝██║
3 // ░░███╔═╝███████║██████╔╝██████╔╝█████╗░░██████╔╝░░░█████╗░░██║
4 // ██╔══╝░░██╔══██║██╔═══╝░██╔═══╝░██╔══╝░░██╔══██╗░░░██╔══╝░░██║
5 // ███████╗██║░░██║██║░░░░░██║░░░░░███████╗██║░░██║██╗██║░░░░░██║
6 // ╚══════╝╚═╝░░╚═╝╚═╝░░░░░╚═╝░░░░░╚══════╝╚═╝░░╚═╝╚═╝╚═╝░░░░░╚═╝
7 // Copyright (C) 2020 zapper, nodar, suhail, seb, sumit, apoorv
8 
9 // This program is free software: you can redistribute it and/or modify
10 // it under the terms of the GNU Affero General Public License as published by
11 // the Free Software Foundation, either version 2 of the License, or
12 // (at your option) any later version.
13 //
14 // This program is distributed in the hope that it will be useful,
15 // but WITHOUT ANY WARRANTY; without even the implied warranty of
16 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
17 // GNU Affero General Public License for more details.
18 //
19 
20 ///@author Zapper
21 ///@notice This contract moves liquidity between UniswapV2 and Balancer pools.
22 
23 pragma solidity ^0.5.0;
24 
25 library SafeMath {
26     function add(uint256 a, uint256 b) internal pure returns (uint256) {
27         uint256 c = a + b;
28         require(c >= a, "SafeMath: addition overflow");
29 
30         return c;
31     }
32 
33     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
34         return sub(a, b, "SafeMath: subtraction overflow");
35     }
36 
37     function sub(
38         uint256 a,
39         uint256 b,
40         string memory errorMessage
41     ) internal pure returns (uint256) {
42         require(b <= a, errorMessage);
43         uint256 c = a - b;
44 
45         return c;
46     }
47 
48     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
49         if (a == 0) {
50             return 0;
51         }
52 
53         uint256 c = a * b;
54         require(c / a == b, "SafeMath: multiplication overflow");
55 
56         return c;
57     }
58 
59     function div(uint256 a, uint256 b) internal pure returns (uint256) {
60         return div(a, b, "SafeMath: division by zero");
61     }
62 
63     function div(
64         uint256 a,
65         uint256 b,
66         string memory errorMessage
67     ) internal pure returns (uint256) {
68         require(b > 0, errorMessage);
69         uint256 c = a / b;
70         return c;
71     }
72 
73     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
74         return mod(a, b, "SafeMath: modulo by zero");
75     }
76 
77     function mod(
78         uint256 a,
79         uint256 b,
80         string memory errorMessage
81     ) internal pure returns (uint256) {
82         require(b != 0, errorMessage);
83         return a % b;
84     }
85 }
86 
87 pragma solidity ^0.5.0;
88 
89 /**
90  * @title SafeERC20
91  * @dev Wrappers around ERC20 operations that throw on failure (when the token
92  * contract returns false). Tokens that return no value (and instead revert or
93  * throw on failure) are also supported, non-reverting calls are assumed to be
94  * successful.
95  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
96  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
97  */
98 library SafeERC20 {
99     using SafeMath for uint256;
100     using Address for address;
101 
102     function safeTransfer(
103         IERC20 token,
104         address to,
105         uint256 value
106     ) internal {
107         callOptionalReturn(
108             token,
109             abi.encodeWithSelector(token.transfer.selector, to, value)
110         );
111     }
112 
113     function safeTransferFrom(
114         IERC20 token,
115         address from,
116         address to,
117         uint256 value
118     ) internal {
119         callOptionalReturn(
120             token,
121             abi.encodeWithSelector(token.transferFrom.selector, from, to, value)
122         );
123     }
124 
125     function safeApprove(
126         IERC20 token,
127         address spender,
128         uint256 value
129     ) internal {
130         // safeApprove should only be called when setting an initial allowance,
131         // or when resetting it to zero. To increase and decrease it, use
132         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
133         // solhint-disable-next-line max-line-length
134         require(
135             (value == 0) || (token.allowance(address(this), spender) == 0),
136             "SafeERC20: approve from non-zero to non-zero allowance"
137         );
138         callOptionalReturn(
139             token,
140             abi.encodeWithSelector(token.approve.selector, spender, value)
141         );
142     }
143 
144     function safeIncreaseAllowance(
145         IERC20 token,
146         address spender,
147         uint256 value
148     ) internal {
149         uint256 newAllowance = token.allowance(address(this), spender).add(
150             value
151         );
152         callOptionalReturn(
153             token,
154             abi.encodeWithSelector(
155                 token.approve.selector,
156                 spender,
157                 newAllowance
158             )
159         );
160     }
161 
162     function safeDecreaseAllowance(
163         IERC20 token,
164         address spender,
165         uint256 value
166     ) internal {
167         uint256 newAllowance = token.allowance(address(this), spender).sub(
168             value,
169             "SafeERC20: decreased allowance below zero"
170         );
171         callOptionalReturn(
172             token,
173             abi.encodeWithSelector(
174                 token.approve.selector,
175                 spender,
176                 newAllowance
177             )
178         );
179     }
180 
181     /**
182      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
183      * on the return value: the return value is optional (but if data is returned, it must not be false).
184      * @param token The token targeted by the call.
185      * @param data The call data (encoded using abi.encode or one of its variants).
186      */
187     function callOptionalReturn(IERC20 token, bytes memory data) private {
188         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
189         // we're implementing it ourselves.
190 
191         // A Solidity high level call has three parts:
192         //  1. The target address is checked to verify it contains contract code
193         //  2. The call itself is made, and success asserted
194         //  3. The return value is decoded, which in turn checks the size of the returned data.
195         // solhint-disable-next-line max-line-length
196         require(address(token).isContract(), "SafeERC20: call to non-contract");
197 
198         // solhint-disable-next-line avoid-low-level-calls
199         (bool success, bytes memory returndata) = address(token).call(data);
200         require(success, "SafeERC20: low-level call failed");
201 
202         if (returndata.length > 0) {
203             // Return data is optional
204             // solhint-disable-next-line max-line-length
205             require(
206                 abi.decode(returndata, (bool)),
207                 "SafeERC20: ERC20 operation did not succeed"
208             );
209         }
210     }
211 }
212 
213 library Address {
214     /**
215      * @dev Returns true if `account` is a contract.
216      *
217      * [IMPORTANT]
218      * ====
219      * It is unsafe to assume that an address for which this function returns
220      * false is an externally-owned account (EOA) and not a contract.
221      *
222      * Among others, `isContract` will return false for the following
223      * types of addresses:
224      *
225      *  - an externally-owned account
226      *  - a contract in construction
227      *  - an address where a contract will be created
228      *  - an address where a contract lived, but was destroyed
229      * ====
230      */
231     function isContract(address account) internal view returns (bool) {
232         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
233         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
234         // for accounts without code, i.e. `keccak256('')`
235         bytes32 codehash;
236 
237 
238             bytes32 accountHash
239          = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
240         // solhint-disable-next-line no-inline-assembly
241         assembly {
242             codehash := extcodehash(account)
243         }
244         return (codehash != accountHash && codehash != 0x0);
245     }
246 
247     /**
248      * @dev Converts an `address` into `address payable`. Note that this is
249      * simply a type cast: the actual underlying value is not changed.
250      *
251      * _Available since v2.4.0._
252      */
253     function toPayable(address account)
254         internal
255         pure
256         returns (address payable)
257     {
258         return address(uint160(account));
259     }
260 
261     /**
262      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
263      * `recipient`, forwarding all available gas and reverting on errors.
264      *
265      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
266      * of certain opcodes, possibly making contracts go over the 2300 gas limit
267      * imposed by `transfer`, making them unable to receive funds via
268      * `transfer`. {sendValue} removes this limitation.
269      *
270      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
271      *
272      * IMPORTANT: because control is transferred to `recipient`, care must be
273      * taken to not create reentrancy vulnerabilities. Consider using
274      * {ReentrancyGuard} or the
275      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
276      *
277      * _Available since v2.4.0._
278      */
279     function sendValue(address payable recipient, uint256 amount) internal {
280         require(
281             address(this).balance >= amount,
282             "Address: insufficient balance"
283         );
284 
285         // solhint-disable-next-line avoid-call-value
286         (bool success, ) = recipient.call.value(amount)("");
287         require(
288             success,
289             "Address: unable to send value, recipient may have reverted"
290         );
291     }
292 }
293 
294 contract ReentrancyGuard {
295     bool private _notEntered;
296 
297     constructor() internal {
298         // Storing an initial non-zero value makes deployment a bit more
299         // expensive, but in exchange the refund on every call to nonReentrant
300         // will be lower in amount. Since refunds are capped to a percetange of
301         // the total transaction's gas, it is best to keep them low in cases
302         // like this one, to increase the likelihood of the full refund coming
303         // into effect.
304         _notEntered = true;
305     }
306 
307     /**
308      * @dev Prevents a contract from calling itself, directly or indirectly.
309      * Calling a `nonReentrant` function from another `nonReentrant`
310      * function is not supported. It is possible to prevent this from happening
311      * by making the `nonReentrant` function external, and make it call a
312      * `private` function that does the actual work.
313      */
314     modifier nonReentrant() {
315         // On the first call to nonReentrant, _notEntered will be true
316         require(_notEntered, "ReentrancyGuard: reentrant call");
317 
318         // Any calls to nonReentrant after this point will fail
319         _notEntered = false;
320 
321         _;
322 
323         // By storing the original value once again, a refund is triggered (see
324         // https://eips.ethereum.org/EIPS/eip-2200)
325         _notEntered = true;
326     }
327 }
328 
329 contract Context {
330     // Empty internal constructor, to prevent people from mistakenly deploying
331     // an instance of this contract, which should be used via inheritance.
332     constructor() internal {}
333 
334     // solhint-disable-previous-line no-empty-blocks
335 
336     function _msgSender() internal view returns (address payable) {
337         return msg.sender;
338     }
339 
340     function _msgData() internal view returns (bytes memory) {
341         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
342         return msg.data;
343     }
344 }
345 
346 contract Ownable is Context {
347     address private _owner;
348 
349     event OwnershipTransferred(
350         address indexed previousOwner,
351         address indexed newOwner
352     );
353 
354     /**
355      * @dev Initializes the contract setting the deployer as the initial owner.
356      */
357     constructor() internal {
358         address msgSender = _msgSender();
359         _owner = msgSender;
360         emit OwnershipTransferred(address(0), msgSender);
361     }
362 
363     /**
364      * @dev Returns the address of the current owner.
365      */
366     function owner() public view returns (address) {
367         return _owner;
368     }
369 
370     /**
371      * @dev Throws if called by any account other than the owner.
372      */
373     modifier onlyOwner() {
374         require(isOwner(), "Ownable: caller is not the owner");
375         _;
376     }
377 
378     /**
379      * @dev Returns true if the caller is the current owner.
380      */
381     function isOwner() public view returns (bool) {
382         return _msgSender() == _owner;
383     }
384 
385     /**
386      * @dev Leaves the contract without owner. It will not be possible to call
387      * `onlyOwner` functions anymore. Can only be called by the current owner.
388      *
389      * NOTE: Renouncing ownership will leave the contract without an owner,
390      * thereby removing any functionality that is only available to the owner.
391      */
392     function renounceOwnership() public onlyOwner {
393         emit OwnershipTransferred(_owner, address(0));
394         _owner = address(0);
395     }
396 
397     /**
398      * @dev Transfers ownership of the contract to a new account (`newOwner`).
399      * Can only be called by the current owner.
400      */
401     function transferOwnership(address newOwner) public onlyOwner {
402         _transferOwnership(newOwner);
403     }
404 
405     /**
406      * @dev Transfers ownership of the contract to a new account (`newOwner`).
407      */
408     function _transferOwnership(address newOwner) internal {
409         require(
410             newOwner != address(0),
411             "Ownable: new owner is the zero address"
412         );
413         emit OwnershipTransferred(_owner, newOwner);
414         _owner = newOwner;
415     }
416 }
417 
418 interface IERC20 {
419     function decimals() external view returns (uint256);
420 
421     function totalSupply() external view returns (uint256);
422 
423     function balanceOf(address account) external view returns (uint256);
424 
425     function transfer(address recipient, uint256 amount)
426         external
427         returns (bool);
428 
429     function allowance(address owner, address spender)
430         external
431         view
432         returns (uint256);
433 
434     function approve(address spender, uint256 amount) external returns (bool);
435 
436     function transferFrom(
437         address sender,
438         address recipient,
439         uint256 amount
440     ) external returns (bool);
441 
442     event Transfer(address indexed from, address indexed to, uint256 value);
443 
444     event Approval(
445         address indexed owner,
446         address indexed spender,
447         uint256 value
448     );
449 }
450 
451 interface IUniswapV2Factory {
452     function getPair(address tokenA, address tokenB)
453         external
454         view
455         returns (address);
456 }
457 
458 interface IUniswapV2Pair {
459     function token0() external pure returns (address);
460 
461     function token1() external pure returns (address);
462 
463     function getReserves()
464         external
465         view
466         returns (
467             uint112 _reserve0,
468             uint112 _reserve1,
469             uint32 _blockTimestampLast
470         );
471 
472     // this low-level function should be called from a contract which performs important safety checks
473     function swap(
474         uint256 amount0Out,
475         uint256 amount1Out,
476         address to,
477         bytes calldata data
478     ) external;
479 
480     // force balances to match reserves
481     function skim(address to) external;
482 }
483 
484 interface IUniswapV2ZapIn {
485     function ZapIn(
486         address _toWhomToIssue,
487         address _FromTokenContractAddress,
488         address _ToUnipoolToken0,
489         address _ToUnipoolToken1,
490         uint256 _amount,
491         uint256 _minPoolTokens
492     ) external payable returns (uint256);
493 }
494 
495 interface IUniswapV2ZapOut {
496     function ZapOut(
497         address _ToTokenContractAddress,
498         address _FromUniPoolAddress,
499         uint256 _IncomingLP,
500         uint256 _minTokensRec
501     ) external payable returns (uint256);
502 }
503 
504 interface IBalancerZapIn {
505     function ZapIn(
506         address _FromTokenContractAddress,
507         address _ToBalancerPoolAddress,
508         uint256 _amount,
509         uint256 _minPoolTokens
510     ) external payable returns (uint256 tokensBought);
511 }
512 
513 interface IBalancerZapOut {
514     function EasyZapOut(
515         address _ToTokenContractAddress,
516         address _FromBalancerPoolAddress,
517         uint256 _IncomingBPT,
518         uint256 _minTokensRec
519     ) external payable returns (uint256);
520 }
521 
522 interface IBPool {
523     function isBound(address t) external view returns (bool);
524 }
525 
526 contract Balancer_UniswapV2_Pipe_V1_4 is ReentrancyGuard, Ownable {
527     using SafeMath for uint256;
528     using SafeERC20 for IERC20;
529     using Address for address;
530     bool public stopped = false;
531 
532     IUniswapV2Factory
533         private constant UniSwapV2FactoryAddress = IUniswapV2Factory(
534         0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f
535     );
536 
537     IBalancerZapOut public balancerZapOut;
538     IUniswapV2ZapIn public uniswapV2ZapIn;
539     IBalancerZapIn public balancerZapIn;
540     IUniswapV2ZapOut public uniswapV2ZapOut;
541 
542     constructor(
543         address _balancerZapIn,
544         address _balancerZapOut,
545         address _uniswapV2ZapIn,
546         address _uniswapV2ZapOut
547     ) public {
548         balancerZapIn = IBalancerZapIn(_balancerZapIn);
549         balancerZapOut = IBalancerZapOut(_balancerZapOut);
550         uniswapV2ZapIn = IUniswapV2ZapIn(_uniswapV2ZapIn);
551         uniswapV2ZapOut = IUniswapV2ZapOut(_uniswapV2ZapOut);
552     }
553 
554     // circuit breaker modifiers
555     modifier stopInEmergency {
556         if (stopped) {
557             revert("Temporarily Paused");
558         } else {
559             _;
560         }
561     }
562 
563     function PipeBalancerUniV2(
564         address _FromBalancerPoolAddress,
565         uint256 _IncomingBPT,
566         address _toUniswapPoolAddress,
567         address _toWhomToIssue,
568         uint256 _minUniV2Tokens
569     ) public nonReentrant stopInEmergency returns (uint256) {
570         // Get BPT
571         IERC20(_FromBalancerPoolAddress).safeTransferFrom(
572             msg.sender,
573             address(this),
574             _IncomingBPT
575         );
576         // Approve BalUnZap
577         IERC20(_FromBalancerPoolAddress).safeApprove(
578             address(balancerZapOut),
579             _IncomingBPT
580         );
581 
582         // Get pair addresses from UniV2Pair
583         address token0 = IUniswapV2Pair(_toUniswapPoolAddress).token0();
584         address token1 = IUniswapV2Pair(_toUniswapPoolAddress).token1();
585 
586         address zapOutToToken = address(0);
587         if (IBPool(_FromBalancerPoolAddress).isBound(token0)) {
588             zapOutToToken = token0;
589         } else if (IBPool(_FromBalancerPoolAddress).isBound(token1)) {
590             zapOutToToken = token1;
591         }
592 
593         // ZapOut from Balancer
594         uint256 zappedOutAmt = balancerZapOut.EasyZapOut(
595             zapOutToToken,
596             _FromBalancerPoolAddress,
597             _IncomingBPT,
598             0
599         );
600 
601         uint256 LPTBought;
602         if (zapOutToToken == address(0)) {
603             // use ETH to ZapIn to UNIV2
604             LPTBought = uniswapV2ZapIn.ZapIn.value(zappedOutAmt)(
605                 _toWhomToIssue,
606                 address(0),
607                 token0,
608                 token1,
609                 0,
610                 _minUniV2Tokens
611             );
612         } else {
613             IERC20(zapOutToToken).safeApprove(
614                 address(uniswapV2ZapIn),
615                 IERC20(zapOutToToken).balanceOf(address(this))
616             );
617             LPTBought = uniswapV2ZapIn.ZapIn.value(0)(
618                 _toWhomToIssue,
619                 zapOutToToken,
620                 token0,
621                 token1,
622                 zappedOutAmt,
623                 _minUniV2Tokens
624             );
625         }
626 
627         return LPTBought;
628     }
629 
630     function PipeUniV2Balancer(
631         address _FromUniswapPoolAddress,
632         uint256 _IncomingLPT,
633         address _ToBalancerPoolAddress,
634         address _toWhomToIssue,
635         uint256 _minBPTokens
636     ) public nonReentrant stopInEmergency returns (uint256) {
637         // Get LPT
638         IERC20(_FromUniswapPoolAddress).safeTransferFrom(
639             msg.sender,
640             address(this),
641             _IncomingLPT
642         );
643 
644         // Approve UniUnZap
645         IERC20(_FromUniswapPoolAddress).safeApprove(
646             address(uniswapV2ZapOut),
647             _IncomingLPT
648         );
649 
650         // Get pair addresses from UniV2Pair
651         address token0 = IUniswapV2Pair(_FromUniswapPoolAddress).token0();
652         address token1 = IUniswapV2Pair(_FromUniswapPoolAddress).token1();
653 
654         address zapOutToToken = address(0);
655         if (IBPool(_ToBalancerPoolAddress).isBound(token0)) {
656             zapOutToToken = token0;
657         } else if (IBPool(_ToBalancerPoolAddress).isBound(token1)) {
658             zapOutToToken = token1;
659         }
660 
661         // ZapOut from Uni
662         uint256 tokensRec = uniswapV2ZapOut.ZapOut(
663             zapOutToToken,
664             _FromUniswapPoolAddress,
665             _IncomingLPT,
666             0
667         );
668 
669         // ZapIn to Balancer
670         uint256 BPTBought;
671         if (zapOutToToken == address(0)) {
672             // use ETH to ZapIn to Balancer
673             BPTBought = balancerZapIn.ZapIn.value(tokensRec)(
674                 address(0),
675                 _ToBalancerPoolAddress,
676                 0,
677                 _minBPTokens
678             );
679         } else {
680             IERC20(zapOutToToken).safeApprove(address(balancerZapIn), tokensRec);
681             BPTBought = balancerZapIn.ZapIn.value(0)(
682                 zapOutToToken,
683                 _ToBalancerPoolAddress,
684                 tokensRec,
685                 _minBPTokens
686             );
687         }
688 
689         IERC20(_ToBalancerPoolAddress).safeTransfer(_toWhomToIssue, BPTBought);
690 
691         return BPTBought;
692     }
693 
694     // Zap Contract Setters
695     function setbalancerZapIn(address _balancerZapIn) public onlyOwner {
696         balancerZapIn = IBalancerZapIn(_balancerZapIn);
697     }
698 
699     function setBalancerZapOut(address _balancerZapOut) public onlyOwner {
700         balancerZapOut = IBalancerZapOut(_balancerZapOut);
701     }
702 
703     function setUniswapV2ZapIn(address _uniswapV2ZapIn) public onlyOwner {
704         uniswapV2ZapIn = IUniswapV2ZapIn(_uniswapV2ZapIn);
705     }
706 
707     function setUniswapV2ZapOut(address _uniswapV2ZapOut) public onlyOwner {
708         uniswapV2ZapOut = IUniswapV2ZapOut(_uniswapV2ZapOut);
709     }
710 
711     // fallback to receive ETH
712     function() external payable {}
713 
714     function inCaseTokengetsStuck(IERC20 _TokenAddress) public onlyOwner {
715         uint256 qty = _TokenAddress.balanceOf(address(this));
716         _TokenAddress.safeTransfer(owner(), qty);
717     }
718 
719     // - to Pause the contract
720     function toggleContractActive() public onlyOwner {
721         stopped = !stopped;
722     }
723 
724     // - to withdraw any ETH balance sitting in the contract
725     function withdraw() public onlyOwner {
726         uint256 contractBalance = address(this).balance;
727         address payable _to = owner().toPayable();
728         Address.sendValue(_to, contractBalance);
729     }
730 }