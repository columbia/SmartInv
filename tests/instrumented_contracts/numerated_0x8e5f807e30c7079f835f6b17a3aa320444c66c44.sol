1 // SPDX-License-Identifier: MIT
2 pragma solidity >=0.8.0 <0.9.0;
3 
4 /*
5  * @dev Provides information about the current execution context, including the
6  * sender of the transaction and its data. While these are generally available
7  * via msg.sender and msg.data, they should not be accessed in such a direct
8  * manner, since when dealing with meta-transactions the account sending and
9  * paying for execution may not be the actual sender (as far as an application
10  * is concerned).
11  *
12  * This contract is only required for intermediate, library-like contracts.
13  */
14 abstract contract Context {
15     function _msgSender() internal view virtual returns (address) {
16         return msg.sender;
17     }
18 
19     function _msgData() internal view virtual returns (bytes calldata) {
20         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
21         return msg.data;
22     }
23 }
24 
25 /**
26  * @dev Contract module which provides a basic access control mechanism, where
27  * there is an account (an owner) that can be granted exclusive access to
28  * specific functions.
29  *
30  * By default, the owner account will be the one that deploys the contract. This
31  * can later be changed with {transferOwnership}.
32  *
33  * This module is used through inheritance. It will make available the modifier
34  * `onlyOwner`, which can be applied to your functions to restrict their use to
35  * the owner.
36  */
37 abstract contract Ownable is Context {
38     address private _owner;
39 
40     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
41 
42     /**
43      * @dev Initializes the contract setting the deployer as the initial owner.
44      */
45     constructor () {
46         address msgSender = _msgSender();
47         _owner = msgSender;
48         emit OwnershipTransferred(address(0), msgSender);
49     }
50 
51     /**
52      * @dev Returns the address of the current owner.
53      */
54     function owner() public view virtual returns (address) {
55         return _owner;
56     }
57 
58     /**
59      * @dev Throws if called by any account other than the owner.
60      */
61     modifier onlyOwner() {
62         require(owner() == _msgSender(), "Ownable: caller is not the owner");
63         _;
64     }
65 
66     /**
67      * @dev Leaves the contract without owner. It will not be possible to call
68      * `onlyOwner` functions anymore. Can only be called by the current owner.
69      *
70      * NOTE: Renouncing ownership will leave the contract without an owner,
71      * thereby removing any functionality that is only available to the owner.
72      */
73     function renounceOwnership() public virtual onlyOwner {
74         emit OwnershipTransferred(_owner, address(0));
75         _owner = address(0);
76     }
77 
78     /**
79      * @dev Transfers ownership of the contract to a new account (`newOwner`).
80      * Can only be called by the current owner.
81      */
82     function transferOwnership(address newOwner) public virtual onlyOwner {
83         require(newOwner != address(0), "Ownable: new owner is the zero address");
84         emit OwnershipTransferred(_owner, newOwner);
85         _owner = newOwner;
86     }
87 }
88 
89 // CAUTION
90 // This version of SafeMath should only be used with Solidity 0.8 or later,
91 // because it relies on the compiler's built in overflow checks.
92 
93 /**
94  * @dev Wrappers over Solidity's arithmetic operations.
95  *
96  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
97  * now has built in overflow checking.
98  */
99 library SafeMath {
100     /**
101      * @dev Returns the addition of two unsigned integers, with an overflow flag.
102      *
103      * _Available since v3.4._
104      */
105     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
106         unchecked {
107             uint256 c = a + b;
108             if (c < a) return (false, 0);
109             return (true, c);
110         }
111     }
112 
113     /**
114      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
115      *
116      * _Available since v3.4._
117      */
118     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
119         unchecked {
120             if (b > a) return (false, 0);
121             return (true, a - b);
122         }
123     }
124 
125     /**
126      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
127      *
128      * _Available since v3.4._
129      */
130     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
131         unchecked {
132             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
133             // benefit is lost if 'b' is also tested.
134             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
135             if (a == 0) return (true, 0);
136             uint256 c = a * b;
137             if (c / a != b) return (false, 0);
138             return (true, c);
139         }
140     }
141 
142     /**
143      * @dev Returns the division of two unsigned integers, with a division by zero flag.
144      *
145      * _Available since v3.4._
146      */
147     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
148         unchecked {
149             if (b == 0) return (false, 0);
150             return (true, a / b);
151         }
152     }
153 
154     /**
155      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
156      *
157      * _Available since v3.4._
158      */
159     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
160         unchecked {
161             if (b == 0) return (false, 0);
162             return (true, a % b);
163         }
164     }
165 
166     /**
167      * @dev Returns the addition of two unsigned integers, reverting on
168      * overflow.
169      *
170      * Counterpart to Solidity's `+` operator.
171      *
172      * Requirements:
173      *
174      * - Addition cannot overflow.
175      */
176     function add(uint256 a, uint256 b) internal pure returns (uint256) {
177         return a + b;
178     }
179 
180     /**
181      * @dev Returns the subtraction of two unsigned integers, reverting on
182      * overflow (when the result is negative).
183      *
184      * Counterpart to Solidity's `-` operator.
185      *
186      * Requirements:
187      *
188      * - Subtraction cannot overflow.
189      */
190     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
191         return a - b;
192     }
193 
194     /**
195      * @dev Returns the multiplication of two unsigned integers, reverting on
196      * overflow.
197      *
198      * Counterpart to Solidity's `*` operator.
199      *
200      * Requirements:
201      *
202      * - Multiplication cannot overflow.
203      */
204     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
205         return a * b;
206     }
207 
208     /**
209      * @dev Returns the integer division of two unsigned integers, reverting on
210      * division by zero. The result is rounded towards zero.
211      *
212      * Counterpart to Solidity's `/` operator.
213      *
214      * Requirements:
215      *
216      * - The divisor cannot be zero.
217      */
218     function div(uint256 a, uint256 b) internal pure returns (uint256) {
219         return a / b;
220     }
221 
222     /**
223      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
224      * reverting when dividing by zero.
225      *
226      * Counterpart to Solidity's `%` operator. This function uses a `revert`
227      * opcode (which leaves remaining gas untouched) while Solidity uses an
228      * invalid opcode to revert (consuming all remaining gas).
229      *
230      * Requirements:
231      *
232      * - The divisor cannot be zero.
233      */
234     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
235         return a % b;
236     }
237 
238     /**
239      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
240      * overflow (when the result is negative).
241      *
242      * CAUTION: This function is deprecated because it requires allocating memory for the error
243      * message unnecessarily. For custom revert reasons use {trySub}.
244      *
245      * Counterpart to Solidity's `-` operator.
246      *
247      * Requirements:
248      *
249      * - Subtraction cannot overflow.
250      */
251     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
252         unchecked {
253             require(b <= a, errorMessage);
254             return a - b;
255         }
256     }
257 
258     /**
259      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
260      * division by zero. The result is rounded towards zero.
261      *
262      * Counterpart to Solidity's `%` operator. This function uses a `revert`
263      * opcode (which leaves remaining gas untouched) while Solidity uses an
264      * invalid opcode to revert (consuming all remaining gas).
265      *
266      * Counterpart to Solidity's `/` operator. Note: this function uses a
267      * `revert` opcode (which leaves remaining gas untouched) while Solidity
268      * uses an invalid opcode to revert (consuming all remaining gas).
269      *
270      * Requirements:
271      *
272      * - The divisor cannot be zero.
273      */
274     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
275         unchecked {
276             require(b > 0, errorMessage);
277             return a / b;
278         }
279     }
280 
281     /**
282      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
283      * reverting with custom message when dividing by zero.
284      *
285      * CAUTION: This function is deprecated because it requires allocating memory for the error
286      * message unnecessarily. For custom revert reasons use {tryMod}.
287      *
288      * Counterpart to Solidity's `%` operator. This function uses a `revert`
289      * opcode (which leaves remaining gas untouched) while Solidity uses an
290      * invalid opcode to revert (consuming all remaining gas).
291      *
292      * Requirements:
293      *
294      * - The divisor cannot be zero.
295      */
296     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
297         unchecked {
298             require(b > 0, errorMessage);
299             return a % b;
300         }
301     }
302 }
303 
304 interface Etheria{
305 	function getOwner(uint8 col, uint8 row) external view returns(address);
306 	function setOwner(uint8 col, uint8 row, address newowner) external;
307 }
308 
309 interface MapElevationRetriever{
310     function getElevation(uint8 col, uint8 row) external view returns (uint8);
311 }
312 
313 contract EtheriaExchangeV1pt2 is Ownable {
314  	using SafeMath for uint256;
315 
316 	string public name = "EtheriaExchangeV1pt2";
317 
318 	Etheria public constant etheria = Etheria(0xB21f8684f23Dbb1008508B4DE91a0aaEDEbdB7E4);
319 	MapElevationRetriever public constant mapElevationRetriever = MapElevationRetriever(0x68549D7Dbb7A956f955Ec1263F55494f05972A6b);
320 
321 	uint256 public feeRate = 25; // 2.5%, max 5%
322 	uint256 public withdrawalPenaltyRate = 1; // 0.1%, max 5%
323 	uint256 public collectedFees = 0;
324 	uint16 public constant mapSize = 33;
325 
326     struct Bid {
327         address bidder;
328 		uint256 amount;
329     }
330 
331     // A record of the highest Etheria bid
332     mapping (uint16 => Bid) public bids;
333 	mapping (address => uint256) public pendingWithdrawals;
334 
335     event EtheriaBidCreated(uint16 indexed index, address indexed bidder, uint256 indexed amount);
336     event EtheriaGlobalBidCreated(address indexed bidder, uint256 indexed amount);
337     event EtheriaBidWithdrawn(uint16 indexed index, address indexed bidder, uint256 indexed amount);
338     event EtheriaBidAccepted(uint16 indexed index, address indexed seller, address indexed bidder, uint256 amount);
339     event EtheriaGlobalBidAccepted(uint16 indexed index, address indexed seller, address indexed bidder, uint256 amount);
340 
341     constructor() {
342     }
343     
344 	function collectFees() external onlyOwner {
345 		payable(msg.sender).transfer(collectedFees);
346 		collectedFees = 0;
347 	}
348 
349 	function setFeeRate(uint256 newFeeRate) external onlyOwner {
350 	    require(newFeeRate <= 50, "EtheriaEx: Invalid fee");
351 		feeRate = newFeeRate;
352 	}
353 	
354 	function setWithdrawalPenaltyRate(uint256 newWithdrawalPenaltyRate) external onlyOwner {
355 	    require(newWithdrawalPenaltyRate <= 50, "EtheriaEx: Invalid penalty rate");
356 		withdrawalPenaltyRate = newWithdrawalPenaltyRate;
357 	}
358 
359 	function getIndex(uint8 col, uint8 row) public pure returns (uint16) {
360 		require(col < 33 && row < 33, "EtheriaEx: Invalid col and/or row");
361 		return uint16(col) * mapSize + uint16(row);
362 	}
363 
364     function getColRow(uint16 index) public pure returns (uint8 col, uint8 row) {
365         require(index < 1089, "EtheriaEx: Invalid index");
366         col = uint8(index / mapSize);
367         row = uint8(index % mapSize);
368 	}
369 	
370 	function getBidDetails(uint8 col, uint8 row) public view returns (address, uint256) {
371 		Bid storage exitingBid = bids[getIndex(col, row)];
372 		return (exitingBid.bidder, exitingBid.amount);
373 	}
374 	
375 	function bid(uint8 col, uint8 row, uint256 amount) internal returns (uint16 index) {
376 	    require(msg.sender == tx.origin, "EtheriaEx: tx origin must be sender"); // etheria doesn't allow tile ownership by contracts, this check prevents blackholing
377 		require(amount > 0, "EtheriaEx: Invalid bid");
378 		
379 		index = getIndex(col, row);
380 		Bid storage existingbid = bids[index];
381 		require(amount >= existingbid.amount.mul(101).div(100), "EtheriaEx: bid not 1% higher"); // require higher bid to be at least 1% higher
382 		
383 		pendingWithdrawals[existingbid.bidder] += existingbid.amount; // new bid is good. add amount of old (stale) bid to pending withdrawals (incl previous stale bid amounts)
384 		
385 		existingbid.bidder = msg.sender;
386 		existingbid.amount = amount;
387 	}
388 
389 	function makeBid(uint8 col, uint8 row) external payable {
390 		require(mapElevationRetriever.getElevation(col, row) >= 125, "EtheriaEx: Can't bid on water");
391 		uint16 index = bid(col, row, msg.value);
392 		emit EtheriaBidCreated(index, msg.sender, msg.value);
393 	}
394 	
395 	function makeGlobalBid() external payable {
396 		bid(0, 0, msg.value);
397 		emit EtheriaGlobalBidCreated(msg.sender, msg.value);
398 	}
399 
400     // withdrawal of a still-good bid by the owner
401 	function withdrawBid(uint8 col, uint8 row) external {
402 		uint16 index = getIndex(col, row);
403 		Bid storage existingbid = bids[index];
404 		require(msg.sender == existingbid.bidder, "EtheriaEx: not existing bidder");
405 
406         // to discourage bid withdrawal, take a cut
407 		uint256 fees = existingbid.amount.mul(withdrawalPenaltyRate).div(1000);
408 		collectedFees += fees;
409 		
410 		uint256 amount = existingbid.amount.sub(fees);
411 		
412 		existingbid.bidder = address(0);
413 		existingbid.amount = 0;
414 		
415 		payable(msg.sender).transfer(amount);
416 		
417 		emit EtheriaBidWithdrawn(index, msg.sender, existingbid.amount);
418 	}
419 	
420 	function accept(uint8 col, uint8 row, uint256 minPrice, uint16 index) internal returns(address bidder, uint256 amount) {
421 	    require(etheria.getOwner(col, row) == msg.sender, "EtheriaEx: Not tile owner");
422 		
423         Bid storage existingbid = bids[index];
424 		require(existingbid.amount > 0, "EtheriaEx: No bid to accept");
425 		require(existingbid.amount >= minPrice, "EtheriaEx: min price not met");
426 		
427 		bidder = existingbid.bidder;
428 		
429 		etheria.setOwner(col, row, bidder);
430 		require(etheria.getOwner(col, row) == bidder, "EtheriaEx: setting owner failed");
431 
432 		//collect fee
433 		uint256 fees = existingbid.amount.mul(feeRate).div(1000);
434 		collectedFees += fees;
435 
436         amount = existingbid.amount.sub(fees);
437         
438 		existingbid.bidder = address(0);
439 		existingbid.amount = 0;
440 		
441         pendingWithdrawals[msg.sender] += amount;
442 	}
443 
444 	function acceptBid(uint8 col, uint8 row, uint256 minPrice) external {
445 	    uint16 index = getIndex(col, row);
446 		(address bidder, uint256 amount) = accept(col, row, minPrice, index);
447 		emit EtheriaBidAccepted(index, msg.sender, bidder, amount);
448     }
449     
450     function acceptGlobalBid(uint8 col, uint8 row, uint256 minPrice) external {
451         (address bidder, uint256 amount) = accept(col, row, minPrice, 0);
452         emit EtheriaGlobalBidAccepted(getIndex(col, row), msg.sender, bidder, amount);
453     }
454 
455     // withdrawal of funds on any and all stale bids that have been bested
456 	function withdraw(address payable destination) public {
457 		uint256 amount = pendingWithdrawals[msg.sender];
458 		require(amount > 0, "EtheriaEx: no amount to withdraw");
459 		
460         // Remember to zero the pending refund before
461         // sending to prevent re-entrancy attacks
462         pendingWithdrawals[destination] = 0;
463         payable(destination).transfer(amount);
464 	}
465 	
466 	function withdraw() external {
467 		withdraw(payable(msg.sender));
468 	}
469 }