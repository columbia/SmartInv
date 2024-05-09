1 // File: @openzeppelin/contracts/GSN/Context.sol
2 
3 pragma solidity ^0.5.0;
4 
5 /*
6  * @dev Provides information about the current execution context, including the
7  * sender of the transaction and its data. While these are generally available
8  * via msg.sender and msg.data, they should not be accessed in such a direct
9  * manner, since when dealing with GSN meta-transactions the account sending and
10  * paying for execution may not be the actual sender (as far as an application
11  * is concerned).
12  *
13  * This contract is only required for intermediate, library-like contracts.
14  */
15 contract Context {
16     // Empty internal constructor, to prevent people from mistakenly deploying
17     // an instance of this contract, which should be used via inheritance.
18     constructor () internal { }
19     // solhint-disable-previous-line no-empty-blocks
20 
21     function _msgSender() internal view returns (address payable) {
22         return msg.sender;
23     }
24 
25     function _msgData() internal view returns (bytes memory) {
26         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
27         return msg.data;
28     }
29 }
30 
31 // File: @openzeppelin/contracts/ownership/Ownable.sol
32 
33 pragma solidity ^0.5.0;
34 
35 /**
36  * @dev Contract module which provides a basic access control mechanism, where
37  * there is an account (an owner) that can be granted exclusive access to
38  * specific functions.
39  *
40  * This module is used through inheritance. It will make available the modifier
41  * `onlyOwner`, which can be applied to your functions to restrict their use to
42  * the owner.
43  */
44 contract Ownable is Context {
45     address private _owner;
46 
47     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
48 
49     /**
50      * @dev Initializes the contract setting the deployer as the initial owner.
51      */
52     constructor () internal {
53         _owner = _msgSender();
54         emit OwnershipTransferred(address(0), _owner);
55     }
56 
57     /**
58      * @dev Returns the address of the current owner.
59      */
60     function owner() public view returns (address) {
61         return _owner;
62     }
63 
64     /**
65      * @dev Throws if called by any account other than the owner.
66      */
67     modifier onlyOwner() {
68         require(isOwner(), "Ownable: caller is not the owner");
69         _;
70     }
71 
72     /**
73      * @dev Returns true if the caller is the current owner.
74      */
75     function isOwner() public view returns (bool) {
76         return _msgSender() == _owner;
77     }
78 
79     /**
80      * @dev Leaves the contract without owner. It will not be possible to call
81      * `onlyOwner` functions anymore. Can only be called by the current owner.
82      *
83      * NOTE: Renouncing ownership will leave the contract without an owner,
84      * thereby removing any functionality that is only available to the owner.
85      */
86     function renounceOwnership() public onlyOwner {
87         emit OwnershipTransferred(_owner, address(0));
88         _owner = address(0);
89     }
90 
91     /**
92      * @dev Transfers ownership of the contract to a new account (`newOwner`).
93      * Can only be called by the current owner.
94      */
95     function transferOwnership(address newOwner) public onlyOwner {
96         _transferOwnership(newOwner);
97     }
98 
99     /**
100      * @dev Transfers ownership of the contract to a new account (`newOwner`).
101      */
102     function _transferOwnership(address newOwner) internal {
103         require(newOwner != address(0), "Ownable: new owner is the zero address");
104         emit OwnershipTransferred(_owner, newOwner);
105         _owner = newOwner;
106     }
107 }
108 
109 // File: contracts/Library/IERC20.sol
110 
111 pragma solidity ^0.5.14;
112 
113 interface IERC20 {
114     event Transfer(address indexed _from, address indexed _to, uint256 _value);
115     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
116 
117     function transfer(address _to, uint256 _value) external returns (bool);
118     function transferFrom(address _from, address _to, uint256 _value) external returns (bool);
119     function approve(address _spender, uint256 _value) external returns (bool);
120 }
121 
122 // File: contracts/Library/SafeMath.sol
123 
124 pragma solidity ^0.5.14;
125 
126 /**
127  * @dev Wrappers over Solidity's arithmetic operations with added overflow
128  * checks.
129  *
130  * Arithmetic operations in Solidity wrap on overflow. This can easily result
131  * in bugs, because programmers usually assume that an overflow raises an
132  * error, which is the standard behavior in high level programming languages.
133  * `SafeMath` restores this intuition by reverting the transaction when an
134  * operation overflows.
135  *
136  * Using this library instead of the unchecked operations eliminates an entire
137  * class of bugs, so it's recommended to use it always.
138  */
139 library SafeMath {
140     /**
141      * @dev Returns the addition of two unsigned integers, reverting on
142      * overflow.
143      *
144      * Counterpart to Solidity's `+` operator.
145      *
146      * Requirements:
147      * - Addition cannot overflow.
148      */
149     function add(uint256 a, uint256 b) internal pure returns (uint256) {
150         uint256 c = a + b;
151         require(c >= a, "SafeMath: addition overflow");
152 
153         return c;
154     }
155 
156     /**
157      * @dev Returns the subtraction of two unsigned integers, reverting on
158      * overflow (when the result is negative).
159      *
160      * Counterpart to Solidity's `-` operator.
161      *
162      * Requirements:
163      * - Subtraction cannot overflow.
164      */
165     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
166         return sub(a, b, "SafeMath: subtraction overflow");
167     }
168 
169     /**
170      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
171      * overflow (when the result is negative).
172      *
173      * Counterpart to Solidity's `-` operator.
174      *
175      * Requirements:
176      * - Subtraction cannot overflow.
177      *
178      * _Available since v2.4.0._
179      */
180     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
181         require(b <= a, errorMessage);
182         uint256 c = a - b;
183 
184         return c;
185     }
186 
187     /**
188      * @dev Returns the multiplication of two unsigned integers, reverting on
189      * overflow.
190      *
191      * Counterpart to Solidity's `*` operator.
192      *
193      * Requirements:
194      * - Multiplication cannot overflow.
195      */
196     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
197         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
198         // benefit is lost if 'b' is also tested.
199         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
200         if (a == 0) {
201             return 0;
202         }
203 
204         uint256 c = a * b;
205         require(c / a == b, "SafeMath: multiplication overflow");
206 
207         return c;
208     }
209 
210     /**
211      * @dev Returns the integer division of two unsigned integers. Reverts on
212      * division by zero. The result is rounded towards zero.
213      *
214      * Counterpart to Solidity's `/` operator. Note: this function uses a
215      * `revert` opcode (which leaves remaining gas untouched) while Solidity
216      * uses an invalid opcode to revert (consuming all remaining gas).
217      *
218      * Requirements:
219      * - The divisor cannot be zero.
220      */
221     function div(uint256 a, uint256 b) internal pure returns (uint256) {
222         return div(a, b, "SafeMath: division by zero");
223     }
224 
225     /**
226      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
227      * division by zero. The result is rounded towards zero.
228      *
229      * Counterpart to Solidity's `/` operator. Note: this function uses a
230      * `revert` opcode (which leaves remaining gas untouched) while Solidity
231      * uses an invalid opcode to revert (consuming all remaining gas).
232      *
233      * Requirements:
234      * - The divisor cannot be zero.
235      *
236      * _Available since v2.4.0._
237      */
238     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
239         // Solidity only automatically asserts when dividing by 0
240         require(b > 0, errorMessage);
241         uint256 c = a / b;
242         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
243 
244         return c;
245     }
246 
247     /**
248      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
249      * Reverts when dividing by zero.
250      *
251      * Counterpart to Solidity's `%` operator. This function uses a `revert`
252      * opcode (which leaves remaining gas untouched) while Solidity uses an
253      * invalid opcode to revert (consuming all remaining gas).
254      *
255      * Requirements:
256      * - The divisor cannot be zero.
257      */
258     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
259         return mod(a, b, "SafeMath: modulo by zero");
260     }
261 
262     /**
263      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
264      * Reverts with custom message when dividing by zero.
265      *
266      * Counterpart to Solidity's `%` operator. This function uses a `revert`
267      * opcode (which leaves remaining gas untouched) while Solidity uses an
268      * invalid opcode to revert (consuming all remaining gas).
269      *
270      * Requirements:
271      * - The divisor cannot be zero.
272      *
273      * _Available since v2.4.0._
274      */
275     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
276         require(b != 0, errorMessage);
277         return a % b;
278     }
279 }
280 
281 // File: contracts/Library/Freezer.sol
282 
283 pragma solidity ^0.5.14;
284 
285 
286 /**
287  * @title Freezer
288  * @author Yoonsung
289  * @notice This Contracts is an extension of the ERC20. Transfer
290  * of a specific address can be blocked from by the Owner of the
291  * Token Contract.
292  */
293 contract Freezer is Ownable {
294     event Freezed(address dsc);
295     event Unfreezed(address dsc);
296 
297     mapping (address => bool) public freezing;
298 
299     modifier isFreezed (address src) {
300         require(freezing[src] == false, "Freeze/Fronzen-Account");
301         _;
302     }
303 
304     /**
305     * @notice The Freeze function sets the transfer limit
306     * for a specific address.
307     * @param _dsc address The specify address want to limit the transfer.
308     */
309     function freeze(address _dsc) external onlyOwner {
310         require(_dsc != address(0), "Freeze/Zero-Address");
311         require(freezing[_dsc] == false, "Freeze/Already-Freezed");
312 
313         freezing[_dsc] = true;
314 
315         emit Freezed(_dsc);
316     }
317 
318     /**
319     * @notice The Freeze function removes the transfer limit
320     * for a specific address.
321     * @param _dsc address The specify address want to remove the transfer.
322     */
323     function unFreeze(address _dsc) external onlyOwner {
324         require(freezing[_dsc] == true, "Freeze/Already-Unfreezed");
325 
326         delete freezing[_dsc];
327 
328         emit Unfreezed(_dsc);
329     }
330 }
331 
332 // File: contracts/Library/SendLimiter.sol
333 
334 pragma solidity ^0.5.14;
335 
336 
337 /**
338  * @title SendLimiter
339  * @author Yoonsung
340  * @notice This contract acts as an ERC20 extension. It must
341  * be called from the creator of the ERC20, and a modifier is
342  * provided that can be used together. This contract is short-lived.
343  * You cannot re-enable it after SendUnlock, to be careful. Provides 
344  * a set of functions to manage the addresses that can be sent.
345  */
346 contract SendLimiter is Ownable {
347     event SendWhitelisted(address dsc);
348     event SendDelisted(address dsc);
349     event SendUnlocked();
350 
351     bool public sendLimit;
352     mapping (address => bool) public sendWhitelist;
353 
354     /**
355     * @notice In constructor, Set Send Limit exceptionally msg.sender.
356     * constructor is used, the restriction is activated.
357     */
358     constructor() public {
359         sendLimit = true;
360         sendWhitelist[msg.sender] = true;
361     }
362 
363     modifier isAllowedSend (address dsc) {
364         if (sendLimit) require(sendWhitelist[dsc], "SendLimiter/Not-Allow-Address");
365         _;
366     }
367 
368     /**
369     * @notice Register the address that you want to allow to be sent.
370     * @param _whiteAddress address The specify what to send target.
371     */
372     function addAllowSender(address _whiteAddress) public onlyOwner {
373         require(_whiteAddress != address(0), "SendLimiter/Not-Allow-Zero-Address");
374         sendWhitelist[_whiteAddress] = true;
375         emit SendWhitelisted(_whiteAddress);
376     }
377 
378     /**
379     * @notice Register the addresses that you want to allow to be sent.
380     * @param _whiteAddresses address[] The specify what to send target.
381     */
382     function addAllowSenders(address[] memory _whiteAddresses) public onlyOwner {
383         for (uint256 i = 0; i < _whiteAddresses.length; i++) {
384             addAllowSender(_whiteAddresses[i]);
385         }
386     }
387 
388     /**
389     * @notice Remove the address that you want to allow to be sent.
390     * @param _whiteAddress address The specify what to send target.
391     */
392     function removeAllowedSender(address _whiteAddress) public onlyOwner {
393         require(_whiteAddress != address(0), "SendLimiter/Not-Allow-Zero-Address");
394         delete sendWhitelist[_whiteAddress];
395         emit SendDelisted(_whiteAddress);
396     }
397 
398     /**
399     * @notice Remove the addresses that you want to allow to be sent.
400     * @param _whiteAddresses address[] The specify what to send target.
401     */
402     function removeAllowedSenders(address[] memory _whiteAddresses) public onlyOwner {
403         for (uint256 i = 0; i < _whiteAddresses.length; i++) {
404             removeAllowedSender(_whiteAddresses[i]);
405         }
406     }
407 
408     /**
409     * @notice Revoke transfer restrictions.
410     */
411     function sendUnlock() external onlyOwner {
412         sendLimit = false;
413         emit SendUnlocked();
414     }
415 }
416 
417 // File: contracts/Library/ReceiveLimiter.sol
418 
419 pragma solidity ^0.5.14;
420 
421 
422 /**
423  * @title ReceiveLimiter
424  * @author Yoonsung
425  * @notice This contract acts as an ERC20 extension. It must
426  * be called from the creator of the ERC20, and a modifier is
427  * provided that can be used together. This contract is short-lived.
428  * You cannot re-enable it after ReceiveUnlock, to be careful. Provides 
429  * a set of functions to manage the addresses that can be sent.
430  */
431 contract ReceiveLimiter is Ownable {
432     event ReceiveWhitelisted(address dsc);
433     event ReceiveDelisted(address dsc);
434     event ReceiveUnlocked();
435 
436     bool public receiveLimit;
437     mapping (address => bool) public receiveWhitelist;
438 
439     /**
440     * @notice In constructor, Set Receive Limit exceptionally msg.sender.
441     * constructor is used, the restriction is activated.
442     */
443     constructor() public {
444         receiveLimit = true;
445         receiveWhitelist[msg.sender] = true;
446     }
447 
448     modifier isAllowedReceive (address dsc) {
449         if (receiveLimit) require(receiveWhitelist[dsc], "Limiter/Not-Allow-Address");
450         _;
451     }
452 
453     /**
454     * @notice Register the address that you want to allow to be receive.
455     * @param _whiteAddress address The specify what to receive target.
456     */
457     function addAllowReceiver(address _whiteAddress) public onlyOwner {
458         require(_whiteAddress != address(0), "Limiter/Not-Allow-Zero-Address");
459         receiveWhitelist[_whiteAddress] = true;
460         emit ReceiveWhitelisted(_whiteAddress);
461     }
462 
463     /**
464     * @notice Register the addresses that you want to allow to be receive.
465     * @param _whiteAddresses address[] The specify what to receive target.
466     */
467     function addAllowReceivers(address[] memory _whiteAddresses) public onlyOwner {
468         for (uint256 i = 0; i < _whiteAddresses.length; i++) {
469             addAllowReceiver(_whiteAddresses[i]);
470         }
471     }
472 
473     /**
474     * @notice Remove the address that you want to allow to be receive.
475     * @param _whiteAddress address The specify what to receive target.
476     */
477     function removeAllowedReceiver(address _whiteAddress) public onlyOwner {
478         require(_whiteAddress != address(0), "Limiter/Not-Allow-Zero-Address");
479         delete receiveWhitelist[_whiteAddress];
480         emit ReceiveDelisted(_whiteAddress);
481     }
482 
483     /**
484     * @notice Remove the addresses that you want to allow to be receive.
485     * @param _whiteAddresses address[] The specify what to receive target.
486     */
487     function removeAllowedReceivers(address[] memory _whiteAddresses) public onlyOwner {
488         for (uint256 i = 0; i < _whiteAddresses.length; i++) {
489             removeAllowedReceiver(_whiteAddresses[i]);
490         }
491     }
492 
493     /**
494     * @notice Revoke Receive restrictions.
495     */
496     function receiveUnlock() external onlyOwner {
497         receiveLimit = false;
498         emit ReceiveUnlocked();
499     }
500 }
501 
502 // File: contracts/TokenAsset.sol
503 
504 pragma solidity ^0.5.14;
505 
506 
507 
508 
509 
510 
511 
512 /**
513  * @title TokenAsset
514  * @author Yoonsung
515  * @notice This Contract is an implementation of TokenAsset's ERC20
516  * Basic ERC20 functions and "Burn" functions are implemented. For the 
517  * Burn function, only the Owner of Contract can be called and used 
518  * to incinerate unsold Token. Transfer and reception limits are imposed
519  * after the contract is distributed and can be revoked through SendUnlock
520  * and ReceiveUnlock. Don't do active again after cancellation. The Owner 
521  * may also suspend the transfer of a particular account at any time.
522  */
523 contract TokenAsset is Ownable, IERC20, SendLimiter, ReceiveLimiter, Freezer {
524     using SafeMath for uint256;
525 
526     string public constant name = "tokenAsset";
527     string public constant symbol = "NTB";
528     uint8 public constant decimals = 18;
529     uint256 public totalSupply = 200000000e18;
530 
531     mapping (address => uint256) public balanceOf;
532     mapping (address => mapping(address => uint256)) public allowance;
533 
534     
535    /**
536     * @notice In constructor, Set Send Limit and Receive Limits.
537     * Additionally, Contract's publisher is authorized to own all tokens.
538     */
539     constructor() SendLimiter() ReceiveLimiter() public {
540         balanceOf[msg.sender] = totalSupply;
541     }
542 
543     /**
544     * @notice Transfer function sends Token to the target. However,
545     * caller must have more tokens than or equal to the quantity for send.
546     * @param _to address The specify what to send target.
547     * @param _value uint256 The amount of token to tranfer.
548     * @return True if the withdrawal succeeded, otherwise revert.
549     */
550     function transfer (
551         address _to,
552         uint256 _value
553     ) external isAllowedSend(msg.sender) isAllowedReceive(_to) isFreezed(msg.sender) returns (bool) {
554         require(_to != address(0), "TokenAsset/Not-Allow-Zero-Address");
555 
556         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
557         balanceOf[_to] = balanceOf[_to].add(_value);
558 
559         emit Transfer(msg.sender, _to, _value);
560 
561         return true;
562     }
563 
564     /**
565     * @notice Transfer function sends Token to the target.
566     * In most cases, the allowed caller uses this function. Send
567     * Token instead of owner. Allowance address must have more
568     * tokens than or equal to the quantity for send.
569     * @param _from address The acoount to sender.
570     * @param _to address The specify what to send target.
571     * @param _value uint256 The amount of token to tranfer.
572     * @return True if the withdrawal succeeded, otherwise revert.
573     */
574     function transferFrom (
575         address _from,
576         address _to,
577         uint256 _value
578     ) external isAllowedSend(_from) isAllowedReceive(_to) isFreezed(_from) returns (bool) {
579         require(_from != address(0), "TokenAsset/Not-Allow-Zero-Address");
580         require(_to != address(0), "TokenAsset/Not-Allow-Zero-Address");
581 
582         balanceOf[_from] = balanceOf[_from].sub(_value);
583         balanceOf[_to] = balanceOf[_to].add(_value);
584         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
585 
586         emit Transfer(_from, _to, _value);
587 
588         return true;
589     }
590 
591     /**
592     * @notice The Owner of the Contracts incinerate own
593     * Token. burn unsold Token and reduce totalsupply. Caller
594     * must have more tokens than or equal to the quantity for send.
595     * @param _value uint256 The amount of incinerate token.
596     * @return True if the withdrawal succeeded, otherwise revert.
597     */
598     function burn (
599         uint256 _value
600     ) external returns (bool) {
601         require(_value <= balanceOf[msg.sender]);
602 
603         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
604         totalSupply = totalSupply.sub(_value);
605 
606         emit Transfer(msg.sender, address(0), _value);
607         
608         return true;
609     }
610 
611     /**
612     * @notice Allow specific address to send token instead.
613     * @param _spender address The address to send transaction on my behalf
614     * @param _value uint256 The amount on my behalf, Usually 0 or uint256(-1).
615     * @return True if the withdrawal succeeded, otherwise revert.
616     */
617     function approve (
618         address _spender,
619         uint256 _value
620     ) external returns (bool) {
621         require(_spender != address(0), "TokenAsset/Not-Allow-Zero-Address");
622         allowance[msg.sender][_spender] = _value;
623         emit Approval(msg.sender, _spender, _value);
624 
625         return true;
626     }
627 }