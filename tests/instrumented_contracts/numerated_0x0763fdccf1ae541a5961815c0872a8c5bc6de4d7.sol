1 // File: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol
2 
3 pragma solidity ^0.5.0;
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
27 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
28 
29 pragma solidity ^0.5.0;
30 
31 /**
32  * @title SafeMath
33  * @dev Unsigned math operations with safety checks that revert on error
34  */
35 library SafeMath {
36     /**
37     * @dev Multiplies two unsigned integers, reverts on overflow.
38     */
39     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
40         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
41         // benefit is lost if 'b' is also tested.
42         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
43         if (a == 0) {
44             return 0;
45         }
46 
47         uint256 c = a * b;
48         require(c / a == b);
49 
50         return c;
51     }
52 
53     /**
54     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
55     */
56     function div(uint256 a, uint256 b) internal pure returns (uint256) {
57         // Solidity only automatically asserts when dividing by 0
58         require(b > 0);
59         uint256 c = a / b;
60         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
61 
62         return c;
63     }
64 
65     /**
66     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
67     */
68     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
69         require(b <= a);
70         uint256 c = a - b;
71 
72         return c;
73     }
74 
75     /**
76     * @dev Adds two unsigned integers, reverts on overflow.
77     */
78     function add(uint256 a, uint256 b) internal pure returns (uint256) {
79         uint256 c = a + b;
80         require(c >= a);
81 
82         return c;
83     }
84 
85     /**
86     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
87     * reverts when dividing by zero.
88     */
89     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
90         require(b != 0);
91         return a % b;
92     }
93 }
94 
95 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
96 
97 pragma solidity ^0.5.0;
98 
99 
100 
101 /**
102  * @title Standard ERC20 token
103  *
104  * @dev Implementation of the basic standard token.
105  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
106  * Originally based on code by FirstBlood:
107  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
108  *
109  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
110  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
111  * compliant implementations may not do it.
112  */
113 contract ERC20 is IERC20 {
114     using SafeMath for uint256;
115 
116     mapping (address => uint256) private _balances;
117 
118     mapping (address => mapping (address => uint256)) private _allowed;
119 
120     uint256 private _totalSupply;
121 
122     /**
123     * @dev Total number of tokens in existence
124     */
125     function totalSupply() public view returns (uint256) {
126         return _totalSupply;
127     }
128 
129     /**
130     * @dev Gets the balance of the specified address.
131     * @param owner The address to query the balance of.
132     * @return An uint256 representing the amount owned by the passed address.
133     */
134     function balanceOf(address owner) public view returns (uint256) {
135         return _balances[owner];
136     }
137 
138     /**
139      * @dev Function to check the amount of tokens that an owner allowed to a spender.
140      * @param owner address The address which owns the funds.
141      * @param spender address The address which will spend the funds.
142      * @return A uint256 specifying the amount of tokens still available for the spender.
143      */
144     function allowance(address owner, address spender) public view returns (uint256) {
145         return _allowed[owner][spender];
146     }
147 
148     /**
149     * @dev Transfer token for a specified address
150     * @param to The address to transfer to.
151     * @param value The amount to be transferred.
152     */
153     function transfer(address to, uint256 value) public returns (bool) {
154         _transfer(msg.sender, to, value);
155         return true;
156     }
157 
158     /**
159      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
160      * Beware that changing an allowance with this method brings the risk that someone may use both the old
161      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
162      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
163      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
164      * @param spender The address which will spend the funds.
165      * @param value The amount of tokens to be spent.
166      */
167     function approve(address spender, uint256 value) public returns (bool) {
168         require(spender != address(0));
169 
170         _allowed[msg.sender][spender] = value;
171         emit Approval(msg.sender, spender, value);
172         return true;
173     }
174 
175     /**
176      * @dev Transfer tokens from one address to another.
177      * Note that while this function emits an Approval event, this is not required as per the specification,
178      * and other compliant implementations may not emit the event.
179      * @param from address The address which you want to send tokens from
180      * @param to address The address which you want to transfer to
181      * @param value uint256 the amount of tokens to be transferred
182      */
183     function transferFrom(address from, address to, uint256 value) public returns (bool) {
184         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
185         _transfer(from, to, value);
186         emit Approval(from, msg.sender, _allowed[from][msg.sender]);
187         return true;
188     }
189 
190     /**
191      * @dev Increase the amount of tokens that an owner allowed to a spender.
192      * approve should be called when allowed_[_spender] == 0. To increment
193      * allowed value is better to use this function to avoid 2 calls (and wait until
194      * the first transaction is mined)
195      * From MonolithDAO Token.sol
196      * Emits an Approval event.
197      * @param spender The address which will spend the funds.
198      * @param addedValue The amount of tokens to increase the allowance by.
199      */
200     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
201         require(spender != address(0));
202 
203         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].add(addedValue);
204         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
205         return true;
206     }
207 
208     /**
209      * @dev Decrease the amount of tokens that an owner allowed to a spender.
210      * approve should be called when allowed_[_spender] == 0. To decrement
211      * allowed value is better to use this function to avoid 2 calls (and wait until
212      * the first transaction is mined)
213      * From MonolithDAO Token.sol
214      * Emits an Approval event.
215      * @param spender The address which will spend the funds.
216      * @param subtractedValue The amount of tokens to decrease the allowance by.
217      */
218     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
219         require(spender != address(0));
220 
221         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].sub(subtractedValue);
222         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
223         return true;
224     }
225 
226     /**
227     * @dev Transfer token for a specified addresses
228     * @param from The address to transfer from.
229     * @param to The address to transfer to.
230     * @param value The amount to be transferred.
231     */
232     function _transfer(address from, address to, uint256 value) internal {
233         require(to != address(0));
234 
235         _balances[from] = _balances[from].sub(value);
236         _balances[to] = _balances[to].add(value);
237         emit Transfer(from, to, value);
238     }
239 
240     /**
241      * @dev Internal function that mints an amount of the token and assigns it to
242      * an account. This encapsulates the modification of balances such that the
243      * proper events are emitted.
244      * @param account The account that will receive the created tokens.
245      * @param value The amount that will be created.
246      */
247     function _mint(address account, uint256 value) internal {
248         require(account != address(0));
249 
250         _totalSupply = _totalSupply.add(value);
251         _balances[account] = _balances[account].add(value);
252         emit Transfer(address(0), account, value);
253     }
254 
255     /**
256      * @dev Internal function that burns an amount of the token of a given
257      * account.
258      * @param account The account whose tokens will be burnt.
259      * @param value The amount that will be burnt.
260      */
261     function _burn(address account, uint256 value) internal {
262         require(account != address(0));
263 
264         _totalSupply = _totalSupply.sub(value);
265         _balances[account] = _balances[account].sub(value);
266         emit Transfer(account, address(0), value);
267     }
268 
269     /**
270      * @dev Internal function that burns an amount of the token of a given
271      * account, deducting from the sender's allowance for said account. Uses the
272      * internal burn function.
273      * Emits an Approval event (reflecting the reduced allowance).
274      * @param account The account whose tokens will be burnt.
275      * @param value The amount that will be burnt.
276      */
277     function _burnFrom(address account, uint256 value) internal {
278         _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(value);
279         _burn(account, value);
280         emit Approval(account, msg.sender, _allowed[account][msg.sender]);
281     }
282 }
283 
284 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Detailed.sol
285 
286 pragma solidity ^0.5.0;
287 
288 
289 /**
290  * @title ERC20Detailed token
291  * @dev The decimals are only for visualization purposes.
292  * All the operations are done using the smallest and indivisible token unit,
293  * just as on Ethereum all the operations are done in wei.
294  */
295 contract ERC20Detailed is IERC20 {
296     string private _name;
297     string private _symbol;
298     uint8 private _decimals;
299 
300     constructor (string memory name, string memory symbol, uint8 decimals) public {
301         _name = name;
302         _symbol = symbol;
303         _decimals = decimals;
304     }
305 
306     /**
307      * @return the name of the token.
308      */
309     function name() public view returns (string memory) {
310         return _name;
311     }
312 
313     /**
314      * @return the symbol of the token.
315      */
316     function symbol() public view returns (string memory) {
317         return _symbol;
318     }
319 
320     /**
321      * @return the number of decimals of the token.
322      */
323     function decimals() public view returns (uint8) {
324         return _decimals;
325     }
326 }
327 
328 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
329 
330 pragma solidity ^0.5.0;
331 
332 /**
333  * @title Ownable
334  * @dev The Ownable contract has an owner address, and provides basic authorization control
335  * functions, this simplifies the implementation of "user permissions".
336  */
337 contract Ownable {
338     address private _owner;
339 
340     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
341 
342     /**
343      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
344      * account.
345      */
346     constructor () internal {
347         _owner = msg.sender;
348         emit OwnershipTransferred(address(0), _owner);
349     }
350 
351     /**
352      * @return the address of the owner.
353      */
354     function owner() public view returns (address) {
355         return _owner;
356     }
357 
358     /**
359      * @dev Throws if called by any account other than the owner.
360      */
361     modifier onlyOwner() {
362         require(isOwner());
363         _;
364     }
365 
366     /**
367      * @return true if `msg.sender` is the owner of the contract.
368      */
369     function isOwner() public view returns (bool) {
370         return msg.sender == _owner;
371     }
372 
373     /**
374      * @dev Allows the current owner to relinquish control of the contract.
375      * @notice Renouncing to ownership will leave the contract without an owner.
376      * It will not be possible to call the functions with the `onlyOwner`
377      * modifier anymore.
378      */
379     function renounceOwnership() public onlyOwner {
380         emit OwnershipTransferred(_owner, address(0));
381         _owner = address(0);
382     }
383 
384     /**
385      * @dev Allows the current owner to transfer control of the contract to a newOwner.
386      * @param newOwner The address to transfer ownership to.
387      */
388     function transferOwnership(address newOwner) public onlyOwner {
389         _transferOwnership(newOwner);
390     }
391 
392     /**
393      * @dev Transfers control of the contract to a newOwner.
394      * @param newOwner The address to transfer ownership to.
395      */
396     function _transferOwnership(address newOwner) internal {
397         require(newOwner != address(0));
398         emit OwnershipTransferred(_owner, newOwner);
399         _owner = newOwner;
400     }
401 }
402 
403 // File: contracts/Administratable.sol
404 
405 pragma solidity 0.5.0;
406 
407 
408 /**
409 This contract allows a list of administrators to be tracked.  This list can then be enforced
410 on functions with administrative permissions.  Only the owner of the contract should be allowed
411 to modify the administrator list.
412  */
413 contract Administratable is Ownable {
414 
415     // The mapping to track administrator accounts - true is reserved for admin addresses.
416     mapping (address => bool) public administrators;
417 
418     // Events to allow tracking add/remove.
419     event AdminAdded(address indexed addedAdmin, address indexed addedBy);
420     event AdminRemoved(address indexed removedAdmin, address indexed removedBy);
421 
422     /**
423     Function modifier to enforce administrative permissions.
424      */
425     modifier onlyAdministrator() {
426         require(isAdministrator(msg.sender), "Calling account is not an administrator.");
427         _;
428     }
429 
430     /**
431     Determine if the message sender is in the administrators list.
432      */
433     function isAdministrator(address addressToTest) public view returns (bool) {
434         return administrators[addressToTest];
435     }
436 
437     /**
438     Add an admin to the list.  This should only be callable by the owner of the contract.
439      */
440     function addAdmin(address adminToAdd) public onlyOwner {
441         // Verify the account is not already an admin
442         require(administrators[adminToAdd] == false, "Account to be added to admin list is already an admin");
443 
444         // Set the address mapping to true to indicate it is an administrator account.
445         administrators[adminToAdd] = true;
446 
447         // Emit the event for any watchers.
448         emit AdminAdded(adminToAdd, msg.sender);
449     }
450 
451     /**
452     Remove an admin from the list.  This should only be callable by the owner of the contract.
453      */
454     function removeAdmin(address adminToRemove) public onlyOwner {
455         // Verify the account is an admin
456         require(administrators[adminToRemove] == true, "Account to be removed from admin list is not already an admin");
457 
458         // Set the address mapping to false to indicate it is NOT an administrator account.  
459         administrators[adminToRemove] = false;
460 
461         // Emit the event for any watchers.
462         emit AdminRemoved(adminToRemove, msg.sender);
463     }
464 }
465 
466 // File: contracts/Whitelistable.sol
467 
468 pragma solidity 0.5.0;
469 
470 
471 
472 
473 /**
474 Keeps track of whitelists and can check if sender and reciever are configured to allow a transfer.
475 Only administrators can update the whitelists.
476 Any address can only be a member of one whitelist at a time.
477  */
478 contract Whitelistable is Administratable {
479     // Zero is reserved for indicating it is not on a whitelist
480     uint8 constant NO_WHITELIST = 0;
481 
482     // The mapping to keep track of which whitelist any address belongs to.
483     // 0 is reserved for no whitelist and is the default for all addresses.
484     mapping (address => uint8) public addressWhitelists;
485 
486     // The mapping to keep track of each whitelist's outbound whitelist flags.
487     // Boolean flag indicates whether outbound transfers are enabled.
488     mapping(uint8 => mapping (uint8 => bool)) public outboundWhitelistsEnabled;
489 
490     // Events to allow tracking add/remove.
491     event AddressAddedToWhitelist(address indexed addedAddress, uint8 indexed whitelist, address indexed addedBy);
492     event AddressRemovedFromWhitelist(address indexed removedAddress, uint8 indexed whitelist, address indexed removedBy);
493     event OutboundWhitelistUpdated(address indexed updatedBy, uint8 indexed sourceWhitelist, uint8 indexed destinationWhitelist, bool from, bool to);
494 
495     /**
496     Sets an address's white list ID.  Only administrators should be allowed to update this.
497     If an address is on an existing whitelist, it will just get updated to the new value (removed from previous).
498      */
499     function addToWhitelist(address addressToAdd, uint8 whitelist) public onlyAdministrator {
500         // Verify the whitelist is valid
501         require(whitelist != NO_WHITELIST, "Invalid whitelist ID supplied");
502 
503         // Save off the previous white list
504         uint8 previousWhitelist = addressWhitelists[addressToAdd];
505 
506         // Set the address's white list ID
507         addressWhitelists[addressToAdd] = whitelist;        
508 
509         // If the previous whitelist existed then we want to indicate it has been removed
510         if(previousWhitelist != NO_WHITELIST) {
511             // Emit the event for tracking
512             emit AddressRemovedFromWhitelist(addressToAdd, previousWhitelist, msg.sender);
513         }
514 
515         // Emit the event for new whitelist
516         emit AddressAddedToWhitelist(addressToAdd, whitelist, msg.sender);
517     }
518 
519     /**
520     Clears out an address's white list ID.  Only administrators should be allowed to update this.
521      */
522     function removeFromWhitelist(address addressToRemove) public onlyAdministrator {
523         // Save off the previous white list
524         uint8 previousWhitelist = addressWhitelists[addressToRemove];
525 
526         // Zero out the previous white list
527         addressWhitelists[addressToRemove] = NO_WHITELIST;
528 
529         // Emit the event for tracking
530         emit AddressRemovedFromWhitelist(addressToRemove, previousWhitelist, msg.sender);
531     }
532 
533     /**
534     Sets the flag to indicate whether source whitelist is allowed to send to destination whitelist.
535     Only administrators should be allowed to update this.
536      */
537     function updateOutboundWhitelistEnabled(uint8 sourceWhitelist, uint8 destinationWhitelist, bool newEnabledValue) public onlyAdministrator {
538         // Get the old enabled flag
539         bool oldEnabledValue = outboundWhitelistsEnabled[sourceWhitelist][destinationWhitelist];
540 
541         // Update to the new value
542         outboundWhitelistsEnabled[sourceWhitelist][destinationWhitelist] = newEnabledValue;
543 
544         // Emit event for tracking
545         emit OutboundWhitelistUpdated(msg.sender, sourceWhitelist, destinationWhitelist, oldEnabledValue, newEnabledValue);
546     }
547 
548     /**
549     Determine if the a sender is allowed to send to the receiver.
550     The source whitelist must be enabled to send to the whitelist where the receive exists.
551      */
552     function checkWhitelistAllowed(address sender, address receiver) public view returns (bool) {
553         // First get each address white list
554         uint8 senderWhiteList = addressWhitelists[sender];
555         uint8 receiverWhiteList = addressWhitelists[receiver];
556 
557         // If either address is not on a white list then the check should fail
558         if(senderWhiteList == NO_WHITELIST || receiverWhiteList == NO_WHITELIST){
559             return false;
560         }
561 
562         // Determine if the sending whitelist is allowed to send to the destination whitelist        
563         return outboundWhitelistsEnabled[senderWhiteList][receiverWhiteList];
564     }
565 }
566 
567 // File: contracts/Restrictable.sol
568 
569 pragma solidity 0.5.0;
570 
571 
572 /**
573 Restrictions start off as enabled.
574 Once they are disabled, they cannot be re-enabled.
575 Only the owner may disable restrictions.
576  */
577 contract Restrictable is Ownable {
578     // State variable to track whether restrictions are enabled.  Defaults to true.
579     bool private _restrictionsEnabled = true;
580 
581     // Event emitted when flag is disabled
582     event RestrictionsDisabled(address indexed owner);
583 
584     /**
585     View function to determine if restrictions are enabled
586      */
587     function isRestrictionEnabled() public view returns (bool) {
588         return _restrictionsEnabled;
589     }
590 
591     /**
592     Function to update the enabled flag on restrictions to disabled.  Only the owner should be able to call.
593     This is a permanent change that cannot be undone
594      */
595     function disableRestrictions() public onlyOwner {
596         require(_restrictionsEnabled, "Restrictions are already disabled.");
597         
598         // Set the flag
599         _restrictionsEnabled = false;
600 
601         // Trigger the event
602         emit RestrictionsDisabled(msg.sender);
603     }
604 }
605 
606 // File: contracts/ERC1404.sol
607 
608 pragma solidity 0.5.0;
609 
610 
611 contract ERC1404 is IERC20 {
612     /// @notice Detects if a transfer will be reverted and if so returns an appropriate reference code
613     /// @param from Sending address
614     /// @param to Receiving address
615     /// @param value Amount of tokens being transferred
616     /// @return Code by which to reference message for rejection reasoning
617     /// @dev Overwrite with your custom transfer restriction logic
618     function detectTransferRestriction (address from, address to, uint256 value) public view returns (uint8);
619 
620     /// @notice Returns a human-readable message for a given restriction code
621     /// @param restrictionCode Identifier for looking up a message
622     /// @return Text showing the restriction's reasoning
623     /// @dev Overwrite with your custom message and restrictionCode handling
624     function messageForTransferRestriction (uint8 restrictionCode) public view returns (string memory);
625 }
626 
627 // File: contracts/SukuToken.sol
628 
629 pragma solidity 0.5.0;
630 
631 
632 
633 
634 
635 
636 contract SukuToken is ERC1404, ERC20, ERC20Detailed, Whitelistable, Restrictable {
637 
638     // Token Details
639     string constant TOKEN_NAME = "SUKU";
640     string constant TOKEN_SYMBOL = "SUKU";
641     uint8 constant TOKEN_DECIMALS = 18;
642 
643     // Token supply - 1.5 Billion Tokens, with 18 decimal precision
644     uint256 constant HUNDRED_MILLION = 100000000;
645     uint256 constant TOKEN_SUPPLY = 15 * HUNDRED_MILLION * (10 ** uint256(TOKEN_DECIMALS));
646 
647     // ERC1404 Error codes and messages
648     uint8 public constant SUCCESS_CODE = 0;
649     uint8 public constant FAILURE_NON_WHITELIST = 1;
650     string public constant SUCCESS_MESSAGE = "SUCCESS";
651     string public constant FAILURE_NON_WHITELIST_MESSAGE = "The transfer was restricted due to white list configuration.";
652     string public constant UNKNOWN_ERROR = "Unknown Error Code";
653 
654 
655     /**
656     Constructor for the token to set readable details and mint all tokens
657     to the contract creator.
658      */
659     constructor(address owner) public 
660         ERC20Detailed(TOKEN_NAME, TOKEN_SYMBOL, TOKEN_DECIMALS)
661     {		
662         _transferOwnership(owner);
663         _mint(owner, TOKEN_SUPPLY);
664     }
665 
666     /**
667     This function detects whether a transfer should be restricted and not allowed.
668     If the function returns SUCCESS_CODE (0) then it should be allowed.
669      */
670     function detectTransferRestriction (address from, address to, uint256)
671         public
672         view
673         returns (uint8)
674     {               
675         // If the restrictions have been disabled by the owner, then just return success
676         // Logic defined in Restrictable parent class
677         if(!isRestrictionEnabled()) {
678             return SUCCESS_CODE;
679         }
680 
681         // If the contract owner is transferring, then ignore reistrictions        
682         if(from == owner()) {
683             return SUCCESS_CODE;
684         }
685 
686         // Restrictions are enabled, so verify the whitelist config allows the transfer.
687         // Logic defined in Whitelistable parent class
688         if(!checkWhitelistAllowed(from, to)) {
689             return FAILURE_NON_WHITELIST;
690         }
691 
692         // If no restrictions were triggered return success
693         return SUCCESS_CODE;
694     }
695     
696     /**
697     This function allows a wallet or other client to get a human readable string to show
698     a user if a transfer was restricted.  It should return enough information for the user
699     to know why it failed.
700      */
701     function messageForTransferRestriction (uint8 restrictionCode)
702         public
703         view
704         returns (string memory)
705     {
706         if (restrictionCode == SUCCESS_CODE) {
707             return SUCCESS_MESSAGE;
708         }
709 
710         if (restrictionCode == FAILURE_NON_WHITELIST) {
711             return FAILURE_NON_WHITELIST_MESSAGE;
712         }
713 
714         // An unknown error code was passed in.
715         return UNKNOWN_ERROR;
716     }
717 
718     /**
719     Evaluates whether a transfer should be allowed or not.
720      */
721     modifier notRestricted (address from, address to, uint256 value) {        
722         uint8 restrictionCode = detectTransferRestriction(from, to, value);
723         require(restrictionCode == SUCCESS_CODE, messageForTransferRestriction(restrictionCode));
724         _;
725     }
726 
727     /**
728     Overrides the parent class token transfer function to enforce restrictions.
729      */
730     function transfer (address to, uint256 value)
731         public
732         notRestricted(msg.sender, to, value)
733         returns (bool success)
734     {
735         success = super.transfer(to, value);
736     }   
737 
738     /**
739     Overrides the parent class token transferFrom function to enforce restrictions.
740      */
741     function transferFrom (address from, address to, uint256 value)
742         public
743         notRestricted(from, to, value)
744         returns (bool success)
745     {
746         success = super.transferFrom(from, to, value);
747     }
748 }