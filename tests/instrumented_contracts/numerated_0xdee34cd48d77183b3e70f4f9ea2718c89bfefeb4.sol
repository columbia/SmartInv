1 pragma solidity ^0.5.2;
2 
3 // File: contracts/lib/github.com/OpenZeppelin/openzeppelin-solidity-2.1.2/contracts/ownership/Ownable.sol
4 
5 /**
6  * @title Ownable
7  * @dev The Ownable contract has an owner address, and provides basic authorization control
8  * functions, this simplifies the implementation of "user permissions".
9  */
10 contract Ownable {
11     address private _owner;
12 
13     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
14 
15     /**
16      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
17      * account.
18      */
19     constructor () internal {
20         _owner = msg.sender;
21         emit OwnershipTransferred(address(0), _owner);
22     }
23 
24     /**
25      * @return the address of the owner.
26      */
27     function owner() public view returns (address) {
28         return _owner;
29     }
30 
31     /**
32      * @dev Throws if called by any account other than the owner.
33      */
34     modifier onlyOwner() {
35         require(isOwner());
36         _;
37     }
38 
39     /**
40      * @return true if `msg.sender` is the owner of the contract.
41      */
42     function isOwner() public view returns (bool) {
43         return msg.sender == _owner;
44     }
45 
46     /**
47      * @dev Allows the current owner to relinquish control of the contract.
48      * @notice Renouncing to ownership will leave the contract without an owner.
49      * It will not be possible to call the functions with the `onlyOwner`
50      * modifier anymore.
51      */
52     function renounceOwnership() public onlyOwner {
53         emit OwnershipTransferred(_owner, address(0));
54         _owner = address(0);
55     }
56 
57     /**
58      * @dev Allows the current owner to transfer control of the contract to a newOwner.
59      * @param newOwner The address to transfer ownership to.
60      */
61     function transferOwnership(address newOwner) public onlyOwner {
62         _transferOwnership(newOwner);
63     }
64 
65     /**
66      * @dev Transfers control of the contract to a newOwner.
67      * @param newOwner The address to transfer ownership to.
68      */
69     function _transferOwnership(address newOwner) internal {
70         require(newOwner != address(0));
71         emit OwnershipTransferred(_owner, newOwner);
72         _owner = newOwner;
73     }
74 }
75 
76 // File: contracts/lib/github.com/OpenZeppelin/openzeppelin-solidity-2.1.2/contracts/token/ERC20/IERC20.sol
77 
78 /**
79  * @title ERC20 interface
80  * @dev see https://github.com/ethereum/EIPs/issues/20
81  */
82 interface IERC20 {
83     function transfer(address to, uint256 value) external returns (bool);
84 
85     function approve(address spender, uint256 value) external returns (bool);
86 
87     function transferFrom(address from, address to, uint256 value) external returns (bool);
88 
89     function totalSupply() external view returns (uint256);
90 
91     function balanceOf(address who) external view returns (uint256);
92 
93     function allowance(address owner, address spender) external view returns (uint256);
94 
95     event Transfer(address indexed from, address indexed to, uint256 value);
96 
97     event Approval(address indexed owner, address indexed spender, uint256 value);
98 }
99 
100 // File: contracts/lib/github.com/contract-library/contract-library-0.0.4/contracts/ownership/Withdrawable.sol
101 
102 contract Withdrawable is Ownable {
103   function withdrawEther() external onlyOwner {
104     msg.sender.transfer(address(this).balance);
105   }
106 
107   function withdrawToken(IERC20 _token) external onlyOwner {
108     require(_token.transfer(msg.sender, _token.balanceOf(address(this))));
109   }
110 }
111 
112 // File: contracts/lib/github.com/OpenZeppelin/openzeppelin-solidity-2.1.2/contracts/access/Roles.sol
113 
114 /**
115  * @title Roles
116  * @dev Library for managing addresses assigned to a Role.
117  */
118 library Roles {
119     struct Role {
120         mapping (address => bool) bearer;
121     }
122 
123     /**
124      * @dev give an account access to this role
125      */
126     function add(Role storage role, address account) internal {
127         require(account != address(0));
128         require(!has(role, account));
129 
130         role.bearer[account] = true;
131     }
132 
133     /**
134      * @dev remove an account's access to this role
135      */
136     function remove(Role storage role, address account) internal {
137         require(account != address(0));
138         require(has(role, account));
139 
140         role.bearer[account] = false;
141     }
142 
143     /**
144      * @dev check if an account has this role
145      * @return bool
146      */
147     function has(Role storage role, address account) internal view returns (bool) {
148         require(account != address(0));
149         return role.bearer[account];
150     }
151 }
152 
153 // File: contracts/lib/github.com/OpenZeppelin/openzeppelin-solidity-2.1.2/contracts/access/roles/PauserRole.sol
154 
155 contract PauserRole {
156     using Roles for Roles.Role;
157 
158     event PauserAdded(address indexed account);
159     event PauserRemoved(address indexed account);
160 
161     Roles.Role private _pausers;
162 
163     constructor () internal {
164         _addPauser(msg.sender);
165     }
166 
167     modifier onlyPauser() {
168         require(isPauser(msg.sender));
169         _;
170     }
171 
172     function isPauser(address account) public view returns (bool) {
173         return _pausers.has(account);
174     }
175 
176     function addPauser(address account) public onlyPauser {
177         _addPauser(account);
178     }
179 
180     function renouncePauser() public {
181         _removePauser(msg.sender);
182     }
183 
184     function _addPauser(address account) internal {
185         _pausers.add(account);
186         emit PauserAdded(account);
187     }
188 
189     function _removePauser(address account) internal {
190         _pausers.remove(account);
191         emit PauserRemoved(account);
192     }
193 }
194 
195 // File: contracts/lib/github.com/OpenZeppelin/openzeppelin-solidity-2.1.2/contracts/lifecycle/Pausable.sol
196 
197 /**
198  * @title Pausable
199  * @dev Base contract which allows children to implement an emergency stop mechanism.
200  */
201 contract Pausable is PauserRole {
202     event Paused(address account);
203     event Unpaused(address account);
204 
205     bool private _paused;
206 
207     constructor () internal {
208         _paused = false;
209     }
210 
211     /**
212      * @return true if the contract is paused, false otherwise.
213      */
214     function paused() public view returns (bool) {
215         return _paused;
216     }
217 
218     /**
219      * @dev Modifier to make a function callable only when the contract is not paused.
220      */
221     modifier whenNotPaused() {
222         require(!_paused);
223         _;
224     }
225 
226     /**
227      * @dev Modifier to make a function callable only when the contract is paused.
228      */
229     modifier whenPaused() {
230         require(_paused);
231         _;
232     }
233 
234     /**
235      * @dev called by the owner to pause, triggers stopped state
236      */
237     function pause() public onlyPauser whenNotPaused {
238         _paused = true;
239         emit Paused(msg.sender);
240     }
241 
242     /**
243      * @dev called by the owner to unpause, returns to normal state
244      */
245     function unpause() public onlyPauser whenPaused {
246         _paused = false;
247         emit Unpaused(msg.sender);
248     }
249 }
250 
251 // File: contracts/lib/github.com/OpenZeppelin/openzeppelin-solidity-2.1.2/contracts/math/SafeMath.sol
252 
253 /**
254  * @title SafeMath
255  * @dev Unsigned math operations with safety checks that revert on error
256  */
257 library SafeMath {
258     /**
259     * @dev Multiplies two unsigned integers, reverts on overflow.
260     */
261     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
262         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
263         // benefit is lost if 'b' is also tested.
264         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
265         if (a == 0) {
266             return 0;
267         }
268 
269         uint256 c = a * b;
270         require(c / a == b);
271 
272         return c;
273     }
274 
275     /**
276     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
277     */
278     function div(uint256 a, uint256 b) internal pure returns (uint256) {
279         // Solidity only automatically asserts when dividing by 0
280         require(b > 0);
281         uint256 c = a / b;
282         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
283 
284         return c;
285     }
286 
287     /**
288     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
289     */
290     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
291         require(b <= a);
292         uint256 c = a - b;
293 
294         return c;
295     }
296 
297     /**
298     * @dev Adds two unsigned integers, reverts on overflow.
299     */
300     function add(uint256 a, uint256 b) internal pure returns (uint256) {
301         uint256 c = a + b;
302         require(c >= a);
303 
304         return c;
305     }
306 
307     /**
308     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
309     * reverts when dividing by zero.
310     */
311     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
312         require(b != 0);
313         return a % b;
314     }
315 }
316 
317 // File: contracts/lib/github.com/OpenZeppelin/openzeppelin-solidity-2.1.2/contracts/utils/ReentrancyGuard.sol
318 
319 /**
320  * @title Helps contracts guard against reentrancy attacks.
321  * @author Remco Bloemen <remco@2π.com>, Eenae <alexey@mixbytes.io>
322  * @dev If you mark a function `nonReentrant`, you should also
323  * mark it `external`.
324  */
325 contract ReentrancyGuard {
326     /// @dev counter to allow mutex lock with only one SSTORE operation
327     uint256 private _guardCounter;
328 
329     constructor () internal {
330         // The counter starts at one to prevent changing it from zero to a non-zero
331         // value, which is a more expensive operation.
332         _guardCounter = 1;
333     }
334 
335     /**
336      * @dev Prevents a contract from calling itself, directly or indirectly.
337      * Calling a `nonReentrant` function from another `nonReentrant`
338      * function is not supported. It is possible to prevent this from happening
339      * by making the `nonReentrant` function external, and make it call a
340      * `private` function that does the actual work.
341      */
342     modifier nonReentrant() {
343         _guardCounter += 1;
344         uint256 localCounter = _guardCounter;
345         _;
346         require(localCounter == _guardCounter);
347     }
348 }
349 
350 // File: contracts/lib/github.com/contract-library/contract-library-0.0.4/contracts/DJTBase.sol
351 
352 contract DJTBase is Withdrawable, Pausable, ReentrancyGuard {
353     using SafeMath for uint256;
354 }
355 
356 // File: contracts/lib/github.com/contract-library/contract-library-0.0.4/contracts/access/roles/OperatorRole.sol
357 
358 contract OperatorRole {
359     using Roles for Roles.Role;
360 
361     event OperatorAdded(address indexed account);
362     event OperatorRemoved(address indexed account);
363 
364     Roles.Role private operators;
365 
366     constructor() public {
367         operators.add(msg.sender);
368     }
369 
370     modifier onlyOperator() {
371         require(isOperator(msg.sender));
372         _;
373     }
374     
375     function isOperator(address account) public view returns (bool) {
376         return operators.has(account);
377     }
378 
379     function addOperator(address account) public onlyOperator() {
380         operators.add(account);
381         emit OperatorAdded(account);
382     }
383 
384     function removeOperator(address account) public onlyOperator() {
385         operators.remove(account);
386         emit OperatorRemoved(account);
387     }
388 
389 }
390 
391 // File: contracts/lib/github.com/OpenZeppelin/openzeppelin-solidity-2.1.2/contracts/cryptography/ECDSA.sol
392 
393 /**
394  * @title Elliptic curve signature operations
395  * @dev Based on https://gist.github.com/axic/5b33912c6f61ae6fd96d6c4a47afde6d
396  * TODO Remove this library once solidity supports passing a signature to ecrecover.
397  * See https://github.com/ethereum/solidity/issues/864
398  */
399 
400 library ECDSA {
401     /**
402      * @dev Recover signer address from a message by using their signature
403      * @param hash bytes32 message, the hash is the signed message. What is recovered is the signer address.
404      * @param signature bytes signature, the signature is generated using web3.eth.sign()
405      */
406     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
407         bytes32 r;
408         bytes32 s;
409         uint8 v;
410 
411         // Check the signature length
412         if (signature.length != 65) {
413             return (address(0));
414         }
415 
416         // Divide the signature in r, s and v variables
417         // ecrecover takes the signature parameters, and the only way to get them
418         // currently is to use assembly.
419         // solhint-disable-next-line no-inline-assembly
420         assembly {
421             r := mload(add(signature, 0x20))
422             s := mload(add(signature, 0x40))
423             v := byte(0, mload(add(signature, 0x60)))
424         }
425 
426         // Version of signature should be 27 or 28, but 0 and 1 are also possible versions
427         if (v < 27) {
428             v += 27;
429         }
430 
431         // If the version is correct return the signer address
432         if (v != 27 && v != 28) {
433             return (address(0));
434         } else {
435             return ecrecover(hash, v, r, s);
436         }
437     }
438 
439     /**
440      * toEthSignedMessageHash
441      * @dev prefix a bytes32 value with "\x19Ethereum Signed Message:"
442      * and hash the result
443      */
444     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
445         // 32 is the length in bytes of hash,
446         // enforced by the type signature above
447         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
448     }
449 }
450 
451 // File: contracts/MCHPrime.sol
452 
453 contract MCHPrime is OperatorRole, DJTBase {
454 
455 
456 	uint128 public primeFee;
457 	uint256 public primeTerm;
458 	uint256 public allowedUpdateBuffer;
459 	mapping(address => uint256) public addressToExpiredAt;
460 
461 	address public validater;
462   
463 	event PrimeFeeUpdated(
464 		uint128 PrimeFeeUpdated
465 	);
466 
467 	event PrimeTermAdded(
468 		address user,
469 		uint256 expiredAt,
470 		uint256 at
471 	);
472 
473 	event PrimeTermUpdated(
474 		uint256 primeTerm
475 	);
476 
477 	event AllowedUpdateBufferUpdated(
478 		uint256 allowedUpdateBuffer
479 	);
480 
481 	event ExpiredAtUpdated(
482 		address user,
483 		uint256 expiredAt,
484 		uint256 at
485 	);
486 
487 	constructor() public {
488 		primeFee = 0.1 ether;
489 		primeTerm = 30 days;
490 		allowedUpdateBuffer = 5 days;
491 	}
492 
493 	function setValidater(address _varidater) external onlyOwner() {
494 		validater = _varidater;
495 	}
496 
497 	function updatePrimeFee(uint128 _newPrimeFee) external onlyOwner() {
498 		primeFee = _newPrimeFee;
499 		emit PrimeFeeUpdated(
500 			primeFee
501 		);
502 	}
503 
504 	function updatePrimeTerm(uint256 _newPrimeTerm) external onlyOwner() {
505 		primeTerm = _newPrimeTerm;
506 		emit PrimeTermUpdated(
507 			primeTerm
508 		);
509 	}
510 
511 	function updateAllowedUpdateBuffer(uint256 _newAllowedUpdateBuffer) external onlyOwner() {
512 		allowedUpdateBuffer = _newAllowedUpdateBuffer;
513 		emit AllowedUpdateBufferUpdated(
514 			allowedUpdateBuffer
515 		);
516 	}
517 
518 	function updateExpiredAt(address _user, uint256 _expiredAt) external onlyOperator() {
519 		addressToExpiredAt[_user] = _expiredAt;
520 		emit ExpiredAtUpdated(
521 			_user,
522 			_expiredAt,
523 			block.timestamp
524 		);
525 	}
526 
527 	function buyPrimeRights(bytes calldata _signature) external whenNotPaused() payable {
528 		require(msg.value == primeFee, "not enough eth");
529 		require(canUpdateNow(msg.sender), "unable to update");
530 		require(validateSig(_signature, bytes32(uint256(msg.sender))), "invalid signature");
531 
532 		uint256 _now = block.timestamp;
533 		uint256 expiredAt = addressToExpiredAt[msg.sender];
534 		if (expiredAt <= _now) {
535 			addressToExpiredAt[msg.sender] = _now.add(primeTerm);
536 		} else if(expiredAt <= _now.add(allowedUpdateBuffer)) {
537 			addressToExpiredAt[msg.sender] = expiredAt.add(primeTerm);
538 		}
539 
540 		emit PrimeTermAdded(
541 			msg.sender,
542 			addressToExpiredAt[msg.sender],
543 			_now
544 		);
545 	}
546 
547 	function canUpdateNow(address _user) public view returns (bool) {
548 		uint256 _now = block.timestamp;
549 		uint256 expiredAt = addressToExpiredAt[_user];
550 		// expired user or new user
551 		if (expiredAt <= _now) {
552 			return true;
553 		}
554 		// user who are able to extend their PrimeTerm
555 		if (expiredAt <= _now.add(allowedUpdateBuffer)) {
556 			return true;
557 		}
558 		return false;
559 	}
560 
561 	function validateSig(bytes memory _signature, bytes32 _message) private view returns (bool) {
562 		require(validater != address(0));
563 		address signer = ECDSA.recover(ECDSA.toEthSignedMessageHash(_message), _signature);
564 		return (signer == validater);
565 	}
566 
567 }