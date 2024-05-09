1 // File: localhost/helpers/ReentrancyGuard.sol
2 
3 // SPDX-License-Identifier: bsl-1.1
4 
5 pragma solidity ^0.7.1;
6 
7 /**
8  * @dev Contract module that helps prevent reentrant calls to a function.
9  *
10  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
11  * available, which can be applied to functions to make sure there are no nested
12  * (reentrant) calls to them.
13  *
14  * Note that because there is a single `nonReentrant` guard, functions marked as
15  * `nonReentrant` may not call one another. This can be worked around by making
16  * those functions `private`, and then adding `external` `nonReentrant` entry
17  * points to them.
18  *
19  * TIP: If you would like to learn more about reentrancy and alternative ways
20  * to protect against it, check out our blog post
21  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
22  */
23 contract ReentrancyGuard {
24     // Booleans are more expensive than uint256 or any type that takes up a full
25     // word because each write operation emits an extra SLOAD to first read the
26     // slot's contents, replace the bits taken up by the boolean, and then write
27     // back. This is the compiler's defense against contract upgrades and
28     // pointer aliasing, and it cannot be disabled.
29 
30     // The values being non-zero value makes deployment a bit more expensive,
31     // but in exchange the refund on every call to nonReentrant will be lower in
32     // amount. Since refunds are capped to a percentage of the total
33     // transaction's gas, it is best to keep them low in cases like this one, to
34     // increase the likelihood of the full refund coming into effect.
35     uint256 private constant _NOT_ENTERED = 1;
36     uint256 private constant _ENTERED = 2;
37 
38     uint256 private _status;
39 
40     constructor () public {
41         _status = _NOT_ENTERED;
42     }
43 
44     /**
45      * @dev Prevents a contract from calling itself, directly or indirectly.
46      * Calling a `nonReentrant` function from another `nonReentrant`
47      * function is not supported. It is possible to prevent this from happening
48      * by making the `nonReentrant` function external, and make it call a
49      * `private` function that does the actual work.
50      */
51     modifier nonReentrant() {
52         // On the first call to nonReentrant, _notEntered will be true
53         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
54 
55         // Any calls to nonReentrant after this point will fail
56         _status = _ENTERED;
57 
58         _;
59 
60         // By storing the original value once again, a refund is triggered (see
61         // https://eips.ethereum.org/EIPS/eip-2200)
62         _status = _NOT_ENTERED;
63     }
64 }
65 
66 // File: localhost/helpers/Math.sol
67 
68 
69 
70 /*
71   Copyright 2020 Unit Protocol: Artem Zakharov (az@unit.xyz).
72 */
73 pragma solidity ^0.7.1;
74 
75 /**
76  * @dev Standard math utilities missing in the Solidity language.
77  */
78 library Math {
79     /**
80      * @dev Returns the largest of two numbers.
81      */
82     function max(uint256 a, uint256 b) internal pure returns (uint256) {
83         return a >= b ? a : b;
84     }
85 
86     /**
87      * @dev Returns the smallest of two numbers.
88      */
89     function min(uint256 a, uint256 b) internal pure returns (uint256) {
90         return a < b ? a : b;
91     }
92 
93     /**
94      * @dev Returns the average of two numbers. The result is rounded towards
95      * zero.
96      */
97     function average(uint256 a, uint256 b) internal pure returns (uint256) {
98         // (a + b) / 2 can overflow, so we distribute
99         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
100     }
101 }
102 
103 // File: localhost/helpers/IWETH.sol
104 
105 /*
106   Copyright 2020 Unit Protocol: Artem Zakharov (az@unit.xyz).
107 */
108 pragma solidity ^0.7.1;
109 
110 
111 interface IWETH {
112     function deposit() external payable;
113     function transfer(address to, uint value) external returns (bool);
114     function withdraw(uint) external;
115 }
116 
117 // File: localhost/VaultParameters.sol
118 
119 
120 
121 /*
122   Copyright 2020 Unit Protocol: Artem Zakharov (az@unit.xyz).
123 */
124 pragma solidity ^0.7.1;
125 
126 
127 /**
128  * @title Auth
129  * @dev Manages USDP's system access
130  **/
131 contract Auth {
132 
133     // address of the the contract with vault parameters
134     VaultParameters public vaultParameters;
135 
136     constructor(address _parameters) public {
137         vaultParameters = VaultParameters(_parameters);
138     }
139 
140     // ensures tx's sender is a manager
141     modifier onlyManager() {
142         require(vaultParameters.isManager(msg.sender), "Unit Protocol: AUTH_FAILED");
143         _;
144     }
145 
146     // ensures tx's sender is able to modify the Vault
147     modifier hasVaultAccess() {
148         require(vaultParameters.canModifyVault(msg.sender), "Unit Protocol: AUTH_FAILED");
149         _;
150     }
151 
152     // ensures tx's sender is the Vault
153     modifier onlyVault() {
154         require(msg.sender == vaultParameters.vault(), "Unit Protocol: AUTH_FAILED");
155         _;
156     }
157 }
158 
159 // File: localhost/USDP.sol
160 
161 
162 
163 /*
164   Copyright 2020 Unit Protocol: Artem Zakharov (az@unit.xyz).
165 */
166 pragma solidity ^0.7.1;
167 
168 
169 
170 
171 /**
172  * @title USDP token implementation
173  * @dev ERC20 token
174  **/
175 contract USDP is Auth {
176     using SafeMath for uint;
177 
178     // name of the token
179     string public constant name = "USDP Stablecoin";
180 
181     // symbol of the token
182     string public constant symbol = "USDP";
183 
184     // version of the token
185     string public constant version = "1";
186 
187     // number of decimals the token uses
188     uint8 public constant decimals = 18;
189 
190     // total token supply
191     uint public totalSupply;
192 
193     // balance information map
194     mapping(address => uint) public balanceOf;
195 
196     // token allowance mapping
197     mapping(address => mapping(address => uint)) public allowance;
198 
199     /**
200      * @dev Trigger on any successful call to approve(address spender, uint amount)
201     **/
202     event Approval(address indexed owner, address indexed spender, uint value);
203 
204     /**
205      * @dev Trigger when tokens are transferred, including zero value transfers
206     **/
207     event Transfer(address indexed from, address indexed to, uint value);
208 
209     /**
210       * @param _parameters The address of system parameters contract
211      **/
212     constructor(address _parameters) public Auth(_parameters) {}
213 
214     /**
215       * @notice Only Vault can mint USDP
216       * @dev Mints 'amount' of tokens to address 'to', and MUST fire the
217       * Transfer event
218       * @param to The address of the recipient
219       * @param amount The amount of token to be minted
220      **/
221     function mint(address to, uint amount) external onlyVault {
222         require(to != address(0), "Unit Protocol: ZERO_ADDRESS");
223 
224         balanceOf[to] = balanceOf[to].add(amount);
225         totalSupply = totalSupply.add(amount);
226 
227         emit Transfer(address(0), to, amount);
228     }
229 
230     /**
231       * @notice Only manager can burn tokens from manager's balance
232       * @dev Burns 'amount' of tokens, and MUST fire the Transfer event
233       * @param amount The amount of token to be burned
234      **/
235     function burn(uint amount) external onlyManager {
236         _burn(msg.sender, amount);
237     }
238 
239     /**
240       * @notice Only Vault can burn tokens from any balance
241       * @dev Burns 'amount' of tokens from 'from' address, and MUST fire the Transfer event
242       * @param from The address of the balance owner
243       * @param amount The amount of token to be burned
244      **/
245     function burn(address from, uint amount) external onlyVault {
246         _burn(from, amount);
247     }
248 
249     /**
250       * @dev Transfers 'amount' of tokens to address 'to', and MUST fire the Transfer event. The
251       * function SHOULD throw if the _from account balance does not have enough tokens to spend.
252       * @param to The address of the recipient
253       * @param amount The amount of token to be transferred
254      **/
255     function transfer(address to, uint amount) external returns (bool) {
256         return transferFrom(msg.sender, to, amount);
257     }
258 
259     /**
260       * @dev Transfers 'amount' of tokens from address 'from' to address 'to', and MUST fire the
261       * Transfer event
262       * @param from The address of the sender
263       * @param to The address of the recipient
264       * @param amount The amount of token to be transferred
265      **/
266     function transferFrom(address from, address to, uint amount) public returns (bool) {
267         require(to != address(0), "Unit Protocol: ZERO_ADDRESS");
268         require(balanceOf[from] >= amount, "Unit Protocol: INSUFFICIENT_BALANCE");
269 
270         if (from != msg.sender) {
271             require(allowance[from][msg.sender] >= amount, "Unit Protocol: INSUFFICIENT_ALLOWANCE");
272             _approve(from, msg.sender, allowance[from][msg.sender].sub(amount));
273         }
274         balanceOf[from] = balanceOf[from].sub(amount);
275         balanceOf[to] = balanceOf[to].add(amount);
276 
277         emit Transfer(from, to, amount);
278         return true;
279     }
280 
281     /**
282       * @dev Allows 'spender' to withdraw from your account multiple times, up to the 'amount' amount. If
283       * this function is called again it overwrites the current allowance with 'amount'.
284       * @param spender The address of the account able to transfer the tokens
285       * @param amount The amount of tokens to be approved for transfer
286      **/
287     function approve(address spender, uint amount) external returns (bool) {
288         _approve(msg.sender, spender, amount);
289         return true;
290     }
291 
292     /**
293      * @dev Atomically increases the allowance granted to `spender` by the caller.
294      *
295      * This is an alternative to `approve` that can be used as a mitigation for
296      * problems described in `IERC20.approve`.
297      *
298      * Emits an `Approval` event indicating the updated allowance.
299      *
300      * Requirements:
301      *
302      * - `spender` cannot be the zero address.
303      */
304     function increaseAllowance(address spender, uint addedValue) public virtual returns (bool) {
305         _approve(msg.sender, spender, allowance[msg.sender][spender].add(addedValue));
306         return true;
307     }
308 
309     /**
310      * @dev Atomically decreases the allowance granted to `spender` by the caller.
311      *
312      * This is an alternative to `approve` that can be used as a mitigation for
313      * problems described in `IERC20.approve`.
314      *
315      * Emits an `Approval` event indicating the updated allowance.
316      *
317      * Requirements:
318      *
319      * - `spender` cannot be the zero address.
320      * - `spender` must have allowance for the caller of at least
321      * `subtractedValue`.
322      */
323     function decreaseAllowance(address spender, uint subtractedValue) public virtual returns (bool) {
324         _approve(msg.sender, spender, allowance[msg.sender][spender].sub(subtractedValue));
325         return true;
326     }
327 
328     function _approve(address owner, address spender, uint amount) internal virtual {
329         require(owner != address(0), "Unit Protocol: approve from the zero address");
330         require(spender != address(0), "Unit Protocol: approve to the zero address");
331 
332         allowance[owner][spender] = amount;
333         emit Approval(owner, spender, amount);
334     }
335 
336     function _burn(address from, uint amount) internal virtual {
337         balanceOf[from] = balanceOf[from].sub(amount);
338         totalSupply = totalSupply.sub(amount);
339 
340         emit Transfer(from, address(0), amount);
341     }
342 }
343 
344 // File: localhost/helpers/TransferHelper.sol
345 
346 /*
347   Copyright 2020 Unit Protocol: Artem Zakharov (az@unit.xyz).
348 */
349 pragma solidity ^0.7.1;
350 
351 // helper methods for interacting with ERC20 tokens and sending ETH that do not consistently return true/false
352 library TransferHelper {
353     function safeApprove(address token, address to, uint value) internal {
354         // bytes4(keccak256(bytes('approve(address,uint256)')));
355         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x095ea7b3, to, value));
356         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: APPROVE_FAILED');
357     }
358 
359     function safeTransfer(address token, address to, uint value) internal {
360         // bytes4(keccak256(bytes('transfer(address,uint256)')));
361         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0xa9059cbb, to, value));
362         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FAILED');
363     }
364 
365     function safeTransferFrom(address token, address from, address to, uint value) internal {
366         // bytes4(keccak256(bytes('transferFrom(address,address,uint256)')));
367         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x23b872dd, from, to, value));
368         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FROM_FAILED');
369     }
370 
371     function safeTransferETH(address to, uint value) internal {
372         (bool success,) = to.call{value:value}(new bytes(0));
373         require(success, 'TransferHelper: ETH_TRANSFER_FAILED');
374     }
375 }
376 
377 
378 /**
379  * @title VaultParameters
380  **/
381 contract VaultParameters is Auth {
382 
383     // map token to stability fee percentage; 3 decimals
384     mapping(address => uint) public stabilityFee;
385 
386     // map token to liquidation fee percentage, 0 decimals
387     mapping(address => uint) public liquidationFee;
388 
389     // map token to USDP mint limit
390     mapping(address => uint) public tokenDebtLimit;
391 
392     // permissions to modify the Vault
393     mapping(address => bool) public canModifyVault;
394 
395     // managers
396     mapping(address => bool) public isManager;
397 
398     // enabled oracle types
399     mapping(uint => mapping (address => bool)) public isOracleTypeEnabled;
400 
401     // address of the Vault
402     address payable public vault;
403 
404     // The foundation address
405     address public foundation;
406 
407     /**
408      * The address for an Ethereum contract is deterministically computed from the address of its creator (sender)
409      * and how many transactions the creator has sent (nonce). The sender and nonce are RLP encoded and then
410      * hashed with Keccak-256.
411      * Therefore, the Vault address can be pre-computed and passed as an argument before deployment.
412     **/
413     constructor(address payable _vault, address _foundation) public Auth(address(this)) {
414         require(_vault != address(0), "Unit Protocol: ZERO_ADDRESS");
415         require(_foundation != address(0), "Unit Protocol: ZERO_ADDRESS");
416 
417         isManager[msg.sender] = true;
418         vault = _vault;
419         foundation = _foundation;
420     }
421 
422     /**
423      * @notice Only manager is able to call this function
424      * @dev Grants and revokes manager's status of any address
425      * @param who The target address
426      * @param permit The permission flag
427      **/
428     function setManager(address who, bool permit) external onlyManager {
429         isManager[who] = permit;
430     }
431 
432     /**
433      * @notice Only manager is able to call this function
434      * @dev Sets the foundation address
435      * @param newFoundation The new foundation address
436      **/
437     function setFoundation(address newFoundation) external onlyManager {
438         require(newFoundation != address(0), "Unit Protocol: ZERO_ADDRESS");
439         foundation = newFoundation;
440     }
441 
442     /**
443      * @notice Only manager is able to call this function
444      * @dev Sets ability to use token as the main collateral
445      * @param asset The address of the main collateral token
446      * @param stabilityFeeValue The percentage of the year stability fee (3 decimals)
447      * @param liquidationFeeValue The liquidation fee percentage (0 decimals)
448      * @param usdpLimit The USDP token issue limit
449      * @param oracles The enables oracle types
450      **/
451     function setCollateral(
452         address asset,
453         uint stabilityFeeValue,
454         uint liquidationFeeValue,
455         uint usdpLimit,
456         uint[] calldata oracles
457     ) external onlyManager {
458         setStabilityFee(asset, stabilityFeeValue);
459         setLiquidationFee(asset, liquidationFeeValue);
460         setTokenDebtLimit(asset, usdpLimit);
461         for (uint i=0; i < oracles.length; i++) {
462             setOracleType(oracles[i], asset, true);
463         }
464     }
465 
466     /**
467      * @notice Only manager is able to call this function
468      * @dev Sets a permission for an address to modify the Vault
469      * @param who The target address
470      * @param permit The permission flag
471      **/
472     function setVaultAccess(address who, bool permit) external onlyManager {
473         canModifyVault[who] = permit;
474     }
475 
476     /**
477      * @notice Only manager is able to call this function
478      * @dev Sets the percentage of the year stability fee for a particular collateral
479      * @param asset The address of the main collateral token
480      * @param newValue The stability fee percentage (3 decimals)
481      **/
482     function setStabilityFee(address asset, uint newValue) public onlyManager {
483         stabilityFee[asset] = newValue;
484     }
485 
486     /**
487      * @notice Only manager is able to call this function
488      * @dev Sets the percentage of the liquidation fee for a particular collateral
489      * @param asset The address of the main collateral token
490      * @param newValue The liquidation fee percentage (0 decimals)
491      **/
492     function setLiquidationFee(address asset, uint newValue) public onlyManager {
493         require(newValue <= 100, "Unit Protocol: VALUE_OUT_OF_RANGE");
494         liquidationFee[asset] = newValue;
495     }
496 
497     /**
498      * @notice Only manager is able to call this function
499      * @dev Enables/disables oracle types
500      * @param _type The type of the oracle
501      * @param asset The address of the main collateral token
502      * @param enabled The control flag
503      **/
504     function setOracleType(uint _type, address asset, bool enabled) public onlyManager {
505         isOracleTypeEnabled[_type][asset] = enabled;
506     }
507 
508     /**
509      * @notice Only manager is able to call this function
510      * @dev Sets USDP limit for a specific collateral
511      * @param asset The address of the main collateral token
512      * @param limit The limit number
513      **/
514     function setTokenDebtLimit(address asset, uint limit) public onlyManager {
515         tokenDebtLimit[asset] = limit;
516     }
517 }
518 
519 // File: localhost/helpers/SafeMath.sol
520 
521 
522 
523 /*
524   Copyright 2020 Unit Protocol: Artem Zakharov (az@unit.xyz).
525 */
526 pragma solidity ^0.7.1;
527 
528 
529 /**
530  * @title SafeMath
531  * @dev Math operations with safety checks that throw on error
532  */
533 library SafeMath {
534 
535     /**
536     * @dev Multiplies two numbers, throws on overflow.
537     */
538     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
539         if (a == 0) {
540             return 0;
541         }
542         c = a * b;
543         assert(c / a == b);
544         return c;
545     }
546 
547     /**
548     * @dev Integer division of two numbers, truncating the quotient.
549     */
550     function div(uint256 a, uint256 b) internal pure returns (uint256) {
551         require(b != 0, "SafeMath: division by zero");
552         return a / b;
553     }
554 
555     /**
556     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
557     */
558     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
559         assert(b <= a);
560         return a - b;
561     }
562 
563     /**
564     * @dev Adds two numbers, throws on overflow.
565     */
566     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
567         c = a + b;
568         assert(c >= a);
569         return c;
570     }
571 }
572 
573 // File: localhost/Vault.sol
574 
575 
576 
577 /*
578   Copyright 2020 Unit Protocol: Artem Zakharov (az@unit.xyz).
579 */
580 pragma solidity ^0.7.1;
581 
582 
583 
584 
585 
586 
587 
588 /**
589  * @title Vault
590  * @notice Vault is the core of Unit Protocol USDP Stablecoin system
591  * @notice Vault stores and manages collateral funds of all positions and counts debts
592  * @notice Only Vault can manage supply of USDP token
593  * @notice Vault will not be changed/upgraded after initial deployment for the current stablecoin version
594  **/
595 contract Vault is Auth {
596     using SafeMath for uint;
597 
598     // COL token address
599     address public immutable col;
600 
601     // WETH token address
602     address payable public immutable weth;
603 
604     uint public constant DENOMINATOR_1E5 = 1e5;
605 
606     uint public constant DENOMINATOR_1E2 = 1e2;
607 
608     // USDP token address
609     address public immutable usdp;
610 
611     // collaterals whitelist
612     mapping(address => mapping(address => uint)) public collaterals;
613 
614     // COL token collaterals
615     mapping(address => mapping(address => uint)) public colToken;
616 
617     // user debts
618     mapping(address => mapping(address => uint)) public debts;
619 
620     // block number of liquidation trigger
621     mapping(address => mapping(address => uint)) public liquidationBlock;
622 
623     // initial price of collateral
624     mapping(address => mapping(address => uint)) public liquidationPrice;
625 
626     // debts of tokens
627     mapping(address => uint) public tokenDebts;
628 
629     // stability fee pinned to each position
630     mapping(address => mapping(address => uint)) public stabilityFee;
631 
632     // liquidation fee pinned to each position, 0 decimals
633     mapping(address => mapping(address => uint)) public liquidationFee;
634 
635     // type of using oracle pinned for each position
636     mapping(address => mapping(address => uint)) public oracleType;
637 
638     // timestamp of the last update
639     mapping(address => mapping(address => uint)) public lastUpdate;
640 
641     modifier notLiquidating(address asset, address user) {
642         require(liquidationBlock[asset][user] == 0, "Unit Protocol: LIQUIDATING_POSITION");
643         _;
644     }
645 
646     /**
647      * @param _parameters The address of the system parameters
648      * @param _col COL token address
649      * @param _usdp USDP token address
650      **/
651     constructor(address _parameters, address _col, address _usdp, address payable _weth) public Auth(_parameters) {
652         col = _col;
653         usdp = _usdp;
654         weth = _weth;
655     }
656 
657     // only accept ETH via fallback from the WETH contract
658     receive() external payable {
659         require(msg.sender == weth, "Unit Protocol: RESTRICTED");
660     }
661 
662     /**
663      * @dev Updates parameters of the position to the current ones
664      * @param asset The address of the main collateral token
665      * @param user The owner of a position
666      **/
667     function update(address asset, address user) public hasVaultAccess notLiquidating(asset, user) {
668 
669         // calculate fee using stored stability fee
670         uint debtWithFee = getTotalDebt(asset, user);
671         tokenDebts[asset] = tokenDebts[asset].sub(debts[asset][user]).add(debtWithFee);
672         debts[asset][user] = debtWithFee;
673 
674         stabilityFee[asset][user] = vaultParameters.stabilityFee(asset);
675         liquidationFee[asset][user] = vaultParameters.liquidationFee(asset);
676         lastUpdate[asset][user] = block.timestamp;
677     }
678 
679     /**
680      * @dev Creates new position for user
681      * @param asset The address of the main collateral token
682      * @param user The address of a position's owner
683      * @param _oracleType The type of an oracle
684      **/
685     function spawn(address asset, address user, uint _oracleType) external hasVaultAccess notLiquidating(asset, user) {
686         oracleType[asset][user] = _oracleType;
687         delete liquidationBlock[asset][user];
688     }
689 
690     /**
691      * @dev Clears unused storage variables
692      * @param asset The address of the main collateral token
693      * @param user The address of a position's owner
694      **/
695     function destroy(address asset, address user) public hasVaultAccess notLiquidating(asset, user) {
696         delete stabilityFee[asset][user];
697         delete oracleType[asset][user];
698         delete lastUpdate[asset][user];
699         delete liquidationFee[asset][user];
700     }
701 
702     /**
703      * @notice Tokens must be pre-approved
704      * @dev Adds main collateral to a position
705      * @param asset The address of the main collateral token
706      * @param user The address of a position's owner
707      * @param amount The amount of tokens to deposit
708      **/
709     function depositMain(address asset, address user, uint amount) external hasVaultAccess notLiquidating(asset, user) {
710         collaterals[asset][user] = collaterals[asset][user].add(amount);
711         TransferHelper.safeTransferFrom(asset, user, address(this), amount);
712     }
713 
714     /**
715      * @dev Converts ETH to WETH and adds main collateral to a position
716      * @param user The address of a position's owner
717      **/
718     function depositEth(address user) external payable notLiquidating(weth, user) {
719         IWETH(weth).deposit{value: msg.value}();
720         collaterals[weth][user] = collaterals[weth][user].add(msg.value);
721     }
722 
723     /**
724      * @dev Withdraws main collateral from a position
725      * @param asset The address of the main collateral token
726      * @param user The address of a position's owner
727      * @param amount The amount of tokens to withdraw
728      **/
729     function withdrawMain(address asset, address user, uint amount) external hasVaultAccess notLiquidating(asset, user) {
730         collaterals[asset][user] = collaterals[asset][user].sub(amount);
731         TransferHelper.safeTransfer(asset, user, amount);
732     }
733 
734     /**
735      * @dev Withdraws WETH collateral from a position converting WETH to ETH
736      * @param user The address of a position's owner
737      * @param amount The amount of ETH to withdraw
738      **/
739     function withdrawEth(address payable user, uint amount) external hasVaultAccess notLiquidating(weth, user) {
740         collaterals[weth][user] = collaterals[weth][user].sub(amount);
741         IWETH(weth).withdraw(amount);
742         TransferHelper.safeTransferETH(user, amount);
743     }
744 
745     /**
746      * @notice Tokens must be pre-approved
747      * @dev Adds COL token to a position
748      * @param asset The address of the main collateral token
749      * @param user The address of a position's owner
750      * @param amount The amount of tokens to deposit
751      **/
752     function depositCol(address asset, address user, uint amount) external hasVaultAccess notLiquidating(asset, user) {
753         colToken[asset][user] = colToken[asset][user].add(amount);
754         TransferHelper.safeTransferFrom(col, user, address(this), amount);
755     }
756 
757     /**
758      * @dev Withdraws COL token from a position
759      * @param asset The address of the main collateral token
760      * @param user The address of a position's owner
761      * @param amount The amount of tokens to withdraw
762      **/
763     function withdrawCol(address asset, address user, uint amount) external hasVaultAccess notLiquidating(asset, user) {
764         colToken[asset][user] = colToken[asset][user].sub(amount);
765         TransferHelper.safeTransfer(col, user, amount);
766     }
767 
768     /**
769      * @dev Increases position's debt and mints USDP token
770      * @param asset The address of the main collateral token
771      * @param user The address of a position's owner
772      * @param amount The amount of USDP to borrow
773      **/
774     function borrow(
775         address asset,
776         address user,
777         uint amount
778     )
779     external
780     hasVaultAccess
781     notLiquidating(asset, user)
782     returns(uint)
783     {
784         require(vaultParameters.isOracleTypeEnabled(oracleType[asset][user], asset), "Unit Protocol: WRONG_ORACLE_TYPE");
785         update(asset, user);
786         debts[asset][user] = debts[asset][user].add(amount);
787         tokenDebts[asset] = tokenDebts[asset].add(amount);
788 
789         // check USDP limit for token
790         require(tokenDebts[asset] <= vaultParameters.tokenDebtLimit(asset), "Unit Protocol: ASSET_DEBT_LIMIT");
791 
792         USDP(usdp).mint(user, amount);
793 
794         return debts[asset][user];
795     }
796 
797     /**
798      * @dev Decreases position's debt and burns USDP token
799      * @param asset The address of the main collateral token
800      * @param user The address of a position's owner
801      * @param amount The amount of USDP to repay
802      * @return updated debt of a position
803      **/
804     function repay(
805         address asset,
806         address user,
807         uint amount
808     )
809     external
810     hasVaultAccess
811     notLiquidating(asset, user)
812     returns(uint)
813     {
814         uint debt = debts[asset][user];
815         debts[asset][user] = debt.sub(amount);
816         tokenDebts[asset] = tokenDebts[asset].sub(amount);
817         USDP(usdp).burn(user, amount);
818 
819         return debts[asset][user];
820     }
821 
822     /**
823      * @dev Transfers fee to foundation
824      * @param asset The address of the fee asset
825      * @param user The address to transfer funds from
826      * @param amount The amount of asset to transfer
827      **/
828     function chargeFee(address asset, address user, uint amount) external hasVaultAccess notLiquidating(asset, user) {
829         if (amount != 0) {
830             TransferHelper.safeTransferFrom(asset, user, vaultParameters.foundation(), amount);
831         }
832     }
833 
834     /**
835      * @dev Deletes position and transfers collateral to liquidation system
836      * @param asset The address of the main collateral token
837      * @param positionOwner The address of a position's owner
838      * @param initialPrice The starting price of collateral in USDP
839      **/
840     function triggerLiquidation(
841         address asset,
842         address positionOwner,
843         uint initialPrice
844     )
845     external
846     hasVaultAccess
847     notLiquidating(asset, positionOwner)
848     {
849         // reverts if oracle type is disabled
850         require(vaultParameters.isOracleTypeEnabled(oracleType[asset][positionOwner], asset), "Unit Protocol: WRONG_ORACLE_TYPE");
851 
852         // fix the debt
853         debts[asset][positionOwner] = getTotalDebt(asset, positionOwner);
854 
855         liquidationBlock[asset][positionOwner] = block.number;
856         liquidationPrice[asset][positionOwner] = initialPrice;
857     }
858 
859     /**
860      * @dev Internal liquidation process
861      * @param asset The address of the main collateral token
862      * @param positionOwner The address of a position's owner
863      * @param mainAssetToLiquidator The amount of main asset to send to a liquidator
864      * @param colToLiquidator The amount of COL to send to a liquidator
865      * @param mainAssetToPositionOwner The amount of main asset to send to a position owner
866      * @param colToPositionOwner The amount of COL to send to a position owner
867      * @param repayment The repayment in USDP
868      * @param penalty The liquidation penalty in USDP
869      * @param liquidator The address of a liquidator
870      **/
871     function liquidate(
872         address asset,
873         address positionOwner,
874         uint mainAssetToLiquidator,
875         uint colToLiquidator,
876         uint mainAssetToPositionOwner,
877         uint colToPositionOwner,
878         uint repayment,
879         uint penalty,
880         address liquidator
881     )
882         external
883         hasVaultAccess
884     {
885         require(liquidationBlock[asset][positionOwner] != 0, "Unit Protocol: NOT_TRIGGERED_LIQUIDATION");
886 
887         uint mainAssetInPosition = collaterals[asset][positionOwner];
888         uint mainAssetToFoundation = mainAssetInPosition.sub(mainAssetToLiquidator).sub(mainAssetToPositionOwner);
889 
890         uint colInPosition = colToken[asset][positionOwner];
891         uint colToFoundation = colInPosition.sub(colToLiquidator).sub(colToPositionOwner);
892 
893         delete liquidationPrice[asset][positionOwner];
894         delete liquidationBlock[asset][positionOwner];
895         delete debts[asset][positionOwner];
896         delete collaterals[asset][positionOwner];
897         delete colToken[asset][positionOwner];
898 
899         destroy(asset, positionOwner);
900 
901         // charge liquidation fee and burn USDP
902         if (repayment > penalty) {
903             if (penalty != 0) {
904                 TransferHelper.safeTransferFrom(usdp, liquidator, vaultParameters.foundation(), penalty);
905             }
906             USDP(usdp).burn(liquidator, repayment.sub(penalty));
907         } else {
908             if (repayment != 0) {
909                 TransferHelper.safeTransferFrom(usdp, liquidator, vaultParameters.foundation(), repayment);
910             }
911         }
912 
913         // send the part of collateral to a liquidator
914         if (mainAssetToLiquidator != 0) {
915             TransferHelper.safeTransfer(asset, liquidator, mainAssetToLiquidator);
916         }
917 
918         if (colToLiquidator != 0) {
919             TransferHelper.safeTransfer(col, liquidator, colToLiquidator);
920         }
921 
922         // send the rest of collateral to a position owner
923         if (mainAssetToPositionOwner != 0) {
924             TransferHelper.safeTransfer(asset, positionOwner, mainAssetToPositionOwner);
925         }
926 
927         if (colToPositionOwner != 0) {
928             TransferHelper.safeTransfer(col, positionOwner, colToPositionOwner);
929         }
930 
931         if (mainAssetToFoundation != 0) {
932             TransferHelper.safeTransfer(asset, vaultParameters.foundation(), mainAssetToFoundation);
933         }
934 
935         if (colToFoundation != 0) {
936             TransferHelper.safeTransfer(col, vaultParameters.foundation(), colToFoundation);
937         }
938     }
939 
940     /**
941      * @notice Only manager can call this function
942      * @dev Changes broken oracle type to the correct one
943      * @param asset The address of the main collateral token
944      * @param user The address of a position's owner
945      * @param newOracleType The new type of an oracle
946      **/
947     function changeOracleType(address asset, address user, uint newOracleType) external onlyManager {
948         oracleType[asset][user] = newOracleType;
949     }
950 
951     /**
952      * @dev Calculates the total amount of position's debt based on elapsed time
953      * @param asset The address of the main collateral token
954      * @param user The address of a position's owner
955      * @return user debt of a position plus accumulated fee
956      **/
957     function getTotalDebt(address asset, address user) public view returns (uint) {
958         uint debt = debts[asset][user];
959         if (liquidationBlock[asset][user] != 0) return debt;
960         uint fee = calculateFee(asset, user, debt);
961         return debt.add(fee);
962     }
963 
964     /**
965      * @dev Calculates the amount of fee based on elapsed time and repayment amount
966      * @param asset The address of the main collateral token
967      * @param user The address of a position's owner
968      * @param amount The repayment amount
969      * @return fee amount
970      **/
971     function calculateFee(address asset, address user, uint amount) public view returns (uint) {
972         uint sFeePercent = stabilityFee[asset][user];
973         uint timePast = block.timestamp.sub(lastUpdate[asset][user]);
974 
975         return amount.mul(sFeePercent).mul(timePast).div(365 days).div(DENOMINATOR_1E5);
976     }
977 }
978 
979 // File: localhost/vault-managers/VaultManagerStandard.sol
980 
981 
982 
983 /*
984   Copyright 2020 Unit Protocol: Artem Zakharov (az@unit.xyz).
985 */
986 pragma solidity ^0.7.1;
987 pragma experimental ABIEncoderV2;
988 
989 
990 
991 
992 
993 /**
994  * @title VaultManagerStandard
995  **/
996 contract VaultManagerStandard is ReentrancyGuard {
997     using SafeMath for uint;
998 
999     Vault public immutable vault;
1000 
1001     /**
1002      * @dev Trigger when params joins are happened
1003     **/
1004     event Join(address indexed asset, address indexed user, uint main, uint usdp);
1005 
1006     /**
1007      * @dev Trigger when params exits are happened
1008     **/
1009     event Exit(address indexed asset, address indexed user, uint main, uint usdp);
1010 
1011     /**
1012      * @param _vault The address of the Vault
1013      **/
1014     constructor(address payable _vault) public {
1015         vault = Vault(_vault);
1016     }
1017 
1018     /**
1019      * @notice Depositing token must be pre-approved to vault address
1020      * @notice Token using as main collateral must be whitelisted
1021      * @dev Deposits collaterals
1022      * @param asset The address of token using as main collateral
1023      * @param mainAmount The amount of main collateral to deposit
1024      **/
1025     function deposit(address asset, uint mainAmount) public nonReentrant {
1026 
1027         // check usefulness of tx
1028         require(mainAmount != 0, "Unit Protocol: USELESS_TX");
1029 
1030         vault.depositMain(asset, msg.sender, mainAmount);
1031 
1032         // fire an event
1033         emit Join(asset, msg.sender, mainAmount, 0);
1034     }
1035 
1036     /**
1037      * @notice Token using as main collateral must be whitelisted
1038      * @dev Deposits collaterals converting ETH to WETH
1039      **/
1040     function deposit_Eth() public payable nonReentrant {
1041 
1042         // check usefulness of tx
1043         require(msg.value != 0, "Unit Protocol: USELESS_TX");
1044 
1045         vault.depositEth{value: msg.value}(msg.sender);
1046 
1047         // fire an event
1048         emit Join(vault.weth(), msg.sender, msg.value, 0);
1049     }
1050 
1051     /**
1052       * @notice Tx sender must have a sufficient USDP balance to pay the debt
1053       * @dev Repays specified amount of debt
1054       * @param asset The address of token using as main collateral
1055       * @param usdpAmount The amount of USDP token to repay
1056       **/
1057     function repay(address asset, uint usdpAmount) public nonReentrant {
1058 
1059         // check usefulness of tx
1060         require(usdpAmount != 0, "Unit Protocol: USELESS_TX");
1061 
1062         _repay(asset, msg.sender, usdpAmount);
1063 
1064         // fire an event
1065         emit Exit(asset, msg.sender, 0, usdpAmount);
1066     }
1067 
1068     /**
1069       * @notice Tx sender must have a sufficient USDP balance to pay the debt
1070       * @notice USDP approval is NOT needed
1071       * @dev Repays total debt and withdraws collaterals
1072       * @param asset The address of token using as main collateral
1073       * @param mainAmount The amount of main collateral token to withdraw
1074       **/
1075     function repayAllAndWithdraw(
1076         address asset,
1077         uint mainAmount
1078     )
1079     external
1080     nonReentrant
1081     {
1082         uint debtAmount = vault.debts(asset, msg.sender);
1083 
1084         if (mainAmount != 0) {
1085             // withdraw main collateral to the user address
1086             vault.withdrawMain(asset, msg.sender, mainAmount);
1087         }
1088 
1089         if (debtAmount != 0) {
1090             // burn USDP from the user's address
1091             _repay(asset, msg.sender, debtAmount);
1092         }
1093 
1094         // fire an event
1095         emit Exit(asset, msg.sender, mainAmount, debtAmount);
1096     }
1097 
1098     /**
1099       * @notice Tx sender must have a sufficient USDP balance to pay the debt
1100       * @notice USDP approval is NOT needed
1101       * @dev Repays total debt and withdraws collaterals
1102       * @param ethAmount The ETH amount to withdraw
1103       **/
1104     function repayAllAndWithdraw_Eth(
1105         uint ethAmount
1106     )
1107     external
1108     nonReentrant
1109     {
1110         uint debtAmount = vault.debts(vault.weth(), msg.sender);
1111 
1112         if (ethAmount != 0) {
1113             // withdraw ETH to the user address
1114             vault.withdrawEth(msg.sender, ethAmount);
1115         }
1116 
1117         if (debtAmount != 0) {
1118             // burn USDP from the user's address
1119             _repay(vault.weth(), msg.sender, debtAmount);
1120         }
1121 
1122         // fire an event
1123         emit Exit(vault.weth(), msg.sender, ethAmount, debtAmount);
1124     }
1125 
1126     // decreases debt
1127     function _repay(address asset, address user, uint usdpAmount) internal {
1128         uint fee = vault.calculateFee(asset, user, usdpAmount);
1129         vault.chargeFee(vault.usdp(), user, fee);
1130 
1131         // burn USDP from the user's balance
1132         uint debtAfter = vault.repay(asset, user, usdpAmount);
1133         if (debtAfter == 0) {
1134             // clear unused storage
1135             vault.destroy(asset, user);
1136         }
1137     }
1138 }