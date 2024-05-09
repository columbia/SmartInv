1 /*
2 
3  ▄▄▄▄▄▄▄▄▄▄▄ ▄▄▄▄▄▄▄▄▄▄▄ ▄           ▄    ▄ ▄▄▄▄▄▄▄▄▄▄▄ ▄▄▄▄▄▄▄▄▄▄  ▄▄▄▄▄▄▄▄▄▄▄ ▄▄▄▄▄▄▄▄▄▄▄ ▄▄▄▄▄▄▄▄▄▄▄ 
4 ▐░░░░░░░░░░░▐░░░░░░░░░░░▐░▌         ▐░▌  ▐░▐░░░░░░░░░░░▐░░░░░░░░░░▌▐░░░░░░░░░░░▐░░░░░░░░░░░▐░░░░░░░░░░░▌
5 ▐░█▀▀▀▀▀▀▀█░▐░█▀▀▀▀▀▀▀█░▐░▌         ▐░▌ ▐░▌▐░█▀▀▀▀▀▀▀█░▐░█▀▀▀▀▀▀▀█░▐░█▀▀▀▀▀▀▀█░▐░█▀▀▀▀▀▀▀▀▀▐░█▀▀▀▀▀▀▀▀▀ 
6 ▐░▌       ▐░▐░▌       ▐░▐░▌         ▐░▌▐░▌ ▐░▌       ▐░▐░▌       ▐░▐░▌       ▐░▐░▌         ▐░▌          
7 ▐░█▄▄▄▄▄▄▄█░▐░▌       ▐░▐░▌         ▐░▌░▌  ▐░█▄▄▄▄▄▄▄█░▐░▌       ▐░▐░▌       ▐░▐░▌ ▄▄▄▄▄▄▄▄▐░█▄▄▄▄▄▄▄▄▄ 
8 ▐░░░░░░░░░░░▐░▌       ▐░▐░▌         ▐░░▌   ▐░░░░░░░░░░░▐░▌       ▐░▐░▌       ▐░▐░▌▐░░░░░░░░▐░░░░░░░░░░░▌
9 ▐░█▀▀▀▀▀▀▀▀▀▐░▌       ▐░▐░▌         ▐░▌░▌  ▐░█▀▀▀▀▀▀▀█░▐░▌       ▐░▐░▌       ▐░▐░▌ ▀▀▀▀▀▀█░▐░█▀▀▀▀▀▀▀▀▀ 
10 ▐░▌         ▐░▌       ▐░▐░▌         ▐░▌▐░▌ ▐░▌       ▐░▐░▌       ▐░▐░▌       ▐░▐░▌       ▐░▐░▌          
11 ▐░▌         ▐░█▄▄▄▄▄▄▄█░▐░█▄▄▄▄▄▄▄▄▄▐░▌ ▐░▌▐░▌       ▐░▐░█▄▄▄▄▄▄▄█░▐░█▄▄▄▄▄▄▄█░▐░█▄▄▄▄▄▄▄█░▐░█▄▄▄▄▄▄▄▄▄ 
12 ▐░▌         ▐░░░░░░░░░░░▐░░░░░░░░░░░▐░▌  ▐░▐░▌       ▐░▐░░░░░░░░░░▌▐░░░░░░░░░░░▐░░░░░░░░░░░▐░░░░░░░░░░░▌
13  ▀           ▀▀▀▀▀▀▀▀▀▀▀ ▀▀▀▀▀▀▀▀▀▀▀ ▀    ▀ ▀         ▀ ▀▀▀▀▀▀▀▀▀▀  ▀▀▀▀▀▀▀▀▀▀▀ ▀▀▀▀▀▀▀▀▀▀▀ ▀▀▀▀▀▀▀▀▀▀▀ 
14                                                                                                         
15                                                                                 
16                                      ,(((((%%%%%%%%%%%(((((                             
17                                (((%%,,,,,,,,,,,,,,,,,,,,,,,,,&%(((                      
18                            ((&&,,,,., ,,,,,,,,,,,,,,,,,,,,,,,,,,,,%%((                  
19                        ((%%,,,,,,,,,,,  ,,,,,,,,,,,,,,,,,,,,,,    ,,,,&%(               
20                      (%%,,,,,,,,,,, ,,   ,,,,,,,,,,,,,,,,,,(,,,,   ,,,,,,%((            
21                   ((%,,,,,,,,,,,,,, ,,, ,,,,,,,,,,,,,,,,,(&(((      ,,,,,,,,&(          
22                  (%,,,,,,,,,,,,,,,. ,,,,,,,,,,*@@@@@@,*((&(         ,,,,,,,,,,&(        
23                (%,,,,,,,,,,,,,  ,,,,...@@@@@((,,,,,,,,,(&%((((     ,,,,,,,,,,,,,&(      
24               (%,,,,,,,,,,, ,@@@@@.....@@@@@@,,,,,,,,,@@@((        ,,,,,,,,,,,,,,%(     
25             ((%,,,,,,,,,,   @@@. @@,,.,,,,,,,,,,,,,,,@@@@@@@&   ,,,,,,,,,,,,,,,,,,%(*   
26            /(%,,,,,,,,,,  ,,,,%.@@@,,,,,,,,,,,,,,,,,,,@@@@@@,,,,%%,,,,,,,,,,,,,,,,,%(   
27            (%,,,,,,,,,,, .@@,,,,%*,,,,,,,,,,@, @@@@,,,,,,,,,       @@(,,,,,,,,,,,,,,%(  
28           (%,,,,,,,,,,,  @@,,,,,,,,,,,,,,,,,&@,,&,,,,,, &&&&##&&&&&&### ,,,,,,,,,,,,,%( 
29           (%,,,,,,,,,,,  ,,,@@@@@@&,,,,,,@@@@,,,,,,,, &&&&&@ .,@@   #####& ,,,,,,,,,,%( 
30           (&,,,,,,,,,,   ,,@@@@@@@@%,,,@@@@@@@,,,,, &&&# ,,,,,,    ,,, &&&&@,,,,,,,,,%( 
31          ((,,,,,,,,,,, , ,,%&@@@@%*,,,,,@@@@@@,,,, &&&& ,,,,,,,    ,,,,, #&&&,,,,,,,,%( 
32           (%,,,,,,,,,,   ,,%%%%%%&,,,,,,,,,,,,,,,,&&&& ,,, &&&     ,, ,,(.%&& ,,,,,,,%( 
33           (&,,,,,,,,,,.  ,,,%%%%%%&@,,,,%%@%,,,,,,(### ,,,,##&    ,  ,,,, &#& ,,,,,,,%( 
34           (%,,,,,,,,,,,   ,,,,%%%%%,%%,%%%&,,,,,,, &&&@,, ##&@   *     , &&&&,,,,,,,,%( 
35            (%,,,,,,,,,,,    ,,,,,,,,,,,,,,@@@@,,,,,, ,,, &&&&      &   &&&&%,,,,,,,,%(  
36            .(%,,,,,,,,,, ,   ,,,,,,,,,,,,&@@@@,,,,   ,,, &&&&  .%%  ###&&& ,,,,,,,,%(   
37             /(%,,,,,,,,, .,,,,           ,,,, @@@@,,,,,,&@###&&&&&##&&@ ,, ,,,,,,,%(    
38               (%,,,,,,,, ,,,,,,@@@@@@@@@@,,,,@@@@@@,,,, &&&&&&     ,,,,,   ,,,,,,%(     
39                (&,,,,,, ,,,,,,,,@@@@@@@&,,,,,,@@@@,,,,,&&&& ,,,,,....,,,   ,,,,,#(      
40                  (%,,,, ,@@@@@,,,,,,,,,,,,,,,,,,,,,,,, ##&%,,.#### ...,,   ,,,%(        
41                    (%, ,,,#&,,,,,,,,,,,,,,,,,@@@@,,,,, &&@....*### .,,     ,%(          
42                      ((%,,,,,,,,,@@@,,,,,,,,,@@@@,,,...............,     %((            
43                         (#%,,,,@@@@@@@,,,,,,,,,,.................     %((               
44                            ((%%,&@@@&,,,,,,,,..................,,,%&((                  
45                                (((%%#,.................,,,,,%&&(((                      
46                                       ((((((%%%%%&%%%((((((                             
47 
48 
49                                     TG: t.me/polkadogecoin
50                                     Website: polkadoge.fi
51 
52 */
53 
54 // SPDX-License-Identifier: Unlicensed
55 pragma solidity ^0.6.12;
56 
57 interface IERC20 {
58 
59     function totalSupply() external view returns (uint256);
60 
61     /**
62      * @dev Returns the amount of tokens owned by `account`.
63      */
64     function balanceOf(address account) external view returns (uint256);
65 
66     /**
67      * @dev Moves `amount` tokens from the caller's account to `recipient`.
68      *
69      * Returns a boolean value indicating whether the operation succeeded.
70      *
71      * Emits a {Transfer} event.
72      */
73     function transfer(address recipient, uint256 amount) external returns (bool);
74 
75     /**
76      * @dev Returns the remaining number of tokens that `spender` will be
77      * allowed to spend on behalf of `owner` through {transferFrom}. This is
78      * zero by default.
79      *
80      * This value changes when {approve} or {transferFrom} are called.
81      */
82     function allowance(address owner, address spender) external view returns (uint256);
83 
84     /**
85      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
86      *
87      * Returns a boolean value indicating whether the operation succeeded.
88      *
89      * IMPORTANT: Beware that changing an allowance with this method brings the risk
90      * that someone may use both the old and the new allowance by unfortunate
91      * transaction ordering. One possible solution to mitigate this race
92      * condition is to first reduce the spender's allowance to 0 and set the
93      * desired value afterwards:
94      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
95      *
96      * Emits an {Approval} event.
97      */
98     function approve(address spender, uint256 amount) external returns (bool);
99 
100     /**
101      * @dev Moves `amount` tokens from `sender` to `recipient` using the
102      * allowance mechanism. `amount` is then deducted from the caller's
103      * allowance.
104      *
105      * Returns a boolean value indicating whether the operation succeeded.
106      *
107      * Emits a {Transfer} event.
108      */
109     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
110 
111     /**
112      * @dev Emitted when `value` tokens are moved from one account (`from`) to
113      * another (`to`).
114      *
115      * Note that `value` may be zero.
116      */
117     event Transfer(address indexed from, address indexed to, uint256 value);
118 
119     /**
120      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
121      * a call to {approve}. `value` is the new allowance.
122      */
123     event Approval(address indexed owner, address indexed spender, uint256 value);
124 }
125 
126 
127 
128 /**
129  * @dev Wrappers over Solidity's arithmetic operations with added overflow
130  * checks.
131  *
132  * Arithmetic operations in Solidity wrap on overflow. This can easily result
133  * in bugs, because programmers usually assume that an overflow raises an
134  * error, which is the standard behavior in high level programming languages.
135  * `SafeMath` restores this intuition by reverting the transaction when an
136  * operation overflows.
137  *
138  * Using this library instead of the unchecked operations eliminates an entire
139  * class of bugs, so it's recommended to use it always.
140  */
141  
142 library SafeMath {
143     /**
144      * @dev Returns the addition of two unsigned integers, reverting on
145      * overflow.
146      *
147      * Counterpart to Solidity's `+` operator.
148      *
149      * Requirements:
150      *
151      * - Addition cannot overflow.
152      */
153     function add(uint256 a, uint256 b) internal pure returns (uint256) {
154         uint256 c = a + b;
155         require(c >= a, "SafeMath: addition overflow");
156 
157         return c;
158     }
159 
160     /**
161      * @dev Returns the subtraction of two unsigned integers, reverting on
162      * overflow (when the result is negative).
163      *
164      * Counterpart to Solidity's `-` operator.
165      *
166      * Requirements:
167      *
168      * - Subtraction cannot overflow.
169      */
170     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
171         return sub(a, b, "SafeMath: subtraction overflow");
172     }
173 
174     /**
175      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
176      * overflow (when the result is negative).
177      *
178      * Counterpart to Solidity's `-` operator.
179      *
180      * Requirements:
181      *
182      * - Subtraction cannot overflow.
183      */
184     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
185         require(b <= a, errorMessage);
186         uint256 c = a - b;
187 
188         return c;
189     }
190 
191     /**
192      * @dev Returns the multiplication of two unsigned integers, reverting on
193      * overflow.
194      *
195      * Counterpart to Solidity's `*` operator.
196      *
197      * Requirements:
198      *
199      * - Multiplication cannot overflow.
200      */
201     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
202         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
203         // benefit is lost if 'b' is also tested.
204         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
205         if (a == 0) {
206             return 0;
207         }
208 
209         uint256 c = a * b;
210         require(c / a == b, "SafeMath: multiplication overflow");
211 
212         return c;
213     }
214 
215     /**
216      * @dev Returns the integer division of two unsigned integers. Reverts on
217      * division by zero. The result is rounded towards zero.
218      *
219      * Counterpart to Solidity's `/` operator. Note: this function uses a
220      * `revert` opcode (which leaves remaining gas untouched) while Solidity
221      * uses an invalid opcode to revert (consuming all remaining gas).
222      *
223      * Requirements:
224      *
225      * - The divisor cannot be zero.
226      */
227     function div(uint256 a, uint256 b) internal pure returns (uint256) {
228         return div(a, b, "SafeMath: division by zero");
229     }
230 
231     /**
232      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
233      * division by zero. The result is rounded towards zero.
234      *
235      * Counterpart to Solidity's `/` operator. Note: this function uses a
236      * `revert` opcode (which leaves remaining gas untouched) while Solidity
237      * uses an invalid opcode to revert (consuming all remaining gas).
238      *
239      * Requirements:
240      *
241      * - The divisor cannot be zero.
242      */
243     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
244         require(b > 0, errorMessage);
245         uint256 c = a / b;
246         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
247 
248         return c;
249     }
250 
251     /**
252      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
253      * Reverts when dividing by zero.
254      *
255      * Counterpart to Solidity's `%` operator. This function uses a `revert`
256      * opcode (which leaves remaining gas untouched) while Solidity uses an
257      * invalid opcode to revert (consuming all remaining gas).
258      *
259      * Requirements:
260      *
261      * - The divisor cannot be zero.
262      */
263     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
264         return mod(a, b, "SafeMath: modulo by zero");
265     }
266 
267     /**
268      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
269      * Reverts with custom message when dividing by zero.
270      *
271      * Counterpart to Solidity's `%` operator. This function uses a `revert`
272      * opcode (which leaves remaining gas untouched) while Solidity uses an
273      * invalid opcode to revert (consuming all remaining gas).
274      *
275      * Requirements:
276      *
277      * - The divisor cannot be zero.
278      */
279     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
280         require(b != 0, errorMessage);
281         return a % b;
282     }
283 }
284 
285 abstract contract Context {
286     function _msgSender() internal view virtual returns (address payable) {
287         return msg.sender;
288     }
289 
290     function _msgData() internal view virtual returns (bytes memory) {
291         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
292         return msg.data;
293     }
294 }
295 
296 
297 /**
298  * @dev Collection of functions related to the address type
299  */
300 library Address {
301     /**
302      * @dev Returns true if `account` is a contract.
303      *
304      * [IMPORTANT]
305      * ====
306      * It is unsafe to assume that an address for which this function returns
307      * false is an externally-owned account (EOA) and not a contract.
308      *
309      * Among others, `isContract` will return false for the following
310      * types of addresses:
311      *
312      *  - an externally-owned account
313      *  - a contract in construction
314      *  - an address where a contract will be created
315      *  - an address where a contract lived, but was destroyed
316      * ====
317      */
318     function isContract(address account) internal view returns (bool) {
319         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
320         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
321         // for accounts without code, i.e. `keccak256('')`
322         bytes32 codehash;
323         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
324         // solhint-disable-next-line no-inline-assembly
325         assembly { codehash := extcodehash(account) }
326         return (codehash != accountHash && codehash != 0x0);
327     }
328 
329     /**
330      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
331      * `recipient`, forwarding all available gas and reverting on errors.
332      *
333      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
334      * of certain opcodes, possibly making contracts go over the 2300 gas limit
335      * imposed by `transfer`, making them unable to receive funds via
336      * `transfer`. {sendValue} removes this limitation.
337      *
338      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
339      *
340      * IMPORTANT: because control is transferred to `recipient`, care must be
341      * taken to not create reentrancy vulnerabilities. Consider using
342      * {ReentrancyGuard} or the
343      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
344      */
345     function sendValue(address payable recipient, uint256 amount) internal {
346         require(address(this).balance >= amount, "Address: insufficient balance");
347 
348         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
349         (bool success, ) = recipient.call{ value: amount }("");
350         require(success, "Address: unable to send value, recipient may have reverted");
351     }
352 
353     /**
354      * @dev Performs a Solidity function call using a low level `call`. A
355      * plain`call` is an unsafe replacement for a function call: use this
356      * function instead.
357      *
358      * If `target` reverts with a revert reason, it is bubbled up by this
359      * function (like regular Solidity function calls).
360      *
361      * Returns the raw returned data. To convert to the expected return value,
362      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
363      *
364      * Requirements:
365      *
366      * - `target` must be a contract.
367      * - calling `target` with `data` must not revert.
368      *
369      * _Available since v3.1._
370      */
371     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
372       return functionCall(target, data, "Address: low-level call failed");
373     }
374 
375     /**
376      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
377      * `errorMessage` as a fallback revert reason when `target` reverts.
378      *
379      * _Available since v3.1._
380      */
381     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
382         return _functionCallWithValue(target, data, 0, errorMessage);
383     }
384 
385     /**
386      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
387      * but also transferring `value` wei to `target`.
388      *
389      * Requirements:
390      *
391      * - the calling contract must have an ETH balance of at least `value`.
392      * - the called Solidity function must be `payable`.
393      *
394      * _Available since v3.1._
395      */
396     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
397         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
398     }
399 
400     /**
401      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
402      * with `errorMessage` as a fallback revert reason when `target` reverts.
403      *
404      * _Available since v3.1._
405      */
406     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
407         require(address(this).balance >= value, "Address: insufficient balance for call");
408         return _functionCallWithValue(target, data, value, errorMessage);
409     }
410 
411     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
412         require(isContract(target), "Address: call to non-contract");
413 
414         // solhint-disable-next-line avoid-low-level-calls
415         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
416         if (success) {
417             return returndata;
418         } else {
419             // Look for revert reason and bubble it up if present
420             if (returndata.length > 0) {
421                 // The easiest way to bubble the revert reason is using memory via assembly
422 
423                 // solhint-disable-next-line no-inline-assembly
424                 assembly {
425                     let returndata_size := mload(returndata)
426                     revert(add(32, returndata), returndata_size)
427                 }
428             } else {
429                 revert(errorMessage);
430             }
431         }
432     }
433 }
434 
435 /**
436  * @dev Contract module which provides a basic access control mechanism, where
437  * there is an account (an owner) that can be granted exclusive access to
438  * specific functions.
439  *
440  * By default, the owner account will be the one that deploys the contract. This
441  * can later be changed with {transferOwnership}.
442  *
443  * This module is used through inheritance. It will make available the modifier
444  * `onlyOwner`, which can be applied to your functions to restrict their use to
445  * the owner.
446  */
447 contract Ownable is Context {
448     address private _owner;
449     address private _previousOwner;
450     uint256 private _lockTime;
451 
452     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
453 
454     /**
455      * @dev Initializes the contract setting the deployer as the initial owner.
456      */
457     constructor () internal {
458         address msgSender = _msgSender();
459         _owner = msgSender;
460         emit OwnershipTransferred(address(0), msgSender);
461     }
462 
463     /**
464      * @dev Returns the address of the current owner.
465      */
466     function owner() public view returns (address) {
467         return _owner;
468     }
469 
470     /**
471      * @dev Throws if called by any account other than the owner.
472      */
473     modifier onlyOwner() {
474         require(_owner == _msgSender(), "Ownable: caller is not the owner");
475         _;
476     }
477 
478      /**
479      * @dev Leaves the contract without owner. It will not be possible to call
480      * `onlyOwner` functions anymore. Can only be called by the current owner.
481      *
482      * NOTE: Renouncing ownership will leave the contract without an owner,
483      * thereby removing any functionality that is only available to the owner.
484      */
485     function renounceOwnership() public virtual onlyOwner {
486         emit OwnershipTransferred(_owner, address(0));
487         _owner = address(0);
488     }
489 
490     /**
491      * @dev Transfers ownership of the contract to a new account (`newOwner`).
492      * Can only be called by the current owner.
493      */
494     function transferOwnership(address newOwner) public virtual onlyOwner {
495         require(newOwner != address(0), "Ownable: new owner is the zero address");
496         emit OwnershipTransferred(_owner, newOwner);
497         _owner = newOwner;
498     }
499 
500     function geUnlockTime() public view returns (uint256) {
501         return _lockTime;
502     }
503 
504     //Locks the contract for owner for the amount of time provided
505     function lock(uint256 time) public virtual onlyOwner {
506         _previousOwner = _owner;
507         _owner = address(0);
508         _lockTime = now + time;
509         emit OwnershipTransferred(_owner, address(0));
510     }
511     
512     //Unlocks the contract for owner when _lockTime is exceeds
513     function unlock() public virtual {
514         require(_previousOwner == msg.sender, "You don't have permission to unlock");
515         require(now > _lockTime , "Contract is locked until 7 days");
516         emit OwnershipTransferred(_owner, _previousOwner);
517         _owner = _previousOwner;
518     }
519 }
520 
521 // pragma solidity >=0.5.0;
522 
523 interface IUniswapV2Factory {
524     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
525 
526     function feeTo() external view returns (address);
527     function feeToSetter() external view returns (address);
528 
529     function getPair(address tokenA, address tokenB) external view returns (address pair);
530     function allPairs(uint) external view returns (address pair);
531     function allPairsLength() external view returns (uint);
532 
533     function createPair(address tokenA, address tokenB) external returns (address pair);
534 
535     function setFeeTo(address) external;
536     function setFeeToSetter(address) external;
537 }
538 
539 
540 // pragma solidity >=0.5.0;
541 
542 interface IUniswapV2Pair {
543     event Approval(address indexed owner, address indexed spender, uint value);
544     event Transfer(address indexed from, address indexed to, uint value);
545 
546     function name() external pure returns (string memory);
547     function symbol() external pure returns (string memory);
548     function decimals() external pure returns (uint8);
549     function totalSupply() external view returns (uint);
550     function balanceOf(address owner) external view returns (uint);
551     function allowance(address owner, address spender) external view returns (uint);
552 
553     function approve(address spender, uint value) external returns (bool);
554     function transfer(address to, uint value) external returns (bool);
555     function transferFrom(address from, address to, uint value) external returns (bool);
556 
557     function DOMAIN_SEPARATOR() external view returns (bytes32);
558     function PERMIT_TYPEHASH() external pure returns (bytes32);
559     function nonces(address owner) external view returns (uint);
560 
561     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
562 
563     event Mint(address indexed sender, uint amount0, uint amount1);
564     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
565     event Swap(
566         address indexed sender,
567         uint amount0In,
568         uint amount1In,
569         uint amount0Out,
570         uint amount1Out,
571         address indexed to
572     );
573     event Sync(uint112 reserve0, uint112 reserve1);
574 
575     function MINIMUM_LIQUIDITY() external pure returns (uint);
576     function factory() external view returns (address);
577     function token0() external view returns (address);
578     function token1() external view returns (address);
579     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
580     function price0CumulativeLast() external view returns (uint);
581     function price1CumulativeLast() external view returns (uint);
582     function kLast() external view returns (uint);
583 
584     function mint(address to) external returns (uint liquidity);
585     function burn(address to) external returns (uint amount0, uint amount1);
586     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
587     function skim(address to) external;
588     function sync() external;
589 
590     function initialize(address, address) external;
591 }
592 
593 // pragma solidity >=0.6.2;
594 
595 interface IUniswapV2Router01 {
596     function factory() external pure returns (address);
597     function WETH() external pure returns (address);
598 
599     function addLiquidity(
600         address tokenA,
601         address tokenB,
602         uint amountADesired,
603         uint amountBDesired,
604         uint amountAMin,
605         uint amountBMin,
606         address to,
607         uint deadline
608     ) external returns (uint amountA, uint amountB, uint liquidity);
609     function addLiquidityETH(
610         address token,
611         uint amountTokenDesired,
612         uint amountTokenMin,
613         uint amountETHMin,
614         address to,
615         uint deadline
616     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
617     function removeLiquidity(
618         address tokenA,
619         address tokenB,
620         uint liquidity,
621         uint amountAMin,
622         uint amountBMin,
623         address to,
624         uint deadline
625     ) external returns (uint amountA, uint amountB);
626     function removeLiquidityETH(
627         address token,
628         uint liquidity,
629         uint amountTokenMin,
630         uint amountETHMin,
631         address to,
632         uint deadline
633     ) external returns (uint amountToken, uint amountETH);
634     function removeLiquidityWithPermit(
635         address tokenA,
636         address tokenB,
637         uint liquidity,
638         uint amountAMin,
639         uint amountBMin,
640         address to,
641         uint deadline,
642         bool approveMax, uint8 v, bytes32 r, bytes32 s
643     ) external returns (uint amountA, uint amountB);
644     function removeLiquidityETHWithPermit(
645         address token,
646         uint liquidity,
647         uint amountTokenMin,
648         uint amountETHMin,
649         address to,
650         uint deadline,
651         bool approveMax, uint8 v, bytes32 r, bytes32 s
652     ) external returns (uint amountToken, uint amountETH);
653     function swapExactTokensForTokens(
654         uint amountIn,
655         uint amountOutMin,
656         address[] calldata path,
657         address to,
658         uint deadline
659     ) external returns (uint[] memory amounts);
660     function swapTokensForExactTokens(
661         uint amountOut,
662         uint amountInMax,
663         address[] calldata path,
664         address to,
665         uint deadline
666     ) external returns (uint[] memory amounts);
667     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
668         external
669         payable
670         returns (uint[] memory amounts);
671     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
672         external
673         returns (uint[] memory amounts);
674     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
675         external
676         returns (uint[] memory amounts);
677     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
678         external
679         payable
680         returns (uint[] memory amounts);
681 
682     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
683     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
684     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
685     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
686     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
687 }
688 
689 
690 
691 // pragma solidity >=0.6.2;
692 
693 interface IUniswapV2Router02 is IUniswapV2Router01 {
694     function removeLiquidityETHSupportingFeeOnTransferTokens(
695         address token,
696         uint liquidity,
697         uint amountTokenMin,
698         uint amountETHMin,
699         address to,
700         uint deadline
701     ) external returns (uint amountETH);
702     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
703         address token,
704         uint liquidity,
705         uint amountTokenMin,
706         uint amountETHMin,
707         address to,
708         uint deadline,
709         bool approveMax, uint8 v, bytes32 r, bytes32 s
710     ) external returns (uint amountETH);
711 
712     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
713         uint amountIn,
714         uint amountOutMin,
715         address[] calldata path,
716         address to,
717         uint deadline
718     ) external;
719     function swapExactETHForTokensSupportingFeeOnTransferTokens(
720         uint amountOutMin,
721         address[] calldata path,
722         address to,
723         uint deadline
724     ) external payable;
725     function swapExactTokensForETHSupportingFeeOnTransferTokens(
726         uint amountIn,
727         uint amountOutMin,
728         address[] calldata path,
729         address to,
730         uint deadline
731     ) external;
732 }
733 
734 
735 contract Polkadoge is Context, IERC20, Ownable {
736     using SafeMath for uint256;
737     using Address for address;
738 
739     mapping (address => uint256) private _rOwned;
740     mapping (address => uint256) private _tOwned;
741     mapping (address => mapping (address => uint256)) private _allowances;
742 
743     mapping (address => bool) private _isExcludedFromFee;
744 
745     mapping (address => bool) private _isExcluded;
746     address[] private _excluded;
747    
748     uint256 private constant MAX = ~uint256(0);
749     uint256 private _tTotal = 100000000000 * 10**9;
750     uint256 private _rTotal = (MAX - (MAX % _tTotal));
751     uint256 private _tFeeTotal;
752 
753     string private _name = "Polkadoge";
754     string private _symbol = "PDOG";
755     uint8 private _decimals = 9;
756     
757     uint256 public _taxFee = 200;
758     uint256 private _previousTaxFee = _taxFee;
759     
760     uint256 public _liquidityFee = 200;
761     uint256 private _previousLiquidityFee = _liquidityFee;
762 
763     IUniswapV2Router02 public immutable uniswapV2Router;
764     address public immutable uniswapV2Pair;
765     
766     bool inSwapAndLiquify;
767     bool public swapAndLiquifyEnabled = true;
768     
769     uint256 public _maxTxAmount = 0; //Transfers are disabled before adding liquidity
770     uint256 private numTokensSellToAddToLiquidity = 50000000 * 10**9; //0.05% of the total supply
771     
772     mapping(address => bool) public bypassesMaxTxAmount; //Owner and presale contract
773     
774     event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
775     event SwapAndLiquifyEnabledUpdated(bool enabled);
776     event SwapAndLiquify(
777         uint256 tokensSwapped,
778         uint256 ethReceived,
779         uint256 tokensIntoLiqudity
780     );
781     
782     modifier lockTheSwap {
783         inSwapAndLiquify = true;
784         _;
785         inSwapAndLiquify = false;
786     }
787     
788     constructor () public {
789         _rOwned[_msgSender()] = _rTotal;
790         
791         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
792          // Create a uniswap pair for this new token
793         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
794             .createPair(address(this), _uniswapV2Router.WETH());
795 
796         // set the rest of the contract variables
797         uniswapV2Router = _uniswapV2Router;
798         
799         //exclude owner and this contract from fee
800         _isExcludedFromFee[owner()] = true;
801         _isExcludedFromFee[address(this)] = true;
802         
803         excludeFromReward(address(0));
804         
805         bypassesMaxTxAmount[owner()] = true;
806         bypassesMaxTxAmount[address(this)] = true;
807         
808         emit Transfer(address(0), _msgSender(), _tTotal);
809     }
810 
811     function name() public view returns (string memory) {
812         return _name;
813     }
814 
815     function symbol() public view returns (string memory) {
816         return _symbol;
817     }
818 
819     function decimals() public view returns (uint8) {
820         return _decimals;
821     }
822 
823     function totalSupply() public view override returns (uint256) {
824         return _tTotal;
825     }
826 
827     function balanceOf(address account) public view override returns (uint256) {
828         if (_isExcluded[account]) return _tOwned[account];
829         return tokenFromReflection(_rOwned[account]);
830     }
831 
832     function transfer(address recipient, uint256 amount) public override returns (bool) {
833         _transfer(_msgSender(), recipient, amount);
834         return true;
835     }
836 
837     function allowance(address owner, address spender) public view override returns (uint256) {
838         return _allowances[owner][spender];
839     }
840 
841     function approve(address spender, uint256 amount) public override returns (bool) {
842         _approve(_msgSender(), spender, amount);
843         return true;
844     }
845 
846     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
847         _transfer(sender, recipient, amount);
848         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
849         return true;
850     }
851 
852     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
853         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
854         return true;
855     }
856 
857     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
858         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
859         return true;
860     }
861 
862     function isExcludedFromReward(address account) public view returns (bool) {
863         return _isExcluded[account];
864     }
865 
866     function totalFees() public view returns (uint256) {
867         return _tFeeTotal;
868     }
869 
870     function deliver(uint256 tAmount) public {
871         address sender = _msgSender();
872         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
873         (uint256 rAmount,,,,,) = _getValues(tAmount);
874         _rOwned[sender] = _rOwned[sender].sub(rAmount);
875         _rTotal = _rTotal.sub(rAmount);
876         _tFeeTotal = _tFeeTotal.add(tAmount);
877     }
878 
879     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
880         require(tAmount <= _tTotal, "Amount must be less than supply");
881         if (!deductTransferFee) {
882             (uint256 rAmount,,,,,) = _getValues(tAmount);
883             return rAmount;
884         } else {
885             (,uint256 rTransferAmount,,,,) = _getValues(tAmount);
886             return rTransferAmount;
887         }
888     }
889 
890     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
891         require(rAmount <= _rTotal, "Amount must be less than total reflections");
892         uint256 currentRate =  _getRate();
893         return rAmount.div(currentRate);
894     }
895 
896     function excludeFromReward(address account) public onlyOwner() {
897         // require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'We can not exclude Uniswap router.');
898         require(!_isExcluded[account], "Account is already excluded");
899         if(_rOwned[account] > 0) {
900             _tOwned[account] = tokenFromReflection(_rOwned[account]);
901         }
902         _isExcluded[account] = true;
903         _excluded.push(account);
904     }
905 
906     function includeInReward(address account) external onlyOwner() {
907         require(_isExcluded[account], "Account is already excluded");
908         for (uint256 i = 0; i < _excluded.length; i++) {
909             if (_excluded[i] == account) {
910                 _excluded[i] = _excluded[_excluded.length - 1];
911                 _tOwned[account] = 0;
912                 _isExcluded[account] = false;
913                 _excluded.pop();
914                 break;
915             }
916         }
917     }
918     
919     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
920         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
921         _tOwned[sender] = _tOwned[sender].sub(tAmount);
922         _rOwned[sender] = _rOwned[sender].sub(rAmount);
923         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
924         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);        
925         _takeLiquidity(tLiquidity);
926         _reflectFee(rFee, tFee);
927         emit Transfer(sender, recipient, tTransferAmount);
928     }
929     
930     function excludeFromFee(address account) public onlyOwner {
931         _isExcludedFromFee[account] = true;
932     }
933     
934     function includeInFee(address account) public onlyOwner {
935         _isExcludedFromFee[account] = false;
936     }
937     
938     function setTaxFeeBasisPoint(uint256 taxFee) external onlyOwner() {
939         _taxFee = taxFee;
940     }
941     
942     function setLiquidityFeeBasisPoint(uint256 liquidityFee) external onlyOwner() {
943         _liquidityFee = liquidityFee;
944     }
945     
946     function setMaxTxBasisPoint(uint256 maxTxBp) external onlyOwner() {	
947         _maxTxAmount = _tTotal.mul(maxTxBp).div(	
948             10000	
949         );	
950     }
951    
952     function setSellToAddLiquidtyBasisPoint(uint256 bp) external onlyOwner() {
953         numTokensSellToAddToLiquidity = _tTotal.mul(bp).div(
954             10000
955         ); 
956     }
957     
958     function addBypassMaxTx(address account) external onlyOwner() {
959         bypassesMaxTxAmount[account] = true;
960     }
961     
962     function removeBypassMaxTx(address account) external onlyOwner() {
963         bypassesMaxTxAmount[account] = false;
964     }
965 
966     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
967         swapAndLiquifyEnabled = _enabled;
968         emit SwapAndLiquifyEnabledUpdated(_enabled);
969     }
970     
971      //to recieve ETH from uniswapV2Router when swaping
972     receive() external payable {}
973 
974     function _reflectFee(uint256 rFee, uint256 tFee) private {
975         _rTotal = _rTotal.sub(rFee);
976         _tFeeTotal = _tFeeTotal.add(tFee);
977     }
978 
979     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
980         (uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getTValues(tAmount);
981         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tLiquidity, _getRate());
982         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tLiquidity);
983     }
984 
985     function _getTValues(uint256 tAmount) private view returns (uint256, uint256, uint256) {
986         uint256 tFee = calculateTaxFee(tAmount);
987         uint256 tLiquidity = calculateLiquidityFee(tAmount);
988         uint256 tTransferAmount = tAmount.sub(tFee).sub(tLiquidity);
989         return (tTransferAmount, tFee, tLiquidity);
990     }
991 
992     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tLiquidity, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
993         uint256 rAmount = tAmount.mul(currentRate);
994         uint256 rFee = tFee.mul(currentRate);
995         uint256 rLiquidity = tLiquidity.mul(currentRate);
996         uint256 rTransferAmount = rAmount.sub(rFee).sub(rLiquidity);
997         return (rAmount, rTransferAmount, rFee);
998     }
999 
1000     function _getRate() private view returns(uint256) {
1001         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
1002         return rSupply.div(tSupply);
1003     }
1004 
1005     function _getCurrentSupply() private view returns(uint256, uint256) {
1006         uint256 rSupply = _rTotal;
1007         uint256 tSupply = _tTotal;      
1008         for (uint256 i = 0; i < _excluded.length; i++) {
1009             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
1010             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
1011             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
1012         }
1013         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
1014         return (rSupply, tSupply);
1015     }
1016     
1017     function _takeLiquidity(uint256 tLiquidity) private {
1018         uint256 currentRate =  _getRate();
1019         uint256 rLiquidity = tLiquidity.mul(currentRate);
1020         _rOwned[address(this)] = _rOwned[address(this)].add(rLiquidity);
1021         if(_isExcluded[address(this)])
1022             _tOwned[address(this)] = _tOwned[address(this)].add(tLiquidity);
1023     }
1024     
1025     function calculateTaxFee(uint256 _amount) private view returns (uint256) {
1026         return _amount.mul(_taxFee).div(
1027             10000
1028         );
1029     }
1030 
1031     function calculateLiquidityFee(uint256 _amount) private view returns (uint256) {
1032         return _amount.mul(_liquidityFee).div(
1033             10000
1034         );
1035     }
1036     
1037     function removeAllFee() private {
1038         if(_taxFee == 0 && _liquidityFee == 0) return;
1039         
1040         _previousTaxFee = _taxFee;
1041         _previousLiquidityFee = _liquidityFee;
1042         
1043         _taxFee = 0;
1044         _liquidityFee = 0;
1045     }
1046     
1047     function restoreAllFee() private {
1048         _taxFee = _previousTaxFee;
1049         _liquidityFee = _previousLiquidityFee;
1050     }
1051     
1052     function isExcludedFromFee(address account) public view returns(bool) {
1053         return _isExcludedFromFee[account];
1054     }
1055 
1056     function _approve(address owner, address spender, uint256 amount) private {
1057         require(owner != address(0), "ERC20: approve from the zero address");
1058         require(spender != address(0), "ERC20: approve to the zero address");
1059 
1060         _allowances[owner][spender] = amount;
1061         emit Approval(owner, spender, amount);
1062     }
1063 
1064     function _transfer(
1065         address from,
1066         address to,
1067         uint256 amount
1068     ) private {
1069         require(from != address(0), "ERC20: transfer from the zero address");
1070         require(to != address(0), "ERC20: transfer to the zero address");
1071         require(amount > 0, "Transfer amount must be greater than zero");
1072         if(!bypassesMaxTxAmount[from] && !bypassesMaxTxAmount[to])
1073             require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
1074 
1075         // is the token balance of this contract address over the min number of
1076         // tokens that we need to initiate a swap + liquidity lock?
1077         // also, don't get caught in a circular liquidity event.
1078         // also, don't swap & liquify if sender is uniswap pair.
1079         uint256 contractTokenBalance = balanceOf(address(this));
1080         
1081         if(contractTokenBalance >= _maxTxAmount)
1082         {
1083             contractTokenBalance = _maxTxAmount;
1084         }
1085         
1086         bool overMinTokenBalance = contractTokenBalance >= numTokensSellToAddToLiquidity;
1087         if (
1088             overMinTokenBalance &&
1089             !inSwapAndLiquify &&
1090             from != uniswapV2Pair &&
1091             swapAndLiquifyEnabled
1092         ) {
1093             contractTokenBalance = numTokensSellToAddToLiquidity;
1094             //add liquidity
1095             swapAndLiquify(contractTokenBalance);
1096         }
1097         
1098         //indicates if fee should be deducted from transfer
1099         bool takeFee = true;
1100         
1101         //if any account belongs to _isExcludedFromFee account then remove the fee
1102         if(_isExcludedFromFee[from] || _isExcludedFromFee[to]){
1103             takeFee = false;
1104         }
1105         
1106         //transfer amount, it will take tax, burn, liquidity fee
1107         _tokenTransfer(from,to,amount,takeFee);
1108     }
1109 
1110     function swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {
1111         // split the contract balance into halves
1112         uint256 half = contractTokenBalance.div(2);
1113         uint256 otherHalf = contractTokenBalance.sub(half);
1114 
1115         // capture the contract's current ETH balance.
1116         // this is so that we can capture exactly the amount of ETH that the
1117         // swap creates, and not make the liquidity event include any ETH that
1118         // has been manually sent to the contract
1119         uint256 initialBalance = address(this).balance;
1120 
1121         // swap tokens for ETH
1122         swapTokensForEth(half); // <- this breaks the ETH -> HATE swap when swap+liquify is triggered
1123 
1124         // how much ETH did we just swap into?
1125         uint256 newBalance = address(this).balance.sub(initialBalance);
1126 
1127         // add liquidity to uniswap
1128         addLiquidity(otherHalf, newBalance);
1129         
1130         emit SwapAndLiquify(half, newBalance, otherHalf);
1131     }
1132 
1133     function swapTokensForEth(uint256 tokenAmount) private {
1134         // generate the uniswap pair path of token -> weth
1135         address[] memory path = new address[](2);
1136         path[0] = address(this);
1137         path[1] = uniswapV2Router.WETH();
1138 
1139         _approve(address(this), address(uniswapV2Router), tokenAmount);
1140 
1141         // make the swap
1142         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1143             tokenAmount,
1144             0, // accept any amount of ETH
1145             path,
1146             address(this),
1147             block.timestamp
1148         );
1149     }
1150 
1151     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1152         // approve token transfer to cover all possible scenarios
1153         _approve(address(this), address(uniswapV2Router), tokenAmount);
1154 
1155         // add the liquidity
1156         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1157             address(this),
1158             tokenAmount,
1159             0, // slippage is unavoidable
1160             0, // slippage is unavoidable
1161             owner(),
1162             block.timestamp
1163         );
1164     }
1165 
1166     //this method is responsible for taking all fee, if takeFee is true
1167     function _tokenTransfer(address sender, address recipient, uint256 amount,bool takeFee) private {
1168         if(!takeFee)
1169             removeAllFee();
1170         
1171         if (_isExcluded[sender] && !_isExcluded[recipient]) {
1172             _transferFromExcluded(sender, recipient, amount);
1173         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
1174             _transferToExcluded(sender, recipient, amount);
1175         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
1176             _transferStandard(sender, recipient, amount);
1177         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
1178             _transferBothExcluded(sender, recipient, amount);
1179         } else {
1180             _transferStandard(sender, recipient, amount);
1181         }
1182         
1183         if(!takeFee)
1184             restoreAllFee();
1185     }
1186 
1187     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
1188         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
1189         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1190         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1191         _takeLiquidity(tLiquidity);
1192         _reflectFee(rFee, tFee);
1193         emit Transfer(sender, recipient, tTransferAmount);
1194     }
1195 
1196     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
1197         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
1198         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1199         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1200         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);           
1201         _takeLiquidity(tLiquidity);
1202         _reflectFee(rFee, tFee);
1203         emit Transfer(sender, recipient, tTransferAmount);
1204     }
1205 
1206     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
1207         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
1208         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1209         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1210         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
1211         _takeLiquidity(tLiquidity);
1212         _reflectFee(rFee, tFee);
1213         emit Transfer(sender, recipient, tTransferAmount);
1214     }
1215 }