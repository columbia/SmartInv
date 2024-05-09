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
482 // File contracts/CustomBond.sol
483 
484 
485 pragma solidity 0.7.5;
486 
487 
488 
489 interface ITreasury {
490     function deposit(address _principleTokenAddress, uint _amountPrincipleToken, uint _amountPayoutToken) external;
491     function valueOfToken( address _principalTokenAddress, uint _amount ) external view returns ( uint value_ );
492     function payoutToken() external view returns (address);
493 }
494 
495 contract CustomBond is Ownable {
496     using FixedPoint for *;
497     using SafeERC20 for IERC20;
498     using SafeMath for uint;
499     
500     /* ======== EVENTS ======== */
501 
502     event BondCreated( uint deposit, uint payout, uint expires );
503     event BondRedeemed( address recipient, uint payout, uint remaining );
504     event BondPriceChanged( uint internalPrice, uint debtRatio );
505     event ControlVariableAdjustment( uint initialBCV, uint newBCV, uint adjustment, bool addition );
506     
507     
508      /* ======== STATE VARIABLES ======== */
509     
510     IERC20 immutable payoutToken; // token paid for principal
511     IERC20 immutable principalToken; // inflow token
512     ITreasury immutable customTreasury; // pays for and receives principal
513     address immutable olympusDAO;
514     address olympusTreasury; // receives fee
515     address immutable subsidyRouter; // pays subsidy in OHM to custom treasury
516 
517     uint public totalPrincipalBonded;
518     uint public totalPayoutGiven;
519     uint public totalDebt; // total value of outstanding bonds; used for pricing
520     uint public lastDecay; // reference block for debt decay
521     uint payoutSinceLastSubsidy; // principal accrued since subsidy paid
522     
523     Terms public terms; // stores terms for new bonds
524     Adjust public adjustment; // stores adjustment to BCV data
525     FeeTiers[] private feeTiers; // stores fee tiers
526 
527     bool immutable private feeInPayout;
528 
529     mapping( address => Bond ) public bondInfo; // stores bond information for depositors
530     
531     /* ======== STRUCTS ======== */
532 
533     struct FeeTiers {
534         uint tierCeilings; // principal bonded till next tier
535         uint fees; // in ten-thousandths (i.e. 33300 = 3.33%)
536     }
537 
538     // Info for creating new bonds
539     struct Terms {
540         uint controlVariable; // scaling variable for price
541         uint vestingTerm; // in blocks
542         uint minimumPrice; // vs principal value
543         uint maxPayout; // in thousandths of a %. i.e. 500 = 0.5%
544         uint maxDebt; // payout token decimal debt ratio, max % total supply created as debt
545     }
546 
547     // Info for bond holder
548     struct Bond {
549         uint payout; // payout token remaining to be paid
550         uint vesting; // Blocks left to vest
551         uint lastBlock; // Last interaction
552         uint truePricePaid; // Price paid (principal tokens per payout token) in ten-millionths - 4000000 = 0.4
553     }
554 
555     // Info for incremental adjustments to control variable 
556     struct Adjust {
557         bool add; // addition or subtraction
558         uint rate; // increment
559         uint target; // BCV when adjustment finished
560         uint buffer; // minimum length (in blocks) between adjustments
561         uint lastBlock; // block when last adjustment made
562     }
563     
564     /* ======== CONSTRUCTOR ======== */
565 
566     constructor(
567         address _customTreasury, 
568         address _principalToken, 
569         address _olympusTreasury,
570         address _subsidyRouter, 
571         address _initialOwner, 
572         address _olympusDAO,
573         uint[] memory _tierCeilings, 
574         uint[] memory _fees,
575         bool _feeInPayout
576     ) {
577         require( _customTreasury != address(0) );
578         customTreasury = ITreasury( _customTreasury );
579         payoutToken = IERC20( ITreasury(_customTreasury).payoutToken() );
580         require( _principalToken != address(0) );
581         principalToken = IERC20( _principalToken );
582         require( _olympusTreasury != address(0) );
583         olympusTreasury = _olympusTreasury;
584         require( _subsidyRouter != address(0) );
585         subsidyRouter = _subsidyRouter;
586         require( _initialOwner != address(0) );
587         policy = _initialOwner;
588         require( _olympusDAO != address(0) );
589         olympusDAO = _olympusDAO;
590         require(_tierCeilings.length == _fees.length, "tier length and fee length not the same");
591 
592         for(uint i; i < _tierCeilings.length; i++) {
593             feeTiers.push( FeeTiers({
594                 tierCeilings: _tierCeilings[i],
595                 fees: _fees[i]
596             }));
597         }
598 
599         feeInPayout = _feeInPayout;
600     }
601 
602     /* ======== INITIALIZATION ======== */
603     
604     /**
605      *  @notice initializes bond parameters
606      *  @param _controlVariable uint
607      *  @param _vestingTerm uint
608      *  @param _minimumPrice uint
609      *  @param _maxPayout uint
610      *  @param _maxDebt uint
611      *  @param _initialDebt uint
612      */
613     function initializeBond( 
614         uint _controlVariable, 
615         uint _vestingTerm,
616         uint _minimumPrice,
617         uint _maxPayout,
618         uint _maxDebt,
619         uint _initialDebt
620     ) external onlyPolicy() {
621         require( currentDebt() == 0, "Debt must be 0 for initialization" );
622         terms = Terms ({
623             controlVariable: _controlVariable,
624             vestingTerm: _vestingTerm,
625             minimumPrice: _minimumPrice,
626             maxPayout: _maxPayout,
627             maxDebt: _maxDebt
628         });
629         totalDebt = _initialDebt;
630         lastDecay = block.number;
631     }
632     
633     
634     /* ======== POLICY FUNCTIONS ======== */
635 
636     enum PARAMETER { VESTING, PAYOUT, DEBT }
637     /**
638      *  @notice set parameters for new bonds
639      *  @param _parameter PARAMETER
640      *  @param _input uint
641      */
642     function setBondTerms ( PARAMETER _parameter, uint _input ) external onlyPolicy() {
643         if ( _parameter == PARAMETER.VESTING ) { // 0
644             require( _input >= 10000, "Vesting must be longer than 36 hours" );
645             terms.vestingTerm = _input;
646         } else if ( _parameter == PARAMETER.PAYOUT ) { // 1
647             require( _input <= 1000, "Payout cannot be above 1 percent" );
648             terms.maxPayout = _input;
649         } else if ( _parameter == PARAMETER.DEBT ) { // 2
650             terms.maxDebt = _input;
651         }
652     }
653 
654     /**
655      *  @notice set control variable adjustment
656      *  @param _addition bool
657      *  @param _increment uint
658      *  @param _target uint
659      *  @param _buffer uint
660      */
661     function setAdjustment ( 
662         bool _addition,
663         uint _increment, 
664         uint _target,
665         uint _buffer 
666     ) external onlyPolicy() {
667         require( _increment <= terms.controlVariable.mul( 30 ).div( 1000 ), "Increment too large" );
668 
669         adjustment = Adjust({
670             add: _addition,
671             rate: _increment,
672             target: _target,
673             buffer: _buffer,
674             lastBlock: block.number
675         });
676     }
677 
678     /**
679      *  @notice change address of Olympus Treasury
680      *  @param _olympusTreasury uint
681      */
682     function changeOlympusTreasury(address _olympusTreasury) external {
683         require( msg.sender == olympusDAO, "Only Olympus DAO" );
684         olympusTreasury = _olympusTreasury;
685     }
686 
687     /**
688      *  @notice subsidy controller checks payouts since last subsidy and resets counter
689      *  @return payoutSinceLastSubsidy_ uint
690      */
691     function paySubsidy() external returns ( uint payoutSinceLastSubsidy_ ) {
692         require( msg.sender == subsidyRouter, "Only subsidy controller" );
693 
694         payoutSinceLastSubsidy_ = payoutSinceLastSubsidy;
695         payoutSinceLastSubsidy = 0;
696     }
697     
698     /* ======== USER FUNCTIONS ======== */
699     
700     /**
701      *  @notice deposit bond
702      *  @param _amount uint
703      *  @param _maxPrice uint
704      *  @param _depositor address
705      *  @return uint
706      */
707     function deposit(uint _amount, uint _maxPrice, address _depositor) external returns (uint) {
708         require( _depositor != address(0), "Invalid address" );
709 
710         decayDebt();
711         
712         uint nativePrice = trueBondPrice();
713 
714         require( _maxPrice >= nativePrice, "Slippage limit: more than max price" ); // slippage protection
715 
716         uint value = customTreasury.valueOfToken( address(principalToken), _amount );
717 
718         uint payout;
719         uint fee;
720 
721         if(feeInPayout) {
722             (payout, fee) = payoutFor( value ); // payout to bonder is computed
723         } else {
724             (payout, fee) = payoutFor( _amount ); // payout to bonder is computed
725             _amount = _amount.sub(fee);
726         }
727 
728         require( payout >= 10 ** payoutToken.decimals() / 100, "Bond too small" ); // must be > 0.01 payout token ( underflow protection )
729         require( payout <= maxPayout(), "Bond too large"); // size protection because there is no slippage
730         
731         // total debt is increased
732         totalDebt = totalDebt.add( value );
733 
734         require( totalDebt <= terms.maxDebt, "Max capacity reached" );
735                 
736         // depositor info is stored
737         bondInfo[ _depositor ] = Bond({ 
738             payout: bondInfo[ _depositor ].payout.add( payout ),
739             vesting: terms.vestingTerm,
740             lastBlock: block.number,
741             truePricePaid: trueBondPrice()
742         });
743 
744         totalPrincipalBonded = totalPrincipalBonded.add(_amount); // total bonded increased
745         totalPayoutGiven = totalPayoutGiven.add(payout); // total payout increased
746         payoutSinceLastSubsidy = payoutSinceLastSubsidy.add( payout ); // subsidy counter increased
747 
748         principalToken.approve( address(customTreasury), _amount );
749 
750         if(feeInPayout) {
751             principalToken.safeTransferFrom( msg.sender, address(this), _amount );
752             customTreasury.deposit( address(principalToken), _amount, payout.add(fee) );
753         } else {
754             principalToken.safeTransferFrom( msg.sender, address(this), _amount.add(fee) );
755             customTreasury.deposit( address(principalToken), _amount, payout );
756         }
757         
758         if ( fee != 0 ) { // fee is transferred to dao 
759             if(feeInPayout) {
760                 payoutToken.safeTransfer(olympusTreasury, fee);
761             } else {
762                 principalToken.safeTransfer( olympusTreasury, fee );
763             }
764         }
765 
766         // indexed events are emitted
767         emit BondCreated( _amount, payout, block.number.add( terms.vestingTerm ) );
768         emit BondPriceChanged( _bondPrice(), debtRatio() );
769 
770         adjust(); // control variable is adjusted
771         return payout; 
772     }
773     
774     /** 
775      *  @notice redeem bond for user
776      *  @return uint
777      */ 
778     function redeem(address _depositor) external returns (uint) {
779         Bond memory info = bondInfo[ _depositor ];
780         uint percentVested = percentVestedFor( _depositor ); // (blocks since last interaction / vesting term remaining)
781 
782         if ( percentVested >= 10000 ) { // if fully vested
783             delete bondInfo[ _depositor ]; // delete user info
784             emit BondRedeemed( _depositor, info.payout, 0 ); // emit bond data
785             payoutToken.safeTransfer( _depositor, info.payout );
786             return info.payout;
787 
788         } else { // if unfinished
789             // calculate payout vested
790             uint payout = info.payout.mul( percentVested ).div( 10000 );
791 
792             // store updated deposit info
793             bondInfo[ _depositor ] = Bond({
794                 payout: info.payout.sub( payout ),
795                 vesting: info.vesting.sub( block.number.sub( info.lastBlock ) ),
796                 lastBlock: block.number,
797                 truePricePaid: info.truePricePaid
798             });
799 
800             emit BondRedeemed( _depositor, payout, bondInfo[ _depositor ].payout );
801             payoutToken.safeTransfer( _depositor, payout );
802             return payout;
803         }
804         
805     }
806     
807     /* ======== INTERNAL HELPER FUNCTIONS ======== */
808 
809     /**
810      *  @notice makes incremental adjustment to control variable
811      */
812     function adjust() internal {
813         uint blockCanAdjust = adjustment.lastBlock.add( adjustment.buffer );
814         if( adjustment.rate != 0 && block.number >= blockCanAdjust ) {
815             uint initial = terms.controlVariable;
816             if ( adjustment.add ) {
817                 terms.controlVariable = terms.controlVariable.add( adjustment.rate );
818                 if ( terms.controlVariable >= adjustment.target ) {
819                     adjustment.rate = 0;
820                 }
821             } else {
822                 terms.controlVariable = terms.controlVariable.sub( adjustment.rate );
823                 if ( terms.controlVariable <= adjustment.target ) {
824                     adjustment.rate = 0;
825                 }
826             }
827             adjustment.lastBlock = block.number;
828             emit ControlVariableAdjustment( initial, terms.controlVariable, adjustment.rate, adjustment.add );
829         }
830     }
831 
832     /**
833      *  @notice reduce total debt
834      */
835     function decayDebt() internal {
836         totalDebt = totalDebt.sub( debtDecay() );
837         lastDecay = block.number;
838     }
839 
840     /**
841      *  @notice calculate current bond price and remove floor if above
842      *  @return price_ uint
843      */
844     function _bondPrice() internal returns ( uint price_ ) {
845         price_ = terms.controlVariable.mul( debtRatio() ).div( 10 ** (uint256(payoutToken.decimals()).sub(8)) );
846         if ( price_ < terms.minimumPrice ) {
847             price_ = terms.minimumPrice;        
848         } else if ( terms.minimumPrice != 0 ) {
849             terms.minimumPrice = 0;
850         }
851     }
852 
853 
854     /* ======== VIEW FUNCTIONS ======== */
855 
856     /**
857      *  @notice calculate current bond premium
858      *  @return price_ uint
859      */
860     function bondPrice() public view returns ( uint price_ ) {        
861         price_ = terms.controlVariable.mul( debtRatio() ).div( 10 ** (uint256(payoutToken.decimals()).sub(8)) );
862         if ( price_ < terms.minimumPrice ) {
863             price_ = terms.minimumPrice;
864         }
865     }
866 
867     /**
868      *  @notice calculate true bond price a user pays
869      *  @return price_ uint
870      */
871     function trueBondPrice() public view returns ( uint price_ ) {
872         price_ = bondPrice().add(bondPrice().mul( currentOlympusFee() ).div( 1e6 ) );
873     }
874 
875     /**
876      *  @notice determine maximum bond size
877      *  @return uint
878      */
879     function maxPayout() public view returns ( uint ) {
880         return payoutToken.totalSupply().mul( terms.maxPayout ).div( 100000 );
881     }
882 
883     /**
884      *  @notice calculate user's interest due for new bond, accounting for Olympus Fee. 
885      If fee is in payout then takes in the already calculated value. If fee is in principal token 
886      then takes in the amount of principal being deposited and then calculates the fee based on
887      the amount of principal token
888      *  @param _value uint
889      *  @return _payout uint
890      *  @return _fee uint
891      */
892     function payoutFor( uint _value ) public view returns ( uint _payout, uint _fee) {
893         if(feeInPayout) {
894             uint total = FixedPoint.fraction( _value, bondPrice() ).decode112with18().div( 1e8 );
895             _fee = total.mul( currentOlympusFee() ).div( 1e6 );
896             _payout = total.sub(_fee);
897         } else {
898             _fee = _value.mul( currentOlympusFee() ).div( 1e6 );
899             _payout = FixedPoint.fraction( customTreasury.valueOfToken(address(principalToken), _value.sub(_fee)), bondPrice() ).decode112with18().div( 1e8 );
900         }
901     }
902 
903     /**
904      *  @notice calculate current ratio of debt to payout token supply
905      *  @notice protocols using Olympus Pro should be careful when quickly adding large %s to total supply
906      *  @return debtRatio_ uint
907      */
908     function debtRatio() public view returns ( uint debtRatio_ ) {   
909         debtRatio_ = FixedPoint.fraction( 
910             currentDebt().mul( 10 ** payoutToken.decimals() ), 
911             payoutToken.totalSupply()
912         ).decode112with18().div( 1e18 );
913     }
914 
915     /**
916      *  @notice calculate debt factoring in decay
917      *  @return uint
918      */
919     function currentDebt() public view returns ( uint ) {
920         return totalDebt.sub( debtDecay() );
921     }
922 
923     /**
924      *  @notice amount to decay total debt by
925      *  @return decay_ uint
926      */
927     function debtDecay() public view returns ( uint decay_ ) {
928         uint blocksSinceLast = block.number.sub( lastDecay );
929         decay_ = totalDebt.mul( blocksSinceLast ).div( terms.vestingTerm );
930         if ( decay_ > totalDebt ) {
931             decay_ = totalDebt;
932         }
933     }
934 
935     /**
936      *  @notice calculate how far into vesting a depositor is
937      *  @param _depositor address
938      *  @return percentVested_ uint
939      */
940     function percentVestedFor( address _depositor ) public view returns ( uint percentVested_ ) {
941         Bond memory bond = bondInfo[ _depositor ];
942         uint blocksSinceLast = block.number.sub( bond.lastBlock );
943         uint vesting = bond.vesting;
944 
945         if ( vesting > 0 ) {
946             percentVested_ = blocksSinceLast.mul( 10000 ).div( vesting );
947         } else {
948             percentVested_ = 0;
949         }
950     }
951 
952     /**
953      *  @notice calculate amount of payout token available for claim by depositor
954      *  @param _depositor address
955      *  @return pendingPayout_ uint
956      */
957     function pendingPayoutFor( address _depositor ) external view returns ( uint pendingPayout_ ) {
958         uint percentVested = percentVestedFor( _depositor );
959         uint payout = bondInfo[ _depositor ].payout;
960 
961         if ( percentVested >= 10000 ) {
962             pendingPayout_ = payout;
963         } else {
964             pendingPayout_ = payout.mul( percentVested ).div( 10000 );
965         }
966     }
967 
968     /**
969      *  @notice current fee Olympus takes of each bond
970      *  @return currentFee_ uint
971      */
972     function currentOlympusFee() public view returns( uint currentFee_ ) {
973         uint tierLength = feeTiers.length;
974         for(uint i; i < tierLength; i++) {
975             if(totalPrincipalBonded < feeTiers[i].tierCeilings || i == tierLength - 1 ) {
976                 return feeTiers[i].fees;
977             }
978         }
979     }
980     
981 }