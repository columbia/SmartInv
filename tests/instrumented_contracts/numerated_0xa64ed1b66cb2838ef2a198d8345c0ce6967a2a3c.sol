1 // SPDX-License-Identifier: AGPL-3.0-or-later
2 pragma solidity 0.7.5;
3 
4 interface IOwnable {
5 
6     function owner() external view returns (address);
7 
8     function renounceOwnership() external;
9   
10     function transferOwnership( address newOwner_ ) external;
11 }
12 
13 contract Ownable is IOwnable {
14     
15     address internal _owner;
16 
17     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
18 
19     constructor () {
20         _owner = msg.sender;
21         emit OwnershipTransferred( address(0), _owner );
22     }
23 
24     function owner() public view override returns (address) {
25         return _owner;
26     }
27 
28     modifier onlyOwner() {
29         require( _owner == msg.sender, "Ownable: caller is not the owner" );
30         _;
31     }
32 
33     function renounceOwnership() public virtual override onlyOwner() {
34         emit OwnershipTransferred( _owner, address(0) );
35         _owner = address(0);
36     }
37 
38     function transferOwnership( address newOwner_ ) public virtual override onlyOwner() {
39         require( newOwner_ != address(0), "Ownable: new owner is the zero address");
40         emit OwnershipTransferred( _owner, newOwner_ );
41         _owner = newOwner_;
42     }
43 }
44 
45 library SafeMath {
46 
47     function add(uint256 a, uint256 b) internal pure returns (uint256) {
48         uint256 c = a + b;
49         require(c >= a, "SafeMath: addition overflow");
50 
51         return c;
52     }
53 
54     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
55         return sub(a, b, "SafeMath: subtraction overflow");
56     }
57 
58     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
59         require(b <= a, errorMessage);
60         uint256 c = a - b;
61 
62         return c;
63     }
64 
65     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
66         if (a == 0) {
67             return 0;
68         }
69 
70         uint256 c = a * b;
71         require(c / a == b, "SafeMath: multiplication overflow");
72 
73         return c;
74     }
75 
76     function div(uint256 a, uint256 b) internal pure returns (uint256) {
77         return div(a, b, "SafeMath: division by zero");
78     }
79 
80     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
81         require(b > 0, errorMessage);
82         uint256 c = a / b;
83         return c;
84     }
85 
86     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
87         return mod(a, b, "SafeMath: modulo by zero");
88     }
89 
90     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
91         require(b != 0, errorMessage);
92         return a % b;
93     }
94 
95     function sqrrt(uint256 a) internal pure returns (uint c) {
96         if (a > 3) {
97             c = a;
98             uint b = add( div( a, 2), 1 );
99             while (b < c) {
100                 c = b;
101                 b = div( add( div( a, b ), b), 2 );
102             }
103         } else if (a != 0) {
104             c = 1;
105         }
106     }
107 
108     function percentageAmount( uint256 total_, uint8 percentage_ ) internal pure returns ( uint256 percentAmount_ ) {
109         return div( mul( total_, percentage_ ), 1000 );
110     }
111 
112     function substractPercentage( uint256 total_, uint8 percentageToSub_ ) internal pure returns ( uint256 result_ ) {
113         return sub( total_, div( mul( total_, percentageToSub_ ), 1000 ) );
114     }
115 
116     function percentageOfTotal( uint256 part_, uint256 total_ ) internal pure returns ( uint256 percent_ ) {
117         return div( mul(part_, 100) , total_ );
118     }
119 
120     function average(uint256 a, uint256 b) internal pure returns (uint256) {
121         // (a + b) / 2 can overflow, so we distribute
122         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
123     }
124 
125     function quadraticPricing( uint256 payment_, uint256 multiplier_ ) internal pure returns (uint256) {
126         return sqrrt( mul( multiplier_, payment_ ) );
127     }
128 
129   function bondingCurve( uint256 supply_, uint256 multiplier_ ) internal pure returns (uint256) {
130       return mul( multiplier_, supply_ );
131   }
132 }
133 
134 library Address {
135 
136     function isContract(address account) internal view returns (bool) {
137 
138         uint256 size;
139         // solhint-disable-next-line no-inline-assembly
140         assembly { size := extcodesize(account) }
141         return size > 0;
142     }
143 
144     function sendValue(address payable recipient, uint256 amount) internal {
145         require(address(this).balance >= amount, "Address: insufficient balance");
146 
147         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
148         (bool success, ) = recipient.call{ value: amount }("");
149         require(success, "Address: unable to send value, recipient may have reverted");
150     }
151 
152     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
153       return functionCall(target, data, "Address: low-level call failed");
154     }
155 
156     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
157         return _functionCallWithValue(target, data, 0, errorMessage);
158     }
159 
160     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
161         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
162     }
163 
164     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
165         require(address(this).balance >= value, "Address: insufficient balance for call");
166         require(isContract(target), "Address: call to non-contract");
167 
168         // solhint-disable-next-line avoid-low-level-calls
169         (bool success, bytes memory returndata) = target.call{ value: value }(data);
170         return _verifyCallResult(success, returndata, errorMessage);
171     }
172 
173     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
174         require(isContract(target), "Address: call to non-contract");
175 
176         // solhint-disable-next-line avoid-low-level-calls
177         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
178         if (success) {
179             return returndata;
180         } else {
181             // Look for revert reason and bubble it up if present
182             if (returndata.length > 0) {
183                 // The easiest way to bubble the revert reason is using memory via assembly
184 
185                 // solhint-disable-next-line no-inline-assembly
186                 assembly {
187                     let returndata_size := mload(returndata)
188                     revert(add(32, returndata), returndata_size)
189                 }
190             } else {
191                 revert(errorMessage);
192             }
193         }
194     }
195 
196     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
197         return functionStaticCall(target, data, "Address: low-level static call failed");
198     }
199 
200     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
201         require(isContract(target), "Address: static call to non-contract");
202 
203         // solhint-disable-next-line avoid-low-level-calls
204         (bool success, bytes memory returndata) = target.staticcall(data);
205         return _verifyCallResult(success, returndata, errorMessage);
206     }
207 
208     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
209         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
210     }
211 
212     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
213         require(isContract(target), "Address: delegate call to non-contract");
214 
215         // solhint-disable-next-line avoid-low-level-calls
216         (bool success, bytes memory returndata) = target.delegatecall(data);
217         return _verifyCallResult(success, returndata, errorMessage);
218     }
219 
220     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
221         if (success) {
222             return returndata;
223         } else {
224             if (returndata.length > 0) {
225 
226                 assembly {
227                     let returndata_size := mload(returndata)
228                     revert(add(32, returndata), returndata_size)
229                 }
230             } else {
231                 revert(errorMessage);
232             }
233         }
234     }
235 
236     function addressToString(address _address) internal pure returns(string memory) {
237         bytes32 _bytes = bytes32(uint256(_address));
238         bytes memory HEX = "0123456789abcdef";
239         bytes memory _addr = new bytes(42);
240 
241         _addr[0] = '0';
242         _addr[1] = 'x';
243 
244         for(uint256 i = 0; i < 20; i++) {
245             _addr[2+i*2] = HEX[uint8(_bytes[i + 12] >> 4)];
246             _addr[3+i*2] = HEX[uint8(_bytes[i + 12] & 0x0f)];
247         }
248 
249         return string(_addr);
250 
251     }
252 }
253 
254 interface IERC20 {
255     function decimals() external view returns (uint8);
256 
257     function totalSupply() external view returns (uint256);
258 
259     function balanceOf(address account) external view returns (uint256);
260 
261     function transfer(address recipient, uint256 amount) external returns (bool);
262 
263     function allowance(address owner, address spender) external view returns (uint256);
264 
265     function approve(address spender, uint256 amount) external returns (bool);
266 
267     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
268 
269     event Transfer(address indexed from, address indexed to, uint256 value);
270 
271     event Approval(address indexed owner, address indexed spender, uint256 value);
272 }
273 
274 abstract contract ERC20 is IERC20 {
275 
276     using SafeMath for uint256;
277 
278     // TODO comment actual hash value.
279     bytes32 constant private ERC20TOKEN_ERC1820_INTERFACE_ID = keccak256( "ERC20Token" );
280     
281     mapping (address => uint256) internal _balances;
282 
283     mapping (address => mapping (address => uint256)) internal _allowances;
284 
285     uint256 internal _totalSupply;
286 
287     string internal _name;
288     
289     string internal _symbol;
290     
291     uint8 internal _decimals;
292 
293     constructor (string memory name_, string memory symbol_, uint8 decimals_) {
294         _name = name_;
295         _symbol = symbol_;
296         _decimals = decimals_;
297     }
298 
299     function name() public view returns (string memory) {
300         return _name;
301     }
302 
303     function symbol() public view returns (string memory) {
304         return _symbol;
305     }
306 
307     function decimals() public view override returns (uint8) {
308         return _decimals;
309     }
310 
311     function totalSupply() public view override returns (uint256) {
312         return _totalSupply;
313     }
314 
315     function balanceOf(address account) public view virtual override returns (uint256) {
316         return _balances[account];
317     }
318 
319     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
320         _transfer(msg.sender, recipient, amount);
321         return true;
322     }
323 
324     function allowance(address owner, address spender) public view virtual override returns (uint256) {
325         return _allowances[owner][spender];
326     }
327 
328     function approve(address spender, uint256 amount) public virtual override returns (bool) {
329         _approve(msg.sender, spender, amount);
330         return true;
331     }
332 
333     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
334         _transfer(sender, recipient, amount);
335         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount, "ERC20: transfer amount exceeds allowance"));
336         return true;
337     }
338 
339     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
340         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
341         return true;
342     }
343 
344     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
345         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
346         return true;
347     }
348 
349     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
350         require(sender != address(0), "ERC20: transfer from the zero address");
351         require(recipient != address(0), "ERC20: transfer to the zero address");
352 
353         _beforeTokenTransfer(sender, recipient, amount);
354 
355         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
356         _balances[recipient] = _balances[recipient].add(amount);
357         emit Transfer(sender, recipient, amount);
358     }
359 
360     function _mint(address account_, uint256 ammount_) internal virtual {
361         require(account_ != address(0), "ERC20: mint to the zero address");
362         _beforeTokenTransfer(address( this ), account_, ammount_);
363         _totalSupply = _totalSupply.add(ammount_);
364         _balances[account_] = _balances[account_].add(ammount_);
365         emit Transfer(address( this ), account_, ammount_);
366     }
367 
368     function _burn(address account, uint256 amount) internal virtual {
369         require(account != address(0), "ERC20: burn from the zero address");
370 
371         _beforeTokenTransfer(account, address(0), amount);
372 
373         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
374         _totalSupply = _totalSupply.sub(amount);
375         emit Transfer(account, address(0), amount);
376     }
377 
378     function _approve(address owner, address spender, uint256 amount) internal virtual {
379         require(owner != address(0), "ERC20: approve from the zero address");
380         require(spender != address(0), "ERC20: approve to the zero address");
381 
382         _allowances[owner][spender] = amount;
383         emit Approval(owner, spender, amount);
384     }
385 
386   function _beforeTokenTransfer( address from_, address to_, uint256 amount_ ) internal virtual { }
387 }
388 
389 interface IERC2612Permit {
390 
391     function permit(
392         address owner,
393         address spender,
394         uint256 amount,
395         uint256 deadline,
396         uint8 v,
397         bytes32 r,
398         bytes32 s
399     ) external;
400 
401     function nonces(address owner) external view returns (uint256);
402 }
403 
404 library Counters {
405     using SafeMath for uint256;
406 
407     struct Counter {
408 
409         uint256 _value; // default: 0
410     }
411 
412     function current(Counter storage counter) internal view returns (uint256) {
413         return counter._value;
414     }
415 
416     function increment(Counter storage counter) internal {
417         counter._value += 1;
418     }
419 
420     function decrement(Counter storage counter) internal {
421         counter._value = counter._value.sub(1);
422     }
423 }
424 
425 abstract contract ERC20Permit is ERC20, IERC2612Permit {
426     using Counters for Counters.Counter;
427 
428     mapping(address => Counters.Counter) private _nonces;
429 
430     // keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");
431     bytes32 public constant PERMIT_TYPEHASH = 0x6e71edae12b1b97f4d1f60370fef10105fa2faae0126114a169c64845d6126c9;
432 
433     bytes32 public DOMAIN_SEPARATOR;
434 
435     constructor() {
436         uint256 chainID;
437         assembly {
438             chainID := chainid()
439         }
440 
441         DOMAIN_SEPARATOR = keccak256(
442             abi.encode(
443                 keccak256("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"),
444                 keccak256(bytes(name())),
445                 keccak256(bytes("1")), // Version
446                 chainID,
447                 address(this)
448             )
449         );
450     }
451 
452     function permit(
453         address owner,
454         address spender,
455         uint256 amount,
456         uint256 deadline,
457         uint8 v,
458         bytes32 r,
459         bytes32 s
460     ) public virtual override {
461         require(block.timestamp <= deadline, "Permit: expired deadline");
462 
463         bytes32 hashStruct =
464             keccak256(abi.encode(PERMIT_TYPEHASH, owner, spender, amount, _nonces[owner].current(), deadline));
465 
466         bytes32 _hash = keccak256(abi.encodePacked(uint16(0x1901), DOMAIN_SEPARATOR, hashStruct));
467 
468         address signer = ecrecover(_hash, v, r, s);
469         require(signer != address(0) && signer == owner, "ZeroSwapPermit: Invalid signature");
470 
471         _nonces[owner].increment();
472         _approve(owner, spender, amount);
473     }
474 
475     function nonces(address owner) public view override returns (uint256) {
476         return _nonces[owner].current();
477     }
478 }
479 
480 library SafeERC20 {
481     using SafeMath for uint256;
482     using Address for address;
483 
484     function safeTransfer(IERC20 token, address to, uint256 value) internal {
485         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
486     }
487 
488     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
489         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
490     }
491 
492     function safeApprove(IERC20 token, address spender, uint256 value) internal {
493 
494         require((value == 0) || (token.allowance(address(this), spender) == 0),
495             "SafeERC20: approve from non-zero to non-zero allowance"
496         );
497         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
498     }
499 
500     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
501         uint256 newAllowance = token.allowance(address(this), spender).add(value);
502         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
503     }
504 
505     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
506         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
507         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
508     }
509 
510     function _callOptionalReturn(IERC20 token, bytes memory data) private {
511 
512         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
513         if (returndata.length > 0) { // Return data is optional
514             // solhint-disable-next-line max-line-length
515             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
516         }
517     }
518 }
519 
520 library FullMath {
521     function fullMul(uint256 x, uint256 y) private pure returns (uint256 l, uint256 h) {
522         uint256 mm = mulmod(x, y, uint256(-1));
523         l = x * y;
524         h = mm - l;
525         if (mm < l) h -= 1;
526     }
527 
528     function fullDiv(
529         uint256 l,
530         uint256 h,
531         uint256 d
532     ) private pure returns (uint256) {
533         uint256 pow2 = d & -d;
534         d /= pow2;
535         l /= pow2;
536         l += h * ((-pow2) / pow2 + 1);
537         uint256 r = 1;
538         r *= 2 - d * r;
539         r *= 2 - d * r;
540         r *= 2 - d * r;
541         r *= 2 - d * r;
542         r *= 2 - d * r;
543         r *= 2 - d * r;
544         r *= 2 - d * r;
545         r *= 2 - d * r;
546         return l * r;
547     }
548 
549     function mulDiv(
550         uint256 x,
551         uint256 y,
552         uint256 d
553     ) internal pure returns (uint256) {
554         (uint256 l, uint256 h) = fullMul(x, y);
555         uint256 mm = mulmod(x, y, d);
556         if (mm > l) h -= 1;
557         l -= mm;
558         require(h < d, 'FullMath::mulDiv: overflow');
559         return fullDiv(l, h, d);
560     }
561 }
562 
563 library FixedPoint {
564 
565     struct uq112x112 {
566         uint224 _x;
567     }
568 
569     struct uq144x112 {
570         uint256 _x;
571     }
572 
573     uint8 private constant RESOLUTION = 112;
574     uint256 private constant Q112 = 0x10000000000000000000000000000;
575     uint256 private constant Q224 = 0x100000000000000000000000000000000000000000000000000000000;
576     uint256 private constant LOWER_MASK = 0xffffffffffffffffffffffffffff; // decimal of UQ*x112 (lower 112 bits)
577 
578     function decode(uq112x112 memory self) internal pure returns (uint112) {
579         return uint112(self._x >> RESOLUTION);
580     }
581 
582     function decode112with18(uq112x112 memory self) internal pure returns (uint) {
583 
584         return uint(self._x) / 5192296858534827;
585     }
586 
587     function fraction(uint256 numerator, uint256 denominator) internal pure returns (uq112x112 memory) {
588         require(denominator > 0, 'FixedPoint::fraction: division by zero');
589         if (numerator == 0) return FixedPoint.uq112x112(0);
590 
591         if (numerator <= uint144(-1)) {
592             uint256 result = (numerator << RESOLUTION) / denominator;
593             require(result <= uint224(-1), 'FixedPoint::fraction: overflow');
594             return uq112x112(uint224(result));
595         } else {
596             uint256 result = FullMath.mulDiv(numerator, Q112, denominator);
597             require(result <= uint224(-1), 'FixedPoint::fraction: overflow');
598             return uq112x112(uint224(result));
599         }
600     }
601 }
602 
603 interface ITreasury {
604     function depositReserves( uint depositAmount_ ) external returns ( bool );
605 }
606 
607 interface ICirculatingOHM {
608     function OHMCirculatingSupply() external view returns ( uint );
609 }
610 
611 interface IBondDepo {
612 
613     function getDepositorInfo( address _depositorAddress_ ) external view returns ( uint principleValue_, uint paidOut_, uint maxPayout, uint vestingPeriod_ );
614     
615     function deposit( uint256 amount_, uint maxPremium_, address depositor_ ) external returns ( bool );
616 
617     function depositWithPermit( uint256 amount_, uint maxPremium_, address depositor_, uint256 deadline, uint8 v, bytes32 r, bytes32 s ) external returns ( bool );
618 
619     function redeem() external returns ( bool );
620 
621     function calculatePercentVested( address depositor_ ) external view returns ( uint _percentVested );
622     
623     function calculatePendingPayout( address depositor_ ) external view returns ( uint _pendingPayout );
624       
625     function calculateBondInterest( uint value_ ) external view returns ( uint _interestDue );
626         
627     function calculatePremium() external view returns ( uint _premium );
628 }
629 
630 
631 
632 contract OlympusDAIDepository is IBondDepo, Ownable {
633 
634     using FixedPoint for *;
635     using SafeERC20 for IERC20;
636     using SafeMath for uint;
637 
638     struct DepositInfo {
639         uint value; // Value
640         uint payoutRemaining; // OHM remaining to be paid
641         uint lastBlock; // Last interaction
642         uint vestingPeriod; // Blocks left to vest
643     }
644 
645     mapping( address => DepositInfo ) public depositorInfo; 
646 
647     uint public DAOShare; // % = 1 / DAOShare
648     uint public bondControlVariable; // Premium scaling variable
649     uint public vestingPeriodInBlocks; 
650     uint public minPremium; // Floor for the premium
651 
652     //  Max a payout can be compared to the circulating supply, in hundreths. i.e. 50 = 0.5%
653     uint public maxPayoutPercent;
654 
655     address public treasury;
656     address public DAI;
657     address public OHM;
658 
659     uint256 public totalDebt; // Total value of outstanding bonds
660 
661     address public stakingContract;
662     address public DAOWallet;
663     address public circulatingOHMContract; // calculates circulating supply
664 
665     bool public useCircForDebtRatio; // Use circulating or total supply to calc total debt
666 
667     constructor ( 
668         address DAI_, 
669         address OHM_,
670         address treasury_, 
671         address stakingContract_, 
672         address DAOWallet_, 
673         address circulatingOHMContract_
674     ) {
675         DAI = DAI_;
676         OHM = OHM_;
677         treasury = treasury_;
678         stakingContract = stakingContract_;
679         DAOWallet = DAOWallet_;
680         circulatingOHMContract = circulatingOHMContract_;
681     }
682 
683     /**
684         @notice set parameters of new bonds
685         @param bondControlVariable_ uint
686         @param vestingPeriodInBlocks_ uint
687         @param minPremium_ uint
688         @param maxPayout_ uint
689         @param DAOShare_ uint
690         @return bool
691      */
692     function setBondTerms( 
693         uint bondControlVariable_, 
694         uint vestingPeriodInBlocks_, 
695         uint minPremium_, 
696         uint maxPayout_,
697         uint DAOShare_ ) 
698     external onlyOwner() returns ( bool ) {
699         bondControlVariable = bondControlVariable_;
700         vestingPeriodInBlocks = vestingPeriodInBlocks_;
701         minPremium = minPremium_;
702         maxPayoutPercent = maxPayout_;
703         DAOShare = DAOShare_;
704         return true;
705     }
706 
707     /**
708         @notice deposit bond
709         @param amount_ uint
710         @param maxPremium_ uint
711         @param depositor_ address
712         @return bool
713      */
714     function deposit( 
715         uint amount_, 
716         uint maxPremium_,
717         address depositor_ ) 
718     external override returns ( bool ) {
719         _deposit( amount_, maxPremium_, depositor_ ) ;
720         return true;
721     }
722 
723     /**
724         @notice deposit bond with permit
725         @param amount_ uint
726         @param maxPremium_ uint
727         @param depositor_ address
728         @param v uint8
729         @param r bytes32
730         @param s bytes32
731         @return bool
732      */
733     function depositWithPermit( 
734         uint amount_, 
735         uint maxPremium_,
736         address depositor_, 
737         uint deadline, 
738         uint8 v, 
739         bytes32 r, 
740         bytes32 s ) 
741     external override returns ( bool ) {
742         ERC20Permit( DAI ).permit( msg.sender, address(this), amount_, deadline, v, r, s );
743         _deposit( amount_, maxPremium_, depositor_ ) ;
744         return true;
745     }
746 
747     /**
748         @notice deposit function like mint
749         @param amount_ uint
750         @param maxPremium_ uint
751         @param depositor_ address
752         @return bool
753      */
754     function _deposit( 
755         uint amount_, 
756         uint maxPremium_, 
757         address depositor_ ) 
758     internal returns ( bool ) {
759         // slippage protection
760         require( maxPremium_ >= _calcPremium(), "Slippage protection: more than max premium" );
761 
762         IERC20( DAI ).safeTransferFrom( msg.sender, address(this), amount_ );
763 
764         uint value_ = amount_.div( 1e9 );
765         uint payout_ = calculateBondInterest( value_ );
766 
767         require( payout_ >= 10000000, "Bond too small" ); // must be > 0.01 OHM
768         require( payout_ <= getMaxPayoutAmount(), "Bond too large");
769 
770         totalDebt = totalDebt.add( value_ );
771 
772         // Deposit token to mint OHM
773         IERC20( DAI ).approve( address( treasury ), amount_ );
774         ITreasury( treasury ).depositReserves( amount_ ); // Returns OHM
775 
776         uint profit_ = value_.sub( payout_ );
777         uint DAOProfit_ = FixedPoint.fraction( profit_, DAOShare ).decode();
778         // Transfer profits to staking distributor and dao
779         IERC20( OHM ).safeTransfer( stakingContract, profit_.sub( DAOProfit_ ) );
780         IERC20( OHM ).safeTransfer( DAOWallet, DAOProfit_ );
781 
782         // Store depositor info
783         depositorInfo[ depositor_ ] = DepositInfo({
784             value: depositorInfo[ depositor_ ].value.add( value_ ),
785             payoutRemaining: depositorInfo[ depositor_ ].payoutRemaining.add( payout_ ),
786             lastBlock: block.number,
787             vestingPeriod: vestingPeriodInBlocks
788         });
789         return true;
790     }
791 
792     /** 
793         @notice redeem bond
794         @return bool
795      */ 
796     function redeem() external override returns ( bool ) {
797         uint payoutRemaining_ = depositorInfo[ msg.sender ].payoutRemaining;
798 
799         require( payoutRemaining_ > 0, "Sender is not due any interest." );
800 
801         uint value_ = depositorInfo[ msg.sender ].value;
802         uint percentVested_ = _calculatePercentVested( msg.sender );
803 
804         if ( percentVested_ >= 10000 ) { // if fully vested
805             delete depositorInfo[msg.sender];
806             IERC20( OHM ).safeTransfer( msg.sender, payoutRemaining_ );
807             totalDebt = totalDebt.sub( value_ );
808             return true;
809         }
810 
811         // calculate and send vested OHM
812         uint payout_ = payoutRemaining_.mul( percentVested_ ).div( 10000 );
813         IERC20( OHM ).safeTransfer( msg.sender, payout_ );
814 
815         // reduce total debt by vested amount
816         uint valueUsed_ = value_.mul( percentVested_ ).div( 10000 );
817         totalDebt = totalDebt.sub( valueUsed_ );
818 
819         uint vestingPeriod_ = depositorInfo[msg.sender].vestingPeriod;
820         uint blocksSinceLast_ = block.number.sub( depositorInfo[ msg.sender ].lastBlock );
821 
822         // store updated deposit info
823         depositorInfo[msg.sender] = DepositInfo({
824             value: value_.sub( valueUsed_ ),
825             payoutRemaining: payoutRemaining_.sub( payout_ ),
826             lastBlock: block.number,
827             vestingPeriod: vestingPeriod_.sub( blocksSinceLast_ )
828         });
829         return true;
830     }
831 
832     /**
833         @notice get info of depositor
834         @param address_ info
835      */
836     function getDepositorInfo( address address_ ) external view override returns ( 
837         uint _value, 
838         uint _payoutRemaining, 
839         uint _lastBlock, 
840         uint _vestingPeriod ) 
841     {
842         DepositInfo memory info = depositorInfo[ address_ ];
843         _value = info.value;
844         _payoutRemaining = info.payoutRemaining;
845         _lastBlock = info.lastBlock;
846         _vestingPeriod = info.vestingPeriod;
847     }
848 
849     /**
850         @notice set contract to use circulating or total supply to calc debt
851      */
852     function toggleUseCircForDebtRatio() external onlyOwner() returns ( bool ) {
853         useCircForDebtRatio = !useCircForDebtRatio;
854         return true;
855     }
856 
857     /**
858         @notice use maxPayoutPercent to determine maximum bond available
859         @return uint
860      */
861     function getMaxPayoutAmount() public view returns ( uint ) {
862         uint circulatingOHM = ICirculatingOHM( circulatingOHMContract ).OHMCirculatingSupply();
863 
864         uint maxPayout = circulatingOHM.mul( maxPayoutPercent ).div( 10000 );
865 
866         return maxPayout;
867     }
868 
869     /**
870         @notice view function for _calculatePercentVested
871         @param depositor_ address
872         @return _percentVested uint
873      */
874     function calculatePercentVested( address depositor_ ) external view override returns ( uint _percentVested ) {
875         _percentVested = _calculatePercentVested( depositor_ );
876     }
877 
878     /**
879         @notice calculate how far into vesting period depositor is
880         @param depositor_ address
881         @return _percentVested uint ( in hundreths - i.e. 10 = 0.1% )
882      */
883     function _calculatePercentVested( address depositor_ ) internal view returns ( uint _percentVested ) {
884         uint vestingPeriod_ = depositorInfo[ depositor_ ].vestingPeriod;
885         if ( vestingPeriod_ > 0 ) {
886             uint blocksSinceLast_ = block.number.sub( depositorInfo[ depositor_ ].lastBlock );
887             _percentVested = blocksSinceLast_.mul( 10000 ).div( vestingPeriod_ );
888         } else {
889             _percentVested = 0;
890         }
891     }
892 
893     /**
894         @notice calculate amount of OHM available for claim by depositor
895         @param depositor_ address
896         @return uint
897      */
898     function calculatePendingPayout( address depositor_ ) external view override returns ( uint ) {
899         uint percentVested_ = _calculatePercentVested( depositor_ );
900         uint payoutRemaining_ = depositorInfo[ depositor_ ].payoutRemaining;
901         
902         uint pendingPayout = payoutRemaining_.mul( percentVested_ ).div( 10000 );
903 
904         if ( percentVested_ >= 10000 ) {
905             pendingPayout = payoutRemaining_;
906         } 
907         return pendingPayout;
908     }
909 
910     /**
911         @notice calculate interest due to new bonder
912         @param value_ uint
913         @return _interestDue uint
914      */
915     function calculateBondInterest( uint value_ ) public view override returns ( uint _interestDue ) {
916         _interestDue = FixedPoint.fraction( value_, _calcPremium() ).decode112with18().div( 1e16 );
917     }
918 
919     /**
920         @notice view function for _calcPremium()
921         @return _premium uint
922      */
923     function calculatePremium() external view override returns ( uint _premium ) {
924         _premium = _calcPremium();
925     }
926 
927     /**
928         @notice calculate current bond premium
929         @return _premium uint
930      */
931     function _calcPremium() internal view returns ( uint _premium ) {
932         _premium = bondControlVariable.mul( _calcDebtRatio() ).add( uint(1000000000) ).div( 1e7 );
933         if ( _premium < minPremium ) {
934             _premium = minPremium;
935         }
936     }
937 
938     /**
939         @notice calculate current debt ratio
940         @return _debtRatio uint
941      */
942     function _calcDebtRatio() internal view returns ( uint _debtRatio ) {   
943         uint supply;
944 
945         if( useCircForDebtRatio ) {
946             supply = ICirculatingOHM( circulatingOHMContract ).OHMCirculatingSupply();
947         } else {
948             supply = IERC20( OHM ).totalSupply();
949         }
950 
951         _debtRatio = FixedPoint.fraction( 
952             // Must move the decimal to the right by 9 places to avoid math underflow error
953             totalDebt.mul( 1e9 ), 
954             supply
955         ).decode112with18().div( 1e18 );
956         // Must move the decimal to the left 18 places to account for the 9 places added above and the 19 signnificant digits added by FixedPoint.
957     }
958 }