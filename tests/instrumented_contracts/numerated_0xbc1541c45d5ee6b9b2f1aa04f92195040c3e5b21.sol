1 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
2 
3 // SPDX-License-Identifier: MIT
4 
5 pragma solidity ^0.6.0;
6 
7 /**
8  * @dev Interface of the ERC20 standard as defined in the EIP.
9  */
10 interface IERC20 {
11     /**
12      * @dev Returns the amount of tokens in existence.
13      */
14     function totalSupply() external view returns (uint256);
15 
16     /**
17      * @dev Returns the amount of tokens owned by `account`.
18      */
19     function balanceOf(address account) external view returns (uint256);
20 
21     /**
22      * @dev Moves `amount` tokens from the caller's account to `recipient`.
23      *
24      * Returns a boolean value indicating whether the operation succeeded.
25      *
26      * Emits a {Transfer} event.
27      */
28     function transfer(address recipient, uint256 amount) external returns (bool);
29 
30     /**
31      * @dev Returns the remaining number of tokens that `spender` will be
32      * allowed to spend on behalf of `owner` through {transferFrom}. This is
33      * zero by default.
34      *
35      * This value changes when {approve} or {transferFrom} are called.
36      */
37     function allowance(address owner, address spender) external view returns (uint256);
38 
39     /**
40      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
41      *
42      * Returns a boolean value indicating whether the operation succeeded.
43      *
44      * IMPORTANT: Beware that changing an allowance with this method brings the risk
45      * that someone may use both the old and the new allowance by unfortunate
46      * transaction ordering. One possible solution to mitigate this race
47      * condition is to first reduce the spender's allowance to 0 and set the
48      * desired value afterwards:
49      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
50      *
51      * Emits an {Approval} event.
52      */
53     function approve(address spender, uint256 amount) external returns (bool);
54 
55     /**
56      * @dev Moves `amount` tokens from `sender` to `recipient` using the
57      * allowance mechanism. `amount` is then deducted from the caller's
58      * allowance.
59      *
60      * Returns a boolean value indicating whether the operation succeeded.
61      *
62      * Emits a {Transfer} event.
63      */
64     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
65 
66     /**
67      * @dev Emitted when `value` tokens are moved from one account (`from`) to
68      * another (`to`).
69      *
70      * Note that `value` may be zero.
71      */
72     event Transfer(address indexed from, address indexed to, uint256 value);
73 
74     /**
75      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
76      * a call to {approve}. `value` is the new allowance.
77      */
78     event Approval(address indexed owner, address indexed spender, uint256 value);
79 }
80 
81 // File: @openzeppelin/contracts/GSN/Context.sol
82 
83 
84 
85 pragma solidity ^0.6.0;
86 
87 /*
88  * @dev Provides information about the current execution context, including the
89  * sender of the transaction and its data. While these are generally available
90  * via msg.sender and msg.data, they should not be accessed in such a direct
91  * manner, since when dealing with GSN meta-transactions the account sending and
92  * paying for execution may not be the actual sender (as far as an application
93  * is concerned).
94  *
95  * This contract is only required for intermediate, library-like contracts.
96  */
97 abstract contract Context {
98     function _msgSender() internal view virtual returns (address payable) {
99         return msg.sender;
100     }
101 
102     function _msgData() internal view virtual returns (bytes memory) {
103         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
104         return msg.data;
105     }
106 }
107 
108 // File: @openzeppelin/contracts/access/Ownable.sol
109 
110 
111 pragma solidity ^0.6.0;
112 
113 /**
114  * @dev Contract module which provides a basic access control mechanism, where
115  * there is an account (an owner) that can be granted exclusive access to
116  * specific functions.
117  *
118  * By default, the owner account will be the one that deploys the contract. This
119  * can later be changed with {transferOwnership}.
120  *
121  * This module is used through inheritance. It will make available the modifier
122  * `onlyOwner`, which can be applied to your functions to restrict their use to
123  * the owner.
124  */
125 contract Ownable is Context {
126     address private _owner;
127 
128     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
129 
130     /**
131      * @dev Initializes the contract setting the deployer as the initial owner.
132      */
133     constructor () internal {
134         address msgSender = _msgSender();
135         _owner = msgSender;
136         emit OwnershipTransferred(address(0), msgSender);
137     }
138 
139     /**
140      * @dev Returns the address of the current owner.
141      */
142     function owner() public view returns (address) {
143         return _owner;
144     }
145 
146     /**
147      * @dev Throws if called by any account other than the owner.
148      */
149     modifier onlyOwner() {
150         require(_owner == _msgSender(), "Ownable: caller is not the owner");
151         _;
152     }
153 
154     /**
155      * @dev Leaves the contract without owner. It will not be possible to call
156      * `onlyOwner` functions anymore. Can only be called by the current owner.
157      *
158      * NOTE: Renouncing ownership will leave the contract without an owner,
159      * thereby removing any functionality that is only available to the owner.
160      */
161     function renounceOwnership() public virtual onlyOwner {
162         emit OwnershipTransferred(_owner, address(0));
163         _owner = address(0);
164     }
165 
166     /**
167      * @dev Transfers ownership of the contract to a new account (`newOwner`).
168      * Can only be called by the current owner.
169      */
170     function transferOwnership(address newOwner) public virtual onlyOwner {
171         require(newOwner != address(0), "Ownable: new owner is the zero address");
172         emit OwnershipTransferred(_owner, newOwner);
173         _owner = newOwner;
174     }
175 }
176 
177 // File: @openzeppelin/contracts/math/SafeMath.sol
178 
179 
180 
181 pragma solidity ^0.6.0;
182 
183 /**
184  * @dev Wrappers over Solidity's arithmetic operations with added overflow
185  * checks.
186  *
187  * Arithmetic operations in Solidity wrap on overflow. This can easily result
188  * in bugs, because programmers usually assume that an overflow raises an
189  * error, which is the standard behavior in high level programming languages.
190  * `SafeMath` restores this intuition by reverting the transaction when an
191  * operation overflows.
192  *
193  * Using this library instead of the unchecked operations eliminates an entire
194  * class of bugs, so it's recommended to use it always.
195  */
196 library SafeMath {
197     /**
198      * @dev Returns the addition of two unsigned integers, reverting on
199      * overflow.
200      *
201      * Counterpart to Solidity's `+` operator.
202      *
203      * Requirements:
204      *
205      * - Addition cannot overflow.
206      */
207     function add(uint256 a, uint256 b) internal pure returns (uint256) {
208         uint256 c = a + b;
209         require(c >= a, "SafeMath: addition overflow");
210 
211         return c;
212     }
213 
214     /**
215      * @dev Returns the subtraction of two unsigned integers, reverting on
216      * overflow (when the result is negative).
217      *
218      * Counterpart to Solidity's `-` operator.
219      *
220      * Requirements:
221      *
222      * - Subtraction cannot overflow.
223      */
224     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
225         return sub(a, b, "SafeMath: subtraction overflow");
226     }
227 
228     /**
229      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
230      * overflow (when the result is negative).
231      *
232      * Counterpart to Solidity's `-` operator.
233      *
234      * Requirements:
235      *
236      * - Subtraction cannot overflow.
237      */
238     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
239         require(b <= a, errorMessage);
240         uint256 c = a - b;
241 
242         return c;
243     }
244 
245     /**
246      * @dev Returns the multiplication of two unsigned integers, reverting on
247      * overflow.
248      *
249      * Counterpart to Solidity's `*` operator.
250      *
251      * Requirements:
252      *
253      * - Multiplication cannot overflow.
254      */
255     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
256         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
257         // benefit is lost if 'b' is also tested.
258         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
259         if (a == 0) {
260             return 0;
261         }
262 
263         uint256 c = a * b;
264         require(c / a == b, "SafeMath: multiplication overflow");
265 
266         return c;
267     }
268 
269     /**
270      * @dev Returns the integer division of two unsigned integers. Reverts on
271      * division by zero. The result is rounded towards zero.
272      *
273      * Counterpart to Solidity's `/` operator. Note: this function uses a
274      * `revert` opcode (which leaves remaining gas untouched) while Solidity
275      * uses an invalid opcode to revert (consuming all remaining gas).
276      *
277      * Requirements:
278      *
279      * - The divisor cannot be zero.
280      */
281     function div(uint256 a, uint256 b) internal pure returns (uint256) {
282         return div(a, b, "SafeMath: division by zero");
283     }
284 
285     /**
286      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
287      * division by zero. The result is rounded towards zero.
288      *
289      * Counterpart to Solidity's `/` operator. Note: this function uses a
290      * `revert` opcode (which leaves remaining gas untouched) while Solidity
291      * uses an invalid opcode to revert (consuming all remaining gas).
292      *
293      * Requirements:
294      *
295      * - The divisor cannot be zero.
296      */
297     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
298         require(b > 0, errorMessage);
299         uint256 c = a / b;
300         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
301 
302         return c;
303     }
304 
305     /**
306      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
307      * Reverts when dividing by zero.
308      *
309      * Counterpart to Solidity's `%` operator. This function uses a `revert`
310      * opcode (which leaves remaining gas untouched) while Solidity uses an
311      * invalid opcode to revert (consuming all remaining gas).
312      *
313      * Requirements:
314      *
315      * - The divisor cannot be zero.
316      */
317     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
318         return mod(a, b, "SafeMath: modulo by zero");
319     }
320 
321     /**
322      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
323      * Reverts with custom message when dividing by zero.
324      *
325      * Counterpart to Solidity's `%` operator. This function uses a `revert`
326      * opcode (which leaves remaining gas untouched) while Solidity uses an
327      * invalid opcode to revert (consuming all remaining gas).
328      *
329      * Requirements:
330      *
331      * - The divisor cannot be zero.
332      */
333     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
334         require(b != 0, errorMessage);
335         return a % b;
336     }
337 }
338 
339 // File: contracts/CrowdFund.sol
340 
341 pragma solidity 0.6.12;
342 
343 
344 
345 
346 contract CrowdFund is Ownable {
347     using SafeMath for uint256;
348     IERC20 public yfethToken;
349     mapping(address => bool) public isClaimed;
350     mapping(address => uint256) public ethContributed;
351     mapping(address => uint256) public refferer_earnings;
352 
353     address constant ETH_TOKEN_PLACHOLDER = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
354 
355     uint256 public immutable startTime;
356     uint256 public immutable endTime;
357     uint256 public constant referralRewardAmount = 500 finney; //0.5 yfeth
358     uint256 public constant claimRewardAmount = 3 ether;
359     uint256 public yfePerWei = 100; //stage 1
360     uint256 public totalEthContributed;
361 
362     uint256[] public canClaimIfHasThisMuchTokens;
363     address[] public canClaimIfHasTokens;
364 
365     event TokenWithdrawn(
366         address indexed token,
367         uint256 indexed amount,
368         address indexed dest
369     );
370     event EthContributed(
371         address indexed contributor,
372         uint256 indexed amount,
373         uint256 indexed yfeReceived
374     );
375 
376     constructor(
377         IERC20 _yfethToken,
378         uint256 _startTime,
379         uint256 _endTime,
380         address[] memory _canClaimIfHasTokens,
381         uint256[] memory _canClaimIfHasThisMuchTokens
382     ) public {
383         _updateClaimCondtions(
384             _canClaimIfHasTokens,
385             _canClaimIfHasThisMuchTokens
386         );
387         yfethToken = _yfethToken;
388         endTime = _endTime;
389         startTime = _startTime;
390     }
391 
392     function claim() external {
393         if (
394             !(isClaimed[msg.sender] ||
395                 now < startTime ||
396                 yfePerWei == 0 ||
397                 now >= endTime)
398         ) {
399             if (canClaim(msg.sender)) {
400                 require(yfethToken.transfer(msg.sender, claimRewardAmount));
401                 isClaimed[msg.sender] = true;
402             }
403         }
404     }
405 
406     function canClaim(address _who) public view returns (bool) {
407         for (uint8 i = 0; i < canClaimIfHasTokens.length; i++) {
408             if (
409                 IERC20(canClaimIfHasTokens[i]).balanceOf(_who) >=
410                 canClaimIfHasThisMuchTokens[i]
411             ) {
412                 return true;
413             }
414         }
415         return false;
416     }
417 
418     function _updateClaimCondtions(
419         address[] memory _canClaimIfHasTokens,
420         uint256[] memory _canClaimIfHasThisMuchTokens
421     ) internal {
422         require(
423             _canClaimIfHasTokens.length == _canClaimIfHasThisMuchTokens.length,
424             "CrowdFund: Invalid Input"
425         );
426         canClaimIfHasTokens = _canClaimIfHasTokens;
427         canClaimIfHasThisMuchTokens = _canClaimIfHasThisMuchTokens;
428     }
429 
430     function updateClaimCondtions(
431         address[] memory _canClaimIfHasTokens,
432         uint256[] memory _canClaimIfHasThisMuchTokens
433     ) public onlyOwner {
434         _updateClaimCondtions(
435             _canClaimIfHasTokens,
436             _canClaimIfHasThisMuchTokens
437         );
438     }
439 
440     function contribute(address _referrer) external payable {
441         //If you are early you just get your eth back
442         if (now < startTime || yfePerWei == 0 || now >= endTime) {
443             msg.sender.transfer(msg.value);
444         } else {
445             totalEthContributed = totalEthContributed.add(msg.value);
446             ethContributed[msg.sender] = ethContributed[msg.sender].add(
447                 msg.value
448             );
449 
450             require(ethContributed[msg.sender] <= 25 ether, "Limit reached");
451 
452             uint256 yfeToTransfer = yfePerWei.mul(msg.value);
453 
454             //transfer 0.5 yfe to the _referrer
455             //transfer yfeToTransfer to the msg.sender
456             emit EthContributed(msg.sender, msg.value, yfeToTransfer);
457             require(yfethToken.transfer(msg.sender, yfeToTransfer));
458             //limit for refferer to earn maximum of 25 yfe tokens
459             if (
460                 _referrer != address(0) &&
461                 refferer_earnings[_referrer] <= 25 ether &&
462                 _referrer != msg.sender
463             ) {
464                 refferer_earnings[_referrer] = refferer_earnings[_referrer].add(
465                     referralRewardAmount
466                 );
467                 require(yfethToken.transfer(_referrer, referralRewardAmount));
468             }
469 
470             if (totalEthContributed > 550 ether && yfePerWei == 50) {
471                 //end
472                 yfePerWei = 0;
473             } else if (totalEthContributed > 250 ether && yfePerWei == 75) {
474                 //stage 3 starts
475                 yfePerWei = 50;
476             } else if (totalEthContributed > 85 ether && yfePerWei == 100) {
477                 //stage 2 starts
478                 yfePerWei = 75;
479             }
480         }
481     }
482 
483     /**
484      * @notice Transfers all tokens of the input adress to the recipient. This is
485      * useful tokens are accidentally sent to this contrasct
486      * @param _tokenAddress address of token to send
487      * @param _dest destination address to send tokens to
488      */
489     function withdrawToken(address _tokenAddress, address _dest)
490         external
491         onlyOwner
492     {
493         uint256 _balance = IERC20(_tokenAddress).balanceOf(address(this));
494         emit TokenWithdrawn(_tokenAddress, _balance, _dest);
495         require(IERC20(_tokenAddress).transfer(_dest, _balance));
496     }
497 
498     /**
499      * @notice Transfers all Ether to the specified address
500      * @param _dest destination address to send ETH to
501      */
502     function withdrawEther(address payable _dest) external onlyOwner {
503         uint256 _balance = address(this).balance;
504         emit TokenWithdrawn(ETH_TOKEN_PLACHOLDER, _balance, _dest);
505         _dest.transfer(_balance);
506     }
507 }