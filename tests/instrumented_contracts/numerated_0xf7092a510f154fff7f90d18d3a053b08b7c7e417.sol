1 pragma solidity 0.7.5;
2 
3 
4 library SafeMath {
5 
6     function add(uint256 a, uint256 b) internal pure returns (uint256) {
7         uint256 c = a + b;
8         require(c >= a, "SafeMath: addition overflow");
9 
10         return c;
11     }
12 
13     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
14         return sub(a, b, "SafeMath: subtraction overflow");
15     }
16 
17     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
18         require(b <= a, errorMessage);
19         uint256 c = a - b;
20 
21         return c;
22     }
23 
24     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
25         if (a == 0) {
26             return 0;
27         }
28 
29         uint256 c = a * b;
30         require(c / a == b, "SafeMath: multiplication overflow");
31 
32         return c;
33     }
34 
35     function div(uint256 a, uint256 b) internal pure returns (uint256) {
36         return div(a, b, "SafeMath: division by zero");
37     }
38 
39     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
40         require(b > 0, errorMessage);
41         uint256 c = a / b;
42         return c;
43     }
44 
45     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
46         return mod(a, b, "SafeMath: modulo by zero");
47     }
48 
49     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
50         require(b != 0, errorMessage);
51         return a % b;
52     }
53 
54     function sqrrt(uint256 a) internal pure returns (uint c) {
55         if (a > 3) {
56             c = a;
57             uint b = add( div( a, 2), 1 );
58             while (b < c) {
59                 c = b;
60                 b = div( add( div( a, b ), b), 2 );
61             }
62         } else if (a != 0) {
63             c = 1;
64         }
65     }
66 }
67 
68 pragma solidity 0.7.5;
69 
70 
71 library Address {
72 
73     function isContract(address account) internal view returns (bool) {
74 
75         uint256 size;
76         // solhint-disable-next-line no-inline-assembly
77         assembly { size := extcodesize(account) }
78         return size > 0;
79     }
80 
81     function sendValue(address payable recipient, uint256 amount) internal {
82         require(address(this).balance >= amount, "Address: insufficient balance");
83 
84         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
85         (bool success, ) = recipient.call{ value: amount }("");
86         require(success, "Address: unable to send value, recipient may have reverted");
87     }
88 
89     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
90       return functionCall(target, data, "Address: low-level call failed");
91     }
92 
93     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
94         return _functionCallWithValue(target, data, 0, errorMessage);
95     }
96 
97     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
98         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
99     }
100 
101     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
102         require(address(this).balance >= value, "Address: insufficient balance for call");
103         require(isContract(target), "Address: call to non-contract");
104 
105         // solhint-disable-next-line avoid-low-level-calls
106         (bool success, bytes memory returndata) = target.call{ value: value }(data);
107         return _verifyCallResult(success, returndata, errorMessage);
108     }
109 
110     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
111         require(isContract(target), "Address: call to non-contract");
112 
113         // solhint-disable-next-line avoid-low-level-calls
114         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
115         if (success) {
116             return returndata;
117         } else {
118             // Look for revert reason and bubble it up if present
119             if (returndata.length > 0) {
120                 // The easiest way to bubble the revert reason is using memory via assembly
121 
122                 // solhint-disable-next-line no-inline-assembly
123                 assembly {
124                     let returndata_size := mload(returndata)
125                     revert(add(32, returndata), returndata_size)
126                 }
127             } else {
128                 revert(errorMessage);
129             }
130         }
131     }
132 
133     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
134         return functionStaticCall(target, data, "Address: low-level static call failed");
135     }
136 
137     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
138         require(isContract(target), "Address: static call to non-contract");
139 
140         // solhint-disable-next-line avoid-low-level-calls
141         (bool success, bytes memory returndata) = target.staticcall(data);
142         return _verifyCallResult(success, returndata, errorMessage);
143     }
144 
145     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
146         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
147     }
148 
149     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
150         require(isContract(target), "Address: delegate call to non-contract");
151 
152         // solhint-disable-next-line avoid-low-level-calls
153         (bool success, bytes memory returndata) = target.delegatecall(data);
154         return _verifyCallResult(success, returndata, errorMessage);
155     }
156 
157     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
158         if (success) {
159             return returndata;
160         } else {
161             if (returndata.length > 0) {
162 
163                 assembly {
164                     let returndata_size := mload(returndata)
165                     revert(add(32, returndata), returndata_size)
166                 }
167             } else {
168                 revert(errorMessage);
169             }
170         }
171     }
172 
173     function addressToString(address _address) internal pure returns(string memory) {
174         bytes32 _bytes = bytes32(uint256(_address));
175         bytes memory HEX = "0123456789abcdef";
176         bytes memory _addr = new bytes(42);
177 
178         _addr[0] = '0';
179         _addr[1] = 'x';
180 
181         for(uint256 i = 0; i < 20; i++) {
182             _addr[2+i*2] = HEX[uint8(_bytes[i + 12] >> 4)];
183             _addr[3+i*2] = HEX[uint8(_bytes[i + 12] & 0x0f)];
184         }
185 
186         return string(_addr);
187 
188     }
189 }
190 
191 pragma solidity 0.7.5;
192 
193 interface IERC20 {
194     function decimals() external view returns (uint8);
195 
196     function totalSupply() external view returns (uint256);
197 
198     function balanceOf(address account) external view returns (uint256);
199 
200     function transfer(address recipient, uint256 amount) external returns (bool);
201 
202     function allowance(address owner, address spender) external view returns (uint256);
203 
204     function approve(address spender, uint256 amount) external returns (bool);
205 
206     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
207 
208     event Transfer(address indexed from, address indexed to, uint256 value);
209 
210     event Approval(address indexed owner, address indexed spender, uint256 value);
211 }
212 
213 pragma solidity 0.7.5;
214 
215 
216 library SafeERC20 {
217     using SafeMath for uint256;
218     using Address for address;
219 
220     function safeTransfer(IERC20 token, address to, uint256 value) internal {
221         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
222     }
223 
224     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
225         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
226     }
227 
228     function safeApprove(IERC20 token, address spender, uint256 value) internal {
229 
230         require((value == 0) || (token.allowance(address(this), spender) == 0),
231             "SafeERC20: approve from non-zero to non-zero allowance"
232         );
233         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
234     }
235 
236     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
237         uint256 newAllowance = token.allowance(address(this), spender).add(value);
238         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
239     }
240 
241     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
242         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
243         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
244     }
245 
246     function _callOptionalReturn(IERC20 token, bytes memory data) private {
247 
248         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
249         if (returndata.length > 0) { // Return data is optional
250             // solhint-disable-next-line max-line-length
251             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
252         }
253     }
254 }
255 
256 
257 // File contracts/libraries/FullMath.sol
258 
259 pragma solidity 0.7.5;
260 
261 library FullMath {
262     function fullMul(uint256 x, uint256 y) private pure returns (uint256 l, uint256 h) {
263         uint256 mm = mulmod(x, y, uint256(-1));
264         l = x * y;
265         h = mm - l;
266         if (mm < l) h -= 1;
267     }
268 
269     function fullDiv(
270         uint256 l,
271         uint256 h,
272         uint256 d
273     ) private pure returns (uint256) {
274         uint256 pow2 = d & -d;
275         d /= pow2;
276         l /= pow2;
277         l += h * ((-pow2) / pow2 + 1);
278         uint256 r = 1;
279         r *= 2 - d * r;
280         r *= 2 - d * r;
281         r *= 2 - d * r;
282         r *= 2 - d * r;
283         r *= 2 - d * r;
284         r *= 2 - d * r;
285         r *= 2 - d * r;
286         r *= 2 - d * r;
287         return l * r;
288     }
289 
290     function mulDiv(
291         uint256 x,
292         uint256 y,
293         uint256 d
294     ) internal pure returns (uint256) {
295         (uint256 l, uint256 h) = fullMul(x, y);
296         uint256 mm = mulmod(x, y, d);
297         if (mm > l) h -= 1;
298         l -= mm;
299         require(h < d, 'FullMath::mulDiv: overflow');
300         return fullDiv(l, h, d);
301     }
302 }
303 
304 
305 // File contracts/libraries/FixedPoint.sol
306 
307 pragma solidity 0.7.5;
308 
309 library Babylonian {
310 
311     function sqrt(uint256 x) internal pure returns (uint256) {
312         if (x == 0) return 0;
313 
314         uint256 xx = x;
315         uint256 r = 1;
316         if (xx >= 0x100000000000000000000000000000000) {
317             xx >>= 128;
318             r <<= 64;
319         }
320         if (xx >= 0x10000000000000000) {
321             xx >>= 64;
322             r <<= 32;
323         }
324         if (xx >= 0x100000000) {
325             xx >>= 32;
326             r <<= 16;
327         }
328         if (xx >= 0x10000) {
329             xx >>= 16;
330             r <<= 8;
331         }
332         if (xx >= 0x100) {
333             xx >>= 8;
334             r <<= 4;
335         }
336         if (xx >= 0x10) {
337             xx >>= 4;
338             r <<= 2;
339         }
340         if (xx >= 0x8) {
341             r <<= 1;
342         }
343         r = (r + x / r) >> 1;
344         r = (r + x / r) >> 1;
345         r = (r + x / r) >> 1;
346         r = (r + x / r) >> 1;
347         r = (r + x / r) >> 1;
348         r = (r + x / r) >> 1;
349         r = (r + x / r) >> 1; // Seven iterations should be enough
350         uint256 r1 = x / r;
351         return (r < r1 ? r : r1);
352     }
353 }
354 
355 library BitMath {
356 
357     function mostSignificantBit(uint256 x) internal pure returns (uint8 r) {
358         require(x > 0, 'BitMath::mostSignificantBit: zero');
359 
360         if (x >= 0x100000000000000000000000000000000) {
361             x >>= 128;
362             r += 128;
363         }
364         if (x >= 0x10000000000000000) {
365             x >>= 64;
366             r += 64;
367         }
368         if (x >= 0x100000000) {
369             x >>= 32;
370             r += 32;
371         }
372         if (x >= 0x10000) {
373             x >>= 16;
374             r += 16;
375         }
376         if (x >= 0x100) {
377             x >>= 8;
378             r += 8;
379         }
380         if (x >= 0x10) {
381             x >>= 4;
382             r += 4;
383         }
384         if (x >= 0x4) {
385             x >>= 2;
386             r += 2;
387         }
388         if (x >= 0x2) r += 1;
389     }
390 }
391 
392 
393 library FixedPoint {
394 
395     struct uq112x112 {
396         uint224 _x;
397     }
398 
399     struct uq144x112 {
400         uint256 _x;
401     }
402 
403     uint8 private constant RESOLUTION = 112;
404     uint256 private constant Q112 = 0x10000000000000000000000000000;
405     uint256 private constant Q224 = 0x100000000000000000000000000000000000000000000000000000000;
406     uint256 private constant LOWER_MASK = 0xffffffffffffffffffffffffffff; // decimal of UQ*x112 (lower 112 bits)
407 
408     function decode(uq112x112 memory self) internal pure returns (uint112) {
409         return uint112(self._x >> RESOLUTION);
410     }
411 
412     function decode112with18(uq112x112 memory self) internal pure returns (uint) {
413 
414         return uint(self._x) / 5192296858534827;
415     }
416 
417     function fraction(uint256 numerator, uint256 denominator) internal pure returns (uq112x112 memory) {
418         require(denominator > 0, 'FixedPoint::fraction: division by zero');
419         if (numerator == 0) return FixedPoint.uq112x112(0);
420 
421         if (numerator <= uint144(-1)) {
422             uint256 result = (numerator << RESOLUTION) / denominator;
423             require(result <= uint224(-1), 'FixedPoint::fraction: overflow');
424             return uq112x112(uint224(result));
425         } else {
426             uint256 result = FullMath.mulDiv(numerator, Q112, denominator);
427             require(result <= uint224(-1), 'FixedPoint::fraction: overflow');
428             return uq112x112(uint224(result));
429         }
430     }
431     
432     // square root of a UQ112x112
433     // lossy between 0/1 and 40 bits
434     function sqrt(uq112x112 memory self) internal pure returns (uq112x112 memory) {
435         if (self._x <= uint144(-1)) {
436             return uq112x112(uint224(Babylonian.sqrt(uint256(self._x) << 112)));
437         }
438 
439         uint8 safeShiftBits = 255 - BitMath.mostSignificantBit(self._x);
440         safeShiftBits -= safeShiftBits % 2;
441         return uq112x112(uint224(Babylonian.sqrt(uint256(self._x) << safeShiftBits) << ((112 - safeShiftBits) / 2)));
442     }
443 }
444 
445 
446 // File contracts/interfaces/ITreasury.sol
447 
448 pragma solidity 0.7.5;
449 
450 interface ITreasury {
451     function sendPayoutTokens(uint _amountPayoutToken) external;
452     function valueOfToken( address _principalTokenAddress, uint _amount ) external view returns ( uint value_ );
453     function payoutToken() external view returns (address);
454 }
455 
456 
457 // File contracts/types/Ownable.sol
458 
459 pragma solidity 0.7.5;
460 
461 contract Ownable {
462 
463     address public policy;
464 
465     constructor () {
466         policy = msg.sender;
467     }
468 
469     modifier onlyPolicy() {
470         require( policy == msg.sender, "Ownable: caller is not the owner" );
471         _;
472     }
473     
474     function transferManagment(address _newOwner) external onlyPolicy() {
475         require( _newOwner != address(0) );
476         policy = _newOwner;
477     }
478 }
479 
480 
481 // File contracts/OlympusProCustomBond.sol
482 
483 // SPDX-License-Identifier: AGPL-3.0-or-later
484 pragma solidity 0.7.5;
485 
486 
487 
488 
489 contract CustomBond is Ownable {
490     using FixedPoint for *;
491     using SafeERC20 for IERC20;
492     using SafeMath for uint;
493     
494     /* ======== EVENTS ======== */
495 
496     event BondCreated( uint deposit, uint payout, uint expires );
497     event BondRedeemed( address recipient, uint payout, uint remaining );
498     event BondPriceChanged( uint internalPrice, uint debtRatio );
499     event ControlVariableAdjustment( uint initialBCV, uint newBCV, uint adjustment, bool addition );
500     
501     
502      /* ======== STATE VARIABLES ======== */
503     
504     IERC20 immutable private payoutToken; // token paid for principal
505     IERC20 immutable private principalToken; // inflow token
506     ITreasury immutable private customTreasury; // pays for and receives principal
507     address immutable private olympusDAO;
508     address private olympusTreasury; // receives fee
509     address immutable private subsidyRouter; // pays subsidy in OHM to custom treasury
510 
511     uint public totalPrincipalBonded;
512     uint public totalPayoutGiven;
513     uint public totalDebt; // total value of outstanding bonds; used for pricing
514     uint public lastDecay; // reference block for debt decay
515     uint private payoutSinceLastSubsidy; // principal accrued since subsidy paid
516     
517     Terms public terms; // stores terms for new bonds
518     Adjust public adjustment; // stores adjustment to BCV data
519     FeeTiers[] private feeTiers; // stores fee tiers
520 
521     bool immutable private feeInPayout;
522 
523     mapping( address => Bond ) public bondInfo; // stores bond information for depositors
524     
525     /* ======== STRUCTS ======== */
526 
527     struct FeeTiers {
528         uint tierCeilings; // principal bonded till next tier
529         uint fees; // in ten-thousandths (i.e. 33300 = 3.33%)
530     }
531 
532     // Info for creating new bonds
533     struct Terms {
534         uint controlVariable; // scaling variable for price
535         uint vestingTerm; // in blocks
536         uint minimumPrice; // vs principal value
537         uint maxPayout; // in thousandths of a %. i.e. 500 = 0.5%
538         uint maxDebt; // payout token decimal debt ratio, max % total supply created as debt
539     }
540 
541     // Info for bond holder
542     struct Bond {
543         uint payout; // payout token remaining to be paid
544         uint vesting; // Blocks left to vest
545         uint lastBlock; // Last interaction
546         uint truePricePaid; // Price paid (principal tokens per payout token) in ten-millionths - 4000000 = 0.4
547     }
548 
549     // Info for incremental adjustments to control variable 
550     struct Adjust {
551         bool add; // addition or subtraction
552         uint rate; // increment
553         uint target; // BCV when adjustment finished
554         uint buffer; // minimum length (in blocks) between adjustments
555         uint lastBlock; // block when last adjustment made
556     }
557     
558     /* ======== CONSTRUCTOR ======== */
559 
560     constructor(
561         address _customTreasury, 
562         address _principalToken, 
563         address _olympusTreasury,
564         address _subsidyRouter, 
565         address _initialOwner, 
566         address _olympusDAO,
567         uint[] memory _tierCeilings, 
568         uint[] memory _fees,
569         bool _feeInPayout
570     ) {
571         require( _customTreasury != address(0) );
572         customTreasury = ITreasury( _customTreasury );
573         payoutToken = IERC20( ITreasury(_customTreasury).payoutToken() );
574         require( _principalToken != address(0) );
575         principalToken = IERC20( _principalToken );
576         require( _olympusTreasury != address(0) );
577         olympusTreasury = _olympusTreasury;
578         require( _subsidyRouter != address(0) );
579         subsidyRouter = _subsidyRouter;
580         require( _initialOwner != address(0) );
581         policy = _initialOwner;
582         require( _olympusDAO != address(0) );
583         olympusDAO = _olympusDAO;
584         require(_tierCeilings.length == _fees.length, "tier length and fee length not the same");
585 
586         for(uint i; i < _tierCeilings.length; i++) {
587             feeTiers.push( FeeTiers({
588                 tierCeilings: _tierCeilings[i],
589                 fees: _fees[i]
590             }));
591         }
592 
593         feeInPayout = _feeInPayout;
594     }
595 
596     /* ======== INITIALIZATION ======== */
597     
598     /**
599      *  @notice initializes bond parameters
600      *  @param _controlVariable uint
601      *  @param _vestingTerm uint
602      *  @param _minimumPrice uint
603      *  @param _maxPayout uint
604      *  @param _maxDebt uint
605      *  @param _initialDebt uint
606      */
607     function initializeBond( 
608         uint _controlVariable, 
609         uint _vestingTerm,
610         uint _minimumPrice,
611         uint _maxPayout,
612         uint _maxDebt,
613         uint _initialDebt
614     ) external onlyPolicy() {
615         require( currentDebt() == 0, "Debt must be 0 for initialization" );
616         terms = Terms ({
617             controlVariable: _controlVariable,
618             vestingTerm: _vestingTerm,
619             minimumPrice: _minimumPrice,
620             maxPayout: _maxPayout,
621             maxDebt: _maxDebt
622         });
623         totalDebt = _initialDebt;
624         lastDecay = block.number;
625     }
626     
627     
628     /* ======== POLICY FUNCTIONS ======== */
629 
630     enum PARAMETER { VESTING, PAYOUT, DEBT }
631     /**
632      *  @notice set parameters for new bonds
633      *  @param _parameter PARAMETER
634      *  @param _input uint
635      */
636     function setBondTerms ( PARAMETER _parameter, uint _input ) external onlyPolicy() {
637         if ( _parameter == PARAMETER.VESTING ) { // 0
638             require( _input >= 10000, "Vesting must be longer than 36 hours" );
639             terms.vestingTerm = _input;
640         } else if ( _parameter == PARAMETER.PAYOUT ) { // 1
641             require( _input <= 1000, "Payout cannot be above 1 percent" );
642             terms.maxPayout = _input;
643         } else if ( _parameter == PARAMETER.DEBT ) { // 2
644             terms.maxDebt = _input;
645         }
646     }
647 
648     /**
649      *  @notice set control variable adjustment
650      *  @param _addition bool
651      *  @param _increment uint
652      *  @param _target uint
653      *  @param _buffer uint
654      */
655     function setAdjustment ( 
656         bool _addition,
657         uint _increment, 
658         uint _target,
659         uint _buffer 
660     ) external onlyPolicy() {
661         require( _increment <= terms.controlVariable.mul( 30 ).div( 1000 ), "Increment too large" );
662 
663         adjustment = Adjust({
664             add: _addition,
665             rate: _increment,
666             target: _target,
667             buffer: _buffer,
668             lastBlock: block.number
669         });
670     }
671 
672     /**
673      *  @notice change address of Olympus Treasury
674      *  @param _olympusTreasury uint
675      */
676     function changeOlympusTreasury(address _olympusTreasury) external {
677         require( msg.sender == olympusDAO, "Only Olympus DAO" );
678         olympusTreasury = _olympusTreasury;
679     }
680 
681     /**
682      *  @notice subsidy controller checks payouts since last subsidy and resets counter
683      *  @return payoutSinceLastSubsidy_ uint
684      */
685     function paySubsidy() external returns ( uint payoutSinceLastSubsidy_ ) {
686         require( msg.sender == subsidyRouter, "Only subsidy controller" );
687 
688         payoutSinceLastSubsidy_ = payoutSinceLastSubsidy;
689         payoutSinceLastSubsidy = 0;
690     }
691     
692     /* ======== USER FUNCTIONS ======== */
693     
694     /**
695      *  @notice deposit bond
696      *  @param _amount uint
697      *  @param _maxPrice uint
698      *  @param _depositor address
699      *  @return uint
700      */
701     function deposit(uint _amount, uint _maxPrice, address _depositor) external returns (uint) {
702         require( _depositor != address(0), "Invalid address" );
703 
704         decayDebt();
705         
706         uint nativePrice = trueBondPrice();
707 
708         require( _maxPrice >= nativePrice, "Slippage limit: more than max price" ); // slippage protection
709 
710         uint value = customTreasury.valueOfToken( address(principalToken), _amount );
711 
712         uint payout;
713         uint fee;
714 
715         if(feeInPayout) {
716             (payout, fee) = payoutFor( value ); // payout and fee is computed
717         } else {
718             (payout, fee) = payoutFor( _amount ); // payout and fee is computed
719             _amount = _amount.sub(fee);
720         }
721 
722         require( payout >= 10 ** payoutToken.decimals() / 100, "Bond too small" ); // must be > 0.01 payout token ( underflow protection )
723         require( payout <= maxPayout(), "Bond too large"); // size protection because there is no slippage
724         
725         // total debt is increased
726         totalDebt = totalDebt.add( value );
727 
728         require( totalDebt <= terms.maxDebt, "Max capacity reached" );
729                 
730         // depositor info is stored
731         bondInfo[ _depositor ] = Bond({ 
732             payout: bondInfo[ _depositor ].payout.add( payout ),
733             vesting: terms.vestingTerm,
734             lastBlock: block.number,
735             truePricePaid: trueBondPrice()
736         });
737 
738         totalPrincipalBonded = totalPrincipalBonded.add(_amount); // total bonded increased
739         totalPayoutGiven = totalPayoutGiven.add(payout); // total payout increased
740         payoutSinceLastSubsidy = payoutSinceLastSubsidy.add( payout ); // subsidy counter increased
741 
742         if(feeInPayout) {
743             customTreasury.sendPayoutTokens( payout.add(fee) );
744             if(fee != 0) { // if fee, send to Olympus treasury
745                 payoutToken.safeTransfer(olympusTreasury, fee);
746             }
747         } else {
748             customTreasury.sendPayoutTokens( payout );
749             if(fee != 0) { // if fee, send to Olympus treasury
750                 principalToken.safeTransferFrom( msg.sender, olympusTreasury, fee );
751             }
752         }
753 
754         principalToken.safeTransferFrom( msg.sender, address(customTreasury), _amount ); // transfer principal bonded to custom treasury
755 
756         // indexed events are emitted
757         emit BondCreated( _amount, payout, block.number.add( terms.vestingTerm ) );
758         emit BondPriceChanged( _bondPrice(), debtRatio() );
759 
760         adjust(); // control variable is adjusted
761         return payout; 
762     }
763     
764     /** 
765      *  @notice redeem bond for user
766      *  @return uint
767      */ 
768     function redeem(address _depositor) external returns (uint) {
769         Bond memory info = bondInfo[ _depositor ];
770         uint percentVested = percentVestedFor( _depositor ); // (blocks since last interaction / vesting term remaining)
771 
772         if ( percentVested >= 10000 ) { // if fully vested
773             delete bondInfo[ _depositor ]; // delete user info
774             emit BondRedeemed( _depositor, info.payout, 0 ); // emit bond data
775             payoutToken.safeTransfer( _depositor, info.payout );
776             return info.payout;
777 
778         } else { // if unfinished
779             // calculate payout vested
780             uint payout = info.payout.mul( percentVested ).div( 10000 );
781 
782             // store updated deposit info
783             bondInfo[ _depositor ] = Bond({
784                 payout: info.payout.sub( payout ),
785                 vesting: info.vesting.sub( block.number.sub( info.lastBlock ) ),
786                 lastBlock: block.number,
787                 truePricePaid: info.truePricePaid
788             });
789 
790             emit BondRedeemed( _depositor, payout, bondInfo[ _depositor ].payout );
791             payoutToken.safeTransfer( _depositor, payout );
792             return payout;
793         }
794         
795     }
796     
797     /* ======== INTERNAL HELPER FUNCTIONS ======== */
798 
799     /**
800      *  @notice makes incremental adjustment to control variable
801      */
802     function adjust() internal {
803         uint blockCanAdjust = adjustment.lastBlock.add( adjustment.buffer );
804         if( adjustment.rate != 0 && block.number >= blockCanAdjust ) {
805             uint initial = terms.controlVariable;
806             if ( adjustment.add ) {
807                 terms.controlVariable = terms.controlVariable.add( adjustment.rate );
808                 if ( terms.controlVariable >= adjustment.target ) {
809                     adjustment.rate = 0;
810                 }
811             } else {
812                 terms.controlVariable = terms.controlVariable.sub( adjustment.rate );
813                 if ( terms.controlVariable <= adjustment.target ) {
814                     adjustment.rate = 0;
815                 }
816             }
817             adjustment.lastBlock = block.number;
818             emit ControlVariableAdjustment( initial, terms.controlVariable, adjustment.rate, adjustment.add );
819         }
820     }
821 
822     /**
823      *  @notice reduce total debt
824      */
825     function decayDebt() internal {
826         totalDebt = totalDebt.sub( debtDecay() );
827         lastDecay = block.number;
828     }
829 
830     /**
831      *  @notice calculate current bond price and remove floor if above
832      *  @return price_ uint
833      */
834     function _bondPrice() internal returns ( uint price_ ) {
835         price_ = terms.controlVariable.mul( debtRatio() ).div( 10 ** (uint256(payoutToken.decimals()).sub(5)) );
836         if ( price_ < terms.minimumPrice ) {
837             price_ = terms.minimumPrice;        
838         } else if ( terms.minimumPrice != 0 ) {
839             terms.minimumPrice = 0;
840         }
841     }
842 
843 
844     /* ======== VIEW FUNCTIONS ======== */
845 
846     /**
847      *  @notice calculate current bond premium
848      *  @return price_ uint
849      */
850     function bondPrice() public view returns ( uint price_ ) {        
851         price_ = terms.controlVariable.mul( debtRatio() ).div( 10 ** (uint256(payoutToken.decimals()).sub(5)) );
852         if ( price_ < terms.minimumPrice ) {
853             price_ = terms.minimumPrice;
854         }
855     }
856 
857     /**
858      *  @notice calculate true bond price a user pays
859      *  @return price_ uint
860      */
861     function trueBondPrice() public view returns ( uint price_ ) {
862         price_ = bondPrice().add(bondPrice().mul( currentOlympusFee() ).div( 1e6 ) );
863     }
864 
865     /**
866      *  @notice determine maximum bond size
867      *  @return uint
868      */
869     function maxPayout() public view returns ( uint ) {
870         return payoutToken.totalSupply().mul( terms.maxPayout ).div( 100000 );
871     }
872 
873     /**
874      *  @notice calculate user's interest due for new bond, accounting for Olympus Fee. 
875      If fee is in payout then takes in the already calcualted value. If fee is in principal token 
876      than takes in the amount of principal being deposited and then calculautes the fee based on
877      the amount of principal and not in terms of the payout token
878      *  @param _value uint
879      *  @return _payout uint
880      *  @return _fee uint
881      */
882     function payoutFor( uint _value ) public view returns ( uint _payout, uint _fee) {
883         if(feeInPayout) {
884             uint total = FixedPoint.fraction( _value, bondPrice() ).decode112with18().div( 1e11 );
885             _fee = total.mul( currentOlympusFee() ).div( 1e6 );
886             _payout = total.sub(_fee);
887         } else {
888             _fee = _value.mul( currentOlympusFee() ).div( 1e6 );
889             _payout = FixedPoint.fraction( customTreasury.valueOfToken(address(principalToken), _value.sub(_fee)), bondPrice() ).decode112with18().div( 1e11 );
890         }
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
925     /**
926      *  @notice calculate how far into vesting a depositor is
927      *  @param _depositor address
928      *  @return percentVested_ uint
929      */
930     function percentVestedFor( address _depositor ) public view returns ( uint percentVested_ ) {
931         Bond memory bond = bondInfo[ _depositor ];
932         uint blocksSinceLast = block.number.sub( bond.lastBlock );
933         uint vesting = bond.vesting;
934 
935         if ( vesting > 0 ) {
936             percentVested_ = blocksSinceLast.mul( 10000 ).div( vesting );
937         } else {
938             percentVested_ = 0;
939         }
940     }
941 
942     /**
943      *  @notice calculate amount of payout token available for claim by depositor
944      *  @param _depositor address
945      *  @return pendingPayout_ uint
946      */
947     function pendingPayoutFor( address _depositor ) external view returns ( uint pendingPayout_ ) {
948         uint percentVested = percentVestedFor( _depositor );
949         uint payout = bondInfo[ _depositor ].payout;
950 
951         if ( percentVested >= 10000 ) {
952             pendingPayout_ = payout;
953         } else {
954             pendingPayout_ = payout.mul( percentVested ).div( 10000 );
955         }
956     }
957 
958     /**
959      *  @notice current fee Olympus takes of each bond
960      *  @return currentFee_ uint
961      */
962     function currentOlympusFee() public view returns( uint currentFee_ ) {
963         uint tierLength = feeTiers.length;
964         for(uint i; i < tierLength; i++) {
965             if(totalPrincipalBonded < feeTiers[i].tierCeilings || i == tierLength - 1 ) {
966                 return feeTiers[i].fees;
967             }
968         }
969     }
970     
971 }