1 // File: @openzeppelin/contracts/utils/Context.sol
2 
3 /*
4  * @dev Provides information about the current execution context, including the
5  * sender of the transaction and its data. While these are generally available
6  * via msg.sender and msg.data, they should not be accessed in such a direct
7  * manner, since when dealing with GSN meta-transactions the account sending and
8  * paying for execution may not be the actual sender (as far as an application
9  * is concerned).
10  *
11  * This contract is only required for intermediate, library-like contracts.
12  */
13 abstract contract Context {
14     function _msgSender() internal view virtual returns (address payable) {
15         return msg.sender;
16     }
17 
18     function _msgData() internal view virtual returns (bytes memory) {
19         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
20         return msg.data;
21     }
22 }
23 
24 // File: @openzeppelin/contracts/access/Ownable.sol
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
46     constructor () internal {
47         address msgSender = _msgSender();
48         _owner = msgSender;
49         emit OwnershipTransferred(address(0), msgSender);
50     }
51 
52     /**
53      * @dev Returns the address of the current owner.
54      */
55     function owner() public view virtual returns (address) {
56         return _owner;
57     }
58 
59     /**
60      * @dev Throws if called by any account other than the owner.
61      */
62     modifier onlyOwner() {
63         require(owner() == _msgSender(), "Ownable: caller is not the owner");
64         _;
65     }
66 
67     /**
68      * @dev Leaves the contract without owner. It will not be possible to call
69      * `onlyOwner` functions anymore. Can only be called by the current owner.
70      *
71      * NOTE: Renouncing ownership will leave the contract without an owner,
72      * thereby removing any functionality that is only available to the owner.
73      */
74     function renounceOwnership() public virtual onlyOwner {
75         emit OwnershipTransferred(_owner, address(0));
76         _owner = address(0);
77     }
78 
79     /**
80      * @dev Transfers ownership of the contract to a new account (`newOwner`).
81      * Can only be called by the current owner.
82      */
83     function transferOwnership(address newOwner) public virtual onlyOwner {
84         require(newOwner != address(0), "Ownable: new owner is the zero address");
85         emit OwnershipTransferred(_owner, newOwner);
86         _owner = newOwner;
87     }
88 }
89 
90 // File: @openzeppelin/contracts/math/SafeMath.sol
91 
92 /**
93  * @dev Wrappers over Solidity's arithmetic operations with added overflow
94  * checks.
95  *
96  * Arithmetic operations in Solidity wrap on overflow. This can easily result
97  * in bugs, because programmers usually assume that an overflow raises an
98  * error, which is the standard behavior in high level programming languages.
99  * `SafeMath` restores this intuition by reverting the transaction when an
100  * operation overflows.
101  *
102  * Using this library instead of the unchecked operations eliminates an entire
103  * class of bugs, so it's recommended to use it always.
104  */
105 library SafeMath {
106     /**
107      * @dev Returns the addition of two unsigned integers, with an overflow flag.
108      *
109      * _Available since v3.4._
110      */
111     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
112         uint256 c = a + b;
113         if (c < a) return (false, 0);
114         return (true, c);
115     }
116 
117     /**
118      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
119      *
120      * _Available since v3.4._
121      */
122     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
123         if (b > a) return (false, 0);
124         return (true, a - b);
125     }
126 
127     /**
128      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
129      *
130      * _Available since v3.4._
131      */
132     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
133         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
134         // benefit is lost if 'b' is also tested.
135         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
136         if (a == 0) return (true, 0);
137         uint256 c = a * b;
138         if (c / a != b) return (false, 0);
139         return (true, c);
140     }
141 
142     /**
143      * @dev Returns the division of two unsigned integers, with a division by zero flag.
144      *
145      * _Available since v3.4._
146      */
147     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
148         if (b == 0) return (false, 0);
149         return (true, a / b);
150     }
151 
152     /**
153      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
154      *
155      * _Available since v3.4._
156      */
157     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
158         if (b == 0) return (false, 0);
159         return (true, a % b);
160     }
161 
162     /**
163      * @dev Returns the addition of two unsigned integers, reverting on
164      * overflow.
165      *
166      * Counterpart to Solidity's `+` operator.
167      *
168      * Requirements:
169      *
170      * - Addition cannot overflow.
171      */
172     function add(uint256 a, uint256 b) internal pure returns (uint256) {
173         uint256 c = a + b;
174         require(c >= a, "SafeMath: addition overflow");
175         return c;
176     }
177 
178     /**
179      * @dev Returns the subtraction of two unsigned integers, reverting on
180      * overflow (when the result is negative).
181      *
182      * Counterpart to Solidity's `-` operator.
183      *
184      * Requirements:
185      *
186      * - Subtraction cannot overflow.
187      */
188     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
189         require(b <= a, "SafeMath: subtraction overflow");
190         return a - b;
191     }
192 
193     /**
194      * @dev Returns the multiplication of two unsigned integers, reverting on
195      * overflow.
196      *
197      * Counterpart to Solidity's `*` operator.
198      *
199      * Requirements:
200      *
201      * - Multiplication cannot overflow.
202      */
203     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
204         if (a == 0) return 0;
205         uint256 c = a * b;
206         require(c / a == b, "SafeMath: multiplication overflow");
207         return c;
208     }
209 
210     /**
211      * @dev Returns the integer division of two unsigned integers, reverting on
212      * division by zero. The result is rounded towards zero.
213      *
214      * Counterpart to Solidity's `/` operator. Note: this function uses a
215      * `revert` opcode (which leaves remaining gas untouched) while Solidity
216      * uses an invalid opcode to revert (consuming all remaining gas).
217      *
218      * Requirements:
219      *
220      * - The divisor cannot be zero.
221      */
222     function div(uint256 a, uint256 b) internal pure returns (uint256) {
223         require(b > 0, "SafeMath: division by zero");
224         return a / b;
225     }
226 
227     /**
228      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
229      * reverting when dividing by zero.
230      *
231      * Counterpart to Solidity's `%` operator. This function uses a `revert`
232      * opcode (which leaves remaining gas untouched) while Solidity uses an
233      * invalid opcode to revert (consuming all remaining gas).
234      *
235      * Requirements:
236      *
237      * - The divisor cannot be zero.
238      */
239     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
240         require(b > 0, "SafeMath: modulo by zero");
241         return a % b;
242     }
243 
244     /**
245      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
246      * overflow (when the result is negative).
247      *
248      * CAUTION: This function is deprecated because it requires allocating memory for the error
249      * message unnecessarily. For custom revert reasons use {trySub}.
250      *
251      * Counterpart to Solidity's `-` operator.
252      *
253      * Requirements:
254      *
255      * - Subtraction cannot overflow.
256      */
257     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
258         require(b <= a, errorMessage);
259         return a - b;
260     }
261 
262     /**
263      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
264      * division by zero. The result is rounded towards zero.
265      *
266      * CAUTION: This function is deprecated because it requires allocating memory for the error
267      * message unnecessarily. For custom revert reasons use {tryDiv}.
268      *
269      * Counterpart to Solidity's `/` operator. Note: this function uses a
270      * `revert` opcode (which leaves remaining gas untouched) while Solidity
271      * uses an invalid opcode to revert (consuming all remaining gas).
272      *
273      * Requirements:
274      *
275      * - The divisor cannot be zero.
276      */
277     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
278         require(b > 0, errorMessage);
279         return a / b;
280     }
281 
282     /**
283      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
284      * reverting with custom message when dividing by zero.
285      *
286      * CAUTION: This function is deprecated because it requires allocating memory for the error
287      * message unnecessarily. For custom revert reasons use {tryMod}.
288      *
289      * Counterpart to Solidity's `%` operator. This function uses a `revert`
290      * opcode (which leaves remaining gas untouched) while Solidity uses an
291      * invalid opcode to revert (consuming all remaining gas).
292      *
293      * Requirements:
294      *
295      * - The divisor cannot be zero.
296      */
297     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
298         require(b > 0, errorMessage);
299         return a % b;
300     }
301 }
302 
303 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
304 
305 /**
306  * @dev Interface of the ERC20 standard as defined in the EIP.
307  */
308 interface IERC20 {
309     /**
310      * @dev Returns the amount of tokens in existence.
311      */
312     function totalSupply() external view returns (uint256);
313 
314     /**
315      * @dev Returns the amount of tokens owned by `account`.
316      */
317     function balanceOf(address account) external view returns (uint256);
318 
319     /**
320      * @dev Moves `amount` tokens from the caller's account to `recipient`.
321      *
322      * Returns a boolean value indicating whether the operation succeeded.
323      *
324      * Emits a {Transfer} event.
325      */
326     function transfer(address recipient, uint256 amount) external returns (bool);
327 
328     /**
329      * @dev Returns the remaining number of tokens that `spender` will be
330      * allowed to spend on behalf of `owner` through {transferFrom}. This is
331      * zero by default.
332      *
333      * This value changes when {approve} or {transferFrom} are called.
334      */
335     function allowance(address owner, address spender) external view returns (uint256);
336 
337     /**
338      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
339      *
340      * Returns a boolean value indicating whether the operation succeeded.
341      *
342      * IMPORTANT: Beware that changing an allowance with this method brings the risk
343      * that someone may use both the old and the new allowance by unfortunate
344      * transaction ordering. One possible solution to mitigate this race
345      * condition is to first reduce the spender's allowance to 0 and set the
346      * desired value afterwards:
347      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
348      *
349      * Emits an {Approval} event.
350      */
351     function approve(address spender, uint256 amount) external returns (bool);
352 
353     /**
354      * @dev Moves `amount` tokens from `sender` to `recipient` using the
355      * allowance mechanism. `amount` is then deducted from the caller's
356      * allowance.
357      *
358      * Returns a boolean value indicating whether the operation succeeded.
359      *
360      * Emits a {Transfer} event.
361      */
362     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
363 
364     /**
365      * @dev Emitted when `value` tokens are moved from one account (`from`) to
366      * another (`to`).
367      *
368      * Note that `value` may be zero.
369      */
370     event Transfer(address indexed from, address indexed to, uint256 value);
371 
372     /**
373      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
374      * a call to {approve}. `value` is the new allowance.
375      */
376     event Approval(address indexed owner, address indexed spender, uint256 value);
377 }
378 
379 // File: @openzeppelin/contracts/utils/Pausable.sol
380 
381 
382 /**
383  * @dev Contract module which allows children to implement an emergency stop
384  * mechanism that can be triggered by an authorized account.
385  *
386  * This module is used through inheritance. It will make available the
387  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
388  * the functions of your contract. Note that they will not be pausable by
389  * simply including this module, only once the modifiers are put in place.
390  */
391 abstract contract Pausable is Context {
392     /**
393      * @dev Emitted when the pause is triggered by `account`.
394      */
395     event Paused(address account);
396 
397     /**
398      * @dev Emitted when the pause is lifted by `account`.
399      */
400     event Unpaused(address account);
401 
402     bool private _paused;
403 
404     /**
405      * @dev Initializes the contract in unpaused state.
406      */
407     constructor () internal {
408         _paused = false;
409     }
410 
411     /**
412      * @dev Returns true if the contract is paused, and false otherwise.
413      */
414     function paused() public view virtual returns (bool) {
415         return _paused;
416     }
417 
418     /**
419      * @dev Modifier to make a function callable only when the contract is not paused.
420      *
421      * Requirements:
422      *
423      * - The contract must not be paused.
424      */
425     modifier whenNotPaused() {
426         require(!paused(), "Pausable: paused");
427         _;
428     }
429 
430     /**
431      * @dev Modifier to make a function callable only when the contract is paused.
432      *
433      * Requirements:
434      *
435      * - The contract must be paused.
436      */
437     modifier whenPaused() {
438         require(paused(), "Pausable: not paused");
439         _;
440     }
441 
442     /**
443      * @dev Triggers stopped state.
444      *
445      * Requirements:
446      *
447      * - The contract must not be paused.
448      */
449     function _pause() internal virtual whenNotPaused {
450         _paused = true;
451         emit Paused(_msgSender());
452     }
453 
454     /**
455      * @dev Returns to normal state.
456      *
457      * Requirements:
458      *
459      * - The contract must be paused.
460      */
461     function _unpause() internal virtual whenPaused {
462         _paused = false;
463         emit Unpaused(_msgSender());
464     }
465 }
466 
467 // File: contracts/Swap.sol
468 
469 // SPDX-License-Identifier: MIT
470 pragma solidity ^0.7.6;
471 
472 
473 
474 
475 
476 contract SentinelSwap is Ownable, Pausable {
477     using SafeMath for uint256;
478 
479     IERC20 public token;
480     uint256 public burnNonce;
481     uint256 public totalBurnt;
482     address burnAddress = 0x000000000000000000000000000000000000dEaD;
483 
484     /*
485      * @dev: Event declarations.
486      */
487     event LogBurn(address _from, bytes _to, uint256 _amount, uint256 burnNonce);
488 
489     /*
490      * @dev: Modifier declarations.
491      */
492     modifier hasBalance(address _sender, uint256 _amount) {
493         require(
494             token.balanceOf(_sender) >= _amount,
495             "Insufficient token balance."
496         );
497         _;
498     }
499 
500     /*
501      * @dev: Constructor which sets the token.
502      */
503     constructor(IERC20 _token) {
504         token = _token;
505     }
506 
507     /*
508      * @dev: Burns the tokens for swap.
509      *
510      * @param _recipient: The non-ERC20 Sentinel address.
511      * @param _amount: The amount of SENT tokens need to be swapped.
512      */
513     function burn(bytes memory _recipient, uint256 _amount)
514         public
515         whenNotPaused
516         hasBalance(msg.sender, _amount)
517     {
518         burnNonce = burnNonce.add(1);
519         totalBurnt = totalBurnt.add(_amount);
520 
521         require(
522             token.transferFrom(msg.sender, burnAddress, _amount),
523             "Contract token allowances insufficient to complete this burn request."
524         );
525         emit LogBurn(msg.sender, _recipient, _amount, burnNonce);
526     }
527 
528     /*
529      * @dev: Pause.
530      */
531     function pause() public onlyOwner {
532         _pause();
533     }
534 
535     /*
536      * @dev: Unpause.
537      */
538     function unpause() public onlyOwner {
539         _unpause();
540     }
541 }