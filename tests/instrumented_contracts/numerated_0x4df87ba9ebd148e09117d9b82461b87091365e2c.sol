1 // File contracts/libraries/SafeMath.sol
2 
3 // SPDX-License-Identifier: AGPL-3.0-or-later
4 pragma solidity 0.7.5;
5 
6 
7 library SafeMath {
8 
9     function add(uint256 a, uint256 b) internal pure returns (uint256) {
10         uint256 c = a + b;
11         require(c >= a, "SafeMath: addition overflow");
12 
13         return c;
14     }
15 
16     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
17         return sub(a, b, "SafeMath: subtraction overflow");
18     }
19 
20     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
21         require(b <= a, errorMessage);
22         uint256 c = a - b;
23 
24         return c;
25     }
26 
27     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
28         if (a == 0) {
29             return 0;
30         }
31 
32         uint256 c = a * b;
33         require(c / a == b, "SafeMath: multiplication overflow");
34 
35         return c;
36     }
37 
38     function div(uint256 a, uint256 b) internal pure returns (uint256) {
39         return div(a, b, "SafeMath: division by zero");
40     }
41 
42     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
43         require(b > 0, errorMessage);
44         uint256 c = a / b;
45         return c;
46     }
47 
48     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
49         return mod(a, b, "SafeMath: modulo by zero");
50     }
51 
52     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
53         require(b != 0, errorMessage);
54         return a % b;
55     }
56 
57     function sqrrt(uint256 a) internal pure returns (uint c) {
58         if (a > 3) {
59             c = a;
60             uint b = add( div( a, 2), 1 );
61             while (b < c) {
62                 c = b;
63                 b = div( add( div( a, b ), b), 2 );
64             }
65         } else if (a != 0) {
66             c = 1;
67         }
68     }
69 }
70 
71 
72 // File contracts/libraries/Address.sol
73 
74 pragma solidity 0.7.5;
75 
76 
77 library Address {
78 
79     function isContract(address account) internal view returns (bool) {
80 
81         uint256 size;
82         // solhint-disable-next-line no-inline-assembly
83         assembly { size := extcodesize(account) }
84         return size > 0;
85     }
86 
87     function sendValue(address payable recipient, uint256 amount) internal {
88         require(address(this).balance >= amount, "Address: insufficient balance");
89 
90         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
91         (bool success, ) = recipient.call{ value: amount }("");
92         require(success, "Address: unable to send value, recipient may have reverted");
93     }
94 
95     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
96       return functionCall(target, data, "Address: low-level call failed");
97     }
98 
99     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
100         return _functionCallWithValue(target, data, 0, errorMessage);
101     }
102 
103     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
104         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
105     }
106 
107     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
108         require(address(this).balance >= value, "Address: insufficient balance for call");
109         require(isContract(target), "Address: call to non-contract");
110 
111         // solhint-disable-next-line avoid-low-level-calls
112         (bool success, bytes memory returndata) = target.call{ value: value }(data);
113         return _verifyCallResult(success, returndata, errorMessage);
114     }
115 
116     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
117         require(isContract(target), "Address: call to non-contract");
118 
119         // solhint-disable-next-line avoid-low-level-calls
120         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
121         if (success) {
122             return returndata;
123         } else {
124             // Look for revert reason and bubble it up if present
125             if (returndata.length > 0) {
126                 // The easiest way to bubble the revert reason is using memory via assembly
127 
128                 // solhint-disable-next-line no-inline-assembly
129                 assembly {
130                     let returndata_size := mload(returndata)
131                     revert(add(32, returndata), returndata_size)
132                 }
133             } else {
134                 revert(errorMessage);
135             }
136         }
137     }
138 
139     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
140         return functionStaticCall(target, data, "Address: low-level static call failed");
141     }
142 
143     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
144         require(isContract(target), "Address: static call to non-contract");
145 
146         // solhint-disable-next-line avoid-low-level-calls
147         (bool success, bytes memory returndata) = target.staticcall(data);
148         return _verifyCallResult(success, returndata, errorMessage);
149     }
150 
151     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
152         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
153     }
154 
155     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
156         require(isContract(target), "Address: delegate call to non-contract");
157 
158         // solhint-disable-next-line avoid-low-level-calls
159         (bool success, bytes memory returndata) = target.delegatecall(data);
160         return _verifyCallResult(success, returndata, errorMessage);
161     }
162 
163     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
164         if (success) {
165             return returndata;
166         } else {
167             if (returndata.length > 0) {
168 
169                 assembly {
170                     let returndata_size := mload(returndata)
171                     revert(add(32, returndata), returndata_size)
172                 }
173             } else {
174                 revert(errorMessage);
175             }
176         }
177     }
178 
179     function addressToString(address _address) internal pure returns(string memory) {
180         bytes32 _bytes = bytes32(uint256(_address));
181         bytes memory HEX = "0123456789abcdef";
182         bytes memory _addr = new bytes(42);
183 
184         _addr[0] = '0';
185         _addr[1] = 'x';
186 
187         for(uint256 i = 0; i < 20; i++) {
188             _addr[2+i*2] = HEX[uint8(_bytes[i + 12] >> 4)];
189             _addr[3+i*2] = HEX[uint8(_bytes[i + 12] & 0x0f)];
190         }
191 
192         return string(_addr);
193 
194     }
195 }
196 
197 
198 // File contracts/interfaces/IERC20.sol
199 
200 pragma solidity 0.7.5;
201 
202 interface IERC20 {
203     function decimals() external view returns (uint8);
204 
205     function totalSupply() external view returns (uint256);
206 
207     function balanceOf(address account) external view returns (uint256);
208 
209     function transfer(address recipient, uint256 amount) external returns (bool);
210 
211     function allowance(address owner, address spender) external view returns (uint256);
212 
213     function approve(address spender, uint256 amount) external returns (bool);
214 
215     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
216 
217     event Transfer(address indexed from, address indexed to, uint256 value);
218 
219     event Approval(address indexed owner, address indexed spender, uint256 value);
220 }
221 
222 
223 // File contracts/libraries/SafeERC20.sol
224 
225 pragma solidity 0.7.5;
226 
227 
228 library SafeERC20 {
229     using SafeMath for uint256;
230     using Address for address;
231 
232     function safeTransfer(IERC20 token, address to, uint256 value) internal {
233         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
234     }
235 
236     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
237         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
238     }
239 
240     function safeApprove(IERC20 token, address spender, uint256 value) internal {
241 
242         require((value == 0) || (token.allowance(address(this), spender) == 0),
243             "SafeERC20: approve from non-zero to non-zero allowance"
244         );
245         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
246     }
247 
248     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
249         uint256 newAllowance = token.allowance(address(this), spender).add(value);
250         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
251     }
252 
253     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
254         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
255         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
256     }
257 
258     function _callOptionalReturn(IERC20 token, bytes memory data) private {
259 
260         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
261         if (returndata.length > 0) { // Return data is optional
262             // solhint-disable-next-line max-line-length
263             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
264         }
265     }
266 }
267 
268 
269 // File contracts/libraries/FullMath.sol
270 
271 pragma solidity 0.7.5;
272 
273 library FullMath {
274     function fullMul(uint256 x, uint256 y) private pure returns (uint256 l, uint256 h) {
275         uint256 mm = mulmod(x, y, uint256(-1));
276         l = x * y;
277         h = mm - l;
278         if (mm < l) h -= 1;
279     }
280 
281     function fullDiv(
282         uint256 l,
283         uint256 h,
284         uint256 d
285     ) private pure returns (uint256) {
286         uint256 pow2 = d & -d;
287         d /= pow2;
288         l /= pow2;
289         l += h * ((-pow2) / pow2 + 1);
290         uint256 r = 1;
291         r *= 2 - d * r;
292         r *= 2 - d * r;
293         r *= 2 - d * r;
294         r *= 2 - d * r;
295         r *= 2 - d * r;
296         r *= 2 - d * r;
297         r *= 2 - d * r;
298         r *= 2 - d * r;
299         return l * r;
300     }
301 
302     function mulDiv(
303         uint256 x,
304         uint256 y,
305         uint256 d
306     ) internal pure returns (uint256) {
307         (uint256 l, uint256 h) = fullMul(x, y);
308         uint256 mm = mulmod(x, y, d);
309         if (mm > l) h -= 1;
310         l -= mm;
311         require(h < d, 'FullMath::mulDiv: overflow');
312         return fullDiv(l, h, d);
313     }
314 }
315 
316 
317 // File contracts/libraries/FixedPoint.sol
318 
319 pragma solidity 0.7.5;
320 
321 library Babylonian {
322 
323     function sqrt(uint256 x) internal pure returns (uint256) {
324         if (x == 0) return 0;
325 
326         uint256 xx = x;
327         uint256 r = 1;
328         if (xx >= 0x100000000000000000000000000000000) {
329             xx >>= 128;
330             r <<= 64;
331         }
332         if (xx >= 0x10000000000000000) {
333             xx >>= 64;
334             r <<= 32;
335         }
336         if (xx >= 0x100000000) {
337             xx >>= 32;
338             r <<= 16;
339         }
340         if (xx >= 0x10000) {
341             xx >>= 16;
342             r <<= 8;
343         }
344         if (xx >= 0x100) {
345             xx >>= 8;
346             r <<= 4;
347         }
348         if (xx >= 0x10) {
349             xx >>= 4;
350             r <<= 2;
351         }
352         if (xx >= 0x8) {
353             r <<= 1;
354         }
355         r = (r + x / r) >> 1;
356         r = (r + x / r) >> 1;
357         r = (r + x / r) >> 1;
358         r = (r + x / r) >> 1;
359         r = (r + x / r) >> 1;
360         r = (r + x / r) >> 1;
361         r = (r + x / r) >> 1; // Seven iterations should be enough
362         uint256 r1 = x / r;
363         return (r < r1 ? r : r1);
364     }
365 }
366 
367 library BitMath {
368 
369     function mostSignificantBit(uint256 x) internal pure returns (uint8 r) {
370         require(x > 0, 'BitMath::mostSignificantBit: zero');
371 
372         if (x >= 0x100000000000000000000000000000000) {
373             x >>= 128;
374             r += 128;
375         }
376         if (x >= 0x10000000000000000) {
377             x >>= 64;
378             r += 64;
379         }
380         if (x >= 0x100000000) {
381             x >>= 32;
382             r += 32;
383         }
384         if (x >= 0x10000) {
385             x >>= 16;
386             r += 16;
387         }
388         if (x >= 0x100) {
389             x >>= 8;
390             r += 8;
391         }
392         if (x >= 0x10) {
393             x >>= 4;
394             r += 4;
395         }
396         if (x >= 0x4) {
397             x >>= 2;
398             r += 2;
399         }
400         if (x >= 0x2) r += 1;
401     }
402 }
403 
404 
405 library FixedPoint {
406 
407     struct uq112x112 {
408         uint224 _x;
409     }
410 
411     struct uq144x112 {
412         uint256 _x;
413     }
414 
415     uint8 private constant RESOLUTION = 112;
416     uint256 private constant Q112 = 0x10000000000000000000000000000;
417     uint256 private constant Q224 = 0x100000000000000000000000000000000000000000000000000000000;
418     uint256 private constant LOWER_MASK = 0xffffffffffffffffffffffffffff; // decimal of UQ*x112 (lower 112 bits)
419 
420     function decode(uq112x112 memory self) internal pure returns (uint112) {
421         return uint112(self._x >> RESOLUTION);
422     }
423 
424     function decode112with18(uq112x112 memory self) internal pure returns (uint) {
425 
426         return uint(self._x) / 5192296858534827;
427     }
428 
429     function fraction(uint256 numerator, uint256 denominator) internal pure returns (uq112x112 memory) {
430         require(denominator > 0, 'FixedPoint::fraction: division by zero');
431         if (numerator == 0) return FixedPoint.uq112x112(0);
432 
433         if (numerator <= uint144(-1)) {
434             uint256 result = (numerator << RESOLUTION) / denominator;
435             require(result <= uint224(-1), 'FixedPoint::fraction: overflow');
436             return uq112x112(uint224(result));
437         } else {
438             uint256 result = FullMath.mulDiv(numerator, Q112, denominator);
439             require(result <= uint224(-1), 'FixedPoint::fraction: overflow');
440             return uq112x112(uint224(result));
441         }
442     }
443     
444     // square root of a UQ112x112
445     // lossy between 0/1 and 40 bits
446     function sqrt(uq112x112 memory self) internal pure returns (uq112x112 memory) {
447         if (self._x <= uint144(-1)) {
448             return uq112x112(uint224(Babylonian.sqrt(uint256(self._x) << 112)));
449         }
450 
451         uint8 safeShiftBits = 255 - BitMath.mostSignificantBit(self._x);
452         safeShiftBits -= safeShiftBits % 2;
453         return uq112x112(uint224(Babylonian.sqrt(uint256(self._x) << safeShiftBits) << ((112 - safeShiftBits) / 2)));
454     }
455 }
456 
457 
458 // File contracts/interfaces/ITreasury.sol
459 
460 pragma solidity 0.7.5;
461 
462 interface ITreasury {
463     function deposit(address _principleTokenAddress, uint _amountPrincipleToken, uint _amountPayoutToken) external;
464     function valueOfToken( address _principleTokenAddress, uint _amount ) external view returns ( uint value_ );
465 }
466 
467 
468 // File contracts/types/Ownable.sol
469 
470 pragma solidity 0.7.5;
471 
472 contract Ownable {
473 
474     address public policy;
475 
476     constructor () {
477         policy = msg.sender;
478     }
479 
480     modifier onlyPolicy() {
481         require( policy == msg.sender, "Ownable: caller is not the owner" );
482         _;
483     }
484     
485     function transferManagment(address _newOwner) external onlyPolicy() {
486         require( _newOwner != address(0) );
487         policy = _newOwner;
488     }
489 }
490 
491 
492 // File contracts/BarnBridgeCustom/CustomBarnBridgeBond.sol
493 
494 pragma solidity 0.7.5;
495 
496 
497 
498 
499 contract CustomBondBarnBridge is Ownable {
500     using FixedPoint for *;
501     using SafeERC20 for IERC20;
502     using SafeMath for uint;
503     
504     /* ======== EVENTS ======== */
505 
506     event BondCreated( uint deposit, uint payout, uint expires );
507     event BondRedeemed( address recipient, uint payout, uint remaining );
508     event BondPriceChanged( uint internalPrice, uint debtRatio );
509     event ControlVariableAdjustment( uint initialBCV, uint newBCV, uint adjustment, bool addition );
510     
511     
512      /* ======== STATE VARIABLES ======== */
513     
514     IERC20 immutable payoutToken; // token paid for principal
515     IERC20 immutable principalToken; // inflow token
516     ITreasury immutable customTreasury; // pays for and receives principal
517     address immutable olympusDAO;
518     address olympusTreasury; // receives fee
519 
520     uint public totalPrincipalBonded;
521     uint public totalPayoutGiven;
522     
523     Terms public terms; // stores terms for new bonds
524     Adjust public adjustment; // stores adjustment to BCV data
525     FeeTiers[] private feeTiers; // stores fee tiers
526 
527     mapping( address => Bond ) public bondInfo; // stores bond information for depositors
528 
529     uint public totalDebt; // total value of outstanding bonds; used for pricing
530     uint public lastDecay; // reference block for debt decay
531 
532     address immutable subsidyRouter; // pays subsidy in OHM to custom treasury
533     uint payoutSinceLastSubsidy; // principal accrued since subsidy paid
534     
535     /* ======== STRUCTS ======== */
536 
537     struct FeeTiers {
538         uint tierCeilings; // principal bonded till next tier
539         uint fees; // in ten-thousandths (i.e. 33300 = 3.33%)
540     }
541 
542     // Info for creating new bonds
543     struct Terms {
544         uint controlVariable; // scaling variable for price
545         uint vestingTerm; // in blocks
546         uint minimumPrice; // vs principal value
547         uint maxPayout; // in thousandths of a %. i.e. 500 = 0.5%
548         uint maxDebt; // payout token decimal debt ratio, max % total supply created as debt
549     }
550 
551     // Info for bond holder
552     struct Bond {
553         uint payout; // payout token remaining to be paid
554         uint vesting; // Blocks left to vest
555         uint lastBlock; // Last interaction
556         uint truePricePaid; // Price paid (principal tokens per payout token) in ten-millionths - 4000000 = 0.4
557     }
558 
559     // Info for incremental adjustments to control variable 
560     struct Adjust {
561         bool add; // addition or subtraction
562         uint rate; // increment
563         uint target; // BCV when adjustment finished
564         uint buffer; // minimum length (in blocks) between adjustments
565         uint lastBlock; // block when last adjustment made
566     }
567     
568     /* ======== CONSTRUCTOR ======== */
569 
570     constructor(
571         address _customTreasury, 
572         address _payoutToken, 
573         address _principalToken, 
574         address _olympusTreasury,
575         address _subsidyRouter, 
576         address _initialOwner, 
577         address _olympusDAO,
578         uint[] memory _tierCeilings, 
579         uint[] memory _fees
580     ) {
581         require( _customTreasury != address(0) );
582         customTreasury = ITreasury( _customTreasury );
583         require( _payoutToken != address(0) );
584         payoutToken = IERC20( _payoutToken );
585         require( _principalToken != address(0) );
586         principalToken = IERC20( _principalToken );
587         require( _olympusTreasury != address(0) );
588         olympusTreasury = _olympusTreasury;
589         require( _subsidyRouter != address(0) );
590         subsidyRouter = _subsidyRouter;
591         require( _initialOwner != address(0) );
592         policy = _initialOwner;
593         require( _olympusDAO != address(0) );
594         olympusDAO = _olympusDAO;
595         require(_tierCeilings.length == _fees.length, "tier length and fee length not the same");
596 
597         for(uint i; i < _tierCeilings.length; i++) {
598             feeTiers.push( FeeTiers({
599                 tierCeilings: _tierCeilings[i],
600                 fees: _fees[i]
601             }));
602         }
603     }
604 
605     /* ======== INITIALIZATION ======== */
606     
607     /**
608      *  @notice initializes bond parameters
609      *  @param _controlVariable uint
610      *  @param _vestingTerm uint
611      *  @param _minimumPrice uint
612      *  @param _maxPayout uint
613      *  @param _maxDebt uint
614      *  @param _initialDebt uint
615      */
616     function initializeBond( 
617         uint _controlVariable, 
618         uint _vestingTerm,
619         uint _minimumPrice,
620         uint _maxPayout,
621         uint _maxDebt,
622         uint _initialDebt
623     ) external onlyPolicy() {
624         require( currentDebt() == 0, "Debt must be 0 for initialization" );
625         terms = Terms ({
626             controlVariable: _controlVariable,
627             vestingTerm: _vestingTerm,
628             minimumPrice: _minimumPrice,
629             maxPayout: _maxPayout,
630             maxDebt: _maxDebt
631         });
632         totalDebt = _initialDebt;
633         lastDecay = block.number;
634     }
635     
636     
637     /* ======== POLICY FUNCTIONS ======== */
638 
639     enum PARAMETER { VESTING, PAYOUT, DEBT }
640     /**
641      *  @notice set parameters for new bonds
642      *  @param _parameter PARAMETER
643      *  @param _input uint
644      */
645     function setBondTerms ( PARAMETER _parameter, uint _input ) external onlyPolicy() {
646         if ( _parameter == PARAMETER.VESTING ) { // 0
647             require( _input >= 10000, "Vesting must be longer than 36 hours" );
648             terms.vestingTerm = _input;
649         } else if ( _parameter == PARAMETER.PAYOUT ) { // 1
650             require( _input <= 1000, "Payout cannot be above 1 percent" );
651             terms.maxPayout = _input;
652         } else if ( _parameter == PARAMETER.DEBT ) { // 2
653             terms.maxDebt = _input;
654         }
655     }
656 
657     /**
658      *  @notice set control variable adjustment
659      *  @param _addition bool
660      *  @param _increment uint
661      *  @param _target uint
662      *  @param _buffer uint
663      */
664     function setAdjustment ( 
665         bool _addition,
666         uint _increment, 
667         uint _target,
668         uint _buffer 
669     ) external onlyPolicy() {
670         require( _increment <= terms.controlVariable.mul( 30 ).div( 1000 ), "Increment too large" );
671 
672         adjustment = Adjust({
673             add: _addition,
674             rate: _increment,
675             target: _target,
676             buffer: _buffer,
677             lastBlock: block.number
678         });
679     }
680 
681     /**
682      *  @notice change address of Olympus Treasury
683      *  @param _olympusTreasury uint
684      */
685     function changeOlympusTreasury(address _olympusTreasury) external {
686         require( msg.sender == olympusDAO, "Only Olympus DAO" );
687         olympusTreasury = _olympusTreasury;
688     }
689 
690     /**
691      *  @notice subsidy controller checks payouts since last subsidy and resets counter
692      *  @return payoutSinceLastSubsidy_ uint
693      */
694     function paySubsidy() external returns ( uint payoutSinceLastSubsidy_ ) {
695         require( msg.sender == subsidyRouter, "Only subsidy controller" );
696 
697         payoutSinceLastSubsidy_ = payoutSinceLastSubsidy;
698         payoutSinceLastSubsidy = 0;
699     }
700     
701     /* ======== USER FUNCTIONS ======== */
702     
703     /**
704      *  @notice deposit bond
705      *  @param _amount uint
706      *  @param _maxPrice uint
707      *  @param _depositor address
708      *  @return uint
709      */
710     function deposit(uint _amount, uint _maxPrice, address _depositor) external returns (uint) {
711         require( _depositor != address(0), "Invalid address" );
712 
713         decayDebt();
714         require( totalDebt <= terms.maxDebt, "Max capacity reached" );
715         
716         uint nativePrice = trueBondPrice();
717 
718         require( _maxPrice >= nativePrice, "Slippage limit: more than max price" ); // slippage protection
719 
720         uint value = customTreasury.valueOfToken( address(principalToken), _amount );
721         uint payout = _payoutFor( value ); // payout to bonder is computed
722 
723         require( payout >= 10 ** payoutToken.decimals() / 100, "Bond too small" ); // must be > 0.01 payout token ( underflow protection )
724         require( payout <= maxPayout(), "Bond too large"); // size protection because there is no slippage
725 
726         // profits are calculated
727         uint fee = payout.mul( currentOlympusFee() ).div( 1e6 );
728 
729         /**
730             principal is transferred in
731             approved and
732             deposited into the treasury, returning (_amount - profit) payout token
733          */
734         principalToken.safeTransferFrom( msg.sender, address(this), _amount );
735         principalToken.approve( address(customTreasury), _amount );
736         customTreasury.deposit( address(principalToken), _amount, payout );
737         
738         if ( fee != 0 ) { // fee is transferred to dao 
739             payoutToken.transfer(olympusTreasury, fee);
740         }
741         
742         // total debt is increased
743         totalDebt = totalDebt.add( value );
744                 
745         // depositor info is stored
746         bondInfo[ _depositor ] = Bond({ 
747             payout: bondInfo[ _depositor ].payout.add( payout.sub(fee) ),
748             vesting: terms.vestingTerm,
749             lastBlock: block.number,
750             truePricePaid: trueBondPrice()
751         });
752 
753         // indexed events are emitted
754         emit BondCreated( _amount, payout, block.number.add( terms.vestingTerm ) );
755         emit BondPriceChanged( _bondPrice(), debtRatio() );
756 
757         totalPrincipalBonded = totalPrincipalBonded.add(_amount); // total bonded increased
758         totalPayoutGiven = totalPayoutGiven.add(payout); // total payout increased
759         payoutSinceLastSubsidy = payoutSinceLastSubsidy.add( payout ); // subsidy counter increased
760 
761         adjust(); // control variable is adjusted
762         return payout; 
763     }
764     
765     /** 
766      *  @notice redeem bond for user
767      *  @return uint
768      */ 
769     function redeem(address _depositor) external returns (uint) {
770         Bond memory info = bondInfo[ _depositor ];
771         uint percentVested = percentVestedFor( _depositor ); // (blocks since last interaction / vesting term remaining)
772 
773         if ( percentVested >= 10000 ) { // if fully vested
774             delete bondInfo[ _depositor ]; // delete user info
775             emit BondRedeemed( _depositor, info.payout, 0 ); // emit bond data
776             payoutToken.transfer( _depositor, info.payout );
777             return info.payout;
778 
779         } else { // if unfinished
780             // calculate payout vested
781             uint payout = info.payout.mul( percentVested ).div( 10000 );
782 
783             // store updated deposit info
784             bondInfo[ _depositor ] = Bond({
785                 payout: info.payout.sub( payout ),
786                 vesting: info.vesting.sub( block.number.sub( info.lastBlock ) ),
787                 lastBlock: block.number,
788                 truePricePaid: info.truePricePaid
789             });
790 
791             emit BondRedeemed( _depositor, payout, bondInfo[ _depositor ].payout );
792             payoutToken.transfer( _depositor, payout );
793             return payout;
794         }
795         
796     }
797     
798     /* ======== INTERNAL HELPER FUNCTIONS ======== */
799 
800     /**
801      *  @notice makes incremental adjustment to control variable
802      */
803     function adjust() internal {
804         uint blockCanAdjust = adjustment.lastBlock.add( adjustment.buffer );
805         if( adjustment.rate != 0 && block.number >= blockCanAdjust ) {
806             uint initial = terms.controlVariable;
807             if ( adjustment.add ) {
808                 terms.controlVariable = terms.controlVariable.add( adjustment.rate );
809                 if ( terms.controlVariable >= adjustment.target ) {
810                     adjustment.rate = 0;
811                 }
812             } else {
813                 terms.controlVariable = terms.controlVariable.sub( adjustment.rate );
814                 if ( terms.controlVariable <= adjustment.target ) {
815                     adjustment.rate = 0;
816                 }
817             }
818             adjustment.lastBlock = block.number;
819             emit ControlVariableAdjustment( initial, terms.controlVariable, adjustment.rate, adjustment.add );
820         }
821     }
822 
823     /**
824      *  @notice reduce total debt
825      */
826     function decayDebt() internal {
827         totalDebt = totalDebt.sub( debtDecay() );
828         lastDecay = block.number;
829     }
830 
831     /**
832      *  @notice calculate current bond price and remove floor if above
833      *  @return price_ uint
834      */
835     function _bondPrice() internal returns ( uint price_ ) {
836         price_ = terms.controlVariable.mul( debtRatio() ).div( 10 ** (uint256(payoutToken.decimals()).sub(8)) );
837         if ( price_ < terms.minimumPrice ) {
838             price_ = terms.minimumPrice;        
839         } else if ( terms.minimumPrice != 0 ) {
840             terms.minimumPrice = 0;
841         }
842     }
843 
844 
845     /* ======== VIEW FUNCTIONS ======== */
846 
847     /**
848      *  @notice calculate current bond premium
849      *  @return price_ uint
850      */
851     function bondPrice() public view returns ( uint price_ ) {        
852         price_ = terms.controlVariable.mul( debtRatio() ).div( 10 ** (uint256(payoutToken.decimals()).sub(8)) );
853         if ( price_ < terms.minimumPrice ) {
854             price_ = terms.minimumPrice;
855         }
856     }
857 
858     /**
859      *  @notice calculate true bond price a user pays
860      *  @return price_ uint
861      */
862     function trueBondPrice() public view returns ( uint price_ ) {
863         price_ = bondPrice().add(bondPrice().mul( currentOlympusFee() ).div( 1e6 ) );
864     }
865 
866     /**
867      *  @notice determine maximum bond size
868      *  @return uint
869      */
870     function maxPayout() public view returns ( uint ) {
871         return payoutToken.totalSupply().mul( terms.maxPayout ).div( 100000 );
872     }
873 
874     /**
875      *  @notice calculate total interest due for new bond
876      *  @param _value uint
877      *  @return uint
878      */
879     function _payoutFor( uint _value ) internal view returns ( uint ) {
880         return FixedPoint.fraction( _value, bondPrice() ).decode112with18().div( 1e8 );
881     }
882 
883     /**
884      *  @notice calculate user's interest due for new bond, accounting for Olympus Fee
885      *  @param _value uint
886      *  @return uint
887      */
888     function payoutFor( uint _value ) external view returns ( uint ) {
889         uint total = FixedPoint.fraction( _value, bondPrice() ).decode112with18().div( 1e8 );
890         return total.sub(total.mul( currentOlympusFee() ).div( 1e6 ));
891     }
892 
893     /**
894      *  @notice calculate current ratio of debt to payout token supply
895      *  @notice protocols using Olympus Pro should be careful when quickly adding large %s to total supply
896      *  @return debtRatio_ uint
897      */
898     function debtRatio() public view returns ( uint debtRatio_ ) {   
899         debtRatio_ = FixedPoint.fraction( 
900             currentDebt().mul( 10 ** payoutToken.decimals() ), 
901             payoutToken.totalSupply()
902         ).decode112with18().div( 1e18 );
903     }
904 
905     /**
906      *  @notice calculate debt factoring in decay
907      *  @return uint
908      */
909     function currentDebt() public view returns ( uint ) {
910         return totalDebt.sub( debtDecay() );
911     }
912 
913     /**
914      *  @notice amount to decay total debt by
915      *  @return decay_ uint
916      */
917     function debtDecay() public view returns ( uint decay_ ) {
918         uint blocksSinceLast = block.number.sub( lastDecay );
919         decay_ = totalDebt.mul( blocksSinceLast ).div( terms.vestingTerm );
920         if ( decay_ > totalDebt ) {
921             decay_ = totalDebt;
922         }
923     }
924 
925 
926     /**
927      *  @notice calculate how far into vesting a depositor is
928      *  @param _depositor address
929      *  @return percentVested_ uint
930      */
931     function percentVestedFor( address _depositor ) public view returns ( uint percentVested_ ) {
932         Bond memory bond = bondInfo[ _depositor ];
933         uint blocksSinceLast = block.number.sub( bond.lastBlock );
934         uint vesting = bond.vesting;
935 
936         if ( vesting > 0 ) {
937             percentVested_ = blocksSinceLast.mul( 10000 ).div( vesting );
938         } else {
939             percentVested_ = 0;
940         }
941     }
942 
943     /**
944      *  @notice calculate amount of payout token available for claim by depositor
945      *  @param _depositor address
946      *  @return pendingPayout_ uint
947      */
948     function pendingPayoutFor( address _depositor ) external view returns ( uint pendingPayout_ ) {
949         uint percentVested = percentVestedFor( _depositor );
950         uint payout = bondInfo[ _depositor ].payout;
951 
952         if ( percentVested >= 10000 ) {
953             pendingPayout_ = payout;
954         } else {
955             pendingPayout_ = payout.mul( percentVested ).div( 10000 );
956         }
957     }
958 
959     /**
960      *  @notice current fee Olympus takes of each bond
961      *  @return currentFee_ uint
962      */
963     function currentOlympusFee() public view returns( uint currentFee_ ) {
964         uint tierLength = feeTiers.length;
965         for(uint i; i < tierLength; i++) {
966             if(totalPrincipalBonded < feeTiers[i].tierCeilings || i == tierLength - 1 ) {
967                 return feeTiers[i].fees;
968             }
969         }
970     }
971     
972 }