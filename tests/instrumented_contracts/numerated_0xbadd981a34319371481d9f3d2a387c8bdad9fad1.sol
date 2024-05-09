1 //SPDX-License-Identifier: UNLICENSED
2 pragma solidity 0.6.12;
3 
4 
5 interface IERC20 {
6     /**
7      * @dev Returns the amount of tokens in existence.
8      */
9     function totalSupply() external view returns (uint256);
10 
11     /**
12      * @dev Returns the amount of tokens owned by `account`.
13      */
14     function balanceOf(address account) external view returns (uint256);
15 
16     /**
17      * @dev Moves `amount` tokens from the caller's account to `recipient`.
18      *
19      * Returns a boolean value indicating whether the operation succeeded.
20      *
21      * Emits a {Transfer} event.
22      */
23     function transfer(address recipient, uint256 amount) external returns (bool);
24 
25     /**
26      * @dev Returns the remaining number of tokens that `spender` will be
27      * allowed to spend on behalf of `owner` through {transferFrom}. This is
28      * zero by default.
29      *
30      * This value changes when {approve} or {transferFrom} are called.
31      */
32     function allowance(address owner, address spender) external view returns (uint256);
33 
34     /**
35      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
36      *
37      * Returns a boolean value indicating whether the operation succeeded.
38      *
39      * IMPORTANT: Beware that changing an allowance with this method brings the risk
40      * that someone may use both the old and the new allowance by unfortunate
41      * transaction ordering. One possible solution to mitigate this race
42      * condition is to first reduce the spender's allowance to 0 and set the
43      * desired value afterwards:
44      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
45      *
46      * Emits an {Approval} event.
47      */
48     function approve(address spender, uint256 amount) external returns (bool);
49 
50     /**
51      * @dev Moves `amount` tokens from `sender` to `recipient` using the
52      * allowance mechanism. `amount` is then deducted from the caller's
53      * allowance.
54      *
55      * Returns a boolean value indicating whether the operation succeeded.
56      *
57      * Emits a {Transfer} event.
58      */
59     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
60 
61     /**
62      * @dev Emitted when `value` tokens are moved from one account (`from`) to
63      * another (`to`).
64      *
65      * Note that `value` may be zero.
66      */
67     event Transfer(address indexed from, address indexed to, uint256 value);
68 
69     /**
70      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
71      * a call to {approve}. `value` is the new allowance.
72      */
73     event Approval(address indexed owner, address indexed spender, uint256 value);
74 }
75 
76 
77 library SafeMath {
78     /**
79      * @dev Returns the addition of two unsigned integers, reverting on
80      * overflow.
81      *
82      * Counterpart to Solidity's `+` operator.
83      *
84      * Requirements:
85      *
86      * - Addition cannot overflow.
87      */
88     function add(uint256 a, uint256 b) internal pure returns (uint256) {
89         uint256 c = a + b;
90         require(c >= a, "SafeMath: addition overflow");
91 
92         return c;
93     }
94 
95     /**
96      * @dev Returns the subtraction of two unsigned integers, reverting on
97      * overflow (when the result is negative).
98      *
99      * Counterpart to Solidity's `-` operator.
100      *
101      * Requirements:
102      *
103      * - Subtraction cannot overflow.
104      */
105     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
106         return sub(a, b, "SafeMath: subtraction overflow");
107     }
108 
109     /**
110      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
111      * overflow (when the result is negative).
112      *
113      * Counterpart to Solidity's `-` operator.
114      *
115      * Requirements:
116      *
117      * - Subtraction cannot overflow.
118      */
119     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
120         require(b <= a, errorMessage);
121         uint256 c = a - b;
122 
123         return c;
124     }
125 
126     /**
127      * @dev Returns the multiplication of two unsigned integers, reverting on
128      * overflow.
129      *
130      * Counterpart to Solidity's `*` operator.
131      *
132      * Requirements:
133      *
134      * - Multiplication cannot overflow.
135      */
136     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
137         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
138         // benefit is lost if 'b' is also tested.
139         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
140         if (a == 0) {
141             return 0;
142         }
143 
144         uint256 c = a * b;
145         require(c / a == b, "SafeMath: multiplication overflow");
146 
147         return c;
148     }
149 
150     /**
151      * @dev Returns the integer division of two unsigned integers. Reverts on
152      * division by zero. The result is rounded towards zero.
153      *
154      * Counterpart to Solidity's `/` operator. Note: this function uses a
155      * `revert` opcode (which leaves remaining gas untouched) while Solidity
156      * uses an invalid opcode to revert (consuming all remaining gas).
157      *
158      * Requirements:
159      *
160      * - The divisor cannot be zero.
161      */
162     function div(uint256 a, uint256 b) internal pure returns (uint256) {
163         return div(a, b, "SafeMath: division by zero");
164     }
165 
166     /**
167      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
168      * division by zero. The result is rounded towards zero.
169      *
170      * Counterpart to Solidity's `/` operator. Note: this function uses a
171      * `revert` opcode (which leaves remaining gas untouched) while Solidity
172      * uses an invalid opcode to revert (consuming all remaining gas).
173      *
174      * Requirements:
175      *
176      * - The divisor cannot be zero.
177      */
178     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
179         require(b > 0, errorMessage);
180         uint256 c = a / b;
181         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
182 
183         return c;
184     }
185 
186     /**
187      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
188      * Reverts when dividing by zero.
189      *
190      * Counterpart to Solidity's `%` operator. This function uses a `revert`
191      * opcode (which leaves remaining gas untouched) while Solidity uses an
192      * invalid opcode to revert (consuming all remaining gas).
193      *
194      * Requirements:
195      *
196      * - The divisor cannot be zero.
197      */
198     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
199         return mod(a, b, "SafeMath: modulo by zero");
200     }
201 
202     /**
203      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
204      * Reverts with custom message when dividing by zero.
205      *
206      * Counterpart to Solidity's `%` operator. This function uses a `revert`
207      * opcode (which leaves remaining gas untouched) while Solidity uses an
208      * invalid opcode to revert (consuming all remaining gas).
209      *
210      * Requirements:
211      *
212      * - The divisor cannot be zero.
213      */
214     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
215         require(b != 0, errorMessage);
216         return a % b;
217     }
218 }
219 
220 
221 
222 abstract contract Context {
223     function _msgSender() internal view virtual returns (address payable) {
224         return msg.sender;
225     }
226 
227     function _msgData() internal view virtual returns (bytes memory) {
228         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
229         return msg.data;
230     }
231 }
232 
233 
234 library TransferHelper {
235     function safeApprove(address token, address to, uint value) internal {
236         // bytes4(keccak256(bytes('approve(address,uint256)')));
237         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x095ea7b3, to, value));
238         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: APPROVE_FAILED');
239     }
240 
241     function safeTransfer(address token, address to, uint value) internal {
242         // bytes4(keccak256(bytes('transfer(address,uint256)')));
243         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0xa9059cbb, to, value));
244         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FAILED');
245     }
246 
247     function safeTransferFrom(address token, address from, address to, uint value) internal {
248         // bytes4(keccak256(bytes('transferFrom(address,address,uint256)')));
249         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x23b872dd, from, to, value));
250         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FROM_FAILED');
251     }
252 
253     function safeTransferETH(address to, uint value) internal {
254         (bool success,) = to.call{value:value}(new bytes(0));
255         require(success, 'TransferHelper: ETH_TRANSFER_FAILED');
256     }
257 }
258 
259 
260 
261 contract Distribute is Context {
262     using SafeMath for uint;
263 
264     mapping(address => bool) public isParticipate;
265 
266     mapping(address => uint256) public giverBalance; 
267 
268     struct UserInfo {
269         uint256 value;
270 
271         uint256 flagBlock;
272 
273         uint256 preBlockReward;
274 
275         uint256 withdraw;
276     }
277 
278     mapping(address => UserInfo) userDepositInfo;
279 
280     //time params
281     uint256 public  getSonEndTime;
282 
283     uint256 public  giveSonEndTime;
284 
285     uint256 public  depositEndBlock;
286 
287     //balance params
288     uint256 public getBalance;
289 
290     uint256 public stakeBalance;
291 
292     uint256 public giveEthBalance;
293    
294     uint256 public giveVitalikEtherValue;
295 
296     //balance to giver
297     uint256 private constant PER_GET_REWARD = 2 ether;
298 
299     uint256 private constant PER_DEPOSIT_REWARD = 50 ether;  
300 
301     uint256 private constant PER_GIVER_REWARD =  150 ether;
302     
303     //limited value
304     uint256 private constant MAX_GIVER_VALUE = 3 ether;
305 
306     uint256 private constant MAX_DEPOSIT_VALUE = 5 ether;
307 
308     //STAKE_BLOCK must > depositEndBlock
309     uint256 private constant STAKE_BLOCK = 288000;
310 
311     uint256 public constant GIVE_VITALIK_BLOCK_TIME = 1612022400;
312 
313     //address
314     address public constant VITALIK_ADDRESS = address(0xAb5801a7D398351b8bE11C439e05C5B3259aeC9B);
315     
316     address public dev;
317 
318     //flag
319     bool private isInnit;
320  
321     uint private unlocked = 1;
322  
323     IERC20  son;
324 
325     event GetSon(address getAddress);
326     event DepositeGetSon(address getAddress, uint256 value);
327     event WithdrawDepositReward(address user, uint256 value);
328     event WithdrawDepositEther(address user, uint256 value);
329     event Unlock(address user, address value);
330     event GiverGetSon(address getAddress, uint256 giverEtherValue);
331     event GiverToVitalik(address _vitalikAddress, uint256 value);
332     event TransferDev(address oldDev, address newDev);
333 
334     constructor()public {
335         dev = msg.sender;
336     }
337 
338     receive() external payable {
339 
340     }
341 
342     modifier lock() {
343         require(unlocked == 1, 'Son Distribute: LOCKED');
344         unlocked = 0;
345         _;
346         unlocked = 1;
347     }
348     
349     //init son Address;
350     function initSon(address sonAddress) public {
351         require(!isInnit,"Son Distribute: is already init");
352 
353         require(msg.sender == dev);
354 
355         son = IERC20(sonAddress);
356 
357         getSonEndTime = block.timestamp + 15 days;
358 
359         giveSonEndTime = block.timestamp + 15 days;
360 
361         depositEndBlock = block.number + 86400;
362 
363         require(STAKE_BLOCK.sub(depositEndBlock.sub(block.number)) > 0, "Son Distribute: stake period must > deposit period!");
364 
365         uint256 toThisAddress = son.totalSupply().mul(95).div(100);
366 
367         require(son.balanceOf(address(this)) == toThisAddress);
368 
369         getBalance = toThisAddress.mul(20).div(100);
370         stakeBalance = toThisAddress.mul(50).div(100);
371         giveEthBalance = toThisAddress.sub(getBalance).sub(stakeBalance);
372 
373         isInnit = true;
374     }
375     
376 
377     //airdrop
378     function getSon() public lock {
379 
380         require(block.timestamp <= getSonEndTime,"Son Distribute: free get Son is End!");
381         
382         require(getBalance >= PER_GET_REWARD,"Son Distribute: have no enough son to giver!");
383 
384         require(!isParticipate[msg.sender],"Son Distribute: Have already taken part in!");
385         
386         getBalance = getBalance.sub(PER_GET_REWARD);
387 
388         isParticipate[msg.sender] = true;
389 
390         TransferHelper.safeTransfer(address(son),msg.sender,PER_GET_REWARD);
391 
392         emit GetSon(msg.sender);
393     }
394 
395 
396     function depositGetSon() public payable lock{
397         require(msg.value > 100 gwei,"Son Distribute: too small value");
398 
399         require(msg.value <= MAX_DEPOSIT_VALUE,"Son Distribute: over max deposit");
400 
401         require(block.number < depositEndBlock,"Son Distribute: deposit time is end!");
402 
403         require(userDepositInfo[msg.sender].value == 0,"Son Distribute: already deposit");
404 
405         uint256 getSonBalance = msg.value.mul(PER_DEPOSIT_REWARD).div(10 ** 18);
406 
407         require(stakeBalance >= getSonBalance,"Son Distribute: not enough son to give!");
408 
409         stakeBalance = stakeBalance.sub(getSonBalance);
410 
411         uint256 preReward = getSonBalance.div(depositEndBlock.sub(block.number));
412 
413         userDepositInfo[msg.sender] = UserInfo({value:msg.value,flagBlock: block.number,preBlockReward:preReward,withdraw:0});
414 
415         emit DepositeGetSon(_msgSender(),msg.value);
416     }
417 
418     function checkDepositInfo(address user) public view returns(uint256,uint256,uint256,uint256) {
419 
420         return (userDepositInfo[user].value, userDepositInfo[user].flagBlock, userDepositInfo[user].preBlockReward, userDepositInfo[user].withdraw);
421 
422     }
423 
424 
425 
426     function pendingDepositReward(address user) public view returns(uint256 amount){
427 
428         if(block.number >= depositEndBlock){
429             
430             amount = userDepositInfo[user].value.mul(PER_DEPOSIT_REWARD).div(10 ** 18).sub(userDepositInfo[user].withdraw);
431  
432         }else{
433 
434              amount = block.number.sub(userDepositInfo[user].flagBlock).mul(userDepositInfo[user].preBlockReward).sub(userDepositInfo[user].withdraw);
435     
436         }
437     
438     }
439 
440     function withdrawDepositReward() public lock{
441 
442         require(userDepositInfo[msg.sender].value > 0,"Son Distribute: have no deposit");
443 
444         uint256 newWithdraw = pendingDepositReward(msg.sender);
445 
446         require(newWithdraw > 0, "Son Distribute: no reward to give");
447 
448         userDepositInfo[msg.sender].withdraw = userDepositInfo[msg.sender].withdraw.add(newWithdraw);
449 
450         TransferHelper.safeTransfer(address(son),msg.sender,newWithdraw);
451 
452         emit WithdrawDepositReward(msg.sender,newWithdraw);
453     }
454 
455 
456     function withdrawDepositEther() public payable lock {
457         
458         require(userDepositInfo[msg.sender].value > 0,"Son Distribute: have no deposit");
459         
460         //check stake finish
461         require(block.number.sub(userDepositInfo[msg.sender].flagBlock) >= STAKE_BLOCK,"Son Distribute: still in staking");
462         
463         //check if already withdraw
464         require(userDepositInfo[msg.sender].flagBlock < depositEndBlock,"Son Distribute: already withdraw");
465 
466         uint256 sendAmount = userDepositInfo[msg.sender].value;
467 
468         userDepositInfo[msg.sender].flagBlock = block.number;
469 
470         TransferHelper.safeTransferETH(_msgSender(),sendAmount);
471 
472         emit WithdrawDepositEther(msg.sender,sendAmount);
473     }
474 
475 
476     function giverGetSon() public payable lock {
477         require(msg.value > 0,"Son Distribute: no ether!");
478 
479         require(block.timestamp <= giveSonEndTime,"Son Distribute: not in the period");
480         
481         require(giverBalance[msg.sender].add(msg.value) <= MAX_GIVER_VALUE,"Son Distribute: is over MAX_GIVER_VALUE");
482 
483         giverBalance[msg.sender] = giverBalance[msg.sender].add(msg.value);
484 
485         uint256 getSonBalance = msg.value.mul(PER_GIVER_REWARD).div(10 ** 18);
486 
487         require(giveEthBalance >= getSonBalance,"Son Distribute: not enough son to give!");
488 
489         giveEthBalance = giveEthBalance.sub(getSonBalance);
490 
491         TransferHelper.safeTransfer(address(son),_msgSender(),getSonBalance);
492 
493         giveVitalikEtherValue = giveVitalikEtherValue.add(msg.value);
494 
495         emit GiverGetSon(_msgSender(),msg.value);
496     }
497 
498 
499     function giverToVitalik() public lock{
500 
501         require(block.timestamp >= GIVE_VITALIK_BLOCK_TIME,"Son Distribute: block timestamp limited!");
502 
503         require(giveVitalikEtherValue > 0,"Son Distribute: no ether to give!");
504 
505         uint256 toValue = giveVitalikEtherValue;
506 
507         giveVitalikEtherValue = 0;
508 
509         TransferHelper.safeTransferETH(VITALIK_ADDRESS,toValue);
510 
511         emit GiverToVitalik(VITALIK_ADDRESS,toValue);
512     }
513 
514 
515     function getRemianSon() public  {
516 
517         uint256 toValue;
518 
519         if (getBalance > 0 && block.timestamp > getSonEndTime) {
520             toValue = toValue.add(getBalance);
521             getBalance = 0;
522             
523         }
524 
525         if (stakeBalance > 0 && block.number > depositEndBlock) {
526             toValue = toValue.add(stakeBalance);
527             stakeBalance = 0;  
528         }
529 
530         if(giveEthBalance > 0 && block.timestamp > giveSonEndTime) {
531             toValue = toValue.add(giveEthBalance);
532             giveEthBalance = 0;
533         }
534 
535         require(toValue > 0,"Son Distribute: no value to give back!");
536 
537         TransferHelper.safeTransfer(address(son),dev,toValue);
538     }
539 
540 
541     function transferDev(address _dev) public {
542         require(msg.sender == dev,"Son Distribute: not dev!");
543         dev = _dev;
544         emit TransferDev(msg.sender, dev);
545     }
546 
547 }