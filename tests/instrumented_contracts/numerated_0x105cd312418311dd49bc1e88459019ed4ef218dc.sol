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
458 // File contracts/types/Ownable.sol
459 
460 pragma solidity 0.7.5;
461 
462 contract Ownable {
463 
464     address public policy;
465 
466     constructor () {
467         policy = msg.sender;
468     }
469 
470     modifier onlyPolicy() {
471         require( policy == msg.sender, "Ownable: caller is not the owner" );
472         _;
473     }
474     
475     function transferManagment(address _newOwner) external onlyPolicy() {
476         require( _newOwner != address(0) );
477         policy = _newOwner;
478     }
479 }
480 
481 
482 // File contracts/ALCXCustom/CustomALCXBond.sol
483 
484 pragma solidity 0.7.5;
485 
486 
487 
488 interface ITreasury {
489     function deposit(address _principleTokenAddress, uint _amountPrincipleToken, uint _amountPayoutToken) external;
490     function valueOfToken( address _principalTokenAddress, uint _amount ) external view returns ( uint value_ );
491     function payoutToken() external view returns (address);
492 }
493 
494 contract CustomALCXBond is Ownable {
495     using FixedPoint for *;
496     using SafeERC20 for IERC20;
497     using SafeMath for uint;
498     
499     /* ======== EVENTS ======== */
500 
501     event BondCreated( uint deposit, uint payout, uint expires );
502     event BondRedeemed( address recipient, uint payout, uint remaining );
503     event BondPriceChanged( uint internalPrice, uint debtRatio );
504     event ControlVariableAdjustment( uint initialBCV, uint newBCV, uint adjustment, bool addition );
505     
506     
507      /* ======== STATE VARIABLES ======== */
508     
509     IERC20 immutable payoutToken; // token paid for principal
510     IERC20 immutable principalToken; // inflow token
511     ITreasury immutable customTreasury; // pays for and receives principal
512     address immutable olympusDAO;
513     address olympusTreasury; // receives fee
514     address immutable subsidyRouter; // pays subsidy in OHM to custom treasury
515 
516     uint public totalPrincipalBonded;
517     uint public totalPayoutGiven;
518     uint public totalDebt; // total value of outstanding bonds; used for pricing
519     uint public lastDecay; // reference block for debt decay
520     uint payoutSinceLastSubsidy; // principal accrued since subsidy paid
521     
522     Terms public terms; // stores terms for new bonds
523     Adjust public adjustment; // stores adjustment to BCV data
524     FeeTiers[] private feeTiers; // stores fee tiers
525 
526     bool immutable private feeInPayout;
527 
528     mapping( address => Bond ) public bondInfo; // stores bond information for depositors
529     
530     /* ======== STRUCTS ======== */
531 
532     struct FeeTiers {
533         uint tierCeilings; // principal bonded till next tier
534         uint fees; // in ten-thousandths (i.e. 33300 = 3.33%)
535     }
536 
537     // Info for creating new bonds
538     struct Terms {
539         uint controlVariable; // scaling variable for price
540         uint vestingTerm; // in blocks
541         uint minimumPrice; // vs principal value
542         uint maxPayout; // in thousandths of a %. i.e. 500 = 0.5%
543         uint maxDebt; // payout token decimal debt ratio, max % total supply created as debt
544     }
545 
546     // Info for bond holder
547     struct Bond {
548         uint payout; // payout token remaining to be paid
549         uint vesting; // Blocks left to vest
550         uint lastBlock; // Last interaction
551         uint truePricePaid; // Price paid (principal tokens per payout token) in ten-millionths - 4000000 = 0.4
552     }
553 
554     // Info for incremental adjustments to control variable 
555     struct Adjust {
556         bool add; // addition or subtraction
557         uint rate; // increment
558         uint target; // BCV when adjustment finished
559         uint buffer; // minimum length (in blocks) between adjustments
560         uint lastBlock; // block when last adjustment made
561     }
562     
563     /* ======== CONSTRUCTOR ======== */
564 
565     constructor(
566         address _customTreasury, 
567         address _principalToken, 
568         address _olympusTreasury,
569         address _subsidyRouter, 
570         address _initialOwner, 
571         address _olympusDAO,
572         uint[] memory _tierCeilings, 
573         uint[] memory _fees,
574         bool _feeInPayout
575     ) {
576         require( _customTreasury != address(0) );
577         customTreasury = ITreasury( _customTreasury );
578         payoutToken = IERC20( ITreasury(_customTreasury).payoutToken() );
579         require( _principalToken != address(0) );
580         principalToken = IERC20( _principalToken );
581         require( _olympusTreasury != address(0) );
582         olympusTreasury = _olympusTreasury;
583         require( _subsidyRouter != address(0) );
584         subsidyRouter = _subsidyRouter;
585         require( _initialOwner != address(0) );
586         policy = _initialOwner;
587         require( _olympusDAO != address(0) );
588         olympusDAO = _olympusDAO;
589         require(_tierCeilings.length == _fees.length, "tier length and fee length not the same");
590 
591         for(uint i; i < _tierCeilings.length; i++) {
592             feeTiers.push( FeeTiers({
593                 tierCeilings: _tierCeilings[i],
594                 fees: _fees[i]
595             }));
596         }
597 
598         feeInPayout = _feeInPayout;
599     }
600 
601     /* ======== INITIALIZATION ======== */
602     
603     /**
604      *  @notice initializes bond parameters
605      *  @param _controlVariable uint
606      *  @param _vestingTerm uint
607      *  @param _minimumPrice uint
608      *  @param _maxPayout uint
609      *  @param _maxDebt uint
610      *  @param _initialDebt uint
611      */
612     function initializeBond( 
613         uint _controlVariable, 
614         uint _vestingTerm,
615         uint _minimumPrice,
616         uint _maxPayout,
617         uint _maxDebt,
618         uint _initialDebt
619     ) external onlyPolicy() {
620         require( currentDebt() == 0, "Debt must be 0 for initialization" );
621         terms = Terms ({
622             controlVariable: _controlVariable,
623             vestingTerm: _vestingTerm,
624             minimumPrice: _minimumPrice,
625             maxPayout: _maxPayout,
626             maxDebt: _maxDebt
627         });
628         totalDebt = _initialDebt;
629         lastDecay = block.number;
630     }
631     
632     
633     /* ======== POLICY FUNCTIONS ======== */
634 
635     enum PARAMETER { VESTING, PAYOUT, DEBT }
636     /**
637      *  @notice set parameters for new bonds
638      *  @param _parameter PARAMETER
639      *  @param _input uint
640      */
641     function setBondTerms ( PARAMETER _parameter, uint _input ) external onlyPolicy() {
642         if ( _parameter == PARAMETER.VESTING ) { // 0
643             require( _input >= 10000, "Vesting must be longer than 36 hours" );
644             terms.vestingTerm = _input;
645         } else if ( _parameter == PARAMETER.PAYOUT ) { // 1
646             require( _input <= 1000, "Payout cannot be above 1 percent" );
647             terms.maxPayout = _input;
648         } else if ( _parameter == PARAMETER.DEBT ) { // 2
649             terms.maxDebt = _input;
650         }
651     }
652 
653     /**
654      *  @notice set control variable adjustment
655      *  @param _addition bool
656      *  @param _increment uint
657      *  @param _target uint
658      *  @param _buffer uint
659      */
660     function setAdjustment ( 
661         bool _addition,
662         uint _increment, 
663         uint _target,
664         uint _buffer 
665     ) external onlyPolicy() {
666         require( _increment <= terms.controlVariable.mul( 30 ).div( 1000 ), "Increment too large" );
667 
668         adjustment = Adjust({
669             add: _addition,
670             rate: _increment,
671             target: _target,
672             buffer: _buffer,
673             lastBlock: block.number
674         });
675     }
676 
677     /**
678      *  @notice change address of Olympus Treasury
679      *  @param _olympusTreasury uint
680      */
681     function changeOlympusTreasury(address _olympusTreasury) external {
682         require( msg.sender == olympusDAO, "Only Olympus DAO" );
683         olympusTreasury = _olympusTreasury;
684     }
685 
686     /**
687      *  @notice subsidy controller checks payouts since last subsidy and resets counter
688      *  @return payoutSinceLastSubsidy_ uint
689      */
690     function paySubsidy() external returns ( uint payoutSinceLastSubsidy_ ) {
691         require( msg.sender == subsidyRouter, "Only subsidy controller" );
692 
693         payoutSinceLastSubsidy_ = payoutSinceLastSubsidy;
694         payoutSinceLastSubsidy = 0;
695     }
696     
697     /* ======== USER FUNCTIONS ======== */
698     
699     /**
700      *  @notice deposit bond
701      *  @param _amount uint
702      *  @param _maxPrice uint
703      *  @param _depositor address
704      *  @return uint
705      */
706     function deposit(uint _amount, uint _maxPrice, address _depositor) external returns (uint) {
707         require( _depositor != address(0), "Invalid address" );
708 
709         decayDebt();
710         
711         uint nativePrice = trueBondPrice();
712 
713         require( _maxPrice >= nativePrice, "Slippage limit: more than max price" ); // slippage protection
714 
715         uint value = customTreasury.valueOfToken( address(principalToken), _amount );
716 
717         uint payout;
718         uint fee;
719 
720         if(feeInPayout) {
721             (payout, fee) = payoutFor( value ); // payout to bonder is computed
722         } else {
723             (payout, fee) = payoutFor( _amount ); // payout to bonder is computed
724             _amount = _amount.sub(fee);
725         }
726 
727         require( payout >= 10 ** payoutToken.decimals() / 100, "Bond too small" ); // must be > 0.01 payout token ( underflow protection )
728         require( payout <= maxPayout(), "Bond too large"); // size protection because there is no slippage
729         
730         // total debt is increased
731         totalDebt = totalDebt.add( value );
732 
733         require( totalDebt <= terms.maxDebt, "Max capacity reached" );
734                 
735         // depositor info is stored
736         bondInfo[ _depositor ] = Bond({ 
737             payout: bondInfo[ _depositor ].payout.add( payout ),
738             vesting: terms.vestingTerm,
739             lastBlock: block.number,
740             truePricePaid: trueBondPrice()
741         });
742 
743         totalPrincipalBonded = totalPrincipalBonded.add(_amount); // total bonded increased
744         totalPayoutGiven = totalPayoutGiven.add(payout); // total payout increased
745         payoutSinceLastSubsidy = payoutSinceLastSubsidy.add( payout ); // subsidy counter increased
746 
747         principalToken.approve( address(customTreasury), _amount );
748 
749         if(feeInPayout) {
750             principalToken.safeTransferFrom( msg.sender, address(this), _amount );
751             customTreasury.deposit( address(principalToken), _amount, payout.add(fee) );
752         } else {
753             principalToken.safeTransferFrom( msg.sender, address(this), _amount.add(fee) );
754             customTreasury.deposit( address(principalToken), _amount, payout );
755         }
756         
757         if ( fee != 0 ) { // fee is transferred to dao 
758             if(feeInPayout) {
759                 payoutToken.safeTransfer(olympusTreasury, fee);
760             } else {
761                 principalToken.safeTransfer( olympusTreasury, fee );
762             }
763         }
764 
765         // indexed events are emitted
766         emit BondCreated( _amount, payout, block.number.add( terms.vestingTerm ) );
767         emit BondPriceChanged( _bondPrice(), debtRatio() );
768 
769         adjust(); // control variable is adjusted
770         return payout; 
771     }
772     
773     /** 
774      *  @notice redeem bond for user
775      *  @return uint
776      */ 
777     function redeem(address _depositor) external returns (uint) {
778         Bond memory info = bondInfo[ _depositor ];
779         uint percentVested = percentVestedFor( _depositor ); // (blocks since last interaction / vesting term remaining)
780 
781         if ( percentVested >= 10000 ) { // if fully vested
782             delete bondInfo[ _depositor ]; // delete user info
783             emit BondRedeemed( _depositor, info.payout, 0 ); // emit bond data
784             payoutToken.safeTransfer( _depositor, info.payout );
785             return info.payout;
786 
787         } else { // if unfinished
788             // calculate payout vested
789             uint payout = info.payout.mul( percentVested ).div( 10000 );
790 
791             // store updated deposit info
792             bondInfo[ _depositor ] = Bond({
793                 payout: info.payout.sub( payout ),
794                 vesting: info.vesting.sub( block.number.sub( info.lastBlock ) ),
795                 lastBlock: block.number,
796                 truePricePaid: info.truePricePaid
797             });
798 
799             emit BondRedeemed( _depositor, payout, bondInfo[ _depositor ].payout );
800             payoutToken.safeTransfer( _depositor, payout );
801             return payout;
802         }
803         
804     }
805     
806     /* ======== INTERNAL HELPER FUNCTIONS ======== */
807 
808     /**
809      *  @notice makes incremental adjustment to control variable
810      */
811     function adjust() internal {
812         uint blockCanAdjust = adjustment.lastBlock.add( adjustment.buffer );
813         if( adjustment.rate != 0 && block.number >= blockCanAdjust ) {
814             uint initial = terms.controlVariable;
815             if ( adjustment.add ) {
816                 terms.controlVariable = terms.controlVariable.add( adjustment.rate );
817                 if ( terms.controlVariable >= adjustment.target ) {
818                     adjustment.rate = 0;
819                 }
820             } else {
821                 terms.controlVariable = terms.controlVariable.sub( adjustment.rate );
822                 if ( terms.controlVariable <= adjustment.target ) {
823                     adjustment.rate = 0;
824                 }
825             }
826             adjustment.lastBlock = block.number;
827             emit ControlVariableAdjustment( initial, terms.controlVariable, adjustment.rate, adjustment.add );
828         }
829     }
830 
831     /**
832      *  @notice reduce total debt
833      */
834     function decayDebt() internal {
835         totalDebt = totalDebt.sub( debtDecay() );
836         lastDecay = block.number;
837     }
838 
839     /**
840      *  @notice calculate current bond price and remove floor if above
841      *  @return price_ uint
842      */
843     function _bondPrice() internal returns ( uint price_ ) {
844         price_ = terms.controlVariable.mul( debtRatio() ).div( 10 ** (uint256(payoutToken.decimals()).sub(5)) );
845         if ( price_ < terms.minimumPrice ) {
846             price_ = terms.minimumPrice;        
847         } else if ( terms.minimumPrice != 0 ) {
848             terms.minimumPrice = 0;
849         }
850     }
851 
852 
853     /* ======== VIEW FUNCTIONS ======== */
854 
855     /**
856      *  @notice calculate current bond premium
857      *  @return price_ uint
858      */
859     function bondPrice() public view returns ( uint price_ ) {        
860         price_ = terms.controlVariable.mul( debtRatio() ).div( 10 ** (uint256(payoutToken.decimals()).sub(5)) );
861         if ( price_ < terms.minimumPrice ) {
862             price_ = terms.minimumPrice;
863         }
864     }
865 
866     /**
867      *  @notice calculate true bond price a user pays
868      *  @return price_ uint
869      */
870     function trueBondPrice() public view returns ( uint price_ ) {
871         price_ = bondPrice().add(bondPrice().mul( currentOlympusFee() ).div( 1e6 ) );
872     }
873 
874     /**
875      *  @notice determine maximum bond size
876      *  @return uint
877      */
878     function maxPayout() public view returns ( uint ) {
879         return payoutToken.totalSupply().mul( terms.maxPayout ).div( 100000 );
880     }
881 
882     /**
883      *  @notice calculate user's interest due for new bond, accounting for Olympus Fee
884      *  @param _value uint
885      *  @return _payout uint
886      *  @return _fee uint
887      */
888     function payoutFor( uint _value ) public view returns ( uint _payout, uint _fee) {
889         if(!feeInPayout) {
890             _fee = _value.mul( currentOlympusFee() ).div( 1e6 );
891             _payout = FixedPoint.fraction( customTreasury.valueOfToken(address(principalToken), _value.sub(_fee)), bondPrice() ).decode112with18().div( 1e11 );
892         } else {
893             uint total = FixedPoint.fraction( _value, bondPrice() ).decode112with18().div( 1e11 );
894             _payout = total.sub(total.mul( currentOlympusFee() ).div( 1e6 ));
895             _fee = total.mul( currentOlympusFee() ).div( 1e6 );
896 
897         }
898     }
899 
900     /**
901      *  @notice calculate current ratio of debt to payout token supply
902      *  @notice protocols using Olympus Pro should be careful when quickly adding large %s to total supply
903      *  @return debtRatio_ uint
904      */
905     function debtRatio() public view returns ( uint debtRatio_ ) {   
906         debtRatio_ = FixedPoint.fraction( 
907             currentDebt().mul( 10 ** payoutToken.decimals() ), 
908             payoutToken.totalSupply()
909         ).decode112with18().div( 1e18 );
910     }
911 
912     /**
913      *  @notice calculate debt factoring in decay
914      *  @return uint
915      */
916     function currentDebt() public view returns ( uint ) {
917         return totalDebt.sub( debtDecay() );
918     }
919 
920     /**
921      *  @notice amount to decay total debt by
922      *  @return decay_ uint
923      */
924     function debtDecay() public view returns ( uint decay_ ) {
925         uint blocksSinceLast = block.number.sub( lastDecay );
926         decay_ = totalDebt.mul( blocksSinceLast ).div( terms.vestingTerm );
927         if ( decay_ > totalDebt ) {
928             decay_ = totalDebt;
929         }
930     }
931 
932     /**
933      *  @notice calculate how far into vesting a depositor is
934      *  @param _depositor address
935      *  @return percentVested_ uint
936      */
937     function percentVestedFor( address _depositor ) public view returns ( uint percentVested_ ) {
938         Bond memory bond = bondInfo[ _depositor ];
939         uint blocksSinceLast = block.number.sub( bond.lastBlock );
940         uint vesting = bond.vesting;
941 
942         if ( vesting > 0 ) {
943             percentVested_ = blocksSinceLast.mul( 10000 ).div( vesting );
944         } else {
945             percentVested_ = 0;
946         }
947     }
948 
949     /**
950      *  @notice calculate amount of payout token available for claim by depositor
951      *  @param _depositor address
952      *  @return pendingPayout_ uint
953      */
954     function pendingPayoutFor( address _depositor ) external view returns ( uint pendingPayout_ ) {
955         uint percentVested = percentVestedFor( _depositor );
956         uint payout = bondInfo[ _depositor ].payout;
957 
958         if ( percentVested >= 10000 ) {
959             pendingPayout_ = payout;
960         } else {
961             pendingPayout_ = payout.mul( percentVested ).div( 10000 );
962         }
963     }
964 
965     /**
966      *  @notice current fee Olympus takes of each bond
967      *  @return currentFee_ uint
968      */
969     function currentOlympusFee() public view returns( uint currentFee_ ) {
970         uint tierLength = feeTiers.length;
971         for(uint i; i < tierLength; i++) {
972             if(totalPrincipalBonded < feeTiers[i].tierCeilings || i == tierLength - 1 ) {
973                 return feeTiers[i].fees;
974             }
975         }
976     }
977     
978 }