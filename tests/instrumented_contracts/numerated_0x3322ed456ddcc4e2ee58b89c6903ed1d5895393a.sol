1 /**
2  *Submitted for verification at Etherscan.io on 2020-12-01
3 */
4 
5 pragma solidity ^0.6.0;
6 pragma experimental ABIEncoderV2;
7 
8 
9  abstract contract Manager {
10     function last(address) virtual public returns (uint);
11     function cdpCan(address, uint, address) virtual public view returns (uint);
12     function ilks(uint) virtual public view returns (bytes32);
13     function owns(uint) virtual public view returns (address);
14     function urns(uint) virtual public view returns (address);
15     function vat() virtual public view returns (address);
16     function open(bytes32, address) virtual public returns (uint);
17     function give(uint, address) virtual public;
18     function cdpAllow(uint, address, uint) virtual public;
19     function urnAllow(address, uint) virtual public;
20     function frob(uint, int, int) virtual public;
21     function flux(uint, address, uint) virtual public;
22     function move(uint, address, uint) virtual public;
23     function exit(address, uint, address, uint) virtual public;
24     function quit(uint, address) virtual public;
25     function enter(address, uint) virtual public;
26     function shift(uint, uint) virtual public;
27 } abstract contract Vat {
28 
29     struct Urn {
30         uint256 ink;   // Locked Collateral  [wad]
31         uint256 art;   // Normalised Debt    [wad]
32     }
33 
34     struct Ilk {
35         uint256 Art;   // Total Normalised Debt     [wad]
36         uint256 rate;  // Accumulated Rates         [ray]
37         uint256 spot;  // Price with Safety Margin  [ray]
38         uint256 line;  // Debt Ceiling              [rad]
39         uint256 dust;  // Urn Debt Floor            [rad]
40     }
41 
42     mapping (bytes32 => mapping (address => Urn )) public urns;
43     mapping (bytes32 => Ilk)                       public ilks;
44     mapping (bytes32 => mapping (address => uint)) public gem;  // [wad]
45 
46     function can(address, address) virtual public view returns (uint);
47     function dai(address) virtual public view returns (uint);
48     function frob(bytes32, address, address, address, int, int) virtual public;
49     function hope(address) virtual public;
50     function move(address, address, uint) virtual public;
51     function fork(bytes32, address, address, int, int) virtual public;
52 } abstract contract PipInterface {
53     function read() public virtual returns (bytes32);
54 } abstract contract Spotter {
55     struct Ilk {
56         PipInterface pip;
57         uint256 mat;
58     }
59 
60     mapping (bytes32 => Ilk) public ilks;
61 
62     uint256 public par;
63 
64 } contract DSMath {
65     function add(uint256 x, uint256 y) internal pure returns (uint256 z) {
66         require((z = x + y) >= x);
67     }
68 
69     function sub(uint256 x, uint256 y) internal pure returns (uint256 z) {
70         require((z = x - y) <= x);
71     }
72 
73     function mul(uint256 x, uint256 y) internal pure returns (uint256 z) {
74         require(y == 0 || (z = x * y) / y == x);
75     }
76 
77     function div(uint256 x, uint256 y) internal pure returns (uint256 z) {
78         return x / y;
79     }
80 
81     function min(uint256 x, uint256 y) internal pure returns (uint256 z) {
82         return x <= y ? x : y;
83     }
84 
85     function max(uint256 x, uint256 y) internal pure returns (uint256 z) {
86         return x >= y ? x : y;
87     }
88 
89     function imin(int256 x, int256 y) internal pure returns (int256 z) {
90         return x <= y ? x : y;
91     }
92 
93     function imax(int256 x, int256 y) internal pure returns (int256 z) {
94         return x >= y ? x : y;
95     }
96 
97     uint256 constant WAD = 10**18;
98     uint256 constant RAY = 10**27;
99 
100     function wmul(uint256 x, uint256 y) internal pure returns (uint256 z) {
101         z = add(mul(x, y), WAD / 2) / WAD;
102     }
103 
104     function rmul(uint256 x, uint256 y) internal pure returns (uint256 z) {
105         z = add(mul(x, y), RAY / 2) / RAY;
106     }
107 
108     function wdiv(uint256 x, uint256 y) internal pure returns (uint256 z) {
109         z = add(mul(x, WAD), y / 2) / y;
110     }
111 
112     function rdiv(uint256 x, uint256 y) internal pure returns (uint256 z) {
113         z = add(mul(x, RAY), y / 2) / y;
114     }
115 
116     // This famous algorithm is called "exponentiation by squaring"
117     // and calculates x^n with x as fixed-point and n as regular unsigned.
118     //
119     // It's O(log n), instead of O(n) for naive repeated multiplication.
120     //
121     // These facts are why it works:
122     //
123     //  If n is even, then x^n = (x^2)^(n/2).
124     //  If n is odd,  then x^n = x * x^(n-1),
125     //   and applying the equation for even x gives
126     //    x^n = x * (x^2)^((n-1) / 2).
127     //
128     //  Also, EVM division is flooring and
129     //    floor[(n-1) / 2] = floor[n / 2].
130     //
131     function rpow(uint256 x, uint256 n) internal pure returns (uint256 z) {
132         z = n % 2 != 0 ? x : RAY;
133 
134         for (n /= 2; n != 0; n /= 2) {
135             x = rmul(x, x);
136 
137             if (n % 2 != 0) {
138                 z = rmul(z, x);
139             }
140         }
141     }
142 } interface ERC20 {
143     function totalSupply() external view returns (uint256 supply);
144 
145     function balanceOf(address _owner) external view returns (uint256 balance);
146 
147     function transfer(address _to, uint256 _value) external returns (bool success);
148 
149     function transferFrom(address _from, address _to, uint256 _value)
150         external
151         returns (bool success);
152 
153     function approve(address _spender, uint256 _value) external returns (bool success);
154 
155     function allowance(address _owner, address _spender) external view returns (uint256 remaining);
156 
157     function decimals() external view returns (uint256 digits);
158 
159     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
160 } library Address {
161     function isContract(address account) internal view returns (bool) {
162         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
163         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
164         // for accounts without code, i.e. `keccak256('')`
165         bytes32 codehash;
166         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
167         // solhint-disable-next-line no-inline-assembly
168         assembly { codehash := extcodehash(account) }
169         return (codehash != accountHash && codehash != 0x0);
170     }
171 
172     function sendValue(address payable recipient, uint256 amount) internal {
173         require(address(this).balance >= amount, "Address: insufficient balance");
174 
175         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
176         (bool success, ) = recipient.call{ value: amount }("");
177         require(success, "Address: unable to send value, recipient may have reverted");
178     }
179 
180     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
181       return functionCall(target, data, "Address: low-level call failed");
182     }
183 
184     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
185         return _functionCallWithValue(target, data, 0, errorMessage);
186     }
187 
188     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
189         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
190     }
191 
192     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
193         require(address(this).balance >= value, "Address: insufficient balance for call");
194         return _functionCallWithValue(target, data, value, errorMessage);
195     }
196 
197     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
198         require(isContract(target), "Address: call to non-contract");
199 
200         // solhint-disable-next-line avoid-low-level-calls
201         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
202         if (success) {
203             return returndata;
204         } else {
205             // Look for revert reason and bubble it up if present
206             if (returndata.length > 0) {
207                 // The easiest way to bubble the revert reason is using memory via assembly
208 
209                 // solhint-disable-next-line no-inline-assembly
210                 assembly {
211                     let returndata_size := mload(returndata)
212                     revert(add(32, returndata), returndata_size)
213                 }
214             } else {
215                 revert(errorMessage);
216             }
217         }
218     }
219 } library SafeMath {
220     function add(uint256 a, uint256 b) internal pure returns (uint256) {
221         uint256 c = a + b;
222         require(c >= a, "SafeMath: addition overflow");
223 
224         return c;
225     }
226 
227     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
228         return sub(a, b, "SafeMath: subtraction overflow");
229     }
230 
231     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
232         require(b <= a, errorMessage);
233         uint256 c = a - b;
234 
235         return c;
236     }
237 
238     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
239         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
240         // benefit is lost if 'b' is also tested.
241         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
242         if (a == 0) {
243             return 0;
244         }
245 
246         uint256 c = a * b;
247         require(c / a == b, "SafeMath: multiplication overflow");
248 
249         return c;
250     }
251 
252     function div(uint256 a, uint256 b) internal pure returns (uint256) {
253         return div(a, b, "SafeMath: division by zero");
254     }
255 
256     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
257         require(b > 0, errorMessage);
258         uint256 c = a / b;
259         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
260 
261         return c;
262     }
263 
264     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
265         return mod(a, b, "SafeMath: modulo by zero");
266     }
267 
268     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
269         require(b != 0, errorMessage);
270         return a % b;
271     }
272 } library SafeERC20 {
273     using SafeMath for uint256;
274     using Address for address;
275 
276     function safeTransfer(ERC20 token, address to, uint256 value) internal {
277         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
278     }
279 
280     function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
281         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
282     }
283 
284     /**
285      * @dev Deprecated. This function has issues similar to the ones found in
286      * {IERC20-approve}, and its usage is discouraged.
287      */
288     function safeApprove(ERC20 token, address spender, uint256 value) internal {
289         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, 0));
290         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
291     }
292 
293     function safeIncreaseAllowance(ERC20 token, address spender, uint256 value) internal {
294         uint256 newAllowance = token.allowance(address(this), spender).add(value);
295         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
296     }
297 
298     function safeDecreaseAllowance(ERC20 token, address spender, uint256 value) internal {
299         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
300         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
301     }
302 
303     function _callOptionalReturn(ERC20 token, bytes memory data) private {
304 
305         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
306         if (returndata.length > 0) { // Return data is optional
307             // solhint-disable-next-line max-line-length
308             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
309         }
310     }
311 } contract AdminAuth {
312 
313     using SafeERC20 for ERC20;
314 
315     address public owner;
316     address public admin;
317 
318     modifier onlyOwner() {
319         require(owner == msg.sender);
320         _;
321     }
322 
323     modifier onlyAdmin() {
324         require(admin == msg.sender);
325         _;
326     }
327 
328     constructor() public {
329         owner = msg.sender;
330         admin = 0x25eFA336886C74eA8E282ac466BdCd0199f85BB9;
331     }
332 
333     /// @notice Admin is set by owner first time, after that admin is super role and has permission to change owner
334     /// @param _admin Address of multisig that becomes admin
335     function setAdminByOwner(address _admin) public {
336         require(msg.sender == owner);
337         require(admin == address(0));
338 
339         admin = _admin;
340     }
341 
342     /// @notice Admin is able to set new admin
343     /// @param _admin Address of multisig that becomes new admin
344     function setAdminByAdmin(address _admin) public {
345         require(msg.sender == admin);
346 
347         admin = _admin;
348     }
349 
350     /// @notice Admin is able to change owner
351     /// @param _owner Address of new owner
352     function setOwnerByAdmin(address _owner) public {
353         require(msg.sender == admin);
354 
355         owner = _owner;
356     }
357 
358     /// @notice Destroy the contract
359     function kill() public onlyOwner {
360         selfdestruct(payable(owner));
361     }
362 
363     /// @notice  withdraw stuck funds
364     function withdrawStuckFunds(address _token, uint _amount) public onlyOwner {
365         if (_token == 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE) {
366             payable(owner).transfer(_amount);
367         } else {
368             ERC20(_token).safeTransfer(owner, _amount);
369         }
370     }
371 } contract DefisaverLogger {
372     event LogEvent(
373         address indexed contractAddress,
374         address indexed caller,
375         string indexed logName,
376         bytes data
377     );
378 
379     // solhint-disable-next-line func-name-mixedcase
380     function Log(address _contract, address _caller, string memory _logName, bytes memory _data)
381         public
382     {
383         emit LogEvent(_contract, _caller, _logName, _data);
384     }
385 } abstract contract GasTokenInterface is ERC20 {
386     function free(uint256 value) public virtual returns (bool success);
387 
388     function freeUpTo(uint256 value) public virtual returns (uint256 freed);
389 
390     function freeFrom(address from, uint256 value) public virtual returns (bool success);
391 
392     function freeFromUpTo(address from, uint256 value) public virtual returns (uint256 freed);
393 } contract GasBurner {
394     // solhint-disable-next-line const-name-snakecase
395     GasTokenInterface public constant gasToken = GasTokenInterface(0x0000000000b3F879cb30FE243b4Dfee438691c04);
396 
397     modifier burnGas(uint _amount) {
398         if (gasToken.balanceOf(address(this)) >= _amount) {
399             gasToken.free(_amount);
400         }
401 
402         _;
403     }
404 } contract BotRegistry is AdminAuth {
405 
406     mapping (address => bool) public botList;
407 
408     constructor() public {
409         botList[0x776B4a13093e30B05781F97F6A4565B6aa8BE330] = true;
410 
411         botList[0xAED662abcC4FA3314985E67Ea993CAD064a7F5cF] = true;
412         botList[0xa5d330F6619d6bF892A5B87D80272e1607b3e34D] = true;
413         botList[0x5feB4DeE5150B589a7f567EA7CADa2759794A90A] = true;
414         botList[0x7ca06417c1d6f480d3bB195B80692F95A6B66158] = true;
415     }
416 
417     function setBot(address _botAddr, bool _state) public onlyOwner {
418         botList[_botAddr] = _state;
419     }
420 
421 } abstract contract TokenInterface {
422     function allowance(address, address) public virtual returns (uint256);
423 
424     function balanceOf(address) public virtual returns (uint256);
425 
426     function approve(address, uint256) public virtual;
427 
428     function transfer(address, uint256) public virtual returns (bool);
429 
430     function transferFrom(address, address, uint256) public virtual returns (bool);
431 
432     function deposit() public virtual payable;
433 
434     function withdraw(uint256) public virtual;
435 } interface ExchangeInterfaceV2 {
436     function sell(address _srcAddr, address _destAddr, uint _srcAmount) external payable returns (uint);
437 
438     function buy(address _srcAddr, address _destAddr, uint _destAmount) external payable returns(uint);
439 
440     function getSellRate(address _srcAddr, address _destAddr, uint _srcAmount) external view returns (uint);
441 
442     function getBuyRate(address _srcAddr, address _destAddr, uint _srcAmount) external view returns (uint);
443 } contract ZrxAllowlist is AdminAuth {
444 
445     mapping (address => bool) public zrxAllowlist;
446     mapping(address => bool) private nonPayableAddrs;
447 
448     constructor() public {
449         zrxAllowlist[0x6958F5e95332D93D21af0D7B9Ca85B8212fEE0A5] = true;
450         zrxAllowlist[0x61935CbDd02287B511119DDb11Aeb42F1593b7Ef] = true;
451         zrxAllowlist[0xDef1C0ded9bec7F1a1670819833240f027b25EfF] = true;
452         zrxAllowlist[0x080bf510FCbF18b91105470639e9561022937712] = true;
453 
454         nonPayableAddrs[0x080bf510FCbF18b91105470639e9561022937712] = true;
455     }
456 
457     function setAllowlistAddr(address _zrxAddr, bool _state) public onlyOwner {
458         zrxAllowlist[_zrxAddr] = _state;
459     }
460 
461     function isZrxAddr(address _zrxAddr) public view returns (bool) {
462         return zrxAllowlist[_zrxAddr];
463     }
464 
465     function addNonPayableAddr(address _nonPayableAddr) public onlyOwner {
466 		nonPayableAddrs[_nonPayableAddr] = true;
467 	}
468 
469 	function removeNonPayableAddr(address _nonPayableAddr) public onlyOwner {
470 		nonPayableAddrs[_nonPayableAddr] = false;
471 	}
472 
473 	function isNonPayableAddr(address _addr) public view returns(bool) {
474 		return nonPayableAddrs[_addr];
475 	}
476 } contract Discount {
477     address public owner;
478     mapping(address => CustomServiceFee) public serviceFees;
479 
480     uint256 constant MAX_SERVICE_FEE = 400;
481 
482     struct CustomServiceFee {
483         bool active;
484         uint256 amount;
485     }
486 
487     constructor() public {
488         owner = msg.sender;
489     }
490 
491     function isCustomFeeSet(address _user) public view returns (bool) {
492         return serviceFees[_user].active;
493     }
494 
495     function getCustomServiceFee(address _user) public view returns (uint256) {
496         return serviceFees[_user].amount;
497     }
498 
499     function setServiceFee(address _user, uint256 _fee) public {
500         require(msg.sender == owner, "Only owner");
501         require(_fee >= MAX_SERVICE_FEE || _fee == 0);
502 
503         serviceFees[_user] = CustomServiceFee({active: true, amount: _fee});
504     }
505 
506     function disableServiceFee(address _user) public {
507         require(msg.sender == owner, "Only owner");
508 
509         serviceFees[_user] = CustomServiceFee({active: false, amount: 0});
510     }
511 } contract SaverExchangeHelper {
512 
513     using SafeERC20 for ERC20;
514 
515     address public constant KYBER_ETH_ADDRESS = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
516     address public constant WETH_ADDRESS = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
517 
518     address payable public constant WALLET_ID = 0x322d58b9E75a6918f7e7849AEe0fF09369977e08;
519     address public constant DISCOUNT_ADDRESS = 0x1b14E8D511c9A4395425314f849bD737BAF8208F;
520     address public constant SAVER_EXCHANGE_REGISTRY = 0x25dd3F51e0C3c3Ff164DDC02A8E4D65Bb9cBB12D;
521 
522     address public constant ERC20_PROXY_0X = 0x95E6F48254609A6ee006F7D493c8e5fB97094ceF;
523     address public constant ZRX_ALLOWLIST_ADDR = 0x4BA1f38427b33B8ab7Bb0490200dAE1F1C36823F;
524 
525 
526     function getDecimals(address _token) internal view returns (uint256) {
527         if (_token == KYBER_ETH_ADDRESS) return 18;
528 
529         return ERC20(_token).decimals();
530     }
531 
532     function getBalance(address _tokenAddr) internal view returns (uint balance) {
533         if (_tokenAddr == KYBER_ETH_ADDRESS) {
534             balance = address(this).balance;
535         } else {
536             balance = ERC20(_tokenAddr).balanceOf(address(this));
537         }
538     }
539 
540     function approve0xProxy(address _tokenAddr, uint _amount) internal {
541         if (_tokenAddr != KYBER_ETH_ADDRESS) {
542             ERC20(_tokenAddr).safeApprove(address(ERC20_PROXY_0X), _amount);
543         }
544     }
545 
546     function sendLeftover(address _srcAddr, address _destAddr, address payable _to) internal {
547         // send back any leftover ether or tokens
548         if (address(this).balance > 0) {
549             _to.transfer(address(this).balance);
550         }
551 
552         if (getBalance(_srcAddr) > 0) {
553             ERC20(_srcAddr).safeTransfer(_to, getBalance(_srcAddr));
554         }
555 
556         if (getBalance(_destAddr) > 0) {
557             ERC20(_destAddr).safeTransfer(_to, getBalance(_destAddr));
558         }
559     }
560 
561     function sliceUint(bytes memory bs, uint256 start) internal pure returns (uint256) {
562         require(bs.length >= start + 32, "slicing out of range");
563 
564         uint256 x;
565         assembly {
566             x := mload(add(bs, add(0x20, start)))
567         }
568 
569         return x;
570     }
571 } contract SaverExchangeRegistry is AdminAuth {
572 
573 	mapping(address => bool) private wrappers;
574 
575 	constructor() public {
576 		wrappers[0x880A845A85F843a5c67DB2061623c6Fc3bB4c511] = true;
577 		wrappers[0x4c9B55f2083629A1F7aDa257ae984E03096eCD25] = true;
578 		wrappers[0x42A9237b872368E1bec4Ca8D26A928D7d39d338C] = true;
579 	}
580 
581 	function addWrapper(address _wrapper) public onlyOwner {
582 		wrappers[_wrapper] = true;
583 	}
584 
585 	function removeWrapper(address _wrapper) public onlyOwner {
586 		wrappers[_wrapper] = false;
587 	}
588 
589 	function isWrapper(address _wrapper) public view returns(bool) {
590 		return wrappers[_wrapper];
591 	}
592 }
593 
594 
595 
596 
597 
598 
599 
600 
601 contract SaverExchangeCore is SaverExchangeHelper, DSMath {
602 
603     // first is empty to keep the legacy order in place
604     enum ExchangeType { _, OASIS, KYBER, UNISWAP, ZEROX }
605 
606     enum ActionType { SELL, BUY }
607 
608     struct ExchangeData {
609         address srcAddr;
610         address destAddr;
611         uint srcAmount;
612         uint destAmount;
613         uint minPrice;
614         address wrapper;
615         address exchangeAddr;
616         bytes callData;
617         uint256 price0x;
618     }
619 
620     /// @notice Internal method that preforms a sell on 0x/on-chain
621     /// @dev Usefull for other DFS contract to integrate for exchanging
622     /// @param exData Exchange data struct
623     /// @return (address, uint) Address of the wrapper used and destAmount
624     function _sell(ExchangeData memory exData) internal returns (address, uint) {
625 
626         address wrapper;
627         uint swapedTokens;
628         bool success;
629         uint tokensLeft = exData.srcAmount;
630 
631         // if selling eth, convert to weth
632         if (exData.srcAddr == KYBER_ETH_ADDRESS) {
633             exData.srcAddr = ethToWethAddr(exData.srcAddr);
634             TokenInterface(WETH_ADDRESS).deposit.value(exData.srcAmount)();
635         }
636 
637         // Try 0x first and then fallback on specific wrapper
638         if (exData.price0x > 0) {
639             approve0xProxy(exData.srcAddr, exData.srcAmount);
640 
641             uint ethAmount = getProtocolFee(exData.srcAddr, exData.srcAmount);
642             (success, swapedTokens, tokensLeft) = takeOrder(exData, ethAmount, ActionType.SELL);
643 
644             if (success) {
645                 wrapper = exData.exchangeAddr;
646             }
647         }
648 
649         // fallback to desired wrapper if 0x failed
650         if (!success) {
651             swapedTokens = saverSwap(exData, ActionType.SELL);
652             wrapper = exData.wrapper;
653         }
654 
655         require(getBalance(exData.destAddr) >= wmul(exData.minPrice, exData.srcAmount), "Final amount isn't correct");
656 
657         // if anything is left in weth, pull it to user as eth
658         if (getBalance(WETH_ADDRESS) > 0) {
659             TokenInterface(WETH_ADDRESS).withdraw(
660                 TokenInterface(WETH_ADDRESS).balanceOf(address(this))
661             );
662         }
663 
664         return (wrapper, swapedTokens);
665     }
666 
667     /// @notice Internal method that preforms a buy on 0x/on-chain
668     /// @dev Usefull for other DFS contract to integrate for exchanging
669     /// @param exData Exchange data struct
670     /// @return (address, uint) Address of the wrapper used and srcAmount
671     function _buy(ExchangeData memory exData) internal returns (address, uint) {
672 
673         address wrapper;
674         uint swapedTokens;
675         bool success;
676 
677         require(exData.destAmount != 0, "Dest amount must be specified");
678 
679         // if selling eth, convert to weth
680         if (exData.srcAddr == KYBER_ETH_ADDRESS) {
681             exData.srcAddr = ethToWethAddr(exData.srcAddr);
682             TokenInterface(WETH_ADDRESS).deposit.value(exData.srcAmount)();
683         }
684 
685         if (exData.price0x > 0) {
686             approve0xProxy(exData.srcAddr, exData.srcAmount);
687 
688             uint ethAmount = getProtocolFee(exData.srcAddr, exData.srcAmount);
689             (success, swapedTokens,) = takeOrder(exData, ethAmount, ActionType.BUY);
690 
691             if (success) {
692                 wrapper = exData.exchangeAddr;
693             }
694         }
695 
696         // fallback to desired wrapper if 0x failed
697         if (!success) {
698             swapedTokens = saverSwap(exData, ActionType.BUY);
699             wrapper = exData.wrapper;
700         }
701 
702         require(getBalance(exData.destAddr) >= exData.destAmount, "Final amount isn't correct");
703 
704         // if anything is left in weth, pull it to user as eth
705         if (getBalance(WETH_ADDRESS) > 0) {
706             TokenInterface(WETH_ADDRESS).withdraw(
707                 TokenInterface(WETH_ADDRESS).balanceOf(address(this))
708             );
709         }
710 
711         return (wrapper, getBalance(exData.destAddr));
712     }
713 
714     /// @notice Takes order from 0x and returns bool indicating if it is successful
715     /// @param _exData Exchange data
716     /// @param _ethAmount Ether fee needed for 0x order
717     function takeOrder(
718         ExchangeData memory _exData,
719         uint256 _ethAmount,
720         ActionType _type
721     ) private returns (bool success, uint256, uint256) {
722 
723         // write in the exact amount we are selling/buing in an order
724         if (_type == ActionType.SELL) {
725             writeUint256(_exData.callData, 36, _exData.srcAmount);
726         } else {
727             writeUint256(_exData.callData, 36, _exData.destAmount);
728         }
729 
730         if (ZrxAllowlist(ZRX_ALLOWLIST_ADDR).isNonPayableAddr(_exData.exchangeAddr)) {
731             _ethAmount = 0;
732         }
733 
734         uint256 tokensBefore = getBalance(_exData.destAddr);
735 
736         if (ZrxAllowlist(ZRX_ALLOWLIST_ADDR).isZrxAddr(_exData.exchangeAddr)) {
737             (success, ) = _exData.exchangeAddr.call{value: _ethAmount}(_exData.callData);
738         } else {
739             success = false;
740         }
741 
742         uint256 tokensSwaped = 0;
743         uint256 tokensLeft = _exData.srcAmount;
744 
745         if (success) {
746             // check to see if any _src tokens are left over after exchange
747             tokensLeft = getBalance(_exData.srcAddr);
748 
749             // convert weth -> eth if needed
750             if (_exData.destAddr == KYBER_ETH_ADDRESS) {
751                 TokenInterface(WETH_ADDRESS).withdraw(
752                     TokenInterface(WETH_ADDRESS).balanceOf(address(this))
753                 );
754             }
755 
756             // get the current balance of the swaped tokens
757             tokensSwaped = getBalance(_exData.destAddr) - tokensBefore;
758         }
759 
760         return (success, tokensSwaped, tokensLeft);
761     }
762 
763     /// @notice Calls wraper contract for exchage to preform an on-chain swap
764     /// @param _exData Exchange data struct
765     /// @param _type Type of action SELL|BUY
766     /// @return swapedTokens For Sell that the destAmount, for Buy thats the srcAmount
767     function saverSwap(ExchangeData memory _exData, ActionType _type) internal returns (uint swapedTokens) {
768         require(SaverExchangeRegistry(SAVER_EXCHANGE_REGISTRY).isWrapper(_exData.wrapper), "Wrapper is not valid");
769 
770         uint ethValue = 0;
771 
772         ERC20(_exData.srcAddr).safeTransfer(_exData.wrapper, _exData.srcAmount);
773 
774         if (_type == ActionType.SELL) {
775             swapedTokens = ExchangeInterfaceV2(_exData.wrapper).
776                     sell{value: ethValue}(_exData.srcAddr, _exData.destAddr, _exData.srcAmount);
777         } else {
778             swapedTokens = ExchangeInterfaceV2(_exData.wrapper).
779                     buy{value: ethValue}(_exData.srcAddr, _exData.destAddr, _exData.destAmount);
780         }
781     }
782 
783     function writeUint256(bytes memory _b, uint256 _index, uint _input) internal pure {
784         if (_b.length < _index + 32) {
785             revert("Incorrent lengt while writting bytes32");
786         }
787 
788         bytes32 input = bytes32(_input);
789 
790         _index += 32;
791 
792         // Read the bytes32 from array memory
793         assembly {
794             mstore(add(_b, _index), input)
795         }
796     }
797 
798     /// @notice Converts Kybers Eth address -> Weth
799     /// @param _src Input address
800     function ethToWethAddr(address _src) internal pure returns (address) {
801         return _src == KYBER_ETH_ADDRESS ? WETH_ADDRESS : _src;
802     }
803 
804     /// @notice Calculates protocol fee
805     /// @param _srcAddr selling token address (if eth should be WETH)
806     /// @param _srcAmount amount we are selling
807     function getProtocolFee(address _srcAddr, uint256 _srcAmount) internal view returns(uint256) {
808         // if we are not selling ETH msg value is always the protocol fee
809         if (_srcAddr != WETH_ADDRESS) return address(this).balance;
810 
811         // if msg value is larger than srcAmount, that means that msg value is protocol fee + srcAmount, so we subsctract srcAmount from msg value
812         // we have an edge case here when protocol fee is higher than selling amount
813         if (address(this).balance > _srcAmount) return address(this).balance - _srcAmount;
814 
815         // if msg value is lower than src amount, that means that srcAmount isn't included in msg value, so we return msg value
816         return address(this).balance;
817     }
818 
819     function packExchangeData(ExchangeData memory _exData) public pure returns(bytes memory) {
820         // splitting in two different bytes and encoding all because of stack too deep in decoding part
821 
822         bytes memory part1 = abi.encode(
823             _exData.srcAddr,
824             _exData.destAddr,
825             _exData.srcAmount,
826             _exData.destAmount
827         );
828 
829         bytes memory part2 = abi.encode(
830             _exData.minPrice,
831             _exData.wrapper,
832             _exData.exchangeAddr,
833             _exData.callData,
834             _exData.price0x
835         );
836 
837 
838         return abi.encode(part1, part2);
839     }
840 
841     function unpackExchangeData(bytes memory _data) public pure returns(ExchangeData memory _exData) {
842         (
843             bytes memory part1,
844             bytes memory part2
845         ) = abi.decode(_data, (bytes,bytes));
846 
847         (
848             _exData.srcAddr,
849             _exData.destAddr,
850             _exData.srcAmount,
851             _exData.destAmount
852         ) = abi.decode(part1, (address,address,uint256,uint256));
853 
854         (
855             _exData.minPrice,
856             _exData.wrapper,
857             _exData.exchangeAddr,
858             _exData.callData,
859             _exData.price0x
860         )
861         = abi.decode(part2, (uint256,address,address,bytes,uint256));
862     }
863 
864     // solhint-disable-next-line no-empty-blocks
865     receive() external virtual payable {}
866 } /// @title Implements enum Method
867 abstract contract StaticV2 {
868 
869     enum Method { Boost, Repay }
870 
871     struct CdpHolder {
872         uint128 minRatio;
873         uint128 maxRatio;
874         uint128 optimalRatioBoost;
875         uint128 optimalRatioRepay;
876         address owner;
877         uint cdpId;
878         bool boostEnabled;
879         bool nextPriceEnabled;
880     }
881 
882     struct SubPosition {
883         uint arrPos;
884         bool subscribed;
885     }
886 }
887 
888 
889 
890 abstract contract ISubscriptionsV2 is StaticV2 {
891 
892     function getOwner(uint _cdpId) external view virtual returns(address);
893     function getSubscribedInfo(uint _cdpId) public view virtual returns(bool, uint128, uint128, uint128, uint128, address, uint coll, uint debt);
894     function getCdpHolder(uint _cdpId) public view virtual returns (bool subscribed, CdpHolder memory);
895 } abstract contract DSProxyInterface {
896 
897     /// Truffle wont compile if this isn't commented
898     // function execute(bytes memory _code, bytes memory _data)
899     //     public virtual
900     //     payable
901     //     returns (address, bytes32);
902 
903     function execute(address _target, bytes memory _data) public virtual payable returns (bytes32);
904 
905     function setCache(address _cacheAddr) public virtual payable returns (bool);
906 
907     function owner() public virtual returns (address);
908 } /// @title Implements logic for calling MCDSaverProxy always from same contract
909 contract MCDMonitorProxyV2 is AdminAuth {
910 
911     uint public CHANGE_PERIOD;
912     uint public MIN_CHANGE_PERIOD = 6 * 1 hours;
913     address public monitor;
914     address public newMonitor;
915     address public lastMonitor;
916     uint public changeRequestedTimestamp;
917 
918     event MonitorChangeInitiated(address oldMonitor, address newMonitor);
919     event MonitorChangeCanceled();
920     event MonitorChangeFinished(address monitor);
921     event MonitorChangeReverted(address monitor);
922 
923     modifier onlyMonitor() {
924         require (msg.sender == monitor);
925         _;
926     }
927 
928     constructor(uint _changePeriod) public {
929         CHANGE_PERIOD = _changePeriod * 1 hours;
930     }
931 
932     /// @notice Only monitor contract is able to call execute on users proxy
933     /// @param _owner Address of cdp owner (users DSProxy address)
934     /// @param _saverProxy Address of MCDSaverProxy
935     /// @param _data Data to send to MCDSaverProxy
936     function callExecute(address _owner, address _saverProxy, bytes memory _data) public payable onlyMonitor {
937         // execute reverts if calling specific method fails
938         DSProxyInterface(_owner).execute{value: msg.value}(_saverProxy, _data);
939 
940         // return if anything left
941         if (address(this).balance > 0) {
942             msg.sender.transfer(address(this).balance);
943         }
944     }
945 
946     /// @notice Allowed users are able to set Monitor contract without any waiting period first time
947     /// @param _monitor Address of Monitor contract
948     function setMonitor(address _monitor) public onlyOwner {
949         require(monitor == address(0));
950         monitor = _monitor;
951     }
952 
953     /// @notice Allowed users are able to start procedure for changing monitor
954     /// @dev after CHANGE_PERIOD needs to call confirmNewMonitor to actually make a change
955     /// @param _newMonitor address of new monitor
956     function changeMonitor(address _newMonitor) public onlyOwner {
957         require(changeRequestedTimestamp == 0);
958 
959         changeRequestedTimestamp = now;
960         lastMonitor = monitor;
961         newMonitor = _newMonitor;
962 
963         emit MonitorChangeInitiated(lastMonitor, newMonitor);
964     }
965 
966     /// @notice At any point allowed users are able to cancel monitor change
967     function cancelMonitorChange() public onlyOwner {
968         require(changeRequestedTimestamp > 0);
969 
970         changeRequestedTimestamp = 0;
971         newMonitor = address(0);
972 
973         emit MonitorChangeCanceled();
974     }
975 
976     /// @notice Anyone is able to confirm new monitor after CHANGE_PERIOD if process is started
977     function confirmNewMonitor() public onlyOwner {
978         require((changeRequestedTimestamp + CHANGE_PERIOD) < now);
979         require(changeRequestedTimestamp != 0);
980         require(newMonitor != address(0));
981 
982         monitor = newMonitor;
983         newMonitor = address(0);
984         changeRequestedTimestamp = 0;
985 
986         emit MonitorChangeFinished(monitor);
987     }
988 
989     /// @notice Its possible to revert monitor to last used monitor
990     function revertMonitor() public onlyOwner {
991         require(lastMonitor != address(0));
992 
993         monitor = lastMonitor;
994 
995         emit MonitorChangeReverted(monitor);
996     }
997 
998     function setChangePeriod(uint _periodInHours) public onlyOwner {
999         require(_periodInHours * 1 hours > MIN_CHANGE_PERIOD);
1000 
1001         CHANGE_PERIOD = _periodInHours * 1 hours;
1002     }
1003 
1004 }
1005 
1006 
1007 
1008 
1009 
1010 
1011 
1012 
1013 
1014 
1015 
1016 
1017 
1018 
1019 
1020 
1021 
1022 /// @title Implements logic that allows bots to call Boost and Repay
1023 contract MCDMonitorV2 is DSMath, AdminAuth, GasBurner, StaticV2 {
1024 
1025     uint public REPAY_GAS_TOKEN = 25;
1026     uint public BOOST_GAS_TOKEN = 25;
1027 
1028     uint public MAX_GAS_PRICE = 500000000000; // 500 gwei
1029 
1030     uint public REPAY_GAS_COST = 1500000;
1031     uint public BOOST_GAS_COST = 1500000;
1032 
1033     MCDMonitorProxyV2 public monitorProxyContract;
1034     ISubscriptionsV2 public subscriptionsContract;
1035     address public mcdSaverTakerAddress;
1036 
1037     address public constant BOT_REGISTRY_ADDRESS = 0x637726f8b08a7ABE3aE3aCaB01A80E2d8ddeF77B;
1038 
1039     address public constant PROXY_PERMISSION_ADDR = 0x5a4f877CA808Cca3cB7c2A194F80Ab8588FAE26B;
1040     address public constant NEW_MONITOR_PROXY_ADDR = 0x1816A86C4DA59395522a42b871bf11A4E96A1C7a;
1041 
1042     Manager public manager = Manager(0x5ef30b9986345249bc32d8928B7ee64DE9435E39);
1043     Vat public vat = Vat(0x35D1b3F3D7966A1DFe207aa4514C12a259A0492B);
1044     Spotter public spotter = Spotter(0x65C79fcB50Ca1594B025960e539eD7A9a6D434A3);
1045 
1046     DefisaverLogger public constant logger = DefisaverLogger(0x5c55B921f590a89C1Ebe84dF170E655a82b62126);
1047 
1048     modifier onlyApproved() {
1049         require(BotRegistry(BOT_REGISTRY_ADDRESS).botList(msg.sender), "Not auth bot");
1050         _;
1051     }
1052 
1053     constructor(address _monitorProxy, address _subscriptions, address _mcdSaverTakerAddress) public {
1054         monitorProxyContract = MCDMonitorProxyV2(_monitorProxy);
1055         subscriptionsContract = ISubscriptionsV2(_subscriptions);
1056         mcdSaverTakerAddress = _mcdSaverTakerAddress;
1057     }
1058 
1059     /// @notice Bots call this method to repay for user when conditions are met
1060     /// @dev If the contract ownes gas token it will try and use it for gas price reduction
1061     function repayFor(
1062         SaverExchangeCore.ExchangeData memory _exchangeData,
1063         uint _cdpId,
1064         uint _nextPrice,
1065         address _joinAddr
1066     ) public payable onlyApproved burnGas(REPAY_GAS_TOKEN) {
1067 
1068         (bool isAllowed, uint ratioBefore) = canCall(Method.Repay, _cdpId, _nextPrice);
1069         require(isAllowed);
1070 
1071         uint gasCost = calcGasCost(REPAY_GAS_COST);
1072 
1073         address owner = subscriptionsContract.getOwner(_cdpId);
1074 
1075         monitorProxyContract.callExecute{value: msg.value}(
1076             owner,
1077             mcdSaverTakerAddress,
1078             abi.encodeWithSignature(
1079             "repayWithLoan((address,address,uint256,uint256,uint256,address,address,bytes,uint256),uint256,uint256,address)",
1080             _exchangeData, _cdpId, gasCost, _joinAddr));
1081 
1082 
1083         (bool isGoodRatio, uint ratioAfter) = ratioGoodAfter(Method.Repay, _cdpId, _nextPrice);
1084         require(isGoodRatio);
1085 
1086         returnEth();
1087 
1088         logger.Log(address(this), owner, "AutomaticMCDRepay", abi.encode(ratioBefore, ratioAfter));
1089     }
1090 
1091     /// @notice Bots call this method to boost for user when conditions are met
1092     /// @dev If the contract ownes gas token it will try and use it for gas price reduction
1093     function boostFor(
1094         SaverExchangeCore.ExchangeData memory _exchangeData,
1095         uint _cdpId,
1096         uint _nextPrice,
1097         address _joinAddr
1098     ) public payable onlyApproved burnGas(BOOST_GAS_TOKEN)  {
1099 
1100         (bool isAllowed, uint ratioBefore) = canCall(Method.Boost, _cdpId, _nextPrice);
1101         require(isAllowed);
1102 
1103         uint gasCost = calcGasCost(BOOST_GAS_COST);
1104 
1105         address owner = subscriptionsContract.getOwner(_cdpId);
1106 
1107         monitorProxyContract.callExecute{value: msg.value}(
1108             owner,
1109             mcdSaverTakerAddress,
1110             abi.encodeWithSignature(
1111             "boostWithLoan((address,address,uint256,uint256,uint256,address,address,bytes,uint256),uint256,uint256,address)",
1112             _exchangeData, _cdpId, gasCost, _joinAddr));
1113 
1114         (bool isGoodRatio, uint ratioAfter) = ratioGoodAfter(Method.Boost, _cdpId, _nextPrice);
1115         require(isGoodRatio);
1116 
1117         returnEth();
1118 
1119         logger.Log(address(this), owner, "AutomaticMCDBoost", abi.encode(ratioBefore, ratioAfter));
1120     }
1121 
1122 
1123 /******************* INTERNAL METHODS ********************************/
1124     function returnEth() internal {
1125         // return if some eth left
1126         if (address(this).balance > 0) {
1127             msg.sender.transfer(address(this).balance);
1128         }
1129     }
1130 
1131 /******************* STATIC METHODS ********************************/
1132 
1133     /// @notice Returns an address that owns the CDP
1134     /// @param _cdpId Id of the CDP
1135     function getOwner(uint _cdpId) public view returns(address) {
1136         return manager.owns(_cdpId);
1137     }
1138 
1139     /// @notice Gets CDP info (collateral, debt)
1140     /// @param _cdpId Id of the CDP
1141     /// @param _ilk Ilk of the CDP
1142     function getCdpInfo(uint _cdpId, bytes32 _ilk) public view returns (uint, uint) {
1143         address urn = manager.urns(_cdpId);
1144 
1145         (uint collateral, uint debt) = vat.urns(_ilk, urn);
1146         (,uint rate,,,) = vat.ilks(_ilk);
1147 
1148         return (collateral, rmul(debt, rate));
1149     }
1150 
1151     /// @notice Gets a price of the asset
1152     /// @param _ilk Ilk of the CDP
1153     function getPrice(bytes32 _ilk) public view returns (uint) {
1154         (, uint mat) = spotter.ilks(_ilk);
1155         (,,uint spot,,) = vat.ilks(_ilk);
1156 
1157         return rmul(rmul(spot, spotter.par()), mat);
1158     }
1159 
1160     /// @notice Gets CDP ratio
1161     /// @param _cdpId Id of the CDP
1162     /// @param _nextPrice Next price for user
1163     function getRatio(uint _cdpId, uint _nextPrice) public view returns (uint) {
1164         bytes32 ilk = manager.ilks(_cdpId);
1165         uint price = (_nextPrice == 0) ? getPrice(ilk) : _nextPrice;
1166 
1167         (uint collateral, uint debt) = getCdpInfo(_cdpId, ilk);
1168 
1169         if (debt == 0) return 0;
1170 
1171         return rdiv(wmul(collateral, price), debt) / (10 ** 18);
1172     }
1173 
1174     /// @notice Checks if Boost/Repay could be triggered for the CDP
1175     /// @dev Called by MCDMonitor to enforce the min/max check
1176     function canCall(Method _method, uint _cdpId, uint _nextPrice) public view returns(bool, uint) {
1177         bool subscribed;
1178         CdpHolder memory holder;
1179         (subscribed, holder) = subscriptionsContract.getCdpHolder(_cdpId);
1180 
1181         // check if cdp is subscribed
1182         if (!subscribed) return (false, 0);
1183 
1184         // check if using next price is allowed
1185         if (_nextPrice > 0 && !holder.nextPriceEnabled) return (false, 0);
1186 
1187         // check if boost and boost allowed
1188         if (_method == Method.Boost && !holder.boostEnabled) return (false, 0);
1189 
1190         // check if owner is still owner
1191         if (getOwner(_cdpId) != holder.owner) return (false, 0);
1192 
1193         uint currRatio = getRatio(_cdpId, _nextPrice);
1194 
1195         if (_method == Method.Repay) {
1196             return (currRatio < holder.minRatio, currRatio);
1197         } else if (_method == Method.Boost) {
1198             return (currRatio > holder.maxRatio, currRatio);
1199         }
1200     }
1201 
1202     /// @dev After the Boost/Repay check if the ratio doesn't trigger another call
1203     function ratioGoodAfter(Method _method, uint _cdpId, uint _nextPrice) public view returns(bool, uint) {
1204         CdpHolder memory holder;
1205 
1206         (, holder) = subscriptionsContract.getCdpHolder(_cdpId);
1207 
1208         uint currRatio = getRatio(_cdpId, _nextPrice);
1209 
1210         if (_method == Method.Repay) {
1211             return (currRatio < holder.maxRatio, currRatio);
1212         } else if (_method == Method.Boost) {
1213             return (currRatio > holder.minRatio, currRatio);
1214         }
1215     }
1216 
1217     /// @notice Calculates gas cost (in Eth) of tx
1218     /// @dev Gas price is limited to MAX_GAS_PRICE to prevent attack of draining user CDP
1219     /// @param _gasAmount Amount of gas used for the tx
1220     function calcGasCost(uint _gasAmount) public view returns (uint) {
1221         uint gasPrice = tx.gasprice <= MAX_GAS_PRICE ? tx.gasprice : MAX_GAS_PRICE;
1222 
1223         return mul(gasPrice, _gasAmount);
1224     }
1225 
1226 /******************* OWNER ONLY OPERATIONS ********************************/
1227 
1228     /// @notice Allows owner to change gas cost for boost operation, but only up to 3 millions
1229     /// @param _gasCost New gas cost for boost method
1230     function changeBoostGasCost(uint _gasCost) public onlyOwner {
1231         require(_gasCost < 3000000);
1232 
1233         BOOST_GAS_COST = _gasCost;
1234     }
1235 
1236     /// @notice Allows owner to change gas cost for repay operation, but only up to 3 millions
1237     /// @param _gasCost New gas cost for repay method
1238     function changeRepayGasCost(uint _gasCost) public onlyOwner {
1239         require(_gasCost < 3000000);
1240 
1241         REPAY_GAS_COST = _gasCost;
1242     }
1243 
1244     /// @notice Allows owner to change max gas price
1245     /// @param _maxGasPrice New max gas price
1246     function changeMaxGasPrice(uint _maxGasPrice) public onlyOwner {
1247         require(_maxGasPrice < 500000000000);
1248 
1249         MAX_GAS_PRICE = _maxGasPrice;
1250     }
1251 
1252     /// @notice Allows owner to change the amount of gas token burned per function call
1253     /// @param _gasAmount Amount of gas token
1254     /// @param _isRepay Flag to know for which function we are setting the gas token amount
1255     function changeGasTokenAmount(uint _gasAmount, bool _isRepay) public onlyOwner {
1256         if (_isRepay) {
1257             REPAY_GAS_TOKEN = _gasAmount;
1258         } else {
1259             BOOST_GAS_TOKEN = _gasAmount;
1260         }
1261     }
1262 }