1 pragma solidity ^0.6.0;
2 pragma experimental ABIEncoderV2;
3 
4 
5 interface ERC20 {
6     function totalSupply() external view returns (uint256 supply);
7 
8     function balanceOf(address _owner) external view returns (uint256 balance);
9 
10     function transfer(address _to, uint256 _value) external returns (bool success);
11 
12     function transferFrom(address _from, address _to, uint256 _value)
13         external
14         returns (bool success);
15 
16     function approve(address _spender, uint256 _value) external returns (bool success);
17 
18     function allowance(address _owner, address _spender) external view returns (uint256 remaining);
19 
20     function decimals() external view returns (uint256 digits);
21 
22     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
23 }
24 
25 library Address {
26     function isContract(address account) internal view returns (bool) {
27         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
28         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
29         // for accounts without code, i.e. `keccak256('')`
30         bytes32 codehash;
31         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
32         // solhint-disable-next-line no-inline-assembly
33         assembly { codehash := extcodehash(account) }
34         return (codehash != accountHash && codehash != 0x0);
35     }
36 
37     function sendValue(address payable recipient, uint256 amount) internal {
38         require(address(this).balance >= amount, "Address: insufficient balance");
39 
40         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
41         (bool success, ) = recipient.call{ value: amount }("");
42         require(success, "Address: unable to send value, recipient may have reverted");
43     }
44 
45     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
46       return functionCall(target, data, "Address: low-level call failed");
47     }
48 
49     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
50         return _functionCallWithValue(target, data, 0, errorMessage);
51     }
52 
53     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
54         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
55     }
56 
57     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
58         require(address(this).balance >= value, "Address: insufficient balance for call");
59         return _functionCallWithValue(target, data, value, errorMessage);
60     }
61 
62     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
63         require(isContract(target), "Address: call to non-contract");
64 
65         // solhint-disable-next-line avoid-low-level-calls
66         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
67         if (success) {
68             return returndata;
69         } else {
70             // Look for revert reason and bubble it up if present
71             if (returndata.length > 0) {
72                 // The easiest way to bubble the revert reason is using memory via assembly
73 
74                 // solhint-disable-next-line no-inline-assembly
75                 assembly {
76                     let returndata_size := mload(returndata)
77                     revert(add(32, returndata), returndata_size)
78                 }
79             } else {
80                 revert(errorMessage);
81             }
82         }
83     }
84 }
85 
86 // SPDX-License-Identifier: MIT
87 library SafeMath {
88     function add(uint256 a, uint256 b) internal pure returns (uint256) {
89         uint256 c = a + b;
90         require(c >= a, "SafeMath: addition overflow");
91 
92         return c;
93     }
94 
95     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
96         return sub(a, b, "SafeMath: subtraction overflow");
97     }
98 
99     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
100         require(b <= a, errorMessage);
101         uint256 c = a - b;
102 
103         return c;
104     }
105 
106     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
107         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
108         // benefit is lost if 'b' is also tested.
109         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
110         if (a == 0) {
111             return 0;
112         }
113 
114         uint256 c = a * b;
115         require(c / a == b, "SafeMath: multiplication overflow");
116 
117         return c;
118     }
119 
120     function div(uint256 a, uint256 b) internal pure returns (uint256) {
121         return div(a, b, "SafeMath: division by zero");
122     }
123 
124     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
125         require(b > 0, errorMessage);
126         uint256 c = a / b;
127         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
128 
129         return c;
130     }
131 
132     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
133         return mod(a, b, "SafeMath: modulo by zero");
134     }
135 
136     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
137         require(b != 0, errorMessage);
138         return a % b;
139     }
140 }
141 
142 library SafeERC20 {
143     using SafeMath for uint256;
144     using Address for address;
145 
146     function safeTransfer(ERC20 token, address to, uint256 value) internal {
147         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
148     }
149 
150     function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
151         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
152     }
153 
154     /**
155      * @dev Deprecated. This function has issues similar to the ones found in
156      * {IERC20-approve}, and its usage is discouraged.
157      */
158     function safeApprove(ERC20 token, address spender, uint256 value) internal {
159         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
160     }
161 
162     function safeIncreaseAllowance(ERC20 token, address spender, uint256 value) internal {
163         uint256 newAllowance = token.allowance(address(this), spender).add(value);
164         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
165     }
166 
167     function safeDecreaseAllowance(ERC20 token, address spender, uint256 value) internal {
168         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
169         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
170     }
171 
172     function _callOptionalReturn(ERC20 token, bytes memory data) private {
173 
174         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
175         if (returndata.length > 0) { // Return data is optional
176             // solhint-disable-next-line max-line-length
177             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
178         }
179     }
180 }
181 
182 contract AdminAuth {
183 
184     using SafeERC20 for ERC20;
185 
186     address public owner;
187     address public admin;
188 
189     modifier onlyOwner() {
190         require(owner == msg.sender);
191         _;
192     }
193 
194     constructor() public {
195         owner = msg.sender;
196     }
197 
198     /// @notice Admin is set by owner first time, after that admin is super role and has permission to change owner
199     /// @param _admin Address of multisig that becomes admin
200     function setAdminByOwner(address _admin) public {
201         require(msg.sender == owner);
202         require(admin == address(0));
203 
204         admin = _admin;
205     }
206 
207     /// @notice Admin is able to set new admin
208     /// @param _admin Address of multisig that becomes new admin
209     function setAdminByAdmin(address _admin) public {
210         require(msg.sender == admin);
211 
212         admin = _admin;
213     }
214 
215     /// @notice Admin is able to change owner
216     /// @param _owner Address of new owner
217     function setOwnerByAdmin(address _owner) public {
218         require(msg.sender == admin);
219 
220         owner = _owner;
221     }
222 
223     /// @notice Destroy the contract
224     function kill() public onlyOwner {
225         selfdestruct(payable(owner));
226     }
227 
228     /// @notice  withdraw stuck funds
229     function withdrawStuckFunds(address _token, uint _amount) public onlyOwner {
230         if (_token == 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE) {
231             payable(owner).transfer(_amount);
232         } else {
233             ERC20(_token).safeTransfer(owner, _amount);
234         }
235     }
236 }
237 
238 abstract contract GasTokenInterface is ERC20 {
239     function free(uint256 value) public virtual returns (bool success);
240 
241     function freeUpTo(uint256 value) public virtual returns (uint256 freed);
242 
243     function freeFrom(address from, uint256 value) public virtual returns (bool success);
244 
245     function freeFromUpTo(address from, uint256 value) public virtual returns (uint256 freed);
246 }
247 
248 contract DSMath {
249     function add(uint256 x, uint256 y) internal pure returns (uint256 z) {
250         require((z = x + y) >= x);
251     }
252 
253     function sub(uint256 x, uint256 y) internal pure returns (uint256 z) {
254         require((z = x - y) <= x);
255     }
256 
257     function mul(uint256 x, uint256 y) internal pure returns (uint256 z) {
258         require(y == 0 || (z = x * y) / y == x);
259     }
260 
261     function div(uint256 x, uint256 y) internal pure returns (uint256 z) {
262         return x / y;
263     }
264 
265     function min(uint256 x, uint256 y) internal pure returns (uint256 z) {
266         return x <= y ? x : y;
267     }
268 
269     function max(uint256 x, uint256 y) internal pure returns (uint256 z) {
270         return x >= y ? x : y;
271     }
272 
273     function imin(int256 x, int256 y) internal pure returns (int256 z) {
274         return x <= y ? x : y;
275     }
276 
277     function imax(int256 x, int256 y) internal pure returns (int256 z) {
278         return x >= y ? x : y;
279     }
280 
281     uint256 constant WAD = 10**18;
282     uint256 constant RAY = 10**27;
283 
284     function wmul(uint256 x, uint256 y) internal pure returns (uint256 z) {
285         z = add(mul(x, y), WAD / 2) / WAD;
286     }
287 
288     function rmul(uint256 x, uint256 y) internal pure returns (uint256 z) {
289         z = add(mul(x, y), RAY / 2) / RAY;
290     }
291 
292     function wdiv(uint256 x, uint256 y) internal pure returns (uint256 z) {
293         z = add(mul(x, WAD), y / 2) / y;
294     }
295 
296     function rdiv(uint256 x, uint256 y) internal pure returns (uint256 z) {
297         z = add(mul(x, RAY), y / 2) / y;
298     }
299 
300     // This famous algorithm is called "exponentiation by squaring"
301     // and calculates x^n with x as fixed-point and n as regular unsigned.
302     //
303     // It's O(log n), instead of O(n) for naive repeated multiplication.
304     //
305     // These facts are why it works:
306     //
307     //  If n is even, then x^n = (x^2)^(n/2).
308     //  If n is odd,  then x^n = x * x^(n-1),
309     //   and applying the equation for even x gives
310     //    x^n = x * (x^2)^((n-1) / 2).
311     //
312     //  Also, EVM division is flooring and
313     //    floor[(n-1) / 2] = floor[n / 2].
314     //
315     function rpow(uint256 x, uint256 n) internal pure returns (uint256 z) {
316         z = n % 2 != 0 ? x : RAY;
317 
318         for (n /= 2; n != 0; n /= 2) {
319             x = rmul(x, x);
320 
321             if (n % 2 != 0) {
322                 z = rmul(z, x);
323             }
324         }
325     }
326 }
327 
328 abstract contract TokenInterface {
329     function allowance(address, address) public virtual returns (uint256);
330 
331     function balanceOf(address) public virtual returns (uint256);
332 
333     function approve(address, uint256) public virtual;
334 
335     function transfer(address, uint256) public virtual returns (bool);
336 
337     function transferFrom(address, address, uint256) public virtual returns (bool);
338 
339     function deposit() public virtual payable;
340 
341     function withdraw(uint256) public virtual;
342 }
343 
344 interface ExchangeInterfaceV2 {
345     function sell(address _srcAddr, address _destAddr, uint _srcAmount) external payable returns (uint);
346 
347     function buy(address _srcAddr, address _destAddr, uint _destAmount) external payable returns(uint);
348 
349     function getSellRate(address _srcAddr, address _destAddr, uint _srcAmount) external view returns (uint);
350 
351     function getBuyRate(address _srcAddr, address _destAddr, uint _srcAmount) external view returns (uint);
352 }
353 
354 contract ZrxAllowlist is AdminAuth {
355 
356     mapping (address => bool) public zrxAllowlist;
357 
358     function setAllowlistAddr(address _zrxAddr, bool _state) public onlyOwner {
359         zrxAllowlist[_zrxAddr] = _state;
360     }
361 
362     function isZrxAddr(address _zrxAddr) public view returns (bool) {
363         return zrxAllowlist[_zrxAddr];
364     }
365 }
366 
367 contract Discount {
368     address public owner;
369     mapping(address => CustomServiceFee) public serviceFees;
370 
371     uint256 constant MAX_SERVICE_FEE = 400;
372 
373     struct CustomServiceFee {
374         bool active;
375         uint256 amount;
376     }
377 
378     constructor() public {
379         owner = msg.sender;
380     }
381 
382     function isCustomFeeSet(address _user) public view returns (bool) {
383         return serviceFees[_user].active;
384     }
385 
386     function getCustomServiceFee(address _user) public view returns (uint256) {
387         return serviceFees[_user].amount;
388     }
389 
390     function setServiceFee(address _user, uint256 _fee) public {
391         require(msg.sender == owner, "Only owner");
392         require(_fee >= MAX_SERVICE_FEE || _fee == 0);
393 
394         serviceFees[_user] = CustomServiceFee({active: true, amount: _fee});
395     }
396 
397     function disableServiceFee(address _user) public {
398         require(msg.sender == owner, "Only owner");
399 
400         serviceFees[_user] = CustomServiceFee({active: false, amount: 0});
401     }
402 }
403 
404 contract SaverExchangeHelper {
405 
406     using SafeERC20 for ERC20;
407 
408     address public constant KYBER_ETH_ADDRESS = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
409     address public constant WETH_ADDRESS = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
410     address public constant DGD_ADDRESS = 0xE0B7927c4aF23765Cb51314A0E0521A9645F0E2A;
411 
412     address payable public constant WALLET_ID = 0x322d58b9E75a6918f7e7849AEe0fF09369977e08;
413     address public constant DISCOUNT_ADDRESS = 0x1b14E8D511c9A4395425314f849bD737BAF8208F;
414     address public constant SAVER_EXCHANGE_REGISTRY = 0x25dd3F51e0C3c3Ff164DDC02A8E4D65Bb9cBB12D;
415 
416     address public constant KYBER_WRAPPER = 0x42A9237b872368E1bec4Ca8D26A928D7d39d338C;
417     address public constant UNISWAP_WRAPPER = 0x880A845A85F843a5c67DB2061623c6Fc3bB4c511;
418     address public constant OASIS_WRAPPER = 0x4c9B55f2083629A1F7aDa257ae984E03096eCD25;
419     address public constant ERC20_PROXY_0X = 0x95E6F48254609A6ee006F7D493c8e5fB97094ceF;
420     address public constant ZRX_ALLOWLIST_ADDR = 0x019739e288973F92bDD3c1d87178E206E51fd911;
421 
422 
423     function getDecimals(address _token) internal view returns (uint256) {
424         if (_token == DGD_ADDRESS) return 9;
425         if (_token == KYBER_ETH_ADDRESS) return 18;
426 
427         return ERC20(_token).decimals();
428     }
429 
430     function getBalance(address _tokenAddr) internal view returns (uint balance) {
431         if (_tokenAddr == KYBER_ETH_ADDRESS) {
432             balance = address(this).balance;
433         } else {
434             balance = ERC20(_tokenAddr).balanceOf(address(this));
435         }
436     }
437 
438     function approve0xProxy(address _tokenAddr, uint _amount) internal {
439         if (_tokenAddr != KYBER_ETH_ADDRESS) {
440             ERC20(_tokenAddr).safeApprove(address(ERC20_PROXY_0X), _amount);
441         }
442     }
443 
444     function sendLeftover(address _srcAddr, address _destAddr, address payable _to) internal {
445         // send back any leftover ether or tokens
446         if (address(this).balance > 0) {
447             _to.transfer(address(this).balance);
448         }
449 
450         if (getBalance(_srcAddr) > 0) {
451             ERC20(_srcAddr).safeTransfer(_to, getBalance(_srcAddr));
452         }
453 
454         if (getBalance(_destAddr) > 0) {
455             ERC20(_destAddr).safeTransfer(_to, getBalance(_destAddr));
456         }
457     }
458 
459     function sliceUint(bytes memory bs, uint256 start) internal pure returns (uint256) {
460         require(bs.length >= start + 32, "slicing out of range");
461 
462         uint256 x;
463         assembly {
464             x := mload(add(bs, add(0x20, start)))
465         }
466 
467         return x;
468     }
469 }
470 
471 contract SaverExchangeRegistry is AdminAuth {
472 
473 	mapping(address => bool) private wrappers;
474 
475 	constructor() public {
476 		wrappers[0x880A845A85F843a5c67DB2061623c6Fc3bB4c511] = true;
477 		wrappers[0x4c9B55f2083629A1F7aDa257ae984E03096eCD25] = true;
478 		wrappers[0x42A9237b872368E1bec4Ca8D26A928D7d39d338C] = true;
479 	}
480 
481 	function addWrapper(address _wrapper) public onlyOwner {
482 		wrappers[_wrapper] = true;
483 	}
484 
485 	function removeWrapper(address _wrapper) public onlyOwner {
486 		wrappers[_wrapper] = false;
487 	}
488 
489 	function isWrapper(address _wrapper) public view returns(bool) {
490 		return wrappers[_wrapper];
491 	}
492 }
493 
494 contract SaverExchangeCore is SaverExchangeHelper, DSMath {
495 
496     // first is empty to keep the legacy order in place
497     enum ExchangeType { _, OASIS, KYBER, UNISWAP, ZEROX }
498 
499     enum ActionType { SELL, BUY }
500 
501     struct ExchangeData {
502         address srcAddr;
503         address destAddr;
504         uint srcAmount;
505         uint destAmount;
506         uint minPrice;
507         address wrapper;
508         address exchangeAddr;
509         bytes callData;
510         uint256 price0x;
511     }
512 
513     /// @notice Internal method that preforms a sell on 0x/on-chain
514     /// @dev Usefull for other DFS contract to integrate for exchanging
515     /// @param exData Exchange data struct
516     /// @return (address, uint) Address of the wrapper used and destAmount
517     function _sell(ExchangeData memory exData) internal returns (address, uint) {
518 
519         address wrapper;
520         uint swapedTokens;
521         bool success;
522         uint tokensLeft = exData.srcAmount;
523 
524         // if selling eth, convert to weth
525         if (exData.srcAddr == KYBER_ETH_ADDRESS) {
526             exData.srcAddr = ethToWethAddr(exData.srcAddr);
527             TokenInterface(WETH_ADDRESS).deposit.value(exData.srcAmount)();
528         }
529 
530         // Try 0x first and then fallback on specific wrapper
531         if (exData.price0x > 0) {
532             approve0xProxy(exData.srcAddr, exData.srcAmount);
533 
534             (success, swapedTokens, tokensLeft) = takeOrder(exData, address(this).balance, ActionType.SELL);
535 
536             if (success) {
537                 wrapper = exData.exchangeAddr;
538             }
539         }
540 
541         // fallback to desired wrapper if 0x failed
542         if (!success) {
543             swapedTokens = saverSwap(exData, ActionType.SELL);
544             wrapper = exData.wrapper;
545         }
546 
547         require(getBalance(exData.destAddr) >= wmul(exData.minPrice, exData.srcAmount), "Final amount isn't correct");
548 
549         // if anything is left in weth, pull it to user as eth
550         if (getBalance(WETH_ADDRESS) > 0) {
551             TokenInterface(WETH_ADDRESS).withdraw(
552                 TokenInterface(WETH_ADDRESS).balanceOf(address(this))
553             );
554         }            
555 
556         return (wrapper, swapedTokens);
557     }
558 
559     /// @notice Internal method that preforms a buy on 0x/on-chain
560     /// @dev Usefull for other DFS contract to integrate for exchanging
561     /// @param exData Exchange data struct
562     /// @return (address, uint) Address of the wrapper used and srcAmount
563     function _buy(ExchangeData memory exData) internal returns (address, uint) {
564 
565         address wrapper;
566         uint swapedTokens;
567         bool success;
568 
569         require(exData.destAmount != 0, "Dest amount must be specified");
570 
571         // if selling eth, convert to weth
572         if (exData.srcAddr == KYBER_ETH_ADDRESS) {
573             exData.srcAddr = ethToWethAddr(exData.srcAddr);
574             TokenInterface(WETH_ADDRESS).deposit.value(exData.srcAmount)();
575         }
576 
577         if (exData.price0x > 0) { 
578             approve0xProxy(exData.srcAddr, exData.srcAmount);
579 
580             (success, swapedTokens,) = takeOrder(exData, address(this).balance, ActionType.BUY);
581 
582             if (success) {
583                 wrapper = exData.exchangeAddr;
584             }
585         }
586 
587         // fallback to desired wrapper if 0x failed
588         if (!success) {
589             swapedTokens = saverSwap(exData, ActionType.BUY);
590             wrapper = exData.wrapper;
591         }
592 
593         require(getBalance(exData.destAddr) >= exData.destAmount, "Final amount isn't correct");
594 
595         // if anything is left in weth, pull it to user as eth
596         if (getBalance(WETH_ADDRESS) > 0) {
597             TokenInterface(WETH_ADDRESS).withdraw(
598                 TokenInterface(WETH_ADDRESS).balanceOf(address(this))
599             );
600         }
601 
602         return (wrapper, getBalance(exData.destAddr));
603     }
604 
605     /// @notice Takes order from 0x and returns bool indicating if it is successful
606     /// @param _exData Exchange data
607     /// @param _ethAmount Ether fee needed for 0x order
608     function takeOrder(
609         ExchangeData memory _exData,
610         uint256 _ethAmount,
611         ActionType _type
612     ) private returns (bool success, uint256, uint256) {
613 
614         // write in the exact amount we are selling/buing in an order
615         if (_type == ActionType.SELL) {
616             writeUint256(_exData.callData, 36, _exData.srcAmount);
617         } else {
618             writeUint256(_exData.callData, 36, _exData.destAmount);
619         }
620 
621         if (ZrxAllowlist(ZRX_ALLOWLIST_ADDR).isZrxAddr(_exData.exchangeAddr)) {
622             (success, ) = _exData.exchangeAddr.call{value: _ethAmount}(_exData.callData);
623         } else {
624             success = false;
625         }
626 
627         uint256 tokensSwaped = 0;
628         uint256 tokensLeft = _exData.srcAmount;
629 
630         if (success) {
631             // check to see if any _src tokens are left over after exchange
632             tokensLeft = getBalance(_exData.srcAddr);
633 
634             // convert weth -> eth if needed
635             if (_exData.destAddr == KYBER_ETH_ADDRESS) {
636                 TokenInterface(WETH_ADDRESS).withdraw(
637                     TokenInterface(WETH_ADDRESS).balanceOf(address(this))
638                 );
639             }
640 
641             // get the current balance of the swaped tokens
642             tokensSwaped = getBalance(_exData.destAddr);
643         }
644 
645         return (success, tokensSwaped, tokensLeft);
646     }
647 
648     /// @notice Returns the best estimated price from 2 exchanges
649     /// @param _amount Amount of source tokens you want to exchange
650     /// @param _srcToken Address of the source token
651     /// @param _destToken Address of the destination token
652     /// @param _exchangeType Which exchange will be used
653     /// @param _type Type of action SELL|BUY
654     /// @return (address, uint) The address of the best exchange and the exchange price
655     function getBestPrice(
656         uint256 _amount,
657         address _srcToken,
658         address _destToken,
659         ExchangeType _exchangeType,
660         ActionType _type
661     ) public returns (address, uint256) {
662 
663         if (_exchangeType == ExchangeType.OASIS) {
664             return (OASIS_WRAPPER, getExpectedRate(OASIS_WRAPPER, _srcToken, _destToken, _amount, _type));
665         }
666 
667         if (_exchangeType == ExchangeType.KYBER) {
668             return (KYBER_WRAPPER, getExpectedRate(KYBER_WRAPPER, _srcToken, _destToken, _amount, _type));
669         }
670 
671         if (_exchangeType == ExchangeType.UNISWAP) {
672             return (UNISWAP_WRAPPER, getExpectedRate(UNISWAP_WRAPPER, _srcToken, _destToken, _amount, _type));
673         }
674 
675         uint expectedRateKyber = getExpectedRate(KYBER_WRAPPER, _srcToken, _destToken, _amount, _type);
676         uint expectedRateUniswap = getExpectedRate(UNISWAP_WRAPPER, _srcToken, _destToken, _amount, _type);
677         uint expectedRateOasis = getExpectedRate(OASIS_WRAPPER, _srcToken, _destToken, _amount, _type);
678 
679         if (_type == ActionType.SELL) {
680             return getBiggestRate(expectedRateKyber, expectedRateUniswap, expectedRateOasis);
681         } else {
682             return getSmallestRate(expectedRateKyber, expectedRateUniswap, expectedRateOasis);
683         }
684     }
685 
686     /// @notice Return the expected rate from the exchange wrapper
687     /// @dev In case of Oasis/Uniswap handles the different precision tokens
688     /// @param _wrapper Address of exchange wrapper
689     /// @param _srcToken From token
690     /// @param _destToken To token
691     /// @param _amount Amount to be exchanged
692     /// @param _type Type of action SELL|BUY
693     function getExpectedRate(
694         address _wrapper,
695         address _srcToken,
696         address _destToken,
697         uint256 _amount,
698         ActionType _type
699     ) public returns (uint256) {
700         bool success;
701         bytes memory result;
702 
703         if (_type == ActionType.SELL) {
704             (success, result) = _wrapper.call(abi.encodeWithSignature(
705                 "getSellRate(address,address,uint256)",
706                 _srcToken,
707                 _destToken,
708                 _amount
709             ));
710 
711         } else {
712             (success, result) = _wrapper.call(abi.encodeWithSignature(
713                 "getBuyRate(address,address,uint256)",
714                 _srcToken,
715                 _destToken,
716                 _amount
717             ));
718         }
719 
720         if (success) {
721             uint rate = sliceUint(result, 0);
722 
723             if (_wrapper != KYBER_WRAPPER) {
724                 rate = rate * (10**(18 - getDecimals(_destToken)));
725             }
726 
727             return rate;
728         }
729 
730         return 0;
731     }
732 
733     /// @notice Calls wraper contract for exchage to preform an on-chain swap
734     /// @param _exData Exchange data struct
735     /// @param _type Type of action SELL|BUY
736     /// @return swapedTokens For Sell that the destAmount, for Buy thats the srcAmount
737     function saverSwap(ExchangeData memory _exData, ActionType _type) internal returns (uint swapedTokens) {
738         require(SaverExchangeRegistry(SAVER_EXCHANGE_REGISTRY).isWrapper(_exData.wrapper), "Wrapper is not valid");
739 
740         uint ethValue = 0;
741 
742         ERC20(_exData.srcAddr).safeTransfer(_exData.wrapper, _exData.srcAmount);
743         
744         if (_type == ActionType.SELL) {
745             swapedTokens = ExchangeInterfaceV2(_exData.wrapper).
746                     sell{value: ethValue}(_exData.srcAddr, _exData.destAddr, _exData.srcAmount);
747         } else {
748             swapedTokens = ExchangeInterfaceV2(_exData.wrapper).
749                     buy{value: ethValue}(_exData.srcAddr, _exData.destAddr, _exData.destAmount);
750         }
751     }
752 
753     /// @notice Finds the biggest rate between exchanges, needed for sell rate
754     /// @param _expectedRateKyber Kyber rate
755     /// @param _expectedRateUniswap Uniswap rate
756     /// @param _expectedRateOasis Oasis rate
757     function getBiggestRate(
758         uint _expectedRateKyber,
759         uint _expectedRateUniswap,
760         uint _expectedRateOasis
761     ) internal pure returns (address, uint) {
762         if (
763             (_expectedRateUniswap >= _expectedRateKyber) && (_expectedRateUniswap >= _expectedRateOasis)
764         ) {
765             return (UNISWAP_WRAPPER, _expectedRateUniswap);
766         }
767 
768         if (
769             (_expectedRateKyber >= _expectedRateUniswap) && (_expectedRateKyber >= _expectedRateOasis)
770         ) {
771             return (KYBER_WRAPPER, _expectedRateKyber);
772         }
773 
774         if (
775             (_expectedRateOasis >= _expectedRateKyber) && (_expectedRateOasis >= _expectedRateUniswap)
776         ) {
777             return (OASIS_WRAPPER, _expectedRateOasis);
778         }
779     }
780 
781     /// @notice Finds the smallest rate between exchanges, needed for buy rate
782     /// @param _expectedRateKyber Kyber rate
783     /// @param _expectedRateUniswap Uniswap rate
784     /// @param _expectedRateOasis Oasis rate
785     function getSmallestRate(
786         uint _expectedRateKyber,
787         uint _expectedRateUniswap,
788         uint _expectedRateOasis
789     ) internal pure returns (address, uint) {
790         if (
791             (_expectedRateUniswap <= _expectedRateKyber) && (_expectedRateUniswap <= _expectedRateOasis)
792         ) {
793             return (UNISWAP_WRAPPER, _expectedRateUniswap);
794         }
795 
796         if (
797             (_expectedRateKyber <= _expectedRateUniswap) && (_expectedRateKyber <= _expectedRateOasis)
798         ) {
799             return (KYBER_WRAPPER, _expectedRateKyber);
800         }
801 
802         if (
803             (_expectedRateOasis <= _expectedRateKyber) && (_expectedRateOasis <= _expectedRateUniswap)
804         ) {
805             return (OASIS_WRAPPER, _expectedRateOasis);
806         }
807     }
808 
809     function writeUint256(bytes memory _b, uint256 _index, uint _input) internal pure {
810         if (_b.length < _index + 32) {
811             revert("Incorrent lengt while writting bytes32");
812         }
813 
814         bytes32 input = bytes32(_input);
815 
816         _index += 32;
817 
818         // Read the bytes32 from array memory
819         assembly {
820             mstore(add(_b, _index), input)
821         }
822     }
823 
824     /// @notice Converts Kybers Eth address -> Weth
825     /// @param _src Input address
826     function ethToWethAddr(address _src) internal pure returns (address) {
827         return _src == KYBER_ETH_ADDRESS ? WETH_ADDRESS : _src;
828     }
829 
830     // solhint-disable-next-line no-empty-blocks
831     receive() external virtual payable {}
832 }
833 
834 contract DefisaverLogger {
835     event LogEvent(
836         address indexed contractAddress,
837         address indexed caller,
838         string indexed logName,
839         bytes data
840     );
841 
842     // solhint-disable-next-line func-name-mixedcase
843     function Log(address _contract, address _caller, string memory _logName, bytes memory _data)
844         public
845     {
846         emit LogEvent(_contract, _caller, _logName, _data);
847     }
848 }
849 
850 contract GasBurner {
851     // solhint-disable-next-line const-name-snakecase
852     GasTokenInterface public constant gasToken = GasTokenInterface(0x0000000000b3F879cb30FE243b4Dfee438691c04);
853 
854     modifier burnGas(uint _amount) {
855         uint gst2Amount = _amount;
856 
857         if (_amount == 0) {
858             gst2Amount = (gasleft() + 14154) / (2 * 24000 - 6870);
859             gst2Amount = gst2Amount - (gst2Amount / 3); // 33.3% less because of gaslimit != gas_used
860         }
861 
862         if (gasToken.balanceOf(address(this)) >= gst2Amount) {
863             gasToken.free(gst2Amount);
864         }
865 
866         _;
867     }
868 }
869 
870 contract SaverExchange is SaverExchangeCore, AdminAuth, GasBurner {
871 
872     using SafeERC20 for ERC20;
873 
874     uint256 public constant SERVICE_FEE = 800; // 0.125% Fee
875 
876     // solhint-disable-next-line const-name-snakecase
877     DefisaverLogger public constant logger = DefisaverLogger(0x5c55B921f590a89C1Ebe84dF170E655a82b62126);
878 
879     uint public burnAmount = 10;
880 
881     /// @notice Takes a src amount of tokens and converts it into the dest token
882     /// @dev Takes fee from the _srcAmount before the exchange
883     /// @param exData [srcAddr, destAddr, srcAmount, destAmount, minPrice, exchangeType, exchangeAddr, callData, price0x]
884     /// @param _user User address who called the exchange
885     function sell(ExchangeData memory exData, address payable _user) public payable burnGas(burnAmount) {
886 
887         // take fee
888         uint dfsFee = getFee(exData.srcAmount, exData.srcAddr);
889         exData.srcAmount = sub(exData.srcAmount, dfsFee);
890 
891         // Perform the exchange
892         (address wrapper, uint destAmount) = _sell(exData);
893 
894         // send back any leftover ether or tokens
895         sendLeftover(exData.srcAddr, exData.destAddr, _user);
896 
897         // log the event
898         logger.Log(address(this), msg.sender, "ExchangeSell", abi.encode(wrapper, exData.srcAddr, exData.destAddr, exData.srcAmount, destAmount));
899     }
900 
901     /// @notice Takes a dest amount of tokens and converts it from the src token
902     /// @dev Send always more than needed for the swap, extra will be returned
903     /// @param exData [srcAddr, destAddr, srcAmount, destAmount, minPrice, exchangeType, exchangeAddr, callData, price0x]
904     /// @param _user User address who called the exchange
905     function buy(ExchangeData memory exData, address payable _user) public payable burnGas(burnAmount){
906 
907         uint dfsFee = getFee(exData.srcAmount, exData.srcAddr);
908         exData.srcAmount = sub(exData.srcAmount, dfsFee);
909 
910         // Perform the exchange
911         (address wrapper, uint srcAmount) = _buy(exData);
912 
913         // send back any leftover ether or tokens
914         sendLeftover(exData.srcAddr, exData.destAddr, _user);
915 
916         // log the event
917         logger.Log(address(this), msg.sender, "ExchangeBuy", abi.encode(wrapper, exData.srcAddr, exData.destAddr, srcAmount, exData.destAmount));
918 
919     }
920 
921     /// @notice Takes a feePercentage and sends it to wallet
922     /// @param _amount Dai amount of the whole trade
923     /// @param _token Address of the token
924     /// @return feeAmount Amount in Dai owner earned on the fee
925     function getFee(uint256 _amount, address _token) internal returns (uint256 feeAmount) {
926         uint256 fee = SERVICE_FEE;
927 
928         if (Discount(DISCOUNT_ADDRESS).isCustomFeeSet(msg.sender)) {
929             fee = Discount(DISCOUNT_ADDRESS).getCustomServiceFee(msg.sender);
930         }
931 
932         if (fee == 0) {
933             feeAmount = 0;
934         } else {
935             feeAmount = _amount / fee;
936             if (_token == KYBER_ETH_ADDRESS) {
937                 WALLET_ID.transfer(feeAmount);
938             } else {
939                 ERC20(_token).safeTransfer(WALLET_ID, feeAmount);
940             }
941         }
942     }
943 
944     /// @notice Changes the amount of gas token we burn for each call
945     /// @dev Only callable by the owner
946     /// @param _newBurnAmount New amount of gas tokens to be burned
947     function changeBurnAmount(uint _newBurnAmount) public {
948         require(owner == msg.sender);
949 
950         burnAmount = _newBurnAmount;
951     }
952 
953 }
954 
955 contract AllowanceProxy is AdminAuth {
956 
957     using SafeERC20 for ERC20;
958 
959     address public constant KYBER_ETH_ADDRESS = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
960 
961     // TODO: Real saver exchange address
962     SaverExchange saverExchange = SaverExchange(0x235abFAd01eb1BDa28Ef94087FBAA63E18074926);
963 
964     function callSell(SaverExchangeCore.ExchangeData memory exData) public payable {
965         pullAndSendTokens(exData.srcAddr, exData.srcAmount);
966 
967         saverExchange.sell{value: msg.value}(exData, msg.sender);
968     }
969 
970     function callBuy(SaverExchangeCore.ExchangeData memory exData) public payable {
971         pullAndSendTokens(exData.srcAddr, exData.srcAmount);
972 
973         saverExchange.buy{value: msg.value}(exData, msg.sender);
974     }
975 
976     function pullAndSendTokens(address _tokenAddr, uint _amount) internal {
977         if (_tokenAddr == KYBER_ETH_ADDRESS) {
978             require(msg.value >= _amount, "msg.value smaller than amount");
979         } else {
980             ERC20(_tokenAddr).safeTransferFrom(msg.sender, address(saverExchange), _amount);
981         }
982     }
983 
984     function ownerChangeExchange(address payable _newExchange) public onlyOwner {
985         saverExchange = SaverExchange(_newExchange);
986     }
987 }