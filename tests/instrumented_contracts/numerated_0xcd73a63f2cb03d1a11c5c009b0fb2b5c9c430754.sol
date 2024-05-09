1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity =0.7.6;  
4 
5 
6 
7 abstract contract IDFSRegistry {
8  
9     function getAddr(bytes32 _id) public view virtual returns (address);
10 
11     function addNewContract(
12         bytes32 _id,
13         address _contractAddr,
14         uint256 _waitPeriod
15     ) public virtual;
16 
17     function startContractChange(bytes32 _id, address _newContractAddr) public virtual;
18 
19     function approveContractChange(bytes32 _id) public virtual;
20 
21     function cancelContractChange(bytes32 _id) public virtual;
22 
23     function changeWaitPeriod(bytes32 _id, uint256 _newWaitPeriod) public virtual;
24 }  
25 
26 
27 
28 interface IERC20 {
29     function totalSupply() external view returns (uint256 supply);
30 
31     function balanceOf(address _owner) external view returns (uint256 balance);
32 
33     function transfer(address _to, uint256 _value) external returns (bool success);
34 
35     function transferFrom(
36         address _from,
37         address _to,
38         uint256 _value
39     ) external returns (bool success);
40 
41     function approve(address _spender, uint256 _value) external returns (bool success);
42 
43     function allowance(address _owner, address _spender) external view returns (uint256 remaining);
44 
45     function decimals() external view returns (uint256 digits);
46 
47     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
48 }  
49 
50 
51 
52 library Address {
53     function isContract(address account) internal view returns (bool) {
54         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
55         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
56         // for accounts without code, i.e. `keccak256('')`
57         bytes32 codehash;
58         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
59         // solhint-disable-next-line no-inline-assembly
60         assembly {
61             codehash := extcodehash(account)
62         }
63         return (codehash != accountHash && codehash != 0x0);
64     }
65 
66     function sendValue(address payable recipient, uint256 amount) internal {
67         require(address(this).balance >= amount, "Address: insufficient balance");
68 
69         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
70         (bool success, ) = recipient.call{value: amount}("");
71         require(success, "Address: unable to send value, recipient may have reverted");
72     }
73 
74     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
75         return functionCall(target, data, "Address: low-level call failed");
76     }
77 
78     function functionCall(
79         address target,
80         bytes memory data,
81         string memory errorMessage
82     ) internal returns (bytes memory) {
83         return _functionCallWithValue(target, data, 0, errorMessage);
84     }
85 
86     function functionCallWithValue(
87         address target,
88         bytes memory data,
89         uint256 value
90     ) internal returns (bytes memory) {
91         return
92             functionCallWithValue(target, data, value, "Address: low-level call with value failed");
93     }
94 
95     function functionCallWithValue(
96         address target,
97         bytes memory data,
98         uint256 value,
99         string memory errorMessage
100     ) internal returns (bytes memory) {
101         require(address(this).balance >= value, "Address: insufficient balance for call");
102         return _functionCallWithValue(target, data, value, errorMessage);
103     }
104 
105     function _functionCallWithValue(
106         address target,
107         bytes memory data,
108         uint256 weiValue,
109         string memory errorMessage
110     ) private returns (bytes memory) {
111         require(isContract(target), "Address: call to non-contract");
112 
113         // solhint-disable-next-line avoid-low-level-calls
114         (bool success, bytes memory returndata) = target.call{value: weiValue}(data);
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
132 }  
133 
134 
135 
136 library SafeMath {
137     function add(uint256 a, uint256 b) internal pure returns (uint256) {
138         uint256 c = a + b;
139         require(c >= a, "SafeMath: addition overflow");
140 
141         return c;
142     }
143 
144     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
145         return sub(a, b, "SafeMath: subtraction overflow");
146     }
147 
148     function sub(
149         uint256 a,
150         uint256 b,
151         string memory errorMessage
152     ) internal pure returns (uint256) {
153         require(b <= a, errorMessage);
154         uint256 c = a - b;
155 
156         return c;
157     }
158 
159     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
160         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
161         // benefit is lost if 'b' is also tested.
162         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
163         if (a == 0) {
164             return 0;
165         }
166 
167         uint256 c = a * b;
168         require(c / a == b, "SafeMath: multiplication overflow");
169 
170         return c;
171     }
172 
173     function div(uint256 a, uint256 b) internal pure returns (uint256) {
174         return div(a, b, "SafeMath: division by zero");
175     }
176 
177     function div(
178         uint256 a,
179         uint256 b,
180         string memory errorMessage
181     ) internal pure returns (uint256) {
182         require(b > 0, errorMessage);
183         uint256 c = a / b;
184         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
185 
186         return c;
187     }
188 
189     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
190         return mod(a, b, "SafeMath: modulo by zero");
191     }
192 
193     function mod(
194         uint256 a,
195         uint256 b,
196         string memory errorMessage
197     ) internal pure returns (uint256) {
198         require(b != 0, errorMessage);
199         return a % b;
200     }
201 }  
202 
203 
204 
205 
206 
207 
208 
209 library SafeERC20 {
210     using SafeMath for uint256;
211     using Address for address;
212 
213     function safeTransfer(
214         IERC20 token,
215         address to,
216         uint256 value
217     ) internal {
218         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
219     }
220 
221     function safeTransferFrom(
222         IERC20 token,
223         address from,
224         address to,
225         uint256 value
226     ) internal {
227         _callOptionalReturn(
228             token,
229             abi.encodeWithSelector(token.transferFrom.selector, from, to, value)
230         );
231     }
232 
233     /// @dev Edited so it always first approves 0 and then the value, because of non standard tokens
234     function safeApprove(
235         IERC20 token,
236         address spender,
237         uint256 value
238     ) internal {
239         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, 0));
240         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
241     }
242 
243     function safeIncreaseAllowance(
244         IERC20 token,
245         address spender,
246         uint256 value
247     ) internal {
248         uint256 newAllowance = token.allowance(address(this), spender).add(value);
249         _callOptionalReturn(
250             token,
251             abi.encodeWithSelector(token.approve.selector, spender, newAllowance)
252         );
253     }
254 
255     function safeDecreaseAllowance(
256         IERC20 token,
257         address spender,
258         uint256 value
259     ) internal {
260         uint256 newAllowance = token.allowance(address(this), spender).sub(
261             value,
262             "SafeERC20: decreased allowance below zero"
263         );
264         _callOptionalReturn(
265             token,
266             abi.encodeWithSelector(token.approve.selector, spender, newAllowance)
267         );
268     }
269 
270     function _callOptionalReturn(IERC20 token, bytes memory data) private {
271         bytes memory returndata = address(token).functionCall(
272             data,
273             "SafeERC20: low-level call failed"
274         );
275         if (returndata.length > 0) {
276             // Return data is optional
277             // solhint-disable-next-line max-line-length
278             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
279         }
280     }
281 }  
282 
283 
284 
285 /// @title A stateful contract that holds and can change owner/admin
286 contract AdminVault {
287     address public owner;
288     address public admin;
289 
290     constructor() {
291         owner = msg.sender;
292         admin = 0x25eFA336886C74eA8E282ac466BdCd0199f85BB9;
293     }
294 
295     /// @notice Admin is able to change owner
296     /// @param _owner Address of new owner
297     function changeOwner(address _owner) public {
298         require(admin == msg.sender, "msg.sender not admin");
299         owner = _owner;
300     }
301 
302     /// @notice Admin is able to set new admin
303     /// @param _admin Address of multisig that becomes new admin
304     function changeAdmin(address _admin) public {
305         require(admin == msg.sender, "msg.sender not admin");
306         admin = _admin;
307     }
308 
309 }  
310 
311 
312 
313 
314 
315 
316 
317 
318 /// @title AdminAuth Handles owner/admin privileges over smart contracts
319 contract AdminAuth {
320     using SafeERC20 for IERC20;
321 
322     AdminVault public constant adminVault = AdminVault(0xCCf3d848e08b94478Ed8f46fFead3008faF581fD);
323 
324     modifier onlyOwner() {
325         require(adminVault.owner() == msg.sender, "msg.sender not owner");
326         _;
327     }
328 
329     modifier onlyAdmin() {
330         require(adminVault.admin() == msg.sender, "msg.sender not admin");
331         _;
332     }
333 
334     /// @notice withdraw stuck funds
335     function withdrawStuckFunds(address _token, address _receiver, uint256 _amount) public onlyOwner {
336         if (_token == 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE) {
337             payable(_receiver).transfer(_amount);
338         } else {
339             IERC20(_token).safeTransfer(_receiver, _amount);
340         }
341     }
342 
343     /// @notice Destroy the contract
344     function kill() public onlyAdmin {
345         selfdestruct(payable(msg.sender));
346     }
347 }  
348 
349 
350 
351 abstract contract IUniswapRouter {
352     function swapExactTokensForETH(
353         uint256 amountIn,
354         uint256 amountOutMin,
355         address[] calldata path,
356         address to,
357         uint256 deadline
358     ) external virtual returns (uint256[] memory amounts);
359 
360     function swapExactTokensForTokens(
361         uint256 amountIn,
362         uint256 amountOutMin,
363         address[] calldata path,
364         address to,
365         uint256 deadline
366     ) external virtual returns (uint256[] memory amounts);
367 
368     function swapTokensForExactETH(
369         uint256 amountOut,
370         uint256 amountInMax,
371         address[] calldata path,
372         address to,
373         uint256 deadline
374     ) external virtual returns (uint256[] memory amounts);
375 
376     function swapTokensForExactTokens(
377         uint256 amountOut,
378         uint256 amountInMax,
379         address[] calldata path,
380         address to,
381         uint256 deadline
382     ) external virtual returns (uint256[] memory amounts);
383 
384     function addLiquidity(
385         address tokenA,
386         address tokenB,
387         uint256 amountADesired,
388         uint256 amountBDesired,
389         uint256 amountAMin,
390         uint256 amountBMin,
391         address to,
392         uint256 deadline
393     )
394         external
395         virtual
396         returns (
397             uint256 amountA,
398             uint256 amountB,
399             uint256 liquidity
400         );
401 
402     function addLiquidityETH(
403         address token,
404         uint256 amountTokenDesired,
405         uint256 amountTokenMin,
406         uint256 amountETHMin,
407         address to,
408         uint256 deadline
409     )
410         external
411         payable
412         virtual
413         returns (
414             uint256 amountToken,
415             uint256 amountETH,
416             uint256 liquidity
417         );
418 
419     function removeLiquidity(
420         address tokenA,
421         address tokenB,
422         uint256 liquidity,
423         uint256 amountAMin,
424         uint256 amountBMin,
425         address to,
426         uint256 deadline
427     ) external virtual returns (uint256 amountA, uint256 amountB);
428 
429     function quote(
430         uint256 amountA,
431         uint256 reserveA,
432         uint256 reserveB
433     ) public pure virtual returns (uint256 amountB);
434 
435     function getAmountsOut(uint256 amountIn, address[] memory path)
436         public
437         view
438         virtual
439         returns (uint256[] memory amounts);
440 
441     function getAmountsIn(uint256 amountOut, address[] memory path)
442         public
443         view
444         virtual
445         returns (uint256[] memory amounts);
446 }  
447 
448 
449 
450 abstract contract IBotRegistry {
451     function botList(address) public virtual view returns (bool);
452 }  
453 
454 
455 
456 
457 
458 abstract contract IWETH {
459     function allowance(address, address) public virtual view returns (uint256);
460 
461     function balanceOf(address) public virtual view returns (uint256);
462 
463     function approve(address, uint256) public virtual;
464 
465     function transfer(address, uint256) public virtual returns (bool);
466 
467     function transferFrom(
468         address,
469         address,
470         uint256
471     ) public virtual returns (bool);
472 
473     function deposit() public payable virtual;
474 
475     function withdraw(uint256) public virtual;
476 }  
477 
478 
479 
480 
481 
482 
483 library TokenUtils {
484     using SafeERC20 for IERC20;
485 
486     address public constant WETH_ADDR = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
487     address public constant ETH_ADDR = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
488 
489     function approveToken(
490         address _tokenAddr,
491         address _to,
492         uint256 _amount
493     ) internal {
494         if (_tokenAddr == ETH_ADDR) return;
495 
496         if (IERC20(_tokenAddr).allowance(address(this), _to) < _amount) {
497             IERC20(_tokenAddr).safeApprove(_to, _amount);
498         }
499     }
500 
501     function pullTokensIfNeeded(
502         address _token,
503         address _from,
504         uint256 _amount
505     ) internal returns (uint256) {
506         // handle max uint amount
507         if (_amount == type(uint256).max) {
508             uint256 userAllowance = IERC20(_token).allowance(_from, address(this));
509             uint256 balance = getBalance(_token, _from);
510 
511             // pull max allowance amount if balance is bigger than allowance
512             _amount = (balance > userAllowance) ? userAllowance : balance;
513         }
514 
515         if (_from != address(0) && _from != address(this) && _token != ETH_ADDR && _amount != 0) {
516             IERC20(_token).safeTransferFrom(_from, address(this), _amount);
517         }
518 
519         return _amount;
520     }
521 
522     function withdrawTokens(
523         address _token,
524         address _to,
525         uint256 _amount
526     ) internal returns (uint256) {
527         if (_amount == type(uint256).max) {
528             _amount = getBalance(_token, address(this));
529         }
530 
531         if (_to != address(0) && _to != address(this) && _amount != 0) {
532             if (_token != ETH_ADDR) {
533                 IERC20(_token).safeTransfer(_to, _amount);
534             } else {
535                 payable(_to).transfer(_amount);
536             }
537         }
538 
539         return _amount;
540     }
541 
542     function depositWeth(uint256 _amount) internal {
543         IWETH(WETH_ADDR).deposit{value: _amount}();
544     }
545 
546     function withdrawWeth(uint256 _amount) internal {
547         IWETH(WETH_ADDR).withdraw(_amount);
548     }
549 
550     function getBalance(address _tokenAddr, address _acc) internal view returns (uint256) {
551         if (_tokenAddr == ETH_ADDR) {
552             return _acc.balance;
553         } else {
554             return IERC20(_tokenAddr).balanceOf(_acc);
555         }
556     }
557 
558     function getTokenDecimals(address _token) internal view returns (uint256) {
559         if (_token == ETH_ADDR) return 18;
560 
561         return IERC20(_token).decimals();
562     }
563 }  
564 
565 
566 
567 
568 
569 
570 
571 
572 /// @title Contract used to refill tx sending bots when they are low on eth
573 contract BotRefills is AdminAuth {
574     using TokenUtils for address;
575 
576     address internal refillCaller = 0x33fDb79aFB4456B604f376A45A546e7ae700e880;
577     address internal feeAddr = 0x76720aC2574631530eC8163e4085d6F98513fb27;
578 
579     address internal constant BOT_REGISTRY_ADDRESS = 0x637726f8b08a7ABE3aE3aCaB01A80E2d8ddeF77B;
580     address internal constant DAI_ADDR = 0x6B175474E89094C44Da98b954EedeAC495271d0F;
581 
582     IUniswapRouter internal router = IUniswapRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
583 
584     mapping(address => bool) public additionalBots;
585 
586     constructor() {
587         additionalBots[0x33fDb79aFB4456B604f376A45A546e7ae700e880] = true;
588         additionalBots[0x7fb85Bab66C4a14eb4c048a34CEf0AB16747778d] = true;
589         additionalBots[0x446aD06C447b26D129C131E893f48b3a518a63c7] = true;
590     }
591 
592     modifier isApprovedBot(address _botAddr) {
593         require(
594             IBotRegistry(BOT_REGISTRY_ADDRESS).botList(_botAddr) || additionalBots[_botAddr],
595             "Not auth bot"
596         );
597 
598         _;
599     }
600 
601     modifier isRefillCaller {
602         require(msg.sender == refillCaller, "Wrong refill caller");
603         _;
604     }
605 
606     function refill(uint256 _ethAmount, address _botAddress)
607         public
608         isRefillCaller
609         isApprovedBot(_botAddress)
610     {
611         // check if we have enough weth to send
612         uint256 wethBalance = IERC20(TokenUtils.WETH_ADDR).balanceOf(feeAddr);
613 
614         if (wethBalance >= _ethAmount) {
615             IERC20(TokenUtils.WETH_ADDR).transferFrom(feeAddr, address(this), _ethAmount);
616 
617             TokenUtils.withdrawWeth(_ethAmount);
618             payable(_botAddress).transfer(_ethAmount);
619         } else {
620             address[] memory path = new address[](2);
621             path[0] = DAI_ADDR;
622             path[1] = TokenUtils.WETH_ADDR;
623 
624             // get how much dai we need to convert
625             uint256 daiAmount = getEth2Dai(_ethAmount);
626 
627             IERC20(DAI_ADDR).transferFrom(feeAddr, address(this), daiAmount);
628             DAI_ADDR.approveToken(address(router), daiAmount);
629 
630             // swap and transfer directly to botAddress
631             router.swapExactTokensForETH(daiAmount, 1, path, _botAddress, block.timestamp + 1);
632         }
633     }
634 
635     function refillMany(uint256[] memory _ethAmounts, address[] memory _botAddresses) public {
636         for(uint i = 0; i < _botAddresses.length; ++i) {
637             refill(_ethAmounts[i], _botAddresses[i]);
638         }
639     }
640 
641     /// @dev Returns Dai amount, given eth amount based on uniV2 pool price
642     function getEth2Dai(uint256 _ethAmount) internal view returns (uint256 daiAmount) {
643         address[] memory path = new address[](2);
644         path[0] = TokenUtils.WETH_ADDR;
645         path[1] = DAI_ADDR;
646 
647         daiAmount = router.getAmountsOut(_ethAmount, path)[1];
648     }
649 
650     function setRefillCaller(address _newBot) public onlyOwner {
651         refillCaller = _newBot;
652     }
653 
654     function setFeeAddr(address _newFeeAddr) public onlyOwner {
655         feeAddr = _newFeeAddr;
656     }
657 
658     function setAdditionalBot(address _botAddr, bool _approved) public onlyOwner {
659         additionalBots[_botAddr] = _approved;
660     }
661 
662     receive() external payable {}
663 }