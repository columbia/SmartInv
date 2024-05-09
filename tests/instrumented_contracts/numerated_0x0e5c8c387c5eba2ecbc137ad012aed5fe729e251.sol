1 pragma solidity 0.5.17;
2 
3 /**
4  * Utility library of inline functions on addresses
5  */
6 library Address {
7     /**
8      * Returns whether the target address is a contract
9      * @dev This function will return false if invoked during the constructor of a contract,
10      * as the code is not actually created until after the constructor finishes.
11      * @param account address of the account to check
12      * @return whether the target address is a contract
13      */
14     function isContract(address account) internal view returns (bool) {
15         uint256 size;
16         // XXX Currently there is no better way to check if there is a contract in an address
17         // than to check the size of the code at that address.
18         // See https://ethereum.stackexchange.com/a/14016/36603
19         // for more details about how this works.
20         // TODO Check this again before the Serenity release, because all addresses will be
21         // contracts then.
22         // solhint-disable-next-line no-inline-assembly
23         assembly { size := extcodesize(account) }
24         return size > 0;
25     }
26 }
27 
28 contract BurnRole {
29     using Roles for Roles.Role;
30 
31     event BurnerAdded(address indexed account);
32     event BurnerRemoved(address indexed account);
33 
34     Roles.Role private _burners;
35 
36     constructor () internal {
37         _addBurner(msg.sender);
38     }
39 
40     modifier onlyBurner() {
41         require(isBurner(msg.sender));
42         _;
43     }
44 
45     function isBurner(address account) public view returns (bool) {
46         return _burners.has(account);
47     }
48 
49     function addBurner(address account) public onlyBurner {
50         _addBurner(account);
51     }
52 
53     function renounceBurner() public {
54         _removeBurner(msg.sender);
55     }
56 
57     function _addBurner(address account) internal {
58         _burners.add(account);
59         emit BurnerAdded(account);
60     }
61 
62     function _removeBurner(address account) internal {
63         _burners.remove(account);
64         emit BurnerRemoved(account);
65     }
66 }
67 
68 
69 /**
70  * @title SafeMath
71  * @dev Unsigned math operations with safety checks that revert on error.
72  */
73 library SafeMath {
74     /**
75      * @dev Multiplies two unsigned integers, reverts on overflow.
76      */
77     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
78         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
79         // benefit is lost if 'b' is also tested.
80         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
81         if (a == 0) {
82             return 0;
83         }
84 
85         uint256 c = a * b;
86         require(c / a == b);
87 
88         return c;
89     }
90 
91     /**
92      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
93      */
94     function div(uint256 a, uint256 b) internal pure returns (uint256) {
95         // Solidity only automatically asserts when dividing by 0
96         require(b > 0);
97         uint256 c = a / b;
98         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
99 
100         return c;
101     }
102 
103     /**
104      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
105      */
106     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
107         require(b <= a);
108         uint256 c = a - b;
109 
110         return c;
111     }
112 
113     /**
114      * @dev Adds two unsigned integers, reverts on overflow.
115      */
116     function add(uint256 a, uint256 b) internal pure returns (uint256) {
117         uint256 c = a + b;
118         require(c >= a);
119 
120         return c;
121     }
122 
123     /**
124      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
125      * reverts when dividing by zero.
126      */
127     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
128         require(b != 0);
129         return a % b;
130     }
131 }
132 
133 
134 /**
135  * @title ERC20 interface
136  * @dev see https://eips.ethereum.org/EIPS/eip-20
137  */
138 interface IERC20 {
139     function transfer(address to, uint256 value) external returns (bool);
140 
141     function approve(address spender, uint256 value) external returns (bool);
142 
143     function transferFrom(address from, address to, uint256 value) external returns (bool);
144 
145     function totalSupply() external view returns (uint256);
146 
147     function balanceOf(address who) external view returns (uint256);
148 
149     function allowance(address owner, address spender) external view returns (uint256);
150 
151     event Transfer(address indexed from, address indexed to, uint256 value);
152 
153     event Approval(address indexed owner, address indexed spender, uint256 value);
154 }
155 
156 
157 /**
158  * @title Standard ERC20 token
159  *
160  * @dev Implementation of the basic standard token.
161  * https://eips.ethereum.org/EIPS/eip-20
162  * Originally based on code by FirstBlood:
163  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
164  *
165  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
166  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
167  * compliant implementations may not do it.
168  */
169 contract ERC20 is IERC20 {
170     using SafeMath for uint256;
171 
172     mapping (address => uint256) private _balances;
173 
174     mapping (address => mapping (address => uint256)) private _allowed;
175 
176     uint256 private _totalSupply;
177 
178     /**
179      * @dev Total number of tokens in existence.
180      */
181     function totalSupply() public view returns (uint256) {
182         return _totalSupply;
183     }
184 
185     /**
186      * @dev Gets the balance of the specified address.
187      * @param owner The address to query the balance of.
188      * @return A uint256 representing the amount owned by the passed address.
189      */
190     function balanceOf(address owner) public view returns (uint256) {
191         return _balances[owner];
192     }
193 
194     /**
195      * @dev Function to check the amount of tokens that an owner allowed to a spender.
196      * @param owner address The address which owns the funds.
197      * @param spender address The address which will spend the funds.
198      * @return A uint256 specifying the amount of tokens still available for the spender.
199      */
200     function allowance(address owner, address spender) public view returns (uint256) {
201         return _allowed[owner][spender];
202     }
203 
204     /**
205      * @dev Transfer token to a specified address.
206      * @param to The address to transfer to.
207      * @param value The amount to be transferred.
208      */
209     function transfer(address to, uint256 value) public returns (bool) {
210         _transfer(msg.sender, to, value);
211         return true;
212     }
213 
214     /**
215      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
216      * Beware that changing an allowance with this method brings the risk that someone may use both the old
217      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
218      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
219      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
220      * @param spender The address which will spend the funds.
221      * @param value The amount of tokens to be spent.
222      */
223     function approve(address spender, uint256 value) public returns (bool) {
224         _approve(msg.sender, spender, value);
225         return true;
226     }
227 
228     /**
229      * @dev Transfer tokens from one address to another.
230      * Note that while this function emits an Approval event, this is not required as per the specification,
231      * and other compliant implementations may not emit the event.
232      * @param from address The address which you want to send tokens from
233      * @param to address The address which you want to transfer to
234      * @param value uint256 the amount of tokens to be transferred
235      */
236     function transferFrom(address from, address to, uint256 value) public returns (bool) {
237         _transfer(from, to, value);
238         _approve(from, msg.sender, _allowed[from][msg.sender].sub(value));
239         return true;
240     }
241 
242     /**
243      * @dev Increase the amount of tokens that an owner allowed to a spender.
244      * approve should be called when _allowed[msg.sender][spender] == 0. To increment
245      * allowed value is better to use this function to avoid 2 calls (and wait until
246      * the first transaction is mined)
247      * From MonolithDAO Token.sol
248      * Emits an Approval event.
249      * @param spender The address which will spend the funds.
250      * @param addedValue The amount of tokens to increase the allowance by.
251      */
252     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
253         _approve(msg.sender, spender, _allowed[msg.sender][spender].add(addedValue));
254         return true;
255     }
256 
257     /**
258      * @dev Decrease the amount of tokens that an owner allowed to a spender.
259      * approve should be called when _allowed[msg.sender][spender] == 0. To decrement
260      * allowed value is better to use this function to avoid 2 calls (and wait until
261      * the first transaction is mined)
262      * From MonolithDAO Token.sol
263      * Emits an Approval event.
264      * @param spender The address which will spend the funds.
265      * @param subtractedValue The amount of tokens to decrease the allowance by.
266      */
267     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
268         _approve(msg.sender, spender, _allowed[msg.sender][spender].sub(subtractedValue));
269         return true;
270     }
271 
272     /**
273      * @dev Transfer token for a specified addresses.
274      * @param from The address to transfer from.
275      * @param to The address to transfer to.
276      * @param value The amount to be transferred.
277      */
278     function _transfer(address from, address to, uint256 value) internal {
279         require(to != address(0));
280 
281         _balances[from] = _balances[from].sub(value);
282         _balances[to] = _balances[to].add(value);
283         emit Transfer(from, to, value);
284     }
285 
286     /**
287      * @dev Internal function that mints an amount of the token and assigns it to
288      * an account. This encapsulates the modification of balances such that the
289      * proper events are emitted.
290      * @param account The account that will receive the created tokens.
291      * @param value The amount that will be created.
292      */
293     function _mint(address account, uint256 value) internal {
294         require(account != address(0));
295 
296         _totalSupply = _totalSupply.add(value);
297         _balances[account] = _balances[account].add(value);
298         emit Transfer(address(0), account, value);
299     }
300 
301     /**
302      * @dev Internal function that burns an amount of the token of a given
303      * account.
304      * @param account The account whose tokens will be burnt.
305      * @param value The amount that will be burnt.
306      */
307     function _burn(address account, uint256 value) internal {
308         require(account != address(0));
309 
310         _totalSupply = _totalSupply.sub(value);
311         _balances[account] = _balances[account].sub(value);
312         emit Transfer(account, address(0), value);
313     }
314 
315     /**
316      * @dev Approve an address to spend another addresses' tokens.
317      * @param owner The address that owns the tokens.
318      * @param spender The address that will spend the tokens.
319      * @param value The number of tokens that can be spent.
320      */
321     function _approve(address owner, address spender, uint256 value) internal {
322         require(spender != address(0));
323         require(owner != address(0));
324 
325         _allowed[owner][spender] = value;
326         emit Approval(owner, spender, value);
327     }
328 }
329 
330 
331 /**
332  * @title Burnable Token
333  * @dev Token that can be irreversibly burned (destroyed).
334  */
335 contract ERC20Burnable is ERC20, BurnRole{
336     /**
337      * @dev Burns a specific amount of tokens.
338      * @param value The amount of token to be burned.
339      */
340     function burn(uint256 value) public onlyBurner returns (bool){
341         _burn(msg.sender, value);
342         return true;
343     }
344 }
345 
346 
347 contract MinterRole {
348     using Roles for Roles.Role;
349 
350     event MinterAdded(address indexed account);
351     event MinterRemoved(address indexed account);
352 
353     Roles.Role private _minters;
354 
355     constructor () internal {
356         _addMinter(msg.sender);
357     }
358 
359     modifier onlyMinter() {
360         require(isMinter(msg.sender));
361         _;
362     }
363 
364     function isMinter(address account) public view returns (bool) {
365         return _minters.has(account);
366     }
367 
368     function addMinter(address account) external onlyMinter {
369         _addMinter(account);
370     }
371 
372     function renounceMinter() public {
373         _removeMinter(msg.sender);
374     }
375 
376     function _addMinter(address account) internal {
377         _minters.add(account);
378         emit MinterAdded(account);
379     }
380 
381     function _removeMinter(address account) internal {
382         _minters.remove(account);
383         emit MinterRemoved(account);
384     }
385 }
386 
387 
388 
389 /**
390  * @title ERC20Mintable
391  * @dev ERC20 minting logic.
392  */
393 contract ERC20Mintable is ERC20, MinterRole{
394     /**
395      * @dev Function to mint tokens
396      * @param to The address that will receive the minted tokens.
397      * @param value The amount of tokens to mint.
398      * @return A boolean that indicates if the operation was successful.
399      */
400     function mint(address to, uint256 value) external onlyMinter returns (bool) {
401         _mint(to, value);
402         return true;
403     }
404 }
405 
406 
407 /**
408  * @title Capped token
409  * @dev Mintable token with a token cap.
410  */
411 contract ERC20Capped is ERC20Mintable {
412     uint256 private _cap;
413 
414     constructor (uint256 cap) public {
415         require(cap > 0);
416         _cap = cap;
417     }
418 
419     /**
420      * @return the cap for the token minting.
421      */
422     function cap() public view returns (uint256) {
423         return _cap;
424     }
425 
426     function _mint(address account, uint256 value) internal {
427         require(totalSupply().add(value) <= _cap);
428         super._mint(account, value);
429     }
430 }
431 
432 
433 /**
434  * @title ERC20Detailed token
435  * @dev The decimals are only for visualization purposes.
436  * All the operations are done using the smallest and indivisible token unit,
437  * just as on Ethereum all the operations are done in wei.
438  */
439 contract ERC20Detailed is IERC20 {
440     string private _name;
441     string private _symbol;
442     uint8 private _decimals;
443 
444     constructor (string memory name, string memory symbol, uint8 decimals) public {
445         _name = name;
446         _symbol = symbol;
447         _decimals = decimals;
448     }
449 
450     /**
451      * @return the name of the token.
452      */
453     function name() public view returns (string memory) {
454         return _name;
455     }
456 
457     /**
458      * @return the symbol of the token.
459      */
460     function symbol() public view returns (string memory) {
461         return _symbol;
462     }
463 
464     /**
465      * @return the number of decimals of the token.
466      */
467     function decimals() public view returns (uint8) {
468         return _decimals;
469     }
470 }
471 
472 
473 
474 /**
475  * @title Ownable
476  * @dev The Ownable contract has an owner address, and provides basic authorization control
477  * functions, this simplifies the implementation of "user permissions".
478  */
479 contract Ownable {
480     address private _owner;
481 
482     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
483 
484     /**
485      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
486      * account.
487      */
488     constructor () internal {
489         _owner = msg.sender;
490         emit OwnershipTransferred(address(0), _owner);
491     }
492 
493     /**
494      * @return the address of the owner.
495      */
496     function owner() public view returns (address) {
497         return _owner;
498     }
499 
500     /**
501      * @dev Throws if called by any account other than the owner.
502      */
503     modifier onlyOwner() {
504         require(isOwner());
505         _;
506     }
507 
508     /**
509      * @return true if `msg.sender` is the owner of the contract.
510      */
511     function isOwner() public view returns (bool) {
512         return msg.sender == _owner;
513     }
514 
515     /**
516      * @dev Allows the current owner to relinquish control of the contract.
517      * It will not be possible to call the functions with the `onlyOwner`
518      * modifier anymore.
519      * @notice Renouncing ownership will leave the contract without an owner,
520      * thereby removing any functionality that is only available to the owner.
521      */
522     function renounceOwnership() public onlyOwner {
523         emit OwnershipTransferred(_owner, address(0));
524         _owner = address(0);
525     }
526 
527     /**
528      * @dev Allows the current owner to transfer control of the contract to a newOwner.
529      * @param newOwner The address to transfer ownership to.
530      */
531     function transferOwnership(address newOwner) public onlyOwner {
532         _transferOwnership(newOwner);
533     }
534 
535     /**
536      * @dev Transfers control of the contract to a newOwner.
537      * @param newOwner The address to transfer ownership to.
538      */
539     function _transferOwnership(address newOwner) internal {
540         require(newOwner != address(0));
541         emit OwnershipTransferred(_owner, newOwner);
542         _owner = newOwner;
543     }
544 }
545 
546 
547 /**
548  * @title Roles
549  * @dev Library for managing addresses assigned to a Role.
550  */
551 library Roles {
552     struct Role {
553         mapping (address => bool) bearer;
554     }
555 
556     /**
557      * @dev Give an account access to this role.
558      */
559     function add(Role storage role, address account) internal {
560         require(account != address(0));
561         require(!has(role, account));
562 
563         role.bearer[account] = true;
564     }
565 
566     /**
567      * @dev Remove an account's access to this role.
568      */
569     function remove(Role storage role, address account) internal {
570         require(account != address(0));
571         require(has(role, account));
572 
573         role.bearer[account] = false;
574     }
575 
576     /**
577      * @dev Check if an account has this role.
578      * @return bool
579      */
580     function has(Role storage role, address account) internal view returns (bool) {
581         require(account != address(0));
582         return role.bearer[account];
583     }
584 }
585 
586 
587 /**
588  * @title SafeERC20
589  * @dev Wrappers around ERC20 operations that throw on failure (when the token
590  * contract returns false). Tokens that return no value (and instead revert or
591  * throw on failure) are also supported, non-reverting calls are assumed to be
592  * successful.
593  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
594  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
595  */
596 library SafeERC20 {
597     using SafeMath for uint256;
598     using Address for address;
599 
600     function safeTransfer(IERC20 token, address to, uint256 value) internal {
601         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
602     }
603 
604     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
605         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
606     }
607 
608     function safeApprove(IERC20 token, address spender, uint256 value) internal {
609         // safeApprove should only be called when setting an initial allowance,
610         // or when resetting it to zero. To increase and decrease it, use
611         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
612         require((value == 0) || (token.allowance(address(this), spender) == 0));
613         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
614     }
615 
616     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
617         uint256 newAllowance = token.allowance(address(this), spender).add(value);
618         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
619     }
620 
621     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
622         uint256 newAllowance = token.allowance(address(this), spender).sub(value);
623         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
624     }
625 
626     /**
627      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
628      * on the return value: the return value is optional (but if data is returned, it must not be false).
629      * @param token The token targeted by the call.
630      * @param data The call data (encoded using abi.encode or one of its variants).
631      */
632     function callOptionalReturn(IERC20 token, bytes memory data) private {
633         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
634         // we're implementing it ourselves.
635 
636         // A Solidity high level call has three parts:
637         //  1. The target address is checked to verify it contains contract code
638         //  2. The call itself is made, and success asserted
639         //  3. The return value is decoded, which in turn checks the size of the returned data.
640 
641         require(address(token).isContract());
642 
643         // solhint-disable-next-line avoid-low-level-calls
644         (bool success, bytes memory returndata) = address(token).call(data);
645         require(success);
646 
647         if (returndata.length > 0) { // Return data is optional
648             require(abi.decode(returndata, (bool)));
649         }
650     }
651 }
652 
653 contract RPGBurn is Ownable {
654     using Address for address;
655     using SafeMath for uint256;
656 
657     ERC20Burnable private _token;
658 
659     constructor(ERC20Burnable token) public {
660         _token = token;
661     }
662 
663     function burn(uint256 value) onlyOwner public {
664         _token.burn(value);
665     }
666 }
667 
668 
669 contract RPG is
670     ERC20,
671     ERC20Detailed,
672     ERC20Burnable,
673     ERC20Capped,
674     Ownable
675 {
676     using Address for address;
677     uint256 public constant INITIAL_SUPPLY = 21000000 * (10**18);
678     mapping(address => uint8) public limit;
679     RPGBurn public burnContract;
680 
681     constructor(string memory name, string memory symbol)
682         public
683         Ownable()
684         ERC20Capped(INITIAL_SUPPLY)
685         ERC20Burnable()
686         ERC20Detailed(name, symbol, 18)
687         ERC20()
688     {
689         // mint all tokens
690         _mint(msg.sender, INITIAL_SUPPLY);
691 
692         // create burner contract
693         burnContract = new RPGBurn(this);
694         addBurner(address(burnContract));
695     }
696 
697     /**
698      * Set target address transfer limit
699      * @param addr target address
700      * @param mode limit mode (0: no limit, 1: can not transfer token, 2: can not receive token)
701      */
702     function setTransferLimit(address addr, uint8 mode) public onlyOwner {
703         require(mode == 0 || mode == 1 || mode == 2);
704 
705         if (mode == 0) {
706             delete limit[addr];
707         } else {
708             limit[addr] = mode;
709         }
710     }
711 
712     /**
713      * @dev Transfer token to a specified address.
714      * @param to The address to transfer to.
715      * @param value The amount to be transferred.
716      */
717     function transfer(address to, uint256 value) public returns (bool) {
718         require(limit[msg.sender] != 1, 'from address is limited.');
719         require(limit[to] != 2, 'to address is limited.');
720 
721         _transfer(msg.sender, to, value);
722 
723         return true;
724     }
725 
726     function burnFromContract(uint256 value) onlyBurner public {
727         burnContract.burn(value);
728     }
729 }
730 
731 contract RPGVesting is Ownable {
732     using Address for address;
733     using SafeMath for uint256;
734 
735     RPG private _token;
736     RPGVestingA private _investors = RPGVestingA(0);
737     RPGVestingB private _incubator_adviser;
738     RPGVestingC private _development;
739     RPGVestingD private _community;
740     RPGVestingE private _fund;
741 
742     uint256 public INITIAL_SUPPLY;
743 
744     event event_debug(uint256 amount);
745 
746     constructor() public {
747 
748     }
749 
750     function init(
751         RPG token,RPGVestingA investors_addr,RPGVestingB incubator_adviser_addr,RPGVestingC development_addr,RPGVestingD community_addr,RPGVestingE fund_addr,
752         address[] memory investors,          //10%-----A
753         uint256[] memory investors_number,
754         address[] memory incubator_advisers, //7%-----B
755         uint256[] memory incubator_advisers_number,
756         address developments,               //14%----C
757         address community,                  //49%----D  mutisigncontract address
758         address[3] memory fund              //20%----E
759     ) public onlyOwner {
760         require(address(_investors) == address(0));     //run once
761 
762         //para check
763         require(address(token) != address(0));
764         require(address(investors_addr) != address(0));
765         require(address(incubator_adviser_addr) != address(0));
766         require(address(development_addr) != address(0));
767         require(address(community_addr) != address(0));
768         require(address(fund_addr) != address(0));
769         require(investors.length == investors_number.length);
770         require(incubator_advisers.length == incubator_advisers_number.length);
771         require(developments != address(0));
772         require(community != address(0));
773         require(fund[0] != address(0));
774         require(fund[1] != address(0));
775         require(fund[2] != address(0));
776         //run check
777 
778         _token = token;
779         _investors = investors_addr;
780         _incubator_adviser = incubator_adviser_addr;
781         _development = development_addr;
782         _community = community_addr;
783         _fund = fund_addr;
784         INITIAL_SUPPLY = _token.INITIAL_SUPPLY();
785         require(_token.balanceOf(address(this)) == INITIAL_SUPPLY);
786 
787         // create all vesting contracts
788         // _investors          = new RPGVestingA(_token,INITIAL_SUPPLY.mul(9).div(100));
789         // _incubator_adviser  = new RPGVestingB(_token,INITIAL_SUPPLY.mul(7).div(100));
790         // _development        = new RPGVestingB(_token,INITIAL_SUPPLY.mul(14).div(100));
791         // _community          = new RPGVestingC(_token,community,INITIAL_SUPPLY.mul(49).div(100));
792         // _fund               = new RPGVestingD(_token,fund,INITIAL_SUPPLY.mul(21).div(100));
793 
794         //init
795         require(_investors.init(_token,INITIAL_SUPPLY.mul(10).div(100),investors,investors_number));
796         require(_incubator_adviser.init(_token,INITIAL_SUPPLY.mul(7).div(100),incubator_advisers,incubator_advisers_number));
797         require(_development.init(_token,developments,INITIAL_SUPPLY.mul(14).div(100)));
798         require(_community.init(_token,community,INITIAL_SUPPLY.mul(49).div(100)));
799         require(_fund.init(_token,fund,INITIAL_SUPPLY.mul(20).div(100)));
800 
801         //transfer tokens to vesting contracts
802         _token.transfer(address(_investors)         , _investors.total());
803         _token.transfer(address(_incubator_adviser) , _incubator_adviser.total());
804         _token.transfer(address(_development)       , _development.total());
805         _token.transfer(address(_community)         , _community.total());
806         _token.transfer(address(_fund)              , _fund.total());
807 
808     }
809 
810     function StartIDO(uint256 start) public onlyOwner {
811         require(start >= block.timestamp);
812 
813         _investors.setStart(start);
814         _fund.setStart(start);
815     }
816 
817     function StartMainnet(uint256 start) public onlyOwner {
818         require(start >= block.timestamp);
819         require(start >= _investors.start());
820 
821         _incubator_adviser.setStart(start);
822         _development.setStart(start);
823         _community.setStart(start);
824     }
825 
826     function StartInvestorsClaim() public onlyOwner {
827         require(_investors.start() > 0 && _investors.start() < block.timestamp);
828 
829         _investors.setcanclaim();
830     }
831 
832     function investors() public view returns (address) {
833         return address(_investors);
834     }
835 
836     function incubator_adviser() public view returns (address) {
837         return address(_incubator_adviser);
838     }
839 
840     function development() public view returns (address) {
841         return address(_development);
842     }
843 
844     function community() public view returns (address) {
845         return address(_community);
846     }
847 
848     function fund() public view returns (address) {
849         return address(_fund);
850     }
851 
852     ////calc vesting number/////////////////////////////
853     function unlocked_investors_vesting(address user) public view returns(uint256) {
854         return _investors.calcvesting(user);
855     }
856 
857     function unlocked_incubator_adviser_vesting(address user) public view returns(uint256) {
858         return _incubator_adviser.calcvesting(user);
859     }
860 
861     function unlocked_development_vesting() public view returns(uint256) {
862         return _development.calcvesting();
863     }
864 
865     function unlocked_community_vesting() public view returns(uint256) {
866         return _community.calcvesting();
867     }
868 
869     // function calc_fund_vesting() public view returns(uint256) {
870     //     return _fund.calcvesting();
871     // }
872 
873     ///////claimed amounts//////////////////////////////
874     function claimed_investors(address user) public view returns(uint256){
875         return _investors.claimed(user);
876     }
877 
878     function claimed_incubator_adviser(address user) public view returns(uint256){
879         return _incubator_adviser.claimed(user);
880     }
881 
882     function claimed_development() public view returns(uint256){
883         return _development.claimed();
884     }
885 
886     function claimed_community() public view returns(uint256){
887         return _community.claimed();
888     }
889 
890     //////change address/////////////////////////////////
891     function investors_changeaddress(address oldaddr,address newaddr) onlyOwner public{
892         require(newaddr != address(0));
893 
894         _investors.changeaddress(oldaddr,newaddr);
895     }
896 
897     function incubator_adviser_changeaddress(address oldaddr,address newaddr) onlyOwner public{
898         require(newaddr != address(0));
899 
900         _incubator_adviser.changeaddress(oldaddr,newaddr);
901     }
902 
903     function community_changeaddress(address newaddr) onlyOwner public{
904         require(newaddr != address(0));
905 
906         _community.changeaddress(newaddr);
907     }
908 
909 }
910 
911 contract RPGVestingA {
912 
913     using SafeMath for uint256;
914     using SafeERC20 for IERC20;
915     using Address for address;
916 
917     address _vestingaddr;
918     IERC20 private _token;
919     uint256 private _total;
920     uint256 private _start = 0;
921     bool    private _canclaim = false;
922     address[] private _beneficiarys;
923     uint256 constant _duration = 86400;
924     uint256 constant _releasealldays = 400;
925     mapping(address => uint256) private _beneficiary_total;
926     mapping(address => uint256) private _released;
927 
928     //event
929     event event_set_can_claim();
930     event event_claimed(address user,uint256 amount);
931     event event_change_address(address oldaddr,address newaddr);
932 
933     constructor(address addr) public {
934         require(addr != address(0));
935 
936         _vestingaddr = addr;
937     }
938 
939     function init(IERC20 token, uint256 total,address[] memory beneficiarys,uint256[] memory amounts) public returns(bool) {
940         require(_vestingaddr == msg.sender);
941         require(_beneficiarys.length == 0);     //run once
942 
943         require(address(token) != address(0));
944         require(total > 0);
945         require(beneficiarys.length == amounts.length);
946 
947         _token = token;
948         _total = total;
949 
950         uint256 all = 0;
951         for(uint256 i = 0 ; i < amounts.length; i++)
952         {
953             all = all.add(amounts[i]);
954         }
955         require(all == _total);
956 
957         _beneficiarys = beneficiarys;
958         for(uint256 i = 0 ; i < _beneficiarys.length; i++)
959         {
960             _beneficiary_total[_beneficiarys[i]] = amounts[i];
961             _released[_beneficiarys[i]] = 0;
962         }
963         return true;
964     }
965 
966     function setStart(uint256 newStart) public {
967         require(_vestingaddr == msg.sender);
968         require(newStart > 0 && _start == 0);
969 
970         _start = newStart;
971     }
972 
973     /**
974     * @return the start time of the token vesting.
975     */
976     function start() public view returns (uint256) {
977         return _start;
978     }
979 
980     /**
981      * @return the beneficiary of the tokens.
982      */
983     function beneficiary() public view returns (address[] memory) {
984         return _beneficiarys;
985     }
986 
987     /**
988      * @return total tokens of the beneficiary address.
989      */
990     function beneficiarytotal(address addr) public view returns (uint256) {
991     	require(_beneficiary_total[addr] != 0,'not in beneficiary list');
992         return _beneficiary_total[addr];
993     }
994 
995     /**
996      * @return total of the tokens.
997      */
998     function total() public view returns (uint256) {
999         return _total;
1000     }
1001 
1002     /**
1003      * @return canclaim.
1004      */
1005     function canclaim() public view returns (bool) {
1006         return _canclaim;
1007     }
1008 
1009     function setcanclaim() public {
1010         require(_vestingaddr == msg.sender);
1011         require(!_canclaim,'_canclaim is not false!');
1012 
1013         _canclaim = true;
1014 
1015         emit event_set_can_claim();
1016     }
1017 
1018     /**
1019      * @return total number can release to now.
1020      */
1021     function calcvesting(address user) public view returns(uint256) {
1022         require(_start > 0);
1023         require(block.timestamp >= _start);
1024         require(_beneficiary_total[user] > 0);
1025 
1026         uint256 daynum = block.timestamp.sub(_start).div(_duration);
1027 
1028         if(daynum <= _releasealldays)
1029         {
1030             return _beneficiary_total[user].mul(daynum).div(_releasealldays);
1031         }
1032         else
1033         {
1034             return _beneficiary_total[user];
1035         }
1036     }
1037 
1038     /**
1039      * claim all the tokens to now
1040      * @return claim number this time .
1041      */
1042     function claim() public returns(uint256) {
1043         require(_start > 0);
1044         require(_beneficiary_total[msg.sender] > 0);
1045         require(_canclaim,'claim not allowed!');
1046 
1047         uint256 amount = calcvesting(msg.sender).sub(_released[msg.sender]);
1048         if(amount > 0)
1049         {
1050             _released[msg.sender] = _released[msg.sender].add(amount);
1051             _token.safeTransfer(msg.sender,amount);
1052             emit event_claimed(msg.sender,amount);
1053         }
1054         return amount;
1055     }
1056 
1057     /**
1058      * @return all number has claimed
1059      */
1060     function claimed(address user) public view returns(uint256) {
1061         require(_start > 0);
1062 
1063         return _released[user];
1064     }
1065 
1066     function changeaddress(address oldaddr,address newaddr) public {
1067         require(_beneficiarys.length > 0);
1068         require(_beneficiary_total[newaddr] == 0);
1069 
1070         if(msg.sender == _vestingaddr)
1071         {
1072             for(uint256 i = 0 ; i < _beneficiarys.length; i++)
1073             {
1074                 if(_beneficiarys[i] == oldaddr)
1075                 {
1076                     _beneficiarys[i] = newaddr;
1077                     _beneficiary_total[newaddr] = _beneficiary_total[oldaddr];
1078                     _beneficiary_total[oldaddr] = 0;
1079                     _released[newaddr] = _released[oldaddr];
1080                     _released[oldaddr] = 0;
1081 
1082                     emit event_change_address(oldaddr,newaddr);
1083                     return;
1084                 }
1085             }
1086         }
1087         else
1088         {
1089             require(msg.sender == oldaddr);
1090 
1091             for(uint256 i = 0 ; i < _beneficiarys.length; i++)
1092             {
1093                 if(_beneficiarys[i] == msg.sender)
1094                 {
1095                     _beneficiarys[i] = newaddr;
1096                     _beneficiary_total[newaddr] = _beneficiary_total[msg.sender];
1097                     _beneficiary_total[msg.sender] = 0;
1098                     _released[newaddr] = _released[msg.sender];
1099                     _released[msg.sender] = 0;
1100 
1101                     emit event_change_address(msg.sender,newaddr);
1102                     return;
1103                 }
1104             }
1105         }
1106     }
1107 }
1108 
1109 
1110 contract RPGVestingB {
1111 
1112     using SafeMath for uint256;
1113     using SafeERC20 for IERC20;
1114     using Address for address;
1115 
1116     address _vestingaddr;
1117     IERC20 private _token;
1118     address[] private _beneficiarys;
1119     uint256 private _total;
1120     uint256 private _start = 0;
1121     uint256 constant _duration = 86400;
1122     uint256 constant _releaseperiod = 180;
1123     mapping(address => uint256) private _beneficiary_total;
1124     mapping(address => uint256) private _released;
1125 
1126     //event
1127     event event_claimed(address user,uint256 amount);
1128     event event_change_address(address oldaddr,address newaddr);
1129 
1130     constructor(address addr) public {
1131         require(addr != address(0));
1132 
1133         _vestingaddr = addr;
1134     }
1135 
1136     function init(IERC20 token,uint256 total,address[] memory beneficiarys,uint256[] memory amounts) public returns(bool) {
1137         require(_vestingaddr == msg.sender);
1138         require(_beneficiarys.length == 0); //run once
1139 
1140         require(address(token) != address(0));
1141         require(total > 0);
1142         require(beneficiarys.length == amounts.length);
1143 
1144         _token = token;
1145         _total = total;
1146 
1147         uint256 all = 0;
1148         for(uint256 i = 0 ; i < amounts.length; i++)
1149         {
1150             all = all.add(amounts[i]);
1151         }
1152         require(all == _total);
1153 
1154         _beneficiarys = beneficiarys;
1155         for(uint256 i = 0 ; i < _beneficiarys.length; i++)
1156         {
1157             _beneficiary_total[_beneficiarys[i]] = amounts[i];
1158             _released[_beneficiarys[i]] = 0;
1159         }
1160         return true;
1161     }
1162 
1163     /**
1164      * @return the beneficiary of the tokens.
1165      */
1166     function beneficiary() public view returns (address[] memory) {
1167         return _beneficiarys;
1168     }
1169 
1170     /**
1171      * @return total tokens of the beneficiary address.
1172      */
1173     function beneficiarytotal(address addr) public view returns (uint256) {
1174     	require(_beneficiary_total[addr] != 0,'not in beneficiary list');
1175         return _beneficiary_total[addr];
1176     }
1177 
1178     /**
1179      * @return total of the tokens.
1180      */
1181     function total() public view returns (uint256) {
1182         return _total;
1183     }
1184 
1185     /**
1186      * @return the start time of the token vesting.
1187      */
1188     function start() public view returns (uint256) {
1189         return _start;
1190     }
1191 
1192     function setStart(uint256 newStart) public {
1193         require(_vestingaddr == msg.sender);
1194         require(newStart > 0 && _start == 0);
1195 
1196         _start = newStart;
1197     }
1198 
1199     /**
1200      * @return number to now.
1201      */
1202     function calcvesting(address user) public view returns(uint256) {
1203         require(_start > 0);
1204         require(block.timestamp >= _start);
1205         require(_beneficiary_total[user] > 0);
1206 
1207         uint256 daynum = block.timestamp.sub(_start).div(_duration);
1208 
1209         uint256 counts180 = daynum.div(_releaseperiod);
1210         uint256 dayleft = daynum.mod(_releaseperiod);
1211         uint256 amount180 = 0;
1212         uint256 thistotal = _beneficiary_total[user].mul(8).div(100);
1213         for(uint256 i = 0; i< counts180; i++)
1214         {
1215             amount180 = amount180.add(thistotal);
1216             thistotal = thistotal.mul(92).div(100);     //thistotal.mul(100).div(8).mul(92).div(100).mul(8).div(100);     //next is thistotal/(0.08)*0.92*0.08
1217         }
1218 
1219         return amount180.add(thistotal.mul(dayleft).div(_releaseperiod));
1220     }
1221 
1222     /**
1223      * claim all the tokens to now
1224      * @return claim number this time .
1225      */
1226     function claim() public returns(uint256) {
1227         require(_start > 0);
1228         require(_beneficiary_total[msg.sender] > 0);
1229 
1230         uint256 amount = calcvesting(msg.sender).sub(_released[msg.sender]);
1231         if(amount > 0)
1232         {
1233             _released[msg.sender] = _released[msg.sender].add(amount);
1234             _token.safeTransfer(msg.sender,amount);
1235             emit event_claimed(msg.sender,amount);
1236         }
1237         return amount;
1238     }
1239 
1240     /**
1241      * @return all number has claimed
1242      */
1243     function claimed(address user) public view returns(uint256) {
1244         require(_start > 0);
1245 
1246         return _released[user];
1247     }
1248 
1249     function changeaddress(address oldaddr,address newaddr) public {
1250         require(_beneficiarys.length > 0);
1251         require(_beneficiary_total[newaddr] == 0);
1252 
1253         if(msg.sender == _vestingaddr)
1254         {
1255             for(uint256 i = 0 ; i < _beneficiarys.length; i++)
1256             {
1257                 if(_beneficiarys[i] == oldaddr)
1258                 {
1259                     _beneficiarys[i] = newaddr;
1260                     _beneficiary_total[newaddr] = _beneficiary_total[oldaddr];
1261                     _beneficiary_total[oldaddr] = 0;
1262                     _released[newaddr] = _released[oldaddr];
1263                     _released[oldaddr] = 0;
1264 
1265                     emit event_change_address(oldaddr,newaddr);
1266                     return;
1267                 }
1268             }
1269         }
1270         else
1271         {
1272             require(msg.sender == oldaddr);
1273 
1274             for(uint256 i = 0 ; i < _beneficiarys.length; i++)
1275             {
1276                 if(_beneficiarys[i] == msg.sender)
1277                 {
1278                     _beneficiarys[i] = newaddr;
1279                     _beneficiary_total[newaddr] = _beneficiary_total[msg.sender];
1280                     _beneficiary_total[msg.sender] = 0;
1281                     _released[newaddr] = _released[msg.sender];
1282                     _released[msg.sender] = 0;
1283 
1284                     emit event_change_address(msg.sender,newaddr);
1285                     return;
1286                 }
1287             }
1288         }
1289     }
1290 }
1291 
1292 contract RPGVestingC {
1293     // The vesting schedule is time-based (i.e. using block timestamps as opposed to e.g. block numbers), and is
1294     // therefore sensitive to timestamp manipulation (which is something miners can do, to a certain degree). Therefore,
1295     // it is recommended to avoid using short time durations (less than a minute).
1296     // solhint-disable not-rely-on-time
1297 
1298     using SafeMath for uint256;
1299     using SafeERC20 for IERC20;
1300     using Address for address;
1301 
1302     address _vestingaddr;
1303 
1304     event event_claimed(address user,uint256 amount);
1305 
1306     IERC20 private _token;
1307     uint256 private _total;
1308     uint256 constant _duration = 86400;
1309     uint256 constant _releaseperiod = 180;
1310     uint256 private _released = 0;
1311 
1312     // beneficiary of tokens after they are released
1313     address private _beneficiary = address(0);
1314     uint256 private _start = 0;
1315 
1316     constructor (address addr) public {
1317         require(addr != address(0));
1318 
1319         _vestingaddr = addr;
1320     }
1321 
1322     function init(IERC20 token,address beneficiary, uint256 total) public returns(bool){
1323         require(_vestingaddr == msg.sender);
1324         require(_beneficiary == address(0));    //run once
1325 
1326         require(address(token) != address(0));
1327         require(beneficiary != address(0));
1328         require(total > 0);
1329 
1330         _token = token;
1331         _beneficiary = beneficiary;
1332         _total = total;
1333         return true;
1334     }
1335 
1336     /**
1337      * @return the beneficiary of the tokens.
1338      */
1339     function beneficiary() public view returns (address) {
1340         return _beneficiary;
1341     }
1342 
1343     /**
1344      * @return the start time of the token vesting.
1345      */
1346     function start() public view returns (uint256) {
1347         return _start;
1348     }
1349 
1350     /**
1351      * @return total of the tokens.
1352      */
1353     function total() public view returns (uint256) {
1354         return _total;
1355     }
1356 
1357     function setStart(uint256 newStart) public {
1358         require(_vestingaddr == msg.sender);
1359         require(newStart > 0 && _start == 0);
1360 
1361         _start = newStart;
1362     }
1363 
1364     /**
1365      * @return number to now.
1366      */
1367     function calcvesting() public view returns(uint256) {
1368         require(_start > 0);
1369         require(block.timestamp >= _start);
1370 
1371         uint256 daynum = block.timestamp.sub(_start).div(_duration);
1372 
1373         uint256 counts180 = daynum.div(_releaseperiod);
1374         uint256 dayleft = daynum.mod(_releaseperiod);
1375         uint256 amount180 = 0;
1376         uint256 thistotal = _total.mul(8).div(100);
1377         for(uint256 i = 0; i< counts180; i++)
1378         {
1379             amount180 = amount180.add(thistotal);
1380             thistotal = thistotal.mul(92).div(100);         //thistotal.mul(100).div(8).mul(92).div(100).mul(8).div(100);     //next is thistotal/(0.08)*0.92*0.08
1381         }
1382 
1383         return amount180.add(thistotal.mul(dayleft).div(_releaseperiod));
1384     }
1385 
1386     /**
1387      * @return number of this claim
1388      */
1389     function claim() public returns(uint256) {
1390         require(_start > 0);
1391 
1392         uint256 amount = calcvesting().sub(_released);
1393         if(amount > 0)
1394         {
1395             _released = _released.add(amount);
1396             _token.safeTransfer(_beneficiary,amount);
1397             emit event_claimed(msg.sender,amount);
1398         }
1399         return amount;
1400     }
1401 
1402     /**
1403      * @return all number has claimed
1404      */
1405     function claimed() public view returns(uint256) {
1406         require(_start > 0);
1407 
1408         return _released;
1409     }
1410 }
1411 
1412 contract RPGVestingD {
1413     // The vesting schedule is time-based (i.e. using block timestamps as opposed to e.g. block numbers), and is
1414     // therefore sensitive to timestamp manipulation (which is something miners can do, to a certain degree). Therefore,
1415     // it is recommended to avoid using short time durations (less than a minute).
1416     // solhint-disable not-rely-on-time
1417 
1418     using SafeMath for uint256;
1419     using SafeERC20 for IERC20;
1420     using Address for address;
1421 
1422     address _vestingaddr;
1423 
1424     event event_claimed(address user,uint256 amount);
1425 
1426     IERC20 private _token;
1427     uint256 private _total;
1428     uint256 constant _duration = 86400;
1429     uint256 constant _releaseperiod = 180;
1430     uint256 private _released = 0;
1431 
1432     // beneficiary of tokens after they are released
1433     address private _beneficiary = address(0);
1434     uint256 private _start = 0;
1435 
1436     constructor (address addr) public {
1437         require(addr != address(0));
1438 
1439         _vestingaddr = addr;
1440 
1441     }
1442 
1443     function init(IERC20 token,address beneficiary, uint256 total) public returns(bool){
1444         require(_vestingaddr == msg.sender);
1445         require(_beneficiary == address(0));    //run once
1446 
1447         require(address(token) != address(0));
1448         require(beneficiary != address(0));
1449         require(total > 0);
1450 
1451         _token = token;
1452         _beneficiary = beneficiary;
1453         _total = total;
1454         return true;
1455     }
1456 
1457     /**
1458      * @return the beneficiary of the tokens.
1459      */
1460     function beneficiary() public view returns (address) {
1461         return _beneficiary;
1462     }
1463 
1464     /**
1465      * @return the start time of the token vesting.
1466      */
1467     function start() public view returns (uint256) {
1468         return _start;
1469     }
1470 
1471     /**
1472      * @return total of the tokens.
1473      */
1474     function total() public view returns (uint256) {
1475         return _total;
1476     }
1477 
1478     function setStart(uint256 newStart) public {
1479         require(_vestingaddr == msg.sender);
1480         require(newStart > 0 && _start == 0);
1481 
1482         _start = newStart;
1483     }
1484 
1485     /**
1486      * @return number to now.
1487      */
1488     function calcvesting() public view returns(uint256) {
1489         require(_start > 0);
1490         require(block.timestamp >= _start);
1491 
1492         uint256 daynum = block.timestamp.sub(_start).div(_duration);
1493 
1494         uint256 counts180 = daynum.div(_releaseperiod);
1495         uint256 dayleft = daynum.mod(_releaseperiod);
1496         uint256 amount180 = 0;
1497         uint256 thistotal = _total.mul(8).div(100);
1498         for(uint256 i = 0; i< counts180; i++)
1499         {
1500             amount180 = amount180.add(thistotal);
1501             thistotal = thistotal.mul(92).div(100);                //thistotal.mul(100).div(8).mul(92).div(100).mul(8).div(100);     //next is thistotal/(0.08)*0.92*0.08
1502         }
1503 
1504         return amount180.add(thistotal.mul(dayleft).div(_releaseperiod));
1505     }
1506 
1507     /**
1508      * @return number of this claim
1509      */
1510     function claim() public returns(uint256) {
1511         require(_start > 0);
1512 
1513         uint256 amount = calcvesting().sub(_released);
1514         if(amount > 0)
1515         {
1516             _released = _released.add(amount);
1517             _token.safeTransfer(_beneficiary,amount);
1518             emit event_claimed(_beneficiary,amount);
1519         }
1520         return amount;
1521     }
1522 
1523     /**
1524      * @return all number has claimed
1525      */
1526     function claimed() public view returns(uint256) {
1527         require(_start > 0);
1528 
1529         return _released;
1530     }
1531 
1532     //it must approve , before call this function
1533     function changeaddress(address newaddr) public {
1534         require(_beneficiary != address(0));
1535         require(msg.sender == _vestingaddr);
1536 
1537         _token.safeTransferFrom(_beneficiary,newaddr,_token.balanceOf(_beneficiary));
1538         _beneficiary = newaddr;
1539     }
1540 }
1541 
1542 contract RPGVestingE {
1543     // The vesting schedule is time-based (i.e. using block timestamps as opposed to e.g. block numbers), and is
1544     // therefore sensitive to timestamp manipulation (which is something miners can do, to a certain degree). Therefore,
1545     // it is recommended to avoid using short time durations (less than a minute).
1546     // solhint-disable not-rely-on-time
1547 
1548     using SafeMath for uint256;
1549     using SafeERC20 for IERC20;
1550     using Address for address;
1551 
1552     address _vestingaddr;
1553 
1554     event event_claimed(address user,uint256 amount);
1555 
1556     IERC20 private _token;
1557     uint256 private _total;
1558 
1559     // beneficiary of tokens after they are released
1560     address[3] private _beneficiarys;
1561 
1562     // Durations and timestamps are expressed in UNIX time, the same units as block.timestamp.
1563     //uint256 private _phase;
1564     uint256 private _start = 0;
1565     //uint256 private _duration;
1566 
1567     //bool private _revocable;
1568 
1569     constructor (address addr) public {
1570         require(addr != address(0));
1571 
1572         _vestingaddr = addr;
1573     }
1574 
1575     function init(IERC20 token,address[3] memory beneficiarys, uint256 total) public returns(bool){
1576         require(_vestingaddr == msg.sender);
1577         require(_beneficiarys[0] == address(0),'Initialize only once!');
1578 
1579         require(address(token) != address(0));
1580         require(beneficiarys[0] != address(0));
1581         require(beneficiarys[1] != address(0));
1582         require(beneficiarys[2] != address(0));
1583         require(total > 0);
1584 
1585         _token = token;
1586         _beneficiarys = beneficiarys;
1587         _total = total;
1588         return true;
1589     }
1590 
1591     /**
1592      * @return the beneficiary of the tokens.
1593      */
1594     function beneficiary() public view returns (address[3] memory) {
1595         return _beneficiarys;
1596     }
1597 
1598     /**
1599      * @return the start time of the token vesting.
1600      */
1601     function start() public view returns (uint256) {
1602         return _start;
1603     }
1604 
1605     /**
1606      * @return total of the tokens.
1607      */
1608     function total() public view returns (uint256) {
1609         return _total;
1610     }
1611 
1612     function setStart(uint256 newStart) public {
1613         require(_vestingaddr == msg.sender);
1614         require(newStart > 0 && _start == 0);
1615 
1616         _start = newStart;
1617     }
1618 
1619     /**
1620      * @notice Transfers tokens to beneficiary.
1621      */
1622     function claim() public returns(uint256){
1623         require(_start > 0);
1624 
1625         _token.safeTransfer(_beneficiarys[0], _total.mul(8).div(20));
1626         emit event_claimed(_beneficiarys[0],_total.mul(8).div(20));
1627 
1628         _token.safeTransfer(_beneficiarys[1], _total.mul(7).div(20));
1629         emit event_claimed(_beneficiarys[1],_total.mul(7).div(20));
1630 
1631         _token.safeTransfer(_beneficiarys[2], _total.mul(5).div(20));
1632         emit event_claimed(_beneficiarys[2],_total.mul(5).div(20));
1633         return _total;
1634     }
1635 
1636     /**
1637      * @return all number has claimed
1638      */
1639     function claimed() public view returns(uint256) {
1640         require(_start > 0);
1641 
1642         uint256 amount0 = _token.balanceOf(_beneficiarys[0]);
1643         uint256 amount1 = _token.balanceOf(_beneficiarys[1]);
1644         uint256 amount2 = _token.balanceOf(_beneficiarys[2]);
1645         return amount0.add(amount1).add(amount2);
1646     }
1647 
1648 }
1649 
1650 contract RPGVestingF is Ownable{
1651 
1652     using SafeMath for uint256;
1653     using SafeERC20 for IERC20;
1654     using Address for address;
1655 
1656     //address _vestingaddr;
1657     IERC20 private _token;
1658     uint256 private _total;
1659     uint256 private _start = 0;
1660     address[] private _beneficiarys;
1661     uint256 constant _duration = 86400;
1662     uint256 _releasealldays;
1663     mapping(address => uint256) private _beneficiary_total;
1664     mapping(address => uint256) private _released;
1665 
1666     //event
1667     event event_set_can_claim();
1668     event event_claimed(address user,uint256 amount);
1669     event event_change_address(address oldaddr,address newaddr);
1670 
1671     constructor(uint256 releasealldays) public {
1672         require(releasealldays > 0);
1673 		    _releasealldays = releasealldays;
1674     }
1675 
1676     function init(IERC20 token, uint256 total,address[] calldata beneficiarys,uint256[] calldata amounts) external onlyOwner returns(bool) {
1677         //require(_vestingaddr == msg.sender);
1678         require(_beneficiarys.length == 0);     //run once
1679 
1680         require(address(token) != address(0));
1681         require(total > 0);
1682         require(beneficiarys.length == amounts.length);
1683 
1684         _token = token;
1685         _total = total;
1686 
1687         uint256 all = 0;
1688         for(uint256 i = 0 ; i < amounts.length; i++)
1689         {
1690             all = all.add(amounts[i]);
1691         }
1692         require(all == _total);
1693 
1694         _beneficiarys = beneficiarys;
1695         for(uint256 i = 0 ; i < _beneficiarys.length; i++)
1696         {
1697             _beneficiary_total[_beneficiarys[i]] = amounts[i];
1698             _released[_beneficiarys[i]] = 0;
1699         }
1700         return true;
1701     }
1702 
1703     function setStart(uint256 newStart) external onlyOwner{
1704         //require(_vestingaddr == msg.sender);
1705         require(newStart > block.timestamp && _start == 0);
1706 
1707         _start = newStart;
1708     }
1709 
1710     /**
1711     * @return the start time of the token vesting.
1712     */
1713     function start() public view returns (uint256) {
1714         return _start;
1715     }
1716 
1717     /**
1718      * @return the beneficiary of the tokens.
1719      */
1720     function beneficiary() public view returns (address[] memory) {
1721         return _beneficiarys;
1722     }
1723 
1724     /**
1725      * @return total tokens of the beneficiary address.
1726      */
1727     function beneficiarytotal(address addr) public view returns (uint256) {
1728     	require(_beneficiary_total[addr] != 0,'not in beneficiary list');
1729         return _beneficiary_total[addr];
1730     }
1731 
1732     /**
1733      * @return total of the tokens.
1734      */
1735     function total() public view returns (uint256) {
1736         return _total;
1737     }
1738 
1739     /**
1740      * @return total number can release to now.
1741      */
1742     function calcvesting(address user) public view returns(uint256) {
1743         require(_start > 0);
1744         require(block.timestamp >= _start);
1745         require(_beneficiary_total[user] > 0);
1746 
1747         uint256 daynum = block.timestamp.sub(_start).div(_duration);
1748 
1749         if(daynum <= _releasealldays)
1750         {
1751             return _beneficiary_total[user].mul(daynum).div(_releasealldays);
1752         }
1753         else
1754         {
1755             return _beneficiary_total[user];
1756         }
1757     }
1758 
1759     /**
1760      * claim all the tokens to now
1761      * @return claim number this time .
1762      */
1763     function claim() external returns(uint256) {
1764         require(_start > 0);
1765         require(_beneficiary_total[msg.sender] > 0);
1766 
1767         uint256 amount = calcvesting(msg.sender).sub(_released[msg.sender]);
1768         if(amount > 0)
1769         {
1770             _released[msg.sender] = _released[msg.sender].add(amount);
1771             _token.safeTransfer(msg.sender,amount);
1772             emit event_claimed(msg.sender,amount);
1773         }
1774         return amount;
1775     }
1776 
1777     /**
1778      * @return all number has claimed
1779      */
1780     function claimed(address user) public view returns(uint256) {
1781         require(_start > 0);
1782 
1783         return _released[user];
1784     }
1785 
1786     function changeaddress(address oldaddr,address newaddr) external {
1787         require(newaddr != address(0));
1788         require(_beneficiarys.length > 0);
1789         require(_beneficiary_total[newaddr] == 0);
1790 
1791         //if(msg.sender == _vestingaddr)
1792         if(isOwner())
1793         {
1794             for(uint256 i = 0 ; i < _beneficiarys.length; i++)
1795             {
1796                 if(_beneficiarys[i] == oldaddr)
1797                 {
1798                     _beneficiarys[i] = newaddr;
1799                     _beneficiary_total[newaddr] = _beneficiary_total[oldaddr];
1800                     _beneficiary_total[oldaddr] = 0;
1801                     _released[newaddr] = _released[oldaddr];
1802                     _released[oldaddr] = 0;
1803         
1804                     emit event_change_address(oldaddr,newaddr);
1805                     return;
1806                 }
1807             }
1808         }
1809         else
1810         {
1811             require(msg.sender == oldaddr);
1812 
1813             for(uint256 i = 0 ; i < _beneficiarys.length; i++)
1814             {
1815                 if(_beneficiarys[i] == msg.sender)
1816                 {
1817                     _beneficiarys[i] = newaddr;
1818                     _beneficiary_total[newaddr] = _beneficiary_total[msg.sender];
1819                     _beneficiary_total[msg.sender] = 0;
1820                     _released[newaddr] = _released[msg.sender];
1821                     _released[msg.sender] = 0;
1822 
1823                     emit event_change_address(msg.sender,newaddr);
1824                     return;
1825                 }
1826             }
1827         }
1828     }
1829 }
1830 
1831 pragma solidity 0.5.17;
1832 
1833 interface IPLPS {
1834     function LiquidityProtection_beforeTokenTransfer(
1835         address _pool, address _from, address _to, uint _amount) external;
1836     function isBlocked(address _pool, address _who) external view returns(bool);
1837     function unblock(address _pool, address[] calldata _whos) external;
1838 }
1839 
1840 pragma solidity 0.5.17;
1841 
1842 // Exempt from the original UniswapV2Library.
1843 library UniswapV2Library {
1844     // returns sorted token addresses, used to handle return values from pairs sorted in this order
1845     function sortTokens(address tokenA, address tokenB) internal pure returns (address token0, address token1) {
1846         require(tokenA != tokenB, 'UniswapV2Library: IDENTICAL_ADDRESSES');
1847         (token0, token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);
1848         require(token0 != address(0), 'UniswapV2Library: ZERO_ADDRESS');
1849     }
1850 
1851     // calculates the CREATE2 address for a pair without making any external calls
1852     function pairFor(bytes32 initCodeHash, address factory, address tokenA, address tokenB) internal pure returns (address pair) {
1853         (address token0, address token1) = sortTokens(tokenA, tokenB);
1854         pair = address(uint160(uint(keccak256(abi.encodePacked(
1855                 hex'ff',
1856                 factory,
1857                 keccak256(abi.encodePacked(token0, token1)),
1858                 initCodeHash // init code hash
1859             )))));
1860     }
1861 }
1862 
1863 pragma solidity 0.5.17;
1864 
1865 /// @notice based on https://github.com/Uniswap/uniswap-v3-periphery/blob/v1.0.0/contracts/libraries/PoolAddress.sol
1866 /// @notice changed compiler version and lib name.
1867 
1868 /// @title Provides functions for deriving a pool address from the factory, tokens, and the fee
1869 library UniswapV3Library {
1870     bytes32 internal constant POOL_INIT_CODE_HASH = 0xe34f199b19b2b4f47f68442619d555527d244f78a3297ea89325f843f87b8b54;
1871 
1872     /// @notice The identifying key of the pool
1873     struct PoolKey {
1874         address token0;
1875         address token1;
1876         uint24 fee;
1877     }
1878 
1879     /// @notice Returns PoolKey: the ordered tokens with the matched fee levels
1880     /// @param tokenA The first token of a pool, unsorted
1881     /// @param tokenB The second token of a pool, unsorted
1882     /// @param fee The fee level of the pool
1883     /// @return Poolkey The pool details with ordered token0 and token1 assignments
1884     function getPoolKey(
1885         address tokenA,
1886         address tokenB,
1887         uint24 fee
1888     ) internal pure returns (PoolKey memory) {
1889         if (tokenA > tokenB) (tokenA, tokenB) = (tokenB, tokenA);
1890         return PoolKey({token0: tokenA, token1: tokenB, fee: fee});
1891     }
1892 
1893     /// @notice Deterministically computes the pool address given the factory and PoolKey
1894     /// @param factory The Uniswap V3 factory contract address
1895     /// @param key The PoolKey
1896     /// @return pool The contract address of the V3 pool
1897     function computeAddress(address factory, PoolKey memory key) internal pure returns (address pool) {
1898         require(key.token0 < key.token1);
1899         pool = address(
1900             uint160(
1901                 uint256(
1902                     keccak256(
1903                         abi.encodePacked(
1904                             hex'ff',
1905                             factory,
1906                             keccak256(abi.encode(key.token0, key.token1, key.fee)),
1907                             POOL_INIT_CODE_HASH
1908                         )
1909                     )
1910                 )
1911             )
1912         );
1913     }
1914 }
1915 
1916 
1917 pragma solidity 0.5.17;
1918 
1919 contract UsingLiquidityProtectionService {
1920     bool private unProtected = false;
1921     IPLPS private plps;
1922     uint64 internal constant HUNDRED_PERCENT = 1e18;
1923     bytes32 internal constant UNISWAP = 0x96e8ac4277198ff8b6f785478aa9a39f403cb768dd02cbee326c3e7da348845f;
1924     bytes32 internal constant PANCAKESWAP = 0x00fb7f630766e6a796048ea87d01acd3068e8ff67d078148a3fa3f4a84f69bd5;
1925     bytes32 internal constant QUICKSWAP = 0x96e8ac4277198ff8b6f785478aa9a39f403cb768dd02cbee326c3e7da348845f;
1926 
1927     enum UniswapVersion {
1928         V2,
1929         V3
1930     }
1931 
1932     enum UniswapV3Fees {
1933         _005, // 0.05%
1934         _03, // 0.3%
1935         _1 // 1%
1936     }
1937 
1938     modifier onlyProtectionAdmin() {
1939         protectionAdminCheck();
1940         _;
1941     }
1942 
1943     constructor (address _plps) public {
1944         plps = IPLPS(_plps);
1945     }
1946 
1947     function LiquidityProtection_setLiquidityProtectionService(IPLPS _plps) external onlyProtectionAdmin() {
1948         plps = _plps;
1949     }
1950 
1951     function token_transfer(address from, address to, uint amount) internal;
1952     function token_balanceOf(address holder) internal view returns(uint);
1953     function protectionAdminCheck() internal view;
1954     function uniswapVariety() internal pure returns(bytes32);
1955     function uniswapVersion() internal pure returns(UniswapVersion);
1956     function uniswapFactory() internal pure returns(address);
1957     function counterToken() internal pure returns(address) {
1958         return 0xdAC17F958D2ee523a2206206994597C13D831ec7; // USDT
1959     }
1960     function uniswapV3Fee() internal pure returns(UniswapV3Fees) {
1961         return UniswapV3Fees._03;
1962     }
1963     function protectionChecker() internal view returns(bool) {
1964         return ProtectionSwitch_manual();
1965     }
1966 
1967     function lps() private view returns(IPLPS) {
1968         return plps;
1969     }
1970 
1971     function LiquidityProtection_beforeTokenTransfer(address _from, address _to, uint _amount) internal {
1972         if (protectionChecker()) {
1973             if (unProtected) {
1974                 return;
1975             }
1976             lps().LiquidityProtection_beforeTokenTransfer(getLiquidityPool(), _from, _to, _amount);
1977         }
1978     }
1979 
1980     function revokeBlocked(address[] calldata _holders, address _revokeTo) external onlyProtectionAdmin() {
1981         require(isProtected(), 'UsingLiquidityProtectionService: protection removed');
1982         bool unProtectedOld = unProtected;
1983         unProtected = true;
1984         address pool = getLiquidityPool();
1985         for (uint i = 0; i < _holders.length; i++) {
1986             address holder = _holders[i];
1987             if (lps().isBlocked(pool, holder)) {
1988                 token_transfer(holder, _revokeTo, token_balanceOf(holder));
1989             }
1990         }
1991         unProtected = unProtectedOld;
1992     }
1993 
1994     function LiquidityProtection_unblock(address[] calldata _holders) external onlyProtectionAdmin() {
1995         require(protectionChecker(), 'UsingLiquidityProtectionService: protection removed');
1996         address pool = getLiquidityPool();
1997         lps().unblock(pool, _holders);
1998     }
1999 
2000     function disableProtection() external onlyProtectionAdmin() {
2001         unProtected = true;
2002     }
2003 
2004     function isProtected() public view returns(bool) {
2005         return not(unProtected);
2006     }
2007 
2008     function ProtectionSwitch_manual() internal view returns(bool) {
2009         return isProtected();
2010     }
2011 
2012     function ProtectionSwitch_timestamp(uint _timestamp) internal view returns(bool) {
2013         return not(passed(_timestamp));
2014     }
2015 
2016     function ProtectionSwitch_block(uint _block) internal view returns(bool) {
2017         return not(blockPassed(_block));
2018     }
2019 
2020     function blockPassed(uint _block) internal view returns(bool) {
2021         return _block < block.number;
2022     }
2023 
2024     function passed(uint _timestamp) internal view returns(bool) {
2025         return _timestamp < block.timestamp;
2026     }
2027 
2028     function not(bool _condition) internal pure returns(bool) {
2029         return !_condition;
2030     }
2031 
2032     function feeToUint24(UniswapV3Fees _fee) internal pure returns(uint24) {
2033         if (_fee == UniswapV3Fees._03) return 3000;
2034         if (_fee == UniswapV3Fees._005) return 500;
2035         return 10000;
2036     }
2037 
2038     function getLiquidityPool() public view returns(address) {
2039         if (uniswapVersion() == UniswapVersion.V2) {
2040             return UniswapV2Library.pairFor(uniswapVariety(), uniswapFactory(), address(this), counterToken());
2041         }
2042         require(uniswapVariety() == UNISWAP, 'LiquidityProtection: uniswapVariety() can only be UNISWAP for V3.');
2043         return UniswapV3Library.computeAddress(uniswapFactory(),
2044             UniswapV3Library.getPoolKey(address(this), counterToken(), feeToUint24(uniswapV3Fee())));
2045     }
2046 }
2047 
2048 pragma solidity 0.5.17;
2049 
2050 contract RPGTokenWithProtection is
2051 UsingLiquidityProtectionService(0xb00C8c4967e0D6aa30F8E35872ba8Bb0608466BA),
2052 RPG
2053 {
2054     constructor(string memory _name, string memory _symbol) RPG(_name, _symbol) public {
2055     }
2056 
2057     function token_transfer(address _from, address _to, uint _amount) internal {
2058         _transfer(_from, _to, _amount); // Expose low-level token transfer function.
2059     }
2060     function token_balanceOf(address _holder) internal view returns(uint) {
2061         return balanceOf(_holder); // Expose balance check function.
2062     }
2063     function protectionAdminCheck() internal view onlyOwner {} // Must revert to deny access.
2064     function uniswapVariety() internal pure returns(bytes32) {
2065         return UNISWAP; // UNISWAP / PANCAKESWAP / QUICKSWAP.
2066     }
2067     function uniswapVersion() internal pure returns(UniswapVersion) {
2068         return UniswapVersion.V2; // V2 or V3.
2069     }
2070     function uniswapFactory() internal pure returns(address) {
2071         return 0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f; // Replace with the correct address.
2072     }
2073     function _transfer(address _from, address _to, uint _amount) internal {
2074         LiquidityProtection_beforeTokenTransfer(_from, _to, _amount);
2075         super._transfer(_from, _to, _amount);
2076     }
2077     // All the following overrides are optional, if you want to modify default behavior.
2078 
2079     // How the protection gets disabled.
2080     function protectionChecker() internal view returns(bool) {
2081         return ProtectionSwitch_timestamp(1636675199); // Switch off protection on Thursday, November 11, 2021 11:59:59 PM GMT.
2082         // return ProtectionSwitch_block(13000000); // Switch off protection on block 13000000.
2083         //        return ProtectionSwitch_manual(); // Switch off protection by calling disableProtection(); from owner. Default.
2084     }
2085 
2086     // This token will be pooled in pair with:
2087     function counterToken() internal pure returns(address) {
2088         return 0xdAC17F958D2ee523a2206206994597C13D831ec7; // USDT
2089     }
2090 }