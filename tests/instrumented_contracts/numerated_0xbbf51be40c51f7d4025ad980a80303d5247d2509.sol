1 // File: @openzeppelin/contracts/utils/ReentrancyGuard.sol
2 
3 pragma solidity ^0.5.0;
4 
5 /**
6  * @dev Contract module that helps prevent reentrant calls to a function.
7  *
8  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
9  * available, which can be applied to functions to make sure there are no nested
10  * (reentrant) calls to them.
11  *
12  * Note that because there is a single `nonReentrant` guard, functions marked as
13  * `nonReentrant` may not call one another. This can be worked around by making
14  * those functions `private`, and then adding `external` `nonReentrant` entry
15  * points to them.
16  */
17 contract ReentrancyGuard {
18     // counter to allow mutex lock with only one SSTORE operation
19     uint256 private _guardCounter;
20 
21     constructor () internal {
22         // The counter starts at one to prevent changing it from zero to a non-zero
23         // value, which is a more expensive operation.
24         _guardCounter = 1;
25     }
26 
27     /**
28      * @dev Prevents a contract from calling itself, directly or indirectly.
29      * Calling a `nonReentrant` function from another `nonReentrant`
30      * function is not supported. It is possible to prevent this from happening
31      * by making the `nonReentrant` function external, and make it call a
32      * `private` function that does the actual work.
33      */
34     modifier nonReentrant() {
35         _guardCounter += 1;
36         uint256 localCounter = _guardCounter;
37         _;
38         require(localCounter == _guardCounter, "ReentrancyGuard: reentrant call");
39     }
40 }
41 
42 // File: @openzeppelin/contracts/GSN/Context.sol
43 
44 pragma solidity ^0.5.0;
45 
46 /*
47  * @dev Provides information about the current execution context, including the
48  * sender of the transaction and its data. While these are generally available
49  * via msg.sender and msg.data, they should not be accessed in such a direct
50  * manner, since when dealing with GSN meta-transactions the account sending and
51  * paying for execution may not be the actual sender (as far as an application
52  * is concerned).
53  *
54  * This contract is only required for intermediate, library-like contracts.
55  */
56 contract Context {
57     // Empty internal constructor, to prevent people from mistakenly deploying
58     // an instance of this contract, which should be used via inheritance.
59     constructor () internal { }
60     // solhint-disable-previous-line no-empty-blocks
61 
62     function _msgSender() internal view returns (address payable) {
63         return msg.sender;
64     }
65 
66     function _msgData() internal view returns (bytes memory) {
67         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
68         return msg.data;
69     }
70 }
71 
72 // File: @openzeppelin/contracts/access/Roles.sol
73 
74 pragma solidity ^0.5.0;
75 
76 /**
77  * @title Roles
78  * @dev Library for managing addresses assigned to a Role.
79  */
80 library Roles {
81     struct Role {
82         mapping (address => bool) bearer;
83     }
84 
85     /**
86      * @dev Give an account access to this role.
87      */
88     function add(Role storage role, address account) internal {
89         require(!has(role, account), "Roles: account already has role");
90         role.bearer[account] = true;
91     }
92 
93     /**
94      * @dev Remove an account's access to this role.
95      */
96     function remove(Role storage role, address account) internal {
97         require(has(role, account), "Roles: account does not have role");
98         role.bearer[account] = false;
99     }
100 
101     /**
102      * @dev Check if an account has this role.
103      * @return bool
104      */
105     function has(Role storage role, address account) internal view returns (bool) {
106         require(account != address(0), "Roles: account is the zero address");
107         return role.bearer[account];
108     }
109 }
110 
111 // File: 0.5-contracts/normal_deployment/racing/RacingAdmins.sol
112 
113 pragma solidity ^0.5.8;
114 
115 
116 
117 contract RacingAdmins is Context {
118     using Roles for Roles.Role;
119 
120     event AdminAdded(address indexed account);
121     event AdminRemoved(address indexed account);
122 
123     Roles.Role private _admins;
124 
125     constructor () internal {
126         _addAdmin(_msgSender());
127     }
128 
129     modifier onlyAdmin() {
130         require(isAdmin(_msgSender()), "AdminRole: caller does not have the Admin role");
131         _;
132     }
133 
134     function isAdmin(address account) public view returns (bool) {
135         return _admins.has(account);
136     }
137 
138     function addAdmin(address account) public onlyAdmin {
139         _addAdmin(account);
140     }
141 
142     function renounceAdmin(address account) public onlyAdmin {
143         _removeAdmin(account);
144     }
145 
146     function _addAdmin(address account) internal {
147         _admins.add(account);
148         emit AdminAdded(account);
149     }
150 
151     function _removeAdmin(address account) internal {
152         _admins.remove(account);
153         emit AdminRemoved(account);
154     }
155 }
156 
157 // File: 0.5-contracts/normal_deployment/racing/RacingFeeReceiver.sol
158 
159 pragma solidity ^0.5.8;
160 
161 
162 contract RacingFeeReceiver is RacingAdmins {
163     address payable private _feeWallet;
164 
165     event FeeWalletTransferred(address indexed previousFeeWallet, address indexed newFeeWallet);
166 
167     /**
168      * @dev Returns the address of the current fee receiver.
169      */
170     function feeWallet() public view returns (address payable) {
171         return _feeWallet;
172     }
173 
174     /**
175      * @dev Throws if called by any account other than the fee receiver wallet.
176      */
177     modifier onlyFeeWallet() {
178         require(isFeeWallet(), "Ownable: caller is not the owner");
179         _;
180     }
181 
182     /**
183      * @dev Returns true if the caller is the current fee receiver wallet.
184      */
185     function isFeeWallet() public view returns (bool) {
186         return _msgSender() == _feeWallet;
187     }
188 
189     /**
190      * @dev Leaves the contract without fee receiver wallet.
191      *
192      * NOTE: Renouncing will leave the contract without an fee receiver wallet.
193      * It means that fee will be transferred to the zero address.
194      */
195     function renounceFeeWallet() public onlyAdmin {
196         emit FeeWalletTransferred(_feeWallet, address(0));
197         _feeWallet = address(0);
198     }
199 
200     /**
201      * @dev Transfers address of the fee receiver to a new address (`newFeeWallet`).
202      * Can only be called by admins.
203      */
204     function transferFeeWalletOwnership(address payable newFeeWallet) public onlyAdmin {
205         _transferFeeWalletOwnership(newFeeWallet);
206     }
207 
208     /**
209      * @dev Transfers address of the fee receiver to a new address (`newFeeWallet`).
210      */
211     function _transferFeeWalletOwnership(address payable newFeeWallet) internal {
212         require(newFeeWallet != address(0), "Ownable: new owner is the zero address");
213         emit FeeWalletTransferred(_feeWallet, newFeeWallet);
214         _feeWallet = newFeeWallet;
215     }
216 }
217 
218 // File: 0.5-contracts/normal_deployment/racing/RacingStorage.sol
219 
220 pragma solidity ^0.5.8;
221 
222 
223 
224 contract RacingStorage is RacingFeeReceiver, ReentrancyGuard {
225     // --
226     // Permanent Storage Variables
227     // --
228 
229     mapping(bytes32 => Race) public Races; // The race mapping structure.
230     mapping(uint256 => address) public Owner_Horse; // Owner of the Horse ID.
231     mapping(uint256 => uint256) public Horse_Active_Races; // Number of races the horse is registered for.
232     mapping(bytes32 => bool) public ID_Saved; // Returns whether or not the race ID is present on storage already.
233     mapping(uint256 => uint256) public Position_To_Payment; // Returns the percentage of the payment depending on horse's position in a race.
234     mapping(address => bool) public Is_Authorized; // Returns whether an address is authorized or not.
235     mapping(bytes32 => string) public Cancelled_Races; // Returns a cancelled race and its reason to be cancelled.
236     mapping(bytes32 => bool) public Has_Zed_Claimed; // Returns whether or not winnings for a race have been claimed for Zed.
237 
238     address BB; // Blockchain Brain
239     address Core; // Core contract.
240 
241     struct Race {
242         string Track_Name; // Name of the track or event.
243         bytes32 Race_ID; // Key provided for Race ID.
244         uint256 Length; // Length of the track (m).
245         uint256 Horses_Registered; // Current number of horses registered.
246         uint256 Unix_Start; // Timestamp the race starts.
247         uint256 Entrance_Fee; // Entrance fee for a particular race (10^18).
248         uint256 Prize_Pool; // Total bets in the prize pool (10^18).
249         uint256 Horses_Allowed; // Total number of horses allowed for a race.
250         uint256[] Horses; // List of Horse IDs on Race.
251         State Race_State; // Current state of the race.
252         mapping(uint256 => Horse) Lineup; // Mapping of the Horse ID => Horse struct.
253         mapping(uint256 => uint256) Gate_To_ID; // Mapping of the Gate # => Horse ID.
254         mapping(uint256 => bool) Is_Gate_Taken; // Whether or not a gate number has been taken.
255     }
256 
257     struct Horse {
258         uint256 Gate; // Gate this horse is currently at.
259         uint256 Total_Bet; // Total amount bet on this horse.
260         uint256 Final_Position; // Final position of the horse (1 to Horses allowed in race).
261         mapping(address => uint256) Bet_Placed; // Amount a specific address bet on this horse.
262         mapping(address => bool) Bet_Claimed; // Whether or not that specific address claimed their bet.
263     }
264 
265     enum State {Null, Registration, Betting, Final, Fail_Safe}
266 }
267 
268 // File: 0.5-contracts/normal_deployment/racing/proxy/Proxy.sol
269 
270 pragma solidity ^0.5.8;
271 
272 
273 /**
274  * @title Proxy
275  * @dev Implements delegation of calls to other contracts, with proper
276  * forwarding of return values and bubbling of failures.
277  * It defines a fallback function that delegates all calls to the address
278  * returned by the abstract _implementation() internal function.
279  */
280 contract Proxy is RacingStorage {
281 	/**
282 	 * @dev Fallback function.
283 	 * Implemented entirely in `_fallback`.
284 	 */
285 	function () payable external {
286 		_fallback();
287 	}
288 
289 	/**
290 	 * @dev fallback implementation.
291 	 * Extracted to enable manual triggering.
292 	 */
293 	function _fallback() internal {
294 		_willFallback();
295 		_delegate(_implementation());
296 	}
297 
298 	/**
299 	 * @dev Function that is run as the first thing in the fallback function.
300 	 * Can be redefined in derived contracts to add functionality.
301 	 * Redefinitions must call super._willFallback().
302 	 */
303 	function _willFallback() internal {}
304 
305 	/**
306 	 * @dev Delegates execution to an implementation contract.
307 	 * This is a low level function that doesn't return to its internal call site.
308 	 * It will return to the external caller whatever the implementation returns.
309 	 * @param implementation Address to delegate.
310 	 */
311 	function _delegate(address implementation) internal {
312 		assembly {
313 			// Copy msg.data. We take full control of memory in this inline assembly
314 			// block because it will not return to Solidity code. We overwrite the
315 			// Solidity scratch pad at memory position 0.
316 			calldatacopy(0, 0, calldatasize)
317 
318 			// Call the implementation.
319 			// out and outsize are 0 because we don't know the size yet.
320 			let result := delegatecall(gas, implementation, 0, calldatasize, 0, 0)
321 
322 			// Copy the returned data.
323 			returndatacopy(0, 0, returndatasize)
324 
325 			switch result
326 			// delegatecall returns 0 on error.
327 			case 0 { revert(0, returndatasize) }
328 			default { return(0, returndatasize) }
329 		}
330   	}
331 
332 	/**
333 	 * @return The Address of the implementation.
334 	 */
335 	function _implementation() internal view returns (address);
336 }
337 
338 // File: @openzeppelin/contracts/utils/Address.sol
339 
340 pragma solidity ^0.5.5;
341 
342 /**
343  * @dev Collection of functions related to the address type
344  */
345 library Address {
346     /**
347      * @dev Returns true if `account` is a contract.
348      *
349      * This test is non-exhaustive, and there may be false-negatives: during the
350      * execution of a contract's constructor, its address will be reported as
351      * not containing a contract.
352      *
353      * IMPORTANT: It is unsafe to assume that an address for which this
354      * function returns false is an externally-owned account (EOA) and not a
355      * contract.
356      */
357     function isContract(address account) internal view returns (bool) {
358         // This method relies in extcodesize, which returns 0 for contracts in
359         // construction, since the code is only stored at the end of the
360         // constructor execution.
361 
362         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
363         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
364         // for accounts without code, i.e. `keccak256('')`
365         bytes32 codehash;
366         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
367         // solhint-disable-next-line no-inline-assembly
368         assembly { codehash := extcodehash(account) }
369         return (codehash != 0x0 && codehash != accountHash);
370     }
371 
372     /**
373      * @dev Converts an `address` into `address payable`. Note that this is
374      * simply a type cast: the actual underlying value is not changed.
375      *
376      * _Available since v2.4.0._
377      */
378     function toPayable(address account) internal pure returns (address payable) {
379         return address(uint160(account));
380     }
381 
382     /**
383      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
384      * `recipient`, forwarding all available gas and reverting on errors.
385      *
386      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
387      * of certain opcodes, possibly making contracts go over the 2300 gas limit
388      * imposed by `transfer`, making them unable to receive funds via
389      * `transfer`. {sendValue} removes this limitation.
390      *
391      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
392      *
393      * IMPORTANT: because control is transferred to `recipient`, care must be
394      * taken to not create reentrancy vulnerabilities. Consider using
395      * {ReentrancyGuard} or the
396      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
397      *
398      * _Available since v2.4.0._
399      */
400     function sendValue(address payable recipient, uint256 amount) internal {
401         require(address(this).balance >= amount, "Address: insufficient balance");
402 
403         // solhint-disable-next-line avoid-call-value
404         (bool success, ) = recipient.call.value(amount)("");
405         require(success, "Address: unable to send value, recipient may have reverted");
406     }
407 }
408 
409 // File: 0.5-contracts/normal_deployment/racing/proxy/BaseUpgradeabilityProxy.sol
410 
411 pragma solidity ^0.5.8;
412 
413 
414 
415 
416 /**
417  * @title BaseUpgradeabilityProxy
418  * @dev This contract implements a proxy that allows to change the
419  * implementation address to which it will delegate.
420  * Such a change is called an implementation upgrade.
421  */
422 contract BaseUpgradeabilityProxy is Proxy {
423 	using Address for address;
424 
425 	/**
426 	 * @dev The version of current(active) logic contract
427 	 */
428     string internal _version;
429 
430 	/**
431 	 * @dev Storage slot with the address of the current implementation.
432 	 * This is the keccak-256 hash of "org.zeppelinos.proxy.implementation", and is
433 	 * validated in the constructor.
434 	 */
435 	bytes32 internal constant IMPLEMENTATION_SLOT = 0x7050c9e0f4ca769c69bd3a8ef740bc37934f8e2c036e5a723fd8ee048ed3f8c3;
436 
437 	/**
438 	 * @dev Emitted when the implementation is upgraded.
439 	 * @param implementation Address of the new implementation.
440 	 */
441 	event Upgraded(address indexed implementation);
442 
443 	/**
444 	 * @dev Returns the current implementation.
445 	 * @return Address of the current implementation
446 	 */
447 	function _implementation() internal view returns (address impl) {
448 		bytes32 slot = IMPLEMENTATION_SLOT;
449 		assembly {
450 		    impl := sload(slot)
451 		}
452 	}
453 
454 	/**
455 	 * @dev Upgrades the proxy to a new implementation.
456 	 * @param newImplementation Address of the new implementation.
457 	 * @param newVersion of proxied contract.
458 	 */
459 	function _upgradeProxyTo(address newImplementation, string memory newVersion) internal {
460 		_setProxyImplementation(newImplementation, newVersion);
461 
462 		emit Upgraded(newImplementation);
463 	}
464 
465 	/**
466 	 * @dev Sets the implementation address of the proxy.
467 	 * @param newImplementation Address of the new implementation.
468 	 * @param newVersion of proxied contract.
469 	 */
470 	function _setProxyImplementation(address newImplementation, string memory newVersion) internal {
471 		require(newImplementation.isContract(), "Cannot set a proxy implementation to a non-contract address");
472 
473  		_version = newVersion;
474 
475 		bytes32 slot = IMPLEMENTATION_SLOT;
476 
477 		assembly {
478 		    sstore(slot, newImplementation)
479 		}
480 	}
481 }
482 
483 // File: 0.5-contracts/normal_deployment/racing/proxy/UpgradeabilityProxy.sol
484 
485 pragma solidity ^0.5.8;
486 
487 
488 /**
489  * @title UpgradeabilityProxy
490  * @dev Extends BaseUpgradeabilityProxy with a constructor for initializing
491  * implementation and init data.
492  */
493 contract UpgradeabilityProxy is BaseUpgradeabilityProxy {
494 	/**
495 	 * @dev Contract constructor.
496 	 * @param _logic Address of the initial implementation.
497 	 */
498 	constructor(address _logic) public payable {
499 		assert(IMPLEMENTATION_SLOT == keccak256("org.zeppelinos.proxy.implementation"));
500 		_setProxyImplementation(_logic, "1.0.0");
501 	}
502 }
503 
504 // File: 0.5-contracts/normal_deployment/racing/proxy/BaseAdminUpgradeabilityProxy.sol
505 
506 pragma solidity ^0.5.8;
507 
508 
509 /**
510  * @title BaseAdminUpgradeabilityProxy
511  * @dev This contract combines an upgradeability proxy with an authorization
512  * mechanism for administrative tasks.
513  * All external functions in this contract must be guarded by the
514  * `ifProxyAdmin` modifier. See ethereum/solidity#3864 for a Solidity
515  * feature proposal that would enable this to be done automatically.
516  */
517 contract BaseAdminUpgradeabilityProxy is BaseUpgradeabilityProxy {
518 	/**
519 	 * @dev Emitted when the administration has been transferred.
520 	 * @param previousAdmin Address of the previous admin.
521 	 * @param newProxyAdmin Address of the new admin.
522 	 */
523 	event ProxyAdminChanged(address previousAdmin, address newProxyAdmin);
524 
525 	/**
526 	 * @dev Storage slot with the admin of the contract.
527 	 * This is the keccak-256 hash of "org.zeppelinos.proxy.admin", and is
528 	 * validated in the constructor.
529 	 */
530   	bytes32 internal constant ADMIN_SLOT = 0x10d6a54a4754c8869d6886b5f5d7fbfa5b4522237ea5c60d11bc4e7a1ff9390b;
531 
532   	/**
533 	 * @dev Modifier to check whether the `msg.sender` is the admin.
534 	 * If it is, it will run the function. Otherwise, it will delegate the call
535 	 * to the implementation.
536 	 */
537 	modifier ifProxyAdmin() {
538 		if (msg.sender == _proxyAdmin()) {
539 		    _;
540 		} else {
541 		    _fallback();
542 		}
543 	}
544 
545 	/**
546 	 * @return The address of the proxy admin.
547 	 */
548 	function proxyAdmin() external view returns (address) {
549 		return _proxyAdmin();
550 	}
551 
552 	/**
553 	 * @return The version of logic contract
554 	 */
555 	function proxyVersion() external view returns (string memory) {
556 		return _version;
557 	}
558 
559 	/**
560 	 * @return The address of the implementation.
561 	 */
562 	function proxyImplementation() external view returns (address) {
563 		return _implementation();
564 	}
565 
566 	/**
567 	 * @dev Changes the admin of the proxy.
568 	 * Only the current admin can call this function.
569 	 * @param newProxyAdmin Address to transfer proxy administration to.
570 	 */
571 	function changeProxyAdmin(address newProxyAdmin) external ifProxyAdmin {
572 		require(newProxyAdmin != address(0), "Cannot change the admin of a proxy to the zero address");
573 		emit ProxyAdminChanged(_proxyAdmin(), newProxyAdmin);
574 		_setProxyAdmin(newProxyAdmin);
575 	}
576 
577 	/**
578 	 * @dev Upgrade the backing implementation of the proxy.
579 	 * Only the admin can call this function.
580 	 * @param newImplementation Address of the new implementation.
581 	 * @param newVersion of proxied contract.
582 	 */
583 	function upgradeProxyTo(address newImplementation, string calldata newVersion) external ifProxyAdmin {
584 		_upgradeProxyTo(newImplementation, newVersion);
585 	}
586 
587 	/**
588 	 * @dev Upgrade the backing implementation of the proxy and call a function
589 	 * on the new implementation.
590 	 * This is useful to initialize the proxied contract.
591 	 * @param newImplementation Address of the new implementation.
592 	 * @param newVersion of proxied contract.
593 	 * @param data Data to send as msg.data in the low level call.
594 	 * It should include the signature and the parameters of the function to be called, as described in
595 	 * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
596 	 */
597 	function upgradeProxyToAndCall(address newImplementation, string calldata newVersion, bytes calldata data) payable external ifProxyAdmin {
598 		_upgradeProxyTo(newImplementation, newVersion);
599 		(bool success,) = newImplementation.delegatecall(data);
600 		require(success);
601 	}
602 
603 	/**
604 	 * @return The admin slot.
605 	 */
606 	function _proxyAdmin() internal view returns (address adm) {
607 		bytes32 slot = ADMIN_SLOT;
608 		assembly {
609     		adm := sload(slot)
610 		}
611 	}
612 
613 	/**
614 	 * @dev Sets the address of the proxy admin.
615 	 * @param newProxyAdmin Address of the new proxy admin.
616 	 */
617 	function _setProxyAdmin(address newProxyAdmin) internal {
618 		bytes32 slot = ADMIN_SLOT;
619 
620 		assembly {
621 			sstore(slot, newProxyAdmin)
622 		}
623 	}
624 
625 	/**
626 	 * @dev Only fall back when the sender is not the admin.
627 	 */
628 	function _willFallback() internal {
629 		require(msg.sender != _proxyAdmin(), "Cannot call fallback function from the proxy admin");
630 		super._willFallback();
631 	}
632 }
633 
634 // File: 0.5-contracts/normal_deployment/racing/RacingProxy.sol
635 
636 pragma solidity ^0.5.8;
637 
638 
639 
640 /**
641  * @title RacingProxy
642  * @dev Extends from BaseAdminUpgradeabilityProxy with a constructor for
643  * initializing the implementation, admin, and init data.
644  */
645 contract RacingProxy is BaseAdminUpgradeabilityProxy, UpgradeabilityProxy {
646 	/**
647 	 * Contract constructor.
648 	 * @param _logic address of the initial implementation.
649 	 * @param _admin Address of the proxy administrator.
650 	 */
651 	constructor(address _logic, address _admin) UpgradeabilityProxy(_logic) public payable {
652 		assert(ADMIN_SLOT == keccak256("org.zeppelinos.proxy.admin"));
653 		_setProxyAdmin(_admin);
654 	}
655 }