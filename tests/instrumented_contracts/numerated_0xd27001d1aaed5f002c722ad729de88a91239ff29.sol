1 // SPDX-License-Identifier: AGPL-3.0-or-later
2 pragma solidity 0.7.4;
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
137         // This method relies in extcodesize, which returns 0 for contracts in
138         // construction, since the code is only stored at the end of the
139         // constructor execution.
140 
141         uint256 size;
142         // solhint-disable-next-line no-inline-assembly
143         assembly { size := extcodesize(account) }
144         return size > 0;
145     }
146 
147     function sendValue(address payable recipient, uint256 amount) internal {
148         require(address(this).balance >= amount, "Address: insufficient balance");
149 
150         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
151         (bool success, ) = recipient.call{ value: amount }("");
152         require(success, "Address: unable to send value, recipient may have reverted");
153     }
154 
155     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
156       return functionCall(target, data, "Address: low-level call failed");
157     }
158 
159     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
160         return _functionCallWithValue(target, data, 0, errorMessage);
161     }
162 
163     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
164         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
165     }
166 
167     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
168         require(address(this).balance >= value, "Address: insufficient balance for call");
169         require(isContract(target), "Address: call to non-contract");
170 
171         // solhint-disable-next-line avoid-low-level-calls
172         (bool success, bytes memory returndata) = target.call{ value: value }(data);
173         return _verifyCallResult(success, returndata, errorMessage);
174     }
175 
176     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
177         require(isContract(target), "Address: call to non-contract");
178 
179         // solhint-disable-next-line avoid-low-level-calls
180         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
181         if (success) {
182             return returndata;
183         } else {
184             // Look for revert reason and bubble it up if present
185             if (returndata.length > 0) {
186                 // The easiest way to bubble the revert reason is using memory via assembly
187 
188                 // solhint-disable-next-line no-inline-assembly
189                 assembly {
190                     let returndata_size := mload(returndata)
191                     revert(add(32, returndata), returndata_size)
192                 }
193             } else {
194                 revert(errorMessage);
195             }
196         }
197     }
198 
199     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
200         return functionStaticCall(target, data, "Address: low-level static call failed");
201     }
202 
203     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
204         require(isContract(target), "Address: static call to non-contract");
205 
206         // solhint-disable-next-line avoid-low-level-calls
207         (bool success, bytes memory returndata) = target.staticcall(data);
208         return _verifyCallResult(success, returndata, errorMessage);
209     }
210 
211     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
212         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
213     }
214 
215     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
216         require(isContract(target), "Address: delegate call to non-contract");
217 
218         // solhint-disable-next-line avoid-low-level-calls
219         (bool success, bytes memory returndata) = target.delegatecall(data);
220         return _verifyCallResult(success, returndata, errorMessage);
221     }
222 
223     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
224         if (success) {
225             return returndata;
226         } else {
227             // Look for revert reason and bubble it up if present
228             if (returndata.length > 0) {
229                 // The easiest way to bubble the revert reason is using memory via assembly
230 
231                 // solhint-disable-next-line no-inline-assembly
232                 assembly {
233                     let returndata_size := mload(returndata)
234                     revert(add(32, returndata), returndata_size)
235                 }
236             } else {
237                 revert(errorMessage);
238             }
239         }
240     }
241 
242     function addressToString(address _address) internal pure returns(string memory) {
243         bytes32 _bytes = bytes32(uint256(_address));
244         bytes memory HEX = "0123456789abcdef";
245         bytes memory _addr = new bytes(42);
246 
247         _addr[0] = '0';
248         _addr[1] = 'x';
249 
250         for(uint256 i = 0; i < 20; i++) {
251             _addr[2+i*2] = HEX[uint8(_bytes[i + 12] >> 4)];
252             _addr[3+i*2] = HEX[uint8(_bytes[i + 12] & 0x0f)];
253         }
254 
255         return string(_addr);
256 
257     }
258 }
259 
260 interface IERC20 {
261     function decimals() external view returns (uint8);
262 
263     function totalSupply() external view returns (uint256);
264 
265     function balanceOf(address account) external view returns (uint256);
266 
267     function transfer(address recipient, uint256 amount) external returns (bool);
268 
269     function allowance(address owner, address spender) external view returns (uint256);
270 
271     function approve(address spender, uint256 amount) external returns (bool);
272 
273     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
274 
275     event Transfer(address indexed from, address indexed to, uint256 value);
276 
277     event Approval(address indexed owner, address indexed spender, uint256 value);
278 }
279 
280 abstract contract ERC20 is IERC20 {
281 
282     using SafeMath for uint256;
283 
284     // TODO comment actual hash value.
285     bytes32 constant private ERC20TOKEN_ERC1820_INTERFACE_ID = keccak256( "ERC20Token" );
286     
287     mapping (address => uint256) internal _balances;
288 
289     mapping (address => mapping (address => uint256)) internal _allowances;
290 
291     uint256 internal _totalSupply;
292 
293     string internal _name;
294     
295     string internal _symbol;
296     
297     uint8 internal _decimals;
298 
299     constructor (string memory name_, string memory symbol_, uint8 decimals_) {
300         _name = name_;
301         _symbol = symbol_;
302         _decimals = decimals_;
303     }
304 
305     function name() public view returns (string memory) {
306         return _name;
307     }
308 
309     function symbol() public view returns (string memory) {
310         return _symbol;
311     }
312 
313     function decimals() public view override returns (uint8) {
314         return _decimals;
315     }
316 
317     function totalSupply() public view override returns (uint256) {
318         return _totalSupply;
319     }
320 
321     function balanceOf(address account) public view virtual override returns (uint256) {
322         return _balances[account];
323     }
324 
325     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
326         _transfer(msg.sender, recipient, amount);
327         return true;
328     }
329 
330     function allowance(address owner, address spender) public view virtual override returns (uint256) {
331         return _allowances[owner][spender];
332     }
333 
334     function approve(address spender, uint256 amount) public virtual override returns (bool) {
335         _approve(msg.sender, spender, amount);
336         return true;
337     }
338 
339     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
340         _transfer(sender, recipient, amount);
341         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount, "ERC20: transfer amount exceeds allowance"));
342         return true;
343     }
344 
345     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
346         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
347         return true;
348     }
349 
350     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
351         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
352         return true;
353     }
354 
355   function _transfer(address sender, address recipient, uint256 amount) internal virtual {
356     require(sender != address(0), "ERC20: transfer from the zero address");
357     require(recipient != address(0), "ERC20: transfer to the zero address");
358 
359     _beforeTokenTransfer(sender, recipient, amount);
360 
361     _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
362     _balances[recipient] = _balances[recipient].add(amount);
363     emit Transfer(sender, recipient, amount);
364   }
365 
366     function _mint(address account_, uint256 ammount_) internal virtual {
367         require(account_ != address(0), "ERC20: mint to the zero address");
368         _beforeTokenTransfer(address( this ), account_, ammount_);
369         _totalSupply = _totalSupply.add(ammount_);
370         _balances[account_] = _balances[account_].add(ammount_);
371         emit Transfer(address( this ), account_, ammount_);
372     }
373 
374     function _burn(address account, uint256 amount) internal virtual {
375         require(account != address(0), "ERC20: burn from the zero address");
376 
377         _beforeTokenTransfer(account, address(0), amount);
378 
379         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
380         _totalSupply = _totalSupply.sub(amount);
381         emit Transfer(account, address(0), amount);
382     }
383 
384     function _approve(address owner, address spender, uint256 amount) internal virtual {
385         require(owner != address(0), "ERC20: approve from the zero address");
386         require(spender != address(0), "ERC20: approve to the zero address");
387 
388         _allowances[owner][spender] = amount;
389         emit Approval(owner, spender, amount);
390     }
391 
392   function _beforeTokenTransfer( address from_, address to_, uint256 amount_ ) internal virtual { }
393 }
394 
395 interface IERC2612Permit {
396 
397     function permit(
398         address owner,
399         address spender,
400         uint256 amount,
401         uint256 deadline,
402         uint8 v,
403         bytes32 r,
404         bytes32 s
405     ) external;
406 
407     function nonces(address owner) external view returns (uint256);
408 }
409 
410 library Counters {
411     using SafeMath for uint256;
412 
413     struct Counter {
414         // This variable should never be directly accessed by users of the library: interactions must be restricted to
415         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
416         // this feature: see https://github.com/ethereum/solidity/issues/4637
417         uint256 _value; // default: 0
418     }
419 
420     function current(Counter storage counter) internal view returns (uint256) {
421         return counter._value;
422     }
423 
424     function increment(Counter storage counter) internal {
425         // The {SafeMath} overflow check can be skipped here, see the comment at the top
426         counter._value += 1;
427     }
428 
429     function decrement(Counter storage counter) internal {
430         counter._value = counter._value.sub(1);
431     }
432 }
433 
434 abstract contract ERC20Permit is ERC20, IERC2612Permit {
435     using Counters for Counters.Counter;
436 
437     mapping(address => Counters.Counter) private _nonces;
438 
439     // keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");
440     bytes32 public constant PERMIT_TYPEHASH = 0x6e71edae12b1b97f4d1f60370fef10105fa2faae0126114a169c64845d6126c9;
441 
442     bytes32 public DOMAIN_SEPARATOR;
443 
444     constructor() {
445         uint256 chainID;
446         assembly {
447             chainID := chainid()
448         }
449 
450         DOMAIN_SEPARATOR = keccak256(
451             abi.encode(
452                 keccak256("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"),
453                 keccak256(bytes(name())),
454                 keccak256(bytes("1")), // Version
455                 chainID,
456                 address(this)
457             )
458         );
459     }
460 
461     function permit(
462         address owner,
463         address spender,
464         uint256 amount,
465         uint256 deadline,
466         uint8 v,
467         bytes32 r,
468         bytes32 s
469     ) public virtual override {
470         require(block.timestamp <= deadline, "Permit: expired deadline");
471 
472         bytes32 hashStruct =
473             keccak256(abi.encode(PERMIT_TYPEHASH, owner, spender, amount, _nonces[owner].current(), deadline));
474 
475         bytes32 _hash = keccak256(abi.encodePacked(uint16(0x1901), DOMAIN_SEPARATOR, hashStruct));
476 
477         address signer = ecrecover(_hash, v, r, s);
478         require(signer != address(0) && signer == owner, "ZeroSwapPermit: Invalid signature");
479 
480         _nonces[owner].increment();
481         _approve(owner, spender, amount);
482     }
483 
484     function nonces(address owner) public view override returns (uint256) {
485         return _nonces[owner].current();
486     }
487 }
488 
489 library SafeERC20 {
490     using SafeMath for uint256;
491     using Address for address;
492 
493     function safeTransfer(IERC20 token, address to, uint256 value) internal {
494         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
495     }
496 
497     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
498         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
499     }
500 
501     function safeApprove(IERC20 token, address spender, uint256 value) internal {
502 
503         require((value == 0) || (token.allowance(address(this), spender) == 0),
504             "SafeERC20: approve from non-zero to non-zero allowance"
505         );
506         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
507     }
508 
509     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
510         uint256 newAllowance = token.allowance(address(this), spender).add(value);
511         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
512     }
513 
514     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
515         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
516         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
517     }
518 
519     function _callOptionalReturn(IERC20 token, bytes memory data) private {
520 
521         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
522         if (returndata.length > 0) { // Return data is optional
523             // solhint-disable-next-line max-line-length
524             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
525         }
526     }
527 }
528 
529 interface IUniswapV2ERC20 {
530     event Approval(address indexed owner, address indexed spender, uint value);
531     event Transfer(address indexed from, address indexed to, uint value);
532 
533     function name() external pure returns (string memory);
534     function symbol() external pure returns (string memory);
535     function decimals() external pure returns (uint8);
536     function totalSupply() external view returns (uint);
537     function balanceOf(address owner) external view returns (uint);
538     function allowance(address owner, address spender) external view returns (uint);
539 
540     function approve(address spender, uint value) external returns (bool);
541     function transfer(address to, uint value) external returns (bool);
542     function transferFrom(address from, address to, uint value) external returns (bool);
543 
544     function DOMAIN_SEPARATOR() external view returns (bytes32);
545     function PERMIT_TYPEHASH() external pure returns (bytes32);
546     function nonces(address owner) external view returns (uint);
547 
548     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
549 }
550 
551 library Babylonian {
552     // credit for this implementation goes to
553     // https://github.com/abdk-consulting/abdk-libraries-solidity/blob/master/ABDKMath64x64.sol#L687
554     function sqrt(uint256 x) internal pure returns (uint256) {
555         if (x == 0) return 0;
556         // this block is equivalent to r = uint256(1) << (BitMath.mostSignificantBit(x) / 2);
557         // however that code costs significantly more gas
558         uint256 xx = x;
559         uint256 r = 1;
560         if (xx >= 0x100000000000000000000000000000000) {
561             xx >>= 128;
562             r <<= 64;
563         }
564         if (xx >= 0x10000000000000000) {
565             xx >>= 64;
566             r <<= 32;
567         }
568         if (xx >= 0x100000000) {
569             xx >>= 32;
570             r <<= 16;
571         }
572         if (xx >= 0x10000) {
573             xx >>= 16;
574             r <<= 8;
575         }
576         if (xx >= 0x100) {
577             xx >>= 8;
578             r <<= 4;
579         }
580         if (xx >= 0x10) {
581             xx >>= 4;
582             r <<= 2;
583         }
584         if (xx >= 0x8) {
585             r <<= 1;
586         }
587         r = (r + x / r) >> 1;
588         r = (r + x / r) >> 1;
589         r = (r + x / r) >> 1;
590         r = (r + x / r) >> 1;
591         r = (r + x / r) >> 1;
592         r = (r + x / r) >> 1;
593         r = (r + x / r) >> 1; // Seven iterations should be enough
594         uint256 r1 = x / r;
595         return (r < r1 ? r : r1);
596     }
597 }
598 
599 library BitMath {
600     // returns the 0 indexed position of the most significant bit of the input x
601     // s.t. x >= 2**msb and x < 2**(msb+1)
602     function mostSignificantBit(uint256 x) internal pure returns (uint8 r) {
603         require(x > 0, 'BitMath::mostSignificantBit: zero');
604 
605         if (x >= 0x100000000000000000000000000000000) {
606             x >>= 128;
607             r += 128;
608         }
609         if (x >= 0x10000000000000000) {
610             x >>= 64;
611             r += 64;
612         }
613         if (x >= 0x100000000) {
614             x >>= 32;
615             r += 32;
616         }
617         if (x >= 0x10000) {
618             x >>= 16;
619             r += 16;
620         }
621         if (x >= 0x100) {
622             x >>= 8;
623             r += 8;
624         }
625         if (x >= 0x10) {
626             x >>= 4;
627             r += 4;
628         }
629         if (x >= 0x4) {
630             x >>= 2;
631             r += 2;
632         }
633         if (x >= 0x2) r += 1;
634     }
635 
636     // returns the 0 indexed position of the least significant bit of the input x
637     // s.t. (x & 2**lsb) != 0 and (x & (2**(lsb) - 1)) == 0)
638     // i.e. the bit at the index is set and the mask of all lower bits is 0
639     function leastSignificantBit(uint256 x) internal pure returns (uint8 r) {
640         require(x > 0, 'BitMath::leastSignificantBit: zero');
641 
642         r = 255;
643         if (x & uint128(-1) > 0) {
644             r -= 128;
645         } else {
646             x >>= 128;
647         }
648         if (x & uint64(-1) > 0) {
649             r -= 64;
650         } else {
651             x >>= 64;
652         }
653         if (x & uint32(-1) > 0) {
654             r -= 32;
655         } else {
656             x >>= 32;
657         }
658         if (x & uint16(-1) > 0) {
659             r -= 16;
660         } else {
661             x >>= 16;
662         }
663         if (x & uint8(-1) > 0) {
664             r -= 8;
665         } else {
666             x >>= 8;
667         }
668         if (x & 0xf > 0) {
669             r -= 4;
670         } else {
671             x >>= 4;
672         }
673         if (x & 0x3 > 0) {
674             r -= 2;
675         } else {
676             x >>= 2;
677         }
678         if (x & 0x1 > 0) r -= 1;
679     }
680 }
681 
682 library FullMath {
683     function fullMul(uint256 x, uint256 y) private pure returns (uint256 l, uint256 h) {
684         uint256 mm = mulmod(x, y, uint256(-1));
685         l = x * y;
686         h = mm - l;
687         if (mm < l) h -= 1;
688     }
689 
690     function fullDiv(
691         uint256 l,
692         uint256 h,
693         uint256 d
694     ) private pure returns (uint256) {
695         uint256 pow2 = d & -d;
696         d /= pow2;
697         l /= pow2;
698         l += h * ((-pow2) / pow2 + 1);
699         uint256 r = 1;
700         r *= 2 - d * r;
701         r *= 2 - d * r;
702         r *= 2 - d * r;
703         r *= 2 - d * r;
704         r *= 2 - d * r;
705         r *= 2 - d * r;
706         r *= 2 - d * r;
707         r *= 2 - d * r;
708         return l * r;
709     }
710 
711     function mulDiv(
712         uint256 x,
713         uint256 y,
714         uint256 d
715     ) internal pure returns (uint256) {
716         (uint256 l, uint256 h) = fullMul(x, y);
717         uint256 mm = mulmod(x, y, d);
718         if (mm > l) h -= 1;
719         l -= mm;
720         require(h < d, 'FullMath::mulDiv: overflow');
721         return fullDiv(l, h, d);
722     }
723 }
724 
725 library FixedPoint {
726     // range: [0, 2**112 - 1]
727     // resolution: 1 / 2**112
728     struct uq112x112 {
729         uint224 _x;
730     }
731 
732     // range: [0, 2**144 - 1]
733     // resolution: 1 / 2**112
734     struct uq144x112 {
735         uint256 _x;
736     }
737 
738     uint8 private constant RESOLUTION = 112;
739     uint256 private constant Q112 = 0x10000000000000000000000000000;
740     uint256 private constant Q224 = 0x100000000000000000000000000000000000000000000000000000000;
741     uint256 private constant LOWER_MASK = 0xffffffffffffffffffffffffffff; // decimal of UQ*x112 (lower 112 bits)
742 
743     // encode a uint112 as a UQ112x112
744     function encode(uint112 x) internal pure returns (uq112x112 memory) {
745         return uq112x112(uint224(x) << RESOLUTION);
746     }
747 
748     // encodes a uint144 as a UQ144x112
749     function encode144(uint144 x) internal pure returns (uq144x112 memory) {
750         return uq144x112(uint256(x) << RESOLUTION);
751     }
752 
753     // decode a UQ112x112 into a uint112 by truncating after the radix point
754     function decode(uq112x112 memory self) internal pure returns (uint112) {
755         return uint112(self._x >> RESOLUTION);
756     }
757 
758     // decode a UQ144x112 into a uint144 by truncating after the radix point
759     function decode144(uq144x112 memory self) internal pure returns (uint144) {
760         return uint144(self._x >> RESOLUTION);
761     }
762 
763     // decode a uq112x112 into a uint with 18 decimals of precision
764   function decode112with18(uq112x112 memory self) internal pure returns (uint) {
765     // we only have 256 - 224 = 32 bits to spare, so scaling up by ~60 bits is dangerous
766     // instead, get close to:
767     //  (x * 1e18) >> 112
768     // without risk of overflowing, e.g.:
769     //  (x) / 2 ** (112 - lg(1e18))
770     return uint(self._x) / 5192296858534827;
771   }
772 
773     // multiply a UQ112x112 by a uint, returning a UQ144x112
774     // reverts on overflow
775     function mul(uq112x112 memory self, uint256 y) internal pure returns (uq144x112 memory) {
776         uint256 z = 0;
777         require(y == 0 || (z = self._x * y) / y == self._x, 'FixedPoint::mul: overflow');
778         return uq144x112(z);
779     }
780 
781     // multiply a UQ112x112 by an int and decode, returning an int
782     // reverts on overflow
783     function muli(uq112x112 memory self, int256 y) internal pure returns (int256) {
784         uint256 z = FullMath.mulDiv(self._x, uint256(y < 0 ? -y : y), Q112);
785         require(z < 2**255, 'FixedPoint::muli: overflow');
786         return y < 0 ? -int256(z) : int256(z);
787     }
788 
789     // multiply a UQ112x112 by a UQ112x112, returning a UQ112x112
790     // lossy
791     function muluq(uq112x112 memory self, uq112x112 memory other) internal pure returns (uq112x112 memory) {
792         if (self._x == 0 || other._x == 0) {
793             return uq112x112(0);
794         }
795         uint112 upper_self = uint112(self._x >> RESOLUTION); // * 2^0
796         uint112 lower_self = uint112(self._x & LOWER_MASK); // * 2^-112
797         uint112 upper_other = uint112(other._x >> RESOLUTION); // * 2^0
798         uint112 lower_other = uint112(other._x & LOWER_MASK); // * 2^-112
799 
800         // partial products
801         uint224 upper = uint224(upper_self) * upper_other; // * 2^0
802         uint224 lower = uint224(lower_self) * lower_other; // * 2^-224
803         uint224 uppers_lowero = uint224(upper_self) * lower_other; // * 2^-112
804         uint224 uppero_lowers = uint224(upper_other) * lower_self; // * 2^-112
805 
806         // so the bit shift does not overflow
807         require(upper <= uint112(-1), 'FixedPoint::muluq: upper overflow');
808 
809         // this cannot exceed 256 bits, all values are 224 bits
810         uint256 sum = uint256(upper << RESOLUTION) + uppers_lowero + uppero_lowers + (lower >> RESOLUTION);
811 
812         // so the cast does not overflow
813         require(sum <= uint224(-1), 'FixedPoint::muluq: sum overflow');
814 
815         return uq112x112(uint224(sum));
816     }
817 
818     // divide a UQ112x112 by a UQ112x112, returning a UQ112x112
819     function divuq(uq112x112 memory self, uq112x112 memory other) internal pure returns (uq112x112 memory) {
820         require(other._x > 0, 'FixedPoint::divuq: division by zero');
821         if (self._x == other._x) {
822             return uq112x112(uint224(Q112));
823         }
824         if (self._x <= uint144(-1)) {
825             uint256 value = (uint256(self._x) << RESOLUTION) / other._x;
826             require(value <= uint224(-1), 'FixedPoint::divuq: overflow');
827             return uq112x112(uint224(value));
828         }
829 
830         uint256 result = FullMath.mulDiv(Q112, self._x, other._x);
831         require(result <= uint224(-1), 'FixedPoint::divuq: overflow');
832         return uq112x112(uint224(result));
833     }
834 
835   // returns a uq112x112 which represents the ratio of the numerator to the denominator
836   // equivalent to encode(numerator).div(denominator)
837   // function fraction(uint112 numerator, uint112 denominator) internal pure returns (uq112x112 memory) {
838   //   require(denominator > 0, "DIV_BY_ZERO");
839   //   return uq112x112((uint224(numerator) << 112) / denominator);
840   // }
841 
842     // returns a UQ112x112 which represents the ratio of the numerator to the denominator
843     // lossy if either numerator or denominator is greater than 112 bits
844     function fraction(uint256 numerator, uint256 denominator) internal pure returns (uq112x112 memory) {
845         require(denominator > 0, 'FixedPoint::fraction: division by zero');
846         if (numerator == 0) return FixedPoint.uq112x112(0);
847 
848         if (numerator <= uint144(-1)) {
849             uint256 result = (numerator << RESOLUTION) / denominator;
850             require(result <= uint224(-1), 'FixedPoint::fraction: overflow');
851             return uq112x112(uint224(result));
852         } else {
853             uint256 result = FullMath.mulDiv(numerator, Q112, denominator);
854             require(result <= uint224(-1), 'FixedPoint::fraction: overflow');
855             return uq112x112(uint224(result));
856         }
857     }
858 
859     // take the reciprocal of a UQ112x112
860     // reverts on overflow
861     // lossy
862     function reciprocal(uq112x112 memory self) internal pure returns (uq112x112 memory) {
863         require(self._x != 0, 'FixedPoint::reciprocal: reciprocal of zero');
864         require(self._x != 1, 'FixedPoint::reciprocal: overflow');
865         return uq112x112(uint224(Q224 / self._x));
866     }
867 
868     // square root of a UQ112x112
869     // lossy between 0/1 and 40 bits
870     function sqrt(uq112x112 memory self) internal pure returns (uq112x112 memory) {
871         if (self._x <= uint144(-1)) {
872             return uq112x112(uint224(Babylonian.sqrt(uint256(self._x) << 112)));
873         }
874 
875         uint8 safeShiftBits = 255 - BitMath.mostSignificantBit(self._x);
876         safeShiftBits -= safeShiftBits % 2;
877         return uq112x112(uint224(Babylonian.sqrt(uint256(self._x) << safeShiftBits) << ((112 - safeShiftBits) / 2)));
878     }
879 }
880 
881 
882 interface IPrincipleDepository {
883 
884     function getDepositorInfo( address _depositorAddress_ ) external view returns 
885         ( uint principleValue_, uint paidOut_, uint maxPayout, uint vestingPeriod_ );
886     
887     function depositBondPrinciple( uint256 amountToDeposit_ ) external returns ( bool );
888 
889     function depositBondPrincipleWithPermit( uint256 amountToDeposit_, uint256 deadline, uint8 v, bytes32 r, bytes32 s ) external returns ( bool );
890 
891     function redeemBond() external returns ( bool );
892 
893     function calculatePercentVested( address depositor_ ) external view returns ( uint _percentVested );
894     
895     function calculatePendingPayout( address depositor_ ) external view returns ( uint _pendingPayout );
896       
897     function calculateBondInterest( uint principleValue_ ) external view returns ( uint maxPayout );
898         
899     function calculatePremium() external view returns ( uint _premium );
900 }
901 
902 interface IBondingCalculator {
903     function principleValuation( address principleTokenAddress_, uint amountDeposited_ ) external view returns ( uint principleValuation_ );
904 }
905 
906 interface ITreasury {
907     function depositPrinciple( uint depositAmount_ ) external returns ( bool );
908 }
909 
910 contract OHMPrincipleDepository is IPrincipleDepository, Ownable {
911 
912     using FixedPoint for *;
913     using SafeERC20 for IERC20;
914     using SafeMath for uint;
915 
916     struct DepositInfo {
917         uint principleValue; // Risk-Free Value of LP
918         uint payoutRemaining; // OHM remaining to be paid
919         uint lastBlock; // Last interaction
920         uint vestingPeriod; // Blocks left to vest
921     }
922 
923     mapping( address => DepositInfo ) public depositorInfo; 
924 
925     uint public bondControlVariable; // Premium scaling variable
926     uint public vestingPeriodInBlocks; 
927     uint public minPremium; // Floor for the premium
928 
929     address public treasury;
930     address public bondCalculator;
931     address public principleToken; // OHM-DAI LP
932     address public OHM;
933 
934     uint256 public totalDebt; // Total principle value of outstanding bonds
935 
936     address public stakingContract;
937     address public DAOWallet;
938     uint public DAOShare; // % = 1 / DAOShare
939 
940     bool public isInitialized;
941 
942     function initialize ( address principleToken_, address OHM_ ) external onlyOwner() returns ( bool ) {
943         require( isInitialized == false );
944         principleToken = principleToken_;
945         OHM = OHM_;
946 
947         isInitialized = true;
948 
949         return true;
950     }
951 
952     function setAddresses( address bondCalculator_, address treasury_, address stakingContract_, 
953     address DAOWallet_, uint DAOShare_ ) external onlyOwner() returns ( bool ) {
954         bondCalculator = bondCalculator_;
955         treasury = treasury_;
956         stakingContract = stakingContract_;
957         DAOWallet = DAOWallet_;
958         DAOShare = DAOShare_;
959         return true;
960     }
961 
962     function setBondTerms( uint bondControlVariable_, uint vestingPeriodInBlocks_, uint minPremium_ ) 
963     external onlyOwner() returns ( bool ) {
964         bondControlVariable = bondControlVariable_;
965         vestingPeriodInBlocks = vestingPeriodInBlocks_;
966         minPremium = minPremium_;
967         return true;
968     }
969 
970     function getDepositorInfo( address depositorAddress_ ) external view override returns 
971     ( uint _principleValue, uint _payoutRemaining, uint _lastBlock, uint _vestingPeriod ) {
972         DepositInfo memory depositorInfo_ = depositorInfo[ depositorAddress_ ];
973         _principleValue = depositorInfo_.principleValue;
974         _payoutRemaining = depositorInfo_.payoutRemaining;
975         _lastBlock = depositorInfo_.lastBlock;
976         _vestingPeriod = depositorInfo_.vestingPeriod;
977     }
978 
979     function depositBondPrinciple( uint amountToDeposit_ ) external override returns ( bool ) {
980         _depositBondPrinciple( amountToDeposit_ ) ;
981         return true;
982     }
983 
984     function depositBondPrincipleWithPermit( uint amountToDeposit_, uint deadline, uint8 v, bytes32 r, bytes32 s ) 
985     external override returns ( bool ) {
986         ERC20Permit( principleToken ).permit( msg.sender, address(this), amountToDeposit_, deadline, v, r, s );
987         _depositBondPrinciple( amountToDeposit_ ) ;
988         return true;
989     }
990 
991     function _depositBondPrinciple( uint amountToDeposit_ ) internal returns ( bool ){
992         IERC20( principleToken ).safeTransferFrom( msg.sender, address(this), amountToDeposit_ );
993 
994         uint principleValue_ = IBondingCalculator( bondCalculator )
995             .principleValuation( principleToken, amountToDeposit_ ).div( 1e9 );
996 
997         uint payout_ = _calculateBondInterest( principleValue_ );
998 
999         require( payout_ >= 10000000, "Bond too small" );
1000 
1001         totalDebt = totalDebt.add( principleValue_ );
1002 
1003         uint profit_ = principleValue_.sub( payout_ );
1004         uint DAOProfit_ = FixedPoint.fraction( profit_, DAOShare ).decode();
1005 
1006         IUniswapV2ERC20( principleToken ).approve( address( treasury ), amountToDeposit_ );
1007 
1008         ITreasury( treasury ).depositPrinciple( amountToDeposit_ ); // Returns OHM
1009 
1010         IERC20( OHM ).safeTransfer( stakingContract, profit_.sub( DAOProfit_ ) );
1011         IERC20( OHM ).safeTransfer( DAOWallet, DAOProfit_ );
1012 
1013         depositorInfo[msg.sender] = DepositInfo({
1014             principleValue: depositorInfo[msg.sender].principleValue.add( principleValue_ ),
1015             payoutRemaining: depositorInfo[msg.sender].payoutRemaining.add( payout_ ),
1016             lastBlock: block.number,
1017             vestingPeriod: vestingPeriodInBlocks
1018         });
1019         return true;
1020     }
1021 
1022     function redeemBond() external override returns ( bool ) {
1023         uint payoutRemaining_ = depositorInfo[msg.sender].payoutRemaining;
1024 
1025         require( payoutRemaining_ > 0, "Sender is not due any interest." );
1026 
1027         uint principleValue_ = depositorInfo[msg.sender].principleValue;
1028 
1029         uint blocksSinceLast_ = block.number.sub( depositorInfo[msg.sender].lastBlock );
1030 
1031         uint vestingPeriod_ = depositorInfo[msg.sender].vestingPeriod;
1032 
1033         uint percentVested_ = _calculatePercentVested( msg.sender );
1034 
1035         if ( percentVested_ >= 10000 ) {
1036             delete depositorInfo[msg.sender];
1037 
1038             IERC20( OHM ).safeTransfer( msg.sender, payoutRemaining_ );
1039             totalDebt = totalDebt.sub( principleValue_ );
1040 
1041             return true;
1042         }
1043 
1044         uint payout_ = payoutRemaining_.mul( percentVested_ ).div( 10000 );
1045         IERC20( OHM ).safeTransfer( msg.sender, payout_ );
1046 
1047         uint principleUsed_ = principleValue_.mul( percentVested_ ).div( 10000 );
1048         totalDebt = totalDebt.sub( principleUsed_ );
1049 
1050         depositorInfo[msg.sender] = DepositInfo({
1051             principleValue: principleValue_.sub( principleUsed_ ),
1052             payoutRemaining: payoutRemaining_.sub( payout_ ),
1053             lastBlock: block.number,
1054             vestingPeriod: vestingPeriod_.sub( blocksSinceLast_ )
1055         });
1056         return true;
1057     }
1058 
1059     function calculatePercentVested( address depositor_ ) external view override returns ( uint _percentVested ) {
1060         _percentVested = _calculatePercentVested( depositor_ );
1061     }
1062 
1063     // In thousandths ( 1 = 0.01% )
1064     function _calculatePercentVested( address depositor_ ) internal view returns ( uint _percentVested ) {
1065         uint blocksSinceLast_ = block.number.sub( depositorInfo[ depositor_ ].lastBlock );
1066 
1067         uint vestingPeriod_ = depositorInfo[ depositor_ ].vestingPeriod;
1068 
1069         if ( vestingPeriod_ > 0 ) {
1070             _percentVested = blocksSinceLast_.mul( 10000 ).div( vestingPeriod_ );
1071         } else {
1072             _percentVested = 0;
1073         }
1074     }
1075 
1076     function calculatePendingPayout( address depositor_ ) external view override returns ( uint _pendingPayout ) {
1077         uint percentVested_ = _calculatePercentVested( depositor_ );
1078         uint payoutRemaining_ = depositorInfo[ depositor_ ].payoutRemaining;
1079         
1080         _pendingPayout = payoutRemaining_.mul( percentVested_ ).div( 10000 );
1081 
1082         if ( percentVested_ >= 10000 ) {
1083             _pendingPayout = payoutRemaining_;
1084         } 
1085     }
1086 
1087     function calculateBondInterest( uint amountToDeposit_ ) external view override returns ( uint _interestDue ) {
1088         uint principleValue_ = IBondingCalculator( bondCalculator ).principleValuation( principleToken, amountToDeposit_ ).div( 1e9 );
1089         _interestDue = _calculateBondInterest( principleValue_ );
1090     }
1091 
1092     function _calculateBondInterest( uint principleValue_ ) internal view returns ( uint _interestDue ) {
1093         _interestDue = FixedPoint.fraction( principleValue_, _calcPremium() ).decode112with18().div( 1e16 );
1094     }
1095 
1096     function calculatePremium() external view override returns ( uint _premium ) {
1097         _premium = _calcPremium();
1098     }
1099 
1100     function _calcPremium() internal view returns ( uint _premium ) {
1101         _premium = bondControlVariable.mul( _calcDebtRatio() ).add( uint(1000000000) ).div( 1e7 );
1102         if ( _premium < minPremium ) {
1103             _premium = minPremium;
1104         }
1105     }
1106 
1107     function _calcDebtRatio() internal view returns ( uint _debtRatio ) {    
1108         _debtRatio = FixedPoint.fraction( 
1109             // Must move the decimal to the right by 9 places to avoid math underflow error
1110             totalDebt.mul( 1e9 ), 
1111             IERC20( OHM ).totalSupply()
1112         ).decode112with18().div( 1e18 );
1113         // Must move the decimal tot he left 18 places to account for the 9 places added above and the 19 signnificant digits added by FixedPoint.
1114     }
1115 }