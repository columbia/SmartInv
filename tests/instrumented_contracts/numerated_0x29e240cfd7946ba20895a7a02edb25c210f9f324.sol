1 /**
2  *Submitted for verification at Etherscan.io on 2020-08-04
3 */
4 
5 pragma solidity ^0.5.16;
6 
7 interface IERC20 {
8     function totalSupply() external view returns (uint256);
9     function balanceOf(address account) external view returns (uint256);
10     function transfer(address recipient, uint256 amount) external returns (bool);
11     function allowance(address owner, address spender) external view returns (uint256);
12     function approve(address spender, uint256 amount) external returns (bool);
13     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
14     event Transfer(address indexed from, address indexed to, uint256 value);
15     event Approval(address indexed owner, address indexed spender, uint256 value);
16 }
17 
18 contract Context {
19     constructor () internal { }
20     // solhint-disable-previous-line no-empty-blocks
21 
22     function _msgSender() internal view returns (address payable) {
23         return msg.sender;
24     }
25 
26     function _msgData() internal view returns (bytes memory) {
27         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
28         return msg.data;
29     }
30 }
31 
32 contract Ownable is Context {
33     address private _owner;
34 
35     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
36     constructor () internal {
37         _owner = _msgSender();
38         emit OwnershipTransferred(address(0), _owner);
39     }
40     function owner() public view returns (address) {
41         return _owner;
42     }
43     modifier onlyOwner() {
44         require(isOwner(), "Ownable: caller is not the owner");
45         _;
46     }
47     function isOwner() public view returns (bool) {
48         return _msgSender() == _owner;
49     }
50     function renounceOwnership() public onlyOwner {
51         emit OwnershipTransferred(_owner, address(0));
52         _owner = address(0);
53     }
54     function transferOwnership(address newOwner) public onlyOwner {
55         _transferOwnership(newOwner);
56     }
57     function _transferOwnership(address newOwner) internal {
58         require(newOwner != address(0), "Ownable: new owner is the zero address");
59         emit OwnershipTransferred(_owner, newOwner);
60         _owner = newOwner;
61     }
62 }
63 
64 contract ERC20 is Context, IERC20 {
65     using SafeMath for uint256;
66 
67     mapping (address => uint256) private _balances;
68 
69     mapping (address => mapping (address => uint256)) private _allowances;
70 
71     uint256 private _totalSupply;
72     function totalSupply() public view returns (uint256) {
73         return _totalSupply;
74     }
75     function balanceOf(address account) public view returns (uint256) {
76         return _balances[account];
77     }
78     function transfer(address recipient, uint256 amount) public returns (bool) {
79         _transfer(_msgSender(), recipient, amount);
80         return true;
81     }
82     function allowance(address owner, address spender) public view returns (uint256) {
83         return _allowances[owner][spender];
84     }
85     function approve(address spender, uint256 amount) public returns (bool) {
86         _approve(_msgSender(), spender, amount);
87         return true;
88     }
89     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
90         _transfer(sender, recipient, amount);
91         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
92         return true;
93     }
94     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
95         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
96         return true;
97     }
98     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
99         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
100         return true;
101     }
102     function _transfer(address sender, address recipient, uint256 amount) internal {
103         require(sender != address(0), "ERC20: transfer from the zero address");
104         require(recipient != address(0), "ERC20: transfer to the zero address");
105 
106         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
107         _balances[recipient] = _balances[recipient].add(amount);
108         emit Transfer(sender, recipient, amount);
109     }
110     function _mint(address account, uint256 amount) internal {
111         require(account != address(0), "ERC20: mint to the zero address");
112 
113         _totalSupply = _totalSupply.add(amount);
114         _balances[account] = _balances[account].add(amount);
115         emit Transfer(address(0), account, amount);
116     }
117     function _burn(address account, uint256 amount) internal {
118         require(account != address(0), "ERC20: burn from the zero address");
119 
120         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
121         _totalSupply = _totalSupply.sub(amount);
122         emit Transfer(account, address(0), amount);
123     }
124     function _approve(address owner, address spender, uint256 amount) internal {
125         require(owner != address(0), "ERC20: approve from the zero address");
126         require(spender != address(0), "ERC20: approve to the zero address");
127 
128         _allowances[owner][spender] = amount;
129         emit Approval(owner, spender, amount);
130     }
131     function _burnFrom(address account, uint256 amount) internal {
132         _burn(account, amount);
133         _approve(account, _msgSender(), _allowances[account][_msgSender()].sub(amount, "ERC20: burn amount exceeds allowance"));
134     }
135 }
136 
137 contract ERC20Detailed is IERC20 {
138     string private _name;
139     string private _symbol;
140     uint8 private _decimals;
141 
142     constructor (string memory name, string memory symbol, uint8 decimals) public {
143         _name = name;
144         _symbol = symbol;
145         _decimals = decimals;
146     }
147     function name() public view returns (string memory) {
148         return _name;
149     }
150     function symbol() public view returns (string memory) {
151         return _symbol;
152     }
153     function decimals() public view returns (uint8) {
154         return _decimals;
155     }
156 }
157 
158 library SafeMath {
159     function add(uint256 a, uint256 b) internal pure returns (uint256) {
160         uint256 c = a + b;
161         require(c >= a, "SafeMath: addition overflow");
162 
163         return c;
164     }
165     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
166         return sub(a, b, "SafeMath: subtraction overflow");
167     }
168     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
169         require(b <= a, errorMessage);
170         uint256 c = a - b;
171 
172         return c;
173     }
174     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
175         if (a == 0) {
176             return 0;
177         }
178 
179         uint256 c = a * b;
180         require(c / a == b, "SafeMath: multiplication overflow");
181 
182         return c;
183     }
184     function div(uint256 a, uint256 b) internal pure returns (uint256) {
185         return div(a, b, "SafeMath: division by zero");
186     }
187     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
188         // Solidity only automatically asserts when dividing by 0
189         require(b > 0, errorMessage);
190         uint256 c = a / b;
191 
192         return c;
193     }
194     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
195         return mod(a, b, "SafeMath: modulo by zero");
196     }
197     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
198         require(b != 0, errorMessage);
199         return a % b;
200     }
201 }
202 
203 library Address {
204     function isContract(address account) internal view returns (bool) {
205         bytes32 codehash;
206         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
207         // solhint-disable-next-line no-inline-assembly
208         assembly { codehash := extcodehash(account) }
209         return (codehash != 0x0 && codehash != accountHash);
210     }
211     function toPayable(address account) internal pure returns (address payable) {
212         return address(uint160(account));
213     }
214     function sendValue(address payable recipient, uint256 amount) internal {
215         require(address(this).balance >= amount, "Address: insufficient balance");
216 
217         // solhint-disable-next-line avoid-call-value
218         (bool success, ) = recipient.call.value(amount)("");
219         require(success, "Address: unable to send value, recipient may have reverted");
220     }
221 }
222 
223 library SafeERC20 {
224     using SafeMath for uint256;
225     using Address for address;
226 
227     function safeTransfer(IERC20 token, address to, uint256 value) internal {
228         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
229     }
230 
231     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
232         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
233     }
234 
235     function safeApprove(IERC20 token, address spender, uint256 value) internal {
236         require((value == 0) || (token.allowance(address(this), spender) == 0),
237             "SafeERC20: approve from non-zero to non-zero allowance"
238         );
239         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
240     }
241 
242     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
243         uint256 newAllowance = token.allowance(address(this), spender).add(value);
244         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
245     }
246 
247     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
248         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
249         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
250     }
251     function callOptionalReturn(IERC20 token, bytes memory data) private {
252         require(address(token).isContract(), "SafeERC20: call to non-contract");
253 
254         // solhint-disable-next-line avoid-low-level-calls
255         (bool success, bytes memory returndata) = address(token).call(data);
256         require(success, "SafeERC20: low-level call failed");
257 
258         if (returndata.length > 0) { // Return data is optional
259             // solhint-disable-next-line max-line-length
260             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
261         }
262     }
263 }
264 
265 interface Controller {
266     function withdraw(address, uint) external;
267     function balanceOf(address) external view returns (uint);
268     function earn(address, uint) external;
269     function want(address) external view returns (address);
270 }
271 
272 interface Aave {
273     function borrow(address _reserve, uint _amount, uint _interestRateModel, uint16 _referralCode) external;
274     function setUserUseReserveAsCollateral(address _reserve, bool _useAsCollateral) external;
275     function repay(address _reserve, uint _amount, address payable _onBehalfOf) external payable;
276     function getUserAccountData(address _user)
277         external
278         view
279         returns (
280             uint totalLiquidityETH,
281             uint totalCollateralETH,
282             uint totalBorrowsETH,
283             uint totalFeesETH,
284             uint availableBorrowsETH,
285             uint currentLiquidationThreshold,
286             uint ltv,
287             uint healthFactor
288         );
289     function getUserReserveData(address _reserve, address _user)
290         external
291         view
292         returns (
293             uint currentATokenBalance,
294             uint currentBorrowBalance,
295             uint principalBorrowBalance,
296             uint borrowRateMode,
297             uint borrowRate,
298             uint liquidityRate,
299             uint originationFee,
300             uint variableBorrowIndex,
301             uint lastUpdateTimestamp,
302             bool usageAsCollateralEnabled
303         );
304 }
305 
306 interface AaveToken {
307     function underlyingAssetAddress() external view returns (address);
308 }
309 
310 interface Oracle {
311     function getAssetPrice(address reserve) external view returns (uint);
312     function latestAnswer() external view returns (uint);
313 }
314 
315 interface LendingPoolAddressesProvider {
316     function getLendingPool() external view returns (address);
317     function getLendingPoolCore() external view returns (address);
318     function getPriceOracle() external view returns (address);
319 }
320 
321 contract yDelegatedVault is ERC20, ERC20Detailed {
322     using SafeERC20 for IERC20;
323     using Address for address;
324     using SafeMath for uint256;
325     
326     IERC20 public token;
327     
328     address public governance;
329     address public controller;
330     uint public insurance;
331     uint public healthFactor = 4;
332     
333     uint public ltv = 65;
334     uint public max = 100;
335     
336     address public constant aave = address(0x24a42fD28C976A61Df5D00D0599C34c4f90748c8);
337     
338     constructor (address _token, address _controller) public ERC20Detailed(
339         string(abi.encodePacked("yearn ", ERC20Detailed(_token).name())),
340         string(abi.encodePacked("y", ERC20Detailed(_token).symbol())),
341         ERC20Detailed(_token).decimals()
342     ) {
343         token = IERC20(_token);
344         governance = msg.sender;
345         controller = _controller;
346     }
347     
348     function debt() public view returns (uint) {
349         address _reserve = Controller(controller).want(address(this));
350         (,uint currentBorrowBalance,,,,,,,,) = Aave(getAave()).getUserReserveData(_reserve, address(this));
351         return currentBorrowBalance;
352     }
353     
354     function credit() public view returns (uint) {
355         return Controller(controller).balanceOf(address(this));
356     }
357     
358     // % of tokens locked and cannot be withdrawn per user
359     // this is impermanent locked, unless the debt out accrues the strategy
360     function locked() public view returns (uint) {
361         return credit().mul(1e18).div(debt());
362     }
363     
364     function debtShare(address _lp) public view returns (uint) {
365         return debt().mul(balanceOf(_lp)).mul(totalSupply());
366     }
367     
368     function getAave() public view returns (address) {
369         return LendingPoolAddressesProvider(aave).getLendingPool();
370     }
371     
372     function getAaveCore() public view returns (address) {
373         return LendingPoolAddressesProvider(aave).getLendingPoolCore();
374     }
375     
376     function setHealthFactor(uint _hf) external {
377         require(msg.sender == governance, "!governance");
378         healthFactor = _hf;
379     }
380     
381     function activate() public {
382         Aave(getAave()).setUserUseReserveAsCollateral(underlying(), true);
383     }
384     
385     function repay(address reserve, uint amount) public  {
386         // Required for certain stable coins (USDT for example)
387         IERC20(reserve).approve(address(getAaveCore()), 0);
388         IERC20(reserve).approve(address(getAaveCore()), amount);
389         Aave(getAave()).repay(reserve, amount, address(uint160(address(this))));
390     }
391     
392     function repayAll() public {
393         address _reserve = reserve();
394         uint _amount = IERC20(_reserve).balanceOf(address(this));
395         repay(_reserve, _amount);
396     }
397     
398     // Used to swap any borrowed reserve over the debt limit to liquidate to 'token'
399     function harvest(address reserve, uint amount) external {
400         require(msg.sender == controller, "!controller");
401         require(reserve != address(token), "token");
402         IERC20(reserve).safeTransfer(controller, amount);
403     }
404     
405     // Ignore insurance fund for balance calculations
406     function balance() public view returns (uint) {
407         return token.balanceOf(address(this)).sub(insurance);
408     }
409     
410     function setController(address _controller) external {
411         require(msg.sender == governance, "!governance");
412         controller = _controller;
413     }
414     
415     function getAaveOracle() public view returns (address) {
416         return LendingPoolAddressesProvider(aave).getPriceOracle();
417     }
418     
419     function getReservePriceETH(address reserve) public view returns (uint) {
420         return Oracle(getAaveOracle()).getAssetPrice(reserve);
421     }
422     
423     function shouldRebalance() external view returns (bool) {
424         return (over() > 0);
425     }
426     
427     function over() public view returns (uint) {
428         over(0);
429     }
430     
431     function getUnderlyingPriceETH(uint _amount) public view returns (uint) {
432         _amount = _amount.mul(getUnderlyingPrice()).div(uint(10)**ERC20Detailed(address(token)).decimals()); // Calculate the amount we are withdrawing in ETH
433         return _amount.mul(ltv).div(max).div(healthFactor);
434     }
435     
436     function over(uint _amount) public view returns (uint) {
437         address _reserve = reserve();
438         uint _eth = getUnderlyingPriceETH(_amount);
439         (uint _maxSafeETH,uint _totalBorrowsETH,) = maxSafeETH();
440         _maxSafeETH = _maxSafeETH.mul(105).div(100); // 5% buffer so we don't go into a earn/rebalance loop
441         if (_eth > _maxSafeETH) {
442             _maxSafeETH = 0;
443         } else {
444             _maxSafeETH = _maxSafeETH.sub(_eth); // Add the ETH we are withdrawing
445         }
446         if (_maxSafeETH < _totalBorrowsETH) {
447             uint _over = _totalBorrowsETH.mul(_totalBorrowsETH.sub(_maxSafeETH)).div(_totalBorrowsETH);
448             _over = _over.mul(uint(10)**ERC20Detailed(_reserve).decimals()).div(getReservePrice());
449             return _over;
450         } else {
451             return 0;
452         }
453     }
454     
455     function _rebalance(uint _amount) internal {
456         uint _over = over(_amount);
457         if (_over > 0) {
458             if (_over > credit()) {
459                 _over = credit();
460             }
461             if (_over > 0) {
462                 Controller(controller).withdraw(address(this), _over);
463                 repayAll();
464             }
465         }
466     }
467     
468     function rebalance() external {
469         _rebalance(0);
470     }
471     
472     function claimInsurance() external {
473         require(msg.sender == controller, "!controller");
474         token.safeTransfer(controller, insurance);
475         insurance = 0;
476     }
477     
478     function maxSafeETH() public view returns (uint maxBorrowsETH, uint totalBorrowsETH, uint availableBorrowsETH) {
479          (,,uint _totalBorrowsETH,,uint _availableBorrowsETH,,,) = Aave(getAave()).getUserAccountData(address(this));
480         uint _maxBorrowETH = (_totalBorrowsETH.add(_availableBorrowsETH));
481         return (_maxBorrowETH.div(healthFactor), _totalBorrowsETH, _availableBorrowsETH);
482     }
483     
484     function shouldBorrow() external view returns (bool) {
485         return (availableToBorrowReserve() > 0);
486     }
487     
488     function availableToBorrowETH() public view returns (uint) {
489         (uint _maxSafeETH,uint _totalBorrowsETH, uint _availableBorrowsETH) = maxSafeETH();
490         _maxSafeETH = _maxSafeETH.mul(95).div(100); // 5% buffer so we don't go into a earn/rebalance loop
491         if (_maxSafeETH > _totalBorrowsETH) {
492             return _availableBorrowsETH.mul(_maxSafeETH.sub(_totalBorrowsETH)).div(_availableBorrowsETH);
493         } else {
494             return 0;
495         }
496     }
497     
498     function availableToBorrowReserve() public view returns (uint) {
499         address _reserve = reserve();
500         uint _available = availableToBorrowETH();
501         if (_available > 0) {
502             return _available.mul(uint(10)**ERC20Detailed(_reserve).decimals()).div(getReservePrice());
503         } else {
504             return 0;
505         }
506     }
507     
508     function getReservePrice() public view returns (uint) {
509         return getReservePriceETH(reserve());
510     }
511     
512     function getUnderlyingPrice() public view returns (uint) {
513         return getReservePriceETH(underlying());
514     }
515     
516     function earn() external {
517         address _reserve = reserve();
518         uint _borrow = availableToBorrowReserve();
519         if (_borrow > 0) {
520             Aave(getAave()).borrow(_reserve, _borrow, 2, 7);
521         }
522         //rebalance here
523         uint _balance = IERC20(_reserve).balanceOf(address(this));
524         if (_balance > 0) {
525             IERC20(_reserve).safeTransfer(controller, _balance);
526             Controller(controller).earn(address(this), _balance);
527         }
528     }
529     
530     function depositAll() external {
531         deposit(token.balanceOf(msg.sender));
532     }
533     
534     function deposit(uint _amount) public {
535         uint _pool = balance();
536         token.safeTransferFrom(msg.sender, address(this), _amount);
537         
538         // 0.5% of deposits go into an insurance fund incase of negative profits to protect withdrawals
539         // At a 4 health factor, this is a -2% position
540         uint _insurance = _amount.mul(50).div(10000);
541         _amount = _amount.sub(_insurance);
542         insurance = insurance.add(_insurance);
543         
544         
545         //Controller can claim insurance to liquidate to cover interest
546         
547         uint shares = 0;
548         if (totalSupply() == 0) {
549             shares = _amount;
550         } else {
551             shares = (_amount.mul(totalSupply())).div(_pool);
552         }
553         _mint(msg.sender, shares);
554     }
555     
556     function reserve() public view returns (address) {
557         return Controller(controller).want(address(this));
558     }
559     
560     function underlying() public view returns (address) {
561         return AaveToken(address(token)).underlyingAssetAddress();
562     }
563     
564     function withdrawAll() public {
565         withdraw(balanceOf(msg.sender));
566     }
567     
568     // Calculates in impermanent lock due to debt
569     function maxWithdrawal(address account) public view returns (uint) {
570         uint _balance = balanceOf(account);
571         uint _safeWithdraw = _balance.mul(locked()).div(1e18);
572         if (_safeWithdraw > _balance) {
573             return _balance;
574         } else {
575             uint _diff = _balance.sub(_safeWithdraw);
576             return _balance.sub(_diff.mul(healthFactor)); // technically 150%, not 200%, but adding buffer
577         }
578     }
579     
580     function safeWithdraw() external {
581         withdraw(maxWithdrawal(msg.sender));
582     }
583     
584     // No rebalance implementation for lower fees and faster swaps
585     function withdraw(uint _shares) public {
586         uint r = (balance().mul(_shares)).div(totalSupply());
587         _burn(msg.sender, _shares);
588         _rebalance(r);
589         token.safeTransfer(msg.sender, r);
590     }
591     
592     function getPricePerFullShare() external view returns (uint) {
593         return balance().mul(1e18).div(totalSupply());
594     }
595 }