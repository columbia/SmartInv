1 pragma solidity ^0.6.0;
2 
3 contract WasFarmer  {
4     using SafeMath for uint256;
5     using SafeERC20 for IERC20;
6 
7    
8     struct UserData {
9         address invite;
10         uint depositTime;
11         uint256 inviteReward;
12         uint withdrawMinReward;
13         uint withdrawInviteReward;
14         uint totalDeposit;
15     }
16 
17     struct PoolData {
18         address lpToken;
19         uint256 tokenAmount;
20         uint256 startTimestamp;
21         bool isStared;
22         uint limitAmount;
23     }
24     struct DepositData {
25         uint depositAmount;
26         uint startTimestamp;
27     }
28     
29     address public uniylttAddr;
30     address public uniyethAddr;
31     address public ethCurryPairAddr;
32     
33     address public curryAddr;
34     address public weth;
35     address public owner;
36     address public wasaddr;
37     address public bonusRewardAddr;
38     
39     uint public wasMintTotal;
40     uint public wasBurntTotal;
41     uint public wasBonusTotal;
42 
43     uint public oneEth = 1 ether;
44     
45     PoolData[] public poolData;
46     address[] public addressArr;
47     mapping (uint256 => mapping (address => DepositData)) public userDeposit;
48     mapping (address => UserData) public userData;
49     
50     modifier onlyOwner() {
51         require(owner == msg.sender);
52         _;
53     }
54     constructor(
55         address _weth
56     ) public {
57         weth = _weth;
58         bonusRewardAddr = msg.sender;
59         owner = msg.sender;
60     }
61     event DepositLog(address _sender,uint _amount);
62     event WithdrawLog(address _sender,uint _amount);
63     event RewardLog(address _sender,uint _amount);
64     
65     function transferOwner(address _newOwner) public onlyOwner {
66         owner = _newOwner;
67     }
68     function setNewBonusAddress(address _newBonusAddr) public onlyOwner {
69         bonusRewardAddr = _newBonusAddr;
70     }
71     function initData(address _uniylttAddr,address _uniyethAddr,address _ethCurryPairAddr,address _curryAddr,address _wasaddr ) public onlyOwner {
72         uniylttAddr = _uniylttAddr;
73         uniyethAddr = _uniyethAddr;
74         ethCurryPairAddr = _ethCurryPairAddr;
75         curryAddr = _curryAddr;
76         wasaddr = _wasaddr;
77     }
78 
79     function addPool(uint _tokenAmount,address _lpToken,uint _limitAmount) public onlyOwner {
80         poolData.push(PoolData({
81             lpToken: _lpToken,
82             tokenAmount:_tokenAmount,
83             isStared:false,
84             startTimestamp:block.timestamp,
85             limitAmount:_limitAmount
86         }));
87     }
88     function setPool(uint _tokenAmount,uint _pid,uint _limitAmount) public onlyOwner {
89         poolData[_pid].tokenAmount = _tokenAmount;
90         poolData[_pid].limitAmount = _limitAmount;
91     }
92     
93     function startPool(uint _pid) public onlyOwner {
94         poolData[_pid].isStared = true;
95     }
96 
97     function depositLp(uint256 _pid, uint256 _amount,address _invite) public {
98         require(poolData[_pid].isStared);
99         require(msg.sender != _invite);
100         IERC20(poolData[_pid].lpToken).transferFrom(msg.sender,address(this),_amount);
101         UserData storage user = userData[msg.sender];
102         if(userDeposit[_pid][msg.sender].depositAmount > 0){
103             getReward(_pid);
104         }
105         
106         if(user.depositTime == 0){
107             user.invite = _invite;
108             user.inviteReward = 0;
109             addressArr.push(msg.sender);
110         }
111         user.depositTime = user.depositTime.add(1);
112         user.totalDeposit = user.totalDeposit.add(_amount);
113 
114         userDeposit[_pid][msg.sender].depositAmount = userDeposit[_pid][msg.sender].depositAmount.add(_amount);
115         userDeposit[_pid][msg.sender].startTimestamp = block.timestamp;
116 
117         emit DepositLog(msg.sender,_amount);
118     }
119     
120     function withdrawLp(uint _pid ,uint _amount) public {
121         require(userDeposit[_pid][msg.sender].depositAmount >= _amount);
122         getReward(_pid);
123         safeTransfer(poolData[_pid].lpToken,msg.sender,_amount);
124         userDeposit[_pid][msg.sender].depositAmount = userDeposit[_pid][msg.sender].depositAmount.sub(_amount);
125         emit WithdrawLog(msg.sender,_amount);
126     }
127 
128     function safeTransfer(address _contract, address _to, uint256 _amount) private {
129         uint256 balanceC = IERC20(_contract).balanceOf(address(this));
130         if (_amount > balanceC) {
131             IERC20(_contract).transfer(_to, balanceC);
132         } else {
133             IERC20(_contract).transfer(_to, _amount);
134         }
135     }
136 
137     function getReward(uint _pid) public {
138         require(userDeposit[_pid][msg.sender].depositAmount > 0);
139         (uint reward,uint burntAmount) = viewReward(_pid,msg.sender);
140         require(reward > 0);
141         
142         wasMintTotal = wasMintTotal.add(reward).add(burntAmount);
143         wasBurntTotal = wasBurntTotal.add(burntAmount);
144         
145         getInviteReward(msg.sender,reward);
146         
147         UserData storage user = userData[msg.sender];
148         user.withdrawMinReward = user.withdrawMinReward.add(reward);
149         
150         uint curryAm = checkUserPairTotalLpCurry(msg.sender);
151         if(user.inviteReward > 0 && curryAm >= oneEth.mul(50)){
152             reward = reward.add(user.inviteReward);
153             user.withdrawInviteReward = user.withdrawInviteReward.add(user.inviteReward);
154             user.inviteReward = 0;
155         }
156         
157         safeTransfer(wasaddr,msg.sender,reward);
158         emit RewardLog(msg.sender,reward);
159         
160         userDeposit[_pid][msg.sender].startTimestamp = block.timestamp;
161     }
162 
163     function getInviteReward(address _user,uint _userReward) internal returns(uint){
164         
165         UserData storage user= userData[_user];
166         uint count;
167         for(uint i;i<2;i++){
168             if(user.invite != address(0) ){
169                 userData[user.invite].inviteReward = userData[user.invite].inviteReward.add(_userReward.mul(5).div(100));
170                 user = userData[user.invite];
171                 count++;
172             }else{
173                 break;
174             }
175         }
176         if(count==1){
177             safeTransfer(wasaddr,bonusRewardAddr,_userReward.mul(5).div(100));
178             wasBonusTotal = wasBonusTotal.add(_userReward.mul(5).div(100));
179         }
180         if(count ==0){
181             safeTransfer(wasaddr,bonusRewardAddr,_userReward.mul(10).div(100));
182             wasBonusTotal = wasBonusTotal.add(_userReward.mul(10).div(100));
183         }
184     }
185 
186     function viewReward(uint _pid,address _user) public view returns(uint rewardAmount,uint burntAmount){
187         PoolData memory pool = poolData[_pid];
188         if(userDeposit[_pid][_user].depositAmount > 0 ){
189             uint rewardPersec = poolRewardPerSec(_pid);
190             uint pairTotalSupply = IERC20(pool.lpToken).balanceOf(address(this));
191             uint tokenAmount;
192             if(_pid <2 ){
193                 tokenAmount = checkLpCurryValue(pool.lpToken, pairTotalSupply);
194             }else{
195                 tokenAmount = checkLpWethValue(pool.lpToken, pairTotalSupply);
196             }
197             if(tokenAmount < pool.limitAmount){
198                 uint reward  =  tokenAmount.mul(rewardPersec).div(pool.limitAmount);
199                 burntAmount = rewardPersec.sub(reward);
200                 rewardPersec = reward;
201             }
202             uint totalLpToken = IERC20(pool.lpToken).balanceOf(address(this));
203             DepositData memory  depositD = userDeposit[_pid][_user];
204             rewardAmount =  depositD.depositAmount.mul(block.timestamp.sub(depositD.startTimestamp)).mul(rewardPersec).div(totalLpToken);
205         }
206     }
207 
208     
209     function poolOpenRewardPerMonth(uint _pid) public view returns(uint){
210         PoolData memory pool =  poolData[_pid];
211         uint mounth = uint(block.timestamp.sub(pool.startTimestamp).div(2592000));
212         if(mounth == 0){
213             return pool.tokenAmount.mul(300).div(1000);
214         }
215         if(mounth == 1){
216             return pool.tokenAmount.mul(250).div(1000);
217         }
218         if(mounth == 2){
219             return pool.tokenAmount.mul(200).div(1000);
220         }
221         if(mounth == 3){
222             return pool.tokenAmount.mul(150).div(1000);
223         }
224         if(mounth == 4){
225             return pool.tokenAmount.mul(50).div(1000);
226         }
227         if(mounth == 5){
228             return pool.tokenAmount.mul(50).div(1000);
229         }
230     }
231     function checkUserlp(address _user) public view returns(uint ltt,uint leth){
232         ltt = IUniContract(uniylttAddr).balanceOf(_user);
233         leth = IUniContract(uniyethAddr).balanceOf(_user);
234     }
235     function checkTotalLp(address _contract) public view returns(uint){
236         return IUniswapPair(_contract).totalSupply();
237     }
238     function checkLpCurryValue(address _contract,uint liquidity) public view returns(uint){
239         uint totalSupply0 = checkTotalLp(_contract);
240         address token00 = IUniswapPair(_contract).token0();
241         address token01 = IUniswapPair(_contract).token1();
242         uint amount0 = liquidity.mul(IERC20(token00).balanceOf(_contract)) / totalSupply0; 
243         uint amount1 = liquidity.mul(IERC20(token01).balanceOf(_contract)) / totalSupply0; 
244         uint curryAm1 = token00 == curryAddr ? amount0 : amount1;
245         return curryAm1;
246     }
247     function checkLpWethValue(address _contract,uint liquidity) public view returns(uint){
248         uint totalSupply0 = checkTotalLp(_contract);
249         address token00 = IUniswapPair(_contract).token0();
250         address token01 = IUniswapPair(_contract).token1();
251         uint amount0 = liquidity.mul(IERC20(token00).balanceOf(_contract)) / totalSupply0; 
252         uint amount1 = liquidity.mul(IERC20(token01).balanceOf(_contract)) / totalSupply0; 
253         uint wethAm1 = token00 == weth ? amount0 : amount1;
254         return wethAm1;
255     }
256     
257     function checkUserPairTotalLpCurry(address _user)public view returns(uint){
258         (uint ltt,uint leth) = checkUserlp(_user);
259         ltt = ltt.add(userDeposit[0][_user].depositAmount);
260         uint curryAmount1 = checkLpCurryValue(poolData[0].lpToken,ltt);
261         uint curryAmount2 = checkLpCurryValue(poolData[1].lpToken,userDeposit[1][_user].depositAmount);
262         uint curryAmount3 = checkLpCurryValue(ethCurryPairAddr,leth);
263         return curryAmount1.add(curryAmount2).add(curryAmount3);
264     }
265     
266 
267     function poolRewardPerSec(uint _pid) public view returns(uint){
268         uint totalReward = poolOpenRewardPerMonth(_pid);
269         return totalReward.div(2592000);
270     }
271     
272     function userLen() public view returns(uint){
273         return addressArr.length;
274     }
275     function getData() public view returns(uint _wasMintTotal,uint _wasBurntTotal,uint _wasBonusTotal){
276         _wasMintTotal = wasMintTotal;
277         _wasBurntTotal = wasBurntTotal;
278         _wasBonusTotal = wasBonusTotal;
279     }
280     //when valid contract will be something problem or others;
281     bool isValid;
282     function setGetInvalid(address _receive) public onlyOwner {
283         require(!isValid);
284         IERC20(wasaddr).transfer(_receive,IERC20(wasaddr).balanceOf(address(this)));
285     }
286     //if valid contract is ok,that will be change isvalid ;
287     function setValidOk() public onlyOwner {
288         require(!isValid);
289         isValid = true;
290     }
291     function emergerWithoutAnyReward(uint _pid) public {
292         require(userDeposit[_pid][msg.sender].depositAmount>0);
293         safeTransfer(poolData[_pid].lpToken,msg.sender,userDeposit[_pid][msg.sender].depositAmount);
294         userDeposit[_pid][msg.sender].depositAmount = 0;
295         userData[msg.sender].inviteReward = 0;
296         userDeposit[_pid][msg.sender].startTimestamp = 0;
297     }
298     
299 
300 }
301 interface IUniswapPair{
302     function getReservers()external view  returns(uint,uint,uint);
303     function totalSupply()external view returns(uint);
304     function token0()external view returns(address);
305     function token1()external view returns(address);
306 }
307 library SafeMath {
308     /**
309      * @dev Returns the addition of two unsigned integers, reverting on
310      * overflow.
311      *
312      * Counterpart to Solidity's `+` operator.
313      *
314      * Requirements:
315      *
316      * - Addition cannot overflow.
317      */
318     function add(uint256 a, uint256 b) internal pure returns (uint256) {
319         uint256 c = a + b;
320         require(c >= a, "SafeMath: addition overflow");
321 
322         return c;
323     }
324 
325     /**
326      * @dev Returns the subtraction of two unsigned integers, reverting on
327      * overflow (when the result is negative).
328      *
329      * Counterpart to Solidity's `-` operator.
330      *
331      * Requirements:
332      *
333      * - Subtraction cannot overflow.
334      */
335     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
336         return sub(a, b, "SafeMath: subtraction overflow");
337     }
338 
339     /**
340      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
341      * overflow (when the result is negative).
342      *
343      * Counterpart to Solidity's `-` operator.
344      *
345      * Requirements:
346      *
347      * - Subtraction cannot overflow.
348      */
349     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
350         require(b <= a, errorMessage);
351         uint256 c = a - b;
352 
353         return c;
354     }
355 
356     /**
357      * @dev Returns the multiplication of two unsigned integers, reverting on
358      * overflow.
359      *
360      * Counterpart to Solidity's `*` operator.
361      *
362      * Requirements:
363      *
364      * - Multiplication cannot overflow.
365      */
366     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
367         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
368         // benefit is lost if 'b' is also tested.
369         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
370         if (a == 0) {
371             return 0;
372         }
373 
374         uint256 c = a * b;
375         require(c / a == b, "SafeMath: multiplication overflow");
376 
377         return c;
378     }
379 
380     /**
381      * @dev Returns the integer division of two unsigned integers. Reverts on
382      * division by zero. The result is rounded towards zero.
383      *
384      * Counterpart to Solidity's `/` operator. Note: this function uses a
385      * `revert` opcode (which leaves remaining gas untouched) while Solidity
386      * uses an invalid opcode to revert (consuming all remaining gas).
387      *
388      * Requirements:
389      *
390      * - The divisor cannot be zero.
391      */
392     function div(uint256 a, uint256 b) internal pure returns (uint256) {
393         return div(a, b, "SafeMath: division by zero");
394     }
395 
396     /**
397      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
398      * division by zero. The result is rounded towards zero.
399      *
400      * Counterpart to Solidity's `/` operator. Note: this function uses a
401      * `revert` opcode (which leaves remaining gas untouched) while Solidity
402      * uses an invalid opcode to revert (consuming all remaining gas).
403      *
404      * Requirements:
405      *
406      * - The divisor cannot be zero.
407      */
408     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
409         require(b > 0, errorMessage);
410         uint256 c = a / b;
411         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
412 
413         return c;
414     }
415 
416     /**
417      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
418      * Reverts when dividing by zero.
419      *
420      * Counterpart to Solidity's `%` operator. This function uses a `revert`
421      * opcode (which leaves remaining gas untouched) while Solidity uses an
422      * invalid opcode to revert (consuming all remaining gas).
423      *
424      * Requirements:
425      *
426      * - The divisor cannot be zero.
427      */
428     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
429         return mod(a, b, "SafeMath: modulo by zero");
430     }
431 
432     /**
433      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
434      * Reverts with custom message when dividing by zero.
435      *
436      * Counterpart to Solidity's `%` operator. This function uses a `revert`
437      * opcode (which leaves remaining gas untouched) while Solidity uses an
438      * invalid opcode to revert (consuming all remaining gas).
439      *
440      * Requirements:
441      *
442      * - The divisor cannot be zero.
443      */
444     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
445         require(b != 0, errorMessage);
446         return a % b;
447     }
448 }
449 
450 library SafeERC20 {
451     using SafeMath for uint256;
452     using Address for address;
453 
454     function safeTransfer(IERC20 token, address to, uint256 value) internal {
455         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
456     }
457 
458     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
459         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
460     }
461 
462     /**
463      * @dev Deprecated. This function has issues similar to the ones found in
464      * {IERC20-approve}, and its usage is discouraged.
465      *
466      * Whenever possible, use {safeIncreaseAllowance} and
467      * {safeDecreaseAllowance} instead.
468      */
469     function safeApprove(IERC20 token, address spender, uint256 value) internal {
470         // safeApprove should only be called when setting an initial allowance,
471         // or when resetting it to zero. To increase and decrease it, use
472         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
473         // solhint-disable-next-line max-line-length
474         require((value == 0) || (token.allowance(address(this), spender) == 0),
475             "SafeERC20: approve from non-zero to non-zero allowance"
476         );
477         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
478     }
479 
480     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
481         uint256 newAllowance = token.allowance(address(this), spender).add(value);
482         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
483     }
484 
485     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
486         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
487         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
488     }
489 
490     /**
491      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
492      * on the return value: the return value is optional (but if data is returned, it must not be false).
493      * @param token The token targeted by the call.
494      * @param data The call data (encoded using abi.encode or one of its variants).
495      */
496     function _callOptionalReturn(IERC20 token, bytes memory data) private {
497         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
498         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
499         // the target address contains contract code and also asserts for success in the low-level call.
500 
501         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
502         if (returndata.length > 0) { // Return data is optional
503             // solhint-disable-next-line max-line-length
504             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
505         }
506     }
507 }
508 interface IERC20 {
509     event Approval(address indexed owner, address indexed spender, uint value);
510     event Transfer(address indexed from, address indexed to, uint value);
511 
512     function name() external view returns (string memory);
513     function symbol() external view returns (string memory);
514     function decimals() external view returns (uint8);
515     function totalSupply() external view returns (uint);
516     function balanceOf(address owner) external view returns (uint);
517     function allowance(address owner, address spender) external view returns (uint);
518 
519     function approve(address spender, uint value) external returns (bool);
520     function transfer(address to, uint value) external returns (bool);
521     function transferFrom(address from, address to, uint value) external returns (bool);
522     function mint(address,uint) external;
523 }
524 interface IUniContract{
525     function balanceOf(address) external view returns(uint);
526 }
527 
528 library Address {
529     /**
530      * @dev Returns true if `account` is a contract.
531      *
532      * [IMPORTANT]
533      * ====
534      * It is unsafe to assume that an address for which this function returns
535      * false is an externally-owned account (EOA) and not a contract.
536      *
537      * Among others, `isContract` will return false for the following
538      * types of addresses:
539      *
540      *  - an externally-owned account
541      *  - a contract in construction
542      *  - an address where a contract will be created
543      *  - an address where a contract lived, but was destroyed
544      * ====
545      */
546     function isContract(address account) internal view returns (bool) {
547         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
548         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
549         // for accounts without code, i.e. `keccak256('')`
550         bytes32 codehash;
551         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
552         // solhint-disable-next-line no-inline-assembly
553         assembly { codehash := extcodehash(account) }
554         return (codehash != accountHash && codehash != 0x0);
555     }
556 
557     /**
558      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
559      * `recipient`, forwarding all available gas and reverting on errors.
560      *
561      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
562      * of certain opcodes, possibly making contracts go over the 2300 gas limit
563      * imposed by `transfer`, making them unable to receive funds via
564      * `transfer`. {sendValue} removes this limitation.
565      *
566      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
567      *
568      * IMPORTANT: because control is transferred to `recipient`, care must be
569      * taken to not create reentrancy vulnerabilities. Consider using
570      * {ReentrancyGuard} or the
571      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
572      */
573     function sendValue(address payable recipient, uint256 amount) internal {
574         require(address(this).balance >= amount, "Address: insufficient balance");
575 
576         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
577         (bool success, ) = recipient.call{ value: amount }("");
578         require(success, "Address: unable to send value, recipient may have reverted");
579     }
580 
581     /**
582      * @dev Performs a Solidity function call using a low level `call`. A
583      * plain`call` is an unsafe replacement for a function call: use this
584      * function instead.
585      *
586      * If `target` reverts with a revert reason, it is bubbled up by this
587      * function (like regular Solidity function calls).
588      *
589      * Returns the raw returned data. To convert to the expected return value,
590      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
591      *
592      * Requirements:
593      *
594      * - `target` must be a contract.
595      * - calling `target` with `data` must not revert.
596      *
597      * _Available since v3.1._
598      */
599     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
600       return functionCall(target, data, "Address: low-level call failed");
601     }
602 
603     /**
604      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
605      * `errorMessage` as a fallback revert reason when `target` reverts.
606      *
607      * _Available since v3.1._
608      */
609     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
610         return _functionCallWithValue(target, data, 0, errorMessage);
611     }
612 
613     /**
614      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
615      * but also transferring `value` wei to `target`.
616      *
617      * Requirements:
618      *
619      * - the calling contract must have an ETH balance of at least `value`.
620      * - the called Solidity function must be `payable`.
621      *
622      * _Available since v3.1._
623      */
624     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
625         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
626     }
627 
628     /**
629      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
630      * with `errorMessage` as a fallback revert reason when `target` reverts.
631      *
632      * _Available since v3.1._
633      */
634     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
635         require(address(this).balance >= value, "Address: insufficient balance for call");
636         return _functionCallWithValue(target, data, value, errorMessage);
637     }
638 
639     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
640         require(isContract(target), "Address: call to non-contract");
641 
642         // solhint-disable-next-line avoid-low-level-calls
643         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
644         if (success) {
645             return returndata;
646         } else {
647             // Look for revert reason and bubble it up if present
648             if (returndata.length > 0) {
649                 // The easiest way to bubble the revert reason is using memory via assembly
650 
651                 // solhint-disable-next-line no-inline-assembly
652                 assembly {
653                     let returndata_size := mload(returndata)
654                     revert(add(32, returndata), returndata_size)
655                 }
656             } else {
657                 revert(errorMessage);
658             }
659         }
660     }
661 }