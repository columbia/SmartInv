1 pragma solidity 0.6.12;
2 
3 /**
4  * @dev Wrappers over Solidity's arithmetic operations with added overflow
5  * checks.
6  *
7  * Arithmetic operations in Solidity wrap on overflow. This can easily result
8  * in bugs, because programmers usually assume that an overflow raises an
9  * error, which is the standard behavior in high level programming languages.
10  * `SafeMath` restores this intuition by reverting the transaction when an
11  * operation overflows.
12  *
13  * Using this library instead of the unchecked operations eliminates an entire
14  * class of bugs, so it's recommended to use it always.
15  */
16 library SafeMath {
17     /**
18      * @dev Returns the addition of two unsigned integers, reverting on
19      * overflow.
20      *
21      * Counterpart to Solidity's `+` operator.
22      *
23      * Requirements:
24      *
25      * - Addition cannot overflow.
26      */
27     function add(uint256 a, uint256 b) internal pure returns (uint256) {
28         uint256 c = a + b;
29         require(c >= a, "SafeMath: addition overflow");
30 
31         return c;
32     }
33 
34     /**
35      * @dev Returns the subtraction of two unsigned integers, reverting on
36      * overflow (when the result is negative).
37      *
38      * Counterpart to Solidity's `-` operator.
39      *
40      * Requirements:
41      *
42      * - Subtraction cannot overflow.
43      */
44     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
45         return sub(a, b, "SafeMath: subtraction overflow");
46     }
47 
48     /**
49      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
50      * overflow (when the result is negative).
51      *
52      * Counterpart to Solidity's `-` operator.
53      *
54      * Requirements:
55      *
56      * - Subtraction cannot overflow.
57      */
58     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
59         require(b <= a, errorMessage);
60         uint256 c = a - b;
61 
62         return c;
63     }
64 
65     /**
66      * @dev Returns the multiplication of two unsigned integers, reverting on
67      * overflow.
68      *
69      * Counterpart to Solidity's `*` operator.
70      *
71      * Requirements:
72      *
73      * - Multiplication cannot overflow.
74      */
75     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
76         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
77         // benefit is lost if 'b' is also tested.
78         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
79         if (a == 0) {
80             return 0;
81         }
82 
83         uint256 c = a * b;
84         require(c / a == b, "SafeMath: multiplication overflow");
85 
86         return c;
87     }
88 
89     /**
90      * @dev Returns the integer division of two unsigned integers. Reverts on
91      * division by zero. The result is rounded towards zero.
92      *
93      * Counterpart to Solidity's `/` operator. Note: this function uses a
94      * `revert` opcode (which leaves remaining gas untouched) while Solidity
95      * uses an invalid opcode to revert (consuming all remaining gas).
96      *
97      * Requirements:
98      *
99      * - The divisor cannot be zero.
100      */
101     function div(uint256 a, uint256 b) internal pure returns (uint256) {
102         return div(a, b, "SafeMath: division by zero");
103     }
104 
105     /**
106      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
107      * division by zero. The result is rounded towards zero.
108      *
109      * Counterpart to Solidity's `/` operator. Note: this function uses a
110      * `revert` opcode (which leaves remaining gas untouched) while Solidity
111      * uses an invalid opcode to revert (consuming all remaining gas).
112      *
113      * Requirements:
114      *
115      * - The divisor cannot be zero.
116      */
117     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
118         require(b > 0, errorMessage);
119         uint256 c = a / b;
120         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
121 
122         return c;
123     }
124 
125     /**
126      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
127      * Reverts when dividing by zero.
128      *
129      * Counterpart to Solidity's `%` operator. This function uses a `revert`
130      * opcode (which leaves remaining gas untouched) while Solidity uses an
131      * invalid opcode to revert (consuming all remaining gas).
132      *
133      * Requirements:
134      *
135      * - The divisor cannot be zero.
136      */
137     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
138         return mod(a, b, "SafeMath: modulo by zero");
139     }
140 
141     /**
142      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
143      * Reverts with custom message when dividing by zero.
144      *
145      * Counterpart to Solidity's `%` operator. This function uses a `revert`
146      * opcode (which leaves remaining gas untouched) while Solidity uses an
147      * invalid opcode to revert (consuming all remaining gas).
148      *
149      * Requirements:
150      *
151      * - The divisor cannot be zero.
152      */
153     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
154         require(b != 0, errorMessage);
155         return a % b;
156     }
157 }
158 
159 /*
160  * @dev Provides information about the current execution context, including the
161  * sender of the transaction and its data. While these are generally available
162  * via msg.sender and msg.data, they should not be accessed in such a direct
163  * manner, since when dealing with GSN meta-transactions the account sending and
164  * paying for execution may not be the actual sender (as far as an application
165  * is concerned).
166  *
167  * This contract is only required for intermediate, library-like contracts.
168  */
169 abstract contract Context {
170     function _msgSender() internal view virtual returns (address payable) {
171         return msg.sender;
172     }
173 
174     function _msgData() internal view virtual returns (bytes memory) {
175         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
176         return msg.data;
177     }
178 }
179 
180 /**
181  * @dev Contract module which provides a basic access control mechanism, where
182  * there is an account (an owner) that can be granted exclusive access to
183  * specific functions.
184  *
185  * By default, the owner account will be the one that deploys the contract. This
186  * can later be changed with {transferOwnership}.
187  *
188  * This module is used through inheritance. It will make available the modifier
189  * `onlyOwner`, which can be applied to your functions to restrict their use to
190  * the owner.
191  */
192 contract Ownable is Context {
193     address private _owner;
194 
195     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
196 
197     /**
198      * @dev Initializes the contract setting the deployer as the initial owner.
199      */
200     constructor () internal {
201         address msgSender = _msgSender();
202         _owner = msgSender;
203         emit OwnershipTransferred(address(0), msgSender);
204     }
205 
206     /**
207      * @dev Returns the address of the current owner.
208      */
209     function owner() public view returns (address) {
210         return _owner;
211     }
212 
213     /**
214      * @dev Throws if called by any account other than the owner.
215      */
216     modifier onlyOwner() {
217         require(_owner == _msgSender(), "Ownable: caller is not the owner");
218         _;
219     }
220 
221     /**
222      * @dev Leaves the contract without owner. It will not be possible to call
223      * `onlyOwner` functions anymore. Can only be called by the current owner.
224      *
225      * NOTE: Renouncing ownership will leave the contract without an owner,
226      * thereby removing any functionality that is only available to the owner.
227      */
228     function renounceOwnership() public virtual onlyOwner {
229         emit OwnershipTransferred(_owner, address(0));
230         _owner = address(0);
231     }
232 
233     /**
234      * @dev Transfers ownership of the contract to a new account (`newOwner`).
235      * Can only be called by the current owner.
236      */
237     function transferOwnership(address newOwner) public virtual onlyOwner {
238         require(newOwner != address(0), "Ownable: new owner is the zero address");
239         emit OwnershipTransferred(_owner, newOwner);
240         _owner = newOwner;
241     }
242 }
243 
244 /**
245  * @dev Interface of the ERC20 standard as defined in the EIP.
246  */
247 interface IERC20 {
248     /**
249      * @dev Returns the amount of tokens in existence.
250      */
251     function totalSupply() external view returns (uint256);
252 
253     /**
254      * @dev Returns the amount of tokens owned by `account`.
255      */
256     function balanceOf(address account) external view returns (uint256);
257 
258     /**
259      * @dev Moves `amount` tokens from the caller's account to `recipient`.
260      *
261      * Returns a boolean value indicating whether the operation succeeded.
262      *
263      * Emits a {Transfer} event.
264      */
265     function transfer(address recipient, uint256 amount) external returns (bool);
266 
267     /**
268      * @dev Returns the remaining number of tokens that `spender` will be
269      * allowed to spend on behalf of `owner` through {transferFrom}. This is
270      * zero by default.
271      *
272      * This value changes when {approve} or {transferFrom} are called.
273      */
274     function allowance(address owner, address spender) external view returns (uint256);
275 
276     /**
277      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
278      *
279      * Returns a boolean value indicating whether the operation succeeded.
280      *
281      * IMPORTANT: Beware that changing an allowance with this method brings the risk
282      * that someone may use both the old and the new allowance by unfortunate
283      * transaction ordering. One possible solution to mitigate this race
284      * condition is to first reduce the spender's allowance to 0 and set the
285      * desired value afterwards:
286      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
287      *
288      * Emits an {Approval} event.
289      */
290     function approve(address spender, uint256 amount) external returns (bool);
291 
292     /**
293      * @dev Moves `amount` tokens from `sender` to `recipient` using the
294      * allowance mechanism. `amount` is then deducted from the caller's
295      * allowance.
296      *
297      * Returns a boolean value indicating whether the operation succeeded.
298      *
299      * Emits a {Transfer} event.
300      */
301     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
302 
303     /**
304      * @dev Emitted when `value` tokens are moved from one account (`from`) to
305      * another (`to`).
306      *
307      * Note that `value` may be zero.
308      */
309     event Transfer(address indexed from, address indexed to, uint256 value);
310 
311     /**
312      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
313      * a call to {approve}. `value` is the new allowance.
314      */
315     event Approval(address indexed owner, address indexed spender, uint256 value);
316 }
317 
318 contract CurryStatic is Ownable {
319     using SafeMath for uint256;
320     
321     IERC20 public token;
322     
323     struct Stake {
324         uint256 amount;
325         uint256 reward;
326         uint256 stakeIndex;
327         uint256 lastclaimedBlock;
328         uint256 fee; 
329         uint256 rewardWithdrawn;
330         
331     }
332     
333     uint256 constant FEE_TO_STAKE = 1;
334     uint256 FEE_TO_UNSTAKE = 4;
335     
336     address[] private stakingAddresses;
337     mapping(address => Stake) public addressToStakeMap;
338     mapping(uint256 => uint256) public cumulativeblockToReward;
339     uint256 public totalAmountForDistribution;
340     uint256 public totalStakes;
341     uint256 public lastRewardFromChefUpdatedBlock;
342     uint256 public totalNumberOfStakers;
343     
344     address public teamAddress =  address(0); // change address
345     address public chefAddress =  address(0); // change address
346     
347     constructor(IERC20 _token) public {
348          token = _token;
349     }
350      modifier onlyChef() {
351         require(chefAddress == _msgSender(), "CurryStatic: caller is not the chefaddress");
352         _;
353     }
354     
355      // distribute function called by chef contract only
356     function distribute(uint256 amount) external onlyChef {
357         // update the total cumulative rewards where the tokens are sent from chef contract
358         totalAmountForDistribution = totalAmountForDistribution.add(amount);
359         lastRewardFromChefUpdatedBlock = block.number;
360         cumulativeblockToReward[lastRewardFromChefUpdatedBlock] = cumulativeblockToReward[lastRewardFromChefUpdatedBlock].add(totalAmountForDistribution);
361         
362     }
363     
364     // stake function
365     function stake(uint256 amount) public {
366         require(
367             amount != 0,
368             "amount cannot be zero"
369         );
370       
371         
372         Stake storage _stake = addressToStakeMap[_msgSender()];
373         
374         if (_stake.amount == 0) {
375             _stake.stakeIndex = stakingAddresses.length;
376             stakingAddresses.push(_msgSender());
377             // update the lastrewardblock to keep track that , when he staked how much rewards came from chef contract
378             // only first time update, as multiple time stake applicable
379             _stake.lastclaimedBlock = lastRewardFromChefUpdatedBlock;
380              totalNumberOfStakers = totalNumberOfStakers.add(1);
381         }
382         
383         uint256 fee = amount.mul(FEE_TO_STAKE).div(100); // 1% stake fee
384         uint256 amountAfterFee = amount.sub(fee);  // actual staked amount
385         totalStakes = totalStakes.add(amountAfterFee); // update total stakes
386         _stake.amount = _stake.amount.add(amountAfterFee); // store the staking amount
387         
388         
389         
390         // transfer tokens to this address
391         require(
392             token.transferFrom(_msgSender(), address(this), amountAfterFee),  
393             "transferFrom failed."
394         );
395         
396         // transfer the fee to teamaddress 
397         require(
398             token.transferFrom(_msgSender(), teamAddress, fee),
399             "transfer failed"
400         );
401       
402     }
403     
404     // withdraw function
405     function withdraw() public  {
406         Stake storage _stake = addressToStakeMap[_msgSender()];
407         if (_stake.amount == 0) {
408             revert("no amount to withdraw");
409         }
410         
411         uint256 fee = _stake.amount.mul(FEE_TO_UNSTAKE).div(100); // 4% unstake fee
412         uint256 amountAfterFee = _stake.amount.sub(fee);  // withdrawal amount 
413         
414         
415         // Get the reward came from chef contract
416         // logic: last updated cumultaive reward - his staked time cumulative reward 
417         _stake.reward = checkCurrentRewards(_msgSender());
418         
419         
420         // add the reward which got from chef contract via, distribute function calling from chef contract
421         uint256 withdrawlAmount = amountAfterFee.add(_stake.reward);
422         
423         // delete the user and update stake
424         totalStakes = totalStakes.sub(_stake.amount); // update stake
425         totalNumberOfStakers = totalNumberOfStakers.sub(1);
426         delete addressToStakeMap[_msgSender()];
427         
428          // transfer tokens to the user
429         require(
430             token.transfer(_msgSender(), withdrawlAmount),
431             "transfer failed"
432         );
433         
434         // transfer the fee to teamaddress
435         require(
436             token.transfer(teamAddress, fee),
437             "transfer failed"
438         );
439         
440        
441     
442     }
443     
444     // update token address called by owner only
445     function changeTokenAddress(IERC20 newAddr) public onlyOwner {
446         require(
447             newAddr != IERC20(0),
448             "zero address is not allowed"
449         );
450         
451         // token address can be changed when total stakers are 0
452         require(
453             totalNumberOfStakers == 0,
454             "stakers are present, can not change token address"
455         );
456         
457        token = newAddr;
458     }
459     
460       // update chef address called by owner only
461     function changeChefAddress(address newAddr) public onlyOwner {
462         require(
463             newAddr != address(0),
464             "zero address is not allowed"
465         );
466         
467        chefAddress = newAddr;
468     }
469     
470     // update team address called by owner only
471     function changeTeamAddress(address newAddr) public onlyOwner {
472         require(
473             newAddr != address(0),
474             "zero address is not allowed"
475         );
476         
477         teamAddress = newAddr;
478     }
479     
480     // withdraw tokens if no stakers are present
481      function withdrawUnClaimed() public onlyOwner {
482          require(
483             totalNumberOfStakers == 0,
484             "stakers are present, can not withdraw unclaimed"
485         );
486          require(
487             token.balanceOf(address(this)) != 0,
488             "totalAmountForDistribution is 0, can not claim"
489         );
490         
491          require(
492             token.transfer(teamAddress, token.balanceOf(address(this))),
493             "transfer failed"
494         );    
495       
496     }
497     
498     // check the current reward
499     function checkCurrentRewards(address user) public view returns (uint256) {
500         Stake storage _stake = addressToStakeMap[user];
501           // Get the reward came from chef contract
502         // logic: last updated cumultaive reward - his staked time cumulative reward 
503         uint256 totalRewardInStakeperiod = cumulativeblockToReward[lastRewardFromChefUpdatedBlock].sub(cumulativeblockToReward[_stake.lastclaimedBlock]);
504         // calculate his reward according to his stake amount
505         uint256 currReward = totalRewardInStakeperiod.mul(_stake.amount).div(totalStakes);
506         return currReward;
507     }
508     
509      // check staking amount
510     function checkStakingAmount(address user) public view returns (uint256) {
511         Stake storage _stake = addressToStakeMap[user];
512         return _stake.amount;
513     }
514     
515 
516 }