1 /*
2  * Drive safe, get paid. Do not use your phone while driving and we reward you with our currency MOBILIO. The earlier you join, the more you can earn!
3  *
4  * for https://www.mobilio.cc
5  * powered by https://capacity.at
6 */
7 
8 // File: node_modules/openzeppelin-solidity/contracts/introspection/IERC165.sol
9 
10 pragma solidity ^0.5.2;
11 
12 /**
13  * @title IERC165
14  * @dev https://eips.ethereum.org/EIPS/eip-165
15  */
16 interface IERC165 {
17     /**
18      * @notice Query if a contract implements an interface
19      * @param interfaceId The interface identifier, as specified in ERC-165
20      * @dev Interface identification is specified in ERC-165. This function
21      * uses less than 30,000 gas.
22      */
23     function supportsInterface(bytes4 interfaceId) external view returns (bool);
24 }
25 
26 // File: openzeppelin-solidity/contracts/token/ERC721/IERC721.sol
27 
28 pragma solidity ^0.5.2;
29 
30 
31 /**
32  * @title ERC721 Non-Fungible Token Standard basic interface
33  * @dev see https://eips.ethereum.org/EIPS/eip-721
34  */
35 contract IERC721 is IERC165 {
36     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
37     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
38     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
39 
40     function balanceOf(address owner) public view returns (uint256 balance);
41     function ownerOf(uint256 tokenId) public view returns (address owner);
42 
43     function approve(address to, uint256 tokenId) public;
44     function getApproved(uint256 tokenId) public view returns (address operator);
45 
46     function setApprovalForAll(address operator, bool _approved) public;
47     function isApprovedForAll(address owner, address operator) public view returns (bool);
48 
49     function transferFrom(address from, address to, uint256 tokenId) public;
50     function safeTransferFrom(address from, address to, uint256 tokenId) public;
51 
52     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public;
53 }
54 
55 // File: node_modules/openzeppelin-solidity/contracts/token/ERC20/IERC20.sol
56 
57 pragma solidity ^0.5.2;
58 
59 /**
60  * @title ERC20 interface
61  * @dev see https://eips.ethereum.org/EIPS/eip-20
62  */
63 interface IERC20 {
64     function transfer(address to, uint256 value) external returns (bool);
65 
66     function approve(address spender, uint256 value) external returns (bool);
67 
68     function transferFrom(address from, address to, uint256 value) external returns (bool);
69 
70     function totalSupply() external view returns (uint256);
71 
72     function balanceOf(address who) external view returns (uint256);
73 
74     function allowance(address owner, address spender) external view returns (uint256);
75 
76     event Transfer(address indexed from, address indexed to, uint256 value);
77 
78     event Approval(address indexed owner, address indexed spender, uint256 value);
79 }
80 
81 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Detailed.sol
82 
83 pragma solidity ^0.5.2;
84 
85 
86 /**
87  * @title ERC20Detailed token
88  * @dev The decimals are only for visualization purposes.
89  * All the operations are done using the smallest and indivisible token unit,
90  * just as on Ethereum all the operations are done in wei.
91  */
92 contract ERC20Detailed is IERC20 {
93     string private _name;
94     string private _symbol;
95     uint8 private _decimals;
96 
97     constructor (string memory name, string memory symbol, uint8 decimals) public {
98         _name = name;
99         _symbol = symbol;
100         _decimals = decimals;
101     }
102 
103     /**
104      * @return the name of the token.
105      */
106     function name() public view returns (string memory) {
107         return _name;
108     }
109 
110     /**
111      * @return the symbol of the token.
112      */
113     function symbol() public view returns (string memory) {
114         return _symbol;
115     }
116 
117     /**
118      * @return the number of decimals of the token.
119      */
120     function decimals() public view returns (uint8) {
121         return _decimals;
122     }
123 }
124 
125 // File: node_modules/openzeppelin-solidity/contracts/math/SafeMath.sol
126 
127 pragma solidity ^0.5.2;
128 
129 /**
130  * @title SafeMath
131  * @dev Unsigned math operations with safety checks that revert on error
132  */
133 library SafeMath {
134     /**
135      * @dev Multiplies two unsigned integers, reverts on overflow.
136      */
137     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
138         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
139         // benefit is lost if 'b' is also tested.
140         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
141         if (a == 0) {
142             return 0;
143         }
144 
145         uint256 c = a * b;
146         require(c / a == b);
147 
148         return c;
149     }
150 
151     /**
152      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
153      */
154     function div(uint256 a, uint256 b) internal pure returns (uint256) {
155         // Solidity only automatically asserts when dividing by 0
156         require(b > 0);
157         uint256 c = a / b;
158         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
159 
160         return c;
161     }
162 
163     /**
164      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
165      */
166     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
167         require(b <= a);
168         uint256 c = a - b;
169 
170         return c;
171     }
172 
173     /**
174      * @dev Adds two unsigned integers, reverts on overflow.
175      */
176     function add(uint256 a, uint256 b) internal pure returns (uint256) {
177         uint256 c = a + b;
178         require(c >= a);
179 
180         return c;
181     }
182 
183     /**
184      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
185      * reverts when dividing by zero.
186      */
187     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
188         require(b != 0);
189         return a % b;
190     }
191 }
192 
193 // File: node_modules/openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
194 
195 pragma solidity ^0.5.2;
196 
197 
198 
199 /**
200  * @title Standard ERC20 token
201  *
202  * @dev Implementation of the basic standard token.
203  * https://eips.ethereum.org/EIPS/eip-20
204  * Originally based on code by FirstBlood:
205  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
206  *
207  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
208  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
209  * compliant implementations may not do it.
210  */
211 contract ERC20 is IERC20 {
212     using SafeMath for uint256;
213 
214     mapping (address => uint256) private _balances;
215 
216     mapping (address => mapping (address => uint256)) private _allowed;
217 
218     uint256 private _totalSupply;
219 
220     /**
221      * @dev Total number of tokens in existence
222      */
223     function totalSupply() public view returns (uint256) {
224         return _totalSupply;
225     }
226 
227     /**
228      * @dev Gets the balance of the specified address.
229      * @param owner The address to query the balance of.
230      * @return A uint256 representing the amount owned by the passed address.
231      */
232     function balanceOf(address owner) public view returns (uint256) {
233         return _balances[owner];
234     }
235 
236     /**
237      * @dev Function to check the amount of tokens that an owner allowed to a spender.
238      * @param owner address The address which owns the funds.
239      * @param spender address The address which will spend the funds.
240      * @return A uint256 specifying the amount of tokens still available for the spender.
241      */
242     function allowance(address owner, address spender) public view returns (uint256) {
243         return _allowed[owner][spender];
244     }
245 
246     /**
247      * @dev Transfer token to a specified address
248      * @param to The address to transfer to.
249      * @param value The amount to be transferred.
250      */
251     function transfer(address to, uint256 value) public returns (bool) {
252         _transfer(msg.sender, to, value);
253         return true;
254     }
255 
256     /**
257      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
258      * Beware that changing an allowance with this method brings the risk that someone may use both the old
259      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
260      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
261      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
262      * @param spender The address which will spend the funds.
263      * @param value The amount of tokens to be spent.
264      */
265     function approve(address spender, uint256 value) public returns (bool) {
266         _approve(msg.sender, spender, value);
267         return true;
268     }
269 
270     /**
271      * @dev Transfer tokens from one address to another.
272      * Note that while this function emits an Approval event, this is not required as per the specification,
273      * and other compliant implementations may not emit the event.
274      * @param from address The address which you want to send tokens from
275      * @param to address The address which you want to transfer to
276      * @param value uint256 the amount of tokens to be transferred
277      */
278     function transferFrom(address from, address to, uint256 value) public returns (bool) {
279         _transfer(from, to, value);
280         _approve(from, msg.sender, _allowed[from][msg.sender].sub(value));
281         return true;
282     }
283 
284     /**
285      * @dev Increase the amount of tokens that an owner allowed to a spender.
286      * approve should be called when _allowed[msg.sender][spender] == 0. To increment
287      * allowed value is better to use this function to avoid 2 calls (and wait until
288      * the first transaction is mined)
289      * From MonolithDAO Token.sol
290      * Emits an Approval event.
291      * @param spender The address which will spend the funds.
292      * @param addedValue The amount of tokens to increase the allowance by.
293      */
294     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
295         _approve(msg.sender, spender, _allowed[msg.sender][spender].add(addedValue));
296         return true;
297     }
298 
299     /**
300      * @dev Decrease the amount of tokens that an owner allowed to a spender.
301      * approve should be called when _allowed[msg.sender][spender] == 0. To decrement
302      * allowed value is better to use this function to avoid 2 calls (and wait until
303      * the first transaction is mined)
304      * From MonolithDAO Token.sol
305      * Emits an Approval event.
306      * @param spender The address which will spend the funds.
307      * @param subtractedValue The amount of tokens to decrease the allowance by.
308      */
309     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
310         _approve(msg.sender, spender, _allowed[msg.sender][spender].sub(subtractedValue));
311         return true;
312     }
313 
314     /**
315      * @dev Transfer token for a specified addresses
316      * @param from The address to transfer from.
317      * @param to The address to transfer to.
318      * @param value The amount to be transferred.
319      */
320     function _transfer(address from, address to, uint256 value) internal {
321         require(to != address(0));
322 
323         _balances[from] = _balances[from].sub(value);
324         _balances[to] = _balances[to].add(value);
325         emit Transfer(from, to, value);
326     }
327 
328     /**
329      * @dev Internal function that mints an amount of the token and assigns it to
330      * an account. This encapsulates the modification of balances such that the
331      * proper events are emitted.
332      * @param account The account that will receive the created tokens.
333      * @param value The amount that will be created.
334      */
335     function _mint(address account, uint256 value) internal {
336         require(account != address(0));
337 
338         _totalSupply = _totalSupply.add(value);
339         _balances[account] = _balances[account].add(value);
340         emit Transfer(address(0), account, value);
341     }
342 
343     /**
344      * @dev Internal function that burns an amount of the token of a given
345      * account.
346      * @param account The account whose tokens will be burnt.
347      * @param value The amount that will be burnt.
348      */
349     function _burn(address account, uint256 value) internal {
350         require(account != address(0));
351 
352         _totalSupply = _totalSupply.sub(value);
353         _balances[account] = _balances[account].sub(value);
354         emit Transfer(account, address(0), value);
355     }
356 
357     /**
358      * @dev Approve an address to spend another addresses' tokens.
359      * @param owner The address that owns the tokens.
360      * @param spender The address that will spend the tokens.
361      * @param value The number of tokens that can be spent.
362      */
363     function _approve(address owner, address spender, uint256 value) internal {
364         require(spender != address(0));
365         require(owner != address(0));
366 
367         _allowed[owner][spender] = value;
368         emit Approval(owner, spender, value);
369     }
370 
371     /**
372      * @dev Internal function that burns an amount of the token of a given
373      * account, deducting from the sender's allowance for said account. Uses the
374      * internal burn function.
375      * Emits an Approval event (reflecting the reduced allowance).
376      * @param account The account whose tokens will be burnt.
377      * @param value The amount that will be burnt.
378      */
379     function _burnFrom(address account, uint256 value) internal {
380         _burn(account, value);
381         _approve(account, msg.sender, _allowed[account][msg.sender].sub(value));
382     }
383 }
384 
385 // File: node_modules/openzeppelin-solidity/contracts/access/Roles.sol
386 
387 pragma solidity ^0.5.2;
388 
389 /**
390  * @title Roles
391  * @dev Library for managing addresses assigned to a Role.
392  */
393 library Roles {
394     struct Role {
395         mapping (address => bool) bearer;
396     }
397 
398     /**
399      * @dev give an account access to this role
400      */
401     function add(Role storage role, address account) internal {
402         require(account != address(0));
403         require(!has(role, account));
404 
405         role.bearer[account] = true;
406     }
407 
408     /**
409      * @dev remove an account's access to this role
410      */
411     function remove(Role storage role, address account) internal {
412         require(account != address(0));
413         require(has(role, account));
414 
415         role.bearer[account] = false;
416     }
417 
418     /**
419      * @dev check if an account has this role
420      * @return bool
421      */
422     function has(Role storage role, address account) internal view returns (bool) {
423         require(account != address(0));
424         return role.bearer[account];
425     }
426 }
427 
428 // File: node_modules/openzeppelin-solidity/contracts/access/roles/MinterRole.sol
429 
430 pragma solidity ^0.5.2;
431 
432 
433 contract MinterRole {
434     using Roles for Roles.Role;
435 
436     event MinterAdded(address indexed account);
437     event MinterRemoved(address indexed account);
438 
439     Roles.Role private _minters;
440 
441     constructor () internal {
442         _addMinter(msg.sender);
443     }
444 
445     modifier onlyMinter() {
446         require(isMinter(msg.sender));
447         _;
448     }
449 
450     function isMinter(address account) public view returns (bool) {
451         return _minters.has(account);
452     }
453 
454     function addMinter(address account) public onlyMinter {
455         _addMinter(account);
456     }
457 
458     function renounceMinter() public {
459         _removeMinter(msg.sender);
460     }
461 
462     function _addMinter(address account) internal {
463         _minters.add(account);
464         emit MinterAdded(account);
465     }
466 
467     function _removeMinter(address account) internal {
468         _minters.remove(account);
469         emit MinterRemoved(account);
470     }
471 }
472 
473 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Mintable.sol
474 
475 pragma solidity ^0.5.2;
476 
477 
478 
479 /**
480  * @title ERC20Mintable
481  * @dev ERC20 minting logic
482  */
483 contract ERC20Mintable is ERC20, MinterRole {
484     /**
485      * @dev Function to mint tokens
486      * @param to The address that will receive the minted tokens.
487      * @param value The amount of tokens to mint.
488      * @return A boolean that indicates if the operation was successful.
489      */
490     function mint(address to, uint256 value) public onlyMinter returns (bool) {
491         _mint(to, value);
492         return true;
493     }
494 }
495 
496 // File: contracts/ENSReverseRegistrarI.sol
497 
498 /*
499  * Interfaces for ENS Reverse Registrar
500  * See https://github.com/ensdomains/ens/blob/master/contracts/ReverseRegistrar.sol for full impl
501  * Also see https://github.com/wealdtech/wealdtech-solidity/blob/master/contracts/ens/ENSReverseRegister.sol
502  *
503  * Use this as follows (registryAddress is the address of the ENS registry to use):
504  * -----
505  * // This hex value is caclulated by namehash('addr.reverse')
506  * bytes32 public constant ENS_ADDR_REVERSE_NODE = 0x91d1777781884d03a6757a803996e38de2a42967fb37eeaca72729271025a9e2;
507  * function registerReverseENS(address registryAddress, string memory calldata) external {
508  *     require(registryAddress != address(0), "need a valid registry");
509  *     address reverseRegistrarAddress = ENSRegistryOwnerI(registryAddress).owner(ENS_ADDR_REVERSE_NODE)
510  *     require(reverseRegistrarAddress != address(0), "need a valid reverse registrar");
511  *     ENSReverseRegistrarI(reverseRegistrarAddress).setName(name);
512  * }
513  * -----
514  * or
515  * -----
516  * function registerReverseENS(address reverseRegistrarAddress, string memory calldata) external {
517  *    require(reverseRegistrarAddress != address(0), "need a valid reverse registrar");
518  *     ENSReverseRegistrarI(reverseRegistrarAddress).setName(name);
519  * }
520  * -----
521  * ENS deployments can be found at https://docs.ens.domains/ens-deployments
522  * For Mainnet, 0x9062c0a6dbd6108336bcbe4593a3d1ce05512069 is the reverseRegistrarAddress,
523  * for Ropsten, it is at 0x67d5418a000534a8F1f5FF4229cC2f439e63BBe2.
524  */
525 pragma solidity ^0.5.2;
526 
527 contract ENSRegistryOwnerI {
528     function owner(bytes32 node) public view returns (address);
529 }
530 
531 contract ENSReverseRegistrarI {
532     function setName(string memory name) public returns (bytes32 node);
533 }
534 
535 // File: contracts/TimestampL.sol
536 
537 pragma solidity ^0.5.2;
538 
539 library TimestampL {
540 
541     uint16 constant ORIGIN_YEAR = 1970;
542 
543     function toTimestamp(uint16 year, uint8 month, uint8 day)
544     internal pure returns (uint timestamp) {
545         uint16 i;
546 
547         // Year
548         timestamp += uint(year - ORIGIN_YEAR) * 365 days;
549         timestamp += (leapYearsBefore(year) - leapYearsBefore(ORIGIN_YEAR)) * 1 days;
550 
551         // Month
552         uint8[12] memory monthDayCounts;
553         monthDayCounts[0] = 31;
554         if (isLeapYear(year)) {
555             monthDayCounts[1] = 29;
556         }
557         else {
558             monthDayCounts[1] = 28;
559         }
560         monthDayCounts[2] = 31;
561         monthDayCounts[3] = 30;
562         monthDayCounts[4] = 31;
563         monthDayCounts[5] = 30;
564         monthDayCounts[6] = 31;
565         monthDayCounts[7] = 31;
566         monthDayCounts[8] = 30;
567         monthDayCounts[9] = 31;
568         monthDayCounts[10] = 30;
569         monthDayCounts[11] = 31;
570 
571         for (i = 1; i < month; i++) {
572             timestamp += monthDayCounts[i - 1] * 1 days;
573         }
574 
575         // Day
576         timestamp += (day - 1) * 1 days;
577 
578         // Hour, Minute, and Second are assumed as 0 (we calculate in GMT)
579 
580         return timestamp;
581     }
582 
583 
584     function leapYearsBefore(uint year)
585     internal pure returns (uint) {
586         year -= 1;
587         return year / 4 - year / 100 + year / 400;
588     }
589 
590     function isLeapYear(uint16 year)
591     internal pure returns (bool) {
592         if (year % 4 != 0) {
593             return false;
594         }
595         if (year % 100 != 0) {
596             return true;
597         }
598         if (year % 400 != 0) {
599             return false;
600         }
601         return true;
602     }
603 
604 }
605 
606 // File: contracts/Mobilio.sol
607 
608 pragma solidity ^0.5.2;
609 
610 
611 
612 
613 
614 
615 contract Mobilio is ERC20, ERC20Detailed {
616 
617     using SafeMath for uint256;
618 
619     address payable public bank;
620 
621     uint private launch_date;
622 
623     uint private seconds_minting;
624 
625     uint256 private trautsch_total;
626 
627     uint private trautsch_pre_minted;
628 
629     modifier onlyBank() {
630         require(msg.sender == bank, "Only the bank account can perform this action.");
631         _;
632     }
633 
634     constructor(address payable _bank, address payable _dolphin) ERC20Detailed("Mobilio", "MOB", 18) public {
635         bank = _bank;
636         launch_date = TimestampL.toTimestamp(2019, 8, 7);
637         seconds_minting = TimestampL.toTimestamp(2119, 1, 1) - TimestampL.toTimestamp(2019, 1, 1); // 100 years
638         trautsch_total = 50_000_000_000 * (uint256(10) ** decimals());
639         _mint(_dolphin, 5_000_000_000 * (uint256(10) ** decimals()));
640         trautsch_pre_minted = super.totalSupply();
641     }
642 
643     function unmintedBalance(address _sender) internal view returns (uint256) {
644         if (_sender == bank) {
645             // super.totalSupply() is the actually minted amount.
646             uint256 missing = totalSupply() - super.totalSupply();
647             return missing;
648         } else {
649             return 0;
650         }
651     }
652 
653     modifier adjustMinting(address _sender) {
654         uint256 missing = unmintedBalance(_sender);
655         if (missing != 0) {
656             _mint(bank, missing);
657         }
658         _;
659     }
660 
661     /**
662      * @dev Total number of tokens in existence
663      */
664     function totalSupply() public view returns (uint256) {
665         uint seconds_since_launch = now - launch_date;
666         if (seconds_since_launch < seconds_minting) {
667             return trautsch_pre_minted + (trautsch_total - trautsch_pre_minted) * seconds_since_launch / seconds_minting;
668         } else {
669             return trautsch_total;
670         }
671     }
672 
673     /**
674      * @dev Gets the balance of the specified address.
675      * @param owner The address to query the balance of.
676      * @return A uint256 representing the amount owned by the passed address.
677      */
678     function balanceOf(address owner) public view returns (uint256) {
679         return super.balanceOf(owner) + unmintedBalance(owner);
680     }
681 
682     /**
683      * @dev Transfer token for a specified addresses
684      * @param from The address to transfer from.
685      * @param to The address to transfer to.
686      * @param value The amount to be transferred.
687      */
688     function _transfer(address from, address to, uint256 value) internal adjustMinting(from) {
689         super._transfer(from, to, value);
690     }
691 
692     /*** Enable reverse ENS registration ***/
693 
694     // Call this with the address of the reverse registrar for the respecitve network and the ENS name to register.
695     // The reverse registrar can be found as the owner of 'addr.reverse' in the ENS system.
696     // For Mainnet, the address needed is 0x9062c0a6dbd6108336bcbe4593a3d1ce05512069
697     function registerReverseENS(address reverseRegistrarAddress, string calldata name)
698     external
699     onlyBank
700     {
701        require(reverseRegistrarAddress != address(0), "need a valid reverse registrar");
702        ENSReverseRegistrarI(reverseRegistrarAddress).setName(name);
703     }
704 
705     /*** Make sure currency or NFT doesn't get stranded in this contract ***/
706 
707     // If this contract gets a balance in some ERC20 contract after it's finished, then we can rescue it.
708     function rescueToken(IERC20 _foreignToken, address _to)
709     external
710     onlyBank
711     {
712         _foreignToken.transfer(_to, _foreignToken.balanceOf(address(this)));
713     }
714 
715     // If this contract gets a balance in some ERC721 contract after it's finished, then we can rescue it.
716     function approveNFTrescue(IERC721 _foreignNFT, address _to)
717     external
718     onlyBank
719     {
720         _foreignNFT.setApprovalForAll(_to, true);
721     }
722 
723     // if a new bank key is needed, call this function 
724     function rotateBankKey(address payable _newBank)
725     external
726     onlyBank
727     {
728         //using super._transfer to not tamper with 
729        super._transfer(bank, _newBank, super.balanceOf(bank));
730        bank = _newBank;
731     }
732 
733     // Make sure this contract cannot receive ETH.
734     function()
735     external payable
736     {
737         revert("The contract cannot receive ETH payments.");
738     }
739 
740 }