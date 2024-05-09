1 // File: contracts/OpenZepplinOwnable.sol
2 
3 pragma solidity ^0.5.0;
4 
5 contract Context {
6     // Empty internal constructor, to prevent people from mistakenly deploying
7     // an instance of this contract, which should be used via inheritance.
8     constructor () internal { }
9     // solhint-disable-previous-line no-empty-blocks
10 
11     function _msgSender() internal view returns (address payable) {
12         return msg.sender;
13     }
14 
15     function _msgData() internal view returns (bytes memory) {
16         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
17         return msg.data;
18     }
19 }
20 
21 /**
22  * @dev Contract module which provides a basic access control mechanism, where
23  * there is an account (an owner) that can be granted exclusive access to
24  * specific functions.
25  *
26  * This module is used through inheritance. It will make available the modifier
27  * `onlyOwner`, which can be applied to your functions to restrict their use to
28  * the owner.
29  */
30 contract Ownable is Context {
31     address payable public _owner;
32 
33     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
34 
35     /**
36      * @dev Initializes the contract setting the deployer as the initial owner.
37      */
38     constructor () internal {
39         address payable msgSender = _msgSender();
40         _owner = msgSender;
41         emit OwnershipTransferred(address(0), msgSender);
42     }
43 
44     /**
45      * @dev Returns the address of the current owner.
46      */
47     function owner() public view returns (address) {
48         return _owner;
49     }
50 
51     /**
52      * @dev Throws if called by any account other than the owner.
53      */
54     modifier onlyOwner() {
55         require(isOwner(), "Ownable: caller is not the owner");
56         _;
57     }
58 
59     /**
60      * @dev Returns true if the caller is the current owner.
61      */
62     function isOwner() public view returns (bool) {
63         return _msgSender() == _owner;
64     }
65 
66     /**
67      * @dev Leaves the contract without owner. It will not be possible to call
68      * `onlyOwner` functions anymore. Can only be called by the current owner.
69      *
70      * NOTE: Renouncing ownership will leave the contract without an owner,
71      * thereby removing any functionality that is only available to the owner.
72      */
73     function renounceOwnership() public onlyOwner {
74         emit OwnershipTransferred(_owner, address(0));
75         _owner = address(0);
76     }
77 
78     /**
79      * @dev Transfers ownership of the contract to a new account (`newOwner`).
80      * Can only be called by the current owner.
81      */
82     function transferOwnership(address payable newOwner) public onlyOwner {
83         _transferOwnership(newOwner);
84     }
85 
86     /**
87      * @dev Transfers ownership of the contract to a new account (`newOwner`).
88      */
89     function _transferOwnership(address payable newOwner) internal {
90         require(newOwner != address(0), "Ownable: new owner is the zero address");
91         emit OwnershipTransferred(_owner, newOwner);
92         _owner = newOwner;
93     }
94 }
95 
96 // File: contracts/OpenZepplinSafeMath.sol
97 
98 pragma solidity ^0.5.0;
99 
100 /**
101  * @dev Wrappers over Solidity's arithmetic operations with added overflow
102  * checks.
103  *
104  * Arithmetic operations in Solidity wrap on overflow. This can easily result
105  * in bugs, because programmers usually assume that an overflow raises an
106  * error, which is the standard behavior in high level programming languages.
107  * `SafeMath` restores this intuition by reverting the transaction when an
108  * operation overflows.
109  *
110  * Using this library instead of the unchecked operations eliminates an entire
111  * class of bugs, so it's recommended to use it always.
112  */
113 library SafeMath {
114     /**
115      * @dev Returns the addition of two unsigned integers, reverting on
116      * overflow.
117      *
118      * Counterpart to Solidity's `+` operator.
119      *
120      * Requirements:
121      * - Addition cannot overflow.
122      */
123     function add(uint256 a, uint256 b) internal pure returns (uint256) {
124         uint256 c = a + b;
125         require(c >= a, "SafeMath: addition overflow");
126 
127         return c;
128     }
129 
130     /**
131      * @dev Returns the subtraction of two unsigned integers, reverting on
132      * overflow (when the result is negative).
133      *
134      * Counterpart to Solidity's `-` operator.
135      *
136      * Requirements:
137      * - Subtraction cannot overflow.
138      */
139     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
140         return sub(a, b, "SafeMath: subtraction overflow");
141     }
142 
143     /**
144      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
145      * overflow (when the result is negative).
146      *
147      * Counterpart to Solidity's `-` operator.
148      *
149      * Requirements:
150      * - Subtraction cannot overflow.
151      *
152      * _Available since v2.4.0._
153      */
154     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
155         require(b <= a, errorMessage);
156         uint256 c = a - b;
157 
158         return c;
159     }
160 
161     /**
162      * @dev Returns the multiplication of two unsigned integers, reverting on
163      * overflow.
164      *
165      * Counterpart to Solidity's `*` operator.
166      *
167      * Requirements:
168      * - Multiplication cannot overflow.
169      */
170     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
171         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
172         // benefit is lost if 'b' is also tested.
173         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
174         if (a == 0) {
175             return 0;
176         }
177 
178         uint256 c = a * b;
179         require(c / a == b, "SafeMath: multiplication overflow");
180 
181         return c;
182     }
183 
184     /**
185      * @dev Returns the integer division of two unsigned integers. Reverts on
186      * division by zero. The result is rounded towards zero.
187      *
188      * Counterpart to Solidity's `/` operator. Note: this function uses a
189      * `revert` opcode (which leaves remaining gas untouched) while Solidity
190      * uses an invalid opcode to revert (consuming all remaining gas).
191      *
192      * Requirements:
193      * - The divisor cannot be zero.
194      */
195     function div(uint256 a, uint256 b) internal pure returns (uint256) {
196         return div(a, b, "SafeMath: division by zero");
197     }
198 
199     /**
200      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
201      * division by zero. The result is rounded towards zero.
202      *
203      * Counterpart to Solidity's `/` operator. Note: this function uses a
204      * `revert` opcode (which leaves remaining gas untouched) while Solidity
205      * uses an invalid opcode to revert (consuming all remaining gas).
206      *
207      * Requirements:
208      * - The divisor cannot be zero.
209      *
210      * _Available since v2.4.0._
211      */
212     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
213         // Solidity only automatically asserts when dividing by 0
214         require(b > 0, errorMessage);
215         uint256 c = a / b;
216         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
217 
218         return c;
219     }
220 
221     /**
222      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
223      * Reverts when dividing by zero.
224      *
225      * Counterpart to Solidity's `%` operator. This function uses a `revert`
226      * opcode (which leaves remaining gas untouched) while Solidity uses an
227      * invalid opcode to revert (consuming all remaining gas).
228      *
229      * Requirements:
230      * - The divisor cannot be zero.
231      */
232     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
233         return mod(a, b, "SafeMath: modulo by zero");
234     }
235 
236     /**
237      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
238      * Reverts with custom message when dividing by zero.
239      *
240      * Counterpart to Solidity's `%` operator. This function uses a `revert`
241      * opcode (which leaves remaining gas untouched) while Solidity uses an
242      * invalid opcode to revert (consuming all remaining gas).
243      *
244      * Requirements:
245      * - The divisor cannot be zero.
246      *
247      * _Available since v2.4.0._
248      */
249     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
250         require(b != 0, errorMessage);
251         return a % b;
252     }
253 }
254 
255 // File: contracts/OpenZepplinIERC20.sol
256 
257 pragma solidity ^0.5.0;
258 
259 /**
260  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
261  * the optional functions; to access them see {ERC20Detailed}.
262  */
263 interface IERC20 {
264     /**
265      * @dev Returns the amount of tokens in existence.
266      */
267     function totalSupply() external view returns (uint256);
268 
269     /**
270      * @dev Returns the amount of tokens owned by `account`.
271      */
272     function balanceOf(address account) external view returns (uint256);
273 
274     /**
275      * @dev Moves `amount` tokens from the caller's account to `recipient`.
276      *
277      * Returns a boolean value indicating whether the operation succeeded.
278      *
279      * Emits a {Transfer} event.
280      */
281     function transfer(address recipient, uint256 amount) external returns (bool);
282 
283     /**
284      * @dev Returns the remaining number of tokens that `spender` will be
285      * allowed to spend on behalf of `owner` through {transferFrom}. This is
286      * zero by default.
287      *
288      * This value changes when {approve} or {transferFrom} are called.
289      */
290     function allowance(address owner, address spender) external view returns (uint256);
291 
292     /**
293      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
294      *
295      * Returns a boolean value indicating whether the operation succeeded.
296      *
297      * IMPORTANT: Beware that changing an allowance with this method brings the risk
298      * that someone may use both the old and the new allowance by unfortunate
299      * transaction ordering. One possible solution to mitigate this race
300      * condition is to first reduce the spender's allowance to 0 and set the
301      * desired value afterwards:
302      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
303      *
304      * Emits an {Approval} event.
305      */
306     function approve(address spender, uint256 amount) external returns (bool);
307 
308     /**
309      * @dev Moves `amount` tokens from `sender` to `recipient` using the
310      * allowance mechanism. `amount` is then deducted from the caller's
311      * allowance.
312      *
313      * Returns a boolean value indicating whether the operation succeeded.
314      *
315      * Emits a {Transfer} event.
316      */
317     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
318 
319     /**
320      * @dev Emitted when `value` tokens are moved from one account (`from`) to
321      * another (`to`).
322      *
323      * Note that `value` may be zero.
324      */
325     event Transfer(address indexed from, address indexed to, uint256 value);
326 
327     /**
328      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
329      * a call to {approve}. `value` is the new allowance.
330      */
331     event Approval(address indexed owner, address indexed spender, uint256 value);
332 }
333 
334 // File: contracts/OpenZepplinReentrancyGuard.sol
335 
336 pragma solidity ^0.5.0;
337 
338 /**
339  * @dev Contract module that helps prevent reentrant calls to a function.
340  *
341  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
342  * available, which can be applied to functions to make sure there are no nested
343  * (reentrant) calls to them.
344  *
345  * Note that because there is a single `nonReentrant` guard, functions marked as
346  * `nonReentrant` may not call one another. This can be worked around by making
347  * those functions `private`, and then adding `external` `nonReentrant` entry
348  * points to them.
349  *
350  * _Since v2.5.0:_ this module is now much more gas efficient, given net gas
351  * metering changes introduced in the Istanbul hardfork.
352  */
353 contract ReentrancyGuard {
354     bool private _notEntered;
355 
356     constructor () internal {
357         // Storing an initial non-zero value makes deployment a bit more
358         // expensive, but in exchange the refund on every call to nonReentrant
359         // will be lower in amount. Since refunds are capped to a percetange of
360         // the total transaction's gas, it is best to keep them low in cases
361         // like this one, to increase the likelihood of the full refund coming
362         // into effect.
363         _notEntered = true;
364     }
365 
366     /**
367      * @dev Prevents a contract from calling itself, directly or indirectly.
368      * Calling a `nonReentrant` function from another `nonReentrant`
369      * function is not supported. It is possible to prevent this from happening
370      * by making the `nonReentrant` function external, and make it call a
371      * `private` function that does the actual work.
372      */
373     modifier nonReentrant() {
374         // On the first call to nonReentrant, _notEntered will be true
375         require(_notEntered, "ReentrancyGuard: reentrant call");
376 
377         // Any calls to nonReentrant after this point will fail
378         _notEntered = false;
379 
380         _;
381 
382         // By storing the original value once again, a refund is triggered (see
383         // https://eips.ethereum.org/EIPS/eip-2200)
384         _notEntered = true;
385     }
386 }
387 
388 // File: contracts/UniSwap_ETH_DAIZap.sol
389 
390 pragma solidity ^0.5.0;
391 
392 
393 
394 
395 
396 // the objective of this contract is only to get the exchange price of the assets from the uniswap indexed
397 
398 interface UniSwapAddLiquityV2_General {
399     function LetsInvest(address _TokenContractAddress, address _towhomtoissue) external payable returns (uint);
400 }
401 
402 contract UniSwap_ETH_DAIZap is Ownable, ReentrancyGuard {
403     using SafeMath for uint;
404 
405     // state variables
406     uint public balance = address(this).balance;
407     
408     
409     // in relation to the emergency functioning of this contract
410     bool private stopped = false;
411      
412     // circuit breaker modifiers
413     modifier stopInEmergency {if (!stopped) _;}
414     modifier onlyInEmergency {if (stopped) _;}
415     
416     address public DAI_TokenContractAddress;
417     UniSwapAddLiquityV2_General public UniSwapAddLiquityV2_GeneralAddress;
418     
419 
420     constructor(address _DAI_TokenContractAddress, UniSwapAddLiquityV2_General _UniSwapAddLiquityV2_GeneralAddress ) public {
421         DAI_TokenContractAddress = _DAI_TokenContractAddress;
422         UniSwapAddLiquityV2_GeneralAddress = _UniSwapAddLiquityV2_GeneralAddress;
423     }
424 
425     function set_new_DAI_TokenContractAddress(address _new_DAI_TokenContractAddress) public onlyOwner {
426         DAI_TokenContractAddress = _new_DAI_TokenContractAddress;
427     }
428 
429     function set_new_UniSwapAddLiquityV2_GeneralAddress(UniSwapAddLiquityV2_General _new_UniSwapAddLiquityV2_GeneralAddress) public onlyOwner {
430         UniSwapAddLiquityV2_GeneralAddress = _new_UniSwapAddLiquityV2_GeneralAddress;
431     }
432 
433     function LetsInvest() public payable stopInEmergency {
434         UniSwapAddLiquityV2_GeneralAddress.LetsInvest.value(msg.value)(DAI_TokenContractAddress, address(msg.sender));
435 
436     }
437 
438 
439     // - this function lets you deposit ETH into this wallet
440     function depositETH() public payable  onlyOwner {
441         balance += msg.value;
442     }
443     
444     // - fallback function let you / anyone send ETH to this wallet without the need to call any function
445     function() external payable {
446         if (msg.sender == _owner) {
447             depositETH();
448         } else {
449             LetsInvest();
450         }
451     }
452     
453     // - to withdraw any ETH balance sitting in the contract
454     function withdraw() public onlyOwner {
455         _owner.transfer(address(this).balance);
456     }
457 
458 
459 }