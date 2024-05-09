1 // File: contracts/Interface/IERC20.sol
2 
3 pragma solidity ^0.5.11;
4 
5 interface IERC20 {
6     event Transfer(address indexed _from, address indexed _to, uint256 _value);
7     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
8 
9     function transfer(address _to, uint256 _value) external returns (bool);
10     function transferFrom(address _from, address _to, uint256 _value) external returns (bool);
11     function approve(address _spender, uint256 _value) external returns (bool);
12     function balanceOf(address _target) external view returns (uint256);
13     function allowance(address _target, address _spender) external view returns (uint256);
14 }
15 
16 // File: contracts/Interface/IMint.sol
17 
18 pragma solidity ^0.5.11;
19 
20 interface IMint {
21     function mint(uint256 _value) external returns (bool);
22     function finishMint() external returns (bool);
23 }
24 
25 // File: contracts/Interface/IBurn.sol
26 
27 pragma solidity ^0.5.11;
28 
29 interface IBurn {
30     function burn(uint256 _value) external returns(bool);
31 }
32 
33 // File: contracts/Library/Ownable.sol
34 
35 pragma solidity ^0.5.11;
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
46 contract Ownable {
47     address private _owner;
48 
49     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
50 
51     /**
52      * @dev Initializes the contract setting the deployer as the initial owner.
53      */
54     constructor() internal {
55         _owner = msg.sender;
56         emit OwnershipTransferred(address(0), _owner);
57     }
58 
59     /**
60      * @dev Returns the address of the current owner.
61      */
62     function owner() external view returns (address) {
63         return _owner;
64     }
65 
66     /**
67      * @dev Throws if called by any account other than the owner.
68      */
69     modifier onlyOwner() {
70         require(isOwner(), "Ownable: caller is not the owner");
71         _;
72     }
73 
74     /**
75      * @dev Returns true if the caller is the current owner.
76      */
77     function isOwner() public view returns (bool) {
78         return msg.sender == _owner;
79     }
80 
81     /**
82      * @dev Leaves the contract without owner. It will not be possible to call
83      * `onlyOwner` functions anymore. Can only be called by the current owner.
84      *
85      * NOTE: Renouncing ownership will leave the contract without an owner,
86      * thereby removing any functionality that is only available to the owner.
87      */
88     function renounceOwnership() external onlyOwner {
89         emit OwnershipTransferred(_owner, address(0));
90         _owner = address(0);
91     }
92 
93     /**
94      * @dev Transfers ownership of the contract to a new account (`newOwner`).
95      * Can only be called by the current owner.
96      */
97     function transferOwnership(address newOwner) external onlyOwner {
98         _transferOwnership(newOwner);
99     }
100 
101     /**
102      * @dev Transfers ownership of the contract to a new account (`newOwner`).
103      */
104     function _transferOwnership(address newOwner) internal {
105         require(newOwner != address(0), "Ownable: new owner is the zero address");
106         emit OwnershipTransferred(_owner, newOwner);
107         _owner = newOwner;
108     }
109 }
110 
111 // File: contracts/Library/SafeMath.sol
112 
113 pragma solidity ^0.5.11;
114 
115 /**
116  * @dev Wrappers over Solidity's arithmetic operations with added overflow
117  * checks.
118  *
119  * Arithmetic operations in Solidity wrap on overflow. This can easily result
120  * in bugs, because programmers usually assume that an overflow raises an
121  * error, which is the standard behavior in high level programming languages.
122  * `SafeMath` restores this intuition by reverting the transaction when an
123  * operation overflows.
124  *
125  * Using this library instead of the unchecked operations eliminates an entire
126  * class of bugs, so it's recommended to use it always.
127  */
128 library SafeMath {
129     /**
130      * @dev Returns the addition of two unsigned integers, reverting on
131      * overflow.
132      *
133      * Counterpart to Solidity's `+` operator.
134      *
135      * Requirements:
136      * - Addition cannot overflow.
137      */
138     function add(uint256 a, uint256 b) internal pure returns (uint256) {
139         uint256 c = a + b;
140         require(c >= a, "SafeMath: addition overflow");
141 
142         return c;
143     }
144 
145     /**
146      * @dev Returns the subtraction of two unsigned integers, reverting on
147      * overflow (when the result is negative).
148      *
149      * Counterpart to Solidity's `-` operator.
150      *
151      * Requirements:
152      * - Subtraction cannot overflow.
153      */
154     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
155         return sub(a, b, "SafeMath: subtraction overflow");
156     }
157 
158     /**
159      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
160      * overflow (when the result is negative).
161      *
162      * Counterpart to Solidity's `-` operator.
163      *
164      * Requirements:
165      * - Subtraction cannot overflow.
166      *
167      * _Available since v2.4.0._
168      */
169     function sub(uint256 a, uint256 b, string memory errorMessage)
170         internal
171         pure
172         returns (uint256)
173     {
174         require(b <= a, errorMessage);
175         uint256 c = a - b;
176 
177         return c;
178     }
179 
180     /**
181      * @dev Returns the multiplication of two unsigned integers, reverting on
182      * overflow.
183      *
184      * Counterpart to Solidity's `*` operator.
185      *
186      * Requirements:
187      * - Multiplication cannot overflow.
188      */
189     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
190         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
191         // benefit is lost if 'b' is also tested.
192         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
193         if (a == 0) {
194             return 0;
195         }
196 
197         uint256 c = a * b;
198         require(c / a == b, "SafeMath: multiplication overflow");
199 
200         return c;
201     }
202 
203     /**
204      * @dev Returns the integer division of two unsigned integers. Reverts on
205      * division by zero. The result is rounded towards zero.
206      *
207      * Counterpart to Solidity's `/` operator. Note: this function uses a
208      * `revert` opcode (which leaves remaining gas untouched) while Solidity
209      * uses an invalid opcode to revert (consuming all remaining gas).
210      *
211      * Requirements:
212      * - The divisor cannot be zero.
213      */
214     function div(uint256 a, uint256 b) internal pure returns (uint256) {
215         return div(a, b, "SafeMath: division by zero");
216     }
217 
218     /**
219      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
220      * division by zero. The result is rounded towards zero.
221      *
222      * Counterpart to Solidity's `/` operator. Note: this function uses a
223      * `revert` opcode (which leaves remaining gas untouched) while Solidity
224      * uses an invalid opcode to revert (consuming all remaining gas).
225      *
226      * Requirements:
227      * - The divisor cannot be zero.
228      *
229      * _Available since v2.4.0._
230      */
231     function div(uint256 a, uint256 b, string memory errorMessage)
232         internal
233         pure
234         returns (uint256)
235     {
236         // Solidity only automatically asserts when dividing by 0
237         require(b > 0, errorMessage);
238         uint256 c = a / b;
239         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
240 
241         return c;
242     }
243 
244     /**
245      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
246      * Reverts when dividing by zero.
247      *
248      * Counterpart to Solidity's `%` operator. This function uses a `revert`
249      * opcode (which leaves remaining gas untouched) while Solidity uses an
250      * invalid opcode to revert (consuming all remaining gas).
251      *
252      * Requirements:
253      * - The divisor cannot be zero.
254      */
255     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
256         return mod(a, b, "SafeMath: modulo by zero");
257     }
258 
259     /**
260      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
261      * Reverts with custom message when dividing by zero.
262      *
263      * Counterpart to Solidity's `%` operator. This function uses a `revert`
264      * opcode (which leaves remaining gas untouched) while Solidity uses an
265      * invalid opcode to revert (consuming all remaining gas).
266      *
267      * Requirements:
268      * - The divisor cannot be zero.
269      *
270      * _Available since v2.4.0._
271      */
272     function mod(uint256 a, uint256 b, string memory errorMessage)
273         internal
274         pure
275         returns (uint256)
276     {
277         require(b != 0, errorMessage);
278         return a % b;
279     }
280 }
281 
282 // File: contracts/Library/Freezer.sol
283 
284 pragma solidity ^0.5.11;
285 
286 
287 /**
288  * @title Freezer
289  * @author Yoonsung
290  * @notice This Contracts is an extension of the ERC20. Transfer
291  * of a specific address can be blocked from by the Owner of the
292  * Token Contract.
293  */
294 contract Freezer is Ownable {
295     event Freezed(address dsc);
296     event Unfreezed(address dsc);
297 
298     mapping(address => bool) public freezing;
299 
300     modifier isFreezed(address src) {
301         require(freezing[src] == false, "Freeze/Fronzen-Account");
302         _;
303     }
304 
305     /**
306     * @notice The Freeze function sets the transfer limit
307     * for a specific address.
308     * @param dsc address The specify address want to limit the transfer.
309     */
310     function freeze(address dsc) external onlyOwner {
311         require(dsc != address(0), "Freeze/Zero-Address");
312         require(freezing[dsc] == false, "Freeze/Already-Freezed");
313 
314         freezing[dsc] = true;
315 
316         emit Freezed(dsc);
317     }
318 
319     /**
320     * @notice The Freeze function removes the transfer limit
321     * for a specific address.
322     * @param dsc address The specify address want to remove the transfer.
323     */
324     function unFreeze(address dsc) external onlyOwner {
325         require(freezing[dsc] == true, "Freeze/Already-Unfreezed");
326 
327         delete freezing[dsc];
328 
329         emit Unfreezed(dsc);
330     }
331 }
332 
333 // File: contracts/Library/Pauser.sol
334 
335 pragma solidity ^0.5.11;
336 
337 
338 /**
339  * @title Pauser
340  * @author Yoonsung
341  * @notice This Contracts is an extension of the ERC20. Transfer
342  * of a specific address can be blocked from by the Owner of the
343  * Token Contract.
344  */
345 contract Pauser is Ownable {
346     event Pause(address pauser);
347     event Resume(address resumer);
348 
349     bool public pausing;
350 
351     modifier isPause() {
352         require(pausing == false, "Pause/Pause-Functionality");
353         _;
354     }
355 
356     function pause() external onlyOwner {
357         require(pausing == false, "Pause/Already-Pausing");
358 
359         pausing = true;
360 
361         emit Pause(msg.sender);
362     }
363 
364     function resume() external onlyOwner {
365         require(pausing == true, "Pause/Already-Resuming");
366 
367         pausing = false;
368 
369         emit Resume(msg.sender);
370     }
371 }
372 
373 // File: contracts/Library/Locker.sol
374 
375 pragma solidity ^0.5.11;
376 
377 
378 
379 
380 contract Locker is Ownable {
381     event LockedUp(address target, uint256 value);
382 
383     using SafeMath for uint256;
384 
385     mapping(address => uint256) public lockup;
386 
387     modifier isLockup(address _target, uint256 _value) {
388         uint256 balance = IERC20(address(this)).balanceOf(_target);
389         require(
390             balance.sub(_value, "Locker/Underflow-Value") >= lockup[_target],
391             "Locker/Impossible-Over-Lockup"
392         );
393         _;
394     }
395 
396     function setInitialLockup(address target, uint256 value) internal onlyOwner returns (bool) {
397         require(lockup[target] == 0, "Locker/Already-Lockup");
398 
399         lockup[target] = value;
400 
401         emit LockedUp(target, value);
402     }
403 
404     function decreaseLockup(address target, uint256 value) external onlyOwner returns (bool) {
405         require(lockup[target] > 0, "Locker/Not-Lockedup");
406 
407         lockup[target] = lockup[target].sub(value, "Locker/Impossible-Underflow");
408 
409         emit LockedUp(target, lockup[target]);
410     }
411 
412     function deleteLockup(address target) external onlyOwner returns (bool) {
413         require(lockup[target] > 0, "Locker/Not-Lockedup");
414 
415         delete lockup[target];
416 
417         emit LockedUp(target, 0);
418     }
419 }
420 
421 // File: contracts/Library/Minter.sol
422 
423 pragma solidity ^0.5.11;
424 
425 
426 
427 contract Minter is Ownable {
428     event Finished();
429 
430     bool public minting;
431 
432     modifier isMinting() {
433         require(minting == true, "Minter/Finish-Minting");
434         _;
435     }
436 
437     constructor() public {
438         minting = true;
439     }
440 
441     function finishMint() external onlyOwner returns (bool) {
442         require(minting == true, "Minter/Already-Finish");
443 
444         minting = false;
445 
446         emit Finished();
447 
448         return true;
449     }
450 }
451 
452 // File: contracts/Xank.sol
453 
454 pragma solidity ^0.5.11;
455 
456 
457 
458 
459 
460 
461 
462 
463 
464 
465 /**
466  * @title Xank
467  * @author Yoonsung
468  * @notice The contract implements the ERC20 specification of Xank. It implements "Mint" 
469  * and "Burn" functions incidentally. "Mint" can only be called by the Owner of the 
470  * corresponding Contract, and "Burn" can be called by any Token owner. Owner of the
471  * contract can use "Pauser" to stop working, "Freezer" to freeze accounts and "Locker" 
472  * to maintain Token minimum balance for some owners.
473  */
474 contract Xank is IERC20, IMint, IBurn, Ownable, Freezer, Pauser, Locker, Minter {
475     using SafeMath for uint256;
476 
477     string public constant name = "Xank";
478     string public constant symbol = "XANK";
479     uint8 public constant decimals = 16;
480     uint256 public totalSupply = 1000000000;
481 
482     mapping(address => uint256) private balances;
483     mapping(address => mapping(address => uint256)) private approved;
484 
485     constructor() public Minter() {
486         totalSupply = totalSupply.mul(10**uint256(decimals));
487         balances[msg.sender] = totalSupply;
488     }
489 
490     function transfer(address to, uint256 value)
491         external
492         isFreezed(msg.sender)
493         isLockup(msg.sender, value)
494         isPause
495         returns (bool)
496     {
497         require(to != address(0), "Xank/Not-Allow-Zero-Address");
498 
499         balances[msg.sender] = balances[msg.sender].sub(value);
500         balances[to] = balances[to].add(value);
501 
502         emit Transfer(msg.sender, to, value);
503 
504         return true;
505     }
506 
507     function transferWithLockup(address to, uint256 value)
508         external
509         onlyOwner
510         isLockup(msg.sender, value)
511         isPause
512         returns (bool)
513     {
514         require(to != address(0), "Xank/Not-Allow-Zero-Address");
515 
516         balances[msg.sender] = balances[msg.sender].sub(value);
517         balances[to] = balances[to].add(value);
518 
519         setInitialLockup(to, value);
520 
521         emit Transfer(msg.sender, to, value);
522 
523         return true;
524     }
525 
526     function transferFrom(address from, address to, uint256 value)
527         external
528         isFreezed(from)
529         isLockup(from, value)
530         isPause
531         returns (bool)
532     {
533         require(from != address(0), "Xank/Not-Allow-Zero-Address");
534         require(to != address(0), "Xank/Not-Allow-Zero-Address");
535 
536         balances[from] = balances[from].sub(value);
537         balances[to] = balances[to].add(value);
538         approved[from][msg.sender] = approved[from][msg.sender].sub(value);
539 
540         emit Transfer(from, to, value);
541 
542         return true;
543     }
544 
545     function mint(uint256 value) external isMinting onlyOwner isPause returns (bool) {
546         totalSupply = totalSupply.add(value);
547         balances[msg.sender] = balances[msg.sender].add(value);
548 
549         emit Transfer(address(0), msg.sender, value);
550 
551         return true;
552     }
553 
554     function burn(uint256 value) external isPause returns (bool) {
555         require(value <= balances[msg.sender], "Xank/Not-Allow-Unvalued-Burn");
556 
557         balances[msg.sender] = balances[msg.sender].sub(value);
558         totalSupply = totalSupply.sub(value);
559 
560         emit Transfer(msg.sender, address(0), value);
561 
562         return true;
563     }
564 
565     function approve(address spender, uint256 value) external isPause returns (bool) {
566         require(spender != address(0), "Xank/Not-Allow-Zero-Address");
567         approved[msg.sender][spender] = value;
568         emit Approval(msg.sender, spender, value);
569 
570         return true;
571     }
572 
573     function balanceOf(address target) external view returns (uint256) {
574         return balances[target];
575     }
576 
577     function allowance(address target, address spender) external view returns (uint256) {
578         return approved[target][spender];
579     }
580 }