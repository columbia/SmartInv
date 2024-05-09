1 pragma solidity ^0.6.0;
2 pragma experimental ABIEncoderV2;
3 
4 
5  abstract contract Manager {
6     function last(address) virtual public returns (uint);
7     function cdpCan(address, uint, address) virtual public view returns (uint);
8     function ilks(uint) virtual public view returns (bytes32);
9     function owns(uint) virtual public view returns (address);
10     function urns(uint) virtual public view returns (address);
11     function vat() virtual public view returns (address);
12     function open(bytes32, address) virtual public returns (uint);
13     function give(uint, address) virtual public;
14     function cdpAllow(uint, address, uint) virtual public;
15     function urnAllow(address, uint) virtual public;
16     function frob(uint, int, int) virtual public;
17     function flux(uint, address, uint) virtual public;
18     function move(uint, address, uint) virtual public;
19     function exit(address, uint, address, uint) virtual public;
20     function quit(uint, address) virtual public;
21     function enter(address, uint) virtual public;
22     function shift(uint, uint) virtual public;
23 } abstract contract Vat {
24 
25     struct Urn {
26         uint256 ink;   // Locked Collateral  [wad]
27         uint256 art;   // Normalised Debt    [wad]
28     }
29 
30     struct Ilk {
31         uint256 Art;   // Total Normalised Debt     [wad]
32         uint256 rate;  // Accumulated Rates         [ray]
33         uint256 spot;  // Price with Safety Margin  [ray]
34         uint256 line;  // Debt Ceiling              [rad]
35         uint256 dust;  // Urn Debt Floor            [rad]
36     }
37 
38     mapping (bytes32 => mapping (address => Urn )) public urns;
39     mapping (bytes32 => Ilk)                       public ilks;
40     mapping (bytes32 => mapping (address => uint)) public gem;  // [wad]
41 
42     function can(address, address) virtual public view returns (uint);
43     function dai(address) virtual public view returns (uint);
44     function frob(bytes32, address, address, address, int, int) virtual public;
45     function hope(address) virtual public;
46     function move(address, address, uint) virtual public;
47     function fork(bytes32, address, address, int, int) virtual public;
48 } abstract contract PipInterface {
49     function read() public virtual returns (bytes32);
50 } abstract contract Spotter {
51     struct Ilk {
52         PipInterface pip;
53         uint256 mat;
54     }
55 
56     mapping (bytes32 => Ilk) public ilks;
57 
58     uint256 public par;
59 
60 } contract DSMath {
61     function add(uint256 x, uint256 y) internal pure returns (uint256 z) {
62         require((z = x + y) >= x);
63     }
64 
65     function sub(uint256 x, uint256 y) internal pure returns (uint256 z) {
66         require((z = x - y) <= x);
67     }
68 
69     function mul(uint256 x, uint256 y) internal pure returns (uint256 z) {
70         require(y == 0 || (z = x * y) / y == x);
71     }
72 
73     function div(uint256 x, uint256 y) internal pure returns (uint256 z) {
74         return x / y;
75     }
76 
77     function min(uint256 x, uint256 y) internal pure returns (uint256 z) {
78         return x <= y ? x : y;
79     }
80 
81     function max(uint256 x, uint256 y) internal pure returns (uint256 z) {
82         return x >= y ? x : y;
83     }
84 
85     function imin(int256 x, int256 y) internal pure returns (int256 z) {
86         return x <= y ? x : y;
87     }
88 
89     function imax(int256 x, int256 y) internal pure returns (int256 z) {
90         return x >= y ? x : y;
91     }
92 
93     uint256 constant WAD = 10**18;
94     uint256 constant RAY = 10**27;
95 
96     function wmul(uint256 x, uint256 y) internal pure returns (uint256 z) {
97         z = add(mul(x, y), WAD / 2) / WAD;
98     }
99 
100     function rmul(uint256 x, uint256 y) internal pure returns (uint256 z) {
101         z = add(mul(x, y), RAY / 2) / RAY;
102     }
103 
104     function wdiv(uint256 x, uint256 y) internal pure returns (uint256 z) {
105         z = add(mul(x, WAD), y / 2) / y;
106     }
107 
108     function rdiv(uint256 x, uint256 y) internal pure returns (uint256 z) {
109         z = add(mul(x, RAY), y / 2) / y;
110     }
111 
112     // This famous algorithm is called "exponentiation by squaring"
113     // and calculates x^n with x as fixed-point and n as regular unsigned.
114     //
115     // It's O(log n), instead of O(n) for naive repeated multiplication.
116     //
117     // These facts are why it works:
118     //
119     //  If n is even, then x^n = (x^2)^(n/2).
120     //  If n is odd,  then x^n = x * x^(n-1),
121     //   and applying the equation for even x gives
122     //    x^n = x * (x^2)^((n-1) / 2).
123     //
124     //  Also, EVM division is flooring and
125     //    floor[(n-1) / 2] = floor[n / 2].
126     //
127     function rpow(uint256 x, uint256 n) internal pure returns (uint256 z) {
128         z = n % 2 != 0 ? x : RAY;
129 
130         for (n /= 2; n != 0; n /= 2) {
131             x = rmul(x, x);
132 
133             if (n % 2 != 0) {
134                 z = rmul(z, x);
135             }
136         }
137     }
138 } interface ERC20 {
139     function totalSupply() external view returns (uint256 supply);
140 
141     function balanceOf(address _owner) external view returns (uint256 balance);
142 
143     function transfer(address _to, uint256 _value) external returns (bool success);
144 
145     function transferFrom(address _from, address _to, uint256 _value)
146         external
147         returns (bool success);
148 
149     function approve(address _spender, uint256 _value) external returns (bool success);
150 
151     function allowance(address _owner, address _spender) external view returns (uint256 remaining);
152 
153     function decimals() external view returns (uint256 digits);
154 
155     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
156 } library Address {
157     function isContract(address account) internal view returns (bool) {
158         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
159         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
160         // for accounts without code, i.e. `keccak256('')`
161         bytes32 codehash;
162         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
163         // solhint-disable-next-line no-inline-assembly
164         assembly { codehash := extcodehash(account) }
165         return (codehash != accountHash && codehash != 0x0);
166     }
167 
168     function sendValue(address payable recipient, uint256 amount) internal {
169         require(address(this).balance >= amount, "Address: insufficient balance");
170 
171         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
172         (bool success, ) = recipient.call{ value: amount }("");
173         require(success, "Address: unable to send value, recipient may have reverted");
174     }
175 
176     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
177       return functionCall(target, data, "Address: low-level call failed");
178     }
179 
180     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
181         return _functionCallWithValue(target, data, 0, errorMessage);
182     }
183 
184     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
185         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
186     }
187 
188     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
189         require(address(this).balance >= value, "Address: insufficient balance for call");
190         return _functionCallWithValue(target, data, value, errorMessage);
191     }
192 
193     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
194         require(isContract(target), "Address: call to non-contract");
195 
196         // solhint-disable-next-line avoid-low-level-calls
197         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
198         if (success) {
199             return returndata;
200         } else {
201             // Look for revert reason and bubble it up if present
202             if (returndata.length > 0) {
203                 // The easiest way to bubble the revert reason is using memory via assembly
204 
205                 // solhint-disable-next-line no-inline-assembly
206                 assembly {
207                     let returndata_size := mload(returndata)
208                     revert(add(32, returndata), returndata_size)
209                 }
210             } else {
211                 revert(errorMessage);
212             }
213         }
214     }
215 } library SafeMath {
216     function add(uint256 a, uint256 b) internal pure returns (uint256) {
217         uint256 c = a + b;
218         require(c >= a, "SafeMath: addition overflow");
219 
220         return c;
221     }
222 
223     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
224         return sub(a, b, "SafeMath: subtraction overflow");
225     }
226 
227     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
228         require(b <= a, errorMessage);
229         uint256 c = a - b;
230 
231         return c;
232     }
233 
234     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
235         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
236         // benefit is lost if 'b' is also tested.
237         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
238         if (a == 0) {
239             return 0;
240         }
241 
242         uint256 c = a * b;
243         require(c / a == b, "SafeMath: multiplication overflow");
244 
245         return c;
246     }
247 
248     function div(uint256 a, uint256 b) internal pure returns (uint256) {
249         return div(a, b, "SafeMath: division by zero");
250     }
251 
252     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
253         require(b > 0, errorMessage);
254         uint256 c = a / b;
255         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
256 
257         return c;
258     }
259 
260     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
261         return mod(a, b, "SafeMath: modulo by zero");
262     }
263 
264     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
265         require(b != 0, errorMessage);
266         return a % b;
267     }
268 } library SafeERC20 {
269     using SafeMath for uint256;
270     using Address for address;
271 
272     function safeTransfer(ERC20 token, address to, uint256 value) internal {
273         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
274     }
275 
276     function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
277         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
278     }
279 
280     /**
281      * @dev Deprecated. This function has issues similar to the ones found in
282      * {IERC20-approve}, and its usage is discouraged.
283      */
284     function safeApprove(ERC20 token, address spender, uint256 value) internal {
285         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, 0));
286         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
287     }
288 
289     function safeIncreaseAllowance(ERC20 token, address spender, uint256 value) internal {
290         uint256 newAllowance = token.allowance(address(this), spender).add(value);
291         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
292     }
293 
294     function safeDecreaseAllowance(ERC20 token, address spender, uint256 value) internal {
295         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
296         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
297     }
298 
299     function _callOptionalReturn(ERC20 token, bytes memory data) private {
300 
301         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
302         if (returndata.length > 0) { // Return data is optional
303             // solhint-disable-next-line max-line-length
304             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
305         }
306     }
307 } contract AdminAuth {
308 
309     using SafeERC20 for ERC20;
310 
311     address public owner;
312     address public admin;
313 
314     modifier onlyOwner() {
315         require(owner == msg.sender);
316         _;
317     }
318 
319     modifier onlyAdmin() {
320         require(admin == msg.sender);
321         _;
322     }
323 
324     constructor() public {
325         owner = msg.sender;
326         admin = 0x25eFA336886C74eA8E282ac466BdCd0199f85BB9;
327     }
328 
329     /// @notice Admin is set by owner first time, after that admin is super role and has permission to change owner
330     /// @param _admin Address of multisig that becomes admin
331     function setAdminByOwner(address _admin) public {
332         require(msg.sender == owner);
333         require(admin == address(0));
334 
335         admin = _admin;
336     }
337 
338     /// @notice Admin is able to set new admin
339     /// @param _admin Address of multisig that becomes new admin
340     function setAdminByAdmin(address _admin) public {
341         require(msg.sender == admin);
342 
343         admin = _admin;
344     }
345 
346     /// @notice Admin is able to change owner
347     /// @param _owner Address of new owner
348     function setOwnerByAdmin(address _owner) public {
349         require(msg.sender == admin);
350 
351         owner = _owner;
352     }
353 
354     /// @notice Destroy the contract
355     function kill() public onlyOwner {
356         selfdestruct(payable(owner));
357     }
358 
359     /// @notice  withdraw stuck funds
360     function withdrawStuckFunds(address _token, uint _amount) public onlyOwner {
361         if (_token == 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE) {
362             payable(owner).transfer(_amount);
363         } else {
364             ERC20(_token).safeTransfer(owner, _amount);
365         }
366     }
367 } contract DefisaverLogger {
368     event LogEvent(
369         address indexed contractAddress,
370         address indexed caller,
371         string indexed logName,
372         bytes data
373     );
374 
375     // solhint-disable-next-line func-name-mixedcase
376     function Log(address _contract, address _caller, string memory _logName, bytes memory _data)
377         public
378     {
379         emit LogEvent(_contract, _caller, _logName, _data);
380     }
381 } abstract contract GasTokenInterface is ERC20 {
382     function free(uint256 value) public virtual returns (bool success);
383 
384     function freeUpTo(uint256 value) public virtual returns (uint256 freed);
385 
386     function freeFrom(address from, uint256 value) public virtual returns (bool success);
387 
388     function freeFromUpTo(address from, uint256 value) public virtual returns (uint256 freed);
389 } contract GasBurner {
390     // solhint-disable-next-line const-name-snakecase
391     GasTokenInterface public constant gasToken = GasTokenInterface(0x0000000000b3F879cb30FE243b4Dfee438691c04);
392 
393     modifier burnGas(uint _amount) {
394         if (gasToken.balanceOf(address(this)) >= _amount) {
395             gasToken.free(_amount);
396         }
397 
398         _;
399     }
400 } contract BotRegistry is AdminAuth {
401 
402     mapping (address => bool) public botList;
403 
404     constructor() public {
405         botList[0x776B4a13093e30B05781F97F6A4565B6aa8BE330] = true;
406 
407         botList[0xAED662abcC4FA3314985E67Ea993CAD064a7F5cF] = true;
408         botList[0xa5d330F6619d6bF892A5B87D80272e1607b3e34D] = true;
409         botList[0x5feB4DeE5150B589a7f567EA7CADa2759794A90A] = true;
410         botList[0x7ca06417c1d6f480d3bB195B80692F95A6B66158] = true;
411     }
412 
413     function setBot(address _botAddr, bool _state) public onlyOwner {
414         botList[_botAddr] = _state;
415     }
416 
417 } abstract contract TokenInterface {
418     function allowance(address, address) public virtual returns (uint256);
419 
420     function balanceOf(address) public virtual returns (uint256);
421 
422     function approve(address, uint256) public virtual;
423 
424     function transfer(address, uint256) public virtual returns (bool);
425 
426     function transferFrom(address, address, uint256) public virtual returns (bool);
427 
428     function deposit() public virtual payable;
429 
430     function withdraw(uint256) public virtual;
431 } interface ExchangeInterfaceV2 {
432     function sell(address _srcAddr, address _destAddr, uint _srcAmount) external payable returns (uint);
433 
434     function buy(address _srcAddr, address _destAddr, uint _destAmount) external payable returns(uint);
435 
436     function getSellRate(address _srcAddr, address _destAddr, uint _srcAmount) external view returns (uint);
437 
438     function getBuyRate(address _srcAddr, address _destAddr, uint _srcAmount) external view returns (uint);
439 } contract ZrxAllowlist is AdminAuth {
440 
441     mapping (address => bool) public zrxAllowlist;
442     mapping(address => bool) private nonPayableAddrs;
443 
444     constructor() public {
445         zrxAllowlist[0x6958F5e95332D93D21af0D7B9Ca85B8212fEE0A5] = true;
446         zrxAllowlist[0x61935CbDd02287B511119DDb11Aeb42F1593b7Ef] = true;
447         zrxAllowlist[0xDef1C0ded9bec7F1a1670819833240f027b25EfF] = true;
448         zrxAllowlist[0x080bf510FCbF18b91105470639e9561022937712] = true;
449 
450         nonPayableAddrs[0x080bf510FCbF18b91105470639e9561022937712] = true;
451     }
452 
453     function setAllowlistAddr(address _zrxAddr, bool _state) public onlyOwner {
454         zrxAllowlist[_zrxAddr] = _state;
455     }
456 
457     function isZrxAddr(address _zrxAddr) public view returns (bool) {
458         return zrxAllowlist[_zrxAddr];
459     }
460 
461     function addNonPayableAddr(address _nonPayableAddr) public onlyOwner {
462 		nonPayableAddrs[_nonPayableAddr] = true;
463 	}
464 
465 	function removeNonPayableAddr(address _nonPayableAddr) public onlyOwner {
466 		nonPayableAddrs[_nonPayableAddr] = false;
467 	}
468 
469 	function isNonPayableAddr(address _addr) public view returns(bool) {
470 		return nonPayableAddrs[_addr];
471 	}
472 } contract Discount {
473     address public owner;
474     mapping(address => CustomServiceFee) public serviceFees;
475 
476     uint256 constant MAX_SERVICE_FEE = 400;
477 
478     struct CustomServiceFee {
479         bool active;
480         uint256 amount;
481     }
482 
483     constructor() public {
484         owner = msg.sender;
485     }
486 
487     function isCustomFeeSet(address _user) public view returns (bool) {
488         return serviceFees[_user].active;
489     }
490 
491     function getCustomServiceFee(address _user) public view returns (uint256) {
492         return serviceFees[_user].amount;
493     }
494 
495     function setServiceFee(address _user, uint256 _fee) public {
496         require(msg.sender == owner, "Only owner");
497         require(_fee >= MAX_SERVICE_FEE || _fee == 0);
498 
499         serviceFees[_user] = CustomServiceFee({active: true, amount: _fee});
500     }
501 
502     function disableServiceFee(address _user) public {
503         require(msg.sender == owner, "Only owner");
504 
505         serviceFees[_user] = CustomServiceFee({active: false, amount: 0});
506     }
507 } contract SaverExchangeHelper {
508 
509     using SafeERC20 for ERC20;
510 
511     address public constant KYBER_ETH_ADDRESS = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
512     address public constant WETH_ADDRESS = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
513 
514     address payable public constant WALLET_ID = 0x322d58b9E75a6918f7e7849AEe0fF09369977e08;
515     address public constant DISCOUNT_ADDRESS = 0x1b14E8D511c9A4395425314f849bD737BAF8208F;
516     address public constant SAVER_EXCHANGE_REGISTRY = 0x25dd3F51e0C3c3Ff164DDC02A8E4D65Bb9cBB12D;
517 
518     address public constant ERC20_PROXY_0X = 0x95E6F48254609A6ee006F7D493c8e5fB97094ceF;
519     address public constant ZRX_ALLOWLIST_ADDR = 0x4BA1f38427b33B8ab7Bb0490200dAE1F1C36823F;
520 
521 
522     function getDecimals(address _token) internal view returns (uint256) {
523         if (_token == KYBER_ETH_ADDRESS) return 18;
524 
525         return ERC20(_token).decimals();
526     }
527 
528     function getBalance(address _tokenAddr) internal view returns (uint balance) {
529         if (_tokenAddr == KYBER_ETH_ADDRESS) {
530             balance = address(this).balance;
531         } else {
532             balance = ERC20(_tokenAddr).balanceOf(address(this));
533         }
534     }
535 
536     function approve0xProxy(address _tokenAddr, uint _amount) internal {
537         if (_tokenAddr != KYBER_ETH_ADDRESS) {
538             ERC20(_tokenAddr).safeApprove(address(ERC20_PROXY_0X), _amount);
539         }
540     }
541 
542     function sendLeftover(address _srcAddr, address _destAddr, address payable _to) internal {
543         // send back any leftover ether or tokens
544         if (address(this).balance > 0) {
545             _to.transfer(address(this).balance);
546         }
547 
548         if (getBalance(_srcAddr) > 0) {
549             ERC20(_srcAddr).safeTransfer(_to, getBalance(_srcAddr));
550         }
551 
552         if (getBalance(_destAddr) > 0) {
553             ERC20(_destAddr).safeTransfer(_to, getBalance(_destAddr));
554         }
555     }
556 
557     function sliceUint(bytes memory bs, uint256 start) internal pure returns (uint256) {
558         require(bs.length >= start + 32, "slicing out of range");
559 
560         uint256 x;
561         assembly {
562             x := mload(add(bs, add(0x20, start)))
563         }
564 
565         return x;
566     }
567 } contract SaverExchangeRegistry is AdminAuth {
568 
569 	mapping(address => bool) private wrappers;
570 
571 	constructor() public {
572 		wrappers[0x880A845A85F843a5c67DB2061623c6Fc3bB4c511] = true;
573 		wrappers[0x4c9B55f2083629A1F7aDa257ae984E03096eCD25] = true;
574 		wrappers[0x42A9237b872368E1bec4Ca8D26A928D7d39d338C] = true;
575 	}
576 
577 	function addWrapper(address _wrapper) public onlyOwner {
578 		wrappers[_wrapper] = true;
579 	}
580 
581 	function removeWrapper(address _wrapper) public onlyOwner {
582 		wrappers[_wrapper] = false;
583 	}
584 
585 	function isWrapper(address _wrapper) public view returns(bool) {
586 		return wrappers[_wrapper];
587 	}
588 }
589 
590 
591 
592 
593 
594 
595 
596 
597 contract SaverExchangeCore is SaverExchangeHelper, DSMath {
598 
599     // first is empty to keep the legacy order in place
600     enum ExchangeType { _, OASIS, KYBER, UNISWAP, ZEROX }
601 
602     enum ActionType { SELL, BUY }
603 
604     struct ExchangeData {
605         address srcAddr;
606         address destAddr;
607         uint srcAmount;
608         uint destAmount;
609         uint minPrice;
610         address wrapper;
611         address exchangeAddr;
612         bytes callData;
613         uint256 price0x;
614     }
615 
616     /// @notice Internal method that preforms a sell on 0x/on-chain
617     /// @dev Usefull for other DFS contract to integrate for exchanging
618     /// @param exData Exchange data struct
619     /// @return (address, uint) Address of the wrapper used and destAmount
620     function _sell(ExchangeData memory exData) internal returns (address, uint) {
621 
622         address wrapper;
623         uint swapedTokens;
624         bool success;
625         uint tokensLeft = exData.srcAmount;
626 
627         // if selling eth, convert to weth
628         if (exData.srcAddr == KYBER_ETH_ADDRESS) {
629             exData.srcAddr = ethToWethAddr(exData.srcAddr);
630             TokenInterface(WETH_ADDRESS).deposit.value(exData.srcAmount)();
631         }
632 
633         // Try 0x first and then fallback on specific wrapper
634         if (exData.price0x > 0) {
635             approve0xProxy(exData.srcAddr, exData.srcAmount);
636 
637             uint ethAmount = getProtocolFee(exData.srcAddr, exData.srcAmount);
638             (success, swapedTokens, tokensLeft) = takeOrder(exData, ethAmount, ActionType.SELL);
639 
640             if (success) {
641                 wrapper = exData.exchangeAddr;
642             }
643         }
644 
645         // fallback to desired wrapper if 0x failed
646         if (!success) {
647             swapedTokens = saverSwap(exData, ActionType.SELL);
648             wrapper = exData.wrapper;
649         }
650 
651         require(getBalance(exData.destAddr) >= wmul(exData.minPrice, exData.srcAmount), "Final amount isn't correct");
652 
653         // if anything is left in weth, pull it to user as eth
654         if (getBalance(WETH_ADDRESS) > 0) {
655             TokenInterface(WETH_ADDRESS).withdraw(
656                 TokenInterface(WETH_ADDRESS).balanceOf(address(this))
657             );
658         }
659 
660         return (wrapper, swapedTokens);
661     }
662 
663     /// @notice Internal method that preforms a buy on 0x/on-chain
664     /// @dev Usefull for other DFS contract to integrate for exchanging
665     /// @param exData Exchange data struct
666     /// @return (address, uint) Address of the wrapper used and srcAmount
667     function _buy(ExchangeData memory exData) internal returns (address, uint) {
668 
669         address wrapper;
670         uint swapedTokens;
671         bool success;
672 
673         require(exData.destAmount != 0, "Dest amount must be specified");
674 
675         // if selling eth, convert to weth
676         if (exData.srcAddr == KYBER_ETH_ADDRESS) {
677             exData.srcAddr = ethToWethAddr(exData.srcAddr);
678             TokenInterface(WETH_ADDRESS).deposit.value(exData.srcAmount)();
679         }
680 
681         if (exData.price0x > 0) {
682             approve0xProxy(exData.srcAddr, exData.srcAmount);
683 
684             uint ethAmount = getProtocolFee(exData.srcAddr, exData.srcAmount);
685             (success, swapedTokens,) = takeOrder(exData, ethAmount, ActionType.BUY);
686 
687             if (success) {
688                 wrapper = exData.exchangeAddr;
689             }
690         }
691 
692         // fallback to desired wrapper if 0x failed
693         if (!success) {
694             swapedTokens = saverSwap(exData, ActionType.BUY);
695             wrapper = exData.wrapper;
696         }
697 
698         require(getBalance(exData.destAddr) >= exData.destAmount, "Final amount isn't correct");
699 
700         // if anything is left in weth, pull it to user as eth
701         if (getBalance(WETH_ADDRESS) > 0) {
702             TokenInterface(WETH_ADDRESS).withdraw(
703                 TokenInterface(WETH_ADDRESS).balanceOf(address(this))
704             );
705         }
706 
707         return (wrapper, getBalance(exData.destAddr));
708     }
709 
710     /// @notice Takes order from 0x and returns bool indicating if it is successful
711     /// @param _exData Exchange data
712     /// @param _ethAmount Ether fee needed for 0x order
713     function takeOrder(
714         ExchangeData memory _exData,
715         uint256 _ethAmount,
716         ActionType _type
717     ) private returns (bool success, uint256, uint256) {
718 
719         // write in the exact amount we are selling/buing in an order
720         if (_type == ActionType.SELL) {
721             writeUint256(_exData.callData, 36, _exData.srcAmount);
722         } else {
723             writeUint256(_exData.callData, 36, _exData.destAmount);
724         }
725 
726         if (ZrxAllowlist(ZRX_ALLOWLIST_ADDR).isNonPayableAddr(_exData.exchangeAddr)) {
727             _ethAmount = 0;
728         }
729 
730         uint256 tokensBefore = getBalance(_exData.destAddr);
731 
732         if (ZrxAllowlist(ZRX_ALLOWLIST_ADDR).isZrxAddr(_exData.exchangeAddr)) {
733             (success, ) = _exData.exchangeAddr.call{value: _ethAmount}(_exData.callData);
734         } else {
735             success = false;
736         }
737 
738         uint256 tokensSwaped = 0;
739         uint256 tokensLeft = _exData.srcAmount;
740 
741         if (success) {
742             // check to see if any _src tokens are left over after exchange
743             tokensLeft = getBalance(_exData.srcAddr);
744 
745             // convert weth -> eth if needed
746             if (_exData.destAddr == KYBER_ETH_ADDRESS) {
747                 TokenInterface(WETH_ADDRESS).withdraw(
748                     TokenInterface(WETH_ADDRESS).balanceOf(address(this))
749                 );
750             }
751 
752             // get the current balance of the swaped tokens
753             tokensSwaped = getBalance(_exData.destAddr) - tokensBefore;
754         }
755 
756         return (success, tokensSwaped, tokensLeft);
757     }
758 
759     /// @notice Calls wraper contract for exchage to preform an on-chain swap
760     /// @param _exData Exchange data struct
761     /// @param _type Type of action SELL|BUY
762     /// @return swapedTokens For Sell that the destAmount, for Buy thats the srcAmount
763     function saverSwap(ExchangeData memory _exData, ActionType _type) internal returns (uint swapedTokens) {
764         require(SaverExchangeRegistry(SAVER_EXCHANGE_REGISTRY).isWrapper(_exData.wrapper), "Wrapper is not valid");
765 
766         uint ethValue = 0;
767 
768         ERC20(_exData.srcAddr).safeTransfer(_exData.wrapper, _exData.srcAmount);
769 
770         if (_type == ActionType.SELL) {
771             swapedTokens = ExchangeInterfaceV2(_exData.wrapper).
772                     sell{value: ethValue}(_exData.srcAddr, _exData.destAddr, _exData.srcAmount);
773         } else {
774             swapedTokens = ExchangeInterfaceV2(_exData.wrapper).
775                     buy{value: ethValue}(_exData.srcAddr, _exData.destAddr, _exData.destAmount);
776         }
777     }
778 
779     function writeUint256(bytes memory _b, uint256 _index, uint _input) internal pure {
780         if (_b.length < _index + 32) {
781             revert("Incorrent lengt while writting bytes32");
782         }
783 
784         bytes32 input = bytes32(_input);
785 
786         _index += 32;
787 
788         // Read the bytes32 from array memory
789         assembly {
790             mstore(add(_b, _index), input)
791         }
792     }
793 
794     /// @notice Converts Kybers Eth address -> Weth
795     /// @param _src Input address
796     function ethToWethAddr(address _src) internal pure returns (address) {
797         return _src == KYBER_ETH_ADDRESS ? WETH_ADDRESS : _src;
798     }
799 
800     /// @notice Calculates protocol fee
801     /// @param _srcAddr selling token address (if eth should be WETH)
802     /// @param _srcAmount amount we are selling
803     function getProtocolFee(address _srcAddr, uint256 _srcAmount) internal view returns(uint256) {
804         // if we are not selling ETH msg value is always the protocol fee
805         if (_srcAddr != WETH_ADDRESS) return address(this).balance;
806 
807         // if msg value is larger than srcAmount, that means that msg value is protocol fee + srcAmount, so we subsctract srcAmount from msg value
808         // we have an edge case here when protocol fee is higher than selling amount
809         if (address(this).balance > _srcAmount) return address(this).balance - _srcAmount;
810 
811         // if msg value is lower than src amount, that means that srcAmount isn't included in msg value, so we return msg value
812         return address(this).balance;
813     }
814 
815     function packExchangeData(ExchangeData memory _exData) public pure returns(bytes memory) {
816         // splitting in two different bytes and encoding all because of stack too deep in decoding part
817 
818         bytes memory part1 = abi.encode(
819             _exData.srcAddr,
820             _exData.destAddr,
821             _exData.srcAmount,
822             _exData.destAmount
823         );
824 
825         bytes memory part2 = abi.encode(
826             _exData.minPrice,
827             _exData.wrapper,
828             _exData.exchangeAddr,
829             _exData.callData,
830             _exData.price0x
831         );
832 
833 
834         return abi.encode(part1, part2);
835     }
836 
837     function unpackExchangeData(bytes memory _data) public pure returns(ExchangeData memory _exData) {
838         (
839             bytes memory part1,
840             bytes memory part2
841         ) = abi.decode(_data, (bytes,bytes));
842 
843         (
844             _exData.srcAddr,
845             _exData.destAddr,
846             _exData.srcAmount,
847             _exData.destAmount
848         ) = abi.decode(part1, (address,address,uint256,uint256));
849 
850         (
851             _exData.minPrice,
852             _exData.wrapper,
853             _exData.exchangeAddr,
854             _exData.callData,
855             _exData.price0x
856         )
857         = abi.decode(part2, (uint256,address,address,bytes,uint256));
858     }
859 
860     // solhint-disable-next-line no-empty-blocks
861     receive() external virtual payable {}
862 } /// @title Implements enum Method
863 abstract contract StaticV2 {
864 
865     enum Method { Boost, Repay }
866 
867     struct CdpHolder {
868         uint128 minRatio;
869         uint128 maxRatio;
870         uint128 optimalRatioBoost;
871         uint128 optimalRatioRepay;
872         address owner;
873         uint cdpId;
874         bool boostEnabled;
875         bool nextPriceEnabled;
876     }
877 
878     struct SubPosition {
879         uint arrPos;
880         bool subscribed;
881     }
882 }
883 
884 
885 
886 abstract contract ISubscriptionsV2 is StaticV2 {
887 
888     function getOwner(uint _cdpId) external view virtual returns(address);
889     function getSubscribedInfo(uint _cdpId) public view virtual returns(bool, uint128, uint128, uint128, uint128, address, uint coll, uint debt);
890     function getCdpHolder(uint _cdpId) public view virtual returns (bool subscribed, CdpHolder memory);
891 } abstract contract DSProxyInterface {
892 
893     /// Truffle wont compile if this isn't commented
894     // function execute(bytes memory _code, bytes memory _data)
895     //     public virtual
896     //     payable
897     //     returns (address, bytes32);
898 
899     function execute(address _target, bytes memory _data) public virtual payable returns (bytes32);
900 
901     function setCache(address _cacheAddr) public virtual payable returns (bool);
902 
903     function owner() public virtual returns (address);
904 } /// @title Implements logic for calling MCDSaverProxy always from same contract
905 contract MCDMonitorProxyV2 is AdminAuth {
906 
907     uint public CHANGE_PERIOD;
908     uint public MIN_CHANGE_PERIOD = 6 * 1 hours;
909     address public monitor;
910     address public newMonitor;
911     address public lastMonitor;
912     uint public changeRequestedTimestamp;
913 
914     event MonitorChangeInitiated(address oldMonitor, address newMonitor);
915     event MonitorChangeCanceled();
916     event MonitorChangeFinished(address monitor);
917     event MonitorChangeReverted(address monitor);
918 
919     modifier onlyMonitor() {
920         require (msg.sender == monitor);
921         _;
922     }
923 
924     constructor(uint _changePeriod) public {
925         CHANGE_PERIOD = _changePeriod * 1 hours;
926     }
927 
928     /// @notice Only monitor contract is able to call execute on users proxy
929     /// @param _owner Address of cdp owner (users DSProxy address)
930     /// @param _saverProxy Address of MCDSaverProxy
931     /// @param _data Data to send to MCDSaverProxy
932     function callExecute(address _owner, address _saverProxy, bytes memory _data) public payable onlyMonitor {
933         // execute reverts if calling specific method fails
934         DSProxyInterface(_owner).execute{value: msg.value}(_saverProxy, _data);
935 
936         // return if anything left
937         if (address(this).balance > 0) {
938             msg.sender.transfer(address(this).balance);
939         }
940     }
941 
942     /// @notice Allowed users are able to set Monitor contract without any waiting period first time
943     /// @param _monitor Address of Monitor contract
944     function setMonitor(address _monitor) public onlyOwner {
945         require(monitor == address(0));
946         monitor = _monitor;
947     }
948 
949     /// @notice Allowed users are able to start procedure for changing monitor
950     /// @dev after CHANGE_PERIOD needs to call confirmNewMonitor to actually make a change
951     /// @param _newMonitor address of new monitor
952     function changeMonitor(address _newMonitor) public onlyOwner {
953         require(changeRequestedTimestamp == 0);
954 
955         changeRequestedTimestamp = now;
956         lastMonitor = monitor;
957         newMonitor = _newMonitor;
958 
959         emit MonitorChangeInitiated(lastMonitor, newMonitor);
960     }
961 
962     /// @notice At any point allowed users are able to cancel monitor change
963     function cancelMonitorChange() public onlyOwner {
964         require(changeRequestedTimestamp > 0);
965 
966         changeRequestedTimestamp = 0;
967         newMonitor = address(0);
968 
969         emit MonitorChangeCanceled();
970     }
971 
972     /// @notice Anyone is able to confirm new monitor after CHANGE_PERIOD if process is started
973     function confirmNewMonitor() public onlyOwner {
974         require((changeRequestedTimestamp + CHANGE_PERIOD) < now);
975         require(changeRequestedTimestamp != 0);
976         require(newMonitor != address(0));
977 
978         monitor = newMonitor;
979         newMonitor = address(0);
980         changeRequestedTimestamp = 0;
981 
982         emit MonitorChangeFinished(monitor);
983     }
984 
985     /// @notice Its possible to revert monitor to last used monitor
986     function revertMonitor() public onlyOwner {
987         require(lastMonitor != address(0));
988 
989         monitor = lastMonitor;
990 
991         emit MonitorChangeReverted(monitor);
992     }
993 
994     function setChangePeriod(uint _periodInHours) public onlyOwner {
995         require(_periodInHours * 1 hours > MIN_CHANGE_PERIOD);
996 
997         CHANGE_PERIOD = _periodInHours * 1 hours;
998     }
999 
1000 }
1001 
1002 
1003 
1004 
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
1018 /// @title Implements logic that allows bots to call Boost and Repay
1019 contract MCDMonitorV2 is DSMath, AdminAuth, GasBurner, StaticV2 {
1020 
1021     uint public REPAY_GAS_TOKEN = 25;
1022     uint public BOOST_GAS_TOKEN = 25;
1023 
1024     uint public MAX_GAS_PRICE = 500000000000; // 500 gwei
1025 
1026     uint public REPAY_GAS_COST = 1500000;
1027     uint public BOOST_GAS_COST = 1500000;
1028 
1029     MCDMonitorProxyV2 public monitorProxyContract;
1030     ISubscriptionsV2 public subscriptionsContract;
1031     address public mcdSaverTakerAddress;
1032 
1033     address public constant BOT_REGISTRY_ADDRESS = 0x637726f8b08a7ABE3aE3aCaB01A80E2d8ddeF77B;
1034 
1035     address public constant PROXY_PERMISSION_ADDR = 0x5a4f877CA808Cca3cB7c2A194F80Ab8588FAE26B;
1036     address public constant NEW_MONITOR_PROXY_ADDR = 0x1816A86C4DA59395522a42b871bf11A4E96A1C7a;
1037 
1038     Manager public manager = Manager(0x5ef30b9986345249bc32d8928B7ee64DE9435E39);
1039     Vat public vat = Vat(0x35D1b3F3D7966A1DFe207aa4514C12a259A0492B);
1040     Spotter public spotter = Spotter(0x65C79fcB50Ca1594B025960e539eD7A9a6D434A3);
1041 
1042     DefisaverLogger public constant logger = DefisaverLogger(0x5c55B921f590a89C1Ebe84dF170E655a82b62126);
1043 
1044     modifier onlyApproved() {
1045         require(BotRegistry(BOT_REGISTRY_ADDRESS).botList(msg.sender), "Not auth bot");
1046         _;
1047     }
1048 
1049     constructor(address _monitorProxy, address _subscriptions, address _mcdSaverTakerAddress) public {
1050         monitorProxyContract = MCDMonitorProxyV2(_monitorProxy);
1051         subscriptionsContract = ISubscriptionsV2(_subscriptions);
1052         mcdSaverTakerAddress = _mcdSaverTakerAddress;
1053     }
1054 
1055     /// @notice Bots call this method to repay for user when conditions are met
1056     /// @dev If the contract ownes gas token it will try and use it for gas price reduction
1057     function repayFor(
1058         SaverExchangeCore.ExchangeData memory _exchangeData,
1059         uint _cdpId,
1060         uint _nextPrice,
1061         address _joinAddr
1062     ) public payable onlyApproved burnGas(REPAY_GAS_TOKEN) {
1063 
1064         (bool isAllowed, uint ratioBefore) = canCall(Method.Repay, _cdpId, _nextPrice);
1065         require(isAllowed);
1066 
1067         uint gasCost = calcGasCost(REPAY_GAS_COST);
1068 
1069         address owner = subscriptionsContract.getOwner(_cdpId);
1070 
1071         monitorProxyContract.callExecute{value: msg.value}(
1072             owner,
1073             mcdSaverTakerAddress,
1074             abi.encodeWithSignature(
1075             "repayWithLoan((address,address,uint256,uint256,uint256,address,address,bytes,uint256),uint256,uint256,address)",
1076             _exchangeData, _cdpId, gasCost, _joinAddr));
1077 
1078 
1079         (bool isGoodRatio, uint ratioAfter) = ratioGoodAfter(Method.Repay, _cdpId, _nextPrice);
1080         require(isGoodRatio);
1081 
1082         returnEth();
1083 
1084         logger.Log(address(this), owner, "AutomaticMCDRepay", abi.encode(ratioBefore, ratioAfter));
1085     }
1086 
1087     /// @notice Bots call this method to boost for user when conditions are met
1088     /// @dev If the contract ownes gas token it will try and use it for gas price reduction
1089     function boostFor(
1090         SaverExchangeCore.ExchangeData memory _exchangeData,
1091         uint _cdpId,
1092         uint _nextPrice,
1093         address _joinAddr
1094     ) public payable onlyApproved burnGas(BOOST_GAS_TOKEN)  {
1095 
1096         (bool isAllowed, uint ratioBefore) = canCall(Method.Boost, _cdpId, _nextPrice);
1097         require(isAllowed);
1098 
1099         uint gasCost = calcGasCost(BOOST_GAS_COST);
1100 
1101         address owner = subscriptionsContract.getOwner(_cdpId);
1102 
1103         monitorProxyContract.callExecute{value: msg.value}(
1104             owner,
1105             mcdSaverTakerAddress,
1106             abi.encodeWithSignature(
1107             "boostWithLoan((address,address,uint256,uint256,uint256,address,address,bytes,uint256),uint256,uint256,address)",
1108             _exchangeData, _cdpId, gasCost, _joinAddr));
1109 
1110         (bool isGoodRatio, uint ratioAfter) = ratioGoodAfter(Method.Boost, _cdpId, _nextPrice);
1111         require(isGoodRatio);
1112 
1113         returnEth();
1114 
1115         logger.Log(address(this), owner, "AutomaticMCDBoost", abi.encode(ratioBefore, ratioAfter));
1116     }
1117 
1118     /// @dev One time function used to remove and give new permission
1119     function monitorProxyUpdate(address[] memory _proxies) public onlyApproved burnGas(30) {
1120         for(uint i = 0; i < _proxies.length; ++i) {
1121             monitorProxyContract.callExecute(
1122             _proxies[i],
1123             PROXY_PERMISSION_ADDR,
1124             abi.encodeWithSignature(
1125                 "givePermission(address)",
1126                 NEW_MONITOR_PROXY_ADDR
1127             ));
1128         }
1129     }
1130 
1131 /******************* INTERNAL METHODS ********************************/
1132     function returnEth() internal {
1133         // return if some eth left
1134         if (address(this).balance > 0) {
1135             msg.sender.transfer(address(this).balance);
1136         }
1137     }
1138 
1139 /******************* STATIC METHODS ********************************/
1140 
1141     /// @notice Returns an address that owns the CDP
1142     /// @param _cdpId Id of the CDP
1143     function getOwner(uint _cdpId) public view returns(address) {
1144         return manager.owns(_cdpId);
1145     }
1146 
1147     /// @notice Gets CDP info (collateral, debt)
1148     /// @param _cdpId Id of the CDP
1149     /// @param _ilk Ilk of the CDP
1150     function getCdpInfo(uint _cdpId, bytes32 _ilk) public view returns (uint, uint) {
1151         address urn = manager.urns(_cdpId);
1152 
1153         (uint collateral, uint debt) = vat.urns(_ilk, urn);
1154         (,uint rate,,,) = vat.ilks(_ilk);
1155 
1156         return (collateral, rmul(debt, rate));
1157     }
1158 
1159     /// @notice Gets a price of the asset
1160     /// @param _ilk Ilk of the CDP
1161     function getPrice(bytes32 _ilk) public view returns (uint) {
1162         (, uint mat) = spotter.ilks(_ilk);
1163         (,,uint spot,,) = vat.ilks(_ilk);
1164 
1165         return rmul(rmul(spot, spotter.par()), mat);
1166     }
1167 
1168     /// @notice Gets CDP ratio
1169     /// @param _cdpId Id of the CDP
1170     /// @param _nextPrice Next price for user
1171     function getRatio(uint _cdpId, uint _nextPrice) public view returns (uint) {
1172         bytes32 ilk = manager.ilks(_cdpId);
1173         uint price = (_nextPrice == 0) ? getPrice(ilk) : _nextPrice;
1174 
1175         (uint collateral, uint debt) = getCdpInfo(_cdpId, ilk);
1176 
1177         if (debt == 0) return 0;
1178 
1179         return rdiv(wmul(collateral, price), debt) / (10 ** 18);
1180     }
1181 
1182     /// @notice Checks if Boost/Repay could be triggered for the CDP
1183     /// @dev Called by MCDMonitor to enforce the min/max check
1184     function canCall(Method _method, uint _cdpId, uint _nextPrice) public view returns(bool, uint) {
1185         bool subscribed;
1186         CdpHolder memory holder;
1187         (subscribed, holder) = subscriptionsContract.getCdpHolder(_cdpId);
1188 
1189         // check if cdp is subscribed
1190         if (!subscribed) return (false, 0);
1191 
1192         // check if using next price is allowed
1193         if (_nextPrice > 0 && !holder.nextPriceEnabled) return (false, 0);
1194 
1195         // check if boost and boost allowed
1196         if (_method == Method.Boost && !holder.boostEnabled) return (false, 0);
1197 
1198         // check if owner is still owner
1199         if (getOwner(_cdpId) != holder.owner) return (false, 0);
1200 
1201         uint currRatio = getRatio(_cdpId, _nextPrice);
1202 
1203         if (_method == Method.Repay) {
1204             return (currRatio < holder.minRatio, currRatio);
1205         } else if (_method == Method.Boost) {
1206             return (currRatio > holder.maxRatio, currRatio);
1207         }
1208     }
1209 
1210     /// @dev After the Boost/Repay check if the ratio doesn't trigger another call
1211     function ratioGoodAfter(Method _method, uint _cdpId, uint _nextPrice) public view returns(bool, uint) {
1212         CdpHolder memory holder;
1213 
1214         (, holder) = subscriptionsContract.getCdpHolder(_cdpId);
1215 
1216         uint currRatio = getRatio(_cdpId, _nextPrice);
1217 
1218         if (_method == Method.Repay) {
1219             return (currRatio < holder.maxRatio, currRatio);
1220         } else if (_method == Method.Boost) {
1221             return (currRatio > holder.minRatio, currRatio);
1222         }
1223     }
1224 
1225     /// @notice Calculates gas cost (in Eth) of tx
1226     /// @dev Gas price is limited to MAX_GAS_PRICE to prevent attack of draining user CDP
1227     /// @param _gasAmount Amount of gas used for the tx
1228     function calcGasCost(uint _gasAmount) public view returns (uint) {
1229         uint gasPrice = tx.gasprice <= MAX_GAS_PRICE ? tx.gasprice : MAX_GAS_PRICE;
1230 
1231         return mul(gasPrice, _gasAmount);
1232     }
1233 
1234 /******************* OWNER ONLY OPERATIONS ********************************/
1235 
1236     /// @notice Allows owner to change gas cost for boost operation, but only up to 3 millions
1237     /// @param _gasCost New gas cost for boost method
1238     function changeBoostGasCost(uint _gasCost) public onlyOwner {
1239         require(_gasCost < 3000000);
1240 
1241         BOOST_GAS_COST = _gasCost;
1242     }
1243 
1244     /// @notice Allows owner to change gas cost for repay operation, but only up to 3 millions
1245     /// @param _gasCost New gas cost for repay method
1246     function changeRepayGasCost(uint _gasCost) public onlyOwner {
1247         require(_gasCost < 3000000);
1248 
1249         REPAY_GAS_COST = _gasCost;
1250     }
1251 
1252     /// @notice Allows owner to change max gas price
1253     /// @param _maxGasPrice New max gas price
1254     function changeMaxGasPrice(uint _maxGasPrice) public onlyOwner {
1255         require(_maxGasPrice < 500000000000);
1256 
1257         MAX_GAS_PRICE = _maxGasPrice;
1258     }
1259 
1260     /// @notice Allows owner to change the amount of gas token burned per function call
1261     /// @param _gasAmount Amount of gas token
1262     /// @param _isRepay Flag to know for which function we are setting the gas token amount
1263     function changeGasTokenAmount(uint _gasAmount, bool _isRepay) public onlyOwner {
1264         if (_isRepay) {
1265             REPAY_GAS_TOKEN = _gasAmount;
1266         } else {
1267             BOOST_GAS_TOKEN = _gasAmount;
1268         }
1269     }
1270 }