1 // File: @openzeppelin/contracts-ethereum-package/contracts/token/ERC20/IERC20.sol
2 
3 pragma solidity ^0.5.0;
4 
5 /**
6  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
7  * the optional functions; to access them see {ERC20Detailed}.
8  */
9 interface IERC20 {
10     /**
11      * @dev Returns the amount of tokens in existence.
12      */
13     function totalSupply() external view returns (uint256);
14 
15     /**
16      * @dev Returns the amount of tokens owned by `account`.
17      */
18     function balanceOf(address account) external view returns (uint256);
19 
20     /**
21      * @dev Moves `amount` tokens from the caller's account to `recipient`.
22      *
23      * Returns a boolean value indicating whether the operation succeeded.
24      *
25      * Emits a {Transfer} event.
26      */
27     function transfer(address recipient, uint256 amount) external returns (bool);
28 
29     /**
30      * @dev Returns the remaining number of tokens that `spender` will be
31      * allowed to spend on behalf of `owner` through {transferFrom}. This is
32      * zero by default.
33      *
34      * This value changes when {approve} or {transferFrom} are called.
35      */
36     function allowance(address owner, address spender) external view returns (uint256);
37 
38     /**
39      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
40      *
41      * Returns a boolean value indicating whether the operation succeeded.
42      *
43      * IMPORTANT: Beware that changing an allowance with this method brings the risk
44      * that someone may use both the old and the new allowance by unfortunate
45      * transaction ordering. One possible solution to mitigate this race
46      * condition is to first reduce the spender's allowance to 0 and set the
47      * desired value afterwards:
48      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
49      *
50      * Emits an {Approval} event.
51      */
52     function approve(address spender, uint256 amount) external returns (bool);
53 
54     /**
55      * @dev Moves `amount` tokens from `sender` to `recipient` using the
56      * allowance mechanism. `amount` is then deducted from the caller's
57      * allowance.
58      *
59      * Returns a boolean value indicating whether the operation succeeded.
60      *
61      * Emits a {Transfer} event.
62      */
63     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
64 
65     /**
66      * @dev Emitted when `value` tokens are moved from one account (`from`) to
67      * another (`to`).
68      *
69      * Note that `value` may be zero.
70      */
71     event Transfer(address indexed from, address indexed to, uint256 value);
72 
73     /**
74      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
75      * a call to {approve}. `value` is the new allowance.
76      */
77     event Approval(address indexed owner, address indexed spender, uint256 value);
78 }
79 
80 // File: @openzeppelin/upgrades/contracts/Initializable.sol
81 
82 pragma solidity >=0.4.24 <0.7.0;
83 
84 
85 /**
86  * @title Initializable
87  *
88  * @dev Helper contract to support initializer functions. To use it, replace
89  * the constructor with a function that has the `initializer` modifier.
90  * WARNING: Unlike constructors, initializer functions must be manually
91  * invoked. This applies both to deploying an Initializable contract, as well
92  * as extending an Initializable contract via inheritance.
93  * WARNING: When used with inheritance, manual care must be taken to not invoke
94  * a parent initializer twice, or ensure that all initializers are idempotent,
95  * because this is not dealt with automatically as with constructors.
96  */
97 contract Initializable {
98 
99   /**
100    * @dev Indicates that the contract has been initialized.
101    */
102   bool private initialized;
103 
104   /**
105    * @dev Indicates that the contract is in the process of being initialized.
106    */
107   bool private initializing;
108 
109   /**
110    * @dev Modifier to use in the initializer function of a contract.
111    */
112   modifier initializer() {
113     require(initializing || isConstructor() || !initialized, "Contract instance has already been initialized");
114 
115     bool isTopLevelCall = !initializing;
116     if (isTopLevelCall) {
117       initializing = true;
118       initialized = true;
119     }
120 
121     _;
122 
123     if (isTopLevelCall) {
124       initializing = false;
125     }
126   }
127 
128   /// @dev Returns true if and only if the function is running in the constructor
129   function isConstructor() private view returns (bool) {
130     // extcodesize checks the size of the code stored in an address, and
131     // address returns the current address. Since the code is still not
132     // deployed when running a constructor, any checks on its code size will
133     // yield zero, making it an effective way to detect if a contract is
134     // under construction or not.
135     address self = address(this);
136     uint256 cs;
137     assembly { cs := extcodesize(self) }
138     return cs == 0;
139   }
140 
141   // Reserved storage space to allow for layout changes in the future.
142   uint256[50] private ______gap;
143 }
144 
145 // File: @openzeppelin/contracts-ethereum-package/contracts/GSN/Context.sol
146 
147 pragma solidity ^0.5.0;
148 
149 
150 /*
151  * @dev Provides information about the current execution context, including the
152  * sender of the transaction and its data. While these are generally available
153  * via msg.sender and msg.data, they should not be accessed in such a direct
154  * manner, since when dealing with GSN meta-transactions the account sending and
155  * paying for execution may not be the actual sender (as far as an application
156  * is concerned).
157  *
158  * This contract is only required for intermediate, library-like contracts.
159  */
160 contract Context is Initializable {
161     // Empty internal constructor, to prevent people from mistakenly deploying
162     // an instance of this contract, which should be used via inheritance.
163     constructor () internal { }
164     // solhint-disable-previous-line no-empty-blocks
165 
166     function _msgSender() internal view returns (address payable) {
167         return msg.sender;
168     }
169 
170     function _msgData() internal view returns (bytes memory) {
171         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
172         return msg.data;
173     }
174 }
175 
176 // File: @openzeppelin/contracts-ethereum-package/contracts/access/Roles.sol
177 
178 pragma solidity ^0.5.0;
179 
180 /**
181  * @title Roles
182  * @dev Library for managing addresses assigned to a Role.
183  */
184 library Roles {
185     struct Role {
186         mapping (address => bool) bearer;
187     }
188 
189     /**
190      * @dev Give an account access to this role.
191      */
192     function add(Role storage role, address account) internal {
193         require(!has(role, account), "Roles: account already has role");
194         role.bearer[account] = true;
195     }
196 
197     /**
198      * @dev Remove an account's access to this role.
199      */
200     function remove(Role storage role, address account) internal {
201         require(has(role, account), "Roles: account does not have role");
202         role.bearer[account] = false;
203     }
204 
205     /**
206      * @dev Check if an account has this role.
207      * @return bool
208      */
209     function has(Role storage role, address account) internal view returns (bool) {
210         require(account != address(0), "Roles: account is the zero address");
211         return role.bearer[account];
212     }
213 }
214 
215 // File: @openzeppelin/contracts-ethereum-package/contracts/access/roles/PauserRole.sol
216 
217 pragma solidity ^0.5.0;
218 
219 
220 
221 
222 contract PauserRole is Initializable, Context {
223     using Roles for Roles.Role;
224 
225     event PauserAdded(address indexed account);
226     event PauserRemoved(address indexed account);
227 
228     Roles.Role private _pausers;
229 
230     function initialize(address sender) public initializer {
231         if (!isPauser(sender)) {
232             _addPauser(sender);
233         }
234     }
235 
236     modifier onlyPauser() {
237         require(isPauser(_msgSender()), "PauserRole: caller does not have the Pauser role");
238         _;
239     }
240 
241     function isPauser(address account) public view returns (bool) {
242         return _pausers.has(account);
243     }
244 
245     function addPauser(address account) public onlyPauser {
246         _addPauser(account);
247     }
248 
249     function renouncePauser() public {
250         _removePauser(_msgSender());
251     }
252 
253     function _addPauser(address account) internal {
254         _pausers.add(account);
255         emit PauserAdded(account);
256     }
257 
258     function _removePauser(address account) internal {
259         _pausers.remove(account);
260         emit PauserRemoved(account);
261     }
262 
263     uint256[50] private ______gap;
264 }
265 
266 // File: @openzeppelin/contracts-ethereum-package/contracts/lifecycle/Pausable.sol
267 
268 pragma solidity ^0.5.0;
269 
270 
271 
272 
273 /**
274  * @dev Contract module which allows children to implement an emergency stop
275  * mechanism that can be triggered by an authorized account.
276  *
277  * This module is used through inheritance. It will make available the
278  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
279  * the functions of your contract. Note that they will not be pausable by
280  * simply including this module, only once the modifiers are put in place.
281  */
282 contract Pausable is Initializable, Context, PauserRole {
283     /**
284      * @dev Emitted when the pause is triggered by a pauser (`account`).
285      */
286     event Paused(address account);
287 
288     /**
289      * @dev Emitted when the pause is lifted by a pauser (`account`).
290      */
291     event Unpaused(address account);
292 
293     bool private _paused;
294 
295     /**
296      * @dev Initializes the contract in unpaused state. Assigns the Pauser role
297      * to the deployer.
298      */
299     function initialize(address sender) public initializer {
300         PauserRole.initialize(sender);
301 
302         _paused = false;
303     }
304 
305     /**
306      * @dev Returns true if the contract is paused, and false otherwise.
307      */
308     function paused() public view returns (bool) {
309         return _paused;
310     }
311 
312     /**
313      * @dev Modifier to make a function callable only when the contract is not paused.
314      */
315     modifier whenNotPaused() {
316         require(!_paused, "Pausable: paused");
317         _;
318     }
319 
320     /**
321      * @dev Modifier to make a function callable only when the contract is paused.
322      */
323     modifier whenPaused() {
324         require(_paused, "Pausable: not paused");
325         _;
326     }
327 
328     /**
329      * @dev Called by a pauser to pause, triggers stopped state.
330      */
331     function pause() public onlyPauser whenNotPaused {
332         _paused = true;
333         emit Paused(_msgSender());
334     }
335 
336     /**
337      * @dev Called by a pauser to unpause, returns to normal state.
338      */
339     function unpause() public onlyPauser whenPaused {
340         _paused = false;
341         emit Unpaused(_msgSender());
342     }
343 
344     uint256[50] private ______gap;
345 }
346 
347 // File: @openzeppelin/contracts-ethereum-package/contracts/ownership/Ownable.sol
348 
349 pragma solidity ^0.5.0;
350 
351 
352 
353 /**
354  * @dev Contract module which provides a basic access control mechanism, where
355  * there is an account (an owner) that can be granted exclusive access to
356  * specific functions.
357  *
358  * This module is used through inheritance. It will make available the modifier
359  * `onlyOwner`, which can be aplied to your functions to restrict their use to
360  * the owner.
361  */
362 contract Ownable is Initializable, Context {
363     address private _owner;
364 
365     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
366 
367     /**
368      * @dev Initializes the contract setting the deployer as the initial owner.
369      */
370     function initialize(address sender) public initializer {
371         _owner = sender;
372         emit OwnershipTransferred(address(0), _owner);
373     }
374 
375     /**
376      * @dev Returns the address of the current owner.
377      */
378     function owner() public view returns (address) {
379         return _owner;
380     }
381 
382     /**
383      * @dev Throws if called by any account other than the owner.
384      */
385     modifier onlyOwner() {
386         require(isOwner(), "Ownable: caller is not the owner");
387         _;
388     }
389 
390     /**
391      * @dev Returns true if the caller is the current owner.
392      */
393     function isOwner() public view returns (bool) {
394         return _msgSender() == _owner;
395     }
396 
397     /**
398      * @dev Leaves the contract without owner. It will not be possible to call
399      * `onlyOwner` functions anymore. Can only be called by the current owner.
400      *
401      * > Note: Renouncing ownership will leave the contract without an owner,
402      * thereby removing any functionality that is only available to the owner.
403      */
404     function renounceOwnership() public onlyOwner {
405         emit OwnershipTransferred(_owner, address(0));
406         _owner = address(0);
407     }
408 
409     /**
410      * @dev Transfers ownership of the contract to a new account (`newOwner`).
411      * Can only be called by the current owner.
412      */
413     function transferOwnership(address newOwner) public onlyOwner {
414         _transferOwnership(newOwner);
415     }
416 
417     /**
418      * @dev Transfers ownership of the contract to a new account (`newOwner`).
419      */
420     function _transferOwnership(address newOwner) internal {
421         require(newOwner != address(0), "Ownable: new owner is the zero address");
422         emit OwnershipTransferred(_owner, newOwner);
423         _owner = newOwner;
424     }
425 
426     uint256[50] private ______gap;
427 }
428 
429 // File: @openzeppelin/contracts/utils/ReentrancyGuard.sol
430 
431 pragma solidity ^0.5.0;
432 
433 /**
434  * @dev Contract module that helps prevent reentrant calls to a function.
435  *
436  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
437  * available, which can be applied to functions to make sure there are no nested
438  * (reentrant) calls to them.
439  *
440  * Note that because there is a single `nonReentrant` guard, functions marked as
441  * `nonReentrant` may not call one another. This can be worked around by making
442  * those functions `private`, and then adding `external` `nonReentrant` entry
443  * points to them.
444  *
445  * TIP: If you would like to learn more about reentrancy and alternative ways
446  * to protect against it, check out our blog post
447  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
448  *
449  * _Since v2.5.0:_ this module is now much more gas efficient, given net gas
450  * metering changes introduced in the Istanbul hardfork.
451  */
452 contract ReentrancyGuard {
453     bool private _notEntered;
454 
455     constructor () internal {
456         // Storing an initial non-zero value makes deployment a bit more
457         // expensive, but in exchange the refund on every call to nonReentrant
458         // will be lower in amount. Since refunds are capped to a percetange of
459         // the total transaction's gas, it is best to keep them low in cases
460         // like this one, to increase the likelihood of the full refund coming
461         // into effect.
462         _notEntered = true;
463     }
464 
465     /**
466      * @dev Prevents a contract from calling itself, directly or indirectly.
467      * Calling a `nonReentrant` function from another `nonReentrant`
468      * function is not supported. It is possible to prevent this from happening
469      * by making the `nonReentrant` function external, and make it call a
470      * `private` function that does the actual work.
471      */
472     modifier nonReentrant() {
473         // On the first call to nonReentrant, _notEntered will be true
474         require(_notEntered, "ReentrancyGuard: reentrant call");
475 
476         // Any calls to nonReentrant after this point will fail
477         _notEntered = false;
478 
479         _;
480 
481         // By storing the original value once again, a refund is triggered (see
482         // https://eips.ethereum.org/EIPS/eip-2200)
483         _notEntered = true;
484     }
485 }
486 
487 // File: contracts/Recoverable.sol
488 
489 /**
490  * Based on https://github.com/TokenMarketNet/smart-contracts/blob/master/contracts/Recoverable.sol
491  */
492 
493 pragma solidity ^0.5.0;
494 
495 
496 
497 /**
498  * Allows to recover any tokens accidentally send on the smart contract.
499  *
500  * Sending ethers on token contracts is not possible in the first place.
501  * as they are not payable.
502  *
503  * https://twitter.com/moo9000/status/1238514802189795331
504  */
505 contract Recoverable is Ownable {
506 
507   function initialize(address sender) public initializer {
508     super.initialize(sender);
509   }
510 
511   /// @dev This will be invoked by the owner, when owner wants to rescue tokens
512   /// @param token Token which will we rescue to the owner from the contract
513   function recoverTokens(IERC20 token) public onlyOwner {
514     require(token.transfer(owner(), tokensToBeReturned(token)), "Transfer failed");
515   }
516 
517   /// @dev Interface function, can be overwritten by the superclass
518   /// @param token Token which balance we will check and return
519   /// @return The amount of tokens (in smallest denominator) the contract owns
520   function tokensToBeReturned(IERC20 token) public view returns (uint) {
521     return token.balanceOf(address(this));
522   }
523 
524   // Upgradeability - add some space
525   uint256[50] private ______gap;
526 }
527 
528 // File: contracts/TokenSwap.sol
529 
530 pragma solidity ^0.5.0;
531 
532 // https://github.com/OpenZeppelin/openzeppelin-contracts-ethereum-package/blob/master/contracts/
533 // https://github.com/OpenZeppelin/openzeppelin-sdk/tree/master/packages/lib/contracts
534 
535 
536 
537 
538 
539 
540 /**
541  * Swap old 1ST token to new DAWN token.
542  *
543  * Recoverable allows us to recover any wrong ERC-20 tokens user send here by an accident.
544  *
545  * This contract *is not* behind a proxy.
546  * We use Initializable pattern here to be in line with the other contracts.
547  * Normal constructor would work as well, but then we would be mixing
548  * base contracts from openzeppelin-contracts and openzeppelin-sdk both,
549  * which is a huge mess.
550  *
551  * We are not using SafeMath here, as we are not doing accounting math.
552  * user gets out the same amount of tokens they send in.
553  *
554  */
555 contract TokenSwap is Initializable, ReentrancyGuard, Pausable, Ownable, Recoverable {
556 
557   /* Token coming for a burn */
558   IERC20 public oldToken;
559 
560   /* Token sent to the swapper */
561   IERC20 public newToken;
562 
563   /* Where old tokens are send permantly to die */
564   address public burnDestination;
565 
566   /* Public key of our server-side signing mechanism to ensure everyone who calls swap is whitelisted */
567   address public signerAddress;
568 
569   /* How many tokens we have successfully swapped */
570   uint public totalSwapped;
571 
572   /* For following in the dashboard */
573   event Swapped(address indexed owner, uint amount);
574 
575   /** When the contract owner sends old token to burn address */
576   event LegacyBurn(uint amount);
577 
578   /** The server-side signer key has been updated */
579   event SignerUpdated(address addr);
580 
581   /**
582    *
583    * 1. Owner is a multisig wallet
584    * 2. Owner holds newToken supply
585    * 3. Owner does approve() on this contract for the full supply
586    * 4. Owner can pause swapping
587    * 5. Owner can send tokens to be burned
588    *
589    */
590   function initialize(address owner, address signer, address _oldToken, address _newToken, address _burnDestination)
591     public initializer {
592 
593     // Note: ReentrancyGuard.initialze() was added in OpenZeppelin SDK 2.6.0, we are using 2.5.0
594     // ReentrancyGuard.initialize();
595 
596     // Deployer account holds temporary ownership until the setup is done
597     Ownable.initialize(_msgSender());
598     setSignerAddress(signer);
599 
600     Pausable.initialize(owner);
601     _transferOwnership(owner);
602 
603     _setBurnDestination(_burnDestination);
604 
605     oldToken = IERC20(_oldToken);
606     newToken = IERC20(_newToken);
607     require(oldToken.totalSupply() == newToken.totalSupply(), "Cannot create swap, old and new token supply differ");
608 
609   }
610 
611   function _swap(address whom, uint amount) internal nonReentrant {
612     // Move old tokens to this contract
613     address swapper = address(this);
614     // We have added some user friendly error messages here if they
615     // somehow manage to screw interaction
616     totalSwapped += amount;
617     require(oldToken.transferFrom(whom, swapper, amount), "Could not retrieve old tokens");
618     require(newToken.transferFrom(owner(), whom, amount), "Could not send new tokens");
619   }
620 
621   /**
622    * Check that the server-side signature matches.
623    *
624    * Note that this check does NOT use Ethereum message signing preamble:
625    * https://ethereum.stackexchange.com/a/43984/620
626    *
627    * Thus, you cannot get v, r, s with user facing wallets, you need
628    * to work for those using lower level tools.
629    *
630    */
631   function _checkSenderSignature(address sender, uint8 v, bytes32 r, bytes32 s) internal view {
632       // https://ethereum.stackexchange.com/a/41356/620
633       bytes memory packed = abi.encodePacked(sender);
634       bytes32 hashResult = keccak256(packed);
635       require(ecrecover(hashResult, v, r, s) == signerAddress, "Address was not properly signed by whitelisting server");
636   }
637 
638   /**
639    * A server-side whitelisted address can swap their tokens.
640    *
641    * Please note that after whitelisted once, the address can call this multiple times. This is intentional behavior.
642    * As whitelisting per transaction is extra complexite that does not server any business goal.
643    *
644    */
645   function swapTokensForSender(uint amount, uint8 v, bytes32 r, bytes32 s) public whenNotPaused {
646     _checkSenderSignature(msg.sender, v, r, s);
647     address swapper = address(this);
648     require(oldToken.allowance(msg.sender, swapper) >= amount, "You need to first approve() enough tokens to swap for this contract");
649     require(oldToken.balanceOf(msg.sender) >= amount, "You do not have enough tokens to swap");
650     _swap(msg.sender, amount);
651 
652     emit Swapped(msg.sender, amount);
653   }
654 
655   /**
656    * How much new tokens we have loaded on the contract to swap.
657    */
658   function getTokensLeftToSwap() public view returns(uint) {
659     return newToken.allowance(owner(), address(this));
660   }
661 
662   /**
663    * Allows admin to burn old tokens
664    *
665    * Note that the owner could recoverToken() here,
666    * before tokens are burned. However, the same
667    * owner can upload the code payload of the new token,
668    * so the trust risk for this to happen is low compared
669    * to other trust risks.
670    */
671   function burn(uint amount) public onlyOwner {
672     require(oldToken.transfer(burnDestination, amount), "Could not send tokens to burn");
673     emit LegacyBurn(amount);
674   }
675 
676   /**
677    * Set the address (0x0000) where we are going to send burned tokens.
678    */
679   function _setBurnDestination(address _destination) internal {
680     burnDestination = _destination;
681   }
682 
683   /**
684    * Allow to cycle the server-side signing key.
685    */
686   function setSignerAddress(address _signerAddress) public onlyOwner {
687     signerAddress = _signerAddress;
688     emit SignerUpdated(signerAddress);
689   }
690 
691 }