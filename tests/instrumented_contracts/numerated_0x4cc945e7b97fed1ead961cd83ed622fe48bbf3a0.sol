1 /***
2  *    ██████╗ ███████╗ ██████╗  ██████╗ 
3  *    ██╔══██╗██╔════╝██╔════╝ ██╔═══██╗
4  *    ██║  ██║█████╗  ██║  ███╗██║   ██║
5  *    ██║  ██║██╔══╝  ██║   ██║██║   ██║
6  *    ██████╔╝███████╗╚██████╔╝╚██████╔╝
7  *    ╚═════╝ ╚══════╝ ╚═════╝  ╚═════╝ 
8  *    
9  * https://dego.finance
10                                   
11 * MIT License
12 * ===========
13 *
14 * Copyright (c) 2020 dego
15 *
16 * Permission is hereby granted, free of charge, to any person obtaining a copy
17 * of this software and associated documentation files (the "Software"), to deal
18 * in the Software without restriction, including without limitation the rights
19 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
20 * copies of the Software, and to permit persons to whom the Software is
21 * furnished to do so, subject to the following conditions:
22 *
23 * The above copyright notice and this permission notice shall be included in all
24 * copies or substantial portions of the Software.
25 *
26 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
27 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
28 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
29 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
30 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
31 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
32 */
33 // File: @openzeppelin/contracts/math/SafeMath.sol
34 
35 pragma solidity ^0.5.0;
36 
37 /**
38  * @dev Wrappers over Solidity's arithmetic operations with added overflow
39  * checks.
40  *
41  * Arithmetic operations in Solidity wrap on overflow. This can easily result
42  * in bugs, because programmers usually assume that an overflow raises an
43  * error, which is the standard behavior in high level programming languages.
44  * `SafeMath` restores this intuition by reverting the transaction when an
45  * operation overflows.
46  *
47  * Using this library instead of the unchecked operations eliminates an entire
48  * class of bugs, so it's recommended to use it always.
49  */
50 library SafeMath {
51     /**
52      * @dev Returns the addition of two unsigned integers, reverting on
53      * overflow.
54      *
55      * Counterpart to Solidity's `+` operator.
56      *
57      * Requirements:
58      * - Addition cannot overflow.
59      */
60     function add(uint256 a, uint256 b) internal pure returns (uint256) {
61         uint256 c = a + b;
62         require(c >= a, "SafeMath: addition overflow");
63 
64         return c;
65     }
66 
67     /**
68      * @dev Returns the subtraction of two unsigned integers, reverting on
69      * overflow (when the result is negative).
70      *
71      * Counterpart to Solidity's `-` operator.
72      *
73      * Requirements:
74      * - Subtraction cannot overflow.
75      */
76     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
77         return sub(a, b, "SafeMath: subtraction overflow");
78     }
79 
80     /**
81      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
82      * overflow (when the result is negative).
83      *
84      * Counterpart to Solidity's `-` operator.
85      *
86      * Requirements:
87      * - Subtraction cannot overflow.
88      *
89      * _Available since v2.4.0._
90      */
91     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
92         require(b <= a, errorMessage);
93         uint256 c = a - b;
94 
95         return c;
96     }
97 
98     /**
99      * @dev Returns the multiplication of two unsigned integers, reverting on
100      * overflow.
101      *
102      * Counterpart to Solidity's `*` operator.
103      *
104      * Requirements:
105      * - Multiplication cannot overflow.
106      */
107     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
108         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
109         // benefit is lost if 'b' is also tested.
110         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
111         if (a == 0) {
112             return 0;
113         }
114 
115         uint256 c = a * b;
116         require(c / a == b, "SafeMath: multiplication overflow");
117 
118         return c;
119     }
120 
121     /**
122      * @dev Returns the integer division of two unsigned integers. Reverts on
123      * division by zero. The result is rounded towards zero.
124      *
125      * Counterpart to Solidity's `/` operator. Note: this function uses a
126      * `revert` opcode (which leaves remaining gas untouched) while Solidity
127      * uses an invalid opcode to revert (consuming all remaining gas).
128      *
129      * Requirements:
130      * - The divisor cannot be zero.
131      */
132     function div(uint256 a, uint256 b) internal pure returns (uint256) {
133         return div(a, b, "SafeMath: division by zero");
134     }
135 
136     /**
137      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
138      * division by zero. The result is rounded towards zero.
139      *
140      * Counterpart to Solidity's `/` operator. Note: this function uses a
141      * `revert` opcode (which leaves remaining gas untouched) while Solidity
142      * uses an invalid opcode to revert (consuming all remaining gas).
143      *
144      * Requirements:
145      * - The divisor cannot be zero.
146      *
147      * _Available since v2.4.0._
148      */
149     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
150         // Solidity only automatically asserts when dividing by 0
151         require(b > 0, errorMessage);
152         uint256 c = a / b;
153         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
154 
155         return c;
156     }
157 
158     /**
159      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
160      * Reverts when dividing by zero.
161      *
162      * Counterpart to Solidity's `%` operator. This function uses a `revert`
163      * opcode (which leaves remaining gas untouched) while Solidity uses an
164      * invalid opcode to revert (consuming all remaining gas).
165      *
166      * Requirements:
167      * - The divisor cannot be zero.
168      */
169     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
170         return mod(a, b, "SafeMath: modulo by zero");
171     }
172 
173     /**
174      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
175      * Reverts with custom message when dividing by zero.
176      *
177      * Counterpart to Solidity's `%` operator. This function uses a `revert`
178      * opcode (which leaves remaining gas untouched) while Solidity uses an
179      * invalid opcode to revert (consuming all remaining gas).
180      *
181      * Requirements:
182      * - The divisor cannot be zero.
183      *
184      * _Available since v2.4.0._
185      */
186     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
187         require(b != 0, errorMessage);
188         return a % b;
189     }
190 }
191 
192 // File: @openzeppelin/contracts/GSN/Context.sol
193 
194 pragma solidity ^0.5.0;
195 
196 /*
197  * @dev Provides information about the current execution context, including the
198  * sender of the transaction and its data. While these are generally available
199  * via msg.sender and msg.data, they should not be accessed in such a direct
200  * manner, since when dealing with GSN meta-transactions the account sending and
201  * paying for execution may not be the actual sender (as far as an application
202  * is concerned).
203  *
204  * This contract is only required for intermediate, library-like contracts.
205  */
206 contract Context {
207     // Empty internal constructor, to prevent people from mistakenly deploying
208     // an instance of this contract, which should be used via inheritance.
209     constructor () internal { }
210     // solhint-disable-previous-line no-empty-blocks
211 
212     function _msgSender() internal view returns (address payable) {
213         return msg.sender;
214     }
215 
216     function _msgData() internal view returns (bytes memory) {
217         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
218         return msg.data;
219     }
220 }
221 
222 // File: @openzeppelin/contracts/ownership/Ownable.sol
223 
224 pragma solidity ^0.5.0;
225 
226 /**
227  * @dev Contract module which provides a basic access control mechanism, where
228  * there is an account (an owner) that can be granted exclusive access to
229  * specific functions.
230  *
231  * This module is used through inheritance. It will make available the modifier
232  * `onlyOwner`, which can be applied to your functions to restrict their use to
233  * the owner.
234  */
235 contract Ownable is Context {
236     address private _owner;
237 
238     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
239 
240     /**
241      * @dev Initializes the contract setting the deployer as the initial owner.
242      */
243     constructor () internal {
244         address msgSender = _msgSender();
245         _owner = msgSender;
246         emit OwnershipTransferred(address(0), msgSender);
247     }
248 
249     /**
250      * @dev Returns the address of the current owner.
251      */
252     function owner() public view returns (address) {
253         return _owner;
254     }
255 
256     /**
257      * @dev Throws if called by any account other than the owner.
258      */
259     modifier onlyOwner() {
260         require(isOwner(), "Ownable: caller is not the owner");
261         _;
262     }
263 
264     /**
265      * @dev Returns true if the caller is the current owner.
266      */
267     function isOwner() public view returns (bool) {
268         return _msgSender() == _owner;
269     }
270 
271     /**
272      * @dev Leaves the contract without owner. It will not be possible to call
273      * `onlyOwner` functions anymore. Can only be called by the current owner.
274      *
275      * NOTE: Renouncing ownership will leave the contract without an owner,
276      * thereby removing any functionality that is only available to the owner.
277      */
278     function renounceOwnership() public onlyOwner {
279         emit OwnershipTransferred(_owner, address(0));
280         _owner = address(0);
281     }
282 
283     /**
284      * @dev Transfers ownership of the contract to a new account (`newOwner`).
285      * Can only be called by the current owner.
286      */
287     function transferOwnership(address newOwner) public onlyOwner {
288         _transferOwnership(newOwner);
289     }
290 
291     /**
292      * @dev Transfers ownership of the contract to a new account (`newOwner`).
293      */
294     function _transferOwnership(address newOwner) internal {
295         require(newOwner != address(0), "Ownable: new owner is the zero address");
296         emit OwnershipTransferred(_owner, newOwner);
297         _owner = newOwner;
298     }
299 }
300 
301 // File: contracts/library/NameFilter.sol
302 
303 pragma solidity ^0.5.0;
304 
305 library NameFilter {
306     /**
307      * @dev filters name strings
308      * -converts uppercase to lower case.  
309      * -makes sure it does not start/end with a space
310      * -makes sure it does not contain multiple spaces in a row
311      * -cannot be only numbers
312      * -cannot start with 0x 
313      * -restricts characters to A-Z, a-z, 0-9, and space.
314      * @return reprocessed string in bytes32 format
315      */
316     function nameFilter(string memory _input)
317         internal
318         pure
319         returns(bytes32)
320     {
321         bytes memory _temp = bytes(_input);
322         uint256 _length = _temp.length;
323         
324         //sorry limited to 32 characters
325         require (_length <= 32 && _length > 0, "string must be between 1 and 32 characters");
326         // make sure first two characters are not 0x
327         if (_temp[0] == 0x30)
328         {
329             require(_temp[1] != 0x78, "string cannot start with 0x");
330             require(_temp[1] != 0x58, "string cannot start with 0X");
331         }
332         
333         // create a bool to track if we have a non number character
334         bool _hasNonNumber;
335         
336         // convert & check
337         for (uint256 i = 0; i < _length; i++)
338         {
339             // if its uppercase A-Z
340             if (_temp[i] > 0x40 && _temp[i] < 0x5b)
341             {
342                 // convert to lower case a-z
343                 _temp[i] = byte(uint8(_temp[i]) + 32);
344                 
345                 // we have a non number
346                 if (_hasNonNumber == false)
347                     _hasNonNumber = true;
348             } else {
349                 require
350                 (
351                     // OR lowercase a-z
352                     (_temp[i] > 0x60 && _temp[i] < 0x7b) ||
353                     // or 0-9
354                     (_temp[i] > 0x2f && _temp[i] < 0x3a),
355                     "string contains invalid characters"
356                 );
357                 
358                 // see if we have a character other than a number
359                 if (_hasNonNumber == false && (_temp[i] < 0x30 || _temp[i] > 0x39))
360                     _hasNonNumber = true;    
361             }
362         }
363         
364         require(_hasNonNumber == true, "string cannot be only numbers");
365         
366         bytes32 _ret;
367         assembly {
368             _ret := mload(add(_temp, 32))
369         }
370         return (_ret);
371     }
372 }
373 
374 // File: contracts/interface/IERC20.sol
375 
376 pragma solidity ^0.5.0;
377 
378 /**
379  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
380  * the optional functions; to access them see {ERC20Detailed}.
381  */
382 interface IERC20 {
383     /**
384      * @dev Returns the amount of tokens in existence.
385      */
386     function totalSupply() external view returns (uint256);
387 
388     /**
389      * @dev Returns the amount of tokens owned by `account`.
390      */
391     function balanceOf(address account) external view returns (uint256);
392 
393     /**
394      * @dev Moves `amount` tokens from the caller's account to `recipient`.
395      *
396      * Returns a boolean value indicating whether the operation succeeded.
397      *
398      * Emits a {Transfer} event.
399      */
400     function transfer(address recipient, uint256 amount) external returns (bool);
401     function mint(address account, uint amount) external;
402     /**
403      * @dev Returns the remaining number of tokens that `spender` will be
404      * allowed to spend on behalf of `owner` through {transferFrom}. This is
405      * zero by default.
406      *
407      * This value changes when {approve} or {transferFrom} are called.
408      */
409     function allowance(address owner, address spender) external view returns (uint256);
410 
411     /**
412      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
413      *
414      * Returns a boolean value indicating whether the operation succeeded.
415      *
416      * IMPORTANT: Beware that changing an allowance with this method brings the risk
417      * that someone may use both the old and the new allowance by unfortunate
418      * transaction ordering. One possible solution to mitigate this race
419      * condition is to first reduce the spender's allowance to 0 and set the
420      * desired value afterwards:
421      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
422      *
423      * Emits an {Approval} event.
424      */
425     function approve(address spender, uint256 amount) external returns (bool);
426 
427     /**
428      * @dev Moves `amount` tokens from `sender` to `recipient` using the
429      * allowance mechanism. `amount` is then deducted from the caller's
430      * allowance.
431      *
432      * Returns a boolean value indicating whether the operation succeeded.
433      *
434      * Emits a {Transfer} event.
435      */
436     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
437 
438     /**
439      * @dev Emitted when `value` tokens are moved from one account (`from`) to
440      * another (`to`).
441      *
442      * Note that `value` may be zero.
443      */
444     event Transfer(address indexed from, address indexed to, uint256 value);
445 
446     /**
447      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
448      * a call to {approve}. `value` is the new allowance.
449      */
450     event Approval(address indexed owner, address indexed spender, uint256 value);
451 }
452 
453 // File: @openzeppelin/contracts/utils/Address.sol
454 
455 pragma solidity ^0.5.5;
456 
457 /**
458  * @dev Collection of functions related to the address type
459  */
460 library Address {
461     /**
462      * @dev Returns true if `account` is a contract.
463      *
464      * [IMPORTANT]
465      * ====
466      * It is unsafe to assume that an address for which this function returns
467      * false is an externally-owned account (EOA) and not a contract.
468      *
469      * Among others, `isContract` will return false for the following 
470      * types of addresses:
471      *
472      *  - an externally-owned account
473      *  - a contract in construction
474      *  - an address where a contract will be created
475      *  - an address where a contract lived, but was destroyed
476      * ====
477      */
478     function isContract(address account) internal view returns (bool) {
479         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
480         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
481         // for accounts without code, i.e. `keccak256('')`
482         bytes32 codehash;
483         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
484         // solhint-disable-next-line no-inline-assembly
485         assembly { codehash := extcodehash(account) }
486         return (codehash != accountHash && codehash != 0x0);
487     }
488 
489     /**
490      * @dev Converts an `address` into `address payable`. Note that this is
491      * simply a type cast: the actual underlying value is not changed.
492      *
493      * _Available since v2.4.0._
494      */
495     function toPayable(address account) internal pure returns (address payable) {
496         return address(uint160(account));
497     }
498 
499     /**
500      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
501      * `recipient`, forwarding all available gas and reverting on errors.
502      *
503      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
504      * of certain opcodes, possibly making contracts go over the 2300 gas limit
505      * imposed by `transfer`, making them unable to receive funds via
506      * `transfer`. {sendValue} removes this limitation.
507      *
508      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
509      *
510      * IMPORTANT: because control is transferred to `recipient`, care must be
511      * taken to not create reentrancy vulnerabilities. Consider using
512      * {ReentrancyGuard} or the
513      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
514      *
515      * _Available since v2.4.0._
516      */
517     function sendValue(address payable recipient, uint256 amount) internal {
518         require(address(this).balance >= amount, "Address: insufficient balance");
519 
520         // solhint-disable-next-line avoid-call-value
521         (bool success, ) = recipient.call.value(amount)("");
522         require(success, "Address: unable to send value, recipient may have reverted");
523     }
524 }
525 
526 // File: contracts/library/SafeERC20.sol
527 
528 pragma solidity ^0.5.0;
529 
530 
531 
532 
533 
534 /**
535  * @title SafeERC20
536  * @dev Wrappers around ERC20 operations that throw on failure (when the token
537  * contract returns false). Tokens that return no value (and instead revert or
538  * throw on failure) are also supported, non-reverting calls are assumed to be
539  * successful.
540  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
541  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
542  */
543 library SafeERC20 {
544     using SafeMath for uint256;
545     using Address for address;
546 
547     function safeTransfer(IERC20 token, address to, uint256 value) internal {
548         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
549     }
550 
551     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
552         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
553     }
554 
555     function safeApprove(IERC20 token, address spender, uint256 value) internal {
556         // safeApprove should only be called when setting an initial allowance,
557         // or when resetting it to zero. To increase and decrease it, use
558         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
559         // solhint-disable-next-line max-line-length
560         require((value == 0) || (token.allowance(address(this), spender) == 0),
561             "SafeERC20: approve from non-zero to non-zero allowance"
562         );
563         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
564     }
565 
566     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
567         uint256 newAllowance = token.allowance(address(this), spender).add(value);
568         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
569     }
570 
571     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
572         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
573         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
574     }
575 
576     /**
577      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
578      * on the return value: the return value is optional (but if data is returned, it must not be false).
579      * @param token The token targeted by the call.
580      * @param data The call data (encoded using abi.encode or one of its variants).
581      */
582     function callOptionalReturn(IERC20 token, bytes memory data) private {
583         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
584         // we're implementing it ourselves.
585 
586         // A Solidity high level call has three parts:
587         //  1. The target address is checked to verify it contains contract code
588         //  2. The call itself is made, and success asserted
589         //  3. The return value is decoded, which in turn checks the size of the returned data.
590         // solhint-disable-next-line max-line-length
591         require(address(token).isContract(), "SafeERC20: call to non-contract");
592 
593         // solhint-disable-next-line avoid-low-level-calls
594         (bool success, bytes memory returndata) = address(token).call(data);
595         require(success, "SafeERC20: low-level call failed");
596 
597         if (returndata.length > 0) { // Return data is optional
598             // solhint-disable-next-line max-line-length
599             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
600         }
601     }
602 }
603 
604 // File: contracts/library/Governance.sol
605 
606 pragma solidity ^0.5.0;
607 
608 contract Governance {
609 
610     address public _governance;
611 
612     constructor() public {
613         _governance = tx.origin;
614     }
615 
616     event GovernanceTransferred(address indexed previousOwner, address indexed newOwner);
617 
618     modifier onlyGovernance {
619         require(msg.sender == _governance, "not governance");
620         _;
621     }
622 
623     function setGovernance(address governance)  public  onlyGovernance
624     {
625         require(governance != address(0), "new governance the zero address");
626         emit GovernanceTransferred(_governance, governance);
627         _governance = governance;
628     }
629 
630 
631 }
632 
633 // File: contracts/interface/IPlayerBook.sol
634 
635 pragma solidity ^0.5.0;
636 
637 
638 interface IPlayerBook {
639     function settleReward( address from,uint256 amount ) external returns (uint256);
640     function bindRefer( address from,string calldata  affCode )  external returns (bool);
641     function hasRefer(address from) external returns(bool);
642 
643 }
644 
645 // File: contracts/referral/PlayerBook.sol
646 
647 pragma solidity ^0.5.0;
648 
649 
650 
651 
652 
653 
654 
655 contract PlayerBook is Governance, IPlayerBook {
656     using NameFilter for string;
657     using SafeMath for uint256;
658     using SafeERC20 for IERC20;
659  
660     // register pools       
661     mapping (address => bool) public _pools;
662 
663     // (addr => pID) returns player id by address
664     mapping (address => uint256) public _pIDxAddr;   
665     // (name => pID) returns player id by name      
666     mapping (bytes32 => uint256) public _pIDxName;    
667     // (pID => data) player data     
668     mapping (uint256 => Player) public _plyr;      
669     // (pID => name => bool) list of names a player owns.  (used so you can change your display name amoungst any name you own)        
670     mapping (uint256 => mapping (bytes32 => bool)) public _plyrNames; 
671   
672     // the  of refrerrals
673     uint256 public _totalReferReward;         
674     // total number of players
675     uint256 public _pID;      
676     // total register name count
677     uint256 public _totalRegisterCount = 0;
678 
679     // the direct refer's reward rate
680     uint256 public _refer1RewardRate = 700; //7%
681     // the second direct refer's reward rate
682     uint256 public _refer2RewardRate = 300; //3%
683     // base rate
684     uint256 public _baseRate = 10000;
685 
686     // base price to register a name
687     uint256 public _registrationBaseFee = 100 finney;     
688     // register fee count step
689     uint256 public _registrationStep = 100;
690     // add base price for one step
691     uint256 public _stepFee = 100 finney;     
692 
693     bytes32 public _defaulRefer ="dego";
694 
695     address payable public _teamWallet = 0x3D0a845C5ef9741De999FC068f70E2048A489F2b;
696   
697     IERC20 public _dego = IERC20(0x0);
698    
699     struct Player {
700         address addr;
701         bytes32 name;
702         uint8 nameCount;
703         uint256 laff;
704         uint256 amount;
705         uint256 rreward;
706         uint256 allReward;
707         uint256 lv1Count;
708         uint256 lv2Count;
709     }
710 
711     event eveClaim(uint256 pID, address addr, uint256 reward, uint256 balance );
712     event eveBindRefer(uint256 pID, address addr, bytes32 name, uint256 affID, address affAddr, bytes32 affName);
713     event eveDefaultPlayer(uint256 pID, address addr, bytes32 name);      
714     event eveNewName(uint256 pID, address addr, bytes32 name, uint256 affID, address affAddr, bytes32 affName, uint256 balance  );
715     event eveSettle(uint256 pID, uint256 affID, uint256 aff_affID, uint256 affReward, uint256 aff_affReward, uint256 amount);
716     event eveAddPool(address addr);
717     event eveRemovePool(address addr);
718 
719 
720     constructor()
721         public
722     {
723         _pID = 0;
724         _totalReferReward = 0;
725         addDefaultPlayer(_teamWallet,_defaulRefer);
726     }
727 
728     /**
729      * check address
730      */
731     modifier validAddress( address addr ) {
732         require(addr != address(0x0));
733         _;
734     }
735 
736     /**
737      * check pool
738      */
739     modifier isRegisteredPool(){
740         require(_pools[msg.sender],"invalid pool address!");
741         _;
742     }
743 
744     /**
745      * contract dego balances
746      */
747     function balances()
748         public
749         view
750         returns(uint256)
751     {
752         return (_dego.balanceOf(address(this)));
753     }
754 
755     // only function for creating additional rewards from dust
756     function seize(IERC20 asset) external returns (uint256 balance) {
757         require(address(_dego) != address(asset), "forbbiden dego");
758 
759         balance = asset.balanceOf(address(this));
760         asset.safeTransfer(_teamWallet, balance);
761     }
762 
763     // get register fee 
764     function seizeEth() external  {
765         uint256 _currentBalance =  address(this).balance;
766         _teamWallet.transfer(_currentBalance);
767     }
768     
769     /**
770      * revert invalid transfer action
771      */
772     function() external payable {
773         revert();
774     }
775 
776 
777     /**
778      * registe a pool
779      */
780     function addPool(address poolAddr)
781         onlyGovernance
782         public
783     {
784         require( !_pools[poolAddr], "derp, that pool already been registered");
785 
786         _pools[poolAddr] = true;
787 
788         emit eveAddPool(poolAddr);
789     }
790     
791     /**
792      * remove a pool
793      */
794     function removePool(address poolAddr)
795         onlyGovernance
796         public
797     {
798         require( _pools[poolAddr], "derp, that pool must be registered");
799 
800         _pools[poolAddr] = false;
801 
802         emit eveRemovePool(poolAddr);
803     }
804 
805     /**
806      * resolve the refer's reward from a player 
807      */
808     function settleReward(address from, uint256 amount)
809         isRegisteredPool()
810         validAddress(from)    
811         external
812         returns (uint256)
813     {
814          // set up our tx event data and determine if player is new or not
815         _determinePID(from);
816 
817         uint256 pID = _pIDxAddr[from];
818         uint256 affID = _plyr[pID].laff;
819         
820         if(affID <= 0 ){
821             affID = _pIDxName[_defaulRefer];
822             _plyr[pID].laff = affID;
823         }
824 
825         if(amount <= 0){
826             return 0;
827         }
828 
829         uint256 fee = 0;
830 
831         // father
832         uint256 affReward = (amount.mul(_refer1RewardRate)).div(_baseRate);
833         _plyr[affID].rreward = _plyr[affID].rreward.add(affReward);
834         _totalReferReward = _totalReferReward.add(affReward);
835         fee = fee.add(affReward);
836 
837 
838         // grandfather
839         uint256 aff_affID = _plyr[affID].laff;
840         uint256 aff_affReward = amount.mul(_refer2RewardRate).div(_baseRate);
841         if(aff_affID <= 0){
842             aff_affID = _pIDxName[_defaulRefer];
843         }
844         _plyr[aff_affID].rreward = _plyr[aff_affID].rreward.add(aff_affReward);
845         _totalReferReward= _totalReferReward.add(aff_affReward);
846 
847         _plyr[pID].amount = _plyr[pID].amount.add( amount);
848 
849         fee = fee.add(aff_affReward);
850        
851         emit eveSettle( pID,affID,aff_affID,affReward,aff_affReward,amount);
852 
853         return fee;
854     }
855 
856     /**
857      * claim all of the refer reward.
858      */
859     function claim()
860         public
861     {
862         address addr = msg.sender;
863         uint256 pid = _pIDxAddr[addr];
864         uint256 reward = _plyr[pid].rreward;
865 
866         require(reward > 0,"only have reward");
867         
868         //reset
869         _plyr[pid].allReward = _plyr[pid].allReward.add(reward);
870         _plyr[pid].rreward = 0;
871 
872         //get reward
873         _dego.safeTransfer(addr, reward);
874         
875         // fire event
876         emit eveClaim(_pIDxAddr[addr], addr, reward, balances());
877     }
878 
879 
880     /**
881      * check name string
882      */
883     function checkIfNameValid(string memory nameStr)
884         public
885         view
886         returns(bool)
887     {
888         bytes32 name = nameStr.nameFilter();
889         if (_pIDxName[name] == 0)
890             return (true);
891         else 
892             return (false);
893     }
894     
895     /**
896      * @dev add a default player
897      */
898     function addDefaultPlayer(address addr, bytes32 name)
899         private
900     {        
901         _pID++;
902 
903         _plyr[_pID].addr = addr;
904         _plyr[_pID].name = name;
905         _plyr[_pID].nameCount = 1;
906         _pIDxAddr[addr] = _pID;
907         _pIDxName[name] = _pID;
908         _plyrNames[_pID][name] = true;
909 
910         //fire event
911         emit eveDefaultPlayer(_pID,addr,name);        
912     }
913     
914     /**
915      * @dev set refer reward rate
916      */
917     function setReferRewardRate(uint256 refer1Rate, uint256 refer2Rate ) public  
918         onlyGovernance
919     {
920         _refer1RewardRate = refer1Rate;
921         _refer2RewardRate = refer2Rate;
922     }
923 
924     /**
925      * @dev set registration step count
926      */
927     function setRegistrationStep(uint256 registrationStep) public  
928         onlyGovernance
929     {
930         _registrationStep = registrationStep;
931     }
932 
933     /**
934      * @dev set dego contract address
935      */
936     function setDegoContract(address dego)  public  
937         onlyGovernance{
938         _dego = IERC20(dego);
939     }
940 
941 
942     /**
943      * @dev registers a name.  UI will always display the last name you registered.
944      * but you will still own all previously registered names to use as affiliate 
945      * links.
946      * - must pay a registration fee.
947      * - name must be unique
948      * - names will be converted to lowercase
949      * - cannot be only numbers
950      * - cannot start with 0x 
951      * - name must be at least 1 char
952      * - max length of 32 characters long
953      * - allowed characters: a-z, 0-9
954      * -functionhash- 0x921dec21 (using ID for affiliate)
955      * -functionhash- 0x3ddd4698 (using address for affiliate)
956      * -functionhash- 0x685ffd83 (using name for affiliate)
957      * @param nameString players desired name
958      * @param affCode affiliate name of who refered you
959      * (this might cost a lot of gas)
960      */
961 
962     function registerNameXName(string memory nameString, string memory affCode)
963         public
964         payable 
965     {
966 
967         // make sure name fees paid
968         require (msg.value >= this.getRegistrationFee(), "umm.....  you have to pay the name fee");
969 
970         // filter name + condition checks
971         bytes32 name = NameFilter.nameFilter(nameString);
972         // if names already has been used
973         require(_pIDxName[name] == 0, "sorry that names already taken");
974 
975         // set up address 
976         address addr = msg.sender;
977          // set up our tx event data and determine if player is new or not
978         _determinePID(addr);
979         // fetch player id
980         uint256 pID = _pIDxAddr[addr];
981         // if names already has been used
982         require(_plyrNames[pID][name] == false, "sorry that names already taken");
983 
984         // add name to player profile, registry, and name book
985         _plyrNames[pID][name] = true;
986         _pIDxName[name] = pID;   
987         _plyr[pID].name = name;
988         _plyr[pID].nameCount++;
989 
990         _totalRegisterCount++;
991 
992 
993         //try bind a refer
994         if(_plyr[pID].laff == 0){
995 
996             bytes memory tempCode = bytes(affCode);
997             bytes32 affName = 0x0;
998             if (tempCode.length >= 0) {
999                 assembly {
1000                     affName := mload(add(tempCode, 32))
1001                 }
1002             }
1003 
1004             _bindRefer(addr,affName);
1005         }
1006         uint256 affID = _plyr[pID].laff;
1007 
1008         // fire event
1009         emit eveNewName(pID, addr, name, affID, _plyr[affID].addr, _plyr[affID].name, _registrationBaseFee );
1010     }
1011     
1012     /**
1013      * @dev bind a refer,if affcode invalid, use default refer
1014      */  
1015     function bindRefer( address from, string calldata  affCode )
1016         isRegisteredPool()
1017         external
1018         returns (bool)
1019     {
1020 
1021         bytes memory tempCode = bytes(affCode);
1022         bytes32 affName = 0x0;
1023         if (tempCode.length >= 0) {
1024             assembly {
1025                 affName := mload(add(tempCode, 32))
1026             }
1027         }
1028 
1029         return _bindRefer(from, affName);
1030     }
1031 
1032 
1033     /**
1034      * @dev bind a refer,if affcode invalid, use default refer
1035      */  
1036     function _bindRefer( address from, bytes32  name )
1037         validAddress(msg.sender)    
1038         validAddress(from)  
1039         private
1040         returns (bool)
1041     {
1042         // set up our tx event data and determine if player is new or not
1043         _determinePID(from);
1044 
1045         // fetch player id
1046         uint256 pID = _pIDxAddr[from];
1047         if( _plyr[pID].laff != 0){
1048             return false;
1049         }
1050 
1051         if (_pIDxName[name] == 0){
1052             //unregister name 
1053             name = _defaulRefer;
1054         }
1055       
1056         uint256 affID = _pIDxName[name];
1057         if( affID == pID){
1058             affID = _pIDxName[_defaulRefer];
1059         }
1060        
1061         _plyr[pID].laff = affID;
1062 
1063         //lvcount
1064         _plyr[affID].lv1Count++;
1065         uint256 aff_affID = _plyr[affID].laff;
1066         if(aff_affID != 0 ){
1067             _plyr[aff_affID].lv2Count++;
1068         }
1069         
1070         // fire event
1071         emit eveBindRefer(pID, from, name, affID, _plyr[affID].addr, _plyr[affID].name);
1072 
1073         return true;
1074     }
1075     
1076     //
1077     function _determinePID(address addr)
1078         private
1079         returns (bool)
1080     {
1081         if (_pIDxAddr[addr] == 0)
1082         {
1083             _pID++;
1084             _pIDxAddr[addr] = _pID;
1085             _plyr[_pID].addr = addr;
1086             
1087             // set the new player bool to true
1088             return (true);
1089         } else {
1090             return (false);
1091         }
1092     }
1093     
1094     function hasRefer(address from) 
1095         isRegisteredPool()
1096         external 
1097         returns(bool) 
1098     {
1099         _determinePID(from);
1100         uint256 pID =  _pIDxAddr[from];
1101         return (_plyr[pID].laff > 0);
1102     }
1103 
1104     
1105     function getPlayerName(address from)
1106         external
1107         view
1108         returns (bytes32)
1109     {
1110         uint256 pID =  _pIDxAddr[from];
1111         if(_pID==0){
1112             return "";
1113         }
1114         return (_plyr[pID].name);
1115     }
1116 
1117     function getPlayerLaffName(address from)
1118         external
1119         view
1120         returns (bytes32)
1121     {
1122         uint256 pID =  _pIDxAddr[from];
1123         if(_pID==0){
1124              return "";
1125         }
1126 
1127         uint256 aID=_plyr[pID].laff;
1128         if( aID== 0){
1129             return "";
1130         }
1131 
1132         return (_plyr[aID].name);
1133     }
1134 
1135     function getPlayerInfo(address from)
1136         external
1137         view
1138         returns (uint256,uint256,uint256,uint256)
1139     {
1140         uint256 pID = _pIDxAddr[from];
1141         if(_pID==0){
1142              return (0,0,0,0);
1143         }
1144         return (_plyr[pID].rreward,_plyr[pID].allReward,_plyr[pID].lv1Count,_plyr[pID].lv2Count);
1145     }
1146 
1147     function getTotalReferReward()
1148         external
1149         view
1150         returns (uint256)
1151     {
1152         return(_totalReferReward);
1153     }
1154 
1155     function getRegistrationFee()
1156         external
1157         view
1158         returns (uint256)
1159     {
1160         if( _totalRegisterCount <_registrationStep || _registrationStep == 0){
1161             return _registrationBaseFee;
1162         }
1163         else{
1164             uint256 step = _totalRegisterCount.div(_registrationStep);
1165             return _registrationBaseFee.add(step.mul(_stepFee));
1166         }
1167     }
1168 }