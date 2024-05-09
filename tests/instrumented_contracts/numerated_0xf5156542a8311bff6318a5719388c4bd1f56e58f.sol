1 // TokenDistributor v1.0
2 
3 // File: @openzeppelin/contracts/GSN/Context.sol
4 
5 pragma solidity ^0.5.0;
6 
7 /*
8  * @dev Provides information about the current execution context, including the
9  * sender of the transaction and its data. While these are generally available
10  * via msg.sender and msg.data, they should not be accessed in such a direct
11  * manner, since when dealing with GSN meta-transactions the account sending and
12  * paying for execution may not be the actual sender (as far as an application
13  * is concerned).
14  *
15  * This contract is only required for intermediate, library-like contracts.
16  */
17 contract Context {
18     // Empty internal constructor, to prevent people from mistakenly deploying
19     // an instance of this contract, which should be used via inheritance.
20     constructor () internal { }
21     // solhint-disable-previous-line no-empty-blocks
22 
23     function _msgSender() internal view returns (address payable) {
24         return msg.sender;
25     }
26 
27     function _msgData() internal view returns (bytes memory) {
28         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
29         return msg.data;
30     }
31 }
32 
33 // File: @openzeppelin/contracts/ownership/Ownable.sol
34 
35 pragma solidity ^0.5.0;
36 
37 /**
38  * @dev Contract module which provides a basic access control mechanism, where
39  * there is an account (an owner) that can be granted exclusive access to
40  * specific functions.
41  *
42  * This module is used through inheritance. It will make available the modifier
43  * `onlyOwner`, which can be applied to your functions to restrict their use to
44  * the owner.
45  */
46 contract Ownable is Context {
47     address private _owner;
48 
49     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
50 
51     /**
52      * @dev Initializes the contract setting the deployer as the initial owner.
53      */
54     constructor () internal {
55         address msgSender = _msgSender();
56         _owner = msgSender;
57         emit OwnershipTransferred(address(0), msgSender);
58     }
59 
60     /**
61      * @dev Returns the address of the current owner.
62      */
63     function owner() public view returns (address) {
64         return _owner;
65     }
66 
67     /**
68      * @dev Throws if called by any account other than the owner.
69      */
70     modifier onlyOwner() {
71         require(isOwner(), "Ownable: caller is not the owner");
72         _;
73     }
74 
75     /**
76      * @dev Returns true if the caller is the current owner.
77      */
78     function isOwner() public view returns (bool) {
79         return _msgSender() == _owner;
80     }
81 
82     /**
83      * @dev Leaves the contract without owner. It will not be possible to call
84      * `onlyOwner` functions anymore. Can only be called by the current owner.
85      *
86      * NOTE: Renouncing ownership will leave the contract without an owner,
87      * thereby removing any functionality that is only available to the owner.
88      */
89     function renounceOwnership() public onlyOwner {
90         emit OwnershipTransferred(_owner, address(0));
91         _owner = address(0);
92     }
93 
94     /**
95      * @dev Transfers ownership of the contract to a new account (`newOwner`).
96      * Can only be called by the current owner.
97      */
98     function transferOwnership(address newOwner) public onlyOwner {
99         _transferOwnership(newOwner);
100     }
101 
102     /**
103      * @dev Transfers ownership of the contract to a new account (`newOwner`).
104      */
105     function _transferOwnership(address newOwner) internal {
106         require(newOwner != address(0), "Ownable: new owner is the zero address");
107         emit OwnershipTransferred(_owner, newOwner);
108         _owner = newOwner;
109     }
110 }
111 
112 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
113 
114 pragma solidity ^0.5.0;
115 
116 /**
117  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
118  * the optional functions; to access them see {ERC20Detailed}.
119  */
120 interface IERC20 {
121     /**
122      * @dev Returns the amount of tokens in existence.
123      */
124     function totalSupply() external view returns (uint256);
125 
126     /**
127      * @dev Returns the amount of tokens owned by `account`.
128      */
129     function balanceOf(address account) external view returns (uint256);
130 
131     /**
132      * @dev Moves `amount` tokens from the caller's account to `recipient`.
133      *
134      * Returns a boolean value indicating whether the operation succeeded.
135      *
136      * Emits a {Transfer} event.
137      */
138     function transfer(address recipient, uint256 amount) external returns (bool);
139 
140     /**
141      * @dev Returns the remaining number of tokens that `spender` will be
142      * allowed to spend on behalf of `owner` through {transferFrom}. This is
143      * zero by default.
144      *
145      * This value changes when {approve} or {transferFrom} are called.
146      */
147     function allowance(address owner, address spender) external view returns (uint256);
148 
149     /**
150      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
151      *
152      * Returns a boolean value indicating whether the operation succeeded.
153      *
154      * IMPORTANT: Beware that changing an allowance with this method brings the risk
155      * that someone may use both the old and the new allowance by unfortunate
156      * transaction ordering. One possible solution to mitigate this race
157      * condition is to first reduce the spender's allowance to 0 and set the
158      * desired value afterwards:
159      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
160      *
161      * Emits an {Approval} event.
162      */
163     function approve(address spender, uint256 amount) external returns (bool);
164 
165     /**
166      * @dev Moves `amount` tokens from `sender` to `recipient` using the
167      * allowance mechanism. `amount` is then deducted from the caller's
168      * allowance.
169      *
170      * Returns a boolean value indicating whether the operation succeeded.
171      *
172      * Emits a {Transfer} event.
173      */
174     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
175 
176     /**
177      * @dev Emitted when `value` tokens are moved from one account (`from`) to
178      * another (`to`).
179      *
180      * Note that `value` may be zero.
181      */
182     event Transfer(address indexed from, address indexed to, uint256 value);
183 
184     /**
185      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
186      * a call to {approve}. `value` is the new allowance.
187      */
188     event Approval(address indexed owner, address indexed spender, uint256 value);
189 }
190 
191 // File: @openzeppelin/contracts/math/SafeMath.sol
192 
193 pragma solidity ^0.5.0;
194 
195 /**
196  * @dev Wrappers over Solidity's arithmetic operations with added overflow
197  * checks.
198  *
199  * Arithmetic operations in Solidity wrap on overflow. This can easily result
200  * in bugs, because programmers usually assume that an overflow raises an
201  * error, which is the standard behavior in high level programming languages.
202  * `SafeMath` restores this intuition by reverting the transaction when an
203  * operation overflows.
204  *
205  * Using this library instead of the unchecked operations eliminates an entire
206  * class of bugs, so it's recommended to use it always.
207  */
208 library SafeMath {
209     /**
210      * @dev Returns the addition of two unsigned integers, reverting on
211      * overflow.
212      *
213      * Counterpart to Solidity's `+` operator.
214      *
215      * Requirements:
216      * - Addition cannot overflow.
217      */
218     function add(uint256 a, uint256 b) internal pure returns (uint256) {
219         uint256 c = a + b;
220         require(c >= a, "SafeMath: addition overflow");
221 
222         return c;
223     }
224 
225     /**
226      * @dev Returns the subtraction of two unsigned integers, reverting on
227      * overflow (when the result is negative).
228      *
229      * Counterpart to Solidity's `-` operator.
230      *
231      * Requirements:
232      * - Subtraction cannot overflow.
233      */
234     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
235         return sub(a, b, "SafeMath: subtraction overflow");
236     }
237 
238     /**
239      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
240      * overflow (when the result is negative).
241      *
242      * Counterpart to Solidity's `-` operator.
243      *
244      * Requirements:
245      * - Subtraction cannot overflow.
246      *
247      * _Available since v2.4.0._
248      */
249     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
250         require(b <= a, errorMessage);
251         uint256 c = a - b;
252 
253         return c;
254     }
255 
256     /**
257      * @dev Returns the multiplication of two unsigned integers, reverting on
258      * overflow.
259      *
260      * Counterpart to Solidity's `*` operator.
261      *
262      * Requirements:
263      * - Multiplication cannot overflow.
264      */
265     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
266         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
267         // benefit is lost if 'b' is also tested.
268         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
269         if (a == 0) {
270             return 0;
271         }
272 
273         uint256 c = a * b;
274         require(c / a == b, "SafeMath: multiplication overflow");
275 
276         return c;
277     }
278 
279     /**
280      * @dev Returns the integer division of two unsigned integers. Reverts on
281      * division by zero. The result is rounded towards zero.
282      *
283      * Counterpart to Solidity's `/` operator. Note: this function uses a
284      * `revert` opcode (which leaves remaining gas untouched) while Solidity
285      * uses an invalid opcode to revert (consuming all remaining gas).
286      *
287      * Requirements:
288      * - The divisor cannot be zero.
289      */
290     function div(uint256 a, uint256 b) internal pure returns (uint256) {
291         return div(a, b, "SafeMath: division by zero");
292     }
293 
294     /**
295      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
296      * division by zero. The result is rounded towards zero.
297      *
298      * Counterpart to Solidity's `/` operator. Note: this function uses a
299      * `revert` opcode (which leaves remaining gas untouched) while Solidity
300      * uses an invalid opcode to revert (consuming all remaining gas).
301      *
302      * Requirements:
303      * - The divisor cannot be zero.
304      *
305      * _Available since v2.4.0._
306      */
307     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
308         // Solidity only automatically asserts when dividing by 0
309         require(b > 0, errorMessage);
310         uint256 c = a / b;
311         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
312 
313         return c;
314     }
315 
316     /**
317      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
318      * Reverts when dividing by zero.
319      *
320      * Counterpart to Solidity's `%` operator. This function uses a `revert`
321      * opcode (which leaves remaining gas untouched) while Solidity uses an
322      * invalid opcode to revert (consuming all remaining gas).
323      *
324      * Requirements:
325      * - The divisor cannot be zero.
326      */
327     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
328         return mod(a, b, "SafeMath: modulo by zero");
329     }
330 
331     /**
332      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
333      * Reverts with custom message when dividing by zero.
334      *
335      * Counterpart to Solidity's `%` operator. This function uses a `revert`
336      * opcode (which leaves remaining gas untouched) while Solidity uses an
337      * invalid opcode to revert (consuming all remaining gas).
338      *
339      * Requirements:
340      * - The divisor cannot be zero.
341      *
342      * _Available since v2.4.0._
343      */
344     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
345         require(b != 0, errorMessage);
346         return a % b;
347     }
348 }
349 
350 // File: contracts/TokenDistributor.sol
351 
352 pragma solidity 0.5.16;
353 
354 
355 
356 
357 contract TokenDistributor is Ownable {
358 	using SafeMath for uint256;
359 
360 	// The token holder that distribution will be done on behalf of
361 	address public tokenHolder;
362 
363 	// The  tokens that will be distributed
364 	IERC20 public tokenContract;
365 
366 	// The states that the contract can be in
367 	enum ContractState {
368 		NONE, // State where nothing is set up
369 		LOADING, // State where addresses/amounts can be added
370 		LOCKED // State where no new addresses can be added, but distribute can be called
371 	}
372 
373 	// The current state that the contract is in
374 	ContractState public currentState;
375 
376 	// Distribution stats - populated with the load() function
377 	address[] public distributionAddresses;
378 	uint256[] public distributionAmounts;
379 	uint256 public totalDistributionAmount;
380 
381 	// Track the index for the distribution - increases by 1 with each transferFrom() call
382 	uint256 public currentDistributionCount;
383 
384 	// Events
385 	event Reset(address indexed _tokenHolder, IERC20 indexed _tokenContract);
386 	event Load(uint256 currentLoaded, uint256 totalLoaded);
387 	event Lock(uint256 totalLoaded);
388 	event Distribute(uint256 currentDistributed, uint256 totalDistributed);
389 
390 	/**
391 	 * Constructor to set the owner.
392 	 * Will transfer ownership to the specified address.
393 	 */
394 	constructor(address _owner) public {
395 		transferOwnership(_owner);
396 		currentState = ContractState.NONE;
397 	}
398 
399 	/**
400 	 * The reset() function sets all variables back to the initial state for a new distribution.
401 	 */
402 	function reset(address _tokenHolder, IERC20 _tokenContract) public onlyOwner {
403 		// Save off the token holder address and token contract
404 		tokenHolder = _tokenHolder;
405 		tokenContract = _tokenContract;
406 
407 		// Verify the token holder does not already have an amount allowed - should be 0 at the start
408 		require(checkAllowanceAmount() == 0, "Reset failed since tokenHolder already has an allowance balance");
409 
410 		// Reset distribution vars
411 		distributionAddresses.length = 0;
412 		distributionAmounts.length = 0;
413 		totalDistributionAmount = 0;
414 		currentDistributionCount = 0;
415 
416 		// Reset the state to loading
417 		currentState = ContractState.LOADING;
418 
419 		// Emit the event
420 		emit Reset(_tokenHolder, _tokenContract);
421 	}
422 
423 	/**
424 	 * Called iteratively to build the distribution list of tokens that will be sent out.
425 	 */
426 	function load(address[] memory addresses, uint256[] memory amounts) public onlyOwner {
427 		// Verify the current state is loading
428 		require(currentState == ContractState.LOADING, "load() can only be called when in LOADING state.");
429 
430 		// Verify the lists are correct length
431 		require(addresses.length == amounts.length, "load() array lengths must match");
432 
433 		// Add the values to the distribution vars
434 		for(uint256 i = 0; i < addresses.length; i++) {
435 			distributionAddresses.push(addresses[i]);
436 			distributionAmounts.push(amounts[i]);
437 			totalDistributionAmount = totalDistributionAmount.add(amounts[i]);
438 		}
439 
440 		// Emit the event
441 		emit Load(addresses.length, distributionAddresses.length);
442 	}
443 
444 	/**
445 	 * Called once the distribution list is complete.  This locks the list in place.
446 	 */
447 	function lock() public onlyOwner {
448 		// Verify the current state is loading
449 		require(currentState == ContractState.LOADING, "lock() can only be called when in LOADING state.");
450 
451 		currentState = ContractState.LOCKED;
452 
453 		// Emit the event
454 		emit Lock(distributionAddresses.length);
455 	}
456 
457 	/**
458 	 * Iteratively called to send batches out until all tokens are distributed.
459 	 * Note that it will delete items from the list as it goes to free up storage and reclaim gas.
460 	 * Reclaiming gas cuts total gas consumed by approx 50% with test token.
461 	 */
462 	function distribute(uint256 batchSize) public onlyOwner {
463 		// Verify the state
464 		require(currentState == ContractState.LOCKED, "distribute() can only be called when in LOCKED state.");
465 
466 		// Track the number of distributions
467 		uint256 numberDistributed = 0;
468 
469 		// Iterate and send tokens
470 		while( currentDistributionCount < distributionAddresses.length && numberDistributed < batchSize) {
471 			// Send tokens
472 			tokenContract.transferFrom(tokenHolder, distributionAddresses[currentDistributionCount], distributionAmounts[currentDistributionCount]);
473 
474 			// Delete the items to reclaim gas
475 			delete distributionAddresses[currentDistributionCount];
476 			delete distributionAmounts[currentDistributionCount];
477 
478 			// Update counters
479 			numberDistributed = numberDistributed.add(1);
480 			currentDistributionCount = currentDistributionCount.add(1);
481 		}
482 
483 		// Emit the event
484 		emit Distribute(numberDistributed, currentDistributionCount);
485 	}
486 
487 	/**
488 	 * Convenience function just to check how many tokens are allowed to be sent on the token holder's behalf.
489 	 */
490 	function checkAllowanceAmount() public view returns (uint256) {
491 		return tokenContract.allowance(tokenHolder, address(this));
492 	}
493 
494 	/**
495 	 * Convenience function to get distribution addresses
496 	 */
497   function getDistributionAddressesArray() public view returns (address[] memory) {
498       return distributionAddresses;
499   }
500 
501 	/**
502 	 * Convenience function to get distribution amounts
503 	 */
504   function getDistributionAmountsArray() public view returns (uint256[] memory) {
505       return distributionAmounts;
506   }
507 }