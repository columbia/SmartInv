1 // SPDX-License-Identifier: MIT
2 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/ERC20.sol)
3 
4 pragma solidity ^0.8.0;
5 
6 /**
7  * @dev Provides information about the current execution context, including the
8  * sender of the transaction and its data. While these are generally available
9  * via msg.sender and msg.data, they should not be accessed in such a direct
10  * manner, since when dealing with meta-transactions the account sending and
11  * paying for execution may not be the actual sender (as far as an application
12  * is concerned).
13  *
14  * This contract is only required for intermediate, library-like contracts.
15  */
16 abstract contract Context {
17     function _msgSender() internal view virtual returns (address) {
18         return msg.sender;
19     }
20 
21     function _msgData() internal view virtual returns (bytes calldata) {
22         return msg.data;
23     }
24 }
25 
26 /**
27  * @dev Contract module which provides a basic access control mechanism, where
28  * there is an account (an owner) that can be granted exclusive access to
29  * specific functions.
30  *
31  * By default, the owner account will be the one that deploys the contract. This
32  * can later be changed with {transferOwnership}.
33  *
34  * This module is used through inheritance. It will make available the modifier
35  * `onlyOwner`, which can be applied to your functions to restrict their use to
36  * the owner.
37  */
38 abstract contract Ownable is Context {
39     address private _owner;
40 
41     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
42 
43     /**
44      * @dev Initializes the contract setting the deployer as the initial owner.
45      */
46     constructor() {
47         _transferOwnership(_msgSender());
48     }
49 
50     /**
51      * @dev Returns the address of the current owner.
52      */
53     function owner() public view virtual returns (address) {
54         return _owner;
55     }
56 
57     /**
58      * @dev Throws if called by any account other than the owner.
59      */
60     modifier onlyOwner() {
61         require(owner() == _msgSender(), "Ownable: caller is not the owner");
62         _;
63     }
64 
65     /**
66      * @dev Leaves the contract without owner. It will not be possible to call
67      * `onlyOwner` functions anymore. Can only be called by the current owner.
68      *
69      * NOTE: Renouncing ownership will leave the contract without an owner,
70      * thereby removing any functionality that is only available to the owner.
71      */
72     function renounceOwnership() public virtual onlyOwner {
73         _transferOwnership(address(0));
74     }
75 
76     /**
77      * @dev Transfers ownership of the contract to a new account (`newOwner`).
78      * Can only be called by the current owner.
79      */
80     function transferOwnership(address newOwner) public virtual onlyOwner {
81         require(newOwner != address(0), "Ownable: new owner is the zero address");
82         _transferOwnership(newOwner);
83     }
84 
85     /**
86      * @dev Transfers ownership of the contract to a new account (`newOwner`).
87      * Internal function without access restriction.
88      */
89     function _transferOwnership(address newOwner) internal virtual {
90         address oldOwner = _owner;
91         _owner = newOwner;
92         emit OwnershipTransferred(oldOwner, newOwner);
93     }
94 }
95 
96 
97 /**
98  * @dev Collection of functions related to the address type
99  */
100 library Address {
101     /**
102      * @dev Returns true if `account` is a contract.
103      *
104      * [IMPORTANT]
105      * ====
106      * It is unsafe to assume that an address for which this function returns
107      * false is an externally-owned account (EOA) and not a contract.
108      *
109      * Among others, `isContract` will return false for the following
110      * types of addresses:
111      *
112      *  - an externally-owned account
113      *  - a contract in construction
114      *  - an address where a contract will be created
115      *  - an address where a contract lived, but was destroyed
116      * ====
117      *
118      * [IMPORTANT]
119      * ====
120      * You shouldn't rely on `isContract` to protect against flash loan attacks!
121      *
122      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
123      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
124      * constructor.
125      * ====
126      */
127     function isContract(address account) internal view returns (bool) {
128         // This method relies on extcodesize/address.code.length, which returns 0
129         // for contracts in construction, since the code is only stored at the end
130         // of the constructor execution.
131 
132         return account.code.length > 0;
133     }
134 
135     /**
136      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
137      * `recipient`, forwarding all available gas and reverting on errors.
138      *
139      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
140      * of certain opcodes, possibly making contracts go over the 2300 gas limit
141      * imposed by `transfer`, making them unable to receive funds via
142      * `transfer`. {sendValue} removes this limitation.
143      *
144      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
145      *
146      * IMPORTANT: because control is transferred to `recipient`, care must be
147      * taken to not create reentrancy vulnerabilities. Consider using
148      * {ReentrancyGuard} or the
149      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
150      */
151     function sendValue(address payable recipient, uint256 amount) internal {
152         require(address(this).balance >= amount, "Address: insufficient balance");
153 
154         (bool success, ) = recipient.call{value: amount}("");
155         require(success, "Address: unable to send value, recipient may have reverted");
156     }
157 
158     /**
159      * @dev Performs a Solidity function call using a low level `call`. A
160      * plain `call` is an unsafe replacement for a function call: use this
161      * function instead.
162      *
163      * If `target` reverts with a revert reason, it is bubbled up by this
164      * function (like regular Solidity function calls).
165      *
166      * Returns the raw returned data. To convert to the expected return value,
167      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
168      *
169      * Requirements:
170      *
171      * - `target` must be a contract.
172      * - calling `target` with `data` must not revert.
173      *
174      * _Available since v3.1._
175      */
176     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
177         return functionCall(target, data, "Address: low-level call failed");
178     }
179 
180     /**
181      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
182      * `errorMessage` as a fallback revert reason when `target` reverts.
183      *
184      * _Available since v3.1._
185      */
186     function functionCall(
187         address target,
188         bytes memory data,
189         string memory errorMessage
190     ) internal returns (bytes memory) {
191         return functionCallWithValue(target, data, 0, errorMessage);
192     }
193 
194     /**
195      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
196      * but also transferring `value` wei to `target`.
197      *
198      * Requirements:
199      *
200      * - the calling contract must have an ETH balance of at least `value`.
201      * - the called Solidity function must be `payable`.
202      *
203      * _Available since v3.1._
204      */
205     function functionCallWithValue(
206         address target,
207         bytes memory data,
208         uint256 value
209     ) internal returns (bytes memory) {
210         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
211     }
212 
213     /**
214      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
215      * with `errorMessage` as a fallback revert reason when `target` reverts.
216      *
217      * _Available since v3.1._
218      */
219     function functionCallWithValue(
220         address target,
221         bytes memory data,
222         uint256 value,
223         string memory errorMessage
224     ) internal returns (bytes memory) {
225         require(address(this).balance >= value, "Address: insufficient balance for call");
226         require(isContract(target), "Address: call to non-contract");
227 
228         (bool success, bytes memory returndata) = target.call{value: value}(data);
229         return verifyCallResult(success, returndata, errorMessage);
230     }
231 
232     /**
233      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
234      * but performing a static call.
235      *
236      * _Available since v3.3._
237      */
238     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
239         return functionStaticCall(target, data, "Address: low-level static call failed");
240     }
241 
242     /**
243      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
244      * but performing a static call.
245      *
246      * _Available since v3.3._
247      */
248     function functionStaticCall(
249         address target,
250         bytes memory data,
251         string memory errorMessage
252     ) internal view returns (bytes memory) {
253         require(isContract(target), "Address: static call to non-contract");
254 
255         (bool success, bytes memory returndata) = target.staticcall(data);
256         return verifyCallResult(success, returndata, errorMessage);
257     }
258 
259     /**
260      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
261      * but performing a delegate call.
262      *
263      * _Available since v3.4._
264      */
265     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
266         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
267     }
268 
269     /**
270      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
271      * but performing a delegate call.
272      *
273      * _Available since v3.4._
274      */
275     function functionDelegateCall(
276         address target,
277         bytes memory data,
278         string memory errorMessage
279     ) internal returns (bytes memory) {
280         require(isContract(target), "Address: delegate call to non-contract");
281 
282         (bool success, bytes memory returndata) = target.delegatecall(data);
283         return verifyCallResult(success, returndata, errorMessage);
284     }
285 
286     /**
287      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
288      * revert reason using the provided one.
289      *
290      * _Available since v4.3._
291      */
292     function verifyCallResult(
293         bool success,
294         bytes memory returndata,
295         string memory errorMessage
296     ) internal pure returns (bytes memory) {
297         if (success) {
298             return returndata;
299         } else {
300             // Look for revert reason and bubble it up if present
301             if (returndata.length > 0) {
302                 // The easiest way to bubble the revert reason is using memory via assembly
303 
304                 assembly {
305                     let returndata_size := mload(returndata)
306                     revert(add(32, returndata), returndata_size)
307                 }
308             } else {
309                 revert(errorMessage);
310             }
311         }
312     }
313 }
314 
315 
316 /**
317  * @dev Wrappers over Solidity's arithmetic operations with added overflow
318  * checks.
319  *
320  * Arithmetic operations in Solidity wrap on overflow. This can easily result
321  * in bugs, because programmers usually assume that an overflow raises an
322  * error, which is the standard behavior in high level programming languages.
323  * `SafeMath` restores this intuition by reverting the transaction when an
324  * operation overflows.
325  *
326  * Using this library instead of the unchecked operations eliminates an entire
327  * class of bugs, so it's recommended to use it always.
328  */
329 library SafeMath {
330     /**
331      * @dev Returns the addition of two unsigned integers, with an overflow flag.
332      *
333      * _Available since v3.4._
334      */
335     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
336         uint256 c = a + b;
337         if (c < a) return (false, 0);
338         return (true, c);
339     }
340 
341     /**
342      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
343      *
344      * _Available since v3.4._
345      */
346     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
347         if (b > a) return (false, 0);
348         return (true, a - b);
349     }
350 
351     /**
352      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
353      *
354      * _Available since v3.4._
355      */
356     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
357         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
358         // benefit is lost if 'b' is also tested.
359         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
360         if (a == 0) return (true, 0);
361         uint256 c = a * b;
362         if (c / a != b) return (false, 0);
363         return (true, c);
364     }
365 
366     /**
367      * @dev Returns the division of two unsigned integers, with a division by zero flag.
368      *
369      * _Available since v3.4._
370      */
371     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
372         if (b == 0) return (false, 0);
373         return (true, a / b);
374     }
375 
376     /**
377      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
378      *
379      * _Available since v3.4._
380      */
381     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
382         if (b == 0) return (false, 0);
383         return (true, a % b);
384     }
385 
386     /**
387      * @dev Returns the addition of two unsigned integers, reverting on
388      * overflow.
389      *
390      * Counterpart to Solidity's `+` operator.
391      *
392      * Requirements:
393      *
394      * - Addition cannot overflow.
395      */
396     function add(uint256 a, uint256 b) internal pure returns (uint256) {
397         uint256 c = a + b;
398         require(c >= a, "SafeMath: addition overflow");
399         return c;
400     }
401 
402     /**
403      * @dev Returns the subtraction of two unsigned integers, reverting on
404      * overflow (when the result is negative).
405      *
406      * Counterpart to Solidity's `-` operator.
407      *
408      * Requirements:
409      *
410      * - Subtraction cannot overflow.
411      */
412     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
413         require(b <= a, "SafeMath: subtraction overflow");
414         return a - b;
415     }
416 
417     /**
418      * @dev Returns the multiplication of two unsigned integers, reverting on
419      * overflow.
420      *
421      * Counterpart to Solidity's `*` operator.
422      *
423      * Requirements:
424      *
425      * - Multiplication cannot overflow.
426      */
427     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
428         if (a == 0) return 0;
429         uint256 c = a * b;
430         require(c / a == b, "SafeMath: multiplication overflow");
431         return c;
432     }
433 
434     /**
435      * @dev Returns the integer division of two unsigned integers, reverting on
436      * division by zero. The result is rounded towards zero.
437      *
438      * Counterpart to Solidity's `/` operator. Note: this function uses a
439      * `revert` opcode (which leaves remaining gas untouched) while Solidity
440      * uses an invalid opcode to revert (consuming all remaining gas).
441      *
442      * Requirements:
443      *
444      * - The divisor cannot be zero.
445      */
446     function div(uint256 a, uint256 b) internal pure returns (uint256) {
447         require(b > 0, "SafeMath: division by zero");
448         return a / b;
449     }
450 
451     /**
452      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
453      * reverting when dividing by zero.
454      *
455      * Counterpart to Solidity's `%` operator. This function uses a `revert`
456      * opcode (which leaves remaining gas untouched) while Solidity uses an
457      * invalid opcode to revert (consuming all remaining gas).
458      *
459      * Requirements:
460      *
461      * - The divisor cannot be zero.
462      */
463     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
464         require(b > 0, "SafeMath: modulo by zero");
465         return a % b;
466     }
467 
468     /**
469      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
470      * overflow (when the result is negative).
471      *
472      * CAUTION: This function is deprecated because it requires allocating memory for the error
473      * message unnecessarily. For custom revert reasons use {trySub}.
474      *
475      * Counterpart to Solidity's `-` operator.
476      *
477      * Requirements:
478      *
479      * - Subtraction cannot overflow.
480      */
481     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
482         require(b <= a, errorMessage);
483         return a - b;
484     }
485 
486     /**
487      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
488      * division by zero. The result is rounded towards zero.
489      *
490      * CAUTION: This function is deprecated because it requires allocating memory for the error
491      * message unnecessarily. For custom revert reasons use {tryDiv}.
492      *
493      * Counterpart to Solidity's `/` operator. Note: this function uses a
494      * `revert` opcode (which leaves remaining gas untouched) while Solidity
495      * uses an invalid opcode to revert (consuming all remaining gas).
496      *
497      * Requirements:
498      *
499      * - The divisor cannot be zero.
500      */
501     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
502         require(b > 0, errorMessage);
503         return a / b;
504     }
505 
506     /**
507      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
508      * reverting with custom message when dividing by zero.
509      *
510      * CAUTION: This function is deprecated because it requires allocating memory for the error
511      * message unnecessarily. For custom revert reasons use {tryMod}.
512      *
513      * Counterpart to Solidity's `%` operator. This function uses a `revert`
514      * opcode (which leaves remaining gas untouched) while Solidity uses an
515      * invalid opcode to revert (consuming all remaining gas).
516      *
517      * Requirements:
518      *
519      * - The divisor cannot be zero.
520      */
521     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
522         require(b > 0, errorMessage);
523         return a % b;
524     }
525 }
526 
527 contract MultiSend is Ownable{
528     using SafeMath for uint256;
529 
530     struct Receiver {
531         address rx;
532         uint256 amount;
533     }
534 
535     uint256 public fee = 0;//0.00001 ETH
536 
537     function sendFixed(address[] memory receivers, uint256 amount)  public payable {
538         require(msg.value >= SafeMath.add(fee, amount.mul(receivers.length)), "MultiSend:: not enough ether");
539         for(uint i = 0; i < receivers.length; i++){
540             payable(receivers[i]).transfer(amount);
541         }
542     }
543 
544     function send(Receiver[] memory receivers)  public payable {
545         uint256 requiredEther = 0;
546         for(uint i = 0; i < receivers.length; i++){
547             requiredEther = requiredEther.add(receivers[i].amount);
548         }
549         require(msg.value >= SafeMath.add(fee, requiredEther), "MultiSend:: not enough ether");
550         for(uint i = 0; i < receivers.length; i++){
551             payable(receivers[i].rx).transfer(receivers[i].amount);
552         }
553     }
554 
555     function setFee(uint256 _fee) public onlyOwner{
556         fee = _fee;
557     }
558 
559     function withdraw() public onlyOwner {
560         uint balance = address(this).balance;
561         payable(msg.sender).transfer(balance);
562     } 
563 }