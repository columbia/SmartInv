1 pragma solidity ^0.5.0;
2 
3 pragma experimental ABIEncoderV2;
4 
5 /**
6  * @title ERC20 interface
7  * @dev see https://github.com/ethereum/EIPs/issues/20
8  */
9 interface IERC20 {
10     function transfer(address to, uint256 value) external returns (bool);
11 
12     function approve(address spender, uint256 value) external returns (bool);
13 
14     function transferFrom(address from, address to, uint256 value) external returns (bool);
15 
16     function totalSupply() external view returns (uint256);
17 
18     function balanceOf(address who) external view returns (uint256);
19 
20     function allowance(address owner, address spender) external view returns (uint256);
21 
22     event Transfer(address indexed from, address indexed to, uint256 value);
23 
24     event Approval(address indexed owner, address indexed spender, uint256 value);
25 }
26 
27 /**
28  * @title Ownable
29  * @dev The Ownable contract has an owner address, and provides basic authorization control
30  * functions, this simplifies the implementation of "user permissions".
31  */
32 contract Ownable {
33     address private _owner;
34 
35     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
36 
37     /**
38      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
39      * account.
40      */
41     constructor () internal {
42         _owner = msg.sender;
43         emit OwnershipTransferred(address(0), _owner);
44     }
45 
46     /**
47      * @return the address of the owner.
48      */
49     function owner() public view returns (address) {
50         return _owner;
51     }
52 
53     /**
54      * @dev Throws if called by any account other than the owner.
55      */
56     modifier onlyOwner() {
57         require(isOwner());
58         _;
59     }
60 
61     /**
62      * @return true if `msg.sender` is the owner of the contract.
63      */
64     function isOwner() public view returns (bool) {
65         return msg.sender == _owner;
66     }
67 
68     /**
69      * @dev Allows the current owner to relinquish control of the contract.
70      * @notice Renouncing to ownership will leave the contract without an owner.
71      * It will not be possible to call the functions with the `onlyOwner`
72      * modifier anymore.
73      */
74     function renounceOwnership() public onlyOwner {
75         emit OwnershipTransferred(_owner, address(0));
76         _owner = address(0);
77     }
78 
79     /**
80      * @dev Allows the current owner to transfer control of the contract to a newOwner.
81      * @param newOwner The address to transfer ownership to.
82      */
83     function transferOwnership(address newOwner) public onlyOwner {
84         _transferOwnership(newOwner);
85     }
86 
87     /**
88      * @dev Transfers control of the contract to a newOwner.
89      * @param newOwner The address to transfer ownership to.
90      */
91     function _transferOwnership(address newOwner) internal {
92         require(newOwner != address(0));
93         emit OwnershipTransferred(_owner, newOwner);
94         _owner = newOwner;
95     }
96 }
97 
98 /**
99  * @title SafeMath
100  * @dev Unsigned math operations with safety checks that revert on error
101  */
102 library SafeMath {
103     /**
104     * @dev Multiplies two unsigned integers, reverts on overflow.
105     */
106     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
107         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
108         // benefit is lost if 'b' is also tested.
109         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
110         if (a == 0) {
111             return 0;
112         }
113 
114         uint256 c = a * b;
115         require(c / a == b);
116 
117         return c;
118     }
119 
120     /**
121     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
122     */
123     function div(uint256 a, uint256 b) internal pure returns (uint256) {
124         // Solidity only automatically asserts when dividing by 0
125         require(b > 0);
126         uint256 c = a / b;
127         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
128 
129         return c;
130     }
131 
132     /**
133     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
134     */
135     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
136         require(b <= a);
137         uint256 c = a - b;
138 
139         return c;
140     }
141 
142     /**
143     * @dev Adds two unsigned integers, reverts on overflow.
144     */
145     function add(uint256 a, uint256 b) internal pure returns (uint256) {
146         uint256 c = a + b;
147         require(c >= a);
148 
149         return c;
150     }
151 
152     /**
153     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
154     * reverts when dividing by zero.
155     */
156     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
157         require(b != 0);
158         return a % b;
159     }
160 }
161 
162 /**
163  * @title SignedSafeMath
164  * @dev Signed math operations with safety checks that revert on error
165  */
166 library SignedSafeMath {
167     int256 constant private INT256_MIN = -2**255;
168 
169     /**
170     * @dev Multiplies two signed integers, reverts on overflow.
171     */
172     function mul(int256 a, int256 b) internal pure returns (int256) {
173         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
174         // benefit is lost if 'b' is also tested.
175         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
176         if (a == 0) {
177             return 0;
178         }
179 
180         require(!(a == -1 && b == INT256_MIN)); // This is the only case of overflow not detected by the check below
181 
182         int256 c = a * b;
183         require(c / a == b);
184 
185         return c;
186     }
187 
188     /**
189     * @dev Integer division of two signed integers truncating the quotient, reverts on division by zero.
190     */
191     function div(int256 a, int256 b) internal pure returns (int256) {
192         require(b != 0); // Solidity only automatically asserts when dividing by 0
193         require(!(b == -1 && a == INT256_MIN)); // This is the only case of overflow
194 
195         int256 c = a / b;
196 
197         return c;
198     }
199 
200     /**
201     * @dev Subtracts two signed integers, reverts on overflow.
202     */
203     function sub(int256 a, int256 b) internal pure returns (int256) {
204         int256 c = a - b;
205         require((b >= 0 && c <= a) || (b < 0 && c > a));
206 
207         return c;
208     }
209 
210     /**
211     * @dev Adds two signed integers, reverts on overflow.
212     */
213     function add(int256 a, int256 b) internal pure returns (int256) {
214         int256 c = a + b;
215         require((b >= 0 && c >= a) || (b < 0 && c < a));
216 
217         return c;
218     }
219 }
220 
221 /**
222  * @title Standard ERC20 token
223  *
224  * @dev Implementation of the basic standard token.
225  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
226  * Originally based on code by FirstBlood:
227  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
228  *
229  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
230  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
231  * compliant implementations may not do it.
232  */
233 contract ERC20 is IERC20 {
234     using SafeMath for uint256;
235 
236     mapping (address => uint256) private _balances;
237 
238     mapping (address => mapping (address => uint256)) private _allowed;
239 
240     uint256 private _totalSupply;
241 
242     /**
243     * @dev Total number of tokens in existence
244     */
245     function totalSupply() public view returns (uint256) {
246         return _totalSupply;
247     }
248 
249     /**
250     * @dev Gets the balance of the specified address.
251     * @param owner The address to query the balance of.
252     * @return An uint256 representing the amount owned by the passed address.
253     */
254     function balanceOf(address owner) public view returns (uint256) {
255         return _balances[owner];
256     }
257 
258     /**
259      * @dev Function to check the amount of tokens that an owner allowed to a spender.
260      * @param owner address The address which owns the funds.
261      * @param spender address The address which will spend the funds.
262      * @return A uint256 specifying the amount of tokens still available for the spender.
263      */
264     function allowance(address owner, address spender) public view returns (uint256) {
265         return _allowed[owner][spender];
266     }
267 
268     /**
269     * @dev Transfer token for a specified address
270     * @param to The address to transfer to.
271     * @param value The amount to be transferred.
272     */
273     function transfer(address to, uint256 value) public returns (bool) {
274         _transfer(msg.sender, to, value);
275         return true;
276     }
277 
278     /**
279      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
280      * Beware that changing an allowance with this method brings the risk that someone may use both the old
281      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
282      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
283      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
284      * @param spender The address which will spend the funds.
285      * @param value The amount of tokens to be spent.
286      */
287     function approve(address spender, uint256 value) public returns (bool) {
288         require(spender != address(0));
289 
290         _allowed[msg.sender][spender] = value;
291         emit Approval(msg.sender, spender, value);
292         return true;
293     }
294 
295     /**
296      * @dev Transfer tokens from one address to another.
297      * Note that while this function emits an Approval event, this is not required as per the specification,
298      * and other compliant implementations may not emit the event.
299      * @param from address The address which you want to send tokens from
300      * @param to address The address which you want to transfer to
301      * @param value uint256 the amount of tokens to be transferred
302      */
303     function transferFrom(address from, address to, uint256 value) public returns (bool) {
304         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
305         _transfer(from, to, value);
306         emit Approval(from, msg.sender, _allowed[from][msg.sender]);
307         return true;
308     }
309 
310     /**
311      * @dev Increase the amount of tokens that an owner allowed to a spender.
312      * approve should be called when allowed_[_spender] == 0. To increment
313      * allowed value is better to use this function to avoid 2 calls (and wait until
314      * the first transaction is mined)
315      * From MonolithDAO Token.sol
316      * Emits an Approval event.
317      * @param spender The address which will spend the funds.
318      * @param addedValue The amount of tokens to increase the allowance by.
319      */
320     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
321         require(spender != address(0));
322 
323         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].add(addedValue);
324         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
325         return true;
326     }
327 
328     /**
329      * @dev Decrease the amount of tokens that an owner allowed to a spender.
330      * approve should be called when allowed_[_spender] == 0. To decrement
331      * allowed value is better to use this function to avoid 2 calls (and wait until
332      * the first transaction is mined)
333      * From MonolithDAO Token.sol
334      * Emits an Approval event.
335      * @param spender The address which will spend the funds.
336      * @param subtractedValue The amount of tokens to decrease the allowance by.
337      */
338     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
339         require(spender != address(0));
340 
341         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].sub(subtractedValue);
342         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
343         return true;
344     }
345 
346     /**
347     * @dev Transfer token for a specified addresses
348     * @param from The address to transfer from.
349     * @param to The address to transfer to.
350     * @param value The amount to be transferred.
351     */
352     function _transfer(address from, address to, uint256 value) internal {
353         require(to != address(0));
354 
355         _balances[from] = _balances[from].sub(value);
356         _balances[to] = _balances[to].add(value);
357         emit Transfer(from, to, value);
358     }
359 
360     /**
361      * @dev Internal function that mints an amount of the token and assigns it to
362      * an account. This encapsulates the modification of balances such that the
363      * proper events are emitted.
364      * @param account The account that will receive the created tokens.
365      * @param value The amount that will be created.
366      */
367     function _mint(address account, uint256 value) internal {
368         require(account != address(0));
369 
370         _totalSupply = _totalSupply.add(value);
371         _balances[account] = _balances[account].add(value);
372         emit Transfer(address(0), account, value);
373     }
374 
375     /**
376      * @dev Internal function that burns an amount of the token of a given
377      * account.
378      * @param account The account whose tokens will be burnt.
379      * @param value The amount that will be burnt.
380      */
381     function _burn(address account, uint256 value) internal {
382         require(account != address(0));
383 
384         _totalSupply = _totalSupply.sub(value);
385         _balances[account] = _balances[account].sub(value);
386         emit Transfer(account, address(0), value);
387     }
388 
389     /**
390      * @dev Internal function that burns an amount of the token of a given
391      * account, deducting from the sender's allowance for said account. Uses the
392      * internal burn function.
393      * Emits an Approval event (reflecting the reduced allowance).
394      * @param account The account whose tokens will be burnt.
395      * @param value The amount that will be burnt.
396      */
397     function _burnFrom(address account, uint256 value) internal {
398         _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(value);
399         _burn(account, value);
400         emit Approval(account, msg.sender, _allowed[account][msg.sender]);
401     }
402 }
403 
404 // The functionality that all derivative contracts expose to the admin.
405 interface AdminInterface {
406     // Initiates the shutdown process, in case of an emergency.
407     function emergencyShutdown() external;
408 
409     // A core contract method called immediately before or after any financial transaction. It pays fees and moves money
410     // between margin accounts to make sure they reflect the NAV of the contract.
411     function remargin() external;
412 }
413 
414 contract ExpandedIERC20 is IERC20 {
415     // Burns a specific amount of tokens. Burns the sender's tokens, so it is safe to leave this method permissionless.
416     function burn(uint value) external;
417 
418     // Mints tokens and adds them to the balance of the `to` address.
419     // Note: this method should be permissioned to only allow designated parties to mint tokens.
420     function mint(address to, uint value) external;
421 }
422 
423 // This interface allows derivative contracts to pay Oracle fees for their use of the system.
424 interface StoreInterface {
425 
426     // Pays Oracle fees in ETH to the store. To be used by contracts whose margin currency is ETH.
427     function payOracleFees() external payable;
428 
429     // Pays Oracle fees in the margin currency, erc20Address, to the store. To be used if the margin currency is an
430     // ERC20 token rather than ETH. All approved tokens are transfered.
431     function payOracleFeesErc20(address erc20Address) external; 
432 
433     // Computes the Oracle fees that a contract should pay for a period. `pfc` is the "profit from corruption", or the
434     // maximum amount of margin currency that a token sponsor could extract from the contract through corrupting the
435     // price feed in their favor.
436     function computeOracleFees(uint startTime, uint endTime, uint pfc) external view returns (uint feeAmount);
437 }
438 
439 interface ReturnCalculatorInterface {
440     // Computes the return between oldPrice and newPrice.
441     function computeReturn(int oldPrice, int newPrice) external view returns (int assetReturn);
442 
443     // Gets the effective leverage for the return calculator.
444     // Note: if this parameter doesn't exist for this calculator, this method should return 1.
445     function leverage() external view returns (int _leverage);
446 }
447 
448 // This interface allows contracts to query unverified prices.
449 interface PriceFeedInterface {
450     // Whether this PriceFeeds provides prices for the given identifier.
451     function isIdentifierSupported(bytes32 identifier) external view returns (bool isSupported);
452 
453     // Gets the latest time-price pair at which a price was published. The transaction will revert if no prices have
454     // been published for this identifier.
455     function latestPrice(bytes32 identifier) external view returns (uint publishTime, int price);
456 
457     // An event fired when a price is published.
458     event PriceUpdated(bytes32 indexed identifier, uint indexed time, int price);
459 }
460 
461 contract AddressWhitelist is Ownable {
462     enum Status { None, In, Out }
463     mapping(address => Status) private whitelist;
464 
465     address[] private whitelistIndices;
466 
467     // Adds an address to the whitelist
468     function addToWhitelist(address newElement) external onlyOwner {
469         // Ignore if address is already included
470         if (whitelist[newElement] == Status.In) {
471             return;
472         }
473 
474         // Only append new addresses to the array, never a duplicate
475         if (whitelist[newElement] == Status.None) {
476             whitelistIndices.push(newElement);
477         }
478 
479         whitelist[newElement] = Status.In;
480 
481         emit AddToWhitelist(newElement);
482     }
483 
484     // Removes an address from the whitelist.
485     function removeFromWhitelist(address elementToRemove) external onlyOwner {
486         if (whitelist[elementToRemove] != Status.Out) {
487             whitelist[elementToRemove] = Status.Out;
488             emit RemoveFromWhitelist(elementToRemove);
489         }
490     }
491 
492     // Checks whether an address is on the whitelist.
493     function isOnWhitelist(address elementToCheck) external view returns (bool) {
494         return whitelist[elementToCheck] == Status.In;
495     }
496 
497     // Gets all addresses that are currently included in the whitelist
498     // Note: This method skips over, but still iterates through addresses.
499     // It is possible for this call to run out of gas if a large number of
500     // addresses have been removed. To prevent this unlikely scenario, we can
501     // modify the implementation so that when addresses are removed, the last addresses
502     // in the array is moved to the empty index.
503     function getWhitelist() external view returns (address[] memory activeWhitelist) {
504         // Determine size of whitelist first
505         uint activeCount = 0;
506         for (uint i = 0; i < whitelistIndices.length; i++) {
507             if (whitelist[whitelistIndices[i]] == Status.In) {
508                 activeCount++;
509             }
510         }
511 
512         // Populate whitelist
513         activeWhitelist = new address[](activeCount);
514         activeCount = 0;
515         for (uint i = 0; i < whitelistIndices.length; i++) {
516             address addr = whitelistIndices[i];
517             if (whitelist[addr] == Status.In) {
518                 activeWhitelist[activeCount] = addr;
519                 activeCount++;
520             }
521         }
522     }
523 
524     event AddToWhitelist(address indexed addedAddress);
525     event RemoveFromWhitelist(address indexed removedAddress);
526 }
527 
528 contract Withdrawable is Ownable {
529     // Withdraws ETH from the contract.
530     function withdraw(uint amount) external onlyOwner {
531         msg.sender.transfer(amount);
532     }
533 
534     // Withdraws ERC20 tokens from the contract.
535     function withdrawErc20(address erc20Address, uint amount) external onlyOwner {
536         IERC20 erc20 = IERC20(erc20Address);
537         require(erc20.transfer(msg.sender, amount));
538     }
539 }
540 
541 // This interface allows contracts to query a verified, trusted price.
542 interface OracleInterface {
543     // Requests the Oracle price for an identifier at a time. Returns the time at which a price will be available.
544     // Returns 0 is the price is available now, and returns 2^256-1 if the price will never be available.  Reverts if
545     // the Oracle doesn't support this identifier. Only contracts registered in the Registry are authorized to call this
546     // method.
547     function requestPrice(bytes32 identifier, uint time) external returns (uint expectedTime);
548 
549     // Checks whether a price has been resolved.
550     function hasPrice(bytes32 identifier, uint time) external view returns (bool hasPriceAvailable);
551 
552     // Returns the Oracle price for identifier at a time. Reverts if the Oracle doesn't support this identifier or if
553     // the Oracle doesn't have a price for this time. Only contracts registered in the Registry are authorized to call
554     // this method.
555     function getPrice(bytes32 identifier, uint time) external view returns (int price);
556 
557     // Returns whether the Oracle provides verified prices for the given identifier.
558     function isIdentifierSupported(bytes32 identifier) external view returns (bool isSupported);
559 
560     // An event fired when a request for a (identifier, time) pair is made.
561     event VerifiedPriceRequested(bytes32 indexed identifier, uint indexed time);
562 
563     // An event fired when a verified price is available for a (identifier, time) pair.
564     event VerifiedPriceAvailable(bytes32 indexed identifier, uint indexed time, int price);
565 }
566 
567 interface RegistryInterface {
568     struct RegisteredDerivative {
569         address derivativeAddress;
570         address derivativeCreator;
571     }
572 
573     // Registers a new derivative. Only authorized derivative creators can call this method.
574     function registerDerivative(address[] calldata counterparties, address derivativeAddress) external;
575 
576     // Adds a new derivative creator to this list of authorized creators. Only the owner of this contract can call
577     // this method.   
578     function addDerivativeCreator(address derivativeCreator) external;
579 
580     // Removes a derivative creator to this list of authorized creators. Only the owner of this contract can call this
581     // method.  
582     function removeDerivativeCreator(address derivativeCreator) external;
583 
584     // Returns whether the derivative has been registered with the registry (and is therefore an authorized participant
585     // in the UMA system).
586     function isDerivativeRegistered(address derivative) external view returns (bool isRegistered);
587 
588     // Returns a list of all derivatives that are associated with a particular party.
589     function getRegisteredDerivatives(address party) external view returns (RegisteredDerivative[] memory derivatives);
590 
591     // Returns all registered derivatives.
592     function getAllRegisteredDerivatives() external view returns (RegisteredDerivative[] memory derivatives);
593 
594     // Returns whether an address is authorized to register new derivatives.
595     function isDerivativeCreatorAuthorized(address derivativeCreator) external view returns (bool isAuthorized);
596 }
597 
598 contract Registry is RegistryInterface, Withdrawable {
599 
600     using SafeMath for uint;
601 
602     // Array of all registeredDerivatives that are approved to use the UMA Oracle.
603     RegisteredDerivative[] private registeredDerivatives;
604 
605     // This enum is required because a WasValid state is required to ensure that derivatives cannot be re-registered.
606     enum PointerValidity {
607         Invalid,
608         Valid,
609         WasValid
610     }
611 
612     struct Pointer {
613         PointerValidity valid;
614         uint128 index;
615     }
616 
617     // Maps from derivative address to a pointer that refers to that RegisteredDerivative in registeredDerivatives.
618     mapping(address => Pointer) private derivativePointers;
619 
620     // Note: this must be stored outside of the RegisteredDerivative because mappings cannot be deleted and copied
621     // like normal data. This could be stored in the Pointer struct, but storing it there would muddy the purpose
622     // of the Pointer struct and break separation of concern between referential data and data.
623     struct PartiesMap {
624         mapping(address => bool) parties;
625     }
626 
627     // Maps from derivative address to the set of parties that are involved in that derivative.
628     mapping(address => PartiesMap) private derivativesToParties;
629 
630     // Maps from derivative creator address to whether that derivative creator has been approved to register contracts.
631     mapping(address => bool) private derivativeCreators;
632 
633     modifier onlyApprovedDerivativeCreator {
634         require(derivativeCreators[msg.sender]);
635         _;
636     }
637 
638     function registerDerivative(address[] calldata parties, address derivativeAddress)
639         external
640         onlyApprovedDerivativeCreator
641     {
642         // Create derivative pointer.
643         Pointer storage pointer = derivativePointers[derivativeAddress];
644 
645         // Ensure that the pointer was not valid in the past (derivatives cannot be re-registered or double
646         // registered).
647         require(pointer.valid == PointerValidity.Invalid);
648         pointer.valid = PointerValidity.Valid;
649 
650         registeredDerivatives.push(RegisteredDerivative(derivativeAddress, msg.sender));
651 
652         // No length check necessary because we should never hit (2^127 - 1) derivatives.
653         pointer.index = uint128(registeredDerivatives.length.sub(1));
654 
655         // Set up PartiesMap for this derivative.
656         PartiesMap storage partiesMap = derivativesToParties[derivativeAddress];
657         for (uint i = 0; i < parties.length; i = i.add(1)) {
658             partiesMap.parties[parties[i]] = true;
659         }
660 
661         address[] memory partiesForEvent = parties;
662         emit RegisterDerivative(derivativeAddress, partiesForEvent);
663     }
664 
665     function addDerivativeCreator(address derivativeCreator) external onlyOwner {
666         if (!derivativeCreators[derivativeCreator]) {
667             derivativeCreators[derivativeCreator] = true;
668             emit AddDerivativeCreator(derivativeCreator);
669         }
670     }
671 
672     function removeDerivativeCreator(address derivativeCreator) external onlyOwner {
673         if (derivativeCreators[derivativeCreator]) {
674             derivativeCreators[derivativeCreator] = false;
675             emit RemoveDerivativeCreator(derivativeCreator);
676         }
677     }
678 
679     function isDerivativeRegistered(address derivative) external view returns (bool isRegistered) {
680         return derivativePointers[derivative].valid == PointerValidity.Valid;
681     }
682 
683     function getRegisteredDerivatives(address party) external view returns (RegisteredDerivative[] memory derivatives) {
684         // This is not ideal - we must statically allocate memory arrays. To be safe, we make a temporary array as long
685         // as registeredDerivatives. We populate it with any derivatives that involve the provided party. Then, we copy
686         // the array over to the return array, which is allocated using the correct size. Note: this is done by double
687         // copying each value rather than storing some referential info (like indices) in memory to reduce the number
688         // of storage reads. This is because storage reads are far more expensive than extra memory space (~100:1).
689         RegisteredDerivative[] memory tmpDerivativeArray = new RegisteredDerivative[](registeredDerivatives.length);
690         uint outputIndex = 0;
691         for (uint i = 0; i < registeredDerivatives.length; i = i.add(1)) {
692             RegisteredDerivative storage derivative = registeredDerivatives[i];
693             if (derivativesToParties[derivative.derivativeAddress].parties[party]) {
694                 // Copy selected derivative to the temporary array.
695                 tmpDerivativeArray[outputIndex] = derivative;
696                 outputIndex = outputIndex.add(1);
697             }
698         }
699 
700         // Copy the temp array to the return array that is set to the correct size.
701         derivatives = new RegisteredDerivative[](outputIndex);
702         for (uint j = 0; j < outputIndex; j = j.add(1)) {
703             derivatives[j] = tmpDerivativeArray[j];
704         }
705     }
706 
707     function getAllRegisteredDerivatives() external view returns (RegisteredDerivative[] memory derivatives) {
708         return registeredDerivatives;
709     }
710 
711     function isDerivativeCreatorAuthorized(address derivativeCreator) external view returns (bool isAuthorized) {
712         return derivativeCreators[derivativeCreator];
713     }
714 
715     event RegisterDerivative(address indexed derivativeAddress, address[] parties);
716     event AddDerivativeCreator(address indexed addedDerivativeCreator);
717     event RemoveDerivativeCreator(address indexed removedDerivativeCreator);
718 
719 }
720 
721 contract Testable is Ownable {
722 
723     // Is the contract being run on the test network. Note: this variable should be set on construction and never
724     // modified.
725     bool public isTest;
726 
727     uint private currentTime;
728 
729     constructor(bool _isTest) internal {
730         isTest = _isTest;
731         if (_isTest) {
732             currentTime = now; // solhint-disable-line not-rely-on-time
733         }
734     }
735 
736     modifier onlyIfTest {
737         require(isTest);
738         _;
739     }
740 
741     function setCurrentTime(uint _time) external onlyOwner onlyIfTest {
742         currentTime = _time;
743     }
744 
745     function getCurrentTime() public view returns (uint) {
746         if (isTest) {
747             return currentTime;
748         } else {
749             return now; // solhint-disable-line not-rely-on-time
750         }
751     }
752 }
753 
754 contract ContractCreator is Withdrawable {
755     Registry internal registry;
756     address internal oracleAddress;
757     address internal storeAddress;
758     address internal priceFeedAddress;
759 
760     constructor(address registryAddress, address _oracleAddress, address _storeAddress, address _priceFeedAddress)
761         public
762     {
763         registry = Registry(registryAddress);
764         oracleAddress = _oracleAddress;
765         storeAddress = _storeAddress;
766         priceFeedAddress = _priceFeedAddress;
767     }
768 
769     function _registerContract(address[] memory parties, address contractToRegister) internal {
770         registry.registerDerivative(parties, contractToRegister);
771     }
772 }
773 
774 library TokenizedDerivativeParams {
775     enum ReturnType {
776         Linear,
777         Compound
778     }
779 
780     struct ConstructorParams {
781         address sponsor;
782         address admin;
783         address oracle;
784         address store;
785         address priceFeed;
786         uint defaultPenalty; // Percentage of margin requirement * 10^18
787         uint supportedMove; // Expected percentage move in the underlying price that the long is protected against.
788         bytes32 product;
789         uint fixedYearlyFee; // Percentage of nav * 10^18
790         uint disputeDeposit; // Percentage of margin requirement * 10^18
791         address returnCalculator;
792         uint startingTokenPrice;
793         uint expiry;
794         address marginCurrency;
795         uint withdrawLimit; // Percentage of derivativeStorage.shortBalance * 10^18
796         ReturnType returnType;
797         uint startingUnderlyingPrice;
798         uint creationTime;
799     }
800 }
801 
802 // TokenizedDerivativeStorage: this library name is shortened due to it being used so often.
803 library TDS {
804         enum State {
805         // The contract is active, and tokens can be created and redeemed. Margin can be added and withdrawn (as long as
806         // it exceeds required levels). Remargining is allowed. Created contracts immediately begin in this state.
807         // Possible state transitions: Disputed, Expired, Defaulted.
808         Live,
809 
810         // Disputed, Expired, Defaulted, and Emergency are Frozen states. In a Frozen state, the contract is frozen in
811         // time awaiting a resolution by the Oracle. No tokens can be created or redeemed. Margin cannot be withdrawn.
812         // The resolution of these states moves the contract to the Settled state. Remargining is not allowed.
813 
814         // The derivativeStorage.externalAddresses.sponsor has disputed the price feed output. If the dispute is valid (i.e., the NAV calculated from the
815         // Oracle price differs from the NAV calculated from the price feed), the dispute fee is added to the short
816         // account. Otherwise, the dispute fee is added to the long margin account.
817         // Possible state transitions: Settled.
818         Disputed,
819 
820         // Contract expiration has been reached.
821         // Possible state transitions: Settled.
822         Expired,
823 
824         // The short margin account is below its margin requirement. The derivativeStorage.externalAddresses.sponsor can choose to confirm the default and
825         // move to Settle without waiting for the Oracle. Default penalties will be assessed when the contract moves to
826         // Settled.
827         // Possible state transitions: Settled.
828         Defaulted,
829 
830         // UMA has manually triggered a shutdown of the account.
831         // Possible state transitions: Settled.
832         Emergency,
833 
834         // Token price is fixed. Tokens can be redeemed by anyone. All short margin can be withdrawn. Tokens can't be
835         // created, and contract can't remargin.
836         // Possible state transitions: None.
837         Settled
838     }
839 
840     // The state of the token at a particular time. The state gets updated on remargin.
841     struct TokenState {
842         int underlyingPrice;
843         int tokenPrice;
844         uint time;
845     }
846 
847     // The information in the following struct is only valid if in the midst of a Dispute.
848     struct Dispute {
849         int disputedNav;
850         uint deposit;
851     }
852 
853     struct WithdrawThrottle {
854         uint startTime;
855         uint remainingWithdrawal;
856     }
857 
858     struct FixedParameters {
859         // Fixed contract parameters.
860         uint defaultPenalty; // Percentage of margin requirement * 10^18
861         uint supportedMove; // Expected percentage move that the long is protected against.
862         uint disputeDeposit; // Percentage of margin requirement * 10^18
863         uint fixedFeePerSecond; // Percentage of nav*10^18
864         uint withdrawLimit; // Percentage of derivativeStorage.shortBalance*10^18
865         bytes32 product;
866         TokenizedDerivativeParams.ReturnType returnType;
867         uint initialTokenUnderlyingRatio;
868         uint creationTime;
869         string symbol;
870     }
871 
872     struct ExternalAddresses {
873         // Other addresses/contracts
874         address sponsor;
875         address admin;
876         address apDelegate;
877         OracleInterface oracle;
878         StoreInterface store;
879         PriceFeedInterface priceFeed;
880         ReturnCalculatorInterface returnCalculator;
881         IERC20 marginCurrency;
882     }
883 
884     struct Storage {
885         FixedParameters fixedParameters;
886         ExternalAddresses externalAddresses;
887 
888         // Balances
889         int shortBalance;
890         int longBalance;
891 
892         State state;
893         uint endTime;
894 
895         // The NAV of the contract always reflects the transition from (`prev`, `current`).
896         // In the case of a remargin, a `latest` price is retrieved from the price feed, and we shift `current` -> `prev`
897         // and `latest` -> `current` (and then recompute).
898         // In the case of a dispute, `current` might change (which is why we have to hold on to `prev`).
899         TokenState referenceTokenState;
900         TokenState currentTokenState;
901 
902         int nav;  // Net asset value is measured in Wei
903 
904         Dispute disputeInfo;
905 
906         // Only populated once the contract enters a frozen state.
907         int defaultPenaltyAmount;
908 
909         WithdrawThrottle withdrawThrottle;
910     }
911 }
912 
913 library TokenizedDerivativeUtils {
914     using TokenizedDerivativeUtils for TDS.Storage;
915     using SafeMath for uint;
916     using SignedSafeMath for int;
917 
918     uint private constant SECONDS_PER_DAY = 86400;
919     uint private constant SECONDS_PER_YEAR = 31536000;
920     uint private constant INT_MAX = 2**255 - 1;
921     uint private constant UINT_FP_SCALING_FACTOR = 10**18;
922     int private constant INT_FP_SCALING_FACTOR = 10**18;
923 
924     modifier onlySponsor(TDS.Storage storage s) {
925         require(msg.sender == s.externalAddresses.sponsor);
926         _;
927     }
928 
929     modifier onlyAdmin(TDS.Storage storage s) {
930         require(msg.sender == s.externalAddresses.admin);
931         _;
932     }
933 
934     modifier onlySponsorOrAdmin(TDS.Storage storage s) {
935         require(msg.sender == s.externalAddresses.sponsor || msg.sender == s.externalAddresses.admin);
936         _;
937     }
938 
939     modifier onlySponsorOrApDelegate(TDS.Storage storage s) {
940         require(msg.sender == s.externalAddresses.sponsor || msg.sender == s.externalAddresses.apDelegate);
941         _;
942     }
943 
944     // Contract initializer. Should only be called at construction.
945     // Note: Must be a public function because structs cannot be passed as calldata (required data type for external
946     // functions).
947     function _initialize(
948         TDS.Storage storage s, TokenizedDerivativeParams.ConstructorParams memory params, string memory symbol) public {
949 
950         s._setFixedParameters(params, symbol);
951         s._setExternalAddresses(params);
952         
953         // Keep the starting token price relatively close to FP_SCALING_FACTOR to prevent users from unintentionally
954         // creating rounding or overflow errors.
955         require(params.startingTokenPrice >= UINT_FP_SCALING_FACTOR.div(10**9));
956         require(params.startingTokenPrice <= UINT_FP_SCALING_FACTOR.mul(10**9));
957 
958         // TODO(mrice32): we should have an ideal start time rather than blindly polling.
959         (uint latestTime, int latestUnderlyingPrice) = s.externalAddresses.priceFeed.latestPrice(s.fixedParameters.product);
960 
961         // If nonzero, take the user input as the starting price.
962         if (params.startingUnderlyingPrice != 0) {
963             latestUnderlyingPrice = _safeIntCast(params.startingUnderlyingPrice);
964         }
965 
966         require(latestUnderlyingPrice > 0);
967         require(latestTime != 0);
968 
969         // Keep the ratio in case it's needed for margin computation.
970         s.fixedParameters.initialTokenUnderlyingRatio = params.startingTokenPrice.mul(UINT_FP_SCALING_FACTOR).div(_safeUintCast(latestUnderlyingPrice));
971         require(s.fixedParameters.initialTokenUnderlyingRatio != 0);
972 
973         // Set end time to max value of uint to implement no expiry.
974         if (params.expiry == 0) {
975             s.endTime = ~uint(0);
976         } else {
977             require(params.expiry >= latestTime);
978             s.endTime = params.expiry;
979         }
980 
981         s.nav = s._computeInitialNav(latestUnderlyingPrice, latestTime, params.startingTokenPrice);
982 
983         s.state = TDS.State.Live;
984     }
985 
986     function _depositAndCreateTokens(TDS.Storage storage s, uint marginForPurchase, uint tokensToPurchase) external onlySponsorOrApDelegate(s) {
987         s._remarginInternal();
988 
989         int newTokenNav = _computeNavForTokens(s.currentTokenState.tokenPrice, tokensToPurchase);
990 
991         if (newTokenNav < 0) {
992             newTokenNav = 0;
993         }
994 
995         uint positiveTokenNav = _safeUintCast(newTokenNav);
996 
997         // Get any refund due to sending more margin than the argument indicated (should only be able to happen in the
998         // ETH case).
999         uint refund = s._pullSentMargin(marginForPurchase);
1000 
1001         // Subtract newTokenNav from amount sent.
1002         uint depositAmount = marginForPurchase.sub(positiveTokenNav);
1003 
1004         // Deposit additional margin into the short account.
1005         s._depositInternal(depositAmount);
1006 
1007         // The _createTokensInternal call returns any refund due to the amount sent being larger than the amount
1008         // required to purchase the tokens, so we add that to the running refund. This should be 0 in this case,
1009         // but we leave this here in case of some refund being generated due to rounding errors or any bugs to ensure
1010         // the sender never loses money.
1011         refund = refund.add(s._createTokensInternal(tokensToPurchase, positiveTokenNav));
1012 
1013         // Send the accumulated refund.
1014         s._sendMargin(refund);
1015     }
1016 
1017     function _redeemTokens(TDS.Storage storage s, uint tokensToRedeem) external {
1018         require(s.state == TDS.State.Live || s.state == TDS.State.Settled);
1019         require(tokensToRedeem > 0);
1020 
1021         if (s.state == TDS.State.Live) {
1022             require(msg.sender == s.externalAddresses.sponsor || msg.sender == s.externalAddresses.apDelegate);
1023             s._remarginInternal();
1024             require(s.state == TDS.State.Live);
1025         }
1026 
1027         ExpandedIERC20 thisErc20Token = ExpandedIERC20(address(this));
1028 
1029         uint initialSupply = _totalSupply();
1030         require(initialSupply > 0);
1031 
1032         _pullAuthorizedTokens(thisErc20Token, tokensToRedeem);
1033         thisErc20Token.burn(tokensToRedeem);
1034         emit TokensRedeemed(s.fixedParameters.symbol, tokensToRedeem);
1035 
1036         // Value of the tokens is just the percentage of all the tokens multiplied by the balance of the investor
1037         // margin account.
1038         uint tokenPercentage = tokensToRedeem.mul(UINT_FP_SCALING_FACTOR).div(initialSupply);
1039         uint tokenMargin = _takePercentage(_safeUintCast(s.longBalance), tokenPercentage);
1040 
1041         s.longBalance = s.longBalance.sub(_safeIntCast(tokenMargin));
1042         assert(s.longBalance >= 0);
1043         s.nav = _computeNavForTokens(s.currentTokenState.tokenPrice, _totalSupply());
1044 
1045         s._sendMargin(tokenMargin);
1046     }
1047 
1048     function _dispute(TDS.Storage storage s, uint depositMargin) external onlySponsor(s) {
1049         require(
1050             s.state == TDS.State.Live,
1051             "Contract must be Live to dispute"
1052         );
1053 
1054         uint requiredDeposit = _safeUintCast(_takePercentage(s._getRequiredMargin(s.currentTokenState), s.fixedParameters.disputeDeposit));
1055 
1056         uint sendInconsistencyRefund = s._pullSentMargin(depositMargin);
1057 
1058         require(depositMargin >= requiredDeposit);
1059         uint overpaymentRefund = depositMargin.sub(requiredDeposit);
1060 
1061         s.state = TDS.State.Disputed;
1062         s.endTime = s.currentTokenState.time;
1063         s.disputeInfo.disputedNav = s.nav;
1064         s.disputeInfo.deposit = requiredDeposit;
1065 
1066         // Store the default penalty in case the dispute pushes the sponsor into default.
1067         s.defaultPenaltyAmount = s._computeDefaultPenalty();
1068         emit Disputed(s.fixedParameters.symbol, s.endTime, s.nav);
1069 
1070         s._requestOraclePrice(s.endTime);
1071 
1072         // Add the two types of refunds:
1073         // 1. The refund for ETH sent if it was > depositMargin.
1074         // 2. The refund for depositMargin > requiredDeposit.
1075         s._sendMargin(sendInconsistencyRefund.add(overpaymentRefund));
1076     }
1077 
1078     function _withdraw(TDS.Storage storage s, uint amount) external onlySponsor(s) {
1079         // Remargin before allowing a withdrawal, but only if in the live state.
1080         if (s.state == TDS.State.Live) {
1081             s._remarginInternal();
1082         }
1083 
1084         // Make sure either in Live or Settled after any necessary remargin.
1085         require(s.state == TDS.State.Live || s.state == TDS.State.Settled);
1086 
1087         // If the contract has been settled or is in prefunded state then can
1088         // withdraw up to full balance. If the contract is in live state then
1089         // must leave at least the required margin. Not allowed to withdraw in
1090         // other states.
1091         int withdrawableAmount;
1092         if (s.state == TDS.State.Settled) {
1093             withdrawableAmount = s.shortBalance;
1094         } else {
1095             // Update throttling snapshot and verify that this withdrawal doesn't go past the throttle limit.
1096             uint currentTime = s.currentTokenState.time;
1097             if (s.withdrawThrottle.startTime <= currentTime.sub(SECONDS_PER_DAY)) {
1098                 // We've passed the previous s.withdrawThrottle window. Start new one.
1099                 s.withdrawThrottle.startTime = currentTime;
1100                 s.withdrawThrottle.remainingWithdrawal = _takePercentage(_safeUintCast(s.shortBalance), s.fixedParameters.withdrawLimit);
1101             }
1102 
1103             int marginMaxWithdraw = s.shortBalance.sub(s._getRequiredMargin(s.currentTokenState));
1104             int throttleMaxWithdraw = _safeIntCast(s.withdrawThrottle.remainingWithdrawal);
1105 
1106             // Take the smallest of the two withdrawal limits.
1107             withdrawableAmount = throttleMaxWithdraw < marginMaxWithdraw ? throttleMaxWithdraw : marginMaxWithdraw;
1108 
1109             // Note: this line alone implicitly ensures the withdrawal throttle is not violated, but the above
1110             // ternary is more explicit.
1111             s.withdrawThrottle.remainingWithdrawal = s.withdrawThrottle.remainingWithdrawal.sub(amount);
1112         }
1113 
1114         // Can only withdraw the allowed amount.
1115         require(
1116             withdrawableAmount >= _safeIntCast(amount),
1117             "Attempting to withdraw more than allowed"
1118         );
1119 
1120         // Transfer amount - Note: important to `-=` before the send so that the
1121         // function can not be called multiple times while waiting for transfer
1122         // to return.
1123         s.shortBalance = s.shortBalance.sub(_safeIntCast(amount));
1124         emit Withdrawal(s.fixedParameters.symbol, amount);
1125         s._sendMargin(amount);
1126     }
1127 
1128     function _acceptPriceAndSettle(TDS.Storage storage s) external onlySponsor(s) {
1129         // Right now, only confirming prices in the defaulted state.
1130         require(s.state == TDS.State.Defaulted);
1131 
1132         // Remargin on agreed upon price.
1133         s._settleAgreedPrice();
1134     }
1135 
1136     function _setApDelegate(TDS.Storage storage s, address _apDelegate) external onlySponsor(s) {
1137         s.externalAddresses.apDelegate = _apDelegate;
1138     }
1139 
1140     // Moves the contract into the Emergency state, where it waits on an Oracle price for the most recent remargin time.
1141     function _emergencyShutdown(TDS.Storage storage s) external onlyAdmin(s) {
1142         require(s.state == TDS.State.Live);
1143         s.state = TDS.State.Emergency;
1144         s.endTime = s.currentTokenState.time;
1145         s.defaultPenaltyAmount = s._computeDefaultPenalty();
1146         emit EmergencyShutdownTransition(s.fixedParameters.symbol, s.endTime);
1147         s._requestOraclePrice(s.endTime);
1148     }
1149 
1150     function _settle(TDS.Storage storage s) external {
1151         s._settleInternal();
1152     }
1153 
1154     function _createTokens(TDS.Storage storage s, uint marginForPurchase, uint tokensToPurchase) external onlySponsorOrApDelegate(s) {
1155         // Returns any refund due to sending more margin than the argument indicated (should only be able to happen in
1156         // the ETH case).
1157         uint refund = s._pullSentMargin(marginForPurchase);
1158 
1159         // The _createTokensInternal call returns any refund due to the amount sent being larger than the amount
1160         // required to purchase the tokens, so we add that to the running refund.
1161         refund = refund.add(s._createTokensInternal(tokensToPurchase, marginForPurchase));
1162 
1163         // Send the accumulated refund.
1164         s._sendMargin(refund);
1165     }
1166 
1167     function _deposit(TDS.Storage storage s, uint marginToDeposit) external onlySponsor(s) {
1168         // Only allow the s.externalAddresses.sponsor to deposit margin.
1169         uint refund = s._pullSentMargin(marginToDeposit);
1170         s._depositInternal(marginToDeposit);
1171 
1172         // Send any refund due to sending more margin than the argument indicated (should only be able to happen in the
1173         // ETH case).
1174         s._sendMargin(refund);
1175     }
1176 
1177     // Returns the expected net asset value (NAV) of the contract using the latest available Price Feed price.
1178     function _calcNAV(TDS.Storage storage s) external view returns (int navNew) {
1179         (TDS.TokenState memory newTokenState, ) = s._calcNewTokenStateAndBalance();
1180         navNew = _computeNavForTokens(newTokenState.tokenPrice, _totalSupply());
1181     }
1182 
1183     // Returns the expected value of each the outstanding tokens of the contract using the latest available Price Feed
1184     // price.
1185     function _calcTokenValue(TDS.Storage storage s) external view returns (int newTokenValue) {
1186         (TDS.TokenState memory newTokenState,) = s._calcNewTokenStateAndBalance();
1187         newTokenValue = newTokenState.tokenPrice;
1188     }
1189 
1190     // Returns the expected balance of the short margin account using the latest available Price Feed price.
1191     function _calcShortMarginBalance(TDS.Storage storage s) external view returns (int newShortMarginBalance) {
1192         (, newShortMarginBalance) = s._calcNewTokenStateAndBalance();
1193     }
1194 
1195     function _calcExcessMargin(TDS.Storage storage s) external view returns (int newExcessMargin) {
1196         (TDS.TokenState memory newTokenState, int newShortMarginBalance) = s._calcNewTokenStateAndBalance();
1197         // If the contract is in/will be moved to a settled state, the margin requirement will be 0.
1198         int requiredMargin = newTokenState.time >= s.endTime ? 0 : s._getRequiredMargin(newTokenState);
1199         return newShortMarginBalance.sub(requiredMargin);
1200     }
1201 
1202     function _getCurrentRequiredMargin(TDS.Storage storage s) external view returns (int requiredMargin) {
1203         if (s.state == TDS.State.Settled) {
1204             // No margin needs to be maintained when the contract is settled.
1205             return 0;
1206         }
1207 
1208          return s._getRequiredMargin(s.currentTokenState);
1209     }
1210 
1211     function _canBeSettled(TDS.Storage storage s) external view returns (bool canBeSettled) {
1212         TDS.State currentState = s.state;
1213 
1214         if (currentState == TDS.State.Settled) {
1215             return false;
1216         }
1217 
1218         // Technically we should also check if price will default the contract, but that isn't a normal flow of
1219         // operations that we want to simulate: we want to discourage the sponsor remargining into a default.
1220         (uint priceFeedTime, ) = s._getLatestPrice();
1221         if (currentState == TDS.State.Live && (priceFeedTime < s.endTime)) {
1222             return false;
1223         }
1224 
1225         return s.externalAddresses.oracle.hasPrice(s.fixedParameters.product, s.endTime);
1226     }
1227 
1228     function _getUpdatedUnderlyingPrice(TDS.Storage storage s) external view returns (int underlyingPrice, uint time) {
1229         (TDS.TokenState memory newTokenState, ) = s._calcNewTokenStateAndBalance();
1230         return (newTokenState.underlyingPrice, newTokenState.time);
1231     }
1232 
1233     function _calcNewTokenStateAndBalance(TDS.Storage storage s) internal view returns (TDS.TokenState memory newTokenState, int newShortMarginBalance)
1234     {
1235         // TODO: there's a lot of repeated logic in this method from elsewhere in the contract. It should be extracted
1236         // so the logic can be written once and used twice. However, much of this was written post-audit, so it was
1237         // deemed preferable not to modify any state changing code that could potentially introduce new security
1238         // bugs. This should be done before the next contract audit.
1239 
1240         if (s.state == TDS.State.Settled) {
1241             // If the contract is Settled, just return the current contract state.
1242             return (s.currentTokenState, s.shortBalance);
1243         }
1244 
1245         // Grab the price feed pricetime.
1246         (uint priceFeedTime, int priceFeedPrice) = s._getLatestPrice();
1247 
1248         bool isContractLive = s.state == TDS.State.Live;
1249         bool isContractPostExpiry = priceFeedTime >= s.endTime;
1250 
1251         // If the time hasn't advanced since the last remargin, short circuit and return the most recently computed values.
1252         if (isContractLive && priceFeedTime <= s.currentTokenState.time) {
1253             return (s.currentTokenState, s.shortBalance);
1254         }
1255 
1256         // Determine which previous price state to use when computing the new NAV.
1257         // If the contract is live, we use the reference for the linear return type or if the contract will immediately
1258         // move to expiry. 
1259         bool shouldUseReferenceTokenState = isContractLive &&
1260             (s.fixedParameters.returnType == TokenizedDerivativeParams.ReturnType.Linear || isContractPostExpiry);
1261         TDS.TokenState memory lastTokenState = shouldUseReferenceTokenState ? s.referenceTokenState : s.currentTokenState;
1262 
1263         // Use the oracle settlement price/time if the contract is frozen or will move to expiry on the next remargin.
1264         (uint recomputeTime, int recomputePrice) = !isContractLive || isContractPostExpiry ?
1265             (s.endTime, s.externalAddresses.oracle.getPrice(s.fixedParameters.product, s.endTime)) :
1266             (priceFeedTime, priceFeedPrice);
1267 
1268         // Init the returned short balance to the current short balance.
1269         newShortMarginBalance = s.shortBalance;
1270 
1271         // Subtract the oracle fees from the short balance.
1272         newShortMarginBalance = isContractLive ?
1273             newShortMarginBalance.sub(
1274                 _safeIntCast(s._computeExpectedOracleFees(s.currentTokenState.time, recomputeTime))) :
1275             newShortMarginBalance;
1276 
1277         // Compute the new NAV
1278         newTokenState = s._computeNewTokenState(lastTokenState, recomputePrice, recomputeTime);
1279         int navNew = _computeNavForTokens(newTokenState.tokenPrice, _totalSupply());
1280         newShortMarginBalance = newShortMarginBalance.sub(_getLongDiff(navNew, s.longBalance, newShortMarginBalance));
1281 
1282         // If the contract is frozen or will move into expiry, we need to settle it, which means adding the default
1283         // penalty and dispute deposit if necessary.
1284         if (!isContractLive || isContractPostExpiry) {
1285             // Subtract default penalty (if necessary) from the short balance.
1286             bool inDefault = !s._satisfiesMarginRequirement(newShortMarginBalance, newTokenState);
1287             if (inDefault) {
1288                 int expectedDefaultPenalty = isContractLive ? s._computeDefaultPenalty() : s._getDefaultPenalty();
1289                 int defaultPenalty = (newShortMarginBalance < expectedDefaultPenalty) ?
1290                     newShortMarginBalance :
1291                     expectedDefaultPenalty;
1292                 newShortMarginBalance = newShortMarginBalance.sub(defaultPenalty);
1293             }
1294 
1295             // Add the dispute deposit to the short balance if necessary.
1296             if (s.state == TDS.State.Disputed && navNew != s.disputeInfo.disputedNav) {
1297                 int depositValue = _safeIntCast(s.disputeInfo.deposit);
1298                 newShortMarginBalance = newShortMarginBalance.add(depositValue);
1299             }
1300         }
1301     }
1302 
1303     function _computeInitialNav(TDS.Storage storage s, int latestUnderlyingPrice, uint latestTime, uint startingTokenPrice)
1304         internal
1305         returns (int navNew)
1306     {
1307         int unitNav = _safeIntCast(startingTokenPrice);
1308         s.referenceTokenState = TDS.TokenState(latestUnderlyingPrice, unitNav, latestTime);
1309         s.currentTokenState = TDS.TokenState(latestUnderlyingPrice, unitNav, latestTime);
1310         // Starting NAV is always 0 in the TokenizedDerivative case.
1311         navNew = 0;
1312     }
1313 
1314     function _remargin(TDS.Storage storage s) external onlySponsorOrAdmin(s) {
1315         s._remarginInternal();
1316     }
1317 
1318     function _withdrawUnexpectedErc20(TDS.Storage storage s, address erc20Address, uint amount) external onlySponsor(s) {
1319         if(address(s.externalAddresses.marginCurrency) == erc20Address) {
1320             uint currentBalance = s.externalAddresses.marginCurrency.balanceOf(address(this));
1321             int totalBalances = s.shortBalance.add(s.longBalance);
1322             assert(totalBalances >= 0);
1323             uint withdrawableAmount = currentBalance.sub(_safeUintCast(totalBalances)).sub(s.disputeInfo.deposit);
1324             require(withdrawableAmount >= amount);
1325         }
1326 
1327         IERC20 erc20 = IERC20(erc20Address);
1328         require(erc20.transfer(msg.sender, amount));
1329     }
1330 
1331     function _setExternalAddresses(TDS.Storage storage s, TokenizedDerivativeParams.ConstructorParams memory params) internal {
1332 
1333         // Note: not all "ERC20" tokens conform exactly to this interface (BNB, OMG, etc). The most common way that
1334         // tokens fail to conform is that they do not return a bool from certain state-changing operations. This
1335         // contract was not designed to work with those tokens because of the additional complexity they would
1336         // introduce.
1337         s.externalAddresses.marginCurrency = IERC20(params.marginCurrency);
1338 
1339         s.externalAddresses.oracle = OracleInterface(params.oracle);
1340         s.externalAddresses.store = StoreInterface(params.store);
1341         s.externalAddresses.priceFeed = PriceFeedInterface(params.priceFeed);
1342         s.externalAddresses.returnCalculator = ReturnCalculatorInterface(params.returnCalculator);
1343 
1344         // Verify that the price feed and s.externalAddresses.oracle support the given s.fixedParameters.product.
1345         require(s.externalAddresses.oracle.isIdentifierSupported(params.product));
1346         require(s.externalAddresses.priceFeed.isIdentifierSupported(params.product));
1347 
1348         s.externalAddresses.sponsor = params.sponsor;
1349         s.externalAddresses.admin = params.admin;
1350     }
1351 
1352     function _setFixedParameters(TDS.Storage storage s, TokenizedDerivativeParams.ConstructorParams memory params, string memory symbol) internal {
1353         // Ensure only valid enum values are provided.
1354         require(params.returnType == TokenizedDerivativeParams.ReturnType.Compound
1355             || params.returnType == TokenizedDerivativeParams.ReturnType.Linear);
1356 
1357         // Fee must be 0 if the returnType is linear.
1358         require(params.returnType == TokenizedDerivativeParams.ReturnType.Compound || params.fixedYearlyFee == 0);
1359 
1360         // The default penalty must be less than the required margin.
1361         require(params.defaultPenalty <= UINT_FP_SCALING_FACTOR);
1362 
1363         s.fixedParameters.returnType = params.returnType;
1364         s.fixedParameters.defaultPenalty = params.defaultPenalty;
1365         s.fixedParameters.product = params.product;
1366         s.fixedParameters.fixedFeePerSecond = params.fixedYearlyFee.div(SECONDS_PER_YEAR);
1367         s.fixedParameters.disputeDeposit = params.disputeDeposit;
1368         s.fixedParameters.supportedMove = params.supportedMove;
1369         s.fixedParameters.withdrawLimit = params.withdrawLimit;
1370         s.fixedParameters.creationTime = params.creationTime;
1371         s.fixedParameters.symbol = symbol;
1372     }
1373 
1374     // _remarginInternal() allows other functions to call remargin internally without satisfying permission checks for
1375     // _remargin().
1376     function _remarginInternal(TDS.Storage storage s) internal {
1377         // If the state is not live, remargining does not make sense.
1378         require(s.state == TDS.State.Live);
1379 
1380         (uint latestTime, int latestPrice) = s._getLatestPrice();
1381         // Checks whether contract has ended.
1382         if (latestTime <= s.currentTokenState.time) {
1383             // If the price feed hasn't advanced, remargining should be a no-op.
1384             return;
1385         }
1386 
1387         // Save the penalty using the current state in case it needs to be used.
1388         int potentialPenaltyAmount = s._computeDefaultPenalty();
1389 
1390         if (latestTime >= s.endTime) {
1391             s.state = TDS.State.Expired;
1392             emit Expired(s.fixedParameters.symbol, s.endTime);
1393 
1394             // Applies the same update a second time to effectively move the current state to the reference state.
1395             int recomputedNav = s._computeNav(s.currentTokenState.underlyingPrice, s.currentTokenState.time);
1396             assert(recomputedNav == s.nav);
1397 
1398             uint feeAmount = s._deductOracleFees(s.currentTokenState.time, s.endTime);
1399 
1400             // Save the precomputed default penalty in case the expiry price pushes the sponsor into default.
1401             s.defaultPenaltyAmount = potentialPenaltyAmount;
1402 
1403             // We have no idea what the price was, exactly at s.endTime, so we can't set
1404             // s.currentTokenState, or update the nav, or do anything.
1405             s._requestOraclePrice(s.endTime);
1406             s._payOracleFees(feeAmount);
1407             return;
1408         }
1409         uint feeAmount = s._deductOracleFees(s.currentTokenState.time, latestTime);
1410 
1411         // Update nav of contract.
1412         int navNew = s._computeNav(latestPrice, latestTime);
1413 
1414         // Update the balances of the contract.
1415         s._updateBalances(navNew);
1416 
1417         // Make sure contract has not moved into default.
1418         bool inDefault = !s._satisfiesMarginRequirement(s.shortBalance, s.currentTokenState);
1419         if (inDefault) {
1420             s.state = TDS.State.Defaulted;
1421             s.defaultPenaltyAmount = potentialPenaltyAmount;
1422             s.endTime = latestTime; // Change end time to moment when default occurred.
1423             emit Default(s.fixedParameters.symbol, latestTime, s.nav);
1424             s._requestOraclePrice(latestTime);
1425         }
1426 
1427         s._payOracleFees(feeAmount);
1428     }
1429 
1430     function _createTokensInternal(TDS.Storage storage s, uint tokensToPurchase, uint navSent) internal returns (uint refund) {
1431         s._remarginInternal();
1432 
1433         // Verify that remargining didn't push the contract into expiry or default.
1434         require(s.state == TDS.State.Live);
1435 
1436         int purchasedNav = _computeNavForTokens(s.currentTokenState.tokenPrice, tokensToPurchase);
1437 
1438         if (purchasedNav < 0) {
1439             purchasedNav = 0;
1440         }
1441 
1442         // Ensures that requiredNav >= navSent.
1443         refund = navSent.sub(_safeUintCast(purchasedNav));
1444 
1445         s.longBalance = s.longBalance.add(purchasedNav);
1446 
1447         ExpandedIERC20 thisErc20Token = ExpandedIERC20(address(this));
1448 
1449         thisErc20Token.mint(msg.sender, tokensToPurchase);
1450         emit TokensCreated(s.fixedParameters.symbol, tokensToPurchase);
1451 
1452         s.nav = _computeNavForTokens(s.currentTokenState.tokenPrice, _totalSupply());
1453 
1454         // Make sure this still satisfies the margin requirement.
1455         require(s._satisfiesMarginRequirement(s.shortBalance, s.currentTokenState));
1456     }
1457 
1458     function _depositInternal(TDS.Storage storage s, uint value) internal {
1459         // Make sure that we are in a "depositable" state.
1460         require(s.state == TDS.State.Live);
1461         s.shortBalance = s.shortBalance.add(_safeIntCast(value));
1462         emit Deposited(s.fixedParameters.symbol, value);
1463     }
1464 
1465     function _settleInternal(TDS.Storage storage s) internal {
1466         TDS.State startingState = s.state;
1467         require(startingState == TDS.State.Disputed || startingState == TDS.State.Expired
1468                 || startingState == TDS.State.Defaulted || startingState == TDS.State.Emergency);
1469         s._settleVerifiedPrice();
1470         if (startingState == TDS.State.Disputed) {
1471             int depositValue = _safeIntCast(s.disputeInfo.deposit);
1472             if (s.nav != s.disputeInfo.disputedNav) {
1473                 s.shortBalance = s.shortBalance.add(depositValue);
1474             } else {
1475                 s.longBalance = s.longBalance.add(depositValue);
1476             }
1477         }
1478     }
1479 
1480     // Deducts the fees from the margin account.
1481     function _deductOracleFees(TDS.Storage storage s, uint lastTimeOracleFeesPaid, uint currentTime) internal returns (uint feeAmount) {
1482         feeAmount = s._computeExpectedOracleFees(lastTimeOracleFeesPaid, currentTime);
1483         s.shortBalance = s.shortBalance.sub(_safeIntCast(feeAmount));
1484         // If paying the Oracle fee reduces the held margin below requirements, the rest of remargin() will default the
1485         // contract.
1486     }
1487 
1488     // Pays out the fees to the Oracle.
1489     function _payOracleFees(TDS.Storage storage s, uint feeAmount) internal {
1490         if (feeAmount == 0) {
1491             return;
1492         }
1493 
1494         if (address(s.externalAddresses.marginCurrency) == address(0x0)) {
1495             s.externalAddresses.store.payOracleFees.value(feeAmount)();
1496         } else {
1497             require(s.externalAddresses.marginCurrency.approve(address(s.externalAddresses.store), feeAmount));
1498             s.externalAddresses.store.payOracleFeesErc20(address(s.externalAddresses.marginCurrency));
1499         }
1500     }
1501 
1502     function _computeExpectedOracleFees(TDS.Storage storage s, uint lastTimeOracleFeesPaid, uint currentTime)
1503         internal
1504         view
1505         returns (uint feeAmount)
1506     {
1507         // The profit from corruption is set as the max(longBalance, shortBalance).
1508         int pfc = s.shortBalance < s.longBalance ? s.longBalance : s.shortBalance;
1509         uint expectedFeeAmount = s.externalAddresses.store.computeOracleFees(lastTimeOracleFeesPaid, currentTime, _safeUintCast(pfc));
1510 
1511         // Ensure the fee returned can actually be paid by the short margin account.
1512         uint shortBalance = _safeUintCast(s.shortBalance);
1513         return (shortBalance < expectedFeeAmount) ? shortBalance : expectedFeeAmount;
1514     }
1515 
1516     function _computeNewTokenState(TDS.Storage storage s,
1517         TDS.TokenState memory beginningTokenState, int latestUnderlyingPrice, uint recomputeTime)
1518         internal
1519         view
1520         returns (TDS.TokenState memory newTokenState)
1521     {
1522         int underlyingReturn = s.externalAddresses.returnCalculator.computeReturn(
1523             beginningTokenState.underlyingPrice, latestUnderlyingPrice);
1524         int tokenReturn = underlyingReturn.sub(
1525             _safeIntCast(s.fixedParameters.fixedFeePerSecond.mul(recomputeTime.sub(beginningTokenState.time))));
1526         int tokenMultiplier = tokenReturn.add(INT_FP_SCALING_FACTOR);
1527         
1528         // In the compound case, don't allow the token price to go below 0.
1529         if (s.fixedParameters.returnType == TokenizedDerivativeParams.ReturnType.Compound && tokenMultiplier < 0) {
1530             tokenMultiplier = 0;
1531         }
1532 
1533         int newTokenPrice = _takePercentage(beginningTokenState.tokenPrice, tokenMultiplier);
1534         newTokenState = TDS.TokenState(latestUnderlyingPrice, newTokenPrice, recomputeTime);
1535     }
1536 
1537     function _satisfiesMarginRequirement(TDS.Storage storage s, int balance, TDS.TokenState memory tokenState)
1538         internal
1539         view
1540         returns (bool doesSatisfyRequirement) 
1541     {
1542         return s._getRequiredMargin(tokenState) <= balance;
1543     }
1544 
1545     function _requestOraclePrice(TDS.Storage storage s, uint requestedTime) internal {
1546         uint expectedTime = s.externalAddresses.oracle.requestPrice(s.fixedParameters.product, requestedTime);
1547         if (expectedTime == 0) {
1548             // The Oracle price is already available, settle the contract right away.
1549             s._settleInternal();
1550         }
1551     }
1552 
1553     function _getLatestPrice(TDS.Storage storage s) internal view returns (uint latestTime, int latestUnderlyingPrice) {
1554         (latestTime, latestUnderlyingPrice) = s.externalAddresses.priceFeed.latestPrice(s.fixedParameters.product);
1555         require(latestTime != 0);
1556     }
1557 
1558     function _computeNav(TDS.Storage storage s, int latestUnderlyingPrice, uint latestTime) internal returns (int navNew) {
1559         if (s.fixedParameters.returnType == TokenizedDerivativeParams.ReturnType.Compound) {
1560             navNew = s._computeCompoundNav(latestUnderlyingPrice, latestTime);
1561         } else {
1562             assert(s.fixedParameters.returnType == TokenizedDerivativeParams.ReturnType.Linear);
1563             navNew = s._computeLinearNav(latestUnderlyingPrice, latestTime);
1564         }
1565     }
1566 
1567     function _computeCompoundNav(TDS.Storage storage s, int latestUnderlyingPrice, uint latestTime) internal returns (int navNew) {
1568         s.referenceTokenState = s.currentTokenState;
1569         s.currentTokenState = s._computeNewTokenState(s.currentTokenState, latestUnderlyingPrice, latestTime);
1570         navNew = _computeNavForTokens(s.currentTokenState.tokenPrice, _totalSupply());
1571         emit NavUpdated(s.fixedParameters.symbol, navNew, s.currentTokenState.tokenPrice);
1572     }
1573 
1574     function _computeLinearNav(TDS.Storage storage s, int latestUnderlyingPrice, uint latestTime) internal returns (int navNew) {
1575         // Only update the time - don't update the prices becuase all price changes are relative to the initial price.
1576         s.referenceTokenState.time = s.currentTokenState.time;
1577         s.currentTokenState = s._computeNewTokenState(s.referenceTokenState, latestUnderlyingPrice, latestTime);
1578         navNew = _computeNavForTokens(s.currentTokenState.tokenPrice, _totalSupply());
1579         emit NavUpdated(s.fixedParameters.symbol, navNew, s.currentTokenState.tokenPrice);
1580     }
1581 
1582     function _recomputeNav(TDS.Storage storage s, int oraclePrice, uint recomputeTime) internal returns (int navNew) {
1583         // We're updating `last` based on what the Oracle has told us.
1584         assert(s.endTime == recomputeTime);
1585         s.currentTokenState = s._computeNewTokenState(s.referenceTokenState, oraclePrice, recomputeTime);
1586         navNew = _computeNavForTokens(s.currentTokenState.tokenPrice, _totalSupply());
1587         emit NavUpdated(s.fixedParameters.symbol, navNew, s.currentTokenState.tokenPrice);
1588     }
1589 
1590     // Function is internally only called by `_settleAgreedPrice` or `_settleVerifiedPrice`. This function handles all 
1591     // of the settlement logic including assessing penalties and then moves the state to `Settled`.
1592     function _settleWithPrice(TDS.Storage storage s, int price) internal {
1593 
1594         // Remargin at whatever price we're using (verified or unverified).
1595         s._updateBalances(s._recomputeNav(price, s.endTime));
1596 
1597         bool inDefault = !s._satisfiesMarginRequirement(s.shortBalance, s.currentTokenState);
1598 
1599         if (inDefault) {
1600             int expectedDefaultPenalty = s._getDefaultPenalty();
1601             int penalty = (s.shortBalance < expectedDefaultPenalty) ?
1602                 s.shortBalance :
1603                 expectedDefaultPenalty;
1604 
1605             s.shortBalance = s.shortBalance.sub(penalty);
1606             s.longBalance = s.longBalance.add(penalty);
1607         }
1608 
1609         s.state = TDS.State.Settled;
1610         emit Settled(s.fixedParameters.symbol, s.endTime, s.nav);
1611     }
1612 
1613     function _updateBalances(TDS.Storage storage s, int navNew) internal {
1614         // Compute difference -- Add the difference to owner and subtract
1615         // from counterparty. Then update nav state variable.
1616         int longDiff = _getLongDiff(navNew, s.longBalance, s.shortBalance);
1617         s.nav = navNew;
1618 
1619         s.longBalance = s.longBalance.add(longDiff);
1620         s.shortBalance = s.shortBalance.sub(longDiff);
1621     }
1622 
1623     function _getDefaultPenalty(TDS.Storage storage s) internal view returns (int penalty) {
1624         return s.defaultPenaltyAmount;
1625     }
1626 
1627     function _computeDefaultPenalty(TDS.Storage storage s) internal view returns (int penalty) {
1628         return _takePercentage(s._getRequiredMargin(s.currentTokenState), s.fixedParameters.defaultPenalty);
1629     }
1630 
1631     function _getRequiredMargin(TDS.Storage storage s, TDS.TokenState memory tokenState)
1632         internal
1633         view
1634         returns (int requiredMargin)
1635     {
1636         int leverageMagnitude = _absoluteValue(s.externalAddresses.returnCalculator.leverage());
1637 
1638         int effectiveNotional;
1639         if (s.fixedParameters.returnType == TokenizedDerivativeParams.ReturnType.Linear) {
1640             int effectiveUnitsOfUnderlying = _safeIntCast(_totalSupply().mul(s.fixedParameters.initialTokenUnderlyingRatio).div(UINT_FP_SCALING_FACTOR)).mul(leverageMagnitude);
1641             effectiveNotional = effectiveUnitsOfUnderlying.mul(tokenState.underlyingPrice).div(INT_FP_SCALING_FACTOR);
1642         } else {
1643             int currentNav = _computeNavForTokens(tokenState.tokenPrice, _totalSupply());
1644             effectiveNotional = currentNav.mul(leverageMagnitude);
1645         }
1646 
1647         // Take the absolute value of the notional since a negative notional has similar risk properties to a positive
1648         // notional of the same size, and, therefore, requires the same margin.
1649         requiredMargin = _takePercentage(_absoluteValue(effectiveNotional), s.fixedParameters.supportedMove);
1650     }
1651 
1652     function _pullSentMargin(TDS.Storage storage s, uint expectedMargin) internal returns (uint refund) {
1653         if (address(s.externalAddresses.marginCurrency) == address(0x0)) {
1654             // Refund is any amount of ETH that was sent that was above the amount that was expected.
1655             // Note: SafeMath will force a revert if msg.value < expectedMargin.
1656             return msg.value.sub(expectedMargin);
1657         } else {
1658             // If we expect an ERC20 token, no ETH should be sent.
1659             require(msg.value == 0);
1660             _pullAuthorizedTokens(s.externalAddresses.marginCurrency, expectedMargin);
1661 
1662             // There is never a refund in the ERC20 case since we use the argument to determine how much to "pull".
1663             return 0;
1664         }
1665     }
1666 
1667     function _sendMargin(TDS.Storage storage s, uint amount) internal {
1668         // There's no point in attempting a send if there's nothing to send.
1669         if (amount == 0) {
1670             return;
1671         }
1672 
1673         if (address(s.externalAddresses.marginCurrency) == address(0x0)) {
1674             msg.sender.transfer(amount);
1675         } else {
1676             require(s.externalAddresses.marginCurrency.transfer(msg.sender, amount));
1677         }
1678     }
1679 
1680     function _settleAgreedPrice(TDS.Storage storage s) internal {
1681         int agreedPrice = s.currentTokenState.underlyingPrice;
1682 
1683         s._settleWithPrice(agreedPrice);
1684     }
1685 
1686     function _settleVerifiedPrice(TDS.Storage storage s) internal {
1687         int oraclePrice = s.externalAddresses.oracle.getPrice(s.fixedParameters.product, s.endTime);
1688         s._settleWithPrice(oraclePrice);
1689     }
1690 
1691     function _pullAuthorizedTokens(IERC20 erc20, uint amountToPull) private {
1692         // If nothing is being pulled, there's no point in calling a transfer.
1693         if (amountToPull > 0) {
1694             require(erc20.transferFrom(msg.sender, address(this), amountToPull));
1695         }
1696     }
1697 
1698     // Gets the change in balance for the long side.
1699     // Note: there's a function for this because signage is tricky here, and it must be done the same everywhere.
1700     function _getLongDiff(int navNew, int longBalance, int shortBalance) private pure returns (int longDiff) {
1701         int newLongBalance = navNew;
1702 
1703         // Long balance cannot go below zero.
1704         if (newLongBalance < 0) {
1705             newLongBalance = 0;
1706         }
1707 
1708         longDiff = newLongBalance.sub(longBalance);
1709 
1710         // Cannot pull more margin from the short than is available.
1711         if (longDiff > shortBalance) {
1712             longDiff = shortBalance;
1713         }
1714     }
1715 
1716     function _computeNavForTokens(int tokenPrice, uint numTokens) private pure returns (int navNew) {
1717         int navPreDivision = _safeIntCast(numTokens).mul(tokenPrice);
1718         navNew = navPreDivision.div(INT_FP_SCALING_FACTOR);
1719 
1720         // The navNew division above truncates by default. Instead, we prefer to ceil this value to ensure tokens
1721         // cannot be purchased or backed with less than their true value.
1722         if ((navPreDivision % INT_FP_SCALING_FACTOR) != 0) {
1723             navNew = navNew.add(1);
1724         }
1725     }
1726 
1727     function _totalSupply() private view returns (uint totalSupply) {
1728         ExpandedIERC20 thisErc20Token = ExpandedIERC20(address(this));
1729         return thisErc20Token.totalSupply();
1730     }
1731 
1732     function _takePercentage(uint value, uint percentage) private pure returns (uint result) {
1733         return value.mul(percentage).div(UINT_FP_SCALING_FACTOR);
1734     }
1735 
1736     function _takePercentage(int value, uint percentage) private pure returns (int result) {
1737         return value.mul(_safeIntCast(percentage)).div(INT_FP_SCALING_FACTOR);
1738     }
1739 
1740     function _takePercentage(int value, int percentage) private pure returns (int result) {
1741         return value.mul(percentage).div(INT_FP_SCALING_FACTOR);
1742     }
1743 
1744     function _absoluteValue(int value) private pure returns (int result) {
1745         return value < 0 ? value.mul(-1) : value;
1746     }
1747 
1748     function _safeIntCast(uint value) private pure returns (int result) {
1749         require(value <= INT_MAX);
1750         return int(value);
1751     }
1752 
1753     function _safeUintCast(int value) private pure returns (uint result) {
1754         require(value >= 0);
1755         return uint(value);
1756     }
1757 
1758     // Note that we can't have the symbol parameter be `indexed` due to:
1759     // TypeError: Indexed reference types cannot yet be used with ABIEncoderV2.
1760     // An event emitted when the NAV of the contract changes.
1761     event NavUpdated(string symbol, int newNav, int newTokenPrice);
1762     // An event emitted when the contract enters the Default state on a remargin.
1763     event Default(string symbol, uint defaultTime, int defaultNav);
1764     // An event emitted when the contract settles.
1765     event Settled(string symbol, uint settleTime, int finalNav);
1766     // An event emitted when the contract expires.
1767     event Expired(string symbol, uint expiryTime);
1768     // An event emitted when the contract's NAV is disputed by the sponsor.
1769     event Disputed(string symbol, uint timeDisputed, int navDisputed);
1770     // An event emitted when the contract enters emergency shutdown.
1771     event EmergencyShutdownTransition(string symbol, uint shutdownTime);
1772     // An event emitted when tokens are created.
1773     event TokensCreated(string symbol, uint numTokensCreated);
1774     // An event emitted when tokens are redeemed.
1775     event TokensRedeemed(string symbol, uint numTokensRedeemed);
1776     // An event emitted when margin currency is deposited.
1777     event Deposited(string symbol, uint amount);
1778     // An event emitted when margin currency is withdrawn.
1779     event Withdrawal(string symbol, uint amount);
1780 }
1781 
1782 // TODO(mrice32): make this and TotalReturnSwap derived classes of a single base to encap common functionality.
1783 contract TokenizedDerivative is ERC20, AdminInterface, ExpandedIERC20 {
1784     using TokenizedDerivativeUtils for TDS.Storage;
1785 
1786     // Note: these variables are to give ERC20 consumers information about the token.
1787     string public name;
1788     string public symbol;
1789     uint8 public constant decimals = 18; // solhint-disable-line const-name-snakecase
1790 
1791     TDS.Storage public derivativeStorage;
1792 
1793     constructor(
1794         TokenizedDerivativeParams.ConstructorParams memory params,
1795         string memory _name,
1796         string memory _symbol
1797     ) public {
1798         // Set token properties.
1799         name = _name;
1800         symbol = _symbol;
1801 
1802         // Initialize the contract.
1803         derivativeStorage._initialize(params, _symbol);
1804     }
1805 
1806     // Creates tokens with sent margin and returns additional margin.
1807     function createTokens(uint marginForPurchase, uint tokensToPurchase) external payable {
1808         derivativeStorage._createTokens(marginForPurchase, tokensToPurchase);
1809     }
1810 
1811     // Creates tokens with sent margin and deposits additional margin in short account.
1812     function depositAndCreateTokens(uint marginForPurchase, uint tokensToPurchase) external payable {
1813         derivativeStorage._depositAndCreateTokens(marginForPurchase, tokensToPurchase);
1814     }
1815 
1816     // Redeems tokens for margin currency.
1817     function redeemTokens(uint tokensToRedeem) external {
1818         derivativeStorage._redeemTokens(tokensToRedeem);
1819     }
1820 
1821     // Triggers a price dispute for the most recent remargin time.
1822     function dispute(uint depositMargin) external payable {
1823         derivativeStorage._dispute(depositMargin);
1824     }
1825 
1826     // Withdraws `amount` from short margin account.
1827     function withdraw(uint amount) external {
1828         derivativeStorage._withdraw(amount);
1829     }
1830 
1831     // Pays (Oracle and service) fees for the previous period, updates the contract NAV, moves margin between long and
1832     // short accounts to reflect the new NAV, and checks if both accounts meet minimum requirements.
1833     function remargin() external {
1834         derivativeStorage._remargin();
1835     }
1836 
1837     // Forgo the Oracle verified price and settle the contract with last remargin price. This method is only callable on
1838     // contracts in the `Defaulted` state, and the default penalty is always transferred from the short to the long
1839     // account.
1840     function acceptPriceAndSettle() external {
1841         derivativeStorage._acceptPriceAndSettle();
1842     }
1843 
1844     // Assigns an address to be the contract's Delegate AP. Replaces previous value. Set to 0x0 to indicate there is no
1845     // Delegate AP.
1846     function setApDelegate(address apDelegate) external {
1847         derivativeStorage._setApDelegate(apDelegate);
1848     }
1849 
1850     // Moves the contract into the Emergency state, where it waits on an Oracle price for the most recent remargin time.
1851     function emergencyShutdown() external {
1852         derivativeStorage._emergencyShutdown();
1853     }
1854 
1855     // Returns the expected net asset value (NAV) of the contract using the latest available Price Feed price.
1856     function calcNAV() external view returns (int navNew) {
1857         return derivativeStorage._calcNAV();
1858     }
1859 
1860     // Returns the expected value of each the outstanding tokens of the contract using the latest available Price Feed
1861     // price.
1862     function calcTokenValue() external view returns (int newTokenValue) {
1863         return derivativeStorage._calcTokenValue();
1864     }
1865 
1866     // Returns the expected balance of the short margin account using the latest available Price Feed price.
1867     function calcShortMarginBalance() external view returns (int newShortMarginBalance) {
1868         return derivativeStorage._calcShortMarginBalance();
1869     }
1870 
1871     // Returns the expected short margin in excess of the margin requirement using the latest available Price Feed
1872     // price.  Value will be negative if the short margin is expected to be below the margin requirement.
1873     function calcExcessMargin() external view returns (int excessMargin) {
1874         return derivativeStorage._calcExcessMargin();
1875     }
1876 
1877     // Returns the required margin, as of the last remargin. Note that `calcExcessMargin` uses updated values using the
1878     // latest available Price Feed price.
1879     function getCurrentRequiredMargin() external view returns (int requiredMargin) {
1880         return derivativeStorage._getCurrentRequiredMargin();
1881     }
1882 
1883     // Returns whether the contract can be settled, i.e., is it valid to call settle() now.
1884     function canBeSettled() external view returns (bool canContractBeSettled) {
1885         return derivativeStorage._canBeSettled();
1886     }
1887 
1888     // Returns the updated underlying price that was used in the calc* methods above. It will be a price feed price if
1889     // the contract is Live and will remain Live, or an Oracle price if the contract is settled/about to be settled.
1890     // Reverts if no Oracle price is available but an Oracle price is required.
1891     function getUpdatedUnderlyingPrice() external view returns (int underlyingPrice, uint time) {
1892         return derivativeStorage._getUpdatedUnderlyingPrice();
1893     }
1894 
1895     // When an Oracle price becomes available, performs a final remargin, assesses any penalties, and moves the contract
1896     // into the `Settled` state.
1897     function settle() external {
1898         derivativeStorage._settle();
1899     }
1900 
1901     // Adds the margin sent along with the call (or in the case of an ERC20 margin currency, authorized before the call)
1902     // to the short account.
1903     function deposit(uint amountToDeposit) external payable {
1904         derivativeStorage._deposit(amountToDeposit);
1905     }
1906 
1907     // Allows the sponsor to withdraw any ERC20 balance that is not the margin token.
1908     function withdrawUnexpectedErc20(address erc20Address, uint amount) external {
1909         derivativeStorage._withdrawUnexpectedErc20(erc20Address, amount);
1910     }
1911 
1912     // ExpandedIERC20 methods.
1913     modifier onlyThis {
1914         require(msg.sender == address(this));
1915         _;
1916     }
1917 
1918     // Only allow calls from this contract or its libraries to burn tokens.
1919     function burn(uint value) external onlyThis {
1920         // Only allow calls from this contract or its libraries to burn tokens.
1921         _burn(msg.sender, value);
1922     }
1923 
1924     // Only allow calls from this contract or its libraries to mint tokens.
1925     function mint(address to, uint256 value) external onlyThis {
1926         _mint(to, value);
1927     }
1928 
1929     // These events are actually emitted by TokenizedDerivativeUtils, but we unfortunately have to define the events
1930     // here as well.
1931     event NavUpdated(string symbol, int newNav, int newTokenPrice);
1932     event Default(string symbol, uint defaultTime, int defaultNav);
1933     event Settled(string symbol, uint settleTime, int finalNav);
1934     event Expired(string symbol, uint expiryTime);
1935     event Disputed(string symbol, uint timeDisputed, int navDisputed);
1936     event EmergencyShutdownTransition(string symbol, uint shutdownTime);
1937     event TokensCreated(string symbol, uint numTokensCreated);
1938     event TokensRedeemed(string symbol, uint numTokensRedeemed);
1939     event Deposited(string symbol, uint amount);
1940     event Withdrawal(string symbol, uint amount);
1941 }
1942 
1943 contract TokenizedDerivativeCreator is ContractCreator, Testable {
1944     struct Params {
1945         uint defaultPenalty; // Percentage of mergin requirement * 10^18
1946         uint supportedMove; // Expected percentage move in the underlying that the long is protected against.
1947         bytes32 product;
1948         uint fixedYearlyFee; // Percentage of nav * 10^18
1949         uint disputeDeposit; // Percentage of mergin requirement * 10^18
1950         address returnCalculator;
1951         uint startingTokenPrice;
1952         uint expiry;
1953         address marginCurrency;
1954         uint withdrawLimit; // Percentage of shortBalance * 10^18
1955         TokenizedDerivativeParams.ReturnType returnType;
1956         uint startingUnderlyingPrice;
1957         string name;
1958         string symbol;
1959     }
1960 
1961     AddressWhitelist public sponsorWhitelist;
1962     AddressWhitelist public returnCalculatorWhitelist;
1963     AddressWhitelist public marginCurrencyWhitelist;
1964 
1965     constructor(
1966         address registryAddress,
1967         address _oracleAddress,
1968         address _storeAddress,
1969         address _priceFeedAddress,
1970         address _sponsorWhitelist,
1971         address _returnCalculatorWhitelist,
1972         address _marginCurrencyWhitelist,
1973         bool _isTest
1974     )
1975         public
1976         ContractCreator(registryAddress, _oracleAddress, _storeAddress, _priceFeedAddress)
1977         Testable(_isTest)
1978     {
1979         sponsorWhitelist = AddressWhitelist(_sponsorWhitelist);
1980         returnCalculatorWhitelist = AddressWhitelist(_returnCalculatorWhitelist);
1981         marginCurrencyWhitelist = AddressWhitelist(_marginCurrencyWhitelist);
1982     }
1983 
1984     function createTokenizedDerivative(Params memory params)
1985         public
1986         returns (address derivativeAddress)
1987     {
1988         TokenizedDerivative derivative = new TokenizedDerivative(_convertParams(params), params.name, params.symbol);
1989 
1990         address[] memory parties = new address[](1);
1991         parties[0] = msg.sender;
1992 
1993         _registerContract(parties, address(derivative));
1994 
1995         return address(derivative);
1996     }
1997 
1998     // Converts createTokenizedDerivative params to TokenizedDerivative constructor params.
1999     function _convertParams(Params memory params)
2000         private
2001         view
2002         returns (TokenizedDerivativeParams.ConstructorParams memory constructorParams)
2003     {
2004         // Copy and verify externally provided variables.
2005         require(sponsorWhitelist.isOnWhitelist(msg.sender));
2006         constructorParams.sponsor = msg.sender;
2007 
2008         require(returnCalculatorWhitelist.isOnWhitelist(params.returnCalculator));
2009         constructorParams.returnCalculator = params.returnCalculator;
2010 
2011         require(marginCurrencyWhitelist.isOnWhitelist(params.marginCurrency));
2012         constructorParams.marginCurrency = params.marginCurrency;
2013 
2014         constructorParams.defaultPenalty = params.defaultPenalty;
2015         constructorParams.supportedMove = params.supportedMove;
2016         constructorParams.product = params.product;
2017         constructorParams.fixedYearlyFee = params.fixedYearlyFee;
2018         constructorParams.disputeDeposit = params.disputeDeposit;
2019         constructorParams.startingTokenPrice = params.startingTokenPrice;
2020         constructorParams.expiry = params.expiry;
2021         constructorParams.withdrawLimit = params.withdrawLimit;
2022         constructorParams.returnType = params.returnType;
2023         constructorParams.startingUnderlyingPrice = params.startingUnderlyingPrice;
2024 
2025         // Copy internal variables.
2026         constructorParams.priceFeed = priceFeedAddress;
2027         constructorParams.oracle = oracleAddress;
2028         constructorParams.store = storeAddress;
2029         constructorParams.admin = oracleAddress;
2030         constructorParams.creationTime = getCurrentTime();
2031     }
2032 }