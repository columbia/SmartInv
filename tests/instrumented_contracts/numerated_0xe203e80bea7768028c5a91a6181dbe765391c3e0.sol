1 pragma solidity ^0.5.0;
2 
3 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
4 
5 /**
6  * @title SafeMath
7  * @dev Unsigned math operations with safety checks that revert on error
8  */
9 library SafeMath {
10     /**
11     * @dev Multiplies two unsigned integers, reverts on overflow.
12     */
13     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
14         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
15         // benefit is lost if 'b' is also tested.
16         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
17         if (a == 0) {
18             return 0;
19         }
20 
21         uint256 c = a * b;
22         require(c / a == b);
23 
24         return c;
25     }
26 
27     /**
28     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
29     */
30     function div(uint256 a, uint256 b) internal pure returns (uint256) {
31         // Solidity only automatically asserts when dividing by 0
32         require(b > 0);
33         uint256 c = a / b;
34         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
35 
36         return c;
37     }
38 
39     /**
40     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
41     */
42     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
43         require(b <= a);
44         uint256 c = a - b;
45 
46         return c;
47     }
48 
49     /**
50     * @dev Adds two unsigned integers, reverts on overflow.
51     */
52     function add(uint256 a, uint256 b) internal pure returns (uint256) {
53         uint256 c = a + b;
54         require(c >= a);
55 
56         return c;
57     }
58 
59     /**
60     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
61     * reverts when dividing by zero.
62     */
63     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
64         require(b != 0);
65         return a % b;
66     }
67 }
68 
69 // File: openzeppelin-solidity/contracts/access/Roles.sol
70 
71 /**
72  * @title Roles
73  * @dev Library for managing addresses assigned to a Role.
74  */
75 library Roles {
76     struct Role {
77         mapping (address => bool) bearer;
78     }
79 
80     /**
81      * @dev give an account access to this role
82      */
83     function add(Role storage role, address account) internal {
84         require(account != address(0));
85         require(!has(role, account));
86 
87         role.bearer[account] = true;
88     }
89 
90     /**
91      * @dev remove an account's access to this role
92      */
93     function remove(Role storage role, address account) internal {
94         require(account != address(0));
95         require(has(role, account));
96 
97         role.bearer[account] = false;
98     }
99 
100     /**
101      * @dev check if an account has this role
102      * @return bool
103      */
104     function has(Role storage role, address account) internal view returns (bool) {
105         require(account != address(0));
106         return role.bearer[account];
107     }
108 }
109 
110 // File: contracts/controller/Permissions/RootPlatformAdministratorRole.sol
111 
112 /*
113     Copyright 2018, CONDA
114 
115     This program is free software: you can redistribute it and/or modify
116     it under the terms of the GNU General Public License as published by
117     the Free Software Foundation, either version 3 of the License, or
118     (at your option) any later version.
119 
120     This program is distributed in the hope that it will be useful,
121     but WITHOUT ANY WARRANTY; without even the implied warranty of
122     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
123     GNU General Public License for more details.
124 
125     You should have received a copy of the GNU General Public License
126     along with this program.  If not, see <http://www.gnu.org/licenses/>.
127 */
128 
129 
130 /** @title RootPlatformAdministratorRole root user role mainly to manage other roles. */
131 contract RootPlatformAdministratorRole {
132     using Roles for Roles.Role;
133 
134 ///////////////////
135 // Events
136 ///////////////////
137 
138     event RootPlatformAdministratorAdded(address indexed account);
139     event RootPlatformAdministratorRemoved(address indexed account);
140 
141 ///////////////////
142 // Variables
143 ///////////////////
144 
145     Roles.Role private rootPlatformAdministrators;
146 
147 ///////////////////
148 // Constructor
149 ///////////////////
150 
151     constructor() internal {
152         _addRootPlatformAdministrator(msg.sender);
153     }
154 
155 ///////////////////
156 // Modifiers
157 ///////////////////
158 
159     modifier onlyRootPlatformAdministrator() {
160         require(isRootPlatformAdministrator(msg.sender), "no root PFadmin");
161         _;
162     }
163 
164 ///////////////////
165 // Functions
166 ///////////////////
167 
168     function isRootPlatformAdministrator(address account) public view returns (bool) {
169         return rootPlatformAdministrators.has(account);
170     }
171 
172     function addRootPlatformAdministrator(address account) public onlyRootPlatformAdministrator {
173         _addRootPlatformAdministrator(account);
174     }
175 
176     function renounceRootPlatformAdministrator() public {
177         _removeRootPlatformAdministrator(msg.sender);
178     }
179 
180     function _addRootPlatformAdministrator(address account) internal {
181         rootPlatformAdministrators.add(account);
182         emit RootPlatformAdministratorAdded(account);
183     }
184 
185     function _removeRootPlatformAdministrator(address account) internal {
186         rootPlatformAdministrators.remove(account);
187         emit RootPlatformAdministratorRemoved(account);
188     }
189 }
190 
191 // File: contracts/controller/Permissions/AssetTokenAdministratorRole.sol
192 
193 /*
194     Copyright 2018, CONDA
195 
196     This program is free software: you can redistribute it and/or modify
197     it under the terms of the GNU General Public License as published by
198     the Free Software Foundation, either version 3 of the License, or
199     (at your option) any later version.
200 
201     This program is distributed in the hope that it will be useful,
202     but WITHOUT ANY WARRANTY; without even the implied warranty of
203     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
204     GNU General Public License for more details.
205 
206     You should have received a copy of the GNU General Public License
207     along with this program.  If not, see <http://www.gnu.org/licenses/>.
208 */
209 
210 
211 /** @title AssetTokenAdministratorRole of AssetToken administrators. */
212 contract AssetTokenAdministratorRole is RootPlatformAdministratorRole {
213 
214 ///////////////////
215 // Events
216 ///////////////////
217 
218     event AssetTokenAdministratorAdded(address indexed account);
219     event AssetTokenAdministratorRemoved(address indexed account);
220 
221 ///////////////////
222 // Variables
223 ///////////////////
224 
225     Roles.Role private assetTokenAdministrators;
226 
227 ///////////////////
228 // Constructor
229 ///////////////////
230 
231     constructor() internal {
232         _addAssetTokenAdministrator(msg.sender);
233     }
234 
235 ///////////////////
236 // Modifiers
237 ///////////////////
238 
239     modifier onlyAssetTokenAdministrator() {
240         require(isAssetTokenAdministrator(msg.sender), "no ATadmin");
241         _;
242     }
243 
244 ///////////////////
245 // Functions
246 ///////////////////
247 
248     function isAssetTokenAdministrator(address _account) public view returns (bool) {
249         return assetTokenAdministrators.has(_account);
250     }
251 
252     function addAssetTokenAdministrator(address _account) public onlyRootPlatformAdministrator {
253         _addAssetTokenAdministrator(_account);
254     }
255 
256     function renounceAssetTokenAdministrator() public {
257         _removeAssetTokenAdministrator(msg.sender);
258     }
259 
260     function _addAssetTokenAdministrator(address _account) internal {
261         assetTokenAdministrators.add(_account);
262         emit AssetTokenAdministratorAdded(_account);
263     }
264 
265     function removeAssetTokenAdministrator(address _account) public onlyRootPlatformAdministrator {
266         _removeAssetTokenAdministrator(_account);
267     }
268 
269     function _removeAssetTokenAdministrator(address _account) internal {
270         assetTokenAdministrators.remove(_account);
271         emit AssetTokenAdministratorRemoved(_account);
272     }
273 }
274 
275 // File: contracts/controller/Permissions/At2CsConnectorRole.sol
276 
277 /*
278     Copyright 2018, CONDA
279 
280     This program is free software: you can redistribute it and/or modify
281     it under the terms of the GNU General Public License as published by
282     the Free Software Foundation, either version 3 of the License, or
283     (at your option) any later version.
284 
285     This program is distributed in the hope that it will be useful,
286     but WITHOUT ANY WARRANTY; without even the implied warranty of
287     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
288     GNU General Public License for more details.
289 
290     You should have received a copy of the GNU General Public License
291     along with this program.  If not, see <http://www.gnu.org/licenses/>.
292 */
293 
294 
295 /** @title At2CsConnectorRole AssetToken to Crowdsale connector role. */
296 contract At2CsConnectorRole is RootPlatformAdministratorRole {
297 
298 ///////////////////
299 // Events
300 ///////////////////
301 
302     event At2CsConnectorAdded(address indexed account);
303     event At2CsConnectorRemoved(address indexed account);
304 
305 ///////////////////
306 // Variables
307 ///////////////////
308 
309     Roles.Role private at2csConnectors;
310 
311 ///////////////////
312 // Constructor
313 ///////////////////
314 
315     constructor() internal {
316         _addAt2CsConnector(msg.sender);
317     }
318 
319 ///////////////////
320 // Modifiers
321 ///////////////////
322 
323     modifier onlyAt2CsConnector() {
324         require(isAt2CsConnector(msg.sender), "no at2csAdmin");
325         _;
326     }
327 
328 ///////////////////
329 // Functions
330 ///////////////////
331 
332     function isAt2CsConnector(address _account) public view returns (bool) {
333         return at2csConnectors.has(_account);
334     }
335 
336     function addAt2CsConnector(address _account) public onlyRootPlatformAdministrator {
337         _addAt2CsConnector(_account);
338     }
339 
340     function renounceAt2CsConnector() public {
341         _removeAt2CsConnector(msg.sender);
342     }
343 
344     function _addAt2CsConnector(address _account) internal {
345         at2csConnectors.add(_account);
346         emit At2CsConnectorAdded(_account);
347     }
348 
349     function removeAt2CsConnector(address _account) public onlyRootPlatformAdministrator {
350         _removeAt2CsConnector(_account);
351     }
352 
353     function _removeAt2CsConnector(address _account) internal {
354         at2csConnectors.remove(_account);
355         emit At2CsConnectorRemoved(_account);
356     }
357 }
358 
359 // File: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol
360 
361 /**
362  * @title ERC20 interface
363  * @dev see https://github.com/ethereum/EIPs/issues/20
364  */
365 interface IERC20 {
366     function transfer(address to, uint256 value) external returns (bool);
367 
368     function approve(address spender, uint256 value) external returns (bool);
369 
370     function transferFrom(address from, address to, uint256 value) external returns (bool);
371 
372     function totalSupply() external view returns (uint256);
373 
374     function balanceOf(address who) external view returns (uint256);
375 
376     function allowance(address owner, address spender) external view returns (uint256);
377 
378     event Transfer(address indexed from, address indexed to, uint256 value);
379 
380     event Approval(address indexed owner, address indexed spender, uint256 value);
381 }
382 
383 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
384 
385 /**
386  * @title Standard ERC20 token
387  *
388  * @dev Implementation of the basic standard token.
389  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
390  * Originally based on code by FirstBlood:
391  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
392  *
393  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
394  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
395  * compliant implementations may not do it.
396  */
397 contract ERC20 is IERC20 {
398     using SafeMath for uint256;
399 
400     mapping (address => uint256) private _balances;
401 
402     mapping (address => mapping (address => uint256)) private _allowed;
403 
404     uint256 private _totalSupply;
405 
406     /**
407     * @dev Total number of tokens in existence
408     */
409     function totalSupply() public view returns (uint256) {
410         return _totalSupply;
411     }
412 
413     /**
414     * @dev Gets the balance of the specified address.
415     * @param owner The address to query the balance of.
416     * @return An uint256 representing the amount owned by the passed address.
417     */
418     function balanceOf(address owner) public view returns (uint256) {
419         return _balances[owner];
420     }
421 
422     /**
423      * @dev Function to check the amount of tokens that an owner allowed to a spender.
424      * @param owner address The address which owns the funds.
425      * @param spender address The address which will spend the funds.
426      * @return A uint256 specifying the amount of tokens still available for the spender.
427      */
428     function allowance(address owner, address spender) public view returns (uint256) {
429         return _allowed[owner][spender];
430     }
431 
432     /**
433     * @dev Transfer token for a specified address
434     * @param to The address to transfer to.
435     * @param value The amount to be transferred.
436     */
437     function transfer(address to, uint256 value) public returns (bool) {
438         _transfer(msg.sender, to, value);
439         return true;
440     }
441 
442     /**
443      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
444      * Beware that changing an allowance with this method brings the risk that someone may use both the old
445      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
446      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
447      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
448      * @param spender The address which will spend the funds.
449      * @param value The amount of tokens to be spent.
450      */
451     function approve(address spender, uint256 value) public returns (bool) {
452         require(spender != address(0));
453 
454         _allowed[msg.sender][spender] = value;
455         emit Approval(msg.sender, spender, value);
456         return true;
457     }
458 
459     /**
460      * @dev Transfer tokens from one address to another.
461      * Note that while this function emits an Approval event, this is not required as per the specification,
462      * and other compliant implementations may not emit the event.
463      * @param from address The address which you want to send tokens from
464      * @param to address The address which you want to transfer to
465      * @param value uint256 the amount of tokens to be transferred
466      */
467     function transferFrom(address from, address to, uint256 value) public returns (bool) {
468         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
469         _transfer(from, to, value);
470         emit Approval(from, msg.sender, _allowed[from][msg.sender]);
471         return true;
472     }
473 
474     /**
475      * @dev Increase the amount of tokens that an owner allowed to a spender.
476      * approve should be called when allowed_[_spender] == 0. To increment
477      * allowed value is better to use this function to avoid 2 calls (and wait until
478      * the first transaction is mined)
479      * From MonolithDAO Token.sol
480      * Emits an Approval event.
481      * @param spender The address which will spend the funds.
482      * @param addedValue The amount of tokens to increase the allowance by.
483      */
484     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
485         require(spender != address(0));
486 
487         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].add(addedValue);
488         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
489         return true;
490     }
491 
492     /**
493      * @dev Decrease the amount of tokens that an owner allowed to a spender.
494      * approve should be called when allowed_[_spender] == 0. To decrement
495      * allowed value is better to use this function to avoid 2 calls (and wait until
496      * the first transaction is mined)
497      * From MonolithDAO Token.sol
498      * Emits an Approval event.
499      * @param spender The address which will spend the funds.
500      * @param subtractedValue The amount of tokens to decrease the allowance by.
501      */
502     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
503         require(spender != address(0));
504 
505         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].sub(subtractedValue);
506         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
507         return true;
508     }
509 
510     /**
511     * @dev Transfer token for a specified addresses
512     * @param from The address to transfer from.
513     * @param to The address to transfer to.
514     * @param value The amount to be transferred.
515     */
516     function _transfer(address from, address to, uint256 value) internal {
517         require(to != address(0));
518 
519         _balances[from] = _balances[from].sub(value);
520         _balances[to] = _balances[to].add(value);
521         emit Transfer(from, to, value);
522     }
523 
524     /**
525      * @dev Internal function that mints an amount of the token and assigns it to
526      * an account. This encapsulates the modification of balances such that the
527      * proper events are emitted.
528      * @param account The account that will receive the created tokens.
529      * @param value The amount that will be created.
530      */
531     function _mint(address account, uint256 value) internal {
532         require(account != address(0));
533 
534         _totalSupply = _totalSupply.add(value);
535         _balances[account] = _balances[account].add(value);
536         emit Transfer(address(0), account, value);
537     }
538 
539     /**
540      * @dev Internal function that burns an amount of the token of a given
541      * account.
542      * @param account The account whose tokens will be burnt.
543      * @param value The amount that will be burnt.
544      */
545     function _burn(address account, uint256 value) internal {
546         require(account != address(0));
547 
548         _totalSupply = _totalSupply.sub(value);
549         _balances[account] = _balances[account].sub(value);
550         emit Transfer(account, address(0), value);
551     }
552 
553     /**
554      * @dev Internal function that burns an amount of the token of a given
555      * account, deducting from the sender's allowance for said account. Uses the
556      * internal burn function.
557      * Emits an Approval event (reflecting the reduced allowance).
558      * @param account The account whose tokens will be burnt.
559      * @param value The amount that will be burnt.
560      */
561     function _burnFrom(address account, uint256 value) internal {
562         _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(value);
563         _burn(account, value);
564         emit Approval(account, msg.sender, _allowed[account][msg.sender]);
565     }
566 }
567 
568 // File: openzeppelin-solidity/contracts/access/roles/MinterRole.sol
569 
570 contract MinterRole {
571     using Roles for Roles.Role;
572 
573     event MinterAdded(address indexed account);
574     event MinterRemoved(address indexed account);
575 
576     Roles.Role private _minters;
577 
578     constructor () internal {
579         _addMinter(msg.sender);
580     }
581 
582     modifier onlyMinter() {
583         require(isMinter(msg.sender));
584         _;
585     }
586 
587     function isMinter(address account) public view returns (bool) {
588         return _minters.has(account);
589     }
590 
591     function addMinter(address account) public onlyMinter {
592         _addMinter(account);
593     }
594 
595     function renounceMinter() public {
596         _removeMinter(msg.sender);
597     }
598 
599     function _addMinter(address account) internal {
600         _minters.add(account);
601         emit MinterAdded(account);
602     }
603 
604     function _removeMinter(address account) internal {
605         _minters.remove(account);
606         emit MinterRemoved(account);
607     }
608 }
609 
610 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Mintable.sol
611 
612 /**
613  * @title ERC20Mintable
614  * @dev ERC20 minting logic
615  */
616 contract ERC20Mintable is ERC20, MinterRole {
617     /**
618      * @dev Function to mint tokens
619      * @param to The address that will receive the minted tokens.
620      * @param value The amount of tokens to mint.
621      * @return A boolean that indicates if the operation was successful.
622      */
623     function mint(address to, uint256 value) public onlyMinter returns (bool) {
624         _mint(to, value);
625         return true;
626     }
627 }
628 
629 // File: contracts/controller/0_library/DSMathL.sol
630 
631 // fork from ds-math specifically my librarization fork: https://raw.githubusercontent.com/JohannesMayerConda/ds-math/master/contracts/DSMathL.sol
632 
633 /// math.sol -- mixin for inline numerical wizardry
634 
635 // This program is free software: you can redistribute it and/or modify
636 // it under the terms of the GNU General Public License as published by
637 // the Free Software Foundation, either version 3 of the License, or
638 // (at your option) any later version.
639 
640 // This program is distributed in the hope that it will be useful,
641 // but WITHOUT ANY WARRANTY; without even the implied warranty of
642 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
643 // GNU General Public License for more details.
644 
645 // You should have received a copy of the GNU General Public License
646 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
647 
648 library DSMathL {
649     function ds_add(uint x, uint y) public pure returns (uint z) {
650         require((z = x + y) >= x, "ds-math-add-overflow");
651     }
652     function ds_sub(uint x, uint y) public pure returns (uint z) {
653         require((z = x - y) <= x, "ds-math-sub-underflow");
654     }
655     function ds_mul(uint x, uint y) public pure returns (uint z) {
656         require(y == 0 || (z = x * y) / y == x, "ds-math-mul-overflow");
657     }
658 
659     function ds_min(uint x, uint y) public pure returns (uint z) {
660         return x <= y ? x : y;
661     }
662     function ds_max(uint x, uint y) public pure returns (uint z) {
663         return x >= y ? x : y;
664     }
665     function ds_imin(int x, int y) public pure returns (int z) {
666         return x <= y ? x : y;
667     }
668     function ds_imax(int x, int y) public pure returns (int z) {
669         return x >= y ? x : y;
670     }
671 
672     uint constant WAD = 10 ** 18;
673     uint constant RAY = 10 ** 27;
674 
675     function ds_wmul(uint x, uint y) public pure returns (uint z) {
676         z = ds_add(ds_mul(x, y), WAD / 2) / WAD;
677     }
678     function ds_rmul(uint x, uint y) public pure returns (uint z) {
679         z = ds_add(ds_mul(x, y), RAY / 2) / RAY;
680     }
681     function ds_wdiv(uint x, uint y) public pure returns (uint z) {
682         z = ds_add(ds_mul(x, WAD), y / 2) / y;
683     }
684     function ds_rdiv(uint x, uint y) public pure returns (uint z) {
685         z = ds_add(ds_mul(x, RAY), y / 2) / y;
686     }
687 
688     // This famous algorithm is called "exponentiation by squaring"
689     // and calculates x^n with x as fixed-point and n as regular unsigned.
690     //
691     // It's O(log n), instead of O(n) for naive repeated multiplication.
692     //
693     // These facts are why it works:
694     //
695     //  If n is even, then x^n = (x^2)^(n/2).
696     //  If n is odd,  then x^n = x * x^(n-1),
697     //   and applying the equation for even x gives
698     //    x^n = x * (x^2)^((n-1) / 2).
699     //
700     //  Also, EVM division is flooring and
701     //    floor[(n-1) / 2] = floor[n / 2].
702     //
703     function ds_rpow(uint x, uint n) public pure returns (uint z) {
704         z = n % 2 != 0 ? x : RAY;
705 
706         for (n /= 2; n != 0; n /= 2) {
707             x = ds_rmul(x, x);
708 
709             if (n % 2 != 0) {
710                 z = ds_rmul(z, x);
711             }
712         }
713     }
714 }
715 
716 // File: contracts/controller/Permissions/YourOwnable.sol
717 
718 // 1:1 copy of https://raw.githubusercontent.com/OpenZeppelin/openzeppelin-solidity/v2.1.1/contracts/ownership/Ownable.sol
719 // except constructor that can instantly transfer ownership
720 
721 contract YourOwnable {
722     address private _owner;
723 
724     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
725 
726     /**
727      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
728      * account.
729      */
730     constructor (address newOwner) public {
731         _transferOwnership(newOwner);
732     }
733 
734     /**
735      * @return the address of the owner.
736      */
737     function owner() public view returns (address) {
738         return _owner;
739     }
740 
741     /**
742      * @dev Throws if called by any account other than the owner.
743      */
744     modifier onlyOwner() {
745         require(isOwner());
746         _;
747     }
748 
749     /**
750      * @return true if `msg.sender` is the owner of the contract.
751      */
752     function isOwner() public view returns (bool) {
753         return msg.sender == _owner;
754     }
755 
756     /**
757      * @dev Allows the current owner to relinquish control of the contract.
758      * @notice Renouncing to ownership will leave the contract without an owner.
759      * It will not be possible to call the functions with the `onlyOwner`
760      * modifier anymore.
761      */
762     function renounceOwnership() public onlyOwner {
763         emit OwnershipTransferred(_owner, address(0));
764         _owner = address(0);
765     }
766 
767     /**
768      * @dev Allows the current owner to transfer control of the contract to a newOwner.
769      * @param newOwner The address to transfer ownership to.
770      */
771     function transferOwnership(address newOwner) public onlyOwner {
772         _transferOwnership(newOwner);
773     }
774 
775     /**
776      * @dev Transfers control of the contract to a newOwner.
777      * @param newOwner The address to transfer ownership to.
778      */
779     function _transferOwnership(address newOwner) internal {
780         require(newOwner != address(0));
781         emit OwnershipTransferred(_owner, newOwner);
782         _owner = newOwner;
783     }
784 }
785 
786 // File: contracts/controller/FeeTable/StandardFeeTable.sol
787 
788 /*
789     Copyright 2018, CONDA
790 
791     This program is free software: you can redistribute it and/or modify
792     it under the terms of the GNU General Public License as published by
793     the Free Software Foundation, either version 3 of the License, or
794     (at your option) any later version.
795 
796     This program is distributed in the hope that it will be useful,
797     but WITHOUT ANY WARRANTY; without even the implied warranty of
798     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
799     GNU General Public License for more details.
800 
801     You should have received a copy of the GNU General Public License
802     along with this program.  If not, see <http://www.gnu.org/licenses/>.
803 */
804 
805 
806 
807 /** @title StandardFeeTable contract to store fees via name (fees per platform for certain name). */
808 contract StandardFeeTable  is YourOwnable {
809     using SafeMath for uint256;
810 
811 ///////////////////
812 // Constructor
813 ///////////////////
814 
815     constructor (address newOwner) YourOwnable(newOwner) public {}
816 
817 ///////////////////
818 // Variables
819 ///////////////////
820 
821     uint256 public defaultFee;
822 
823     mapping (bytes32 => uint256) public feeFor;
824     mapping (bytes32 => bool) public isFeeDisabled;
825 
826 ///////////////////
827 // Functions
828 ///////////////////
829 
830     /// @notice Set default fee (when nothing else applies).
831     /// @param _defaultFee default fee value. Unit is WAD so fee 1 means value=1e18.
832     function setDefaultFee(uint256 _defaultFee) public onlyOwner {
833         defaultFee = _defaultFee;
834     }
835 
836     /// @notice Set fee by name.
837     /// @param _feeName fee name.
838     /// @param _feeValue fee value. Unit is WAD so fee 1 means value=1e18.
839     function setFee(bytes32 _feeName, uint256 _feeValue) public onlyOwner {
840         feeFor[_feeName] = _feeValue;
841     }
842 
843     /// @notice Enable or disable fee by name.
844     /// @param _feeName fee name.
845     /// @param _feeDisabled true if fee should be disabled.
846     function setFeeMode(bytes32 _feeName, bool _feeDisabled) public onlyOwner {
847         isFeeDisabled[_feeName] = _feeDisabled;
848     }
849 
850     /// @notice Get standard fee (not overriden by special fee for specific AssetToken).
851     /// @param _feeName fee name.
852     /// @return fee value. Unit is WAD so fee 1 means value=1e18.
853     function getStandardFee(bytes32 _feeName) public view returns (uint256 _feeValue) {
854         if (isFeeDisabled[_feeName]) {
855             return 0;
856         }
857 
858         if(feeFor[_feeName] == 0) {
859             return defaultFee;
860         }
861 
862         return feeFor[_feeName];
863     }
864 
865     /// @notice Get standard fee for amount in base unit.
866     /// @param _feeName fee name.
867     /// @param _amountInFeeBaseUnit amount in fee base unit (currently in unit tokens).
868     /// @return fee value. Unit is WAD (converted it).
869     function getStandardFeeFor(bytes32 _feeName, uint256 _amountInFeeBaseUnit) public view returns (uint256) {
870         //1000000000000000 is 0,001 as WAD
871         //example fee 0.001 for amount 3: 3 tokens * 1000000000000000 fee = 3000000000000000 (0.003)
872         return _amountInFeeBaseUnit.mul(getStandardFee(_feeName));
873     }
874 }
875 
876 // File: contracts/controller/FeeTable/FeeTable.sol
877 
878 /*
879     Copyright 2018, CONDA
880 
881     This program is free software: you can redistribute it and/or modify
882     it under the terms of the GNU General Public License as published by
883     the Free Software Foundation, either version 3 of the License, or
884     (at your option) any later version.
885 
886     This program is distributed in the hope that it will be useful,
887     but WITHOUT ANY WARRANTY; without even the implied warranty of
888     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
889     GNU General Public License for more details.
890 
891     You should have received a copy of the GNU General Public License
892     along with this program.  If not, see <http://www.gnu.org/licenses/>.
893 */
894 
895 
896 /** @title FeeTable contract to store fees via name (fees per platform per assettoken for certain name). */
897 contract FeeTable is StandardFeeTable {
898     
899 ///////////////////
900 // Constructor
901 ///////////////////
902 
903     constructor (address newOwner) StandardFeeTable(newOwner) public {}
904 
905 ///////////////////
906 // Mappings
907 ///////////////////
908 
909     // specialfee mapping feeName -> token -> fee
910     mapping (bytes32 => mapping (address => uint256)) public specialFeeFor;
911 
912     // specialfee mapping feeName -> token -> isSet
913     mapping (bytes32 => mapping (address => bool)) public isSpecialFeeEnabled;
914 
915 ///////////////////
916 // Functions
917 ///////////////////
918 
919     /// @notice Set a special fee specifically for an AssetToken (higher or lower than normal fee).
920     /// @param _feeName fee name.
921     /// @param _regardingAssetToken regarding AssetToken.
922     /// @param _feeValue fee value. Unit is WAD so fee 1 means value=1e18.
923     function setSpecialFee(bytes32 _feeName, address _regardingAssetToken, uint256 _feeValue) public onlyOwner {
924         specialFeeFor[_feeName][_regardingAssetToken] = _feeValue;
925     }
926 
927     /// @notice Enable or disable special fee.
928     /// @param _feeName fee name.
929     /// @param _regardingAssetToken regarding AssetToken.
930     /// @param _feeEnabled true to enable fee.
931     function setSpecialFeeMode(bytes32 _feeName, address _regardingAssetToken, bool _feeEnabled) public onlyOwner {
932         isSpecialFeeEnabled[_feeName][_regardingAssetToken] = _feeEnabled;
933     }
934 
935     /// @notice Get fee by name.
936     /// @param _feeName fee name.
937     /// @param _regardingAssetToken regarding AssetToken.
938     /// @return fee value. Unit is WAD so fee 11 means value=1e18.
939     function getFee(bytes32 _feeName, address _regardingAssetToken) public view returns (uint256) {
940         if (isFeeDisabled[_feeName]) {
941             return 0;
942         }
943 
944         if (isSpecialFeeEnabled[_feeName][_regardingAssetToken]) {
945             return specialFeeFor[_feeName][_regardingAssetToken];
946         }
947 
948         return super.getStandardFee(_feeName);
949     }
950 
951     /// @notice Get fee for amount in base unit.
952     /// @param _feeName fee name.
953     /// @param _regardingAssetToken regarding AssetToken.
954     /// @param _amountInFeeBaseUnit amount in fee base unit (currently in unit tokens).
955     /// @return fee value. Unit is WAD (converted it).
956     function getFeeFor(bytes32 _feeName, address _regardingAssetToken, uint256 _amountInFeeBaseUnit, address /*oracle*/)
957         public view returns (uint256) 
958     {   
959         uint256 fee = getFee(_feeName, _regardingAssetToken);
960         
961         //1000000000000000 is 0,001 as WAD
962         //example fee 0.001 for amount 3: 3 tokens * 1000000000000000 fee = 3000000000000000 (0.003)
963         return _amountInFeeBaseUnit.mul(fee);
964     }
965 }
966 
967 // File: contracts/controller/Permissions/WhitelistControlRole.sol
968 
969 /*
970     Copyright 2018, CONDA
971 
972     This program is free software: you can redistribute it and/or modify
973     it under the terms of the GNU General Public License as published by
974     the Free Software Foundation, either version 3 of the License, or
975     (at your option) any later version.
976 
977     This program is distributed in the hope that it will be useful,
978     but WITHOUT ANY WARRANTY; without even the implied warranty of
979     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
980     GNU General Public License for more details.
981 
982     You should have received a copy of the GNU General Public License
983     along with this program.  If not, see <http://www.gnu.org/licenses/>.
984 */
985 
986 
987 /** @title WhitelistControlRole role to administrate whitelist and KYC. */
988 contract WhitelistControlRole is RootPlatformAdministratorRole {
989 
990 ///////////////////
991 // Events
992 ///////////////////
993 
994     event WhitelistControlAdded(address indexed account);
995     event WhitelistControlRemoved(address indexed account);
996 
997 ///////////////////
998 // Variables
999 ///////////////////
1000 
1001     Roles.Role private whitelistControllers;
1002 
1003 ///////////////////
1004 // Constructor
1005 ///////////////////
1006 
1007     constructor() internal {
1008         _addWhitelistControl(msg.sender);
1009     }
1010 
1011 ///////////////////
1012 // Modifiers
1013 ///////////////////
1014 
1015     modifier onlyWhitelistControl() {
1016         require(isWhitelistControl(msg.sender), "no WLcontrol");
1017         _;
1018     }
1019 
1020 ///////////////////
1021 // Functions
1022 ///////////////////
1023 
1024     function isWhitelistControl(address account) public view returns (bool) {
1025         return whitelistControllers.has(account);
1026     }
1027 
1028     function addWhitelistControl(address account) public onlyRootPlatformAdministrator {
1029         _addWhitelistControl(account);
1030     }
1031 
1032     function _addWhitelistControl(address account) internal {
1033         whitelistControllers.add(account);
1034         emit WhitelistControlAdded(account);
1035     }
1036 
1037     function removeWhitelistControl(address account) public onlyRootPlatformAdministrator {
1038         whitelistControllers.remove(account);
1039         emit WhitelistControlRemoved(account);
1040     }
1041 }
1042 
1043 // File: contracts/controller/interface/IWhitelistAutoExtendExpirationExecutor.sol
1044 
1045 interface IWhitelistAutoExtendExpirationExecutor {
1046     function recheckIdentity(address _wallet, address _investorKey, address _issuer) external;
1047 }
1048 
1049 // File: contracts/controller/interface/IWhitelistAutoExtendExpirationCallback.sol
1050 
1051 interface IWhitelistAutoExtendExpirationCallback {
1052     function updateIdentity(address _wallet, bool _isWhitelisted, address _investorKey, address _issuer) external;
1053 }
1054 
1055 // File: contracts/controller/Whitelist/Whitelist.sol
1056 
1057 /** @title Whitelist stores whitelist information of investors like if and when they were KYC checked. */
1058 contract Whitelist is WhitelistControlRole, IWhitelistAutoExtendExpirationCallback {
1059     using SafeMath for uint256;
1060 
1061 ///////////////////
1062 // Variables
1063 ///////////////////
1064 
1065     uint256 public expirationBlocks;
1066     bool public expirationEnabled;
1067     bool public autoExtendExpiration;
1068     address public autoExtendExpirationContract;
1069 
1070     mapping (address => bool) whitelistedWallet;
1071     mapping (address => uint256) lastIdentityVerificationDate;
1072     mapping (address => address) whitelistedWalletIssuer;
1073     mapping (address => address) walletToInvestorKey;
1074 
1075 ///////////////////
1076 // Events
1077 ///////////////////
1078 
1079     event WhitelistChanged(address indexed wallet, bool whitelisted, address investorKey, address issuer);
1080     event ExpirationBlocksChanged(address initiator, uint256 addedBlocksSinceWhitelisting);
1081     event ExpirationEnabled(address initiator, bool expirationEnabled);
1082     event UpdatedIdentity(address initiator, address indexed wallet, bool whitelisted, address investorKey, address issuer);
1083     event SetAutoExtendExpirationContract(address initiator, address expirationContract);
1084     event UpdatedAutoExtendExpiration(address initiator, bool autoExtendEnabled);
1085 
1086 ///////////////////
1087 // Functions
1088 ///////////////////
1089 
1090     function getIssuer(address _whitelistedWallet) public view returns (address) {
1091         return whitelistedWalletIssuer[_whitelistedWallet];
1092     }
1093 
1094     function getInvestorKey(address _wallet) public view returns (address) {
1095         return walletToInvestorKey[_wallet];
1096     }
1097 
1098     function setWhitelisted(address _wallet, bool _isWhitelisted, address _investorKey, address _issuer) public onlyWhitelistControl {
1099         whitelistedWallet[_wallet] = _isWhitelisted;
1100         lastIdentityVerificationDate[_wallet] = block.number;
1101         whitelistedWalletIssuer[_wallet] = _issuer;
1102         assignWalletToInvestorKey(_wallet, _investorKey);
1103 
1104         emit WhitelistChanged(_wallet, _isWhitelisted, _investorKey, _issuer);
1105     }
1106 
1107     function assignWalletToInvestorKey(address _wallet, address _investorKey) public onlyWhitelistControl {
1108         walletToInvestorKey[_wallet] = _investorKey;
1109     }
1110 
1111     //note: no view keyword here because IWhitelistAutoExtendExpirationExecutor could change state via callback
1112     function checkWhitelistedWallet(address _wallet) public returns (bool) {
1113         if(autoExtendExpiration && isExpired(_wallet)) {
1114             address investorKey = walletToInvestorKey[_wallet];
1115             address issuer = whitelistedWalletIssuer[_wallet];
1116             require(investorKey != address(0), "expired, unknown identity");
1117 
1118             //IMPORTANT: reentrance hook. make sure calling contract is safe
1119             IWhitelistAutoExtendExpirationExecutor(autoExtendExpirationContract).recheckIdentity(_wallet, investorKey, issuer);
1120         }
1121 
1122         require(!isExpired(_wallet), "whitelist expired");
1123         require(whitelistedWallet[_wallet], "not whitelisted");
1124 
1125         return true;
1126     }
1127 
1128     function isWhitelistedWallet(address _wallet) public view returns (bool) {
1129         if(isExpired(_wallet)) {
1130             return false;
1131         }
1132 
1133         return whitelistedWallet[_wallet];
1134     }
1135 
1136     function isExpired(address _wallet) private view returns (bool) {
1137         return expirationEnabled && block.number > lastIdentityVerificationDate[_wallet].add(expirationBlocks);
1138     }
1139 
1140     function blocksLeftUntilExpired(address _wallet) public view returns (uint256) {
1141         require(expirationEnabled, "expiration disabled");
1142 
1143         return lastIdentityVerificationDate[_wallet].add(expirationBlocks).sub(block.number);
1144     }
1145 
1146     function setExpirationBlocks(uint256 _addedBlocksSinceWhitelisting) public onlyRootPlatformAdministrator {
1147         expirationBlocks = _addedBlocksSinceWhitelisting;
1148 
1149         emit ExpirationBlocksChanged(msg.sender, _addedBlocksSinceWhitelisting);
1150     }
1151 
1152     function setExpirationEnabled(bool _isEnabled) public onlyRootPlatformAdministrator {
1153         expirationEnabled = _isEnabled;
1154 
1155         emit ExpirationEnabled(msg.sender, expirationEnabled);
1156     }
1157 
1158     function setAutoExtendExpirationContract(address _autoExtendContract) public onlyRootPlatformAdministrator {
1159         autoExtendExpirationContract = _autoExtendContract;
1160 
1161         emit SetAutoExtendExpirationContract(msg.sender, _autoExtendContract);
1162     }
1163 
1164     function setAutoExtendExpiration(bool _autoExtendEnabled) public onlyRootPlatformAdministrator {
1165         autoExtendExpiration = _autoExtendEnabled;
1166 
1167         emit UpdatedAutoExtendExpiration(msg.sender, _autoExtendEnabled);
1168     }
1169 
1170     function updateIdentity(address _wallet, bool _isWhitelisted, address _investorKey, address _issuer) public onlyWhitelistControl {
1171         setWhitelisted(_wallet, _isWhitelisted, _investorKey, _issuer);
1172 
1173         emit UpdatedIdentity(msg.sender, _wallet, _isWhitelisted, _investorKey, _issuer);
1174     }
1175 }
1176 
1177 // File: contracts/controller/interface/IExchangeRateOracle.sol
1178 
1179 contract IExchangeRateOracle {
1180     function resetCurrencyPair(address _currencyA, address _currencyB) public;
1181 
1182     function configureCurrencyPair(address _currencyA, address _currencyB, uint256 maxNextUpdateInBlocks) public;
1183 
1184     function setExchangeRate(address _currencyA, address _currencyB, uint256 _rateFromTo, uint256 _rateToFrom) public;
1185     function getExchangeRate(address _currencyA, address _currencyB) public view returns (uint256);
1186 
1187     function convert(address _currencyA, address _currencyB, uint256 _amount) public view returns (uint256);
1188     function convertTT(bytes32 _currencyAText, bytes32 _currencyBText, uint256 _amount) public view returns (uint256);
1189     function convertTA(bytes32 _currencyAText, address _currencyB, uint256 _amount) public view returns (uint256);
1190     function convertAT(address _currencyA, bytes32 _currencyBText, uint256 _amount) public view returns (uint256);
1191 }
1192 
1193 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Detailed.sol
1194 
1195 /**
1196  * @title ERC20Detailed token
1197  * @dev The decimals are only for visualization purposes.
1198  * All the operations are done using the smallest and indivisible token unit,
1199  * just as on Ethereum all the operations are done in wei.
1200  */
1201 contract ERC20Detailed is IERC20 {
1202     string private _name;
1203     string private _symbol;
1204     uint8 private _decimals;
1205 
1206     constructor (string memory name, string memory symbol, uint8 decimals) public {
1207         _name = name;
1208         _symbol = symbol;
1209         _decimals = decimals;
1210     }
1211 
1212     /**
1213      * @return the name of the token.
1214      */
1215     function name() public view returns (string memory) {
1216         return _name;
1217     }
1218 
1219     /**
1220      * @return the symbol of the token.
1221      */
1222     function symbol() public view returns (string memory) {
1223         return _symbol;
1224     }
1225 
1226     /**
1227      * @return the number of decimals of the token.
1228      */
1229     function decimals() public view returns (uint8) {
1230         return _decimals;
1231     }
1232 }
1233 
1234 // File: contracts/controller/interfaces/IBasicAssetToken.sol
1235 
1236 interface IBasicAssetToken {
1237     //AssetToken specific
1238     function isTokenAlive() external view returns (bool);
1239 
1240     //Mintable
1241     function mint(address _to, uint256 _amount) external returns (bool);
1242     function finishMinting() external returns (bool);
1243 }
1244 
1245 // File: contracts/controller/Permissions/StorageAdministratorRole.sol
1246 
1247 /*
1248     Copyright 2018, CONDA
1249 
1250     This program is free software: you can redistribute it and/or modify
1251     it under the terms of the GNU General Public License as published by
1252     the Free Software Foundation, either version 3 of the License, or
1253     (at your option) any later version.
1254 
1255     This program is distributed in the hope that it will be useful,
1256     but WITHOUT ANY WARRANTY; without even the implied warranty of
1257     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
1258     GNU General Public License for more details.
1259 
1260     You should have received a copy of the GNU General Public License
1261     along with this program.  If not, see <http://www.gnu.org/licenses/>.
1262 */
1263 
1264 
1265 /** @title StorageAdministratorRole role to administrate generic storage. */
1266 contract StorageAdministratorRole is RootPlatformAdministratorRole {
1267 
1268 ///////////////////
1269 // Events
1270 ///////////////////
1271 
1272     event StorageAdministratorAdded(address indexed account);
1273     event StorageAdministratorRemoved(address indexed account);
1274 
1275 ///////////////////
1276 // Variables
1277 ///////////////////
1278 
1279     Roles.Role private storageAdministrators;
1280 
1281 ///////////////////
1282 // Constructor
1283 ///////////////////
1284 
1285     constructor() internal {
1286         _addStorageAdministrator(msg.sender);
1287     }
1288 
1289 ///////////////////
1290 // Modifiers
1291 ///////////////////
1292 
1293     modifier onlyStorageAdministrator() {
1294         require(isStorageAdministrator(msg.sender), "no SAdmin");
1295         _;
1296     }
1297 
1298 ///////////////////
1299 // Functions
1300 ///////////////////
1301 
1302     function isStorageAdministrator(address account) public view returns (bool) {
1303         return storageAdministrators.has(account);
1304     }
1305 
1306     function addStorageAdministrator(address account) public onlyRootPlatformAdministrator {
1307         _addStorageAdministrator(account);
1308     }
1309 
1310     function _addStorageAdministrator(address account) internal {
1311         storageAdministrators.add(account);
1312         emit StorageAdministratorAdded(account);
1313     }
1314 
1315     function removeStorageAdministrator(address account) public onlyRootPlatformAdministrator {
1316         storageAdministrators.remove(account);
1317         emit StorageAdministratorRemoved(account);
1318     }
1319 }
1320 
1321 // File: contracts/controller/Storage/storagetypes/UintStorage.sol
1322 
1323 /*
1324     Copyright 2018, CONDA
1325 
1326     This program is free software: you can redistribute it and/or modify
1327     it under the terms of the GNU General Public License as published by
1328     the Free Software Foundation, either version 3 of the License, or
1329     (at your option) any later version.
1330 
1331     This program is distributed in the hope that it will be useful,
1332     but WITHOUT ANY WARRANTY; without even the implied warranty of
1333     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
1334     GNU General Public License for more details.
1335 
1336     You should have received a copy of the GNU General Public License
1337     along with this program.  If not, see <http://www.gnu.org/licenses/>.
1338 */
1339 
1340 
1341 /** @title UintStorage uint storage. */
1342 contract UintStorage is StorageAdministratorRole
1343 {
1344 
1345 ///////////////////
1346 // Mappings
1347 ///////////////////
1348 
1349     mapping (bytes32 => uint256) private uintStorage;
1350 
1351 ///////////////////
1352 // Functions
1353 ///////////////////
1354 
1355     function setUint(bytes32 _name, uint256 _value)
1356         public 
1357         onlyStorageAdministrator 
1358     {
1359         return _setUint(_name, _value);
1360     }
1361 
1362     function getUint(bytes32 _name) 
1363         public view 
1364         returns (uint256) 
1365     {
1366         return _getUint(_name);
1367     }
1368 
1369     function _setUint(bytes32 _name, uint256 _value)
1370         private 
1371     {
1372         if(_name != "") {
1373             uintStorage[_name] = _value;
1374         }
1375     }
1376 
1377     function _getUint(bytes32 _name) 
1378         private view 
1379         returns (uint256) 
1380     {
1381         return uintStorage[_name];
1382     }
1383 
1384     function get2Uint(
1385         bytes32 _name1, 
1386         bytes32 _name2) 
1387         public view 
1388         returns (uint256, uint256) 
1389     {
1390         return (_getUint(_name1), _getUint(_name2));
1391     }
1392     
1393     function get3Uint(
1394         bytes32 _name1, 
1395         bytes32 _name2, 
1396         bytes32 _name3) 
1397         public view 
1398         returns (uint256, uint256, uint256) 
1399     {
1400         return (_getUint(_name1), _getUint(_name2), _getUint(_name3));
1401     }
1402 
1403     function get4Uint(
1404         bytes32 _name1, 
1405         bytes32 _name2, 
1406         bytes32 _name3, 
1407         bytes32 _name4) 
1408         public view 
1409         returns (uint256, uint256, uint256, uint256) 
1410     {
1411         return (_getUint(_name1), _getUint(_name2), _getUint(_name3), _getUint(_name4));
1412     }
1413 
1414     function get5Uint(
1415         bytes32 _name1, 
1416         bytes32 _name2, 
1417         bytes32 _name3, 
1418         bytes32 _name4, 
1419         bytes32 _name5) 
1420         public view 
1421         returns (uint256, uint256, uint256, uint256, uint256) 
1422     {
1423         return (_getUint(_name1), 
1424             _getUint(_name2), 
1425             _getUint(_name3), 
1426             _getUint(_name4), 
1427             _getUint(_name5));
1428     }
1429 
1430     function set2Uint(
1431         bytes32 _name1, uint256 _value1, 
1432         bytes32 _name2, uint256 _value2)
1433         public 
1434         onlyStorageAdministrator 
1435     {
1436         _setUint(_name1, _value1);
1437         _setUint(_name2, _value2);
1438     }
1439 
1440     function set3Uint(
1441         bytes32 _name1, uint256 _value1, 
1442         bytes32 _name2, uint256 _value2,
1443         bytes32 _name3, uint256 _value3)
1444         public 
1445         onlyStorageAdministrator 
1446     {
1447         _setUint(_name1, _value1);
1448         _setUint(_name2, _value2);
1449         _setUint(_name3, _value3);
1450     }
1451 
1452     function set4Uint(
1453         bytes32 _name1, uint256 _value1, 
1454         bytes32 _name2, uint256 _value2,
1455         bytes32 _name3, uint256 _value3,
1456         bytes32 _name4, uint256 _value4)
1457         public 
1458         onlyStorageAdministrator 
1459     {
1460         _setUint(_name1, _value1);
1461         _setUint(_name2, _value2);
1462         _setUint(_name3, _value3);
1463         _setUint(_name4, _value4);
1464     }
1465 
1466     function set5Uint(
1467         bytes32 _name1, uint256 _value1, 
1468         bytes32 _name2, uint256 _value2,
1469         bytes32 _name3, uint256 _value3,
1470         bytes32 _name4, uint256 _value4,
1471         bytes32 _name5, uint256 _value5)
1472         public 
1473         onlyStorageAdministrator 
1474     {
1475         _setUint(_name1, _value1);
1476         _setUint(_name2, _value2);
1477         _setUint(_name3, _value3);
1478         _setUint(_name4, _value4);
1479         _setUint(_name5, _value5);
1480     }
1481 }
1482 
1483 // File: contracts/controller/Storage/storagetypes/AddrStorage.sol
1484 
1485 /*
1486     Copyright 2018, CONDA
1487 
1488     This program is free software: you can redistribute it and/or modify
1489     it under the terms of the GNU General Public License as published by
1490     the Free Software Foundation, either version 3 of the License, or
1491     (at your option) any later version.
1492 
1493     This program is distributed in the hope that it will be useful,
1494     but WITHOUT ANY WARRANTY; without even the implied warranty of
1495     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
1496     GNU General Public License for more details.
1497 
1498     You should have received a copy of the GNU General Public License
1499     along with this program.  If not, see <http://www.gnu.org/licenses/>.
1500 */
1501 
1502 
1503 /** @title AddrStorage address storage. */
1504 contract AddrStorage is StorageAdministratorRole
1505 {
1506 
1507 ///////////////////
1508 // Mappings
1509 ///////////////////
1510 
1511     mapping (bytes32 => address) private addrStorage;
1512 
1513 ///////////////////
1514 // Functions
1515 ///////////////////
1516 
1517     function setAddr(bytes32 _name, address _value)
1518         public 
1519         onlyStorageAdministrator 
1520     {
1521         return _setAddr(_name, _value);
1522     }
1523 
1524     function getAddr(bytes32 _name) 
1525         public view 
1526         returns (address) 
1527     {
1528         return _getAddr(_name);
1529     }
1530 
1531     function _setAddr(bytes32 _name, address _value)
1532         private 
1533     {
1534         if(_name != "") {
1535             addrStorage[_name] = _value;
1536         }
1537     }
1538 
1539     function _getAddr(bytes32 _name) 
1540         private view 
1541         returns (address) 
1542     {
1543         return addrStorage[_name];
1544     }
1545 
1546     function get2Address(
1547         bytes32 _name1, 
1548         bytes32 _name2) 
1549         public view 
1550         returns (address, address) 
1551     {
1552         return (_getAddr(_name1), _getAddr(_name2));
1553     }
1554     
1555     function get3Address(
1556         bytes32 _name1, 
1557         bytes32 _name2, 
1558         bytes32 _name3) 
1559         public view 
1560         returns (address, address, address) 
1561     {
1562         return (_getAddr(_name1), _getAddr(_name2), _getAddr(_name3));
1563     }
1564 
1565     function set2Address(
1566         bytes32 _name1, address _value1, 
1567         bytes32 _name2, address _value2)
1568         public 
1569         onlyStorageAdministrator 
1570     {
1571         _setAddr(_name1, _value1);
1572         _setAddr(_name2, _value2);
1573     }
1574 
1575     function set3Address(
1576         bytes32 _name1, address _value1, 
1577         bytes32 _name2, address _value2,
1578         bytes32 _name3, address _value3)
1579         public 
1580         onlyStorageAdministrator 
1581     {
1582         _setAddr(_name1, _value1);
1583         _setAddr(_name2, _value2);
1584         _setAddr(_name3, _value3);
1585     }
1586 }
1587 
1588 // File: contracts/controller/Storage/storagetypes/Addr2UintStorage.sol
1589 
1590 /*
1591     Copyright 2018, CONDA
1592 
1593     This program is free software: you can redistribute it and/or modify
1594     it under the terms of the GNU General Public License as published by
1595     the Free Software Foundation, either version 3 of the License, or
1596     (at your option) any later version.
1597 
1598     This program is distributed in the hope that it will be useful,
1599     but WITHOUT ANY WARRANTY; without even the implied warranty of
1600     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
1601     GNU General Public License for more details.
1602 
1603     You should have received a copy of the GNU General Public License
1604     along with this program.  If not, see <http://www.gnu.org/licenses/>.
1605 */
1606 
1607 
1608 /** @title Addr2UintStorage address to uint mapping storage. */
1609 contract Addr2UintStorage is StorageAdministratorRole
1610 {
1611     
1612 ///////////////////
1613 // Mappings
1614 ///////////////////
1615 
1616     mapping (bytes32 => mapping (address => uint256)) private addr2UintStorage;
1617 
1618 ///////////////////
1619 // Functions
1620 ///////////////////
1621 
1622     function setAddr2Uint(bytes32 _name, address _address, uint256 _value)
1623         public 
1624         onlyStorageAdministrator 
1625     {
1626         return _setAddr2Uint(_name, _address, _value);
1627     }
1628 
1629     function getAddr2Uint(bytes32 _name, address _address)
1630         public view 
1631         returns (uint256) 
1632     {
1633         return _getAddr2Uint(_name, _address);
1634     }
1635 
1636     function _setAddr2Uint(bytes32 _name, address _address, uint256 _value)
1637         private 
1638     {
1639         if(_name != "") {
1640             addr2UintStorage[_name][_address] = _value;
1641         }
1642     }
1643 
1644     function _getAddr2Uint(bytes32 _name, address _address)
1645         private view 
1646         returns (uint256) 
1647     {
1648         return addr2UintStorage[_name][_address];
1649     }
1650 
1651     function get2Addr2Uint(
1652         bytes32 _name1, address _address1,
1653         bytes32 _name2, address _address2)
1654         public view 
1655         returns (uint256, uint256) 
1656     {
1657         return (_getAddr2Uint(_name1, _address1), 
1658             _getAddr2Uint(_name2, _address2));
1659     }
1660     
1661     function get3Addr2Addr2Uint(
1662         bytes32 _name1, address _address1,
1663         bytes32 _name2, address _address2,
1664         bytes32 _name3, address _address3) 
1665         public view 
1666         returns (uint256, uint256, uint256) 
1667     {
1668         return (_getAddr2Uint(_name1, _address1), 
1669             _getAddr2Uint(_name2, _address2), 
1670             _getAddr2Uint(_name3, _address3));
1671     }
1672 
1673     function set2Addr2Uint(
1674         bytes32 _name1, address _address1, uint256 _value1, 
1675         bytes32 _name2, address _address2, uint256 _value2)
1676         public 
1677         onlyStorageAdministrator 
1678     {
1679         _setAddr2Uint(_name1, _address1, _value1);
1680         _setAddr2Uint(_name2, _address2, _value2);
1681     }
1682 
1683     function set3Addr2Uint(
1684         bytes32 _name1, address _address1, uint256 _value1, 
1685         bytes32 _name2, address _address2, uint256 _value2,
1686         bytes32 _name3, address _address3, uint256 _value3)
1687         public 
1688         onlyStorageAdministrator 
1689     {
1690         _setAddr2Uint(_name1, _address1, _value1);
1691         _setAddr2Uint(_name2, _address2, _value2);
1692         _setAddr2Uint(_name3, _address3, _value3);
1693     }
1694 }
1695 
1696 // File: contracts/controller/Storage/storagetypes/Addr2AddrStorage.sol
1697 
1698 /*
1699     Copyright 2018, CONDA
1700 
1701     This program is free software: you can redistribute it and/or modify
1702     it under the terms of the GNU General Public License as published by
1703     the Free Software Foundation, either version 3 of the License, or
1704     (at your option) any later version.
1705 
1706     This program is distributed in the hope that it will be useful,
1707     but WITHOUT ANY WARRANTY; without even the implied warranty of
1708     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
1709     GNU General Public License for more details.
1710 
1711     You should have received a copy of the GNU General Public License
1712     along with this program.  If not, see <http://www.gnu.org/licenses/>.
1713 */
1714 
1715 
1716 /** @title Addr2AddrStorage address to address mapping storage. */
1717 contract Addr2AddrStorage is StorageAdministratorRole
1718 {
1719 ///////////////////
1720 // Mappings
1721 ///////////////////
1722 
1723     mapping (bytes32 => mapping (address => address)) private addr2AddrStorage;
1724 
1725 ///////////////////
1726 // Functions
1727 ///////////////////
1728 
1729     function setAddr2Addr(bytes32 _name, address _address, address _value)
1730         public 
1731         onlyStorageAdministrator 
1732     {
1733         return _setAddr2Addr(_name, _address, _value);
1734     }
1735 
1736     function getAddr2Addr(bytes32 _name, address _address)
1737         public view 
1738         returns (address) 
1739     {
1740         return _getAddr2Addr(_name, _address);
1741     }
1742 
1743     function _setAddr2Addr(bytes32 _name, address _address, address _value)
1744         private 
1745     {
1746         if(_name != "") {
1747             addr2AddrStorage[_name][_address] = _value;
1748         }
1749     }
1750 
1751     function _getAddr2Addr(bytes32 _name, address _address)
1752         private view 
1753         returns (address) 
1754     {
1755         return addr2AddrStorage[_name][_address];
1756     }
1757 
1758     function get2Addr2Addr(
1759         bytes32 _name1, address _address1,
1760         bytes32 _name2, address _address2)
1761         public view 
1762         returns (address, address) 
1763     {
1764         return (_getAddr2Addr(_name1, _address1), 
1765             _getAddr2Addr(_name2, _address2));
1766     }
1767     
1768     function get3Addr2Addr2Addr(
1769         bytes32 _name1, address _address1,
1770         bytes32 _name2, address _address2,
1771         bytes32 _name3, address _address3) 
1772         public view 
1773         returns (address, address, address) 
1774     {
1775         return (_getAddr2Addr(_name1, _address1), 
1776             _getAddr2Addr(_name2, _address2), 
1777             _getAddr2Addr(_name3, _address3));
1778     }
1779 
1780     function set2Addr2Addr(
1781         bytes32 _name1, address _address1, address _value1, 
1782         bytes32 _name2, address _address2, address _value2)
1783         public 
1784         onlyStorageAdministrator 
1785     {
1786         _setAddr2Addr(_name1, _address1, _value1);
1787         _setAddr2Addr(_name2, _address2, _value2);
1788     }
1789 
1790     function set3Addr2Addr(
1791         bytes32 _name1, address _address1, address _value1, 
1792         bytes32 _name2, address _address2, address _value2,
1793         bytes32 _name3, address _address3, address _value3)
1794         public 
1795         onlyStorageAdministrator 
1796     {
1797         _setAddr2Addr(_name1, _address1, _value1);
1798         _setAddr2Addr(_name2, _address2, _value2);
1799         _setAddr2Addr(_name3, _address3, _value3);
1800     }
1801 }
1802 
1803 // File: contracts/controller/Storage/storagetypes/Addr2BoolStorage.sol
1804 
1805 /*
1806     Copyright 2018, CONDA
1807 
1808     This program is free software: you can redistribute it and/or modify
1809     it under the terms of the GNU General Public License as published by
1810     the Free Software Foundation, either version 3 of the License, or
1811     (at your option) any later version.
1812 
1813     This program is distributed in the hope that it will be useful,
1814     but WITHOUT ANY WARRANTY; without even the implied warranty of
1815     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
1816     GNU General Public License for more details.
1817 
1818     You should have received a copy of the GNU General Public License
1819     along with this program.  If not, see <http://www.gnu.org/licenses/>.
1820 */
1821 
1822 
1823 /** @title Addr2BoolStorage address to address mapping storage. */
1824 contract Addr2BoolStorage is StorageAdministratorRole
1825 {
1826     
1827 ///////////////////
1828 // Mappings
1829 ///////////////////
1830 
1831     mapping (bytes32 => mapping (address => bool)) private addr2BoolStorage;
1832 
1833 ///////////////////
1834 // Functions
1835 ///////////////////
1836 
1837     function setAddr2Bool(bytes32 _name, address _address, bool _value)
1838         public 
1839         onlyStorageAdministrator 
1840     {
1841         return _setAddr2Bool(_name, _address, _value);
1842     }
1843 
1844     function getAddr2Bool(bytes32 _name, address _address)
1845         public view  
1846         returns (bool) 
1847     {
1848         return _getAddr2Bool(_name, _address);
1849     }
1850 
1851     function _setAddr2Bool(bytes32 _name, address _address, bool _value)
1852         private 
1853     {
1854         if(_name != "") {
1855             addr2BoolStorage[_name][_address] = _value;
1856         }
1857     }
1858 
1859     function _getAddr2Bool(bytes32 _name, address _address)
1860         private view 
1861         returns (bool) 
1862     {
1863         return addr2BoolStorage[_name][_address];
1864     }
1865 
1866     function get2Addr2Bool(
1867         bytes32 _name1, address _address1,
1868         bytes32 _name2, address _address2)
1869         public view 
1870         returns (bool, bool) 
1871     {
1872         return (_getAddr2Bool(_name1, _address1), 
1873             _getAddr2Bool(_name2, _address2));
1874     }
1875     
1876     function get3Address2Address2Bool(
1877         bytes32 _name1, address _address1,
1878         bytes32 _name2, address _address2,
1879         bytes32 _name3, address _address3) 
1880         public view 
1881         returns (bool, bool, bool) 
1882     {
1883         return (_getAddr2Bool(_name1, _address1), 
1884             _getAddr2Bool(_name2, _address2), 
1885             _getAddr2Bool(_name3, _address3));
1886     }
1887 
1888     function set2Address2Bool(
1889         bytes32 _name1, address _address1, bool _value1, 
1890         bytes32 _name2, address _address2, bool _value2)
1891         public 
1892         onlyStorageAdministrator 
1893     {
1894         _setAddr2Bool(_name1, _address1, _value1);
1895         _setAddr2Bool(_name2, _address2, _value2);
1896     }
1897 
1898     function set3Address2Bool(
1899         bytes32 _name1, address _address1, bool _value1, 
1900         bytes32 _name2, address _address2, bool _value2,
1901         bytes32 _name3, address _address3, bool _value3)
1902         public 
1903         onlyStorageAdministrator 
1904     {
1905         _setAddr2Bool(_name1, _address1, _value1);
1906         _setAddr2Bool(_name2, _address2, _value2);
1907         _setAddr2Bool(_name3, _address3, _value3);
1908     }
1909 }
1910 
1911 // File: contracts/controller/Storage/storagetypes/BytesStorage.sol
1912 
1913 /*
1914     Copyright 2018, CONDA
1915 
1916     This program is free software: you can redistribute it and/or modify
1917     it under the terms of the GNU General Public License as published by
1918     the Free Software Foundation, either version 3 of the License, or
1919     (at your option) any later version.
1920 
1921     This program is distributed in the hope that it will be useful,
1922     but WITHOUT ANY WARRANTY; without even the implied warranty of
1923     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
1924     GNU General Public License for more details.
1925 
1926     You should have received a copy of the GNU General Public License
1927     along with this program.  If not, see <http://www.gnu.org/licenses/>.
1928 */
1929 
1930 
1931 /** @title BytesStorage bytes storage. */
1932 contract BytesStorage is StorageAdministratorRole
1933 {
1934 
1935 ///////////////////
1936 // Mappings
1937 ///////////////////
1938 
1939     mapping (bytes32 => bytes32) private bytesStorage;
1940 
1941 ///////////////////
1942 // Functions
1943 ///////////////////
1944 
1945     function setBytes(bytes32 _name, bytes32 _value)
1946         public 
1947         onlyStorageAdministrator 
1948     {
1949         return _setBytes(_name, _value);
1950     }
1951 
1952     function getBytes(bytes32 _name) 
1953         public view 
1954         returns (bytes32) 
1955     {
1956         return _getBytes(_name);
1957     }
1958 
1959     function _setBytes(bytes32 _name, bytes32 _value)
1960         private 
1961     {
1962         if(_name != "") {
1963             bytesStorage[_name] = _value;
1964         }
1965     }
1966 
1967     function _getBytes(bytes32 _name) 
1968         private view 
1969         returns (bytes32) 
1970     {
1971         return bytesStorage[_name];
1972     }
1973 
1974     function get2Bytes(
1975         bytes32 _name1, 
1976         bytes32 _name2) 
1977         public view 
1978         returns (bytes32, bytes32) 
1979     {
1980         return (_getBytes(_name1), _getBytes(_name2));
1981     }
1982     
1983     function get3Bytes(
1984         bytes32 _name1, 
1985         bytes32 _name2, 
1986         bytes32 _name3) 
1987         public view 
1988         returns (bytes32, bytes32, bytes32) 
1989     {
1990         return (_getBytes(_name1), _getBytes(_name2), _getBytes(_name3));
1991     }
1992 
1993     function set2Bytes(
1994         bytes32 _name1, bytes32 _value1, 
1995         bytes32 _name2, bytes32 _value2)
1996         public 
1997         onlyStorageAdministrator 
1998     {
1999         _setBytes(_name1, _value1);
2000         _setBytes(_name2, _value2);
2001     }
2002 
2003     function set3Bytes(
2004         bytes32 _name1, bytes32 _value1, 
2005         bytes32 _name2, bytes32 _value2,
2006         bytes32 _name3, bytes32 _value3)
2007         public 
2008         onlyStorageAdministrator 
2009     {
2010         _setBytes(_name1, _value1);
2011         _setBytes(_name2, _value2);
2012         _setBytes(_name3, _value3);
2013     }
2014 }
2015 
2016 // File: contracts/controller/Storage/storagetypes/Addr2AddrArrStorage.sol
2017 
2018 /*
2019     Copyright 2018, CONDA
2020 
2021     This program is free software: you can redistribute it and/or modify
2022     it under the terms of the GNU General Public License as published by
2023     the Free Software Foundation, either version 3 of the License, or
2024     (at your option) any later version.
2025 
2026     This program is distributed in the hope that it will be useful,
2027     but WITHOUT ANY WARRANTY; without even the implied warranty of
2028     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
2029     GNU General Public License for more details.
2030 
2031     You should have received a copy of the GNU General Public License
2032     along with this program.  If not, see <http://www.gnu.org/licenses/>.
2033 */
2034 
2035 
2036 /** @title Addr2AddrArrStorage address to address array mapping storage. */
2037 contract Addr2AddrArrStorage is StorageAdministratorRole
2038 {
2039 
2040 ///////////////////
2041 // Mappings
2042 ///////////////////
2043 
2044     mapping (bytes32 => mapping (address => address[])) private addr2AddrArrStorage;
2045 
2046 ///////////////////
2047 // Functions
2048 ///////////////////
2049 
2050     function addToAddr2AddrArr(bytes32 _name, address _address, address _value)
2051         public 
2052         onlyStorageAdministrator 
2053     {
2054         addr2AddrArrStorage[_name][_address].push(_value);
2055     }
2056 
2057     function getAddr2AddrArr(bytes32 _name, address _address)
2058         public view 
2059         returns (address[] memory) 
2060     {
2061         return addr2AddrArrStorage[_name][_address];
2062     }
2063 }
2064 
2065 // File: contracts/controller/Storage/storagetypes/StorageHolder.sol
2066 
2067 /*
2068     Copyright 2018, CONDA
2069 
2070     This program is free software: you can redistribute it and/or modify
2071     it under the terms of the GNU General Public License as published by
2072     the Free Software Foundation, either version 3 of the License, or
2073     (at your option) any later version.
2074 
2075     This program is distributed in the hope that it will be useful,
2076     but WITHOUT ANY WARRANTY; without even the implied warranty of
2077     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
2078     GNU General Public License for more details.
2079 
2080     You should have received a copy of the GNU General Public License
2081     along with this program.  If not, see <http://www.gnu.org/licenses/>.
2082 */
2083 
2084 
2085 
2086 
2087 
2088 
2089 
2090 
2091 /** @title StorageHolder holds the fine-grained generic storage functions. */
2092 contract StorageHolder is 
2093     UintStorage,
2094     BytesStorage,
2095     AddrStorage,
2096     Addr2UintStorage,
2097     Addr2BoolStorage,
2098     Addr2AddrStorage,
2099     Addr2AddrArrStorage
2100 {
2101 
2102 ///////////////////
2103 // Functions
2104 ///////////////////
2105 
2106     function getMixedUBA(bytes32 _uintName, bytes32 _bytesName, bytes32 _addressName) 
2107         public view
2108         returns (uint256, bytes32, address) 
2109     {
2110         return (getUint(_uintName), getBytes(_bytesName), getAddr(_addressName));
2111     }
2112 
2113     function getMixedMapA2UA2BA2A(
2114         bytes32 _a2uName, 
2115         address _a2uAddress, 
2116         bytes32 _a2bName, 
2117         address _a2bAddress, 
2118         bytes32 _a2aName, 
2119         address _a2aAddress)
2120         public view
2121         returns (uint256, bool, address) 
2122     {
2123         return (getAddr2Uint(_a2uName, _a2uAddress), 
2124             getAddr2Bool(_a2bName, _a2bAddress), 
2125             getAddr2Addr(_a2aName, _a2aAddress));
2126     }
2127 }
2128 
2129 // File: contracts/controller/Storage/AT2CSStorage.sol
2130 
2131 /*
2132     Copyright 2018, CONDA
2133 
2134     This program is free software: you can redistribute it and/or modify
2135     it under the terms of the GNU General Public License as published by
2136     the Free Software Foundation, either version 3 of the License, or
2137     (at your option) any later version.
2138 
2139     This program is distributed in the hope that it will be useful,
2140     but WITHOUT ANY WARRANTY; without even the implied warranty of
2141     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
2142     GNU General Public License for more details.
2143 
2144     You should have received a copy of the GNU General Public License
2145     along with this program.  If not, see <http://www.gnu.org/licenses/>.
2146 */
2147 
2148 
2149 
2150 
2151 
2152 /** @title AT2CSStorage AssetToken to Crowdsale storage (that is upgradeable). */
2153 contract AT2CSStorage is StorageAdministratorRole {
2154 
2155 ///////////////////
2156 // Constructor
2157 ///////////////////
2158 
2159     constructor(address controllerStorage) public {
2160         storageHolder = StorageHolder(controllerStorage);
2161     }
2162 
2163 ///////////////////
2164 // Variables
2165 ///////////////////
2166 
2167     StorageHolder storageHolder;
2168 
2169 ///////////////////
2170 // Functions
2171 ///////////////////
2172 
2173     function getAssetTokenOfCrowdsale(address _crowdsale) public view returns (address) {
2174         return storageHolder.getAddr2Addr("cs2at", _crowdsale);
2175     }
2176 
2177     function getRateFromCrowdsale(address _crowdsale) public view returns (uint256) {
2178         address assetToken = storageHolder.getAddr2Addr("cs2at", _crowdsale);
2179         return getRateFromAssetToken(assetToken);
2180     }
2181 
2182     function getRateFromAssetToken(address _assetToken) public view returns (uint256) {
2183         require(_assetToken != address(0), "rate assetTokenIs0");
2184         return storageHolder.getAddr2Uint("rate", _assetToken);
2185     }
2186 
2187     function getAssetTokenOwnerWalletFromCrowdsale(address _crowdsale) public view returns (address) {
2188         address assetToken = storageHolder.getAddr2Addr("cs2at", _crowdsale);
2189         return getAssetTokenOwnerWalletFromAssetToken(assetToken);
2190     }
2191 
2192     function getAssetTokenOwnerWalletFromAssetToken(address _assetToken) public view returns (address) {
2193         return storageHolder.getAddr2Addr("at2wallet", _assetToken);
2194     }
2195 
2196     function getAssetTokensOf(address _wallet) public view returns (address[] memory) {
2197         return storageHolder.getAddr2AddrArr("wallet2AT", _wallet);
2198     }
2199 
2200     function isAssignedCrowdsale(address _crowdsale) public view returns (bool) {
2201         return storageHolder.getAddr2Bool("isCS", _crowdsale);
2202     }
2203 
2204     function isTrustedAssetTokenRegistered(address _assetToken) public view returns (bool) {
2205         return storageHolder.getAddr2Bool("trustedAT", _assetToken);
2206     }
2207 
2208     function isTrustedAssetTokenActive(address _assetToken) public view returns (bool) {
2209         return storageHolder.getAddr2Bool("ATactive", _assetToken);
2210     }
2211 
2212     function checkTrustedAssetToken(address _assetToken) public view returns (bool) {
2213         require(storageHolder.getAddr2Bool("ATactive", _assetToken), "not trusted AT");
2214 
2215         return true;
2216     }
2217 
2218     function checkTrustedCrowdsaleInternal(address _crowdsale) public view returns (bool) {
2219         address _assetTokenAddress = storageHolder.getAddr2Addr("cs2at", _crowdsale);
2220         require(storageHolder.getAddr2Bool("isCS", _crowdsale), "not registered CS");
2221         require(checkTrustedAssetToken(_assetTokenAddress), "not trusted AT");
2222 
2223         return true;
2224     }
2225 
2226     function changeActiveTrustedAssetToken(address _assetToken, bool _active) public onlyStorageAdministrator {
2227         storageHolder.setAddr2Bool("ATactive", _assetToken, _active);
2228     }
2229 
2230     function addTrustedAssetTokenInternal(address _ownerWallet, address _assetToken, uint256 _rate) public onlyStorageAdministrator {
2231         require(!storageHolder.getAddr2Bool("trustedAT", _assetToken), "exists");
2232         require(ERC20Detailed(_assetToken).decimals() == 0, "decimal not 0");
2233 
2234         storageHolder.setAddr2Bool("trustedAT", _assetToken, true);
2235         storageHolder.setAddr2Bool("ATactive", _assetToken, true);
2236         storageHolder.addToAddr2AddrArr("wallet2AT", _ownerWallet, _assetToken);
2237         storageHolder.setAddr2Addr("at2wallet", _assetToken, _ownerWallet);
2238         storageHolder.setAddr2Uint("rate", _assetToken, _rate);
2239     }
2240 
2241     function assignCrowdsale(address _assetToken, address _crowdsale) public onlyStorageAdministrator {
2242         require(storageHolder.getAddr2Bool("trustedAT", _assetToken), "no AT");
2243         require(!storageHolder.getAddr2Bool("isCS", _crowdsale), "is assigned");
2244         require(IBasicAssetToken(_assetToken).isTokenAlive(), "not alive");
2245         require(ERC20Detailed(_assetToken).decimals() == 0, "decimal not 0");
2246         
2247         storageHolder.setAddr2Bool("isCS", _crowdsale, true);
2248         storageHolder.setAddr2Addr("cs2at", _crowdsale, _assetToken);
2249     }
2250 
2251     function setAssetTokenRate(address _assetToken, uint256 _rate) public onlyStorageAdministrator {
2252         storageHolder.setAddr2Uint("rate", _assetToken, _rate);
2253     }
2254 }
2255 
2256 // File: contracts/controller/0_library/ControllerL.sol
2257 
2258 /*
2259     Copyright 2018, CONDA
2260 
2261     This program is free software: you can redistribute it and/or modify
2262     it under the terms of the GNU General Public License as published by
2263     the Free Software Foundation, either version 3 of the License, or
2264     (at your option) any later version.
2265 
2266     This program is distributed in the hope that it will be useful,
2267     but WITHOUT ANY WARRANTY; without even the implied warranty of
2268     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
2269     GNU General Public License for more details.
2270 
2271     You should have received a copy of the GNU General Public License
2272     along with this program.  If not, see <http://www.gnu.org/licenses/>.
2273 */
2274 
2275 
2276 
2277 
2278 
2279 
2280 
2281 
2282 /** @title ControllerL library. */
2283 library ControllerL {
2284     using SafeMath for uint256;
2285 
2286 ///////////////////
2287 // Structs
2288 ///////////////////
2289 
2290     struct Data {
2291         // global flag fees enabled
2292         bool feesEnabled;
2293 
2294         // global flag whitelist enabled
2295         bool whitelistEnabled;
2296 
2297         // address of the crwd token (for fees etc.)
2298         address crwdToken;
2299 
2300         // root platform wallet (receives fees according to it's FeeTable)
2301         address rootPlatformAddress;
2302 
2303         // address of ExchangeRateOracle (converts e.g. ETH to EUR and vice versa)
2304         address exchangeRateOracle;
2305 
2306         // the address of the whitelist contract
2307         address whitelist;
2308 
2309         // the generic storage contract
2310         AT2CSStorage store;
2311 
2312         // global flag to prevent new AssetToken or crowdsales to be accepted (e.g. after upgrade).
2313         bool blockNew;
2314 
2315         // mapping of platform addresses that are trusted
2316         mapping ( address => bool ) trustedPlatform; //note: not easily upgradeable
2317 
2318         // mapping of platform addresses that are trusted
2319         mapping ( address => bool ) onceTrustedPlatform; //note: not easily upgradeable
2320 
2321         // mapping of crowdsale to platform wallet
2322         mapping ( address => address ) crowdsaleToPlatform; //note: not easily upgradeable
2323 
2324         // mapping from platform address to FeeTable
2325         mapping ( address => address ) platformToFeeTable; //note: not easily upgradeable
2326     }
2327 
2328 ///////////////////
2329 // Functions
2330 ///////////////////
2331 
2332     /// @dev Contant point multiplier because no decimals.
2333     function pointMultiplier() private pure returns (uint256) {
2334         return 1e18;
2335     }
2336 
2337     /// @notice Address of generic storage (for upgradability).
2338     function getStorageAddress(Data storage _self) public view returns (address) {
2339         return address(_self.store);
2340     }
2341 
2342     /// @notice Assign generic storage (for upgradability).
2343     /// @param _storage storage address.
2344     function assignStore(Data storage _self, address _storage) public {
2345         _self.store = AT2CSStorage(_storage);
2346     }
2347 
2348     /// @notice Get FeeTable for platform.
2349     /// @param _platform platform to find FeeTable for.
2350     /// @return address of FeeTable of platform.
2351     function getFeeTableAddressForPlatform(Data storage _self, address _platform) public view returns (address) {
2352         return _self.platformToFeeTable[_platform];
2353     }
2354 
2355     /// @notice Get FeeTable for platform.
2356     /// @param _platform platform to find FeeTable for.
2357     /// @return address of FeeTable of platform.
2358     function getFeeTableForPlatform(Data storage _self, address _platform) private view returns (FeeTable) {
2359         return FeeTable(_self.platformToFeeTable[_platform]);
2360     }
2361 
2362     /// @notice Set exchange rate oracle address.
2363     /// @param _oracleAddress the address of the ExchangeRateOracle.
2364     function setExchangeRateOracle(Data storage _self, address _oracleAddress) public {
2365         _self.exchangeRateOracle = _oracleAddress;
2366 
2367         emit ExchangeRateOracleSet(msg.sender, _oracleAddress);
2368     }
2369 
2370     /// @notice Check if a wallet is whitelisted or fail. Also considers auto extend (if enabled).
2371     /// @param _wallet the wallet to check.
2372     function checkWhitelistedWallet(Data storage _self, address _wallet) public returns (bool) {
2373         require(Whitelist(_self.whitelist).checkWhitelistedWallet(_wallet), "not whitelist");
2374 
2375         return true;
2376     }
2377 
2378     /// @notice Check if a wallet is whitelisted.
2379     /// @param _wallet the wallet to check.
2380     /// @return true if whitelisted.
2381     function isWhitelistedWallet(Data storage _self, address _wallet) public view returns (bool) {
2382         return Whitelist(_self.whitelist).isWhitelistedWallet(_wallet);
2383     }
2384 
2385     /// @notice Convert eth amount into base currency (EUR), apply exchange rate via oracle, apply rate for AssetToken.
2386     /// @param _crowdsale the crowdsale address.
2387     /// @param _amountInWei the amount desired to be converted into tokens.
2388     function convertEthToEurApplyRateGetTokenAmountFromCrowdsale(
2389         Data storage _self, 
2390         address _crowdsale,
2391         uint256 _amountInWei) 
2392         public view returns (uint256 _effectiveTokensNoDecimals, uint256 _overpaidEthWhenZeroDecimals)
2393     {
2394         uint256 amountInEur = convertEthToEur(_self, _amountInWei);
2395         uint256 tokens = DSMathL.ds_wmul(amountInEur, _self.store.getRateFromCrowdsale(_crowdsale));
2396 
2397         _effectiveTokensNoDecimals = tokens.div(pointMultiplier());
2398         _overpaidEthWhenZeroDecimals = convertEurToEth(_self, DSMathL.ds_wdiv(tokens.sub(_effectiveTokensNoDecimals.mul(pointMultiplier())), _self.store.getRateFromCrowdsale(_crowdsale)));
2399 
2400         return (_effectiveTokensNoDecimals, _overpaidEthWhenZeroDecimals);
2401     }
2402 
2403     /// @notice Checks if a crowdsale is trusted or fail.
2404     /// @param _crowdsale the address of the crowdsale.
2405     /// @return true if trusted.
2406     function checkTrustedCrowdsale(Data storage _self, address _crowdsale) public view returns (bool) {
2407         require(checkTrustedPlatform(_self, _self.crowdsaleToPlatform[_crowdsale]), "not trusted PF0");
2408         require(_self.store.checkTrustedCrowdsaleInternal(_crowdsale), "not trusted CS1");
2409 
2410         return true;   
2411     }
2412 
2413     /// @notice Checks if a AssetToken is trusted or fail.
2414     /// @param _assetToken the address of the AssetToken.
2415     /// @return true if trusted.
2416     function checkTrustedAssetToken(Data storage _self, address _assetToken) public view returns (bool) {
2417         //here just a minimal check for active (simple check on transfer).
2418         require(_self.store.checkTrustedAssetToken(_assetToken), "untrusted AT");
2419 
2420         return true;   
2421     }
2422 
2423     /// @notice Checks if a platform is certified or fail.
2424     /// @param _platformWallet wallet of platform.
2425     /// @return true if trusted.
2426     function checkTrustedPlatform(Data storage _self, address _platformWallet) public view returns (bool) {
2427         require(isTrustedPlatform(_self, _platformWallet), "not trusted PF3");
2428 
2429         return true;
2430     }
2431 
2432     /// @notice Checks if a platform is certified.
2433     /// @param _platformWallet wallet of platform.
2434     /// @return true if certified.
2435     function isTrustedPlatform(Data storage _self, address _platformWallet) public view returns (bool) {
2436         return _self.trustedPlatform[_platformWallet];
2437     }
2438 
2439     /// @notice Add trusted AssetToken.
2440     /// @param _ownerWallet requires CRWD for fees, receives ETH on successful campaign.
2441     /// @param _rate the rate of tokens per basecurrency (currently EUR).
2442     function addTrustedAssetToken(Data storage _self, address _ownerWallet, address _assetToken, uint256 _rate) public {
2443         require(!_self.blockNew, "blocked. newest version?");
2444 
2445         _self.store.addTrustedAssetTokenInternal(_ownerWallet, _assetToken, _rate);
2446 
2447         emit AssetTokenAdded(msg.sender, _ownerWallet, _assetToken, _rate);
2448     }
2449 
2450     /// @notice assign a crowdsale to an AssetToken.
2451     /// @param _assetToken the AssetToken being sold.
2452     /// @param _crowdsale the crowdsale that takes ETH (if enabled) and triggers assignment of tokens.
2453     /// @param _platformWallet the wallet of the platform. Fees are paid to this address.
2454     function assignCrowdsale(Data storage _self, address _assetToken, address _crowdsale, address _platformWallet) public {
2455         require(!_self.blockNew, "blocked. newest version?");
2456         checkTrustedPlatform(_self, _platformWallet);
2457         _self.store.assignCrowdsale(_assetToken, _crowdsale);
2458         _self.crowdsaleToPlatform[_crowdsale] = _platformWallet;
2459 
2460         emit CrowdsaleAssigned(msg.sender, _assetToken, _crowdsale, _platformWallet);
2461     }
2462 
2463     /// @notice Can change the state of an AssetToken (e.g. blacklist for legal reasons)
2464     /// @param _assetToken the AssetToken to change state.
2465     /// @param _active the state. True means active.
2466     /// @return True if successful.
2467     function changeActiveTrustedAssetToken(Data storage _self, address _assetToken, bool _active) public returns (bool) {
2468         _self.store.changeActiveTrustedAssetToken(_assetToken, _active);
2469         emit AssetTokenChangedActive(msg.sender, _assetToken, _active);
2470     }
2471 
2472     /// @notice Function to call on buy request.
2473     /// @param _to beneficiary of tokens.
2474     /// @param _amountInWei the invested ETH amount (unit WEI).
2475     function buyFromCrowdsale(
2476         Data storage _self, 
2477         address _to, 
2478         uint256 _amountInWei) 
2479         public returns (uint256 _tokensCreated, uint256 _overpaidRefund)
2480     {
2481         (uint256 effectiveTokensNoDecimals, uint256 overpaidEth) = convertEthToEurApplyRateGetTokenAmountFromCrowdsale(
2482             _self, 
2483             msg.sender, 
2484             _amountInWei);
2485 
2486         checkValidTokenAssignmentFromCrowdsale(_self, _to);
2487         payFeeFromCrowdsale(_self, effectiveTokensNoDecimals);
2488         _tokensCreated = doTokenAssignment(_self, _to, effectiveTokensNoDecimals, msg.sender);
2489 
2490         return (_tokensCreated, overpaidEth);
2491     }
2492 
2493     /// @notice Assign tokens.
2494     /// @dev Pure assignment without e.g. rate calculation.
2495     /// @param _to beneficiary of tokens.
2496     /// @param _tokensToMint amount of tokens beneficiary receives.
2497     /// @return amount of tokens being created.
2498     function assignFromCrowdsale(Data storage _self, address _to, uint256 _tokensToMint) public returns (uint256 _tokensCreated) {
2499         checkValidTokenAssignmentFromCrowdsale(_self, _to);
2500         payFeeFromCrowdsale(_self, _tokensToMint);
2501 
2502         _tokensCreated = doTokenAssignment(_self, _to, _tokensToMint, msg.sender);
2503 
2504         return _tokensCreated;
2505     }
2506 
2507     /// @dev Token assignment logic.
2508     /// @param _to beneficiary of tokens.
2509     /// @param _tokensToMint amount of tokens beneficiary receives.
2510     /// @param _crowdsale being used.
2511     /// @return amount of tokens being created.
2512     function doTokenAssignment(
2513         Data storage _self, 
2514         address _to, 
2515         uint256 _tokensToMint, 
2516         address _crowdsale) 
2517         private returns 
2518         (uint256 _tokensCreated)
2519     {
2520         address assetToken = _self.store.getAssetTokenOfCrowdsale(_crowdsale);
2521     
2522         require(assetToken != address(0), "assetTokenIs0");
2523         ERC20Mintable(assetToken).mint(_to, _tokensToMint);
2524 
2525         return _tokensToMint;
2526     }
2527 
2528     /// @notice Pay fee on calls from crowdsale.
2529     /// @param _tokensToMint tokens being created.
2530     function payFeeFromCrowdsale(Data storage _self, uint256 _tokensToMint) private {
2531         if (_self.feesEnabled) {
2532             address ownerAssetTokenWallet = _self.store.getAssetTokenOwnerWalletFromCrowdsale(msg.sender);
2533             payFeeKnowingCrowdsale(_self, msg.sender, ownerAssetTokenWallet, _tokensToMint, "investorInvests");
2534         }
2535     }
2536 
2537     /// @notice Check if token assignment is valid and e.g. crowdsale is trusted and investor KYC checked.
2538     /// @param _to beneficiary.
2539     function checkValidTokenAssignmentFromCrowdsale(Data storage _self, address _to) private {
2540         require(checkTrustedCrowdsale(_self, msg.sender), "untrusted source1");
2541 
2542         if (_self.whitelistEnabled) {
2543             checkWhitelistedWallet(_self, _to);
2544         }
2545     }
2546 
2547     /// @notice Pay fee on controller call from Crowdsale.
2548     /// @param _crowdsale the calling Crowdsale contract.
2549     /// @param _ownerAssetToken the AssetToken of the owner.
2550     /// @param _tokensToMint the tokens being created.
2551     /// @param _feeName the name of the fee (key in mapping).
2552     function payFeeKnowingCrowdsale(
2553         Data storage _self, 
2554         address _crowdsale, 
2555         address _ownerAssetToken, 
2556         uint256 _tokensToMint, //tokensToMint requires precalculations and is base for fees
2557         bytes32 _feeName)
2558         private
2559     {
2560         address platform = _self.crowdsaleToPlatform[_crowdsale];
2561 
2562         uint256 feePromilleRootPlatform = getFeeKnowingCrowdsale(
2563             _self, 
2564             _crowdsale, 
2565             getFeeTableAddressForPlatform(_self, _self.rootPlatformAddress),
2566             _tokensToMint, 
2567             false, 
2568             _feeName);
2569 
2570         payWithCrwd(_self, _ownerAssetToken, _self.rootPlatformAddress, feePromilleRootPlatform);
2571 
2572         if(platform != _self.rootPlatformAddress) {
2573             address feeTable = getFeeTableAddressForPlatform(_self, platform);
2574             require(feeTable != address(0), "FeeTbl 0 addr");
2575             uint256 feePromillePlatform = getFeeKnowingCrowdsale(_self, _crowdsale, feeTable, _tokensToMint, false, _feeName);
2576             payWithCrwd(_self, _ownerAssetToken, platform, feePromillePlatform);
2577         }
2578     }
2579 
2580     /// @notice Pay fee on controller call from AssetToken.
2581     /// @param _assetToken the calling AssetToken contract.
2582     /// @param _initiator the initiator passed through as parameter by AssetToken.
2583     /// @param _tokensToMint the tokens being handled.
2584     /// @param _feeName the name of the fee (key in mapping).
2585     function payFeeKnowingAssetToken(
2586         Data storage _self, 
2587         address _assetToken, 
2588         address _initiator, 
2589         uint256 _tokensToMint, //tokensToMint requires precalculations and is base for fees
2590         bytes32 _feeName) 
2591         public 
2592     {
2593         uint256 feePromille = getFeeKnowingAssetToken(
2594             _self, 
2595             _assetToken, 
2596             _initiator, 
2597             _tokensToMint, 
2598             _feeName);
2599 
2600         payWithCrwd(_self, _initiator, _self.rootPlatformAddress, feePromille);
2601     }
2602 
2603     /// @dev this function in the end does the fee payment in CRWD.
2604     function payWithCrwd(Data storage _self, address _from, address _to, uint256 _value) private {
2605         if(_value > 0 && _from != _to) {
2606             ERC20Mintable(_self.crwdToken).transferFrom(_from, _to, _value);
2607             emit FeesPaid(_from, _to, _value);
2608         }
2609     }
2610 
2611     /// @notice Current conversion of ETH to EUR via oracle.
2612     /// @param _weiAmount the ETH amount (uint WEI).
2613     /// @return amount converted in euro.
2614     function convertEthToEur(Data storage _self, uint256 _weiAmount) public view returns (uint256) {
2615         require(_self.exchangeRateOracle != address(0), "no oracle");
2616         return IExchangeRateOracle(_self.exchangeRateOracle).convertTT("ETH", "EUR", _weiAmount);
2617     }
2618 
2619     /// @notice Current conversion of EUR to ETH via oracle.
2620     /// @param _eurAmount the EUR amount
2621     /// @return amount converted in eth (formatted like WEI)
2622     function convertEurToEth(Data storage _self, uint256 _eurAmount) public view returns (uint256) {
2623         require(_self.exchangeRateOracle != address(0), "no oracle");
2624         return IExchangeRateOracle(_self.exchangeRateOracle).convertTT("EUR", "ETH", _eurAmount);
2625     }
2626 
2627     /// @notice Get fee that needs to be paid for certain Crowdsale and FeeName.
2628     /// @param _crowdsale the Crowdsale being used.
2629     /// @param _feeTableAddr the address of the feetable.
2630     /// @param _amountInTokensOrEth the amount in tokens or pure ETH when conversion parameter true.
2631     /// @param _amountRequiresConversion when true amount parameter is converted from ETH into tokens.
2632     /// @param _feeName the name of the fee being paid.
2633     /// @return amount of fees that would/will be paid.
2634     function getFeeKnowingCrowdsale(
2635         Data storage _self,
2636         address _crowdsale, 
2637         address _feeTableAddr, 
2638         uint256 _amountInTokensOrEth,
2639         bool _amountRequiresConversion,
2640         bytes32 _feeName) 
2641         public view returns (uint256) 
2642     {
2643         uint256 tokens = _amountInTokensOrEth;
2644 
2645         if(_amountRequiresConversion) {
2646             (tokens, ) = convertEthToEurApplyRateGetTokenAmountFromCrowdsale(_self, _crowdsale, _amountInTokensOrEth);
2647         }
2648         
2649         FeeTable feeTable = FeeTable(_feeTableAddr);
2650         address assetTokenOfCrowdsale = _self.store.getAssetTokenOfCrowdsale(_crowdsale);
2651 
2652         return feeTable.getFeeFor(_feeName, assetTokenOfCrowdsale, tokens, _self.exchangeRateOracle);
2653     }
2654 
2655     /// @notice Get fee that needs to be paid for certain AssetToken and FeeName.
2656     /// @param _assetToken the AssetToken being used.
2657     /// @param _tokenAmount the amount in tokens.
2658     /// @param _feeName the name of the fee being paid.
2659     /// @return amount of fees that would/will be paid.
2660     function getFeeKnowingAssetToken(
2661         Data storage _self, 
2662         address _assetToken, 
2663         address /*_from*/, 
2664         uint256 _tokenAmount, 
2665         bytes32 _feeName) 
2666         public view returns (uint256) 
2667     {
2668         FeeTable feeTable = getFeeTableForPlatform(_self, _self.rootPlatformAddress);
2669         return feeTable.getFeeFor(_feeName, _assetToken, _tokenAmount, _self.exchangeRateOracle);
2670     }
2671 
2672     /// @notice Set CRWD token address (e.g. for fees).
2673     /// @param _crwdToken the CRWD token address.
2674     function setCrwdTokenAddress(Data storage _self, address _crwdToken) public {
2675         _self.crwdToken = _crwdToken;
2676         emit CrwdTokenAddressChanged(_crwdToken);
2677     }
2678 
2679     /// @notice set platform address to trusted. A platform can receive fees.
2680     /// @param _platformWallet the wallet that will receive fees.
2681     /// @param _trusted true means trusted and false means not (=default).
2682     function setTrustedPlatform(Data storage _self, address _platformWallet, bool _trusted) public {
2683         setTrustedPlatformInternal(_self, _platformWallet, _trusted, false);
2684     }
2685 
2686     /// @dev set trusted platform logic
2687     /// @param _platformWallet the wallet that will receive fees.
2688     /// @param _trusted true means trusted and false means not (=default).
2689     /// @param _isRootPlatform true means that the given address is the root platform (here mainly used to save info into event).
2690     function setTrustedPlatformInternal(Data storage _self, address _platformWallet, bool _trusted, bool _isRootPlatform) private {
2691         require(_self.rootPlatformAddress != address(0), "no rootPF");
2692 
2693         _self.trustedPlatform[_platformWallet] = _trusted;
2694         
2695         if(_trusted && !_self.onceTrustedPlatform[msg.sender]) {
2696             _self.onceTrustedPlatform[_platformWallet] = true;
2697             FeeTable ft = new FeeTable(_self.rootPlatformAddress);
2698             _self.platformToFeeTable[_platformWallet] = address(ft);
2699         }
2700 
2701         emit PlatformTrustChanged(_platformWallet, _trusted, _isRootPlatform);
2702     }
2703 
2704     /// @notice Set root platform address. Root platform address can receive fees (independent of which Crowdsale/AssetToken).
2705     /// @param _rootPlatformWallet wallet of root platform.
2706     function setRootPlatform(Data storage _self, address _rootPlatformWallet) public {
2707         _self.rootPlatformAddress = _rootPlatformWallet;
2708         emit RootPlatformChanged(_rootPlatformWallet);
2709 
2710         setTrustedPlatformInternal(_self, _rootPlatformWallet, true, true);
2711     }
2712 
2713     /// @notice Set rate of AssetToken.
2714     /// @dev Rate is from BaseCurrency (currently EUR). E.g. rate 2 means 2 tokens per 1 EUR.
2715     /// @param _assetToken the regarding AssetToken the rate should be applied on.
2716     /// @param _rate the rate.
2717     function setAssetTokenRate(Data storage _self, address _assetToken, uint256 _rate) public {
2718         _self.store.setAssetTokenRate(_assetToken, _rate);
2719         emit AssetTokenRateChanged(_assetToken, _rate);
2720     }
2721 
2722     /// @notice If this contract gets a balance in some other ERC20 contract - or even iself - then we can rescue it.
2723     /// @param _foreignTokenAddress token where contract has balance.
2724     /// @param _to the beneficiary.
2725     function rescueToken(Data storage /*_self*/, address _foreignTokenAddress, address _to) public
2726     {
2727         ERC20Mintable(_foreignTokenAddress).transfer(_to, ERC20(_foreignTokenAddress).balanceOf(address(this)));
2728     }
2729 
2730 ///////////////////
2731 // Events
2732 ///////////////////
2733     event AssetTokenAdded(address indexed initiator, address indexed wallet, address indexed assetToken, uint256 rate);
2734     event AssetTokenChangedActive(address indexed initiator, address indexed assetToken, bool active);
2735     event PlatformTrustChanged(address indexed platformWallet, bool trusted, bool isRootPlatform);
2736     event CrwdTokenAddressChanged(address indexed crwdToken);
2737     event AssetTokenRateChanged(address indexed assetToken, uint256 rate);
2738     event RootPlatformChanged(address indexed _rootPlatformWalletAddress);
2739     event CrowdsaleAssigned(address initiator, address indexed assetToken, address indexed crowdsale, address platformWallet);
2740     event ExchangeRateOracleSet(address indexed initiator, address indexed oracleAddress);
2741     event FeesPaid(address indexed from, address indexed to, uint256 value);
2742 }
2743 
2744 // File: contracts/controller/0_library/LibraryHolder.sol
2745 
2746 /** @title LibraryHolder holds libraries used in inheritance bellow. */
2747 contract LibraryHolder {
2748     using ControllerL for ControllerL.Data;
2749 
2750 ///////////////////
2751 // Variables
2752 ///////////////////
2753 
2754     ControllerL.Data internal controllerData;
2755 }
2756 
2757 // File: contracts/controller/1_permissions/PermissionHolder.sol
2758 
2759 /*
2760     Copyright 2018, CONDA
2761 
2762     This program is free software: you can redistribute it and/or modify
2763     it under the terms of the GNU General Public License as published by
2764     the Free Software Foundation, either version 3 of the License, or
2765     (at your option) any later version.
2766 
2767     This program is distributed in the hope that it will be useful,
2768     but WITHOUT ANY WARRANTY; without even the implied warranty of
2769     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
2770     GNU General Public License for more details.
2771 
2772     You should have received a copy of the GNU General Public License
2773     along with this program.  If not, see <http://www.gnu.org/licenses/>.
2774 */
2775 
2776 
2777 
2778 
2779 /** @title PermissionHolder role permissions used in inheritance bellow. */
2780 contract PermissionHolder  is AssetTokenAdministratorRole, At2CsConnectorRole, LibraryHolder {
2781 
2782 }
2783 
2784 // File: contracts/controller/2_provider/MainInfoProvider.sol
2785 
2786 /*
2787     Copyright 2018, CONDA
2788 
2789     This program is free software: you can redistribute it and/or modify
2790     it under the terms of the GNU General Public License as published by
2791     the Free Software Foundation, either version 3 of the License, or
2792     (at your option) any later version.
2793 
2794     This program is distributed in the hope that it will be useful,
2795     but WITHOUT ANY WARRANTY; without even the implied warranty of
2796     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
2797     GNU General Public License for more details.
2798 
2799     You should have received a copy of the GNU General Public License
2800     along with this program.  If not, see <http://www.gnu.org/licenses/>.
2801 */
2802 
2803 
2804 /** @title MainInfoProvider holding simple getters and setters and events without much logic. */
2805 contract MainInfoProvider is PermissionHolder {
2806     
2807 ///////////////////
2808 // Events
2809 ///////////////////
2810 
2811     event AssetTokenAdded(address indexed initiator, address indexed wallet, address indexed assetToken, uint256 rate);
2812     event AssetTokenChangedActive(address indexed initiator, address indexed assetToken, bool active);
2813     event CrwdTokenAddressChanged(address indexed crwdToken);
2814     event ExchangeRateOracleSet(address indexed initiator, address indexed oracleAddress);
2815     event AssetTokenRateChanged(address indexed assetToken, uint256 rate);
2816     event RootPlatformChanged(address indexed _rootPlatformWalletAddress);
2817     event PlatformTrustChanged(address indexed platformWallet, bool trusted, bool isRootPlatform);
2818     event WhitelistSet(address indexed initiator, address indexed whitelistAddress);
2819     event CrowdsaleAssigned(address initiator, address indexed assetToken, address indexed crowdsale, address platformWallet);
2820     event FeesPaid(address indexed from, address indexed to, uint256 value);
2821     event TokenAssignment(address indexed to, uint256 tokensToMint, address indexed crowdsale, bytes8 tag);
2822 
2823 ///////////////////
2824 // Methods (simple getters/setters ONLY)
2825 ///////////////////
2826 
2827     /// @notice Set CRWD token address (e.g. for fees).
2828     /// @param _crwdToken the CRWD token address.
2829     function setCrwdTokenAddress(address _crwdToken) public onlyRootPlatformAdministrator {
2830         controllerData.setCrwdTokenAddress(_crwdToken);
2831     }
2832 
2833     /// @notice Set exchange rate oracle address.
2834     /// @param _oracleAddress the address of the ExchangeRateOracle.
2835     function setOracle(address _oracleAddress) public onlyRootPlatformAdministrator {
2836         controllerData.setExchangeRateOracle(_oracleAddress);
2837     }
2838 
2839     /// @notice Get FeeTable for platform.
2840     /// @param _platform platform to find FeeTable for.
2841     /// @return address of FeeTable of platform.
2842     function getFeeTableAddressForPlatform(address _platform) public view returns (address) {
2843         return controllerData.getFeeTableAddressForPlatform(_platform);
2844     }   
2845 
2846     /// @notice Set rate of AssetToken.
2847     /// @dev Rate is from BaseCurrency (currently EUR). E.g. rate 2 means 2 tokens per 1 EUR.
2848     /// @param _assetToken the regarding AssetToken the rate should be applied on.
2849     /// @param _rate the rate. Unit is WAD (decimal number with 18 digits, so rate of x WAD is x*1e18).
2850     function setAssetTokenRate(address _assetToken, uint256 _rate) public onlyRootPlatformAdministrator {
2851         controllerData.setAssetTokenRate(_assetToken, _rate);
2852     }
2853 
2854     /// @notice Set root platform address. Root platform address can receive fees (independent of which Crowdsale/AssetToken).
2855     /// @param _rootPlatformWallet wallet of root platform.
2856     function setRootPlatform(address _rootPlatformWallet) public onlyRootPlatformAdministrator {
2857         controllerData.setRootPlatform(_rootPlatformWallet);
2858     }
2859 
2860     /// @notice Root platform wallet (receives fees according to it's FeeTable regardless of which Crowdsale/AssetToken)
2861     function getRootPlatform() public view returns (address) {
2862         return controllerData.rootPlatformAddress;
2863     }
2864     
2865     /// @notice Set platform address to trusted. A platform can receive fees.
2866     /// @param _platformWallet the wallet that will receive fees.
2867     /// @param _trusted true means trusted and false means not (=default).
2868     function setTrustedPlatform(address _platformWallet, bool _trusted) public onlyRootPlatformAdministrator {
2869         controllerData.setTrustedPlatform(_platformWallet, _trusted);
2870     }
2871 
2872     /// @notice Is trusted platform.
2873     /// @param _platformWallet platform wallet that recieves fees.
2874     /// @return true if trusted.
2875     function isTrustedPlatform(address _platformWallet) public view returns (bool) {
2876         return controllerData.trustedPlatform[_platformWallet];
2877     }
2878 
2879     /// @notice Get platform of crowdsale.
2880     /// @param _crowdsale the crowdsale to get platfrom from.
2881     /// @return address of owning platform.
2882     function getPlatformOfCrowdsale(address _crowdsale) public view returns (address) {
2883         return controllerData.crowdsaleToPlatform[_crowdsale];
2884     }
2885 
2886     /// @notice Set whitelist contrac address.
2887     /// @param _whitelistAddress the whitelist address.
2888     function setWhitelistContract(address _whitelistAddress) public onlyRootPlatformAdministrator {
2889         controllerData.whitelist = _whitelistAddress;
2890 
2891         emit WhitelistSet(msg.sender, _whitelistAddress);
2892     }
2893 
2894     /// @notice Get address of generic storage that survives an upgrade.
2895     /// @return address of storage.
2896     function getStorageAddress() public view returns (address) {
2897         return controllerData.getStorageAddress();
2898     }
2899 
2900     /// @notice Block new connections between AssetToken and Crowdsale (e.g. on upgrade)
2901     /// @param _isBlockNewActive true if no new AssetTokens or Crowdsales can be added to controller.
2902     function setBlockNewState(bool _isBlockNewActive) public onlyRootPlatformAdministrator {
2903         controllerData.blockNew = _isBlockNewActive;
2904     }
2905 
2906     /// @notice Gets state of block new.
2907     /// @return true if no new AssetTokens or Crowdsales can be added to controller.
2908     function getBlockNewState() public view returns (bool) {
2909         return controllerData.blockNew;
2910     }
2911 }
2912 
2913 // File: contracts/controller/3_manage/ManageAssetToken.sol
2914 
2915 /*
2916     Copyright 2018, CONDA
2917 
2918     This program is free software: you can redistribute it and/or modify
2919     it under the terms of the GNU General Public License as published by
2920     the Free Software Foundation, either version 3 of the License, or
2921     (at your option) any later version.
2922 
2923     This program is distributed in the hope that it will be useful,
2924     but WITHOUT ANY WARRANTY; without even the implied warranty of
2925     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
2926     GNU General Public License for more details.
2927 
2928     You should have received a copy of the GNU General Public License
2929     along with this program.  If not, see <http://www.gnu.org/licenses/>.
2930 */
2931 
2932 
2933 
2934 /** @title ManageAssetToken holds logic functions managing AssetTokens. */
2935 contract ManageAssetToken  is MainInfoProvider {
2936     using SafeMath for uint256;
2937 
2938 ///////////////////
2939 // Functions
2940 ///////////////////
2941 
2942     /// @notice Add trusted AssetToken.
2943     /// @param _ownerWallet requires CRWD for fees, receives ETH on successful campaign.
2944     /// @param _rate the rate of tokens per basecurrency (currently EUR).
2945     function addTrustedAssetToken(address _ownerWallet, address _assetToken, uint256 _rate) 
2946         public 
2947         onlyAssetTokenAdministrator 
2948     {
2949         controllerData.addTrustedAssetToken(_ownerWallet, _assetToken, _rate);
2950     }
2951 
2952     /// @notice Checks if a AssetToken is trusted.
2953     /// @param _assetToken the address of the AssetToken.
2954     function checkTrustedAssetToken(address _assetToken) public view returns (bool) {
2955         return controllerData.checkTrustedAssetToken(_assetToken);
2956     }
2957 
2958     /// @notice Can change the state of an AssetToken (e.g. blacklist for legal reasons)
2959     /// @param _assetToken the AssetToken to change state.
2960     /// @param _active the state. True means active.
2961     /// @return True if successful.
2962     function changeActiveTrustedAssetToken(address _assetToken, bool _active) public onlyRootPlatformAdministrator returns (bool) {
2963         return controllerData.changeActiveTrustedAssetToken(_assetToken, _active);
2964     }
2965 
2966     /// @notice Get fee that needs to be paid for certain AssetToken and FeeName.
2967     /// @param _assetToken the AssetToken being used.
2968     /// @param _tokenAmount the amount in tokens.
2969     /// @param _feeName the name of the fee being paid.
2970     /// @return amount of fees that would/will be paid.
2971     function getFeeKnowingAssetToken(
2972         address _assetToken, 
2973         address _from, 
2974         uint256 _tokenAmount, 
2975         bytes32 _feeName) 
2976         public view returns (uint256)
2977     {
2978         return controllerData.getFeeKnowingAssetToken(_assetToken, _from, _tokenAmount, _feeName);
2979     }
2980 
2981     /// @notice Convert eth amount into base currency (EUR), apply exchange rate via oracle, apply rate for AssetToken.
2982     /// @param _crowdsale the crowdsale address.
2983     /// @param _amountInWei the amount desired to be converted into tokens.
2984     function convertEthToTokenAmount(address _crowdsale, uint256 _amountInWei) public view returns (uint256 _tokens) {
2985         (uint256 tokens, ) = controllerData.convertEthToEurApplyRateGetTokenAmountFromCrowdsale(_crowdsale, _amountInWei);
2986         return tokens;
2987     }
2988 }
2989 
2990 // File: contracts/controller/3_manage/ManageFee.sol
2991 
2992 /*
2993     Copyright 2018, CONDA
2994 
2995     This program is free software: you can redistribute it and/or modify
2996     it under the terms of the GNU General Public License as published by
2997     the Free Software Foundation, either version 3 of the License, or
2998     (at your option) any later version.
2999 
3000     This program is distributed in the hope that it will be useful,
3001     but WITHOUT ANY WARRANTY; without even the implied warranty of
3002     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
3003     GNU General Public License for more details.
3004 
3005     You should have received a copy of the GNU General Public License
3006     along with this program.  If not, see <http://www.gnu.org/licenses/>.
3007 */
3008 
3009 
3010 /** @title ManageAssetToken holds logic functions managing Fees. */
3011 contract ManageFee is MainInfoProvider {
3012 
3013 ///////////////////
3014 // Functions
3015 ///////////////////
3016 
3017     /// @notice Pay fee on controller call from AssetToken.
3018     /// @param _assetToken the calling AssetToken contract.
3019     /// @param _from the initiator passed through as parameter by AssetToken.
3020     /// @param _amount the tokens being handled.
3021     /// @param _feeName the name of the fee (key in mapping).
3022     function payFeeKnowingAssetToken(address _assetToken, address _from, uint256 _amount, bytes32 _feeName) internal {
3023         controllerData.payFeeKnowingAssetToken(_assetToken, _from, _amount, _feeName);
3024     }
3025 }
3026 
3027 // File: contracts/controller/3_manage/ManageCrowdsale.sol
3028 
3029 /*
3030     Copyright 2018, CONDA
3031 
3032     This program is free software: you can redistribute it and/or modify
3033     it under the terms of the GNU General Public License as published by
3034     the Free Software Foundation, either version 3 of the License, or
3035     (at your option) any later version.
3036 
3037     This program is distributed in the hope that it will be useful,
3038     but WITHOUT ANY WARRANTY; without even the implied warranty of
3039     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
3040     GNU General Public License for more details.
3041 
3042     You should have received a copy of the GNU General Public License
3043     along with this program.  If not, see <http://www.gnu.org/licenses/>.
3044 */
3045 
3046 
3047 /** @title ManageAssetToken holds logic functions managing Crowdsales. */
3048 contract ManageCrowdsale is MainInfoProvider {
3049 
3050 ///////////////////
3051 // Functions
3052 ///////////////////
3053 
3054     /// @notice assign a crowdsale to an AssetToken.
3055     /// @param _assetToken the AssetToken being sold.
3056     /// @param _crowdsale the crowdsale that takes ETH (if enabled) and triggers assignment of tokens.
3057     /// @param _platformWallet the wallet of the platform. Fees are paid to this address.
3058     function assignCrowdsale(address _assetToken, address _crowdsale, address _platformWallet) 
3059         public 
3060         onlyAt2CsConnector 
3061     {
3062         controllerData.assignCrowdsale(_assetToken, _crowdsale, _platformWallet);
3063     }
3064 
3065     /// @notice Checks if a crowdsale is trusted.
3066     /// @param _crowdsale the address of the crowdsale.
3067     function checkTrustedCrowdsale(address _crowdsale) public view returns (bool) {
3068         return controllerData.checkTrustedCrowdsale(_crowdsale);
3069     }
3070 
3071     /// @notice Get fee that needs to be paid for certain Crowdsale and FeeName.
3072     /// @param _crowdsale the Crowdsale being used.
3073     /// @param _feeTableAddr the address of the feetable.
3074     /// @param _amountInTokensOrEth the amount in tokens or pure ETH when conversion parameter true.
3075     /// @param _amountRequiresConversion when true amount parameter is converted from ETH into tokens.
3076     /// @param _feeName the name of the fee being paid.
3077     /// @return amount of fees that would/will be paid.
3078     function getFeeKnowingCrowdsale(
3079         address _crowdsale, 
3080         address _feeTableAddr, 
3081         uint256 _amountInTokensOrEth, 
3082         bool _amountRequiresConversion,
3083         bytes32 _feeName) 
3084         public view returns (uint256) 
3085     {
3086         return controllerData.getFeeKnowingCrowdsale(_crowdsale, _feeTableAddr, _amountInTokensOrEth, _amountRequiresConversion, _feeName);
3087     }
3088 }
3089 
3090 // File: contracts/controller/3_manage/ManagePlatform.sol
3091 
3092 /*
3093     Copyright 2018, CONDA
3094 
3095     This program is free software: you can redistribute it and/or modify
3096     it under the terms of the GNU General Public License as published by
3097     the Free Software Foundation, either version 3 of the License, or
3098     (at your option) any later version.
3099 
3100     This program is distributed in the hope that it will be useful,
3101     but WITHOUT ANY WARRANTY; without even the implied warranty of
3102     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
3103     GNU General Public License for more details.
3104 
3105     You should have received a copy of the GNU General Public License
3106     along with this program.  If not, see <http://www.gnu.org/licenses/>.
3107 */
3108 
3109 
3110 
3111 /** @title ManageAssetToken holds logic functions managing platforms. */
3112 contract ManagePlatform  is MainInfoProvider {
3113 
3114 ///////////////////
3115 // Functions
3116 ///////////////////
3117 
3118     /// @notice Checks if a crowdsale is trusted or fail.
3119     /// @param _platformWallet the platform wallet.
3120     /// @return true if trusted.
3121     function checkTrustedPlatform(address _platformWallet) public view returns (bool) {
3122         return controllerData.checkTrustedPlatform(_platformWallet);
3123     }
3124 
3125     /// @notice Is a platform wallet trusted.
3126     /// @return true if trusted.
3127     function isTrustedPlatform(address _platformWallet) public view returns (bool) {
3128         return controllerData.trustedPlatform[_platformWallet];
3129     }
3130 }
3131 
3132 // File: contracts/controller/3_manage/ManageWhitelist.sol
3133 
3134 /*
3135     Copyright 2018, CONDA
3136 
3137     This program is free software: you can redistribute it and/or modify
3138     it under the terms of the GNU General Public License as published by
3139     the Free Software Foundation, either version 3 of the License, or
3140     (at your option) any later version.
3141 
3142     This program is distributed in the hope that it will be useful,
3143     but WITHOUT ANY WARRANTY; without even the implied warranty of
3144     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
3145     GNU General Public License for more details.
3146 
3147     You should have received a copy of the GNU General Public License
3148     along with this program.  If not, see <http://www.gnu.org/licenses/>.
3149 */
3150 
3151 
3152 
3153 /** @title ManageAssetToken holds logic functions managing Whitelist and KYC. */
3154 contract ManageWhitelist  is MainInfoProvider {
3155 
3156 ///////////////////
3157 // Functions
3158 ///////////////////
3159 
3160     /// @notice Check if a wallet is whitelisted or fail. Also considers auto extend (if enabled).
3161     /// @param _wallet the wallet to check.
3162     function checkWhitelistedWallet(address _wallet) public returns (bool) {
3163         controllerData.checkWhitelistedWallet(_wallet);
3164     }
3165 
3166     /// @notice Check if a wallet is whitelisted.
3167     /// @param _wallet the wallet to check.
3168     /// @return true if whitelisted.
3169     function isWhitelistedWallet(address _wallet) public view returns (bool) {
3170         controllerData.isWhitelistedWallet(_wallet);
3171     }
3172 }
3173 
3174 // File: contracts/controller/3_manage/ManagerHolder.sol
3175 
3176 /*
3177     Copyright 2018, CONDA
3178 
3179     This program is free software: you can redistribute it and/or modify
3180     it under the terms of the GNU General Public License as published by
3181     the Free Software Foundation, either version 3 of the License, or
3182     (at your option) any later version.
3183 
3184     This program is distributed in the hope that it will be useful,
3185     but WITHOUT ANY WARRANTY; without even the implied warranty of
3186     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
3187     GNU General Public License for more details.
3188 
3189     You should have received a copy of the GNU General Public License
3190     along with this program.  If not, see <http://www.gnu.org/licenses/>.
3191 */
3192 
3193 
3194 
3195 
3196 
3197 
3198 /** @title ManagerHolder combining all managers into single contract to be inherited. */
3199 contract ManagerHolder is 
3200     ManageAssetToken, 
3201     ManageFee, 
3202     ManageCrowdsale,
3203     ManagePlatform,
3204     ManageWhitelist
3205 {
3206 }
3207 
3208 // File: contracts/controller/interface/ICRWDController.sol
3209 
3210 interface ICRWDController {
3211     function transferParticipantsVerification(address _underlyingCurrency, address _from, address _to, uint256 _tokenAmount) external returns (bool); //from AssetToken
3212     function buyFromCrowdsale(address _to, uint256 _amountInWei) external returns (uint256 _tokensCreated, uint256 _overpaidRefund); //from Crowdsale
3213     function assignFromCrowdsale(address _to, uint256 _tokenAmount, bytes8 _tag) external returns (uint256 _tokensCreated); //from Crowdsale
3214     function calcTokensForEth(uint256 _amountInWei) external view returns (uint256 _tokensWouldBeCreated); //from Crowdsale
3215 }
3216 
3217 // File: contracts/controller/CRWDController.sol
3218 
3219 /** @title CRWDController main contract and n-th child of multi-level inheritance. */
3220 contract CRWDController is ManagerHolder, ICRWDController {
3221 
3222 ///////////////////
3223 // Events
3224 ///////////////////
3225 
3226     event GlobalConfigurationChanged(bool feesEnabled, bool whitelistEnabled);
3227 
3228 ///////////////////
3229 // Constructor
3230 ///////////////////
3231 
3232     constructor(bool _feesEnabled, bool _whitelistEnabled, address _rootPlatformAddress, address _storage) public {
3233         controllerData.assignStore(_storage);
3234         
3235         setRootPlatform(_rootPlatformAddress);
3236 
3237         configure(_feesEnabled, _whitelistEnabled);
3238     }
3239 
3240 ///////////////////
3241 // Functions
3242 ///////////////////
3243 
3244     /// @notice configure global flags.
3245     /// @param _feesEnabled global flag fees enabled.
3246     /// @param _whitelistEnabled global flag whitelist check enabled.
3247     function configure(bool _feesEnabled, bool _whitelistEnabled) public onlyRootPlatformAdministrator {
3248         controllerData.feesEnabled = _feesEnabled;
3249         controllerData.whitelistEnabled = _whitelistEnabled;
3250 
3251         emit GlobalConfigurationChanged(_feesEnabled, _whitelistEnabled);
3252     }
3253 
3254     /// @notice Called from AssetToken on transfer for whitelist check.
3255     /// @param _from the original initiator passed through.
3256     /// @param _to the receiver of the tokens.
3257     /// @param _tokenAmount the amount of tokens to be transfered.
3258     function transferParticipantsVerification(address /*_underlyingCurrency*/, address _from, address _to, uint256 _tokenAmount) public returns (bool) {
3259 
3260         if (controllerData.whitelistEnabled) {
3261             checkWhitelistedWallet(_to); //receiver must be whitelisted
3262         }
3263 
3264         // Caller must be a trusted AssetToken. Otherwise anyone could make investor pay fees for no reason. 
3265         require(checkTrustedAssetToken(msg.sender), "untrusted");
3266 
3267         if (controllerData.feesEnabled) {
3268             payFeeKnowingAssetToken(msg.sender, _from, _tokenAmount, "clearTransferFunds");
3269         }
3270 
3271         return true;
3272     }
3273 
3274     /// @notice Called from Crowdsale on buy token action (paid via Ether).
3275     /// @param _to the beneficiary of the tokens (passed through from Crowdsale).
3276     /// @param _amountInWei the ETH amount (unit WEI).
3277     function buyFromCrowdsale(address _to, uint256 _amountInWei) public returns (uint256 _tokensCreated, uint256 _overpaidRefund) {
3278         return controllerData.buyFromCrowdsale(_to, _amountInWei);
3279     }
3280 
3281     /// @notice Calculate how many tokens will be received per Ether.
3282     /// @param _amountInWei the ETH amount (unit WEI).
3283     /// @return tokens that would be created.
3284     function calcTokensForEth(uint256 _amountInWei) external view returns (uint256 _tokensWouldBeCreated) {
3285         require(checkTrustedCrowdsale(msg.sender), "untrusted source2");
3286 
3287         return convertEthToTokenAmount(msg.sender, _amountInWei);
3288     }
3289 
3290     /// @notice Called from Crowdsale via (semi-)automatic process on off-chain payment.
3291     /// @param _to the beneficiary of the tokens.
3292     /// @param _tokenAmount the amount of tokens to be minted/assigned.
3293     /// @return tokens created.
3294     function assignFromCrowdsale(address _to, uint256 _tokenAmount, bytes8 _tag) external returns (uint256 _tokensCreated) {
3295         _tokensCreated = controllerData.assignFromCrowdsale(_to, _tokenAmount);
3296 
3297         emit TokenAssignment(_to, _tokenAmount, msg.sender, _tag);
3298 
3299         return _tokensCreated;
3300     }
3301 
3302 ////////////////
3303 // Rescue Tokens 
3304 ////////////////
3305 
3306     /// @dev Can rescue tokens accidentally assigned to this contract
3307     /// @param _foreignTokenAddress The address from which the balance will be retrieved
3308     /// @param _to beneficiary
3309     function rescueToken(address _foreignTokenAddress, address _to)
3310     public
3311     onlyRootPlatformAdministrator
3312     {
3313         controllerData.rescueToken(_foreignTokenAddress, _to);
3314     }
3315 }