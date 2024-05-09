1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.6.0;
4 
5 
6 // 
7 /**
8  * @dev Wrappers over Solidity's arithmetic operations with added overflow
9  * checks.
10  *
11  * Arithmetic operations in Solidity wrap on overflow. This can easily result
12  * in bugs, because programmers usually assume that an overflow raises an
13  * error, which is the standard behavior in high level programming languages.
14  * `SafeMath` restores this intuition by reverting the transaction when an
15  * operation overflows.
16  *
17  * Using this library instead of the unchecked operations eliminates an entire
18  * class of bugs, so it's recommended to use it always.
19  */
20 library SafeMath {
21     /**
22      * @dev Returns the addition of two unsigned integers, reverting on
23      * overflow.
24      *
25      * Counterpart to Solidity's `+` operator.
26      *
27      * Requirements:
28      *
29      * - Addition cannot overflow.
30      */
31     function add(uint256 a, uint256 b) internal pure returns (uint256) {
32         uint256 c = a + b;
33         require(c >= a, "SafeMath: addition overflow");
34 
35         return c;
36     }
37 
38     /**
39      * @dev Returns the subtraction of two unsigned integers, reverting on
40      * overflow (when the result is negative).
41      *
42      * Counterpart to Solidity's `-` operator.
43      *
44      * Requirements:
45      *
46      * - Subtraction cannot overflow.
47      */
48     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
49         return sub(a, b, "SafeMath: subtraction overflow");
50     }
51 
52     /**
53      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
54      * overflow (when the result is negative).
55      *
56      * Counterpart to Solidity's `-` operator.
57      *
58      * Requirements:
59      *
60      * - Subtraction cannot overflow.
61      */
62     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
63         require(b <= a, errorMessage);
64         uint256 c = a - b;
65 
66         return c;
67     }
68 
69     /**
70      * @dev Returns the multiplication of two unsigned integers, reverting on
71      * overflow.
72      *
73      * Counterpart to Solidity's `*` operator.
74      *
75      * Requirements:
76      *
77      * - Multiplication cannot overflow.
78      */
79     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
80         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
81         // benefit is lost if 'b' is also tested.
82         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
83         if (a == 0) {
84             return 0;
85         }
86 
87         uint256 c = a * b;
88         require(c / a == b, "SafeMath: multiplication overflow");
89 
90         return c;
91     }
92 
93     /**
94      * @dev Returns the integer division of two unsigned integers. Reverts on
95      * division by zero. The result is rounded towards zero.
96      *
97      * Counterpart to Solidity's `/` operator. Note: this function uses a
98      * `revert` opcode (which leaves remaining gas untouched) while Solidity
99      * uses an invalid opcode to revert (consuming all remaining gas).
100      *
101      * Requirements:
102      *
103      * - The divisor cannot be zero.
104      */
105     function div(uint256 a, uint256 b) internal pure returns (uint256) {
106         return div(a, b, "SafeMath: division by zero");
107     }
108 
109     /**
110      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
111      * division by zero. The result is rounded towards zero.
112      *
113      * Counterpart to Solidity's `/` operator. Note: this function uses a
114      * `revert` opcode (which leaves remaining gas untouched) while Solidity
115      * uses an invalid opcode to revert (consuming all remaining gas).
116      *
117      * Requirements:
118      *
119      * - The divisor cannot be zero.
120      */
121     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
122         require(b > 0, errorMessage);
123         uint256 c = a / b;
124         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
125 
126         return c;
127     }
128 
129     /**
130      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
131      * Reverts when dividing by zero.
132      *
133      * Counterpart to Solidity's `%` operator. This function uses a `revert`
134      * opcode (which leaves remaining gas untouched) while Solidity uses an
135      * invalid opcode to revert (consuming all remaining gas).
136      *
137      * Requirements:
138      *
139      * - The divisor cannot be zero.
140      */
141     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
142         return mod(a, b, "SafeMath: modulo by zero");
143     }
144 
145     /**
146      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
147      * Reverts with custom message when dividing by zero.
148      *
149      * Counterpart to Solidity's `%` operator. This function uses a `revert`
150      * opcode (which leaves remaining gas untouched) while Solidity uses an
151      * invalid opcode to revert (consuming all remaining gas).
152      *
153      * Requirements:
154      *
155      * - The divisor cannot be zero.
156      */
157     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
158         require(b != 0, errorMessage);
159         return a % b;
160     }
161 }
162 
163 // 
164 /*
165  * @dev Provides information about the current execution context, including the
166  * sender of the transaction and its data. While these are generally available
167  * via msg.sender and msg.data, they should not be accessed in such a direct
168  * manner, since when dealing with GSN meta-transactions the account sending and
169  * paying for execution may not be the actual sender (as far as an application
170  * is concerned).
171  *
172  * This contract is only required for intermediate, library-like contracts.
173  */
174 abstract contract Context {
175     function _msgSender() internal view virtual returns (address payable) {
176         return msg.sender;
177     }
178 
179     function _msgData() internal view virtual returns (bytes memory) {
180         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
181         return msg.data;
182     }
183 }
184 
185 // 
186 /**
187  * @dev Contract module which provides a basic access control mechanism, where
188  * there is an account (an owner) that can be granted exclusive access to
189  * specific functions.
190  *
191  * By default, the owner account will be the one that deploys the contract. This
192  * can later be changed with {transferOwnership}.
193  *
194  * This module is used through inheritance. It will make available the modifier
195  * `onlyOwner`, which can be applied to your functions to restrict their use to
196  * the owner.
197  */
198 contract Ownable is Context {
199     address private _owner;
200 
201     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
202 
203     /**
204      * @dev Initializes the contract setting the deployer as the initial owner.
205      */
206     constructor () internal {
207         address msgSender = _msgSender();
208         _owner = msgSender;
209         emit OwnershipTransferred(address(0), msgSender);
210     }
211 
212     /**
213      * @dev Returns the address of the current owner.
214      */
215     function owner() public view returns (address) {
216         return _owner;
217     }
218 
219     /**
220      * @dev Throws if called by any account other than the owner.
221      */
222     modifier onlyOwner() {
223         require(_owner == _msgSender(), "Ownable: caller is not the owner");
224         _;
225     }
226 
227     /**
228      * @dev Leaves the contract without owner. It will not be possible to call
229      * `onlyOwner` functions anymore. Can only be called by the current owner.
230      *
231      * NOTE: Renouncing ownership will leave the contract without an owner,
232      * thereby removing any functionality that is only available to the owner.
233      */
234     function renounceOwnership() public virtual onlyOwner {
235         emit OwnershipTransferred(_owner, address(0));
236         _owner = address(0);
237     }
238 
239     /**
240      * @dev Transfers ownership of the contract to a new account (`newOwner`).
241      * Can only be called by the current owner.
242      */
243     function transferOwnership(address newOwner) public virtual onlyOwner {
244         require(newOwner != address(0), "Ownable: new owner is the zero address");
245         emit OwnershipTransferred(_owner, newOwner);
246         _owner = newOwner;
247     }
248 }
249 
250 // 
251 /**
252  * @dev Interface of the ERC20 standard as defined in the EIP.
253  */
254 interface IERC20 {
255     /**
256      * @dev Returns the amount of tokens in existence.
257      */
258     function totalSupply() external view returns (uint256);
259 
260     /**
261      * @dev Returns the amount of tokens owned by `account`.
262      */
263     function balanceOf(address account) external view returns (uint256);
264 
265     /**
266      * @dev Moves `amount` tokens from the caller's account to `recipient`.
267      *
268      * Returns a boolean value indicating whether the operation succeeded.
269      *
270      * Emits a {Transfer} event.
271      */
272     function transfer(address recipient, uint256 amount) external returns (bool);
273 
274     /**
275      * @dev Returns the remaining number of tokens that `spender` will be
276      * allowed to spend on behalf of `owner` through {transferFrom}. This is
277      * zero by default.
278      *
279      * This value changes when {approve} or {transferFrom} are called.
280      */
281     function allowance(address owner, address spender) external view returns (uint256);
282 
283     /**
284      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
285      *
286      * Returns a boolean value indicating whether the operation succeeded.
287      *
288      * IMPORTANT: Beware that changing an allowance with this method brings the risk
289      * that someone may use both the old and the new allowance by unfortunate
290      * transaction ordering. One possible solution to mitigate this race
291      * condition is to first reduce the spender's allowance to 0 and set the
292      * desired value afterwards:
293      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
294      *
295      * Emits an {Approval} event.
296      */
297     function approve(address spender, uint256 amount) external returns (bool);
298 
299     /**
300      * @dev Moves `amount` tokens from `sender` to `recipient` using the
301      * allowance mechanism. `amount` is then deducted from the caller's
302      * allowance.
303      *
304      * Returns a boolean value indicating whether the operation succeeded.
305      *
306      * Emits a {Transfer} event.
307      */
308     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
309 
310     /**
311      * @dev Emitted when `value` tokens are moved from one account (`from`) to
312      * another (`to`).
313      *
314      * Note that `value` may be zero.
315      */
316     event Transfer(address indexed from, address indexed to, uint256 value);
317 
318     /**
319      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
320      * a call to {approve}. `value` is the new allowance.
321      */
322     event Approval(address indexed owner, address indexed spender, uint256 value);
323 }
324 
325 // 
326 contract PublicSaleContract is Ownable {
327 
328 	using SafeMath for uint256;
329 
330 	event Whitelist(address indexed _address, bool _isStaking);
331 	event Deposit(uint256 _timestamp, address indexed _address);
332 	event Refund(uint256 _timestamp, address indexed _address);
333 	event TokenReleased(uint256 _timestamp, address indexed _address, uint256 _amount);
334 
335 	// Token Contract
336 	IERC20 tokenContract = IERC20(0x03042482d64577A7bdb282260e2eA4c8a89C064B);
337 	uint256 public noStakeReleaseAmount = 166666.67 ether;
338 	uint256 public stakeReleaseFirstBatchAmount = 83333.33 ether;
339 	uint256 public stakeReleaseSecondBatchAmount = 87500 ether;
340 
341 	// Receiving Address
342 	address payable receivingAddress = 0x6359EAdBB84C8f7683E26F392A1573Ab6a37B4b4;
343 
344 	// Contract status
345 	ContractStatus public status;
346 
347 	enum ContractStatus {
348 		INIT, 
349 		ACCEPT_DEPOSIT, 
350 		FIRST_BATCH_TOKEN_RELEASED, 
351 		SECOND_BATCH_TOKEN_RELEASED
352 	}
353 
354 
355 	// Whitelist
356 	mapping(address => WhitelistDetail) whitelist;
357 
358 	struct WhitelistDetail {
359         // Check if address is whitelisted
360         bool isWhitelisted;
361 
362         // Check if address is staking
363         bool isStaking;
364 
365         // Check if address has deposited
366         bool hasDeposited;
367     }
368 
369 	// Total count of whitelisted address
370 	uint256 public whitelistCount = 0;
371 
372 	// Addresses that deposited
373 	address[] depositAddresses;
374 	uint256 dIndex = 0;
375 
376 	// Addresses for second batch release
377 	address[] secondBatchAddresses;
378 	uint256 sIndex = 0;
379 
380 	// Total count of deposits
381 	uint256 public depositCount = 0;
382 
383 	// Deposit ticket size
384 	uint256 public ticketSize = 2.85 ether;
385 
386 	// Duration of stake
387 	uint256 constant stakeDuration = 30 days;
388 
389 	// Time that staking starts
390 	uint256 public stakeStart;
391 
392 	constructor() public {
393 		status = ContractStatus.INIT;
394 	}
395 
396 	function updateReceivingAddress(address payable _address) public onlyOwner {
397 		receivingAddress = _address;
398 	}
399 
400 	/**
401      * @dev ContractStatus.INIT functions
402      */
403 
404 	function whitelistAddresses(address[] memory _addresses, bool[] memory _isStaking) public onlyOwner {
405 		require(status == ContractStatus.INIT);
406 
407 		for (uint256 i = 0; i < _addresses.length; i++) {
408 			if (!whitelist[_addresses[i]].isWhitelisted) {
409 				whitelistCount = whitelistCount.add(1);
410 			}
411 
412 			whitelist[_addresses[i]].isWhitelisted = true;
413 			whitelist[_addresses[i]].isStaking = _isStaking[i];
414 
415 			emit Whitelist(_addresses[i], _isStaking[i]);
416 		}
417 	}
418 
419 	function updateTicketSize(uint256 _amount) public onlyOwner {
420 		require(status == ContractStatus.INIT);
421 
422 		ticketSize = _amount;
423 	}
424 
425 	function acceptDeposit() public onlyOwner {
426 		require(status == ContractStatus.INIT);
427 
428 		status = ContractStatus.ACCEPT_DEPOSIT;
429 	}
430 
431 	/**
432      * @dev ContractStatus.ACCEPT_DEPOSIT functions
433      */
434 
435     receive() external payable {
436 		deposit();
437 	}
438 
439 	function deposit() internal {
440 		require(status == ContractStatus.ACCEPT_DEPOSIT);
441 		require(whitelist[msg.sender].isWhitelisted && !whitelist[msg.sender].hasDeposited);
442 		require(msg.value >= ticketSize);
443 
444 		msg.sender.transfer(msg.value.sub(ticketSize));
445 		whitelist[msg.sender].hasDeposited = true;
446 		depositAddresses.push(msg.sender);
447 		depositCount = depositCount.add(1);
448 
449 		emit Deposit(block.timestamp, msg.sender);
450 	}
451 
452 	function refund(address payable _address) public onlyOwner {
453 		require(whitelist[_address].hasDeposited);
454 
455 		delete whitelist[_address];
456 		_address.transfer(ticketSize);
457 		depositCount = depositCount.sub(1);
458 
459 		emit Refund(block.timestamp, _address);
460 	}
461 
462 	function refundMultiple(address payable[] memory _addresses) public onlyOwner {
463 		for (uint256 i = 0; i < _addresses.length; i++) {
464 			if (whitelist[_addresses[i]].hasDeposited) {
465 				delete whitelist[_addresses[i]];
466 				_addresses[i].transfer(ticketSize);
467 				depositCount = depositCount.sub(1);
468 
469 				emit Refund(block.timestamp, _addresses[i]);
470 			}
471 		}
472 	}
473 
474 	function releaseFirstBatchTokens(uint256 _count) public onlyOwner {
475 		require(status == ContractStatus.ACCEPT_DEPOSIT);
476 
477 		for (uint256 i = 0; i < _count; i++) {
478 			if (whitelist[depositAddresses[dIndex]].isWhitelisted) {
479 				if (whitelist[depositAddresses[dIndex]].isStaking) {
480 					// Is staking
481 					tokenContract.transfer(depositAddresses[dIndex], stakeReleaseFirstBatchAmount);
482 					secondBatchAddresses.push(depositAddresses[dIndex]);
483 
484 					emit TokenReleased(block.timestamp, depositAddresses[dIndex], stakeReleaseFirstBatchAmount);
485 				} else {
486 					// Not staking
487 					tokenContract.transfer(depositAddresses[dIndex], noStakeReleaseAmount);
488 
489 					emit TokenReleased(block.timestamp, depositAddresses[dIndex], noStakeReleaseAmount);
490 				}
491 			}
492 
493 			dIndex = dIndex.add(1);
494 
495 			if (dIndex == depositAddresses.length) {
496 				receivingAddress.transfer(address(this).balance);
497 				stakeStart = block.timestamp;
498 				status = ContractStatus.FIRST_BATCH_TOKEN_RELEASED;
499 				break;
500 			}
501 		}
502 	}
503 
504 	/**
505      * @dev ContractStatus.FIRST_BATCH_TOKEN_RELEASED functions
506      */
507 
508     function releaseSecondBatchTokens(uint256 _count) public onlyOwner {
509 		require(status == ContractStatus.FIRST_BATCH_TOKEN_RELEASED);
510 		require(block.timestamp > (stakeStart + stakeDuration));
511 
512 		for (uint256 i = 0; i < _count; i++) {
513 			tokenContract.transfer(secondBatchAddresses[sIndex], stakeReleaseSecondBatchAmount);
514 			emit TokenReleased(block.timestamp, secondBatchAddresses[sIndex], stakeReleaseSecondBatchAmount);
515 
516 			sIndex = sIndex.add(1);
517 
518 			if (sIndex == secondBatchAddresses.length) {
519 				status = ContractStatus.SECOND_BATCH_TOKEN_RELEASED;
520 				break;
521 			}
522 		}
523 	}
524 
525 	/**
526      * @dev ContractStatus.SECOND_BATCH_TOKEN_RELEASED functions
527      */
528 
529 	function withdrawTokens() public onlyOwner {
530 		require(status == ContractStatus.SECOND_BATCH_TOKEN_RELEASED);
531 
532 		tokenContract.transfer(receivingAddress, tokenContract.balanceOf(address(this)));
533 	}
534 
535 }