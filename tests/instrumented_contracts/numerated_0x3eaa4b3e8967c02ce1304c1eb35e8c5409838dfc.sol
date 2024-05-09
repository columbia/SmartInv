1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.3;
3 
4 /**
5  * @title Represents an ownable resource.
6  */
7 contract Ownable {
8     address public owner;
9 
10     event OwnershipTransferred(address previousOwner, address newOwner);
11 
12     /**
13      * Constructor
14      * @param addr The owner of the smart contract
15      */
16     constructor (address addr) {
17         require(addr != address(0), "non-zero address required");
18         require(addr != address(1), "ecrecover address not allowed");
19         owner = addr;
20         emit OwnershipTransferred(address(0), addr);
21     }
22 
23     /**
24      * @notice This modifier indicates that the function can only be called by the owner.
25      * @dev Throws if called by any account other than the owner.
26      */
27     modifier onlyOwner() {
28         require(owner == msg.sender, "Only owner requirement");
29         _;
30     }
31 
32     /**
33      * @notice Transfers ownership to the address specified.
34      * @param addr Specifies the address of the new owner.
35      * @dev Throws if called by any account other than the owner.
36      */
37     function transferOwnership (address addr) public virtual onlyOwner {
38         require(addr != address(0), "non-zero address required");
39         emit OwnershipTransferred(owner, addr);
40         owner = addr;
41     }
42 }
43 
44 
45 /**
46  * @title ERC20 interface
47  * @dev see https://github.com/ethereum/EIPs/issues/20
48  */
49 interface IERC20 {
50     /**
51     * Transfer token for a specified address
52     * @param to The address to transfer to.
53     * @param value The amount to be transferred.
54     */
55     function transfer(address to, uint256 value) external returns (bool);
56 
57     /**
58      * Transfer tokens from one address to another.
59      * Note that while this function emits an Approval event, this is not required as per the specification,
60      * and other compliant implementations may not emit the event.
61      * @param from address The address which you want to send tokens from
62      * @param to address The address which you want to transfer to
63      * @param value uint256 the amount of tokens to be transferred
64      */
65     function transferFrom(address from, address to, uint256 value) external returns (bool);
66 
67     /**
68      * Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
69      * Beware that changing an allowance with this method brings the risk that someone may use both the old
70      * and the new allowance by unfortunate transaction ordering.
71      * One possible solution to mitigate this race condition is to first reduce the spender's allowance to 0
72      * and set the desired value afterwards: https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
73      * @param spender The address which will spend the funds.
74      * @param value The amount of tokens to be spent.
75      */
76     function approve(address spender, uint256 value) external returns (bool);
77 
78     /**
79      * Returns the total number of tokens in existence.
80      */
81     function totalSupply() external view returns (uint256);
82 
83     function decimals() external view returns (uint8);
84     function name() external view returns (string memory);
85     function symbol() external view returns (string memory);
86 
87     /**
88     * Gets the balance of the address specified.
89     * @param addr The address to query the balance of.
90     * @return An uint256 representing the amount owned by the passed address.
91     */
92     function balanceOf(address addr) external view returns (uint256);
93 
94     /**
95      * Function to check the amount of tokens that an owner allowed to a spender.
96      * @param owner address The address which owns the funds.
97      * @param spender address The address which will spend the funds.
98      * @return A uint256 specifying the amount of tokens still available for the spender.
99      */
100     function allowance(address owner, address spender) external view returns (uint256);
101 
102     /**
103      * This event is triggered when a given amount of tokens is sent to an address.
104      * @param from The address of the sender
105      * @param to The address of the receiver
106      * @param value The amount transferred
107      */
108     event Transfer(address indexed from, address indexed to, uint256 value);
109 
110     /**
111      * This event is triggered when a given address is approved to spend a specific amount of tokens
112      * on behalf of the sender.
113      * @param owner The owner of the token
114      * @param spender The spender
115      * @param value The amount to transfer
116      */
117     event Approval(address indexed owner, address indexed spender, uint256 value);
118 }
119 
120 /**
121  * @title Represents an ERC-20
122  */
123 contract ERC20 is IERC20 {
124     // Basic ERC-20 data
125     string private _name;
126     string private _symbol;
127     uint8 private _decimals;
128     uint256 internal _totalSupply;
129 
130     // The balance of each owner
131     mapping(address => uint256) internal _balances;
132 
133     // The allowance set by each owner
134     mapping(address => mapping(address => uint256)) private _allowances;
135 
136     /**
137      * @notice Constructor
138      * @param tokenName The name of the token
139      * @param tokenSymbol The symbol of the token
140      * @param tokenDecimals The decimals of the token
141      * @param initialSupply The initial supply
142      */
143     constructor (string memory tokenName, string memory tokenSymbol, uint8 tokenDecimals, uint256 initialSupply) {
144         _name = tokenName;
145         _symbol = tokenSymbol;
146         _decimals = tokenDecimals;
147         _totalSupply = initialSupply;
148     }
149 
150     /**
151     * @notice Transfers a given amount tokens to the address specified.
152     * @param from The address of the sender.
153     * @param to The address to transfer to.
154     * @param value The amount to be transferred.
155     * @return Returns true in case of success.
156     */
157     function _executeErc20Transfer (address from, address to, uint256 value) private returns (bool) {
158         // Checks
159         require(to != address(0), "non-zero address required");
160         require(from != address(0), "non-zero sender required");
161         require(value > 0, "Amount cannot be zero");
162         require(_balances[from] >= value, "Amount exceeds sender balance");
163 
164         // State changes
165         _balances[from] = _balances[from] - value;
166         _balances[to] = _balances[to] + value;
167 
168         // Emit the event per ERC-20
169         emit Transfer(from, to, value);
170 
171         return true;
172     }
173 
174     /**
175      * @notice Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
176      * @dev Beware that changing an allowance with this method brings the risk that someone may use both the old
177      * and the new allowance by unfortunate transaction ordering.
178      * One possible solution to mitigate this race condition is to first reduce the spender's allowance to 0
179      * and set the desired value afterwards: https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
180      * @param ownerAddr The address of the owner.
181      * @param spender The address which will spend the funds.
182      * @param value The amount of tokens to be spent.
183      * @return Returns true in case of success.
184      */
185     function _approveSpender(address ownerAddr, address spender, uint256 value) private returns (bool) {
186         require(spender != address(0), "non-zero spender required");
187         require(ownerAddr != address(0), "non-zero owner required");
188 
189         // State changes
190         _allowances[ownerAddr][spender] = value;
191 
192         // Emit the event
193         emit Approval(ownerAddr, spender, value);
194 
195         return true;
196     }
197 
198     /**
199     * @notice Transfers a given amount tokens to the address specified.
200     * @param to The address to transfer to.
201     * @param value The amount to be transferred.
202     * @return Returns true in case of success.
203     */
204     function transfer(address to, uint256 value) public override returns (bool) {
205         require (_executeErc20Transfer(msg.sender, to, value), "Failed to execute ERC20 transfer");
206         return true;
207     }
208 
209     /**
210      * @notice Transfer tokens from one address to another.
211      * @dev Note that while this function emits an Approval event, this is not required as per the specification,
212      * and other compliant implementations may not emit the event.
213      * @param from address The address which you want to send tokens from
214      * @param to address The address which you want to transfer to
215      * @param value uint256 the amount of tokens to be transferred
216      * @return Returns true in case of success.
217      */
218     function transferFrom(address from, address to, uint256 value) public override returns (bool) {
219         uint256 currentAllowance = _allowances[from][msg.sender];
220         require(currentAllowance >= value, "Amount exceeds allowance");
221 
222         require (_executeErc20Transfer(from, to, value), "Failed to execute transferFrom");
223 
224         require(_approveSpender(from, msg.sender, currentAllowance - value), "ERC20: Approval failed");
225 
226         return true;
227     }
228 
229     /**
230      * @notice Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
231      * @dev Beware that changing an allowance with this method brings the risk that someone may use both the old
232      * and the new allowance by unfortunate transaction ordering.
233      * One possible solution to mitigate this race condition is to first reduce the spender's allowance to 0
234      * and set the desired value afterwards: https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
235      * @param spender The address which will spend the funds.
236      * @param value The amount of tokens to be spent.
237      * @return Returns true in case of success.
238      */
239     function approve(address spender, uint256 value) public override returns (bool) {
240         require(_approveSpender(msg.sender, spender, value), "ERC20: Approval failed");
241         return true;
242     }
243 
244     /**
245      * Gets the total supply of tokens
246      */
247     function totalSupply() public view override returns (uint256) {
248         return _totalSupply;
249     }
250 
251     /**
252      * @notice Gets the name of the token.
253      */
254     function name() public view override returns (string memory) {
255         return _name;
256     }
257 
258     /**
259      * @notice Gets the symbol of the token.
260      */
261     function symbol() public view override returns (string memory) {
262         return _symbol;
263     }
264 
265     /**
266      * @notice Gets the decimals of the token.
267      */
268     function decimals() public view override returns (uint8) {
269         return _decimals;
270     }
271 
272     /**
273     * Gets the balance of the address specified.
274     * @param addr The address to query the balance of.
275     * @return An uint256 representing the amount owned by the passed address.
276     */
277     function balanceOf(address addr) public view override returns (uint256) {
278         return _balances[addr];
279     }
280 
281     /**
282      * Function to check the amount of tokens that an owner allowed to a spender.
283      * @param owner address The address which owns the funds.
284      * @param spender address The address which will spend the funds.
285      * @return A uint256 specifying the amount of tokens still available for the spender.
286      */
287     function allowance(address owner, address spender) public view override returns (uint256) {
288         return _allowances[owner][spender];
289     }
290 }
291 
292 /**
293  * @notice Represents an ERC20 that can be minted and/or burnt by multiple parties.
294  */
295 contract Mintable is ERC20, Ownable {
296     /**
297      * @notice The maximum circulating supply of tokens
298      */
299     uint256 public maxSupply;
300 
301     // Keeps track of the authorized minters
302     mapping (address => bool) internal _authorizedMinters;
303 
304     // Keeps track of the authorized burners
305     mapping (address => bool) internal _authorizedBurners;
306 
307     // ---------------------------------------
308     // Events
309     // ---------------------------------------
310     /**
311      * This event is triggered whenever an address is added as a valid minter.
312      * @param addr The address that became a valid minter
313      */
314     event OnMinterGranted(address addr);
315 
316     /**
317      * This event is triggered when a minter is revoked.
318      * @param addr The address that was revoked
319      */
320     event OnMinterRevoked(address addr);
321 
322     /**
323      * This event is triggered whenever an address is added as a valid burner.
324      * @param addr The address that became a valid burner
325      */
326     event OnBurnerGranted(address addr);
327 
328     /**
329      * This event is triggered when a burner is revoked.
330      * @param addr The address that was revoked
331      */
332     event OnBurnerRevoked(address addr);
333 
334     /**
335      * This event is triggered when the maximum limit for minting tokens is updated.
336      * @param prevValue The previous limit
337      * @param newValue The new limit
338      */
339     event OnMaxSupplyChanged(uint256 prevValue, uint256 newValue);
340 
341     // ---------------------------------------
342     // Constructor
343     // ---------------------------------------
344     /**
345      * @notice Constructor
346      * @param newOwner The contract owner
347      * @param tokenName The name of the token
348      * @param tokenSymbol The symbol of the token
349      * @param tokenDecimals The decimals of the token
350      * @param initialSupply The initial supply
351      */
352     constructor (address newOwner, string memory tokenName, string memory tokenSymbol, uint8 tokenDecimals, uint256 initialSupply)
353     ERC20(tokenName, tokenSymbol, tokenDecimals, initialSupply)
354     Ownable(newOwner) { // solhint-disable-line no-empty-blocks
355     }
356 
357     /**
358      * @notice Throws if the sender is not a valid minter
359      */
360     modifier onlyMinter() {
361         require(_authorizedMinters[msg.sender], "Unauthorized minter");
362         _;
363     }
364 
365     /**
366      * @notice Throws if the sender is not a valid burner
367      */
368     modifier onlyBurner() {
369         require(_authorizedBurners[msg.sender], "Unauthorized burner");
370         _;
371     }
372 
373     /**
374      * @notice Grants the right to issue new tokens to the address specified.
375      * @dev This function can be called by the owner only.
376      * @param addr The destination address
377      */
378     function grantMinter (address addr) public onlyOwner {
379         require(!_authorizedMinters[addr], "Address authorized already");
380         _authorizedMinters[addr] = true;
381         emit OnMinterGranted(addr);
382     }
383 
384     /**
385      * @notice Revokes the right to issue new tokens from the address specified.
386      * @dev This function can be called by the owner only.
387      * @param addr The destination address
388      */
389     function revokeMinter (address addr) public onlyOwner {
390         require(_authorizedMinters[addr], "Address was never authorized");
391         _authorizedMinters[addr] = false;
392         emit OnMinterRevoked(addr);
393     }
394 
395     /**
396      * @notice Grants the right to burn tokens to the address specified.
397      * @dev This function can be called by the owner only.
398      * @param addr The destination address
399      */
400     function grantBurner (address addr) public onlyOwner {
401         require(!_authorizedBurners[addr], "Address authorized already");
402         _authorizedBurners[addr] = true;
403         emit OnBurnerGranted(addr);
404     }
405 
406     /**
407      * @notice Revokes the right to burn tokens from the address specified.
408      * @dev This function can be called by the owner only.
409      * @param addr The destination address
410      */
411     function revokeBurner (address addr) public onlyOwner {
412         require(_authorizedBurners[addr], "Address was never authorized");
413         _authorizedBurners[addr] = false;
414         emit OnBurnerRevoked(addr);
415     }
416 
417     /**
418      * @notice Updates the maximum limit for minting tokens.
419      * @param newValue The new limit
420      */
421     function changeMaxSupply (uint256 newValue) public onlyOwner {
422         require(newValue == 0 || newValue > _totalSupply, "Invalid max supply");
423         emit OnMaxSupplyChanged(maxSupply, newValue);
424         maxSupply = newValue;
425     }
426 
427     /**
428      * @notice Issues a given number of tokens to the address specified.
429      * @dev This function throws if the sender is not a whitelisted minter.
430      * @param addr The destination address
431      * @param amount The number of tokens
432      */
433     function mint (address addr, uint256 amount) public onlyMinter {
434         require(addr != address(0) && addr != address(this), "Invalid address");
435         require(amount > 0, "Invalid amount");
436         require(canMint(amount), "Max token supply exceeded");
437 
438         _totalSupply += amount;
439         _balances[addr] += amount;
440         emit Transfer(address(0), addr, amount);
441     }
442 
443     /**
444      * @notice Burns a given number of tokens from the address specified.
445      * @dev This function throws if the sender is not a whitelisted minter. In this context, minters and burners have the same privileges.
446      * @param addr The destination address
447      * @param amount The number of tokens
448      */
449     function burn (address addr, uint256 amount) public onlyBurner {
450         require(addr != address(0) && addr != address(this), "Invalid address");
451         require(amount > 0, "Invalid amount");
452         require(_totalSupply > 0, "No token supply");
453 
454         uint256 accountBalance = _balances[addr];
455         require(accountBalance >= amount, "Burn amount exceeds balance");
456 
457         _balances[addr] = accountBalance - amount;
458         _totalSupply -= amount;
459         emit Transfer(addr, address(0), amount);
460     }
461 
462     /**
463      * @notice Indicates if we can issue/mint the number of tokens specified.
464      * @param amount The number of tokens to issue/mint
465      */
466     function canMint (uint256 amount) public view returns (bool) {
467         return (maxSupply == 0) || (_totalSupply + amount <= maxSupply);
468     }
469 }
470 
471 
472 /**
473  * @title Represents a controllable resource.
474  */
475 contract Controllable is Ownable {
476     address public controllerAddress;
477 
478     event OnControllerChanged (address prevAddress, address newAddress);
479 
480     /**
481      * @notice Constructor
482      * @param ownerAddr The owner of the smart contract
483      * @param controllerAddr The address of the controller
484      */
485     constructor (address ownerAddr, address controllerAddr) Ownable (ownerAddr) {
486         require(controllerAddr != address(0), "Controller address required");
487         require(controllerAddr != ownerAddr, "Owner cannot be the Controller");
488         controllerAddress = controllerAddr;
489     }
490 
491     /**
492      * @notice Throws if the sender is not the controller
493      */
494     modifier onlyController() {
495         require(msg.sender == controllerAddress, "Unauthorized controller");
496         _;
497     }
498 
499     /**
500      * @notice Makes sure the sender is either the owner of the contract or the controller
501      */
502     modifier onlyOwnerOrController() {
503         require(msg.sender == controllerAddress || msg.sender == owner, "Only owner or controller");
504         _;
505     }
506 
507     /**
508      * @notice Sets the controller
509      * @dev This function can be called by the owner only
510      * @param controllerAddr The address of the controller
511      */
512     function setController (address controllerAddr) public onlyOwner {
513         // Checks
514         require(controllerAddr != address(0), "Controller address required");
515         require(controllerAddr != owner, "Owner cannot be the Controller");
516         require(controllerAddr != controllerAddress, "Controller already set");
517 
518         emit OnControllerChanged(controllerAddress, controllerAddr);
519 
520         // State changes
521         controllerAddress = controllerAddr;
522     }
523 
524     /**
525      * @notice Transfers ownership to the address specified.
526      * @param addr Specifies the address of the new owner.
527      * @dev Throws if called by any account other than the owner.
528      */
529     function transferOwnership (address addr) public override onlyOwner {
530         require(addr != controllerAddress, "Cannot transfer to controller");
531         super.transferOwnership(addr);
532     }
533 }
534 
535 /**
536  * @title Represents a receipt token. The token is fully compliant with the ERC20 interface.
537  * @dev The token can be minted or burnt by whitelisted addresses only. Only the owner is allowed to enable/disable addresses.
538  */
539 contract ReceiptToken is Mintable {
540     /**
541      * @notice Constructor.
542      * @param newOwner The owner of the smart contract.
543      */
544     constructor (address newOwner, uint256 initialMaxSupply) Mintable(newOwner, "Fractal Protocol Vault Token", "USDF", 6, 0) {
545         maxSupply = initialMaxSupply;
546     }
547 }
548 
549 /**
550  * @notice This library provides stateless, general purpose functions.
551  */
552 library Utils {
553     // The code hash of any EOA
554     bytes32 constant internal EOA_HASH = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
555 
556     /**
557      * @notice Indicates if the address specified represents a smart contract.
558      * @dev Notice that this method returns TRUE if the address is a contract under construction
559      * @param addr The address to evaluate
560      * @return Returns true if the address represents a smart contract
561      */
562     function isContract (address addr) internal view returns (bool) {
563         bytes32 eoaHash = EOA_HASH;
564 
565         bytes32 codeHash;
566 
567         // solhint-disable-next-line no-inline-assembly
568         assembly { codeHash := extcodehash(addr) }
569 
570         return (codeHash != eoaHash && codeHash != 0x0);
571     }
572 
573     /**
574      * @notice Gets the code hash of the address specified
575      * @param addr The address to evaluate
576      * @return Returns a hash
577      */
578     function getCodeHash (address addr) internal view returns (bytes32) {
579         bytes32 codeHash;
580 
581         // solhint-disable-next-line no-inline-assembly
582         assembly { codeHash := extcodehash(addr) }
583 
584         return codeHash;
585     }
586 }
587 
588 library DateUtils {
589     // The number of seconds per day
590     uint256 internal constant SECONDS_PER_DAY = 24 * 60 * 60;
591 
592     // The number of seconds per hour
593     uint256 internal constant SECONDS_PER_HOUR = 60 * 60;
594 
595     // The number of seconds per minute
596     uint256 internal constant SECONDS_PER_MINUTE = 60;
597 
598     // The offset from 01/01/1970
599     int256 internal constant OFFSET19700101 = 2440588;
600 
601     /**
602      * @notice Gets the year of the timestamp specified.
603      * @param timestamp The timestamp
604      * @return year The year
605      */
606     function getYear (uint256 timestamp) internal pure returns (uint256 year) {
607         (year,,) = _daysToDate(timestamp / SECONDS_PER_DAY);
608     }
609 
610     /**
611      * @notice Gets the timestamp of the date specified.
612      * @param year The year
613      * @param month The month
614      * @param day The day
615      * @param hour The hour
616      * @param minute The minute
617      * @param second The seconds
618      * @return timestamp The timestamp
619      */
620     function timestampFromDateTime(uint256 year, uint256 month, uint256 day, uint256 hour, uint256 minute, uint256 second) internal pure returns (uint256 timestamp) {
621         timestamp = _daysFromDate(year, month, day) * SECONDS_PER_DAY + hour * SECONDS_PER_HOUR + minute * SECONDS_PER_MINUTE + second;
622     }
623 
624     /**
625      * @notice Gets the number of days elapsed between the two timestamps specified.
626      * @param fromTimestamp The source date
627      * @param toTimestamp The target date
628      * @return Returns the difference, in days
629      */
630     function diffDays (uint256 fromTimestamp, uint256 toTimestamp) internal pure returns (uint256) {
631         require(fromTimestamp <= toTimestamp, "Invalid order for timestamps");
632         return (toTimestamp - fromTimestamp) / SECONDS_PER_DAY;
633     }
634 
635     /**
636      * @notice Calculate year/month/day from the number of days since 1970/01/01 using the date conversion algorithm from http://aa.usno.navy.mil/faq/docs/JD_Formula.php and adding the offset 2440588 so that 1970/01/01 is day 0
637      * @dev Taken from https://github.com/bokkypoobah/BokkyPooBahsDateTimeLibrary/blob/master/contracts/BokkyPooBahsDateTimeLibrary.sol
638      * @param _days The year
639      * @return year The year
640      * @return month The month
641      * @return day The day
642      */
643     function _daysToDate (uint256 _days) internal pure returns (uint256 year, uint256 month, uint256 day) {
644         int256 __days = int256(_days);
645 
646         int256 x = __days + 68569 + OFFSET19700101;
647         int256 n = 4 * x / 146097;
648         x = x - (146097 * n + 3) / 4;
649         int256 _year = 4000 * (x + 1) / 1461001;
650         x = x - 1461 * _year / 4 + 31;
651         int256 _month = 80 * x / 2447;
652         int256 _day = x - 2447 * _month / 80;
653         x = _month / 11;
654         _month = _month + 2 - 12 * x;
655         _year = 100 * (n - 49) + _year + x;
656 
657         year = uint256(_year);
658         month = uint256(_month);
659         day = uint256(_day);
660     }
661 
662     /**
663      * @notice Calculates the number of days from 1970/01/01 to year/month/day using the date conversion algorithm from http://aa.usno.navy.mil/faq/docs/JD_Formula.php and subtracting the offset 2440588 so that 1970/01/01 is day 0
664      * @dev Taken from https://github.com/bokkypoobah/BokkyPooBahsDateTimeLibrary/blob/master/contracts/BokkyPooBahsDateTimeLibrary.sol
665      * @param year The year
666      * @param month The month
667      * @param day The day
668      * @return _days Returns the number of days
669      */
670     function _daysFromDate (uint256 year, uint256 month, uint256 day) internal pure returns (uint256 _days) {
671         require(year >= 1970, "Error");
672         int _year = int(year);
673         int _month = int(month);
674         int _day = int(day);
675 
676         int __days = _day
677           - 32075
678           + 1461 * (_year + 4800 + (_month - 14) / 12) / 4
679           + 367 * (_month - 2 - (_month - 14) / 12 * 12) / 12
680           - 3 * ((_year + 4900 + (_month - 14) / 12) / 100) / 4
681           - OFFSET19700101;
682 
683         _days = uint256(__days);
684     }
685 
686     function isLeapYear(uint timestamp) internal pure returns (bool leapYear) {
687         (uint year,,) = _daysToDate(timestamp / SECONDS_PER_DAY);
688         leapYear = _isLeapYear(year);
689     }    
690 
691     function _isLeapYear (uint256 year) internal pure returns (bool leapYear) {
692         leapYear = ((year % 4 == 0) && (year % 100 != 0)) || (year % 400 == 0);
693     }
694 }
695 
696 interface IDeployable {
697     function deployCapital (uint256 deploymentAmount, bytes32 foreignNetwork) external;
698     function claim (uint256 dailyInterestAmount) external;
699 }
700 
701 /**
702  * @title Represents a vault.
703  */
704 contract Vault is Controllable {
705     // The decimal multiplier of the receipt token
706     uint256 private constant USDF_DECIMAL_MULTIPLIER = uint256(10) ** uint256(6);
707 
708     // Represents a record
709     struct Record {
710         uint256 apr;
711         uint256 tokenPrice;
712         uint256 totalDeposited;
713         uint256 dailyInterest;
714     }
715 
716     /**
717      * @notice The timestamp that defines the start of the current year, per contract deployment.
718      * @dev This is the unix epoch of January 1st since the contract deployment.
719      */
720     uint256 public startOfYearTimestamp;
721 
722     /**
723      * @notice The current period. It is the zero-based day of the year, ranging from [0..364]
724      * @dev Day zero represents January 1st (first day of the year) whereas day 364 represents December 31st (last day of the day)
725      */
726     uint256 public currentPeriod;
727 
728     /**
729      * @notice The minimum amount you can deposit in the vault.
730      */
731     uint256 public minDepositAmount;
732 
733     /**
734      * @notice The flat fee to apply to vault withdrawals.
735      */
736     uint256 public flatFeePercent;
737 
738     // The decimals multiplier of the underlying ERC20
739     uint256 immutable private _decimalsMultiplier;
740 
741     /**
742      * @notice The percentage of capital that needs to be invested. It ranges from [1..99]
743      * @dev The investment percent is set to 90% by default
744      */
745     uint8 public investmentPercent = 90;
746 
747     // The reentrancy guard for deposits
748     uint8 private _reentrancyMutexForDeposits;
749 
750     // The reentrancy guard for withdrawals
751     uint8 private _reentrancyMutexForWithdrawals;
752 
753     /**
754      * @notice The address of the yield reserve
755      */
756     address public yieldReserveAddress;
757 
758     /**
759      * @notice The address that collects the applicable fees
760      */
761     address public feesAddress;
762 
763     /**
764      * @notice The interface of the underlying token
765      */
766     IERC20 public immutable underlyingTokenInterface;
767 
768     // The receipt token. This is immutable so it cannot be altered after deployment.
769     ReceiptToken private immutable _receiptToken;
770 
771     // The snapshots history
772     mapping (uint256 => Record) private _records;
773 
774     // ---------------------------------------
775     // Events
776     // ---------------------------------------
777     /**
778      * @notice This event is fired when the vault receives a deposit.
779      * @param tokenAddress Specifies the token address
780      * @param fromAddress Specifies the address of the sender
781      * @param depositAmount Specifies the deposit amount in USDC or the ERC20 handled by this contract
782      * @param receiptTokensAmount Specifies the amount of receipt tokens issued to the user
783      */
784     event OnVaultDeposit (address tokenAddress, address fromAddress, uint256 depositAmount, uint256 receiptTokensAmount);
785 
786     /**
787      * @notice This event is fired when a user withdraws funds from the vault.
788      * @param tokenAddress Specifies the token address
789      * @param toAddress Specifies the address of the recipient
790      * @param erc20Amount Specifies the amount in USDC or the ERC20 handled by this contract
791      * @param receiptTokensAmount Specifies the amount of receipt tokens withdrawn by the user
792      * @param fee Specifies the withdrawal fee
793      */
794     event OnVaultWithdrawal (address tokenAddress, address toAddress, uint256 erc20Amount, uint256 receiptTokensAmount, uint256 fee);
795 
796     event OnTokenPriceChanged (uint256 prevTokenPrice, uint256 newTokenPrice);
797     event OnFlatWithdrawalFeeChanged (uint256 prevValue, uint256 newValue);
798     event OnYieldReserveAddressChanged (address prevAddress, address newAddress);
799     event OnFeesAddressChanged (address prevAddress, address newAddress);
800     event OnInvestmentPercentChanged (uint8 prevValue, uint8 newValue);
801     event OnCapitalLocked (uint256 amountLocked);
802     event OnInterestClaimed (uint256 interestAmount);
803     event OnAprChanged (uint256 prevApr, uint256 newApr);
804     event OnEmergencyWithdraw (uint256 withdrawalAmount);
805 
806     // ---------------------------------------
807     // Constructor
808     // ---------------------------------------
809     constructor (
810         address ownerAddr, 
811         address controllerAddr, 
812         ReceiptToken receiptTokenInterface, 
813         IERC20 eip20Interface, 
814         uint256 initialApr, 
815         uint256 initialTokenPrice, 
816         uint256 initialMinDepositAmount,
817         uint256 flatFeePerc,
818         address feesAddr) 
819     Controllable (ownerAddr, controllerAddr) {
820         // Checks
821         require(initialMinDepositAmount > 0, "Invalid min deposit amount");
822         require(feesAddr != address(0), "Invalid address for fees");
823 
824         // State changes
825         underlyingTokenInterface = eip20Interface;
826         _receiptToken = receiptTokenInterface;
827         minDepositAmount = initialMinDepositAmount;
828         _decimalsMultiplier = uint256(10) ** uint256(eip20Interface.decimals());
829 
830         uint256 currentTimestamp = block.timestamp; // solhint-disable-line not-rely-on-time
831 
832         // Get the current year
833         uint256 currentYear = DateUtils.getYear(currentTimestamp);
834 
835         // Set the timestamp of January 1st of the current year (the year starts at this unix epoch)
836         startOfYearTimestamp = DateUtils.timestampFromDateTime(currentYear, 1, 1, 0, 0, 0);
837 
838         // Create the first record
839         currentPeriod = DateUtils.diffDays(startOfYearTimestamp, currentTimestamp);
840         
841         // The APR must be expressed with 2 decimal places. Example: 5% = 500 whereas 5.75% = 575
842         _records[currentPeriod] = Record(initialApr, initialTokenPrice, 0, 0);
843 
844         flatFeePercent = flatFeePerc;
845         feesAddress = feesAddr;
846     }
847 
848     // ---------------------------------------
849     // Modifiers
850     // ---------------------------------------
851     /**
852      * @notice Throws if there is a deposit in progress
853      */
854     modifier ifNotReentrantDeposit() {
855         require(_reentrancyMutexForDeposits == 0, "Reentrant deposit rejected");
856         _;
857     }
858 
859     /**
860      * @notice Throws if there is a withdrawal in progress
861      */
862     modifier ifNotReentrantWithdrawal() {
863         require(_reentrancyMutexForWithdrawals == 0, "Reentrant withdrawal rejected");
864         _;
865     }
866 
867     // ---------------------------------------
868     // Functions
869     // ---------------------------------------
870     /**
871      * @notice Sets the address of the yield reserve
872      * @dev This function can be called by the owner or the controller.
873      * @param addr The address of the yield reserve
874      */
875     function setYieldReserveAddress (address addr) public onlyOwnerOrController {
876         require(addr != address(0) && addr != address(this), "Invalid address");
877         require(Utils.isContract(addr), "The address must be a contract");
878 
879         emit OnYieldReserveAddressChanged(yieldReserveAddress, addr);
880         yieldReserveAddress = addr;
881     }
882 
883     /**
884      * @notice Sets the minimum amount for deposits.
885      * @dev This function can be called by the owner or the controller.
886      * @param minAmount The minimum deposit amount
887      */
888     function setMinDepositAmount (uint256 minAmount) public onlyOwnerOrController {
889         // Checks
890         require(minAmount > 0, "Invalid minimum deposit amount");
891 
892         // State changes
893         minDepositAmount = minAmount;
894     }
895 
896     /**
897      * @notice Sets a new flat fee for withdrawals.
898      * @dev The new fee is allowed to be zero (aka: no fees).
899      * @param newFeeWithMultiplier The new fee, which is expressed per decimals precision of the underlying token (say USDC for example)
900      */
901     function setFlatWithdrawalFee (uint256 newFeeWithMultiplier) public onlyOwnerOrController {
902         // Example for USDC (6 decimal places):
903         // Say the fee is: 0.03%
904         // Thus the fee amount is: 0.03 * _decimalsMultiplier = 30000 = 0.03 * (10 to the power of 6)
905         emit OnFlatWithdrawalFeeChanged(flatFeePercent, newFeeWithMultiplier);
906 
907         flatFeePercent = newFeeWithMultiplier;
908     }
909 
910     /**
911      * @notice Sets the address for collecting fees.
912      * @param addr The address
913      */
914     function setFeeAddress (address addr) public onlyOwnerOrController {
915         require(addr != address(0) && addr != feesAddress, "Invalid address for fees");
916 
917         emit OnFeesAddressChanged(feesAddress, addr);
918         feesAddress = addr;
919     }
920 
921     /**
922      * @notice Sets the total amount deposited in the Vault
923      * @dev This function can be called during a migration only. It is guaranteed to fail otherwise.
924      * @param newAmount The total amount deposited in the old Vault
925      */
926     function setTotalDepositedAmount (uint256 newAmount) public onlyOwner {
927         require(newAmount > 0, "Non-zero amount required");
928 
929         uint256 currentBalance = underlyingTokenInterface.balanceOf(address(this));
930         require(currentBalance == 0, "Deposits already available");
931 
932         // State changes
933         _records[currentPeriod].totalDeposited = newAmount;
934     }
935 
936     /**
937      * @notice Deposits funds in the vault. The caller gets the respective amount of receipt tokens in exchange for their deposit.
938      * @dev The number of receipt tokens is calculated based on the current token price.
939      * @param depositAmount Specifies the deposit amount
940      */
941     function deposit (uint256 depositAmount) public ifNotReentrantDeposit {
942         // Make sure the deposit amount falls within the expected range
943         require(depositAmount >= minDepositAmount, "Minimum deposit amount not met");
944 
945         // Wake up the reentrancy guard
946         _reentrancyMutexForDeposits = 1;
947 
948         // Refresh the current timelime, if needed
949         compute();
950 
951         // Make sure the sender can cover the deposit (aka: has enough USDC/ERC20 on their wallet)
952         require(underlyingTokenInterface.balanceOf(msg.sender) >= depositAmount, "Insufficient funds");
953 
954         // Make sure the user approved this contract to spend the amount specified
955         require(underlyingTokenInterface.allowance(msg.sender, address(this)) >= depositAmount, "Insufficient allowance");
956 
957         // Determine how many tokens can be issued/minted to the destination address
958         uint256 numberOfReceiptTokens = depositAmount * USDF_DECIMAL_MULTIPLIER / _records[currentPeriod].tokenPrice;
959 
960         // Make sure we can issue the number of tokens specified, per limits
961         require(_receiptToken.canMint(numberOfReceiptTokens), "Token supply limit exceeded");
962 
963         _records[currentPeriod].totalDeposited += depositAmount;
964 
965         // Get the current balance of this contract in USDC (or whatever the ERC20 is, which defined at deployment time)
966         uint256 balanceBeforeTransfer = underlyingTokenInterface.balanceOf(address(this));
967 
968         // Make sure the ERC20 transfer succeeded
969         require(underlyingTokenInterface.transferFrom(msg.sender, address(this), depositAmount), "Token transfer failed");
970 
971         // The new balance of this contract, after the transfer
972         uint256 newBalance = underlyingTokenInterface.balanceOf(address(this));
973 
974         // At the very least, the new balance should be the previous balance + the deposit.
975         require(newBalance == balanceBeforeTransfer + depositAmount, "Balance verification failed");
976 
977         // Issue/mint the respective number of tokens. Users get a receipt token in exchange for their deposit in USDC/ERC20.
978         _receiptToken.mint(msg.sender, numberOfReceiptTokens);
979 
980         // Emit a new "deposit" event
981         emit OnVaultDeposit(address(underlyingTokenInterface), msg.sender, depositAmount, numberOfReceiptTokens);
982 
983         // Reset the reentrancy guard
984         _reentrancyMutexForDeposits = 0;
985     }
986 
987     /**
988      * @notice Withdraws a specific amount of tokens from the Vault.
989      * @param receiptTokenAmount The number of tokens to withdraw from the vault
990      */
991     function withdraw (uint256 receiptTokenAmount) public ifNotReentrantWithdrawal {
992         // Checks
993         require(receiptTokenAmount > 0, "Invalid withdrawal amount");
994 
995         // Wake up the reentrancy guard
996         _reentrancyMutexForWithdrawals = 1;
997 
998         // Refresh the current timelime, if needed
999         compute();
1000 
1001         // Make sure the sender has enough receipt tokens to burn
1002         require(_receiptToken.balanceOf(msg.sender) >= receiptTokenAmount, "Insufficient balance of tokens");
1003 
1004         // The amount of USDC you get in exchange, at the current token price
1005         uint256 withdrawalAmount = toErc20Amount(receiptTokenAmount);
1006         require(withdrawalAmount <= _records[currentPeriod].totalDeposited, "Invalid withdrawal amount");
1007 
1008         uint256 maxWithdrawalAmount = _records[currentPeriod].totalDeposited * (uint256(100) - uint256(investmentPercent)) / uint256(100);
1009         require(withdrawalAmount <= maxWithdrawalAmount, "Max withdrawal amount exceeded");
1010 
1011         uint256 currentBalance = underlyingTokenInterface.balanceOf(address(this));
1012         require(currentBalance >= withdrawalAmount, "Insufficient funds in the buffer");
1013 
1014         // Notice that the fee is applied in the underlying currency instead of receipt tokens.
1015         // The amount applicable to the fee
1016         uint256 feeAmount = (flatFeePercent > 0) ? withdrawalAmount * flatFeePercent / uint256(100) / _decimalsMultiplier : 0;
1017         require(feeAmount < withdrawalAmount, "Invalid fee");
1018 
1019         // The amount to send to the destination address (recipient), after applying the fee
1020         uint256 withdrawalAmountAfterFees = withdrawalAmount - feeAmount;
1021 
1022         // Update the record per amount withdrawn, with no applicable fees.
1023         // A common mistake would be update the metric below with fees included. DONT DO THAT.
1024         _records[currentPeriod].totalDeposited -= withdrawalAmount;
1025 
1026         // Burn the number of receipt tokens specified
1027         _receiptToken.burn(msg.sender, receiptTokenAmount);
1028 
1029         // Transfer the respective amount of underlying tokens to the sender (after applying the fee)
1030         require(underlyingTokenInterface.transfer(msg.sender, withdrawalAmountAfterFees), "Token transfer failed");
1031 
1032         if (feeAmount > 0) {
1033             // Transfer the applicable fee, if any
1034             require(underlyingTokenInterface.transfer(feesAddress, feeAmount), "Fee transfer failed");
1035         }
1036 
1037         // Emit a new "withdrawal" event
1038         emit OnVaultWithdrawal(address(underlyingTokenInterface), msg.sender, withdrawalAmount, receiptTokenAmount, feeAmount);
1039 
1040         // Reset the reentrancy guard
1041         _reentrancyMutexForWithdrawals = 0; // solhint-disable-line reentrancy
1042     }
1043 
1044     /**
1045      * @notice Runs an emergency withdrawal. Sends the whole balance to the address specified.
1046      * @dev This function can be called by the owner only.
1047      * @param destinationAddr The destination address
1048      */
1049     function emergencyWithdraw (address destinationAddr) public onlyOwner ifNotReentrantWithdrawal {
1050         require(destinationAddr != address(0) && destinationAddr != address(this), "Invalid address");
1051 
1052         // Wake up the reentrancy guard
1053         _reentrancyMutexForWithdrawals = 1;
1054 
1055         uint256 currentBalance = underlyingTokenInterface.balanceOf(address(this));
1056         require(currentBalance > 0, "The vault has no funds");
1057 
1058         // Transfer all funds to the address specified
1059         require(underlyingTokenInterface.transfer(destinationAddr, currentBalance), "Token transfer failed");
1060 
1061         emit OnEmergencyWithdraw(currentBalance);
1062 
1063         // Reset the reentrancy guard
1064         _reentrancyMutexForWithdrawals = 0; // solhint-disable-line reentrancy
1065     }
1066 
1067     /**
1068      * @notice Updates the APR
1069      * @dev The APR must be expressed with 2 decimal places. Example: 5% = 500 whereas 5.75% = 575
1070      * @param newApr The new APR, expressed with 2 decimal places.
1071      */
1072     function changeApr (uint256 newApr) public onlyOwner {
1073         require(newApr > 0, "Invalid APR");
1074 
1075         compute();
1076 
1077         emit OnAprChanged(_records[currentPeriod].apr, newApr);
1078         _records[currentPeriod].apr = newApr;
1079     }
1080 
1081     /**
1082      * @notice Sets the token price, arbitrarily.
1083      * @param newTokenPrice The new price of the receipt token
1084      */
1085     function setTokenPrice (uint256 newTokenPrice) public onlyOwner {
1086         require(newTokenPrice > 0, "Invalid token price");
1087 
1088         compute();
1089 
1090         emit OnTokenPriceChanged(_records[currentPeriod].tokenPrice, newTokenPrice);
1091         _records[currentPeriod].tokenPrice = newTokenPrice;
1092     }
1093 
1094     /**
1095      * @notice Sets the investment percent.
1096      * @param newPercent The new investment percent
1097      */
1098     function setInvestmentPercent (uint8 newPercent) public onlyOwnerOrController {
1099         require(newPercent > 0 && newPercent < 100, "Invalid investment percent");
1100 
1101         emit OnInvestmentPercentChanged(investmentPercent, newPercent);
1102         investmentPercent = newPercent;
1103     }
1104 
1105     /**
1106      * @notice Computes the metrics (token price, daily interest) for the current day of year
1107      */
1108     function compute () public {
1109         uint256 currentTimestamp = block.timestamp; // solhint-disable-line not-rely-on-time
1110 
1111         uint256 newPeriod = DateUtils.diffDays(startOfYearTimestamp, currentTimestamp);
1112         if (newPeriod <= currentPeriod) return;
1113 
1114         uint256 x = 0;
1115 
1116         for (uint256 i = currentPeriod + 1; i <= newPeriod; i++) {
1117             x++;
1118             _records[i].apr = _records[i - 1].apr;
1119             _records[i].totalDeposited = _records[i - 1].totalDeposited;
1120 
1121             uint256 diff = _records[i - 1].apr * USDF_DECIMAL_MULTIPLIER * uint256(100) / uint256(36500);
1122             _records[i].tokenPrice = _records[i - 1].tokenPrice + (diff / uint256(10000));
1123             _records[i].dailyInterest = _records[i - 1].totalDeposited * uint256(_records[i - 1].apr) / uint256(3650000);
1124             if (x >= 30) break;
1125         }
1126 
1127         currentPeriod += x;
1128     }
1129 
1130     /**
1131      * @notice Moves the deployable capital from the vault to the yield reserve.
1132      * @dev This function should fail if it would cause the vault to be left with <10% of deposited amount
1133      */
1134     function lockCapital () public onlyOwnerOrController ifNotReentrantWithdrawal {
1135         // Wake up the reentrancy guard
1136         _reentrancyMutexForWithdrawals = 1;
1137 
1138         compute();
1139 
1140         // Get the maximum amount of capital that can be deployed at this point in time
1141         uint256 maxDeployableAmount = getDeployableCapital();
1142         require(maxDeployableAmount > 0, "No capital to deploy");
1143 
1144         require(underlyingTokenInterface.transfer(yieldReserveAddress, maxDeployableAmount), "Transfer failed");
1145         emit OnCapitalLocked(maxDeployableAmount);
1146 
1147         // Reset the reentrancy guard
1148         _reentrancyMutexForWithdrawals = 0; // solhint-disable-line reentrancy
1149     }
1150 
1151     /**
1152      * @notice Claims the daily interest promised per APR.
1153      */
1154     function claimDailyInterest () public onlyOwnerOrController {
1155         compute();
1156 
1157         // Get the daily interest that need to be claimed at this point in time
1158         uint256 dailyInterestAmount = getDailyInterest();
1159 
1160         uint256 balanceBefore = underlyingTokenInterface.balanceOf(address(this));
1161 
1162         IDeployable(yieldReserveAddress).claim(dailyInterestAmount);
1163 
1164         uint256 balanceAfter = underlyingTokenInterface.balanceOf(address(this));
1165 
1166         require(balanceAfter >= balanceBefore + dailyInterestAmount, "Balance verification failed");
1167 
1168         emit OnInterestClaimed(dailyInterestAmount);
1169     }
1170 
1171     /**
1172      * @notice Gets the period of the current unix epoch.
1173      * @dev The period is the zero-based day of the current year. It is the number of days that elapsed since January 1st of the current year.
1174      * @return Returns a number between [0..364]
1175      */
1176     function getPeriodOfCurrentEpoch () public view returns (uint256) {
1177         return DateUtils.diffDays(startOfYearTimestamp, block.timestamp); // solhint-disable-line not-rely-on-time
1178     }
1179 
1180     function getSnapshot (uint256 i) public view returns (uint256 apr, uint256 tokenPrice, uint256 totalDeposited, uint256 dailyInterest) {
1181         apr = _records[i].apr;
1182         tokenPrice = _records[i].tokenPrice;
1183         totalDeposited = _records[i].totalDeposited;
1184         dailyInterest = _records[i].dailyInterest;
1185     }
1186 
1187     /**
1188      * @notice Gets the total amount deposited in the vault.
1189      * @dev This value increases when people deposits funds in the vault. Likewise, it decreases when people withdraw from the vault.
1190      * @return The total amount deposited in the vault.
1191      */
1192     function getTotalDeposited () public view returns (uint256) {
1193         return _records[currentPeriod].totalDeposited;
1194     }
1195 
1196     /**
1197      * @notice Gets the daily interest
1198      * @return The daily interest
1199      */
1200     function getDailyInterest () public view returns (uint256) {
1201         return _records[currentPeriod].dailyInterest;
1202     }
1203 
1204     /**
1205      * @notice Gets the current token price
1206      * @return The price of the token
1207      */
1208     function getTokenPrice () public view returns (uint256) {
1209         return _records[currentPeriod].tokenPrice;
1210     }
1211 
1212     /**
1213      * @notice Gets the maximum amount of USDC/ERC20 you can withdraw from the vault
1214      * @return The maximum withdrawal amount
1215      */
1216     function getMaxWithdrawalAmount () public view returns (uint256) {
1217         return _records[currentPeriod].totalDeposited * (uint256(100) - uint256(investmentPercent)) / uint256(100);
1218     }
1219 
1220     /**
1221      * @notice Gets the amount of capital that can be deployed.
1222      * @dev This is the amount of capital that will be moved from the Vault to the Yield Reserve.
1223      * @return The amount of deployable capital
1224      */
1225     function getDeployableCapital () public view returns (uint256) {
1226         // X% of the total deposits should remain in the vault. This is the target vault balance.
1227         //
1228         // For example:
1229         // ------------
1230         // If the total deposits are 800k USDC and the investment percent is set to 90%
1231         // then the vault should keep the remaining 10% as a buffer for withdrawals.
1232         // In this example the vault should keep 80k USDC, which is the 10% of 800k USDC.
1233         uint256 shouldRemainInVault = _records[currentPeriod].totalDeposited * (uint256(100) - uint256(investmentPercent)) / uint256(100);
1234 
1235         // The current balance at the Vault
1236         uint256 currentBalance = underlyingTokenInterface.balanceOf(address(this));
1237 
1238         // Return the amount of deployable capital
1239         return (currentBalance > shouldRemainInVault) ? currentBalance - shouldRemainInVault : 0;
1240     }
1241 
1242     /**
1243      * @notice Returns the amount of USDC you would get by burning the number of receipt tokens specified, at the current price.
1244      * @return The amount of USDC you get in exchange, at the current token price
1245      */
1246     function toErc20Amount (uint256 receiptTokenAmount) public view returns (uint256) {
1247         return receiptTokenAmount * _records[currentPeriod].tokenPrice / USDF_DECIMAL_MULTIPLIER;
1248     }
1249 }