1 //SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.8.20;
4 
5 interface IDexRouter {
6     function factory() external pure returns (address);
7     function WETH() external pure returns (address);
8     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
9     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
10     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
11     function swapExactETHForTokensSupportingFeeOnTransferTokens(
12         uint amountOutMin,
13         address[] calldata path,
14         address to,
15         uint deadline
16     ) external payable;
17 }
18 
19 library SafeMath {
20     function add(uint256 a, uint256 b) internal pure returns (uint256) {
21         uint256 c = a + b;
22         require(c >= a, 'SafeMath: addition overflow');
23 
24         return c;
25     }
26 
27     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
28         return sub(a, b, 'SafeMath: subtraction overflow');
29     }
30 
31     function sub(
32         uint256 a,
33         uint256 b,
34         string memory errorMessage
35     ) internal pure returns (uint256) {
36         require(b <= a, errorMessage);
37         uint256 c = a - b;
38 
39         return c;
40     }
41 
42     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
43         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
44         // benefit is lost if 'b' is also tested.
45         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
46         if (a == 0) {
47             return 0;
48         }
49 
50         uint256 c = a * b;
51         require(c / a == b, 'SafeMath: multiplication overflow');
52 
53         return c;
54     }
55 
56     function div(uint256 a, uint256 b) internal pure returns (uint256) {
57         return div(a, b, 'SafeMath: division by zero');
58     }
59 
60     function div(
61         uint256 a,
62         uint256 b,
63         string memory errorMessage
64     ) internal pure returns (uint256) {
65         require(b > 0, errorMessage);
66         uint256 c = a / b;
67         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
68 
69         return c;
70     }
71 
72     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
73         return mod(a, b, 'SafeMath: modulo by zero');
74     }
75 
76     function mod(
77         uint256 a,
78         uint256 b,
79         string memory errorMessage
80     ) internal pure returns (uint256) {
81         require(b != 0, errorMessage);
82         return a % b;
83     }
84 
85     function min(uint256 x, uint256 y) internal pure returns (uint256 z) {
86         z = x < y ? x : y;
87     }
88 
89     function sqrt(uint256 y) internal pure returns (uint256 z) {
90         if (y > 3) {
91             z = y;
92             uint256 x = y / 2 + 1;
93             while (x < z) {
94                 z = x;
95                 x = (y / x + x) / 2;
96             }
97         } else if (y != 0) {
98             z = 1;
99         }
100     }
101 }
102 
103 library SafeMathInt {
104     int256 private constant MIN_INT256 = int256(1) << 255;
105     int256 private constant MAX_INT256 = ~(int256(1) << 255);
106 
107     /**
108      * @dev Multiplies two int256 variables and fails on overflow.
109      */
110     function mul(int256 a, int256 b) internal pure returns (int256) {
111         int256 c = a * b;
112 
113         // Detect overflow when multiplying MIN_INT256 with -1
114         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
115         require((b == 0) || (c / b == a));
116         return c;
117     }
118 
119     /**
120      * @dev Division of two int256 variables and fails on overflow.
121      */
122     function div(int256 a, int256 b) internal pure returns (int256) {
123         // Prevent overflow when dividing MIN_INT256 by -1
124         require(b != -1 || a != MIN_INT256);
125 
126         // Solidity already throws when dividing by 0.
127         return a / b;
128     }
129 
130     /**
131      * @dev Subtracts two int256 variables and fails on overflow.
132      */
133     function sub(int256 a, int256 b) internal pure returns (int256) {
134         int256 c = a - b;
135         require((b >= 0 && c <= a) || (b < 0 && c > a));
136         return c;
137     }
138 
139     /**
140      * @dev Adds two int256 variables and fails on overflow.
141      */
142     function add(int256 a, int256 b) internal pure returns (int256) {
143         int256 c = a + b;
144         require((b >= 0 && c >= a) || (b < 0 && c < a));
145         return c;
146     }
147 
148     /**
149      * @dev Converts to absolute value, and fails on overflow.
150      */
151     function abs(int256 a) internal pure returns (int256) {
152         require(a != MIN_INT256);
153         return a < 0 ? -a : a;
154     }
155 
156 
157     function toUint256Safe(int256 a) internal pure returns (uint256) {
158         require(a >= 0);
159         return uint256(a);
160     }
161 }
162 
163 library SafeMathUint {
164   function toInt256Safe(uint256 a) internal pure returns (int256) {
165     int256 b = int256(a);
166     require(b >= 0);
167     return b;
168   }
169 }
170 
171 interface IERC20 {
172     function totalSupply() external view returns (uint256);
173     function balanceOf(address account) external view returns (uint256);
174     function transfer(address recipient, uint256 amount) external returns (bool);
175     function allowance(address owner, address spender) external view returns (uint256);
176     function approve(address spender, uint256 amount) external returns (bool);
177     function transferFrom(
178         address sender,
179         address recipient,
180         uint256 amount
181     ) external returns (bool);
182     event Transfer(address indexed from, address indexed to, uint256 value);
183     event Approval(address indexed owner, address indexed spender, uint256 value);
184 }
185 
186 interface DividendPayingContractOptionalInterface {
187   function withdrawableDividendOf(address _owner) external view returns(uint256);
188   function withdrawnDividendOf(address _owner) external view returns(uint256);
189   function accumulativeDividendOf(address _owner) external view returns(uint256);
190 }
191 
192 interface DividendPayingContractInterface {
193   function dividendOf(address _owner) external view returns(uint256);
194   function distributeDividends() external payable;
195   function withdrawDividend() external;
196   event DividendsDistributed(
197     address indexed from,
198     uint256 weiAmount
199   );
200   event DividendWithdrawn(
201     address indexed to,
202     uint256 weiAmount
203   );
204 }
205 
206 contract DividendPayingContract is DividendPayingContractInterface, DividendPayingContractOptionalInterface {
207   using SafeMath for uint256;
208   using SafeMathUint for uint256;
209   using SafeMathInt for int256;
210 
211   uint256 constant internal magnitude = 2**128;
212 
213   uint256 internal magnifiedDividendPerShare;
214                                                                          
215   mapping(address => int256) internal magnifiedDividendCorrections;
216   mapping(address => uint256) internal withdrawnDividends;
217   
218   mapping (address => uint256) public holderBalance;
219   uint256 public totalBalance;
220 
221   uint256 public totalDividendsDistributed;
222 
223   receive() external payable {
224     distributeDividends();
225   }
226 
227   function distributeDividends() public override payable {
228     if(totalBalance > 0 && msg.value > 0){
229         magnifiedDividendPerShare = magnifiedDividendPerShare.add(
230             (msg.value).mul(magnitude) / totalBalance
231         );
232         emit DividendsDistributed(msg.sender, msg.value);
233 
234         totalDividendsDistributed = totalDividendsDistributed.add(msg.value);
235     }
236   }
237 
238   function withdrawDividend() external virtual override {
239     _withdrawDividendOfUser(payable(msg.sender));
240   }
241 
242   function _withdrawDividendOfUser(address payable user) internal returns (uint256) {
243     uint256 _withdrawableDividend = withdrawableDividendOf(user);
244     if (_withdrawableDividend > 0) {
245       withdrawnDividends[user] = withdrawnDividends[user].add(_withdrawableDividend);
246 
247       emit DividendWithdrawn(user, _withdrawableDividend);
248       (bool success,) = user.call{value: _withdrawableDividend}("");
249 
250       if(!success) {
251         withdrawnDividends[user] = withdrawnDividends[user].sub(_withdrawableDividend);
252         return 0;
253       }
254 
255       return _withdrawableDividend;
256     }
257 
258     return 0;
259   }
260 
261   function dividendOf(address _owner) external view override returns(uint256) {
262     return withdrawableDividendOf(_owner);
263   }
264 
265   function withdrawableDividendOf(address _owner) public view override returns(uint256) {
266     return accumulativeDividendOf(_owner).sub(withdrawnDividends[_owner]);
267   }
268 
269   function withdrawnDividendOf(address _owner) external view override returns(uint256) {
270     return withdrawnDividends[_owner];
271   }
272 
273   function accumulativeDividendOf(address _owner) public view override returns(uint256) {
274     return magnifiedDividendPerShare.mul(holderBalance[_owner]).toInt256Safe()
275       .add(magnifiedDividendCorrections[_owner]).toUint256Safe() / magnitude;
276   }
277 
278   function _increase(address account, uint256 value) internal {
279     magnifiedDividendCorrections[account] = magnifiedDividendCorrections[account]
280       .sub( (magnifiedDividendPerShare.mul(value)).toInt256Safe() );
281   }
282 
283   function _reduce(address account, uint256 value) internal {
284     magnifiedDividendCorrections[account] = magnifiedDividendCorrections[account]
285       .add( (magnifiedDividendPerShare.mul(value)).toInt256Safe() );
286   }
287 
288   function _setBalance(address account, uint256 newBalance) internal {
289     uint256 currentBalance = holderBalance[account];
290     holderBalance[account] = newBalance;
291     if(newBalance > currentBalance) {
292       uint256 increaseAmount = newBalance.sub(currentBalance);
293       _increase(account, increaseAmount);
294       totalBalance += increaseAmount;
295     } else if(newBalance < currentBalance) {
296       uint256 reduceAmount = currentBalance.sub(newBalance);
297       _reduce(account, reduceAmount);
298       totalBalance -= reduceAmount;
299     }
300   }
301 }
302 
303 
304 contract DividendTracker is DividendPayingContract {
305 
306     event Claim(address indexed account, uint256 amount, bool indexed automatic);
307 
308     constructor() {}
309 
310     function getAccount(address _account)
311         public view returns (
312             address account,
313             uint256 withdrawableDividends,
314             uint256 totalDividends,
315             uint256 balance) {
316         account = _account;
317 
318         withdrawableDividends = withdrawableDividendOf(account);
319         totalDividends = accumulativeDividendOf(account);
320 
321         balance = holderBalance[account];
322     }
323     function setBalance(address payable account, uint256 newBalance) internal {
324 
325         _setBalance(account, newBalance);
326 
327     	processAccount(account, true);
328     }
329     
330     function processAccount(address payable account, bool automatic) internal returns (bool) {
331         uint256 amount = _withdrawDividendOfUser(account);
332 
333     	if(amount > 0) {
334             emit Claim(account, amount, automatic);
335     		return true;
336     	}
337 
338     	return false;
339     }
340 
341     function getTotalDividendsDistributed() external view returns (uint256) {
342         return totalDividendsDistributed;
343     }
344 
345 	function dividendTokenBalanceOf(address account) public view returns (uint256) {
346 		return holderBalance[account];
347 	}
348 
349     function getNumberOfDividends() external view returns(uint256) {
350         return totalBalance;
351     }
352 }
353 
354 abstract contract ReentrancyGuard {
355     uint256 private constant _NOT_ENTERED = 1;
356     uint256 private constant _ENTERED = 2;
357 
358     uint256 private _status;
359 
360     constructor() {
361         _status = _NOT_ENTERED;
362     }
363 
364     modifier nonReentrant() {
365         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
366         _status = _ENTERED;
367         _;
368         _status = _NOT_ENTERED;
369     }
370 }
371 
372 contract GenieRevenueStaking is ReentrancyGuard, DividendTracker {
373 
374     IERC20 public immutable genieToken;
375     IDexRouter public immutable dexRouter;
376 
377     uint64 private numberOfStakers;
378 
379     event Deposit(address indexed user, uint256 amount);
380     event Withdraw(address indexed user, uint256 amount);
381 
382     constructor(address _genieToken) {
383         require(_genieToken != address(0), "cannot be 0 address");
384         genieToken = IERC20(_genieToken);
385 
386         address _v2Router;
387 
388         // @dev assumes WETH pair
389         if(block.chainid == 1){
390             _v2Router = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
391         } else if(block.chainid == 5){
392             _v2Router = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
393         } else if(block.chainid == 97){
394             _v2Router = 0xD99D1c33F9fC3444f8101754aBC46c52416550D1;
395         } else if(block.chainid == 42161){
396             _v2Router = 0x1b02dA8Cb0d097eB8D57A175b88c7D8b47997506;
397         } else {
398             revert("Chain not configured");
399         }
400 
401         dexRouter = IDexRouter(_v2Router);
402     }
403 
404     // Stake primary tokens
405     function deposit(uint256 _amount) external nonReentrant {
406         require(_amount > 0, "Zero Amount");
407         uint256 userAmount = holderBalance[msg.sender];
408 
409         uint256 amountTransferred = 0;
410 
411         if(userAmount == 0){
412             numberOfStakers++;
413         }
414 
415         uint256 initialBalance = genieToken.balanceOf(address(this));
416         genieToken.transferFrom(address(msg.sender), address(this), _amount);
417         amountTransferred = genieToken.balanceOf(address(this)) - initialBalance;
418     
419         setBalance(payable(msg.sender), userAmount + amountTransferred);
420 
421         emit Deposit(msg.sender, _amount);
422     }
423 
424     // Withdraw primary tokens
425 
426     function withdraw(uint256 _amount) external nonReentrant {
427         require(_amount > 0, "Zero Amount");
428         uint256 userAmount = holderBalance[msg.sender];
429         require(_amount <= userAmount, "Not enough tokens");
430 
431         if(userAmount - _amount == 0 && numberOfStakers > 0){
432             numberOfStakers--;
433         }
434 
435         genieToken.transfer(address(msg.sender), _amount);
436 
437         setBalance(payable(msg.sender), userAmount - _amount);
438 
439         emit Withdraw(msg.sender, _amount);
440     }
441 
442     function withdrawAll() public nonReentrant {
443         uint256 userAmount = holderBalance[msg.sender];
444         require(userAmount > 0, "Not a holder");
445 
446         numberOfStakers--;
447         genieToken.transfer(address(msg.sender), userAmount);
448 
449         setBalance(payable(msg.sender), 0);
450 
451         emit Withdraw(msg.sender, userAmount);
452     }
453 
454     function claim() external nonReentrant {
455         processAccount(payable(msg.sender), false);
456     }
457 
458     function getNumberOfStakers() external view returns(uint256) {
459         return numberOfStakers;
460     }
461 
462     function compound(uint256 minOutput) external nonReentrant {
463         uint256 userAmount = holderBalance[msg.sender];
464         uint256 amountEthForCompound = _withdrawDividendOfUserForCompound(payable(msg.sender));
465         if(amountEthForCompound > 0){
466             uint256 initialBalance = genieToken.balanceOf(address(this));
467             buyBackTokens(amountEthForCompound, minOutput);
468             uint256 amountTransferred = genieToken.balanceOf(address(this)) - initialBalance;
469             setBalance(payable(msg.sender), userAmount + amountTransferred);
470         } else {
471             revert("No rewards");
472         }
473     }
474 
475     function _withdrawDividendOfUserForCompound(address payable user) internal returns (uint256 _withdrawableDividend) {
476         _withdrawableDividend = withdrawableDividendOf(user);
477         if (_withdrawableDividend > 0) {
478             withdrawnDividends[user] = withdrawnDividends[user] + _withdrawableDividend;
479 
480             emit DividendWithdrawn(user, _withdrawableDividend);
481         }
482     }
483 
484     function buyBackTokens(uint256 ethAmountInWei, uint256 minOut) internal {
485         // generate the uniswap pair path of weth -> eth
486         address[] memory path = new address[](2);
487         path[0] = dexRouter.WETH();
488         path[1] = address(genieToken);
489 
490         // make the swap
491         dexRouter.swapExactETHForTokensSupportingFeeOnTransferTokens{value: ethAmountInWei}(
492             minOut,
493             path,
494             address(this),
495             block.timestamp
496         );
497     }
498 
499     // helper views
500 
501     function getExpectedCompoundOutputByEthAmount(uint256 rewardAmount) external view returns(uint256) {
502         address[] memory path = new address[](2);
503         path[0] = dexRouter.WETH();
504         path[1] = address(genieToken);
505         uint256[] memory amounts = dexRouter.getAmountsOut(rewardAmount, path);
506         return amounts[1];
507     }
508 
509     function getExpectedCompoundOutputByWallet(address wallet) external view returns(uint256) {
510         uint256 rewardAmount = withdrawableDividendOf(wallet);
511         address[] memory path = new address[](2);
512         path[0] = dexRouter.WETH();
513         path[1] = address(genieToken);
514         uint256[] memory amounts = dexRouter.getAmountsOut(rewardAmount, path);
515         return amounts[1];
516     }
517  }