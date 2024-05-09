1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.6.0;
4 pragma experimental ABIEncoderV2;
5 
6 
7 // 
8 /*
9  * @dev Provides information about the current execution context, including the
10  * sender of the transaction and its data. While these are generally available
11  * via msg.sender and msg.data, they should not be accessed in such a direct
12  * manner, since when dealing with GSN meta-transactions the account sending and
13  * paying for execution may not be the actual sender (as far as an application
14  * is concerned).
15  *
16  * This contract is only required for intermediate, library-like contracts.
17  */
18 abstract contract Context {
19     function _msgSender() internal view virtual returns (address payable) {
20         return msg.sender;
21     }
22 
23     function _msgData() internal view virtual returns (bytes memory) {
24         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
25         return msg.data;
26     }
27 }
28 
29 // 
30 /**
31  * @dev Contract module which provides a basic access control mechanism, where
32  * there is an account (an owner) that can be granted exclusive access to
33  * specific functions.
34  *
35  * By default, the owner account will be the one that deploys the contract. This
36  * can later be changed with {transferOwnership}.
37  *
38  * This module is used through inheritance. It will make available the modifier
39  * `onlyOwner`, which can be applied to your functions to restrict their use to
40  * the owner.
41  */
42 contract Ownable is Context {
43     address private _owner;
44 
45     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
46 
47     /**
48      * @dev Initializes the contract setting the deployer as the initial owner.
49      */
50     constructor () internal {
51         address msgSender = _msgSender();
52         _owner = msgSender;
53         emit OwnershipTransferred(address(0), msgSender);
54     }
55 
56     /**
57      * @dev Returns the address of the current owner.
58      */
59     function owner() public view returns (address) {
60         return _owner;
61     }
62 
63     /**
64      * @dev Throws if called by any account other than the owner.
65      */
66     modifier onlyOwner() {
67         require(_owner == _msgSender(), "Ownable: caller is not the owner");
68         _;
69     }
70 
71     /**
72      * @dev Leaves the contract without owner. It will not be possible to call
73      * `onlyOwner` functions anymore. Can only be called by the current owner.
74      *
75      * NOTE: Renouncing ownership will leave the contract without an owner,
76      * thereby removing any functionality that is only available to the owner.
77      */
78     function renounceOwnership() public virtual onlyOwner {
79         emit OwnershipTransferred(_owner, address(0));
80         _owner = address(0);
81     }
82 
83     /**
84      * @dev Transfers ownership of the contract to a new account (`newOwner`).
85      * Can only be called by the current owner.
86      */
87     function transferOwnership(address newOwner) public virtual onlyOwner {
88         require(newOwner != address(0), "Ownable: new owner is the zero address");
89         emit OwnershipTransferred(_owner, newOwner);
90         _owner = newOwner;
91     }
92 }
93 
94 // 
95 /**
96  * @dev Wrappers over Solidity's arithmetic operations with added overflow
97  * checks.
98  *
99  * Arithmetic operations in Solidity wrap on overflow. This can easily result
100  * in bugs, because programmers usually assume that an overflow raises an
101  * error, which is the standard behavior in high level programming languages.
102  * `SafeMath` restores this intuition by reverting the transaction when an
103  * operation overflows.
104  *
105  * Using this library instead of the unchecked operations eliminates an entire
106  * class of bugs, so it's recommended to use it always.
107  */
108 library SafeMath {
109     /**
110      * @dev Returns the addition of two unsigned integers, reverting on
111      * overflow.
112      *
113      * Counterpart to Solidity's `+` operator.
114      *
115      * Requirements:
116      *
117      * - Addition cannot overflow.
118      */
119     function add(uint256 a, uint256 b) internal pure returns (uint256) {
120         uint256 c = a + b;
121         require(c >= a, "SafeMath: addition overflow");
122 
123         return c;
124     }
125 
126     /**
127      * @dev Returns the subtraction of two unsigned integers, reverting on
128      * overflow (when the result is negative).
129      *
130      * Counterpart to Solidity's `-` operator.
131      *
132      * Requirements:
133      *
134      * - Subtraction cannot overflow.
135      */
136     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
137         return sub(a, b, "SafeMath: subtraction overflow");
138     }
139 
140     /**
141      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
142      * overflow (when the result is negative).
143      *
144      * Counterpart to Solidity's `-` operator.
145      *
146      * Requirements:
147      *
148      * - Subtraction cannot overflow.
149      */
150     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
151         require(b <= a, errorMessage);
152         uint256 c = a - b;
153 
154         return c;
155     }
156 
157     /**
158      * @dev Returns the multiplication of two unsigned integers, reverting on
159      * overflow.
160      *
161      * Counterpart to Solidity's `*` operator.
162      *
163      * Requirements:
164      *
165      * - Multiplication cannot overflow.
166      */
167     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
168         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
169         // benefit is lost if 'b' is also tested.
170         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
171         if (a == 0) {
172             return 0;
173         }
174 
175         uint256 c = a * b;
176         require(c / a == b, "SafeMath: multiplication overflow");
177 
178         return c;
179     }
180 
181     /**
182      * @dev Returns the integer division of two unsigned integers. Reverts on
183      * division by zero. The result is rounded towards zero.
184      *
185      * Counterpart to Solidity's `/` operator. Note: this function uses a
186      * `revert` opcode (which leaves remaining gas untouched) while Solidity
187      * uses an invalid opcode to revert (consuming all remaining gas).
188      *
189      * Requirements:
190      *
191      * - The divisor cannot be zero.
192      */
193     function div(uint256 a, uint256 b) internal pure returns (uint256) {
194         return div(a, b, "SafeMath: division by zero");
195     }
196 
197     /**
198      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
199      * division by zero. The result is rounded towards zero.
200      *
201      * Counterpart to Solidity's `/` operator. Note: this function uses a
202      * `revert` opcode (which leaves remaining gas untouched) while Solidity
203      * uses an invalid opcode to revert (consuming all remaining gas).
204      *
205      * Requirements:
206      *
207      * - The divisor cannot be zero.
208      */
209     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
210         require(b > 0, errorMessage);
211         uint256 c = a / b;
212         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
213 
214         return c;
215     }
216 
217     /**
218      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
219      * Reverts when dividing by zero.
220      *
221      * Counterpart to Solidity's `%` operator. This function uses a `revert`
222      * opcode (which leaves remaining gas untouched) while Solidity uses an
223      * invalid opcode to revert (consuming all remaining gas).
224      *
225      * Requirements:
226      *
227      * - The divisor cannot be zero.
228      */
229     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
230         return mod(a, b, "SafeMath: modulo by zero");
231     }
232 
233     /**
234      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
235      * Reverts with custom message when dividing by zero.
236      *
237      * Counterpart to Solidity's `%` operator. This function uses a `revert`
238      * opcode (which leaves remaining gas untouched) while Solidity uses an
239      * invalid opcode to revert (consuming all remaining gas).
240      *
241      * Requirements:
242      *
243      * - The divisor cannot be zero.
244      */
245     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
246         require(b != 0, errorMessage);
247         return a % b;
248     }
249 }
250 
251 // 
252 /**
253  * @dev Interface of the ERC20 standard as defined in the EIP.
254  */
255 interface IERC20 {
256     /**
257      * @dev Returns the amount of tokens in existence.
258      */
259     function totalSupply() external view returns (uint256);
260 
261     /**
262      * @dev Returns the amount of tokens owned by `account`.
263      */
264     function balanceOf(address account) external view returns (uint256);
265 
266     /**
267      * @dev Moves `amount` tokens from the caller's account to `recipient`.
268      *
269      * Returns a boolean value indicating whether the operation succeeded.
270      *
271      * Emits a {Transfer} event.
272      */
273     function transfer(address recipient, uint256 amount) external returns (bool);
274 
275     /**
276      * @dev Returns the remaining number of tokens that `spender` will be
277      * allowed to spend on behalf of `owner` through {transferFrom}. This is
278      * zero by default.
279      *
280      * This value changes when {approve} or {transferFrom} are called.
281      */
282     function allowance(address owner, address spender) external view returns (uint256);
283 
284     /**
285      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
286      *
287      * Returns a boolean value indicating whether the operation succeeded.
288      *
289      * IMPORTANT: Beware that changing an allowance with this method brings the risk
290      * that someone may use both the old and the new allowance by unfortunate
291      * transaction ordering. One possible solution to mitigate this race
292      * condition is to first reduce the spender's allowance to 0 and set the
293      * desired value afterwards:
294      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
295      *
296      * Emits an {Approval} event.
297      */
298     function approve(address spender, uint256 amount) external returns (bool);
299 
300     /**
301      * @dev Moves `amount` tokens from `sender` to `recipient` using the
302      * allowance mechanism. `amount` is then deducted from the caller's
303      * allowance.
304      *
305      * Returns a boolean value indicating whether the operation succeeded.
306      *
307      * Emits a {Transfer} event.
308      */
309     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
310 
311     /**
312      * @dev Emitted when `value` tokens are moved from one account (`from`) to
313      * another (`to`).
314      *
315      * Note that `value` may be zero.
316      */
317     event Transfer(address indexed from, address indexed to, uint256 value);
318 
319     /**
320      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
321      * a call to {approve}. `value` is the new allowance.
322      */
323     event Approval(address indexed owner, address indexed spender, uint256 value);
324 }
325 
326 // 
327 // The MIT License (MIT)
328 // Copyright (c) 2016-2020 zOS Global Limited
329 // Permission is hereby granted, free of charge, to any person obtaining
330 // a copy of this software and associated documentation files (the
331 // "Software"), to deal in the Software without restriction, including
332 // without limitation the rights to use, copy, modify, merge, publish,
333 // distribute, sublicense, and/or sell copies of the Software, and to
334 // permit persons to whom the Software is furnished to do so, subject to
335 // the following conditions:
336 // The above copyright notice and this permission notice shall be included
337 // in all copies or substantial portions of the Software.
338 // THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
339 // OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
340 // MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
341 // IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
342 // CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
343 // TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
344 // SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
345 contract CentaurStakingV1 is Ownable {
346 
347 	using SafeMath for uint;
348 
349 	// Events
350 	event Deposit(uint256 _timestmap, address indexed _address, uint256 _amount);
351 	event Withdraw(uint256 _timestamp, address indexed _address, uint256 _amount);
352 
353 	// CNTR Token Contract & Funding Address
354 	IERC20 public tokenContract = IERC20(0x03042482d64577A7bdb282260e2eA4c8a89C064B);
355 	address public fundingAddress = 0x6359EAdBB84C8f7683E26F392A1573Ab6a37B4b4;
356 
357 	// Current rewardPercentage
358 	uint256 public currentRewardPercentage;
359 	
360 	// Initial & Final Reward Constants (100% => 10000)
361 	uint256 constant initialRewardPercentage = 1000; // 10%
362 	uint256 constant finalRewardPercetage = 500; // 5%
363 
364 	// Rewards % decrement when TVL hits certain volume (100% => 10000)
365 	uint256 constant rewardDecrementCycle = 10000000 * 1 ether; // Decrement when TVL hits certain volume
366 	uint256 constant percentageDecrementPerCycle = 50; // 0.5%
367 
368 	// Stake Lock Constants
369 	uint256 public constant stakeLockDuration = 30 days;
370 
371 	// Stake tracking
372 	uint256 public stakeStartTimestamp;
373 	uint256 public stakeEndTimestamp;
374 
375 	mapping(address => StakeInfo[]) stakeHolders;
376 
377 	struct StakeInfo {
378 		uint256 startTimestamp;
379 		uint256 amountStaked;
380 		uint256 rewardPercentage;
381 		bool withdrawn;
382 	}
383 
384 	// Total Value Locked (TVL) Tracking
385 	uint256 public totalValueLocked;
386 
387 	/**
388      * @dev Constructor
389      */
390 
391 	constructor() public {
392 		currentRewardPercentage = initialRewardPercentage;
393 		stakeStartTimestamp = block.timestamp + 7 days; // Stake event will start 7 days from deployment
394 		stakeEndTimestamp = stakeStartTimestamp + 30 days; // Stake event is going to run for 30 days
395 	}
396 
397 	/**
398      * @dev Contract Modifiers
399      */
400 
401 	function updateFundingAddress(address _address) public onlyOwner {
402 		require(block.timestamp < stakeStartTimestamp);
403 
404 		fundingAddress = _address;
405 	}
406 
407 	function changeStartTimestamp(uint256 _timestamp) public onlyOwner {
408 		require(block.timestamp < stakeStartTimestamp);
409 
410 		stakeStartTimestamp = _timestamp;
411 	}
412 
413 	function changeEndTimestamp(uint256 _timestamp) public onlyOwner {
414 		require(block.timestamp < stakeEndTimestamp);
415 		require(_timestamp > stakeStartTimestamp);
416 
417 		stakeEndTimestamp = _timestamp;
418 	}
419 
420 	/**
421      * @dev Stake functions
422      */
423 
424     function deposit(uint256 _amount) public {
425     	require(block.timestamp > stakeStartTimestamp && block.timestamp < stakeEndTimestamp, "Contract is not accepting deposits at the moment");
426     	require(_amount > 0, "Amount has to be more than 0");
427     	require(stakeHolders[msg.sender].length < 1000, "Prevent Denial of Service");
428 
429     	// Transfers amount to contract
430     	require(tokenContract.transferFrom(msg.sender, address(this), _amount));
431 		emit Deposit(block.timestamp, msg.sender, _amount);
432 
433     	uint256 stakeAmount = _amount;
434 		uint256 stakeRewards = 0;
435 
436     	// Check if deposit exceeds rewardDecrementCycle
437 		while(stakeAmount >= amountToNextDecrement()) {
438 
439 			// Variable cache
440 			uint256 amountToNextDecrement = amountToNextDecrement();
441 
442 			// Add new stake
443 	    	StakeInfo memory newStake;
444 	    	newStake.startTimestamp = block.timestamp;
445 	    	newStake.amountStaked = amountToNextDecrement;
446 	    	newStake.rewardPercentage = currentRewardPercentage;
447 
448 	    	stakeHolders[msg.sender].push(newStake);
449 
450 	    	stakeAmount = stakeAmount.sub(amountToNextDecrement);
451 	    	stakeRewards = stakeRewards.add(amountToNextDecrement.mul(currentRewardPercentage).div(10000));
452 
453 			totalValueLocked = totalValueLocked.add(amountToNextDecrement);
454 
455 	    	// Reduce reward percentage if not at final
456     		if (currentRewardPercentage > finalRewardPercetage) {
457     			currentRewardPercentage = currentRewardPercentage.sub(percentageDecrementPerCycle);
458     		}
459 		}
460 
461 		// Deposit leftover stake
462 		if (stakeAmount > 0) {
463 			// Add new stake
464 	    	StakeInfo memory newStake;
465 	    	newStake.startTimestamp = block.timestamp;
466 	    	newStake.amountStaked = stakeAmount;
467 	    	newStake.rewardPercentage = currentRewardPercentage;
468 
469 	    	stakeHolders[msg.sender].push(newStake);
470 
471 	    	stakeRewards = stakeRewards.add(stakeAmount.mul(currentRewardPercentage).div(10000));
472 
473 	    	totalValueLocked = totalValueLocked.add(stakeAmount);
474 		}
475 
476 		// Transfer stake rewards from funding address to contract
477     	require(tokenContract.transferFrom(fundingAddress, address(this), stakeRewards));
478 
479     	// Transfer total from contract to msg.sender
480     	require(tokenContract.transfer(msg.sender, stakeRewards));
481 
482     }
483 
484     function withdraw() public {
485     	_withdraw(msg.sender);
486     }
487 
488     function withdrawAddress(address _address) public onlyOwner {
489     	_withdraw(_address);
490     }
491 
492     function _withdraw(address _address) internal {
493     	uint256 withdrawAmount = 0;
494 
495     	for(uint256 i = 0; i < stakeHolders[_address].length; i++) {
496     		StakeInfo storage stake = stakeHolders[_address][i];
497     		if (!stake.withdrawn && block.timestamp >= stake.startTimestamp + stakeLockDuration) {
498 	    		withdrawAmount = withdrawAmount.add(stake.amountStaked);
499 	    		stake.withdrawn = true;
500     		}
501     	}
502 
503     	require(withdrawAmount > 0, "No funds available for withdrawal");
504 
505     	totalValueLocked = totalValueLocked.sub(withdrawAmount);
506 
507     	require(tokenContract.transfer(_address, withdrawAmount));
508     	emit Withdraw(block.timestamp, _address, withdrawAmount);
509     }
510 
511     function amountToNextDecrement() public view returns (uint256) {
512     	return rewardDecrementCycle.sub(totalValueLocked.mod(rewardDecrementCycle));
513     }
514 
515     function amountAvailableForWithdrawal(address _address) public view returns (uint256) {
516     	uint256 withdrawAmount = 0;
517 
518     	for(uint256 i = 0; i < stakeHolders[_address].length; i++) {
519     		StakeInfo storage stake = stakeHolders[_address][i];
520     		if (!stake.withdrawn && block.timestamp >= stake.startTimestamp + stakeLockDuration) {
521 	    		withdrawAmount = withdrawAmount.add(stake.amountStaked);
522     		}
523     	}
524 
525     	return withdrawAmount;
526     }
527 
528     function getStakes(address _address) public view returns(StakeInfo[] memory) {
529     	StakeInfo[] memory stakes = new StakeInfo[](stakeHolders[_address].length);
530 
531     	for (uint256 i = 0; i < stakeHolders[_address].length; i++) {
532     		StakeInfo storage stake = stakeHolders[_address][i];
533     		stakes[i] = stake;
534     	}
535 
536     	return stakes;
537     }
538 }