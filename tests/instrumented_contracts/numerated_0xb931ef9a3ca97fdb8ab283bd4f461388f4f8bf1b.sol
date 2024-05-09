1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.7.2;
3 
4 /**
5  * @dev Wrappers over Solidity's arithmetic operations with added overflow
6  * checks.
7  *
8  * Arithmetic operations in Solidity wrap on overflow. This can easily result
9  * in bugs, because programmers usually assume that an overflow raises an
10  * error, which is the standard behavior in high level programming languages.
11  * `SafeMath` restores this intuition by reverting the transaction when an
12  * operation overflows.
13  *
14  * Using this library instead of the unchecked operations eliminates an entire
15  * class of bugs, so it's recommended to use it always.
16  */
17 library SafeMath {
18     /**
19      * @dev Returns the addition of two unsigned integers, reverting on
20      * overflow.
21      *
22      * Counterpart to Solidity's `+` operator.
23      *
24      * Requirements:
25      *
26      * - Addition cannot overflow.
27      */
28     function add(uint256 a, uint256 b) internal pure returns (uint256) {
29         uint256 c = a + b;
30         require(c >= a, "SafeMath: addition overflow");
31 
32         return c;
33     }
34 
35     /**
36      * @dev Returns the subtraction of two unsigned integers, reverting on
37      * overflow (when the result is negative).
38      *
39      * Counterpart to Solidity's `-` operator.
40      *
41      * Requirements:
42      *
43      * - Subtraction cannot overflow.
44      */
45     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
46         return sub(a, b, "SafeMath: subtraction overflow");
47     }
48 
49     /**
50      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
51      * overflow (when the result is negative).
52      *
53      * Counterpart to Solidity's `-` operator.
54      *
55      * Requirements:
56      *
57      * - Subtraction cannot overflow.
58      */
59     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
60         require(b <= a, errorMessage);
61         uint256 c = a - b;
62 
63         return c;
64     }
65 
66     /**
67      * @dev Returns the multiplication of two unsigned integers, reverting on
68      * overflow.
69      *
70      * Counterpart to Solidity's `*` operator.
71      *
72      * Requirements:
73      *
74      * - Multiplication cannot overflow.
75      */
76     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
77         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
78         // benefit is lost if 'b' is also tested.
79         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
80         if (a == 0) {
81             return 0;
82         }
83 
84         uint256 c = a * b;
85         require(c / a == b, "SafeMath: multiplication overflow");
86 
87         return c;
88     }
89 
90     /**
91      * @dev Returns the integer division of two unsigned integers. Reverts on
92      * division by zero. The result is rounded towards zero.
93      *
94      * Counterpart to Solidity's `/` operator. Note: this function uses a
95      * `revert` opcode (which leaves remaining gas untouched) while Solidity
96      * uses an invalid opcode to revert (consuming all remaining gas).
97      *
98      * Requirements:
99      *
100      * - The divisor cannot be zero.
101      */
102     function div(uint256 a, uint256 b) internal pure returns (uint256) {
103         return div(a, b, "SafeMath: division by zero");
104     }
105 
106     /**
107      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
108      * division by zero. The result is rounded towards zero.
109      *
110      * Counterpart to Solidity's `/` operator. Note: this function uses a
111      * `revert` opcode (which leaves remaining gas untouched) while Solidity
112      * uses an invalid opcode to revert (consuming all remaining gas).
113      *
114      * Requirements:
115      *
116      * - The divisor cannot be zero.
117      */
118     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
119         require(b > 0, errorMessage);
120         uint256 c = a / b;
121         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
122 
123         return c;
124     }
125 
126     /**
127      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
128      * Reverts when dividing by zero.
129      *
130      * Counterpart to Solidity's `%` operator. This function uses a `revert`
131      * opcode (which leaves remaining gas untouched) while Solidity uses an
132      * invalid opcode to revert (consuming all remaining gas).
133      *
134      * Requirements:
135      *
136      * - The divisor cannot be zero.
137      */
138     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
139         return mod(a, b, "SafeMath: modulo by zero");
140     }
141 
142     /**
143      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
144      * Reverts with custom message when dividing by zero.
145      *
146      * Counterpart to Solidity's `%` operator. This function uses a `revert`
147      * opcode (which leaves remaining gas untouched) while Solidity uses an
148      * invalid opcode to revert (consuming all remaining gas).
149      *
150      * Requirements:
151      *
152      * - The divisor cannot be zero.
153      */
154     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
155         require(b != 0, errorMessage);
156         return a % b;
157     }
158 }
159 
160 
161 /**
162  * @dev Collection of functions related to the address type
163  */
164 library Address {
165     /**
166      * @dev Returns true if `account` is a contract.
167      *
168      * [IMPORTANT]
169      * ====
170      * It is unsafe to assume that an address for which this function returns
171      * false is an externally-owned account (EOA) and not a contract.
172      *
173      * Among others, `isContract` will return false for the following
174      * types of addresses:
175      *
176      *  - an externally-owned account
177      *  - a contract in construction
178      *  - an address where a contract will be created
179      *  - an address where a contract lived, but was destroyed
180      * ====
181      */
182     function isContract(address account) internal view returns (bool) {
183         // This method relies in extcodesize, which returns 0 for contracts in
184         // construction, since the code is only stored at the end of the
185         // constructor execution.
186 
187         uint256 size;
188         // solhint-disable-next-line no-inline-assembly
189         assembly { size := extcodesize(account) }
190         return size > 0;
191     }
192 
193     /**
194      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
195      * `recipient`, forwarding all available gas and reverting on errors.
196      *
197      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
198      * of certain opcodes, possibly making contracts go over the 2300 gas limit
199      * imposed by `transfer`, making them unable to receive funds via
200      * `transfer`. {sendValue} removes this limitation.
201      *
202      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
203      *
204      * IMPORTANT: because control is transferred to `recipient`, care must be
205      * taken to not create reentrancy vulnerabilities. Consider using
206      * {ReentrancyGuard} or the
207      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
208      */
209     function sendValue(address payable recipient, uint256 amount) internal {
210         require(address(this).balance >= amount, "Address: insufficient balance");
211 
212         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
213         (bool success, ) = recipient.call{ value: amount }("");
214         require(success, "Address: unable to send value, recipient may have reverted");
215     }
216 
217     /**
218      * @dev Performs a Solidity function call using a low level `call`. A
219      * plain`call` is an unsafe replacement for a function call: use this
220      * function instead.
221      *
222      * If `target` reverts with a revert reason, it is bubbled up by this
223      * function (like regular Solidity function calls).
224      *
225      * Returns the raw returned data. To convert to the expected return value,
226      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
227      *
228      * Requirements:
229      *
230      * - `target` must be a contract.
231      * - calling `target` with `data` must not revert.
232      *
233      * _Available since v3.1._
234      */
235     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
236       return functionCall(target, data, "Address: low-level call failed");
237     }
238 
239     /**
240      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
241      * `errorMessage` as a fallback revert reason when `target` reverts.
242      *
243      * _Available since v3.1._
244      */
245     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
246         return _functionCallWithValue(target, data, 0, errorMessage);
247     }
248 
249     /**
250      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
251      * but also transferring `value` wei to `target`.
252      *
253      * Requirements:
254      *
255      * - the calling contract must have an ETH balance of at least `value`.
256      * - the called Solidity function must be `payable`.
257      *
258      * _Available since v3.1._
259      */
260     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
261         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
262     }
263 
264     /**
265      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
266      * with `errorMessage` as a fallback revert reason when `target` reverts.
267      *
268      * _Available since v3.1._
269      */
270     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
271         require(address(this).balance >= value, "Address: insufficient balance for call");
272         return _functionCallWithValue(target, data, value, errorMessage);
273     }
274 
275     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
276         require(isContract(target), "Address: call to non-contract");
277 
278         // solhint-disable-next-line avoid-low-level-calls
279         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
280         if (success) {
281             return returndata;
282         } else {
283             // Look for revert reason and bubble it up if present
284             if (returndata.length > 0) {
285                 // The easiest way to bubble the revert reason is using memory via assembly
286 
287                 // solhint-disable-next-line no-inline-assembly
288                 assembly {
289                     let returndata_size := mload(returndata)
290                     revert(add(32, returndata), returndata_size)
291                 }
292             } else {
293                 revert(errorMessage);
294             }
295         }
296     }
297 }
298 
299 
300 /**
301  * @dev Interface of the ERC20 standard as defined in the EIP.
302  */
303 interface IERC20 {
304     /**
305      * @dev Returns the amount of tokens in existence.
306      */
307     function totalSupply() external view returns (uint256);
308 
309     /**
310      * @dev Returns the amount of tokens owned by `account`.
311      */
312     function balanceOf(address account) external view returns (uint256);
313 
314     /**
315      * @dev Moves `amount` tokens from the caller's account to `recipient`.
316      *
317      * Returns a boolean value indicating whether the operation succeeded.
318      *
319      * Emits a {Transfer} event.
320      */
321     function transfer(address recipient, uint256 amount) external returns (bool);
322 
323     /**
324      * @dev Returns the remaining number of tokens that `spender` will be
325      * allowed to spend on behalf of `owner` through {transferFrom}. This is
326      * zero by default.
327      *
328      * This value changes when {approve} or {transferFrom} are called.
329      */
330     function allowance(address owner, address spender) external view returns (uint256);
331 
332     /**
333      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
334      *
335      * Returns a boolean value indicating whether the operation succeeded.
336      *
337      * IMPORTANT: Beware that changing an allowance with this method brings the risk
338      * that someone may use both the old and the new allowance by unfortunate
339      * transaction ordering. One possible solution to mitigate this race
340      * condition is to first reduce the spender's allowance to 0 and set the
341      * desired value afterwards:
342      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
343      *
344      * Emits an {Approval} event.
345      */
346     function approve(address spender, uint256 amount) external returns (bool);
347 
348     /**
349      * @dev Moves `amount` tokens from `sender` to `recipient` using the
350      * allowance mechanism. `amount` is then deducted from the caller's
351      * allowance.
352      *
353      * Returns a boolean value indicating whether the operation succeeded.
354      *
355      * Emits a {Transfer} event.
356      */
357     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
358 
359     /**
360      * @dev Emitted when `value` tokens are moved from one account (`from`) to
361      * another (`to`).
362      *
363      * Note that `value` may be zero.
364      */
365     event Transfer(address indexed from, address indexed to, uint256 value);
366 
367     /**
368      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
369      * a call to {approve}. `value` is the new allowance.
370      */
371     event Approval(address indexed owner, address indexed spender, uint256 value);
372 }
373 
374 /*
375  * @dev Provides information about the current execution context, including the
376  * sender of the transaction and its data. While these are generally available
377  * via msg.sender and msg.data, they should not be accessed in such a direct
378  * manner, since when dealing with GSN meta-transactions the account sending and
379  * paying for execution may not be the actual sender (as far as an application
380  * is concerned).
381  *
382  * This contract is only required for intermediate, library-like contracts.
383  */
384 abstract contract Context {
385     function _msgSender() internal view virtual returns (address payable) {
386         return msg.sender;
387     }
388 
389     function _msgData() internal view virtual returns (bytes memory) {
390         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
391         return msg.data;
392     }
393 }
394 
395 
396  /* @dev Contract module which provides a basic access control mechanism, where
397  * there is an account (an owner) that can be granted exclusive access to
398  * specific functions.
399  *
400  * By default, the owner account will be the one that deploys the contract. This
401  * can later be changed with {transferOwnership}.
402  *
403  * This module is used through inheritance. It will make available the modifier
404  * `onlyOwner`, which can be applied to your functions to restrict their use to
405  * the owner.
406  */
407 contract Ownable is Context {
408     address private _owner;
409 
410     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
411 
412     /**
413      * @dev Initializes the contract setting the deployer as the initial owner.
414      */
415     constructor () {
416         address msgSender = _msgSender();
417         _owner = msgSender;
418         emit OwnershipTransferred(address(0), msgSender);
419     }
420 
421     /**
422      * @dev Returns the address of the current owner.
423      */
424     function owner() public view returns (address) {
425         return _owner;
426     }
427 
428     /**
429      * @dev Throws if called by any account other than the owner.
430      */
431     modifier onlyOwner() {
432         require(_owner == _msgSender(), "Ownable: caller is not the owner");
433         _;
434     }
435 
436     /**
437      * @dev Transfers ownership of the contract to a new account (`newOwner`).
438      * Can only be called by the current owner.
439      */
440     function transferOwnership(address newOwner) public virtual onlyOwner {
441         require(newOwner != address(0), "Ownable: new owner is the zero address");
442         emit OwnershipTransferred(_owner, newOwner);
443         _owner = newOwner;
444     }
445 }
446 
447 contract YMF20Farm is Ownable {
448     using SafeMath for uint256;
449 
450     uint256 public farmYieldRate = 600;
451     uint256 public farmDecimals = 1e8;
452     IERC20 public yieldToken;
453     IERC20 public farmToken;
454     
455     struct Farm {
456         uint256 planted;
457         uint256 lastHarvest;
458     }
459     
460     mapping(address => Farm) farms;
461     
462     constructor() {
463         farmToken = IERC20(0x16bE21C08EB27953273608629e4397556c561D26);
464         yieldToken = IERC20(0x16bE21C08EB27953273608629e4397556c561D26);
465     }
466     
467     function lastHarvest(address _farmer) external view returns(uint256) {
468         return farms[_farmer].lastHarvest;
469     }
470     
471     function planted(address _farmer) external view returns(uint256) {
472         return farms[_farmer].planted;
473     }
474     
475     function newFarmer(uint256 _plant) public {
476         require(_plant > 0, "Cannot farm zero");
477         uint256 prevPlanted = farms[_msgSender()].planted;
478         
479         if (prevPlanted > 0) {
480             harvest();
481         }
482         _plant = _plant.add(prevPlanted);
483         require(farmToken.transferFrom(_msgSender(), address(this), _plant), "Could not transfer token to farm");
484         farms[_msgSender()] = Farm({lastHarvest: block.timestamp, planted: _plant});
485         emit NewFarmer(_msgSender(), _plant);
486     }
487     
488     function exit() public {
489         harvest();
490         _exit();
491     }
492     
493     function emergencyExit() public {
494         _exit();
495     }
496     
497     function _exit() internal {
498         Farm storage farm = farms[_msgSender()];
499         require(farmToken.transfer(_msgSender(), farm.planted), "Could not transfer farmed token");
500         farm.planted = 0;
501         emit Exit(_msgSender());
502     }
503     
504     function harvest() public {
505         Farm storage farm = farms[_msgSender()];
506         
507         if (farm.planted > 0) {
508             uint256 thisYield = _harvestable(farm);
509             farm.lastHarvest = block.timestamp;
510             
511             if (yieldToken.balanceOf(address(this)) < thisYield) {
512                  thisYield = yieldToken.balanceOf(address(this));
513             }
514             require(yieldToken.transfer(_msgSender(), thisYield), "Could not transfer yield token"); 
515             emit Harvest(_msgSender(), thisYield);
516         }
517     }
518     
519     function harvestable(address _farmer) public view returns(uint256) {
520         Farm memory farm = farms[_farmer];
521         return _harvestable(farm);
522     }
523     
524     function _harvestable(Farm memory _farm) internal view returns(uint256) {
525         uint256 duration = block.timestamp.sub(_farm.lastHarvest);
526         uint256 inFarmToken = _farm.planted.mul(duration).mul(1369).div(1e5).div(86400);
527         return toYieldToken(inFarmToken);
528     }
529     
530     function toYieldToken(uint256 _amount) public view returns(uint256) {
531         return _amount.mul(1e8).div(farmYieldRate).div(farmDecimals);
532     }
533     
534     function updateFarmYeidRate(uint256 _rate) public onlyOwner {
535         farmYieldRate = _rate;
536     }
537     
538     function adminWithdraw(uint256 _amount) public onlyOwner {
539         require(yieldToken.balanceOf(address(this)) >= _amount, "Not enough balance");
540         require(yieldToken.transfer(owner(), _amount), "Could not transfer yield token"); 
541     }
542     
543     event NewFarmer(address indexed farmer, uint256 amount);
544     event Exit(address indexed farmer);
545     event Harvest(address indexed farmer, uint256 amount);
546 }