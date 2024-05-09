1 // File: @openzeppelin/contracts/utils/Context.sol
2 
3 pragma solidity >=0.6.0 <0.8.0;
4 
5 /*
6  * @dev Provides information about the current execution context, including the
7  * sender of the transaction and its data. While these are generally available
8  * via msg.sender and msg.data, they should not be accessed in such a direct
9  * manner, since when dealing with GSN meta-transactions the account sending and
10  * paying for execution may not be the actual sender (as far as an application
11  * is concerned).
12  *
13  * This contract is only required for intermediate, library-like contracts.
14  */
15 abstract contract Context {
16     function _msgSender() internal view virtual returns (address payable) {
17         return msg.sender;
18     }
19 
20     function _msgData() internal view virtual returns (bytes memory) {
21         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
22         return msg.data;
23     }
24 }
25 
26 // File: @openzeppelin/contracts/access/Ownable.sol
27 
28 /**
29  * @dev Contract module which provides a basic access control mechanism, where
30  * there is an account (an owner) that can be granted exclusive access to
31  * specific functions.
32  *
33  * By default, the owner account will be the one that deploys the contract. This
34  * can later be changed with {transferOwnership}.
35  *
36  * This module is used through inheritance. It will make available the modifier
37  * `onlyOwner`, which can be applied to your functions to restrict their use to
38  * the owner.
39  */
40 abstract contract Ownable is Context {
41     address private _owner;
42 
43     event OwnershipTransferred(
44         address indexed previousOwner,
45         address indexed newOwner
46     );
47 
48     /**
49      * @dev Initializes the contract setting the deployer as the initial owner.
50      */
51     constructor() internal {
52         address msgSender = _msgSender();
53         _owner = msgSender;
54         emit OwnershipTransferred(address(0), msgSender);
55     }
56 
57     /**
58      * @dev Returns the address of the current owner.
59      */
60     function owner() public view virtual returns (address) {
61         return _owner;
62     }
63 
64     /**
65      * @dev Throws if called by any account other than the owner.
66      */
67     modifier onlyOwner() {
68         require(owner() == _msgSender(), "Ownable: caller is not the owner");
69         _;
70     }
71 
72     /**
73      * @dev Leaves the contract without owner. It will not be possible to call
74      * `onlyOwner` functions anymore. Can only be called by the current owner.
75      *
76      * NOTE: Renouncing ownership will leave the contract without an owner,
77      * thereby removing any functionality that is only available to the owner.
78      */
79     function renounceOwnership() public virtual onlyOwner {
80         emit OwnershipTransferred(_owner, address(0));
81         _owner = address(0);
82     }
83 
84     /**
85      * @dev Transfers ownership of the contract to a new account (`newOwner`).
86      * Can only be called by the current owner.
87      */
88     function transferOwnership(address newOwner) public virtual onlyOwner {
89         require(
90             newOwner != address(0),
91             "Ownable: new owner is the zero address"
92         );
93         emit OwnershipTransferred(_owner, newOwner);
94         _owner = newOwner;
95     }
96 }
97 
98 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
99 
100 /**
101  * @dev Interface of the ERC20 standard as defined in the EIP.
102  */
103 interface IERC20 {
104     /**
105      * @dev Returns the amount of tokens in existence.
106      */
107     function totalSupply() external view returns (uint256);
108 
109     /**
110      * @dev Returns the amount of tokens owned by `account`.
111      */
112     function balanceOf(address account) external view returns (uint256);
113 
114     /**
115      * @dev Moves `amount` tokens from the caller's account to `recipient`.
116      *
117      * Returns a boolean value indicating whether the operation succeeded.
118      *
119      * Emits a {Transfer} event.
120      */
121     function transfer(address recipient, uint256 amount)
122         external
123         returns (bool);
124 
125     /**
126      * @dev Returns the remaining number of tokens that `spender` will be
127      * allowed to spend on behalf of `owner` through {transferFrom}. This is
128      * zero by default.
129      *
130      * This value changes when {approve} or {transferFrom} are called.
131      */
132     function allowance(address owner, address spender)
133         external
134         view
135         returns (uint256);
136 
137     /**
138      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
139      *
140      * Returns a boolean value indicating whether the operation succeeded.
141      *
142      * IMPORTANT: Beware that changing an allowance with this method brings the risk
143      * that someone may use both the old and the new allowance by unfortunate
144      * transaction ordering. One possible solution to mitigate this race
145      * condition is to first reduce the spender's allowance to 0 and set the
146      * desired value afterwards:
147      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
148      *
149      * Emits an {Approval} event.
150      */
151     function approve(address spender, uint256 amount) external returns (bool);
152 
153     /**
154      * @dev Moves `amount` tokens from `sender` to `recipient` using the
155      * allowance mechanism. `amount` is then deducted from the caller's
156      * allowance.
157      *
158      * Returns a boolean value indicating whether the operation succeeded.
159      *
160      * Emits a {Transfer} event.
161      */
162     function transferFrom(
163         address sender,
164         address recipient,
165         uint256 amount
166     ) external returns (bool);
167 
168     /**
169      * @dev Emitted when `value` tokens are moved from one account (`from`) to
170      * another (`to`).
171      *
172      * Note that `value` may be zero.
173      */
174     event Transfer(address indexed from, address indexed to, uint256 value);
175 
176     /**
177      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
178      * a call to {approve}. `value` is the new allowance.
179      */
180     event Approval(
181         address indexed owner,
182         address indexed spender,
183         uint256 value
184     );
185 }
186 
187 // File: @openzeppelin/contracts/math/SafeMath.sol
188 
189 /**
190  * @dev Wrappers over Solidity's arithmetic operations with added overflow
191  * checks.
192  *
193  * Arithmetic operations in Solidity wrap on overflow. This can easily result
194  * in bugs, because programmers usually assume that an overflow raises an
195  * error, which is the standard behavior in high level programming languages.
196  * `SafeMath` restores this intuition by reverting the transaction when an
197  * operation overflows.
198  *
199  * Using this library instead of the unchecked operations eliminates an entire
200  * class of bugs, so it's recommended to use it always.
201  */
202 library SafeMath {
203     /**
204      * @dev Returns the addition of two unsigned integers, with an overflow flag.
205      *
206      * _Available since v3.4._
207      */
208     function tryAdd(uint256 a, uint256 b)
209         internal
210         pure
211         returns (bool, uint256)
212     {
213         uint256 c = a + b;
214         if (c < a) return (false, 0);
215         return (true, c);
216     }
217 
218     /**
219      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
220      *
221      * _Available since v3.4._
222      */
223     function trySub(uint256 a, uint256 b)
224         internal
225         pure
226         returns (bool, uint256)
227     {
228         if (b > a) return (false, 0);
229         return (true, a - b);
230     }
231 
232     /**
233      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
234      *
235      * _Available since v3.4._
236      */
237     function tryMul(uint256 a, uint256 b)
238         internal
239         pure
240         returns (bool, uint256)
241     {
242         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
243         // benefit is lost if 'b' is also tested.
244         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
245         if (a == 0) return (true, 0);
246         uint256 c = a * b;
247         if (c / a != b) return (false, 0);
248         return (true, c);
249     }
250 
251     /**
252      * @dev Returns the division of two unsigned integers, with a division by zero flag.
253      *
254      * _Available since v3.4._
255      */
256     function tryDiv(uint256 a, uint256 b)
257         internal
258         pure
259         returns (bool, uint256)
260     {
261         if (b == 0) return (false, 0);
262         return (true, a / b);
263     }
264 
265     /**
266      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
267      *
268      * _Available since v3.4._
269      */
270     function tryMod(uint256 a, uint256 b)
271         internal
272         pure
273         returns (bool, uint256)
274     {
275         if (b == 0) return (false, 0);
276         return (true, a % b);
277     }
278 
279     /**
280      * @dev Returns the addition of two unsigned integers, reverting on
281      * overflow.
282      *
283      * Counterpart to Solidity's `+` operator.
284      *
285      * Requirements:
286      *
287      * - Addition cannot overflow.
288      */
289     function add(uint256 a, uint256 b) internal pure returns (uint256) {
290         uint256 c = a + b;
291         require(c >= a, "SafeMath: addition overflow");
292         return c;
293     }
294 
295     /**
296      * @dev Returns the subtraction of two unsigned integers, reverting on
297      * overflow (when the result is negative).
298      *
299      * Counterpart to Solidity's `-` operator.
300      *
301      * Requirements:
302      *
303      * - Subtraction cannot overflow.
304      */
305     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
306         require(b <= a, "SafeMath: subtraction overflow");
307         return a - b;
308     }
309 
310     /**
311      * @dev Returns the multiplication of two unsigned integers, reverting on
312      * overflow.
313      *
314      * Counterpart to Solidity's `*` operator.
315      *
316      * Requirements:
317      *
318      * - Multiplication cannot overflow.
319      */
320     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
321         if (a == 0) return 0;
322         uint256 c = a * b;
323         require(c / a == b, "SafeMath: multiplication overflow");
324         return c;
325     }
326 
327     /**
328      * @dev Returns the integer division of two unsigned integers, reverting on
329      * division by zero. The result is rounded towards zero.
330      *
331      * Counterpart to Solidity's `/` operator. Note: this function uses a
332      * `revert` opcode (which leaves remaining gas untouched) while Solidity
333      * uses an invalid opcode to revert (consuming all remaining gas).
334      *
335      * Requirements:
336      *
337      * - The divisor cannot be zero.
338      */
339     function div(uint256 a, uint256 b) internal pure returns (uint256) {
340         require(b > 0, "SafeMath: division by zero");
341         return a / b;
342     }
343 
344     /**
345      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
346      * reverting when dividing by zero.
347      *
348      * Counterpart to Solidity's `%` operator. This function uses a `revert`
349      * opcode (which leaves remaining gas untouched) while Solidity uses an
350      * invalid opcode to revert (consuming all remaining gas).
351      *
352      * Requirements:
353      *
354      * - The divisor cannot be zero.
355      */
356     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
357         require(b > 0, "SafeMath: modulo by zero");
358         return a % b;
359     }
360 
361     /**
362      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
363      * overflow (when the result is negative).
364      *
365      * CAUTION: This function is deprecated because it requires allocating memory for the error
366      * message unnecessarily. For custom revert reasons use {trySub}.
367      *
368      * Counterpart to Solidity's `-` operator.
369      *
370      * Requirements:
371      *
372      * - Subtraction cannot overflow.
373      */
374     function sub(
375         uint256 a,
376         uint256 b,
377         string memory errorMessage
378     ) internal pure returns (uint256) {
379         require(b <= a, errorMessage);
380         return a - b;
381     }
382 
383     /**
384      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
385      * division by zero. The result is rounded towards zero.
386      *
387      * CAUTION: This function is deprecated because it requires allocating memory for the error
388      * message unnecessarily. For custom revert reasons use {tryDiv}.
389      *
390      * Counterpart to Solidity's `/` operator. Note: this function uses a
391      * `revert` opcode (which leaves remaining gas untouched) while Solidity
392      * uses an invalid opcode to revert (consuming all remaining gas).
393      *
394      * Requirements:
395      *
396      * - The divisor cannot be zero.
397      */
398     function div(
399         uint256 a,
400         uint256 b,
401         string memory errorMessage
402     ) internal pure returns (uint256) {
403         require(b > 0, errorMessage);
404         return a / b;
405     }
406 
407     /**
408      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
409      * reverting with custom message when dividing by zero.
410      *
411      * CAUTION: This function is deprecated because it requires allocating memory for the error
412      * message unnecessarily. For custom revert reasons use {tryMod}.
413      *
414      * Counterpart to Solidity's `%` operator. This function uses a `revert`
415      * opcode (which leaves remaining gas untouched) while Solidity uses an
416      * invalid opcode to revert (consuming all remaining gas).
417      *
418      * Requirements:
419      *
420      * - The divisor cannot be zero.
421      */
422     function mod(
423         uint256 a,
424         uint256 b,
425         string memory errorMessage
426     ) internal pure returns (uint256) {
427         require(b > 0, errorMessage);
428         return a % b;
429     }
430 }
431 
432 // File: contracts/Pool.sol
433 
434 contract KawaPool is Ownable {
435     struct user {
436         uint256 staked;
437         uint256 withdrawn;
438         uint256[] stakeTimes;
439         uint256[] stakeAmounts;
440         uint256[] startingAPYLength;
441     }
442     using SafeMath for uint256;
443     uint256 public mintedTokens;
444     uint256 public totalStaked;
445     uint256[] apys;
446     uint256[] apyTimes;
447     mapping(address => user) public userList;
448     event StakeTokens(address indexed user, uint256 tokensStaked);
449     IERC20 stakeToken;
450     IERC20 xKawaToken;
451     mapping(address => uint256) earlyUnstake;
452 
453     constructor(
454         address tokenAddress,
455         address rewardTokenAddress,
456         uint256 initAPY
457     ) public {
458         stakeToken = IERC20(tokenAddress);
459         xKawaToken = IERC20(rewardTokenAddress);
460         apys.push(initAPY);
461         apyTimes.push(now);
462     }
463 
464     function userStaked(address addrToCheck) public view returns (uint256) {
465         return userList[addrToCheck].staked;
466     }
467 
468     function userClaimable(address addrToCheck)
469         public
470         view
471         returns (uint256 withdrawable)
472     {
473         if (xKawaToken.balanceOf(address(this)) > 0) {
474             withdrawable = calculateStaked(addrToCheck)
475             .add(earlyUnstake[addrToCheck])
476             .sub(userList[msg.sender].withdrawn);
477             if (withdrawable > xKawaToken.balanceOf(address(this))) {
478                 withdrawable = xKawaToken.balanceOf(address(this));
479             }
480         } else {
481             withdrawable = 0;
482         }
483     }
484 
485     function changeAPY(uint256 newAPY) external onlyOwner {
486         apys.push(newAPY);
487         apyTimes.push(now);
488     }
489 
490     function emergencyWithdraw() external onlyOwner {
491         require(
492             xKawaToken.transfer(
493                 msg.sender,
494                 xKawaToken.balanceOf(address(this))
495             ),
496             "Emergency withdrawl failed"
497         );
498     }
499 
500     function withdrawTokens() public {
501         //remove supplied
502         earlyUnstake[msg.sender] = userClaimable(msg.sender);
503         require(
504             stakeToken.transfer(msg.sender, userList[msg.sender].staked),
505             "Stake Token Transfer failed"
506         );
507         totalStaked = totalStaked.sub(userList[msg.sender].staked);
508         delete userList[msg.sender];
509     }
510 
511     function withdrawReward() public {
512         uint256 withdrawable = userClaimable(msg.sender);
513         require(
514             xKawaToken.transfer(msg.sender, withdrawable),
515             "Reward Token Transfer failed"
516         );
517         userList[msg.sender].withdrawn = userList[msg.sender].withdrawn.add(
518             withdrawable
519         );
520         delete earlyUnstake[msg.sender];
521         mintedTokens = mintedTokens.add(withdrawable);
522     }
523 
524     function claimAndWithdraw() public {
525         withdrawReward();
526         withdrawTokens();
527     }
528 
529     function stakeTokens(uint256 amountOfTokens) public {
530         totalStaked = totalStaked.add(amountOfTokens);
531         require(
532             stakeToken.transferFrom(msg.sender, address(this), amountOfTokens),
533             "Stake Token Transfer Failed"
534         );
535         userList[msg.sender].staked = userList[msg.sender].staked.add(
536             amountOfTokens
537         );
538         userList[msg.sender].stakeTimes.push(now);
539         userList[msg.sender].stakeAmounts.push(amountOfTokens);
540         userList[msg.sender].startingAPYLength.push(apys.length - 1);
541         emit StakeTokens(msg.sender, amountOfTokens);
542     }
543 
544     function calculateStaked(address usercheck)
545         public
546         view
547         returns (uint256 totalMinted)
548     {
549         totalMinted = 0;
550         for (uint256 i = 0; i < userList[usercheck].stakeAmounts.length; i++) {
551             //loop through everytime they have staked
552             for (
553                 uint256 j = userList[usercheck].startingAPYLength[i];
554                 j < apys.length;
555                 j++
556             ) {
557                 //for the i number of time they have staked, go through each apy times and values since they have staked (which is startingAPYLength)
558                 if (userList[usercheck].stakeTimes[i] < apyTimes[j]) {
559                     //this will happen if there is an APY change after the user has staked, since only after apy change can apy time > user staked time
560                     if (userList[usercheck].stakeTimes[i] < apyTimes[j - 1]) {
561                         //assuming there are 2 or more apy changes after staking, it will mean user has amount still staked in between the 2 apy
562                         totalMinted = totalMinted.add(
563                             (
564                                 userList[usercheck].stakeAmounts[i].mul(
565                                     (apyTimes[j].sub(apyTimes[j - 1]))
566                                 )
567                             )
568                             .mul(apys[j])
569                             .div(10**18)
570                         );
571                     } else {
572                         //will take place on the 1st apy change after staking
573                         totalMinted = totalMinted.add(
574                             (
575                                 userList[usercheck].stakeAmounts[i].mul(
576                                     (now.sub(apyTimes[j]))
577                                 )
578                             )
579                             .mul(apys[j])
580                             .div(10**18)
581                         );
582                     }
583                 } else {
584                     //Will take place only once for each iteration in i, as only once and the first time will apy time < user stake time
585                     totalMinted = totalMinted.add(
586                         (
587                             userList[usercheck].stakeAmounts[i].mul(
588                                 (now.sub(userList[usercheck].stakeTimes[i]))
589                             )
590                         )
591                         .mul(apys[j])
592                         .div(10**18)
593                     );
594                     //multiplies stake amount with time staked, divided by apy value which gives number of tokens to be minted
595                 }
596             }
597         }
598     }
599 }