1 // SPDX-License-Identifier: Apache-2.0
2 
3 pragma solidity 0.6.8;
4 
5 
6 // i2c mainnet mark
7 
8 
9 /*
10  * @dev Provides information about the current execution context, including the
11  * sender of the transaction and its data. While these are generally available
12  * via msg.sender and msg.data, they should not be accessed in such a direct
13  * manner, since when dealing with GSN meta-transactions the account sending and
14  * paying for execution may not be the actual sender (as far as an application
15  * is concerned).
16  *
17  * This contract is only required for intermediate, library-like contracts.
18  */
19 abstract contract Context {
20     function _msgSender() internal view virtual returns (address payable) {
21         return msg.sender;
22     }
23 
24     function _msgData() internal view virtual returns (bytes memory) {
25         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
26         return msg.data;
27     }
28 }
29 
30 
31 
32 
33 
34 /**
35  * @dev Contract module which allows children to implement an emergency stop
36  * mechanism that can be triggered by an authorized account.
37  *
38  * This module is used through inheritance. It will make available the
39  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
40  * the functions of your contract. Note that they will not be pausable by
41  * simply including this module, only once the modifiers are put in place.
42  */
43 contract Pausable is Context {
44     /**
45      * @dev Emitted when the pause is triggered by `account`.
46      */
47     event Paused(address account);
48 
49     /**
50      * @dev Emitted when the pause is lifted by `account`.
51      */
52     event Unpaused(address account);
53 
54     bool private _paused;
55 
56     /**
57      * @dev Initializes the contract in unpaused state.
58      */
59     constructor () internal {
60         _paused = false;
61     }
62 
63     /**
64      * @dev Returns true if the contract is paused, and false otherwise.
65      */
66     function paused() public view returns (bool) {
67         return _paused;
68     }
69 
70     /**
71      * @dev Modifier to make a function callable only when the contract is not paused.
72      *
73      * Requirements:
74      *
75      * - The contract must not be paused.
76      */
77     modifier whenNotPaused() {
78         require(!_paused, "Pausable: paused");
79         _;
80     }
81 
82     /**
83      * @dev Modifier to make a function callable only when the contract is paused.
84      *
85      * Requirements:
86      *
87      * - The contract must be paused.
88      */
89     modifier whenPaused() {
90         require(_paused, "Pausable: not paused");
91         _;
92     }
93 
94     /**
95      * @dev Triggers stopped state.
96      *
97      * Requirements:
98      *
99      * - The contract must not be paused.
100      */
101     function _pause() internal virtual whenNotPaused {
102         _paused = true;
103         emit Paused(_msgSender());
104     }
105 
106     /**
107      * @dev Returns to normal state.
108      *
109      * Requirements:
110      *
111      * - The contract must be paused.
112      */
113     function _unpause() internal virtual whenPaused {
114         _paused = false;
115         emit Unpaused(_msgSender());
116     }
117 }
118 
119 
120 
121 
122 
123 /**
124  * @dev Contract module which provides a basic access control mechanism, where
125  * there is an account (an owner) that can be granted exclusive access to
126  * specific functions.
127  *
128  * By default, the owner account will be the one that deploys the contract. This
129  * can later be changed with {transferOwnership}.
130  *
131  * This module is used through inheritance. It will make available the modifier
132  * `onlyOwner`, which can be applied to your functions to restrict their use to
133  * the owner.
134  */
135 contract Ownable is Context {
136     address private _owner;
137 
138     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
139 
140     /**
141      * @dev Initializes the contract setting the deployer as the initial owner.
142      */
143     constructor () internal {
144         address msgSender = _msgSender();
145         _owner = msgSender;
146         emit OwnershipTransferred(address(0), msgSender);
147     }
148 
149     /**
150      * @dev Returns the address of the current owner.
151      */
152     function owner() public view returns (address) {
153         return _owner;
154     }
155 
156     /**
157      * @dev Throws if called by any account other than the owner.
158      */
159     modifier onlyOwner() {
160         require(_owner == _msgSender(), "Ownable: caller is not the owner");
161         _;
162     }
163 
164     /**
165      * @dev Leaves the contract without owner. It will not be possible to call
166      * `onlyOwner` functions anymore. Can only be called by the current owner.
167      *
168      * NOTE: Renouncing ownership will leave the contract without an owner,
169      * thereby removing any functionality that is only available to the owner.
170      */
171     function renounceOwnership() public virtual onlyOwner {
172         emit OwnershipTransferred(_owner, address(0));
173         _owner = address(0);
174     }
175 
176     /**
177      * @dev Transfers ownership of the contract to a new account (`newOwner`).
178      * Can only be called by the current owner.
179      */
180     function transferOwnership(address newOwner) public virtual onlyOwner {
181         require(newOwner != address(0), "Ownable: new owner is the zero address");
182         emit OwnershipTransferred(_owner, newOwner);
183         _owner = newOwner;
184     }
185 }
186 
187 
188 
189 
190 
191 /**
192  * @dev Wrappers over Solidity's arithmetic operations with added overflow
193  * checks.
194  *
195  * Arithmetic operations in Solidity wrap on overflow. This can easily result
196  * in bugs, because programmers usually assume that an overflow raises an
197  * error, which is the standard behavior in high level programming languages.
198  * `SafeMath` restores this intuition by reverting the transaction when an
199  * operation overflows.
200  *
201  * Using this library instead of the unchecked operations eliminates an entire
202  * class of bugs, so it's recommended to use it always.
203  */
204 library SafeMath {
205     /**
206      * @dev Returns the addition of two unsigned integers, reverting on
207      * overflow.
208      *
209      * Counterpart to Solidity's `+` operator.
210      *
211      * Requirements:
212      *
213      * - Addition cannot overflow.
214      */
215     function add(uint256 a, uint256 b) internal pure returns (uint256) {
216         uint256 c = a + b;
217         require(c >= a, "SafeMath: addition overflow");
218 
219         return c;
220     }
221 
222     /**
223      * @dev Returns the subtraction of two unsigned integers, reverting on
224      * overflow (when the result is negative).
225      *
226      * Counterpart to Solidity's `-` operator.
227      *
228      * Requirements:
229      *
230      * - Subtraction cannot overflow.
231      */
232     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
233         return sub(a, b, "SafeMath: subtraction overflow");
234     }
235 
236     /**
237      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
238      * overflow (when the result is negative).
239      *
240      * Counterpart to Solidity's `-` operator.
241      *
242      * Requirements:
243      *
244      * - Subtraction cannot overflow.
245      */
246     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
247         require(b <= a, errorMessage);
248         uint256 c = a - b;
249 
250         return c;
251     }
252 
253     /**
254      * @dev Returns the multiplication of two unsigned integers, reverting on
255      * overflow.
256      *
257      * Counterpart to Solidity's `*` operator.
258      *
259      * Requirements:
260      *
261      * - Multiplication cannot overflow.
262      */
263     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
264         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
265         // benefit is lost if 'b' is also tested.
266         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
267         if (a == 0) {
268             return 0;
269         }
270 
271         uint256 c = a * b;
272         require(c / a == b, "SafeMath: multiplication overflow");
273 
274         return c;
275     }
276 
277     /**
278      * @dev Returns the integer division of two unsigned integers. Reverts on
279      * division by zero. The result is rounded towards zero.
280      *
281      * Counterpart to Solidity's `/` operator. Note: this function uses a
282      * `revert` opcode (which leaves remaining gas untouched) while Solidity
283      * uses an invalid opcode to revert (consuming all remaining gas).
284      *
285      * Requirements:
286      *
287      * - The divisor cannot be zero.
288      */
289     function div(uint256 a, uint256 b) internal pure returns (uint256) {
290         return div(a, b, "SafeMath: division by zero");
291     }
292 
293     /**
294      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
295      * division by zero. The result is rounded towards zero.
296      *
297      * Counterpart to Solidity's `/` operator. Note: this function uses a
298      * `revert` opcode (which leaves remaining gas untouched) while Solidity
299      * uses an invalid opcode to revert (consuming all remaining gas).
300      *
301      * Requirements:
302      *
303      * - The divisor cannot be zero.
304      */
305     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
306         require(b > 0, errorMessage);
307         uint256 c = a / b;
308         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
309 
310         return c;
311     }
312 
313     /**
314      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
315      * Reverts when dividing by zero.
316      *
317      * Counterpart to Solidity's `%` operator. This function uses a `revert`
318      * opcode (which leaves remaining gas untouched) while Solidity uses an
319      * invalid opcode to revert (consuming all remaining gas).
320      *
321      * Requirements:
322      *
323      * - The divisor cannot be zero.
324      */
325     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
326         return mod(a, b, "SafeMath: modulo by zero");
327     }
328 
329     /**
330      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
331      * Reverts with custom message when dividing by zero.
332      *
333      * Counterpart to Solidity's `%` operator. This function uses a `revert`
334      * opcode (which leaves remaining gas untouched) while Solidity uses an
335      * invalid opcode to revert (consuming all remaining gas).
336      *
337      * Requirements:
338      *
339      * - The divisor cannot be zero.
340      */
341     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
342         require(b != 0, errorMessage);
343         return a % b;
344     }
345 }
346 
347 
348 
349 
350 
351 // Deposit contract interface
352 interface IDepositContract {
353     /// @notice A processed deposit event.
354     event DepositEvent(
355         bytes pubkey,
356         bytes withdrawal_credentials,
357         bytes amount,
358         bytes signature,
359         bytes index
360     );
361 
362     /// @notice Submit a Phase 0 DepositData object.
363     /// @param pubkey A BLS12-381 public key.
364     /// @param withdrawal_credentials Commitment to a public key for withdrawals.
365     /// @param signature A BLS12-381 signature.
366     /// @param deposit_data_root The SHA-256 hash of the SSZ-encoded DepositData object.
367     /// Used as a protection against malformed input.
368     function deposit(
369         bytes calldata pubkey,
370         bytes calldata withdrawal_credentials,
371         bytes calldata signature,
372         bytes32 deposit_data_root
373     ) external payable;
374 
375     /// @notice Query the current deposit root hash.
376     /// @return The deposit root hash.
377     function get_deposit_root() external view returns (bytes32);
378 
379     /// @notice Query the current deposit count.
380     /// @return The deposit count encoded as a little endian 64-bit number.
381     function get_deposit_count() external view returns (bytes memory);
382 }
383 
384 
385 contract BatchDeposit is Pausable, Ownable {
386     using SafeMath for uint256;
387 
388     address depositContract;
389     uint256 private _fee;
390 
391     uint256 constant PUBKEY_LENGTH = 48;
392     uint256 constant SIGNATURE_LENGTH = 96;
393     uint256 constant CREDENTIALS_LENGTH = 32;
394     uint256 constant MAX_VALIDATORS = 100;
395     uint256 constant DEPOSIT_AMOUNT = 32 ether;
396 
397     event FeeChanged(uint256 previousFee, uint256 newFee);
398     event Withdrawn(address indexed payee, uint256 weiAmount);
399     event FeeCollected(address indexed payee, uint256 weiAmount);
400 
401     constructor(address depositContractAddr, uint256 initialFee) public {
402         require(initialFee % 1000000000 == 0, "Fee must be a multiple of GWEI");
403 
404         depositContract = depositContractAddr;
405         _fee = initialFee;
406     }
407 
408     /**
409      * @dev Performs a batch deposit, asking for an additional fee payment.
410      */
411     function batchDeposit(
412         bytes calldata pubkeys, 
413         bytes calldata withdrawal_credentials, 
414         bytes calldata signatures, 
415         bytes32[] calldata deposit_data_roots
416     ) 
417         external payable whenNotPaused 
418     {
419         // sanity checks
420         require(msg.value % 1000000000 == 0, "BatchDeposit: Deposit value not multiple of GWEI");
421         require(msg.value >= DEPOSIT_AMOUNT, "BatchDeposit: Amount is too low");
422 
423         uint256 count = deposit_data_roots.length;
424         require(count > 0, "BatchDeposit: You should deposit at least one validator");
425         require(count <= MAX_VALIDATORS, "BatchDeposit: You can deposit max 100 validators at a time");
426 
427         require(pubkeys.length == count * PUBKEY_LENGTH, "BatchDeposit: Pubkey count don't match");
428         require(signatures.length == count * SIGNATURE_LENGTH, "BatchDeposit: Signatures count don't match");
429         require(withdrawal_credentials.length == 1 * CREDENTIALS_LENGTH, "BatchDeposit: Withdrawal Credentials count don't match");
430 
431         uint256 expectedAmount = _fee.add(DEPOSIT_AMOUNT).mul(count);
432         require(msg.value > expectedAmount, "BatchDeposit: Amount is not aligned with pubkeys number");
433 
434         // emit FeeCollected(msg.sender, _fee.mul(count));
435 
436         for (uint256 i = 0; i < count; ++i) {
437             bytes memory pubkey = bytes(pubkeys[i*PUBKEY_LENGTH:(i+1)*PUBKEY_LENGTH]);
438             bytes memory signature = bytes(signatures[i*SIGNATURE_LENGTH:(i+1)*SIGNATURE_LENGTH]);
439 
440             IDepositContract(depositContract).deposit{value: DEPOSIT_AMOUNT}(
441                 pubkey,
442                 withdrawal_credentials,
443                 signature,
444                 deposit_data_roots[i]
445             );
446         }
447     }
448 
449     /**
450      * @dev Withdraw accumulated fee in the contract
451      *
452      * @param receiver The address where all accumulated funds will be transferred to.
453      * Can only be called by the current owner.
454      */
455     function withdraw(address payable receiver) public onlyOwner {       
456         require(receiver != address(0), "You can't burn these eth directly");
457 
458         uint256 amount = address(this).balance;
459         emit Withdrawn(receiver, amount);
460         receiver.transfer(amount);
461     }
462 
463     /**
464      * @dev Change the validator fee (`newOwner`).
465      * Can only be called by the current owner.
466      */
467     function changeFee(uint256 newFee) public onlyOwner {
468         require(newFee != _fee, "Fee must be different from current one");
469         require(newFee % 1000000000 == 0, "Fee must be a multiple of GWEI");
470 
471         emit FeeChanged(_fee, newFee);
472         _fee = newFee;
473     }
474 
475     /**
476      * @dev Triggers stopped state.
477      *
478      * Requirements:
479      *
480      * - The contract must not be paused.
481      */
482     function pause() public onlyOwner {
483         _pause();
484     }
485 
486     /**
487      * @dev Returns to normal state.
488      *
489      * Requirements:
490      *
491      * - The contract must be paused.
492      */
493     function unpause() public onlyOwner {
494         _unpause();
495     }
496 
497     /**
498      * @dev Returns the current fee
499      */
500     function fee() public view returns (uint256) {
501         return _fee;
502     }
503   
504     /**
505      * Disable renunce ownership
506      */
507     function renounceOwnership() public override onlyOwner {
508         revert("Ownable: renounceOwnership is disabled");
509     }
510 }