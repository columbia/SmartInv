1 pragma solidity ^0.5.0;
2 
3 interface IERC20 {
4     function totalSupply() external view returns (uint256);
5     function balanceOf(address account) external view returns (uint256);
6     function transfer(address recipient, uint256 amount) external returns (bool);
7     function allowance(address owner, address spender) external view returns (uint256);
8     function approve(address spender, uint256 amount) external returns (bool);
9     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
10     event Transfer(address indexed from, address indexed to, uint256 value);
11     event Approval(address indexed owner, address indexed spender, uint256 value);
12 }
13 
14 contract Context {
15     constructor () internal { }
16     // solhint-disable-previous-line no-empty-blocks
17 
18     function _msgSender() internal view returns (address payable) {
19         return msg.sender;
20     }
21 
22     function _msgData() internal view returns (bytes memory) {
23         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
24         return msg.data;
25     }
26 }
27 
28 contract ReentrancyGuard {
29     uint256 private _guardCounter;
30 
31     constructor () internal {
32         _guardCounter = 1;
33     }
34 
35     modifier nonReentrant() {
36         _guardCounter += 1;
37         uint256 localCounter = _guardCounter;
38         _;
39         require(localCounter == _guardCounter, "ReentrancyGuard: reentrant call");
40     }
41 }
42 
43 contract Ownable is Context {
44     address private _owner;
45 
46     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
47     constructor () internal {
48         _owner = _msgSender();
49         emit OwnershipTransferred(address(0), _owner);
50     }
51     function owner() public view returns (address) {
52         return _owner;
53     }
54     modifier onlyOwner() {
55         require(isOwner(), "Ownable: caller is not the owner");
56         _;
57     }
58     function isOwner() public view returns (bool) {
59         return _msgSender() == _owner;
60     }
61     function renounceOwnership() public onlyOwner {
62         emit OwnershipTransferred(_owner, address(0));
63         _owner = address(0);
64     }
65     function transferOwnership(address newOwner) public onlyOwner {
66         _transferOwnership(newOwner);
67     }
68     function _transferOwnership(address newOwner) internal {
69         require(newOwner != address(0), "Ownable: new owner is the zero address");
70         emit OwnershipTransferred(_owner, newOwner);
71         _owner = newOwner;
72     }
73 }
74 
75 library SafeMath {
76     function add(uint256 a, uint256 b) internal pure returns (uint256) {
77         uint256 c = a + b;
78         require(c >= a, "SafeMath: addition overflow");
79 
80         return c;
81     }
82     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
83         return sub(a, b, "SafeMath: subtraction overflow");
84     }
85     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
86         require(b <= a, errorMessage);
87         uint256 c = a - b;
88 
89         return c;
90     }
91     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
92         if (a == 0) {
93             return 0;
94         }
95 
96         uint256 c = a * b;
97         require(c / a == b, "SafeMath: multiplication overflow");
98 
99         return c;
100     }
101     function div(uint256 a, uint256 b) internal pure returns (uint256) {
102         return div(a, b, "SafeMath: division by zero");
103     }
104     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
105         // Solidity only automatically asserts when dividing by 0
106         require(b > 0, errorMessage);
107         uint256 c = a / b;
108 
109         return c;
110     }
111     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
112         return mod(a, b, "SafeMath: modulo by zero");
113     }
114     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
115         require(b != 0, errorMessage);
116         return a % b;
117     }
118 }
119 
120 library Address {
121     function isContract(address account) internal view returns (bool) {
122         bytes32 codehash;
123         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
124         // solhint-disable-next-line no-inline-assembly
125         assembly { codehash := extcodehash(account) }
126         return (codehash != 0x0 && codehash != accountHash);
127     }
128     function toPayable(address account) internal pure returns (address payable) {
129         return address(uint160(account));
130     }
131     function sendValue(address payable recipient, uint256 amount) internal {
132         require(address(this).balance >= amount, "Address: insufficient balance");
133 
134         // solhint-disable-next-line avoid-call-value
135         (bool success, ) = recipient.call.value(amount)("");
136         require(success, "Address: unable to send value, recipient may have reverted");
137     }
138 }
139 
140 library SafeERC20 {
141     using SafeMath for uint256;
142     using Address for address;
143 
144     function safeTransfer(IERC20 token, address to, uint256 value) internal {
145         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
146     }
147     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
148         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
149     }
150     function safeApprove(IERC20 token, address spender, uint256 value) internal {
151         require((value == 0) || (token.allowance(address(this), spender) == 0),
152             "SafeERC20: approve from non-zero to non-zero allowance"
153         );
154         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
155     }
156     function callOptionalReturn(IERC20 token, bytes memory data) private {
157         require(address(token).isContract(), "SafeERC20: call to non-contract");
158 
159         // solhint-disable-next-line avoid-low-level-calls
160         (bool success, bytes memory returndata) = address(token).call(data);
161         require(success, "SafeERC20: low-level call failed");
162 
163         if (returndata.length > 0) { // Return data is optional
164             // solhint-disable-next-line max-line-length
165             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
166         }
167     }
168 }
169 
170 interface yERC20 {
171   function deposit(uint256 _amount) external;
172   function withdraw(uint256 _amount) external;
173   function getPricePerFullShare() external view returns (uint256);
174 }
175 
176 // Solidity Interface
177 
178 interface CurveFi {
179   function exchange(
180     int128 i,
181     int128 j,
182     uint256 dx,
183     uint256 min_dy
184   ) external;
185   function get_dx_underlying(
186     int128 i,
187     int128 j,
188     uint256 dy
189   ) external view returns (uint256);
190   function get_dy_underlying(
191     int128 i,
192     int128 j,
193     uint256 dx
194   ) external view returns (uint256);
195   function get_dx(
196     int128 i,
197     int128 j,
198     uint256 dy
199   ) external view returns (uint256);
200   function get_dy(
201     int128 i,
202     int128 j,
203     uint256 dx
204   ) external view returns (uint256);
205   function get_virtual_price() external view returns (uint256);
206 }
207 
208 interface yCurveFi {
209   function add_liquidity(
210     uint256[4] calldata amounts,
211     uint256 min_mint_amount
212   ) external;
213   function remove_liquidity(
214     uint256 _amount,
215     uint256[4] calldata amounts
216   ) external;
217   function calc_token_amount(
218     uint256[4] calldata amounts,
219     bool deposit
220   ) external view returns (uint256);
221 }
222 
223 interface sCurveFi {
224   function add_liquidity(
225     uint256[2] calldata amounts,
226     uint256 min_mint_amount
227   ) external;
228   function remove_liquidity(
229     uint256 _amount,
230     uint256[2] calldata amounts
231   ) external;
232   function calc_token_amount(
233     uint256[2] calldata amounts,
234     bool deposit
235   ) external view returns (uint256);
236 }
237 
238 contract yCurveExchange is ReentrancyGuard, Ownable {
239   using SafeERC20 for IERC20;
240   using Address for address;
241   using SafeMath for uint256;
242 
243   address public constant DAI = address(0x6B175474E89094C44Da98b954EedeAC495271d0F);
244   address public constant yDAI = address(0x16de59092dAE5CcF4A1E6439D611fd0653f0Bd01);
245   address public constant USDC = address(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48);
246   address public constant yUSDC = address(0xd6aD7a6750A7593E092a9B218d66C0A814a3436e);
247   address public constant USDT = address(0xdAC17F958D2ee523a2206206994597C13D831ec7);
248   address public constant yUSDT = address(0x83f798e925BcD4017Eb265844FDDAbb448f1707D);
249   address public constant TUSD = address(0x0000000000085d4780B73119b644AE5ecd22b376);
250   address public constant yTUSD = address(0x73a052500105205d34Daf004eAb301916DA8190f);
251   address public constant ySUSD = address(0xF61718057901F84C4eEC4339EF8f0D86D2B45600);
252   address public constant SUSD = address(0x57Ab1ec28D129707052df4dF418D58a2D46d5f51);
253   address public constant ySWAP = address(0x45F783CCE6B7FF23B2ab2D70e416cdb7D6055f51);
254   address public constant yCURVE = address(0xdF5e0e81Dff6FAF3A7e52BA697820c5e32D806A8);
255   address public constant sSWAP = address(0xeDf54bC005bc2Df0Cc6A675596e843D28b16A966);
256   address public constant sCURVE = address(0x2b645a6A426f22fB7954dC15E583e3737B8d1434);
257 
258   constructor () public {
259     approveToken();
260   }
261 
262   function approveToken() public {
263       IERC20(DAI).safeApprove(yDAI, uint(-1));
264       IERC20(yDAI).safeApprove(ySWAP, uint(-1));
265 
266       IERC20(USDC).safeApprove(yUSDC, uint(-1));
267       IERC20(yUSDC).safeApprove(ySWAP, uint(-1));
268 
269       IERC20(USDT).safeApprove(yUSDT, uint(-1));
270       IERC20(yUSDT).safeApprove(ySWAP, uint(-1));
271 
272       IERC20(TUSD).safeApprove(yTUSD, uint(-1));
273       IERC20(yTUSD).safeApprove(ySWAP, uint(-1));
274 
275       IERC20(SUSD).safeApprove(ySUSD, uint(-1));
276       IERC20(ySUSD).safeApprove(sSWAP, uint(-1));
277 
278       IERC20(yCURVE).safeApprove(sSWAP, uint(-1));
279   }
280 
281   // 0 = DAI, 1 = USDC, 2 = USDT, 3 = TUSD, 4 = SUSD
282   function exchange_underlying(int128 i, int128 j, uint256 dx, uint256 min_dy) external nonReentrant {
283     address _ui = get_address_underlying(i);
284     IERC20(_ui).safeTransferFrom(msg.sender, address(this), dx);
285     address _i = get_address(i);
286     yERC20(_i).deposit(IERC20(_ui).balanceOf(address(this)));
287 
288     _exchange(i, j);
289 
290     address _j = get_address(j);
291     yERC20(_j).withdraw(IERC20(_j).balanceOf(address(this)));
292     address _uj = get_address_underlying(j);
293     uint256 _dy = IERC20(_uj).balanceOf(address(this));
294     require(_dy >= min_dy, "slippage");
295     IERC20(_uj).safeTransfer(msg.sender, _dy);
296   }
297   function exchange(int128 i, int128 j, uint256 dx, uint256 min_dy) external nonReentrant {
298     IERC20(get_address(i)).safeTransferFrom(msg.sender, address(this), dx);
299 
300     _exchange(i, j);
301 
302     address _j = get_address(j);
303     uint256 _dy = IERC20(_j).balanceOf(address(this));
304     require(_dy >= min_dy, "slippage");
305     IERC20(_j).safeTransfer(msg.sender, _dy);
306   }
307   // 0 = yDAI, 1 = yUSDC, 2 = yUSDT, 3 = yTUSD, 4 = ySUSD
308   function _exchange(int128 i, int128 j) internal {
309     if (i == 4) {
310       CurveFi(sSWAP).exchange(0, 1, IERC20(get_address(i)).balanceOf(address(this)), 0);
311       yCurveFi(ySWAP).remove_liquidity(IERC20(yCURVE).balanceOf(address(this)), [uint256(0),0,0,0]);
312       _swap_to(j);
313     } else if (j == 4) {
314       uint256[4] memory amounts;
315       amounts[uint256(i)] = IERC20(get_address(i)).balanceOf(address(this));
316       yCurveFi(ySWAP).add_liquidity(amounts, 0);
317       CurveFi(sSWAP).exchange(1, 0, IERC20(yCURVE).balanceOf(address(this)), 0);
318     } else {
319       CurveFi(ySWAP).exchange(i, j, IERC20(get_address(i)).balanceOf(address(this)), 0);
320     }
321   }
322   function _swap_to(int128 j) internal {
323     if (j == 0) {
324       _swap_to_dai();
325     } else if (j == 1) {
326       _swap_to_usdc();
327     } else if (j == 2) {
328       _swap_to_usdt();
329     } else if (j == 3) {
330       _swap_to_tusd();
331     }
332   }
333   function _swap_to_dai() internal {
334     uint256 _yusdc = IERC20(yUSDC).balanceOf(address(this));
335     uint256 _yusdt = IERC20(yUSDT).balanceOf(address(this));
336     uint256 _ytusd = IERC20(yTUSD).balanceOf(address(this));
337 
338     if (_yusdc > 0) {
339       CurveFi(ySWAP).exchange(1, 0, _yusdc, 0);
340     }
341     if (_yusdt > 0) {
342       CurveFi(ySWAP).exchange(2, 0, _yusdt, 0);
343     }
344     if (_ytusd > 0) {
345       CurveFi(ySWAP).exchange(3, 0, _ytusd, 0);
346     }
347   }
348   function _swap_to_usdc() internal {
349     uint256 _ydai = IERC20(yDAI).balanceOf(address(this));
350     uint256 _yusdt = IERC20(yUSDT).balanceOf(address(this));
351     uint256 _ytusd = IERC20(yTUSD).balanceOf(address(this));
352 
353     if (_ydai > 0) {
354       CurveFi(ySWAP).exchange(0, 1, _ydai, 0);
355     }
356     if (_yusdt > 0) {
357       CurveFi(ySWAP).exchange(2, 1, _yusdt, 0);
358     }
359     if (_ytusd > 0) {
360       CurveFi(ySWAP).exchange(3, 1, _ytusd, 0);
361     }
362   }
363   function _swap_to_usdt() internal {
364     uint256 _ydai = IERC20(yDAI).balanceOf(address(this));
365     uint256 _yusdc = IERC20(yUSDC).balanceOf(address(this));
366     uint256 _ytusd = IERC20(yTUSD).balanceOf(address(this));
367 
368     if (_ydai > 0) {
369       CurveFi(ySWAP).exchange(0, 2, _ydai, 0);
370     }
371     if (_yusdc > 0) {
372       CurveFi(ySWAP).exchange(1, 2, _yusdc, 0);
373     }
374     if (_ytusd > 0) {
375       CurveFi(ySWAP).exchange(3, 2, _ytusd, 0);
376     }
377   }
378   function _swap_to_tusd() internal {
379     uint256 _ydai = IERC20(yDAI).balanceOf(address(this));
380     uint256 _yusdc = IERC20(yUSDC).balanceOf(address(this));
381     uint256 _yusdt = IERC20(yUSDT).balanceOf(address(this));
382 
383     if (_ydai > 0) {
384       CurveFi(ySWAP).exchange(0, 3, _ydai, 0);
385     }
386     if (_yusdc > 0) {
387       CurveFi(ySWAP).exchange(1, 3, _yusdc, 0);
388     }
389     if (_yusdt > 0) {
390       CurveFi(ySWAP).exchange(2, 3, _yusdt, 0);
391     }
392   }
393 
394   function get_address_underlying(int128 index) public pure returns (address) {
395     if (index == 0) {
396       return DAI;
397     } else if (index == 1) {
398       return USDC;
399     } else if (index == 2) {
400       return USDT;
401     } else if (index == 3) {
402       return TUSD;
403     } else if (index == 4) {
404       return SUSD;
405     }
406   }
407   function get_address(int128 index) public pure returns (address) {
408     if (index == 0) {
409       return yDAI;
410     } else if (index == 1) {
411       return yUSDC;
412     } else if (index == 2) {
413       return yUSDT;
414     } else if (index == 3) {
415       return yTUSD;
416     } else if (index == 4) {
417       return ySUSD;
418     }
419   }
420   function add_liquidity_underlying(uint256[5] calldata amounts, uint256 min_mint_amount) external nonReentrant {
421     uint256[5] memory _amounts;
422     if (amounts[0] > 0) {
423       IERC20(DAI).safeTransferFrom(msg.sender, address(this), amounts[0]);
424       yERC20(yDAI).deposit(IERC20(DAI).balanceOf(address(this)));
425       _amounts[0] = IERC20(yDAI).balanceOf(address(this));
426     }
427     if (amounts[1] > 0) {
428       IERC20(USDC).safeTransferFrom(msg.sender, address(this), amounts[1]);
429       yERC20(yUSDC).deposit(IERC20(USDC).balanceOf(address(this)));
430       _amounts[1] = IERC20(yUSDC).balanceOf(address(this));
431     }
432     if (amounts[2] > 0) {
433       IERC20(USDT).safeTransferFrom(msg.sender, address(this), amounts[2]);
434       yERC20(yUSDT).deposit(IERC20(USDT).balanceOf(address(this)));
435       _amounts[2] = IERC20(yUSDT).balanceOf(address(this));
436     }
437     if (amounts[3] > 0) {
438       IERC20(TUSD).safeTransferFrom(msg.sender, address(this), amounts[3]);
439       yERC20(yTUSD).deposit(IERC20(TUSD).balanceOf(address(this)));
440       _amounts[3] = IERC20(yTUSD).balanceOf(address(this));
441     }
442     if (amounts[4] > 0) {
443       IERC20(SUSD).safeTransferFrom(msg.sender, address(this), amounts[4]);
444       yERC20(ySUSD).deposit(IERC20(SUSD).balanceOf(address(this)));
445       _amounts[4] = IERC20(ySUSD).balanceOf(address(this));
446     }
447     _add_liquidity(_amounts, min_mint_amount);
448     IERC20(sCURVE).safeTransfer(msg.sender, IERC20(sCURVE).balanceOf(address(this)));
449   }
450   function _add_liquidity(uint256[5] memory amounts, uint256 min_mint_amount) internal {
451     uint256[4] memory _y;
452     _y[0] = amounts[0];
453     _y[1] = amounts[1];
454     _y[2] = amounts[2];
455     _y[3] = amounts[3];
456     uint256[2] memory _s;
457     _s[0] = amounts[4];
458 
459     yCurveFi(ySWAP).add_liquidity(_y, 0);
460     _s[1] = IERC20(yCURVE).balanceOf(address(this));
461     sCurveFi(sSWAP).add_liquidity(_s, min_mint_amount);
462   }
463   function remove_liquidity_underlying(uint256 _amount, uint256[5] calldata min_amounts) external nonReentrant {
464     IERC20(sCURVE).safeTransferFrom(msg.sender, address(this), _amount);
465     _remove_liquidity(min_amounts);
466     uint256 _ydai = IERC20(yDAI).balanceOf(address(this));
467     uint256 _yusdc = IERC20(yUSDC).balanceOf(address(this));
468     uint256 _yusdt = IERC20(yUSDT).balanceOf(address(this));
469     uint256 _ytusd = IERC20(yTUSD).balanceOf(address(this));
470     uint256 _ysusd = IERC20(ySUSD).balanceOf(address(this));
471 
472     if (_ydai > 0) {
473       yERC20(yDAI).withdraw(_ydai);
474       IERC20(DAI).safeTransfer(msg.sender, IERC20(DAI).balanceOf(address(this)));
475     }
476     if (_yusdc > 0) {
477       yERC20(yUSDC).withdraw(_yusdc);
478       IERC20(USDC).safeTransfer(msg.sender, IERC20(USDC).balanceOf(address(this)));
479     }
480     if (_yusdt > 0) {
481       yERC20(yUSDT).withdraw(_yusdt);
482       IERC20(USDT).safeTransfer(msg.sender, IERC20(USDT).balanceOf(address(this)));
483     }
484     if (_ytusd > 0) {
485       yERC20(yTUSD).withdraw(_ytusd);
486       IERC20(TUSD).safeTransfer(msg.sender, IERC20(TUSD).balanceOf(address(this)));
487     }
488     if (_ysusd > 0) {
489       yERC20(ySUSD).withdraw(_ysusd);
490       IERC20(SUSD).safeTransfer(msg.sender, IERC20(SUSD).balanceOf(address(this)));
491     }
492   }
493   function remove_liquidity_underlying_to(int128 j, uint256 _amount, uint256 _min_amount) external nonReentrant {
494     IERC20(sCURVE).safeTransferFrom(msg.sender, address(this), _amount);
495     _remove_liquidity([uint256(0),0,0,0,0]);
496     _swap_to(j);
497     yERC20(get_address(j)).withdraw(IERC20(j).balanceOf(address(this)));
498     address _uj = get_address_underlying(j);
499     uint256 _dy = IERC20(_uj).balanceOf(address(this));
500     require(_dy >= _min_amount, "slippage");
501     IERC20(_uj).safeTransfer(msg.sender, _dy);
502   }
503   function _remove_liquidity(uint256[5] memory min_amounts) internal {
504     uint256[2] memory _s;
505     _s[0] = min_amounts[4];
506     sCurveFi(sSWAP).remove_liquidity(IERC20(sCURVE).balanceOf(address(this)), _s);
507     uint256[4] memory _y;
508     _y[0] = min_amounts[0];
509     _y[1] = min_amounts[1];
510     _y[2] = min_amounts[2];
511     _y[3] = min_amounts[3];
512     yCurveFi(ySWAP).remove_liquidity(IERC20(yCURVE).balanceOf(address(this)), _y);
513   }
514 
515   function get_dy_underlying(int128 i, int128 j, uint256 dx) external view returns (uint256) {
516     if (i == 4) { // How much j (USDT) will I get, if I sell dx SUSD (i)
517       uint256 _yt = dx.mul(1e18).div(yERC20(get_address(i)).getPricePerFullShare());
518       uint256 _y = CurveFi(sSWAP).get_dy(0, 1, _yt);
519       return calc_withdraw_amount_y(_y, j);
520       //return _y.mul(1e18).div(CurveFi(ySWAP).get_virtual_price()).div(decimals[uint256(j)]);
521     } else if (j == 4) { // How much SUSD (j) will I get, if I sell dx USDT (i)
522       uint256[4] memory _amounts;
523       _amounts[uint256(i)] = dx.mul(1e18).div(yERC20(get_address(i)).getPricePerFullShare());
524       uint256 _y = yCurveFi(ySWAP).calc_token_amount(_amounts, true);
525       uint256 _fee = _y.mul(4).div(10000);
526       return CurveFi(sSWAP).get_dy_underlying(1, 0, _y.sub(_fee));
527     } else {
528       uint256 _dy = CurveFi(ySWAP).get_dy_underlying(i, j, dx);
529       return _dy.sub(_dy.mul(4).div(10000));
530     }
531   }
532 
533   function calc_withdraw_amount_y(uint256 amount, int128 j) public view returns (uint256) {
534     uint256 _ytotal = IERC20(yCURVE).totalSupply();
535 
536     uint256 _yDAI = IERC20(yDAI).balanceOf(ySWAP);
537     uint256 _yUSDC = IERC20(yUSDC).balanceOf(ySWAP);
538     uint256 _yUSDT = IERC20(yUSDT).balanceOf(ySWAP);
539     uint256 _yTUSD = IERC20(yTUSD).balanceOf(ySWAP);
540 
541     uint256[4] memory _amounts;
542     _amounts[0] = _yDAI.mul(amount).div(_ytotal);
543     _amounts[1] = _yUSDC.mul(amount).div(_ytotal);
544     _amounts[2] = _yUSDT.mul(amount).div(_ytotal);
545     _amounts[3] = _yTUSD.mul(amount).div(_ytotal);
546 
547     uint256 _base = _calc_to(_amounts, j).mul(yERC20(get_address(j)).getPricePerFullShare()).div(1e18);
548     uint256 _fee = _base.mul(4).div(10000);
549     return _base.sub(_fee);
550   }
551   function _calc_to(uint256[4] memory _amounts, int128 j) public view returns (uint256) {
552     if (j == 0) {
553       return _calc_to_dai(_amounts);
554     } else if (j == 1) {
555       return _calc_to_usdc(_amounts);
556     } else if (j == 2) {
557       return _calc_to_usdt(_amounts);
558     } else if (j == 3) {
559       return _calc_to_tusd(_amounts);
560     }
561   }
562 
563   function _calc_to_dai(uint256[4] memory _amounts) public view returns (uint256) {
564     uint256 _from_usdc = CurveFi(ySWAP).get_dy(1, 0, _amounts[1]);
565     uint256 _from_usdt = CurveFi(ySWAP).get_dy(2, 0, _amounts[2]);
566     uint256 _from_tusd = CurveFi(ySWAP).get_dy(3, 0, _amounts[3]);
567     return _amounts[0].add(_from_usdc).add(_from_usdt).add(_from_tusd);
568   }
569   function _calc_to_usdc(uint256[4] memory _amounts) public view returns (uint256) {
570     uint256 _from_dai = CurveFi(ySWAP).get_dy(0, 1, _amounts[0]);
571     uint256 _from_usdt = CurveFi(ySWAP).get_dy(2, 1, _amounts[2]);
572     uint256 _from_tusd = CurveFi(ySWAP).get_dy(3, 1, _amounts[3]);
573     return _amounts[1].add(_from_dai).add(_from_usdt).add(_from_tusd);
574   }
575   function _calc_to_usdt(uint256[4] memory _amounts) public view returns (uint256) {
576     uint256 _from_dai = CurveFi(ySWAP).get_dy(0, 2, _amounts[0]);
577     uint256 _from_usdc = CurveFi(ySWAP).get_dy(1, 2, _amounts[1]);
578     uint256 _from_tusd = CurveFi(ySWAP).get_dy(3, 2, _amounts[3]);
579     return _amounts[2].add(_from_dai).add(_from_usdc).add(_from_tusd);
580   }
581   function _calc_to_tusd(uint256[4] memory _amounts) public view returns (uint256) {
582     uint256 _from_dai = CurveFi(ySWAP).get_dy(0, 3, _amounts[0]);
583     uint256 _from_usdc = CurveFi(ySWAP).get_dy(1, 3, _amounts[1]);
584     uint256 _from_usdt = CurveFi(ySWAP).get_dy(2, 3, _amounts[2]);
585     return _amounts[3].add(_from_dai).add(_from_usdc).add(_from_usdt);
586   }
587 
588   function calc_withdraw_amount(uint256 amount) external view returns (uint256[5] memory) {
589     uint256 _stotal = IERC20(sCURVE).totalSupply();
590     uint256 _ytotal = IERC20(yCURVE).totalSupply();
591     uint256 _yCURVE = IERC20(yCURVE).balanceOf(sSWAP);
592 
593     uint256 _yshares = _yCURVE.mul(amount).div(_stotal);
594 
595     uint256[5] memory _amounts;
596     _amounts[0] = IERC20(yDAI).balanceOf(ySWAP);
597     _amounts[1] = IERC20(yUSDC).balanceOf(ySWAP);
598     _amounts[2] = IERC20(yUSDT).balanceOf(ySWAP);
599     _amounts[3] = IERC20(yTUSD).balanceOf(ySWAP);
600     _amounts[4] = IERC20(ySUSD).balanceOf(sSWAP);
601 
602     _amounts[0] = _amounts[0].mul(_yshares).div(_ytotal);
603     _amounts[0] = _amounts[0].sub(_amounts[0].mul(4).div(10000));
604     _amounts[1] = _amounts[1].mul(_yshares).div(_ytotal);
605     _amounts[1] = _amounts[1].sub(_amounts[1].mul(4).div(10000));
606     _amounts[2] = _amounts[2].mul(_yshares).div(_ytotal);
607     _amounts[2] = _amounts[2].sub(_amounts[2].mul(4).div(10000));
608     _amounts[3] = _amounts[3].mul(_yshares).div(_ytotal);
609     _amounts[3] = _amounts[3].sub(_amounts[3].mul(4).div(10000));
610     _amounts[4] = _amounts[4].mul(amount).div(_stotal);
611     _amounts[4] = _amounts[4].sub(_amounts[4].mul(4).div(10000));
612 
613     return _amounts;
614   }
615 
616   function calc_deposit_amount(uint256[5] calldata amounts) external view returns (uint256) {
617     uint256[4] memory _y;
618     _y[0] = amounts[0].mul(1e18).div(yERC20(yDAI).getPricePerFullShare());
619     _y[1] = amounts[1].mul(1e18).div(yERC20(yUSDC).getPricePerFullShare());
620     _y[2] = amounts[2].mul(1e18).div(yERC20(yUSDT).getPricePerFullShare());
621     _y[3] = amounts[3].mul(1e18).div(yERC20(yTUSD).getPricePerFullShare());
622     uint256 _y_output = yCurveFi(ySWAP).calc_token_amount(_y, true);
623     uint256[2] memory _s;
624     _s[0] = amounts[4].mul(1e18).div(yERC20(ySUSD).getPricePerFullShare());
625     _s[1] = _y_output.mul(1e18).div(CurveFi(ySWAP).get_virtual_price());
626     uint256 _base = sCurveFi(sSWAP).calc_token_amount(_s, true);
627     uint256 _fee = _base.mul(4).div(10000);
628     return _base.sub(_fee);
629   }
630 
631   // incase of half-way error
632   function inCaseTokenGetsStuck(IERC20 _TokenAddress) onlyOwner public {
633       uint qty = _TokenAddress.balanceOf(address(this));
634       _TokenAddress.safeTransfer(msg.sender, qty);
635   }
636 }