1 // File: contracts/helpers/SafeMath.sol
2 
3 // SPDX-License-Identifier: bsl-1.1
4 
5 /*
6   Copyright 2020 Unit Protocol: Artem Zakharov (az@unit.xyz).
7 */
8 pragma solidity ^0.7.1;
9 
10 
11 /**
12  * @title SafeMath
13  * @dev Math operations with safety checks that throw on error
14  */
15 library SafeMath {
16 
17     /**
18     * @dev Multiplies two numbers, throws on overflow.
19     */
20     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
21         if (a == 0) {
22             return 0;
23         }
24         c = a * b;
25         assert(c / a == b);
26         return c;
27     }
28 
29     /**
30     * @dev Integer division of two numbers, truncating the quotient.
31     */
32     function div(uint256 a, uint256 b) internal pure returns (uint256) {
33         require(b != 0, "SafeMath: division by zero");
34         return a / b;
35     }
36 
37     /**
38     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
39     */
40     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
41         assert(b <= a);
42         return a - b;
43     }
44 
45     /**
46     * @dev Adds two numbers, throws on overflow.
47     */
48     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
49         c = a + b;
50         assert(c >= a);
51         return c;
52     }
53 }
54 
55 // File: contracts/VaultParameters.sol
56 
57 /*
58   Copyright 2020 Unit Protocol: Artem Zakharov (az@unit.xyz).
59 */
60 pragma solidity ^0.7.1;
61 
62 
63 /**
64  * @title Auth
65  * @author Unit Protocol: Artem Zakharov (az@unit.xyz), Alexander Ponomorev (@bcngod)
66  * @dev Manages USDP's system access
67  **/
68 contract Auth {
69 
70     // address of the the contract with vault parameters
71     VaultParameters public vaultParameters;
72 
73     constructor(address _parameters) public {
74         vaultParameters = VaultParameters(_parameters);
75     }
76 
77     // ensures tx's sender is a manager
78     modifier onlyManager() {
79         require(vaultParameters.isManager(msg.sender), "Unit Protocol: AUTH_FAILED");
80         _;
81     }
82 
83     // ensures tx's sender is able to modify the Vault
84     modifier hasVaultAccess() {
85         require(vaultParameters.canModifyVault(msg.sender), "Unit Protocol: AUTH_FAILED");
86         _;
87     }
88 
89     // ensures tx's sender is the Vault
90     modifier onlyVault() {
91         require(msg.sender == vaultParameters.vault(), "Unit Protocol: AUTH_FAILED");
92         _;
93     }
94 }
95 
96 
97 /**
98  * @title VaultParameters
99  * @author Unit Protocol: Artem Zakharov (az@unit.xyz), Alexander Ponomorev (@bcngod)
100  **/
101 contract VaultParameters is Auth {
102 
103     // map token to stability fee percentage; 3 decimals
104     mapping(address => uint) public stabilityFee;
105 
106     // map token to liquidation fee percentage, 0 decimals
107     mapping(address => uint) public liquidationFee;
108 
109     // map token to USDP mint limit
110     mapping(address => uint) public tokenDebtLimit;
111 
112     // permissions to modify the Vault
113     mapping(address => bool) public canModifyVault;
114 
115     // managers
116     mapping(address => bool) public isManager;
117 
118     // enabled oracle types
119     mapping(uint => mapping (address => bool)) public isOracleTypeEnabled;
120 
121     // address of the Vault
122     address payable public vault;
123 
124     // The foundation address
125     address public foundation;
126 
127     /**
128      * The address for an Ethereum contract is deterministically computed from the address of its creator (sender)
129      * and how many transactions the creator has sent (nonce). The sender and nonce are RLP encoded and then
130      * hashed with Keccak-256.
131      * Therefore, the Vault address can be pre-computed and passed as an argument before deployment.
132     **/
133     constructor(address payable _vault, address _foundation) public Auth(address(this)) {
134         require(_vault != address(0), "Unit Protocol: ZERO_ADDRESS");
135         require(_foundation != address(0), "Unit Protocol: ZERO_ADDRESS");
136 
137         isManager[msg.sender] = true;
138         vault = _vault;
139         foundation = _foundation;
140     }
141 
142     /**
143      * @notice Only manager is able to call this function
144      * @dev Grants and revokes manager's status of any address
145      * @param who The target address
146      * @param permit The permission flag
147      **/
148     function setManager(address who, bool permit) external onlyManager {
149         isManager[who] = permit;
150     }
151 
152     /**
153      * @notice Only manager is able to call this function
154      * @dev Sets the foundation address
155      * @param newFoundation The new foundation address
156      **/
157     function setFoundation(address newFoundation) external onlyManager {
158         require(newFoundation != address(0), "Unit Protocol: ZERO_ADDRESS");
159         foundation = newFoundation;
160     }
161 
162     /**
163      * @notice Only manager is able to call this function
164      * @dev Sets ability to use token as the main collateral
165      * @param asset The address of the main collateral token
166      * @param stabilityFeeValue The percentage of the year stability fee (3 decimals)
167      * @param liquidationFeeValue The liquidation fee percentage (0 decimals)
168      * @param usdpLimit The USDP token issue limit
169      * @param oracles The enables oracle types
170      **/
171     function setCollateral(
172         address asset,
173         uint stabilityFeeValue,
174         uint liquidationFeeValue,
175         uint usdpLimit,
176         uint[] calldata oracles
177     ) external onlyManager {
178         setStabilityFee(asset, stabilityFeeValue);
179         setLiquidationFee(asset, liquidationFeeValue);
180         setTokenDebtLimit(asset, usdpLimit);
181         for (uint i=0; i < oracles.length; i++) {
182             setOracleType(oracles[i], asset, true);
183         }
184     }
185 
186     /**
187      * @notice Only manager is able to call this function
188      * @dev Sets a permission for an address to modify the Vault
189      * @param who The target address
190      * @param permit The permission flag
191      **/
192     function setVaultAccess(address who, bool permit) external onlyManager {
193         canModifyVault[who] = permit;
194     }
195 
196     /**
197      * @notice Only manager is able to call this function
198      * @dev Sets the percentage of the year stability fee for a particular collateral
199      * @param asset The address of the main collateral token
200      * @param newValue The stability fee percentage (3 decimals)
201      **/
202     function setStabilityFee(address asset, uint newValue) public onlyManager {
203         stabilityFee[asset] = newValue;
204     }
205 
206     /**
207      * @notice Only manager is able to call this function
208      * @dev Sets the percentage of the liquidation fee for a particular collateral
209      * @param asset The address of the main collateral token
210      * @param newValue The liquidation fee percentage (0 decimals)
211      **/
212     function setLiquidationFee(address asset, uint newValue) public onlyManager {
213         require(newValue <= 100, "Unit Protocol: VALUE_OUT_OF_RANGE");
214         liquidationFee[asset] = newValue;
215     }
216 
217     /**
218      * @notice Only manager is able to call this function
219      * @dev Enables/disables oracle types
220      * @param _type The type of the oracle
221      * @param asset The address of the main collateral token
222      * @param enabled The control flag
223      **/
224     function setOracleType(uint _type, address asset, bool enabled) public onlyManager {
225         isOracleTypeEnabled[_type][asset] = enabled;
226     }
227 
228     /**
229      * @notice Only manager is able to call this function
230      * @dev Sets USDP limit for a specific collateral
231      * @param asset The address of the main collateral token
232      * @param limit The limit number
233      **/
234     function setTokenDebtLimit(address asset, uint limit) public onlyManager {
235         tokenDebtLimit[asset] = limit;
236     }
237 }
238 
239 // File: contracts/helpers/TransferHelper.sol
240 
241 /*
242   Copyright 2020 Unit Protocol: Artem Zakharov (az@unit.xyz).
243 */
244 pragma solidity ^0.7.1;
245 
246 // helper methods for interacting with ERC20 tokens and sending ETH that do not consistently return true/false
247 library TransferHelper {
248     function safeApprove(address token, address to, uint value) internal {
249         // bytes4(keccak256(bytes('approve(address,uint256)')));
250         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x095ea7b3, to, value));
251         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: APPROVE_FAILED');
252     }
253 
254     function safeTransfer(address token, address to, uint value) internal {
255         // bytes4(keccak256(bytes('transfer(address,uint256)')));
256         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0xa9059cbb, to, value));
257         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FAILED');
258     }
259 
260     function safeTransferFrom(address token, address from, address to, uint value) internal {
261         // bytes4(keccak256(bytes('transferFrom(address,address,uint256)')));
262         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x23b872dd, from, to, value));
263         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FROM_FAILED');
264     }
265 
266     function safeTransferETH(address to, uint value) internal {
267         (bool success,) = to.call{value:value}(new bytes(0));
268         require(success, 'TransferHelper: ETH_TRANSFER_FAILED');
269     }
270 }
271 
272 // File: contracts/USDP.sol
273 
274 /*
275   Copyright 2020 Unit Protocol: Artem Zakharov (az@unit.xyz).
276 */
277 pragma solidity ^0.7.1;
278 
279 
280 
281 
282 /**
283  * @title USDP token implementation
284  * @author Unit Protocol: Artem Zakharov (az@unit.xyz), Alexander Ponomorev (@bcngod)
285  * @dev ERC20 token
286  **/
287 contract USDP is Auth {
288     using SafeMath for uint;
289 
290     // name of the token
291     string public constant name = "USDP Stablecoin";
292 
293     // symbol of the token
294     string public constant symbol = "USDP";
295 
296     // version of the token
297     string public constant version = "1";
298 
299     // number of decimals the token uses
300     uint8 public constant decimals = 18;
301 
302     // total token supply
303     uint public totalSupply;
304 
305     // balance information map
306     mapping(address => uint) public balanceOf;
307 
308     // token allowance mapping
309     mapping(address => mapping(address => uint)) public allowance;
310 
311     /**
312      * @dev Trigger on any successful call to approve(address spender, uint amount)
313     **/
314     event Approval(address indexed owner, address indexed spender, uint value);
315 
316     /**
317      * @dev Trigger when tokens are transferred, including zero value transfers
318     **/
319     event Transfer(address indexed from, address indexed to, uint value);
320 
321     /**
322       * @param _parameters The address of system parameters contract
323      **/
324     constructor(address _parameters) public Auth(_parameters) {}
325 
326     /**
327       * @notice Only Vault can mint USDP
328       * @dev Mints 'amount' of tokens to address 'to', and MUST fire the
329       * Transfer event
330       * @param to The address of the recipient
331       * @param amount The amount of token to be minted
332      **/
333     function mint(address to, uint amount) external onlyVault {
334         require(to != address(0), "Unit Protocol: ZERO_ADDRESS");
335 
336         balanceOf[to] = balanceOf[to].add(amount);
337         totalSupply = totalSupply.add(amount);
338 
339         emit Transfer(address(0), to, amount);
340     }
341 
342     /**
343       * @notice Only manager can burn tokens from manager's balance
344       * @dev Burns 'amount' of tokens, and MUST fire the Transfer event
345       * @param amount The amount of token to be burned
346      **/
347     function burn(uint amount) external onlyManager {
348         _burn(msg.sender, amount);
349     }
350 
351     /**
352       * @notice Only Vault can burn tokens from any balance
353       * @dev Burns 'amount' of tokens from 'from' address, and MUST fire the Transfer event
354       * @param from The address of the balance owner
355       * @param amount The amount of token to be burned
356      **/
357     function burn(address from, uint amount) external onlyVault {
358         _burn(from, amount);
359     }
360 
361     /**
362       * @dev Transfers 'amount' of tokens to address 'to', and MUST fire the Transfer event. The
363       * function SHOULD throw if the _from account balance does not have enough tokens to spend.
364       * @param to The address of the recipient
365       * @param amount The amount of token to be transferred
366      **/
367     function transfer(address to, uint amount) external returns (bool) {
368         return transferFrom(msg.sender, to, amount);
369     }
370 
371     /**
372       * @dev Transfers 'amount' of tokens from address 'from' to address 'to', and MUST fire the
373       * Transfer event
374       * @param from The address of the sender
375       * @param to The address of the recipient
376       * @param amount The amount of token to be transferred
377      **/
378     function transferFrom(address from, address to, uint amount) public returns (bool) {
379         require(to != address(0), "Unit Protocol: ZERO_ADDRESS");
380         require(balanceOf[from] >= amount, "Unit Protocol: INSUFFICIENT_BALANCE");
381 
382         if (from != msg.sender) {
383             require(allowance[from][msg.sender] >= amount, "Unit Protocol: INSUFFICIENT_ALLOWANCE");
384             _approve(from, msg.sender, allowance[from][msg.sender].sub(amount));
385         }
386         balanceOf[from] = balanceOf[from].sub(amount);
387         balanceOf[to] = balanceOf[to].add(amount);
388 
389         emit Transfer(from, to, amount);
390         return true;
391     }
392 
393     /**
394       * @dev Allows 'spender' to withdraw from your account multiple times, up to the 'amount' amount. If
395       * this function is called again it overwrites the current allowance with 'amount'.
396       * @param spender The address of the account able to transfer the tokens
397       * @param amount The amount of tokens to be approved for transfer
398      **/
399     function approve(address spender, uint amount) external returns (bool) {
400         _approve(msg.sender, spender, amount);
401         return true;
402     }
403 
404     /**
405      * @dev Atomically increases the allowance granted to `spender` by the caller.
406      *
407      * This is an alternative to `approve` that can be used as a mitigation for
408      * problems described in `IERC20.approve`.
409      *
410      * Emits an `Approval` event indicating the updated allowance.
411      *
412      * Requirements:
413      *
414      * - `spender` cannot be the zero address.
415      */
416     function increaseAllowance(address spender, uint addedValue) public virtual returns (bool) {
417         _approve(msg.sender, spender, allowance[msg.sender][spender].add(addedValue));
418         return true;
419     }
420 
421     /**
422      * @dev Atomically decreases the allowance granted to `spender` by the caller.
423      *
424      * This is an alternative to `approve` that can be used as a mitigation for
425      * problems described in `IERC20.approve`.
426      *
427      * Emits an `Approval` event indicating the updated allowance.
428      *
429      * Requirements:
430      *
431      * - `spender` cannot be the zero address.
432      * - `spender` must have allowance for the caller of at least
433      * `subtractedValue`.
434      */
435     function decreaseAllowance(address spender, uint subtractedValue) public virtual returns (bool) {
436         _approve(msg.sender, spender, allowance[msg.sender][spender].sub(subtractedValue));
437         return true;
438     }
439 
440     function _approve(address owner, address spender, uint amount) internal virtual {
441         require(owner != address(0), "Unit Protocol: approve from the zero address");
442         require(spender != address(0), "Unit Protocol: approve to the zero address");
443 
444         allowance[owner][spender] = amount;
445         emit Approval(owner, spender, amount);
446     }
447 
448     function _burn(address from, uint amount) internal virtual {
449         balanceOf[from] = balanceOf[from].sub(amount);
450         totalSupply = totalSupply.sub(amount);
451 
452         emit Transfer(from, address(0), amount);
453     }
454 }
455 
456 // File: contracts/helpers/IWETH.sol
457 
458 /*
459   Copyright 2020 Unit Protocol: Artem Zakharov (az@unit.xyz).
460 */
461 pragma solidity ^0.7.1;
462 
463 
464 interface IWETH {
465     function deposit() external payable;
466     function transfer(address to, uint value) external returns (bool);
467     function withdraw(uint) external;
468 }
469 
470 // File: contracts/Vault.sol
471 
472 /*
473   Copyright 2020 Unit Protocol: Artem Zakharov (az@unit.xyz).
474 */
475 pragma solidity ^0.7.1;
476 
477 
478 
479 
480 
481 
482 
483 /**
484  * @title Vault
485  * @author Unit Protocol: Artem Zakharov (az@unit.xyz), Alexander Ponomorev (@bcngod)
486  * @notice Vault is the core of Unit Protocol USDP Stablecoin system
487  * @notice Vault stores and manages collateral funds of all positions and counts debts
488  * @notice Only Vault can manage supply of USDP token
489  * @notice Vault will not be changed/upgraded after initial deployment for the current stablecoin version
490  **/
491 contract Vault is Auth {
492     using SafeMath for uint;
493 
494     // COL token address
495     address public immutable col;
496 
497     // WETH token address
498     address payable public immutable weth;
499 
500     uint public constant DENOMINATOR_1E5 = 1e5;
501 
502     uint public constant DENOMINATOR_1E2 = 1e2;
503 
504     // USDP token address
505     address public immutable usdp;
506 
507     // collaterals whitelist
508     mapping(address => mapping(address => uint)) public collaterals;
509 
510     // COL token collaterals
511     mapping(address => mapping(address => uint)) public colToken;
512 
513     // user debts
514     mapping(address => mapping(address => uint)) public debts;
515 
516     // block number of liquidation trigger
517     mapping(address => mapping(address => uint)) public liquidationBlock;
518 
519     // initial price of collateral
520     mapping(address => mapping(address => uint)) public liquidationPrice;
521 
522     // debts of tokens
523     mapping(address => uint) public tokenDebts;
524 
525     // stability fee pinned to each position
526     mapping(address => mapping(address => uint)) public stabilityFee;
527 
528     // liquidation fee pinned to each position, 0 decimals
529     mapping(address => mapping(address => uint)) public liquidationFee;
530 
531     // type of using oracle pinned for each position
532     mapping(address => mapping(address => uint)) public oracleType;
533 
534     // timestamp of the last update
535     mapping(address => mapping(address => uint)) public lastUpdate;
536 
537     modifier notLiquidating(address asset, address user) {
538         require(liquidationBlock[asset][user] == 0, "Unit Protocol: LIQUIDATING_POSITION");
539         _;
540     }
541 
542     /**
543      * @param _parameters The address of the system parameters
544      * @param _col COL token address
545      * @param _usdp USDP token address
546      **/
547     constructor(address _parameters, address _col, address _usdp, address payable _weth) public Auth(_parameters) {
548         col = _col;
549         usdp = _usdp;
550         weth = _weth;
551     }
552 
553     // only accept ETH via fallback from the WETH contract
554     receive() external payable {
555         require(msg.sender == weth, "Unit Protocol: RESTRICTED");
556     }
557 
558     /**
559      * @dev Updates parameters of the position to the current ones
560      * @param asset The address of the main collateral token
561      * @param user The owner of a position
562      **/
563     function update(address asset, address user) public hasVaultAccess notLiquidating(asset, user) {
564 
565         // calculate fee using stored stability fee
566         uint debtWithFee = getTotalDebt(asset, user);
567         tokenDebts[asset] = tokenDebts[asset].sub(debts[asset][user]).add(debtWithFee);
568         debts[asset][user] = debtWithFee;
569 
570         stabilityFee[asset][user] = vaultParameters.stabilityFee(asset);
571         liquidationFee[asset][user] = vaultParameters.liquidationFee(asset);
572         lastUpdate[asset][user] = block.timestamp;
573     }
574 
575     /**
576      * @dev Creates new position for user
577      * @param asset The address of the main collateral token
578      * @param user The address of a position's owner
579      * @param _oracleType The type of an oracle
580      **/
581     function spawn(address asset, address user, uint _oracleType) external hasVaultAccess notLiquidating(asset, user) {
582         oracleType[asset][user] = _oracleType;
583         delete liquidationBlock[asset][user];
584     }
585 
586     /**
587      * @dev Clears unused storage variables
588      * @param asset The address of the main collateral token
589      * @param user The address of a position's owner
590      **/
591     function destroy(address asset, address user) public hasVaultAccess notLiquidating(asset, user) {
592         delete stabilityFee[asset][user];
593         delete oracleType[asset][user];
594         delete lastUpdate[asset][user];
595         delete liquidationFee[asset][user];
596     }
597 
598     /**
599      * @notice Tokens must be pre-approved
600      * @dev Adds main collateral to a position
601      * @param asset The address of the main collateral token
602      * @param user The address of a position's owner
603      * @param amount The amount of tokens to deposit
604      **/
605     function depositMain(address asset, address user, uint amount) external hasVaultAccess notLiquidating(asset, user) {
606         collaterals[asset][user] = collaterals[asset][user].add(amount);
607         TransferHelper.safeTransferFrom(asset, user, address(this), amount);
608     }
609 
610     /**
611      * @dev Converts ETH to WETH and adds main collateral to a position
612      * @param user The address of a position's owner
613      **/
614     function depositEth(address user) external payable notLiquidating(weth, user) {
615         IWETH(weth).deposit{value: msg.value}();
616         collaterals[weth][user] = collaterals[weth][user].add(msg.value);
617     }
618 
619     /**
620      * @dev Withdraws main collateral from a position
621      * @param asset The address of the main collateral token
622      * @param user The address of a position's owner
623      * @param amount The amount of tokens to withdraw
624      **/
625     function withdrawMain(address asset, address user, uint amount) external hasVaultAccess notLiquidating(asset, user) {
626         collaterals[asset][user] = collaterals[asset][user].sub(amount);
627         TransferHelper.safeTransfer(asset, user, amount);
628     }
629 
630     /**
631      * @dev Withdraws WETH collateral from a position converting WETH to ETH
632      * @param user The address of a position's owner
633      * @param amount The amount of ETH to withdraw
634      **/
635     function withdrawEth(address payable user, uint amount) external hasVaultAccess notLiquidating(weth, user) {
636         collaterals[weth][user] = collaterals[weth][user].sub(amount);
637         IWETH(weth).withdraw(amount);
638         TransferHelper.safeTransferETH(user, amount);
639     }
640 
641     /**
642      * @notice Tokens must be pre-approved
643      * @dev Adds COL token to a position
644      * @param asset The address of the main collateral token
645      * @param user The address of a position's owner
646      * @param amount The amount of tokens to deposit
647      **/
648     function depositCol(address asset, address user, uint amount) external hasVaultAccess notLiquidating(asset, user) {
649         colToken[asset][user] = colToken[asset][user].add(amount);
650         TransferHelper.safeTransferFrom(col, user, address(this), amount);
651     }
652 
653     /**
654      * @dev Withdraws COL token from a position
655      * @param asset The address of the main collateral token
656      * @param user The address of a position's owner
657      * @param amount The amount of tokens to withdraw
658      **/
659     function withdrawCol(address asset, address user, uint amount) external hasVaultAccess notLiquidating(asset, user) {
660         colToken[asset][user] = colToken[asset][user].sub(amount);
661         TransferHelper.safeTransfer(col, user, amount);
662     }
663 
664     /**
665      * @dev Increases position's debt and mints USDP token
666      * @param asset The address of the main collateral token
667      * @param user The address of a position's owner
668      * @param amount The amount of USDP to borrow
669      **/
670     function borrow(
671         address asset,
672         address user,
673         uint amount
674     )
675     external
676     hasVaultAccess
677     notLiquidating(asset, user)
678     returns(uint)
679     {
680         require(vaultParameters.isOracleTypeEnabled(oracleType[asset][user], asset), "Unit Protocol: WRONG_ORACLE_TYPE");
681         update(asset, user);
682         debts[asset][user] = debts[asset][user].add(amount);
683         tokenDebts[asset] = tokenDebts[asset].add(amount);
684 
685         // check USDP limit for token
686         require(tokenDebts[asset] <= vaultParameters.tokenDebtLimit(asset), "Unit Protocol: ASSET_DEBT_LIMIT");
687 
688         USDP(usdp).mint(user, amount);
689 
690         return debts[asset][user];
691     }
692 
693     /**
694      * @dev Decreases position's debt and burns USDP token
695      * @param asset The address of the main collateral token
696      * @param user The address of a position's owner
697      * @param amount The amount of USDP to repay
698      * @return updated debt of a position
699      **/
700     function repay(
701         address asset,
702         address user,
703         uint amount
704     )
705     external
706     hasVaultAccess
707     notLiquidating(asset, user)
708     returns(uint)
709     {
710         uint debt = debts[asset][user];
711         debts[asset][user] = debt.sub(amount);
712         tokenDebts[asset] = tokenDebts[asset].sub(amount);
713         USDP(usdp).burn(user, amount);
714 
715         return debts[asset][user];
716     }
717 
718     /**
719      * @dev Transfers fee to foundation
720      * @param asset The address of the fee asset
721      * @param user The address to transfer funds from
722      * @param amount The amount of asset to transfer
723      **/
724     function chargeFee(address asset, address user, uint amount) external hasVaultAccess notLiquidating(asset, user) {
725         if (amount != 0) {
726             TransferHelper.safeTransferFrom(asset, user, vaultParameters.foundation(), amount);
727         }
728     }
729 
730     /**
731      * @dev Deletes position and transfers collateral to liquidation system
732      * @param asset The address of the main collateral token
733      * @param positionOwner The address of a position's owner
734      * @param initialPrice The starting price of collateral in USDP
735      **/
736     function triggerLiquidation(
737         address asset,
738         address positionOwner,
739         uint initialPrice
740     )
741     external
742     hasVaultAccess
743     notLiquidating(asset, positionOwner)
744     {
745         // reverts if oracle type is disabled
746         require(vaultParameters.isOracleTypeEnabled(oracleType[asset][positionOwner], asset), "Unit Protocol: WRONG_ORACLE_TYPE");
747 
748         // fix the debt
749         debts[asset][positionOwner] = getTotalDebt(asset, positionOwner);
750 
751         liquidationBlock[asset][positionOwner] = block.number;
752         liquidationPrice[asset][positionOwner] = initialPrice;
753     }
754 
755     /**
756      * @dev Internal liquidation process
757      * @param asset The address of the main collateral token
758      * @param positionOwner The address of a position's owner
759      * @param mainAssetToLiquidator The amount of main asset to send to a liquidator
760      * @param colToLiquidator The amount of COL to send to a liquidator
761      * @param mainAssetToPositionOwner The amount of main asset to send to a position owner
762      * @param colToPositionOwner The amount of COL to send to a position owner
763      * @param repayment The repayment in USDP
764      * @param penalty The liquidation penalty in USDP
765      * @param liquidator The address of a liquidator
766      **/
767     function liquidate(
768         address asset,
769         address positionOwner,
770         uint mainAssetToLiquidator,
771         uint colToLiquidator,
772         uint mainAssetToPositionOwner,
773         uint colToPositionOwner,
774         uint repayment,
775         uint penalty,
776         address liquidator
777     )
778         external
779         hasVaultAccess
780     {
781         require(liquidationBlock[asset][positionOwner] != 0, "Unit Protocol: NOT_TRIGGERED_LIQUIDATION");
782 
783         uint mainAssetInPosition = collaterals[asset][positionOwner];
784         uint mainAssetToFoundation = mainAssetInPosition.sub(mainAssetToLiquidator).sub(mainAssetToPositionOwner);
785 
786         uint colInPosition = colToken[asset][positionOwner];
787         uint colToFoundation = colInPosition.sub(colToLiquidator).sub(colToPositionOwner);
788 
789         delete liquidationPrice[asset][positionOwner];
790         delete liquidationBlock[asset][positionOwner];
791         delete debts[asset][positionOwner];
792         delete collaterals[asset][positionOwner];
793         delete colToken[asset][positionOwner];
794 
795         destroy(asset, positionOwner);
796 
797         // charge liquidation fee and burn USDP
798         if (repayment > penalty) {
799             if (penalty != 0) {
800                 TransferHelper.safeTransferFrom(usdp, liquidator, vaultParameters.foundation(), penalty);
801             }
802             USDP(usdp).burn(liquidator, repayment.sub(penalty));
803         } else {
804             if (repayment != 0) {
805                 TransferHelper.safeTransferFrom(usdp, liquidator, vaultParameters.foundation(), repayment);
806             }
807         }
808 
809         // send the part of collateral to a liquidator
810         if (mainAssetToLiquidator != 0) {
811             TransferHelper.safeTransfer(asset, liquidator, mainAssetToLiquidator);
812         }
813 
814         if (colToLiquidator != 0) {
815             TransferHelper.safeTransfer(col, liquidator, colToLiquidator);
816         }
817 
818         // send the rest of collateral to a position owner
819         if (mainAssetToPositionOwner != 0) {
820             TransferHelper.safeTransfer(asset, positionOwner, mainAssetToPositionOwner);
821         }
822 
823         if (colToPositionOwner != 0) {
824             TransferHelper.safeTransfer(col, positionOwner, colToPositionOwner);
825         }
826 
827         if (mainAssetToFoundation != 0) {
828             TransferHelper.safeTransfer(asset, vaultParameters.foundation(), mainAssetToFoundation);
829         }
830 
831         if (colToFoundation != 0) {
832             TransferHelper.safeTransfer(col, vaultParameters.foundation(), colToFoundation);
833         }
834     }
835 
836     /**
837      * @notice Only manager can call this function
838      * @dev Changes broken oracle type to the correct one
839      * @param asset The address of the main collateral token
840      * @param user The address of a position's owner
841      * @param newOracleType The new type of an oracle
842      **/
843     function changeOracleType(address asset, address user, uint newOracleType) external onlyManager {
844         oracleType[asset][user] = newOracleType;
845     }
846 
847     /**
848      * @dev Calculates the total amount of position's debt based on elapsed time
849      * @param asset The address of the main collateral token
850      * @param user The address of a position's owner
851      * @return user debt of a position plus accumulated fee
852      **/
853     function getTotalDebt(address asset, address user) public view returns (uint) {
854         uint debt = debts[asset][user];
855         if (liquidationBlock[asset][user] != 0) return debt;
856         uint fee = calculateFee(asset, user, debt);
857         return debt.add(fee);
858     }
859 
860     /**
861      * @dev Calculates the amount of fee based on elapsed time and repayment amount
862      * @param asset The address of the main collateral token
863      * @param user The address of a position's owner
864      * @param amount The repayment amount
865      * @return fee amount
866      **/
867     function calculateFee(address asset, address user, uint amount) public view returns (uint) {
868         uint sFeePercent = stabilityFee[asset][user];
869         uint timePast = block.timestamp.sub(lastUpdate[asset][user]);
870 
871         return amount.mul(sFeePercent).mul(timePast).div(365 days).div(DENOMINATOR_1E5);
872     }
873 }
874 
875 // File: contracts/helpers/Math.sol
876 
877 /*
878   Copyright 2020 Unit Protocol: Artem Zakharov (az@unit.xyz).
879 */
880 pragma solidity ^0.7.1;
881 
882 /**
883  * @dev Standard math utilities missing in the Solidity language.
884  */
885 library Math {
886     /**
887      * @dev Returns the largest of two numbers.
888      */
889     function max(uint256 a, uint256 b) internal pure returns (uint256) {
890         return a >= b ? a : b;
891     }
892 
893     /**
894      * @dev Returns the smallest of two numbers.
895      */
896     function min(uint256 a, uint256 b) internal pure returns (uint256) {
897         return a < b ? a : b;
898     }
899 
900     /**
901      * @dev Returns the average of two numbers. The result is rounded towards
902      * zero.
903      */
904     function average(uint256 a, uint256 b) internal pure returns (uint256) {
905         // (a + b) / 2 can overflow, so we distribute
906         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
907     }
908 }
909 
910 // File: contracts/helpers/ReentrancyGuard.sol
911 
912 pragma solidity ^0.7.1;
913 
914 /**
915  * @dev Contract module that helps prevent reentrant calls to a function.
916  *
917  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
918  * available, which can be applied to functions to make sure there are no nested
919  * (reentrant) calls to them.
920  *
921  * Note that because there is a single `nonReentrant` guard, functions marked as
922  * `nonReentrant` may not call one another. This can be worked around by making
923  * those functions `private`, and then adding `external` `nonReentrant` entry
924  * points to them.
925  *
926  * TIP: If you would like to learn more about reentrancy and alternative ways
927  * to protect against it, check out our blog post
928  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
929  */
930 contract ReentrancyGuard {
931     // Booleans are more expensive than uint256 or any type that takes up a full
932     // word because each write operation emits an extra SLOAD to first read the
933     // slot's contents, replace the bits taken up by the boolean, and then write
934     // back. This is the compiler's defense against contract upgrades and
935     // pointer aliasing, and it cannot be disabled.
936 
937     // The values being non-zero value makes deployment a bit more expensive,
938     // but in exchange the refund on every call to nonReentrant will be lower in
939     // amount. Since refunds are capped to a percentage of the total
940     // transaction's gas, it is best to keep them low in cases like this one, to
941     // increase the likelihood of the full refund coming into effect.
942     uint256 private constant _NOT_ENTERED = 1;
943     uint256 private constant _ENTERED = 2;
944 
945     uint256 private _status;
946 
947     constructor () public {
948         _status = _NOT_ENTERED;
949     }
950 
951     /**
952      * @dev Prevents a contract from calling itself, directly or indirectly.
953      * Calling a `nonReentrant` function from another `nonReentrant`
954      * function is not supported. It is possible to prevent this from happening
955      * by making the `nonReentrant` function external, and make it call a
956      * `private` function that does the actual work.
957      */
958     modifier nonReentrant() {
959         // On the first call to nonReentrant, _notEntered will be true
960         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
961 
962         // Any calls to nonReentrant after this point will fail
963         _status = _ENTERED;
964 
965         _;
966 
967         // By storing the original value once again, a refund is triggered (see
968         // https://eips.ethereum.org/EIPS/eip-2200)
969         _status = _NOT_ENTERED;
970     }
971 }
972 
973 // File: contracts/vault-managers/VaultManagerParameters.sol
974 
975 /*
976   Copyright 2020 Unit Protocol: Artem Zakharov (az@unit.xyz).
977 */
978 pragma solidity ^0.7.1;
979 
980 
981 
982 /**
983  * @title VaultManagerParameters
984  * @author Unit Protocol: Artem Zakharov (az@unit.xyz), Alexander Ponomorev (@bcngod)
985  **/
986 contract VaultManagerParameters is Auth {
987 
988     // determines the minimum percentage of COL token part in collateral, 0 decimals
989     mapping(address => uint) public minColPercent;
990 
991     // determines the maximum percentage of COL token part in collateral, 0 decimals
992     mapping(address => uint) public maxColPercent;
993 
994     // map token to initial collateralization ratio; 0 decimals
995     mapping(address => uint) public initialCollateralRatio;
996 
997     // map token to liquidation ratio; 0 decimals
998     mapping(address => uint) public liquidationRatio;
999 
1000     // map token to liquidation discount; 3 decimals
1001     mapping(address => uint) public liquidationDiscount;
1002 
1003     // map token to devaluation period in blocks
1004     mapping(address => uint) public devaluationPeriod;
1005 
1006     constructor(address _vaultParameters) public Auth(_vaultParameters) {}
1007 
1008     /**
1009      * @notice Only manager is able to call this function
1010      * @dev Sets ability to use token as the main collateral
1011      * @param asset The address of the main collateral token
1012      * @param stabilityFeeValue The percentage of the year stability fee (3 decimals)
1013      * @param liquidationFeeValue The liquidation fee percentage (0 decimals)
1014      * @param initialCollateralRatioValue The initial collateralization ratio
1015      * @param liquidationRatioValue The liquidation ratio
1016      * @param liquidationDiscountValue The liquidation discount (3 decimals)
1017      * @param devaluationPeriodValue The devaluation period in blocks
1018      * @param usdpLimit The USDP token issue limit
1019      * @param minColP The min percentage of COL value in position (0 decimals)
1020      * @param maxColP The max percentage of COL value in position (0 decimals)
1021      **/
1022     function setCollateral(
1023         address asset,
1024         uint stabilityFeeValue,
1025         uint liquidationFeeValue,
1026         uint initialCollateralRatioValue,
1027         uint liquidationRatioValue,
1028         uint liquidationDiscountValue,
1029         uint devaluationPeriodValue,
1030         uint usdpLimit,
1031         uint[] calldata oracles,
1032         uint minColP,
1033         uint maxColP
1034     ) external onlyManager {
1035         vaultParameters.setCollateral(asset, stabilityFeeValue, liquidationFeeValue, usdpLimit, oracles);
1036         setInitialCollateralRatio(asset, initialCollateralRatioValue);
1037         setLiquidationRatio(asset, liquidationRatioValue);
1038         setDevaluationPeriod(asset, devaluationPeriodValue);
1039         setLiquidationDiscount(asset, liquidationDiscountValue);
1040         setColPartRange(asset, minColP, maxColP);
1041     }
1042 
1043     /**
1044      * @notice Only manager is able to call this function
1045      * @dev Sets the initial collateral ratio
1046      * @param asset The address of the main collateral token
1047      * @param newValue The collateralization ratio (0 decimals)
1048      **/
1049     function setInitialCollateralRatio(address asset, uint newValue) public onlyManager {
1050         require(newValue != 0 && newValue <= 100, "Unit Protocol: INCORRECT_COLLATERALIZATION_VALUE");
1051         initialCollateralRatio[asset] = newValue;
1052     }
1053 
1054     /**
1055      * @notice Only manager is able to call this function
1056      * @dev Sets the liquidation ratio
1057      * @param asset The address of the main collateral token
1058      * @param newValue The liquidation ratio (0 decimals)
1059      **/
1060     function setLiquidationRatio(address asset, uint newValue) public onlyManager {
1061         require(newValue != 0 && newValue >= initialCollateralRatio[asset], "Unit Protocol: INCORRECT_COLLATERALIZATION_VALUE");
1062         liquidationRatio[asset] = newValue;
1063     }
1064 
1065     /**
1066      * @notice Only manager is able to call this function
1067      * @dev Sets the liquidation discount
1068      * @param asset The address of the main collateral token
1069      * @param newValue The liquidation discount (3 decimals)
1070      **/
1071     function setLiquidationDiscount(address asset, uint newValue) public onlyManager {
1072         require(newValue < 1e5, "Unit Protocol: INCORRECT_DISCOUNT_VALUE");
1073         liquidationDiscount[asset] = newValue;
1074     }
1075 
1076     /**
1077      * @notice Only manager is able to call this function
1078      * @dev Sets the devaluation period of collateral after liquidation
1079      * @param asset The address of the main collateral token
1080      * @param newValue The devaluation period in blocks
1081      **/
1082     function setDevaluationPeriod(address asset, uint newValue) public onlyManager {
1083         require(newValue != 0, "Unit Protocol: INCORRECT_DEVALUATION_VALUE");
1084         devaluationPeriod[asset] = newValue;
1085     }
1086 
1087     /**
1088      * @notice Only manager is able to call this function
1089      * @dev Sets the percentage range of the COL token part for specific collateral token
1090      * @param asset The address of the main collateral token
1091      * @param min The min percentage (0 decimals)
1092      * @param max The max percentage (0 decimals)
1093      **/
1094     function setColPartRange(address asset, uint min, uint max) public onlyManager {
1095         require(max <= 100 && min <= max, "Unit Protocol: WRONG_RANGE");
1096         minColPercent[asset] = min;
1097         maxColPercent[asset] = max;
1098     }
1099 }
1100 
1101 // File: contracts/oracles/OracleSimple.sol
1102 
1103 /*
1104   Copyright 2020 Unit Protocol: Artem Zakharov (az@unit.xyz).
1105 */
1106 pragma solidity ^0.7.1;
1107 
1108 
1109 /**
1110  * @title OracleSimple
1111  * @author Unit Protocol: Artem Zakharov (az@unit.xyz), Alexander Ponomorev (@bcngod)
1112  **/
1113 abstract contract OracleSimple {
1114     // returns Q112-encoded value
1115     function assetToUsd(address asset, uint amount) public virtual view returns (uint);
1116 }
1117 
1118 
1119 /**
1120  * @title OracleSimplePoolToken
1121  * @author Unit Protocol: Artem Zakharov (az@unit.xyz), Alexander Ponomorev (@bcngod)
1122  **/
1123 abstract contract OracleSimplePoolToken is OracleSimple {
1124     ChainlinkedOracleSimple public oracleMainAsset;
1125 }
1126 
1127 
1128 /**
1129  * @title ChainlinkedOracleSimple
1130  * @author Unit Protocol: Artem Zakharov (az@unit.xyz), Alexander Ponomorev (@bcngod)
1131  **/
1132 abstract contract ChainlinkedOracleSimple is OracleSimple {
1133     address public WETH;
1134     // returns ordinary value
1135     function ethToUsd(uint ethAmount) public virtual view returns (uint);
1136     // returns Q112-encoded value
1137     function assetToEth(address asset, uint amount) public virtual view returns (uint);
1138 }
1139 
1140 // File: contracts/vault-managers/VaultManagerKeep3rMainAsset.sol
1141 
1142 /*
1143   Copyright 2020 Unit Protocol: Artem Zakharov (az@unit.xyz).
1144 */
1145 pragma solidity ^0.7.1;
1146 pragma experimental ABIEncoderV2;
1147 
1148 
1149 
1150 
1151 
1152 
1153 
1154 /**
1155  * @title VaultManagerKeep3rMainAsset
1156  * @author Unit Protocol: Artem Zakharov (az@unit.xyz), Alexander Ponomorev (@bcngod)
1157  **/
1158 contract VaultManagerKeep3rMainAsset is ReentrancyGuard {
1159     using SafeMath for uint;
1160 
1161     Vault public immutable vault;
1162     VaultManagerParameters public immutable vaultManagerParameters;
1163     ChainlinkedOracleSimple public immutable oracle;
1164     uint public constant ORACLE_TYPE = 3;
1165     uint public constant Q112 = 2 ** 112;
1166 
1167     /**
1168      * @dev Trigger when joins are happened
1169     **/
1170     event Join(address indexed asset, address indexed user, uint main, uint col, uint usdp);
1171 
1172     /**
1173      * @dev Trigger when exits are happened
1174     **/
1175     event Exit(address indexed asset, address indexed user, uint main, uint col, uint usdp);
1176 
1177     modifier spawned(address asset, address user) {
1178 
1179         // check the existence of a position
1180         require(vault.getTotalDebt(asset, user) != 0, "Unit Protocol: NOT_SPAWNED_POSITION");
1181         require(vault.oracleType(asset, user) == ORACLE_TYPE, "Unit Protocol: WRONG_ORACLE_TYPE");
1182         _;
1183     }
1184 
1185     /**
1186      * @param _vaultManagerParameters The address of the contract with vault manager parameters
1187      * @param _keep3rOracleMainAsset The address of Keep3r-based Oracle for main asset
1188      **/
1189     constructor(address _vaultManagerParameters, address _keep3rOracleMainAsset) public {
1190         vaultManagerParameters = VaultManagerParameters(_vaultManagerParameters);
1191         vault = Vault(VaultManagerParameters(_vaultManagerParameters).vaultParameters().vault());
1192         oracle = ChainlinkedOracleSimple(_keep3rOracleMainAsset);
1193     }
1194 
1195     /**
1196       * @notice Cannot be used for already spawned positions
1197       * @notice Token using as main collateral must be whitelisted
1198       * @notice Depositing tokens must be pre-approved to vault address
1199       * @notice position actually considered as spawned only when usdpAmount > 0
1200       * @dev Spawns new positions
1201       * @param asset The address of token using as main collateral
1202       * @param mainAmount The amount of main collateral to deposit
1203       * @param colAmount The amount of COL token to deposit
1204       * @param usdpAmount The amount of USDP token to borrow
1205       **/
1206     function spawn(
1207         address asset,
1208         uint mainAmount,
1209         uint colAmount,
1210         uint usdpAmount
1211     )
1212     public
1213     nonReentrant
1214     {
1215         require(usdpAmount != 0, "Unit Protocol: ZERO_BORROWING");
1216 
1217         // check whether the position is spawned
1218         require(vault.getTotalDebt(asset, msg.sender) == 0, "Unit Protocol: SPAWNED_POSITION");
1219 
1220         // oracle availability check
1221         require(vault.vaultParameters().isOracleTypeEnabled(ORACLE_TYPE, asset), "Unit Protocol: WRONG_ORACLE_TYPE");
1222 
1223         // USDP minting triggers the spawn of a position
1224         vault.spawn(asset, msg.sender, ORACLE_TYPE);
1225 
1226         _depositAndBorrow(asset, msg.sender, mainAmount, colAmount, usdpAmount);
1227 
1228         // fire an event
1229         emit Join(asset, msg.sender, mainAmount, colAmount, usdpAmount);
1230     }
1231 
1232     /**
1233       * @notice Cannot be used for already spawned positions
1234       * @notice WETH must be whitelisted as collateral
1235       * @notice COL must be pre-approved to vault address
1236       * @notice position actually considered as spawned only when usdpAmount > 0
1237       * @dev Spawns new positions using ETH
1238       * @param colAmount The amount of COL token to deposit
1239       * @param usdpAmount The amount of USDP token to borrow
1240       **/
1241     function spawn_Eth(
1242         uint colAmount,
1243         uint usdpAmount
1244     )
1245     public
1246     payable
1247     nonReentrant
1248     {
1249         require(usdpAmount != 0, "Unit Protocol: ZERO_BORROWING");
1250 
1251         // check whether the position is spawned
1252         require(vault.getTotalDebt(vault.weth(), msg.sender) == 0, "Unit Protocol: SPAWNED_POSITION");
1253 
1254         // oracle availability check
1255         require(vault.vaultParameters().isOracleTypeEnabled(ORACLE_TYPE, vault.weth()), "Unit Protocol: WRONG_ORACLE_TYPE");
1256 
1257         // USDP minting triggers the spawn of a position
1258         vault.spawn(vault.weth(), msg.sender, ORACLE_TYPE);
1259 
1260         _depositAndBorrow_Eth(msg.sender, colAmount, usdpAmount);
1261 
1262         // fire an event
1263         emit Join(vault.weth(), msg.sender, msg.value, colAmount, usdpAmount);
1264     }
1265 
1266     /**
1267      * @notice Position should be spawned (USDP borrowed from position) to call this method
1268      * @notice Depositing tokens must be pre-approved to vault address
1269      * @notice Token using as main collateral must be whitelisted
1270      * @dev Deposits collaterals and borrows USDP to spawned positions simultaneously
1271      * @param asset The address of token using as main collateral
1272      * @param mainAmount The amount of main collateral to deposit
1273      * @param colAmount The amount of COL token to deposit
1274      * @param usdpAmount The amount of USDP token to borrow
1275      **/
1276     function depositAndBorrow(
1277         address asset,
1278         uint mainAmount,
1279         uint colAmount,
1280         uint usdpAmount
1281     )
1282     public
1283     spawned(asset, msg.sender)
1284     nonReentrant
1285     {
1286         require(usdpAmount != 0, "Unit Protocol: ZERO_BORROWING");
1287 
1288         _depositAndBorrow(asset, msg.sender, mainAmount, colAmount, usdpAmount);
1289 
1290         // fire an event
1291         emit Join(asset, msg.sender, mainAmount, colAmount, usdpAmount);
1292     }
1293 
1294     /**
1295      * @notice Position should be spawned (USDP borrowed from position) to call this method
1296      * @notice Depositing tokens must be pre-approved to vault address
1297      * @notice Token using as main collateral must be whitelisted
1298      * @dev Deposits collaterals and borrows USDP to spawned positions simultaneously
1299      * @param colAmount The amount of COL token to deposit
1300      * @param usdpAmount The amount of USDP token to borrow
1301      **/
1302     function depositAndBorrow_Eth(
1303         uint colAmount,
1304         uint usdpAmount
1305     )
1306     public
1307     payable
1308     spawned(vault.weth(), msg.sender)
1309     nonReentrant
1310     {
1311         require(usdpAmount != 0, "Unit Protocol: ZERO_BORROWING");
1312 
1313         _depositAndBorrow_Eth(msg.sender, colAmount, usdpAmount);
1314 
1315         // fire an event
1316         emit Join(vault.weth(), msg.sender, msg.value, colAmount, usdpAmount);
1317     }
1318 
1319     /**
1320       * @notice Tx sender must have a sufficient USDP balance to pay the debt
1321       * @dev Withdraws collateral and repays specified amount of debt simultaneously
1322       * @param asset The address of token using as main collateral
1323       * @param mainAmount The amount of main collateral token to withdraw
1324       * @param colAmount The amount of COL token to withdraw
1325       * @param usdpAmount The amount of USDP token to repay
1326       **/
1327     function withdrawAndRepay(
1328         address asset,
1329         uint mainAmount,
1330         uint colAmount,
1331         uint usdpAmount
1332     )
1333     public
1334     spawned(asset, msg.sender)
1335     nonReentrant
1336     {
1337         // check usefulness of tx
1338         require(mainAmount != 0 || colAmount != 0, "Unit Protocol: USELESS_TX");
1339 
1340         uint debt = vault.debts(asset, msg.sender);
1341         require(debt != 0 && usdpAmount != debt, "Unit Protocol: USE_REPAY_ALL_INSTEAD");
1342 
1343         if (mainAmount != 0) {
1344             // withdraw main collateral to the user address
1345             vault.withdrawMain(asset, msg.sender, mainAmount);
1346         }
1347 
1348         if (colAmount != 0) {
1349             // withdraw COL tokens to the user's address
1350             vault.withdrawCol(asset, msg.sender, colAmount);
1351         }
1352 
1353         if (usdpAmount != 0) {
1354             uint fee = vault.calculateFee(asset, msg.sender, usdpAmount);
1355             vault.chargeFee(vault.usdp(), msg.sender, fee);
1356             vault.repay(asset, msg.sender, usdpAmount);
1357         }
1358 
1359         vault.update(asset, msg.sender);
1360 
1361         _ensurePositionCollateralization(asset, msg.sender);
1362 
1363         // fire an event
1364         emit Exit(asset, msg.sender, mainAmount, colAmount, usdpAmount);
1365     }
1366 
1367     /**
1368       * @notice Tx sender must have a sufficient USDP balance to pay the debt
1369       * @dev Withdraws collateral and repays specified amount of debt simultaneously converting WETH to ETH
1370       * @param ethAmount The amount of ETH to withdraw
1371       * @param colAmount The amount of COL token to withdraw
1372       * @param usdpAmount The amount of USDP token to repay
1373       **/
1374     function withdrawAndRepay_Eth(
1375         uint ethAmount,
1376         uint colAmount,
1377         uint usdpAmount
1378     )
1379     public
1380     spawned(vault.weth(), msg.sender)
1381     nonReentrant
1382     {
1383         // check usefulness of tx
1384         require(ethAmount != 0 || colAmount != 0, "Unit Protocol: USELESS_TX");
1385 
1386         uint debt = vault.debts(vault.weth(), msg.sender);
1387         require(debt != 0 && usdpAmount != debt, "Unit Protocol: USE_REPAY_ALL_INSTEAD");
1388 
1389         if (ethAmount != 0) {
1390             // withdraw main collateral to the user address
1391             vault.withdrawEth(msg.sender, ethAmount);
1392         }
1393 
1394         if (colAmount != 0) {
1395             // withdraw COL tokens to the user's address
1396             vault.withdrawCol(vault.weth(), msg.sender, colAmount);
1397         }
1398 
1399         if (usdpAmount != 0) {
1400             uint fee = vault.calculateFee(vault.weth(), msg.sender, usdpAmount);
1401             vault.chargeFee(vault.usdp(), msg.sender, fee);
1402             vault.repay(vault.weth(), msg.sender, usdpAmount);
1403         }
1404 
1405         vault.update(vault.weth(), msg.sender);
1406 
1407         _ensurePositionCollateralization_Eth(msg.sender);
1408 
1409         // fire an event
1410         emit Exit(vault.weth(), msg.sender, ethAmount, colAmount, usdpAmount);
1411     }
1412 
1413     /**
1414       * @notice Tx sender must have a sufficient USDP and COL balances and allowances to pay the debt
1415       * @dev Repays specified amount of debt paying fee in COL
1416       * @param asset The address of token using as main collateral
1417       * @param usdpAmount The amount of USDP token to repay
1418       **/
1419     function repayUsingCol(address asset, uint usdpAmount) public spawned(asset, msg.sender) nonReentrant {
1420         // check usefulness of tx
1421         require(usdpAmount != 0, "Unit Protocol: USELESS_TX");
1422 
1423         // COL token price in USD
1424         uint colUsdPrice_q112 = oracle.assetToUsd(vault.col(), 1);
1425 
1426         uint fee = vault.calculateFee(asset, msg.sender, usdpAmount);
1427         uint feeInCol = fee.mul(Q112).div(colUsdPrice_q112);
1428         vault.chargeFee(vault.col(), msg.sender, feeInCol);
1429         vault.repay(asset, msg.sender, usdpAmount);
1430 
1431         // fire an event
1432         emit Exit(asset, msg.sender, 0, 0, usdpAmount);
1433     }
1434 
1435     /**
1436       * @notice Tx sender must have a sufficient USDP and COL balances and allowances to pay the debt
1437       * @dev Withdraws collateral
1438       * @dev Repays specified amount of debt paying fee in COL
1439       * @param asset The address of token using as main collateral
1440       * @param mainAmount The amount of main collateral token to withdraw
1441       * @param colAmount The amount of COL token to withdraw
1442       * @param usdpAmount The amount of USDP token to repay
1443       **/
1444     function withdrawAndRepayUsingCol(
1445         address asset,
1446         uint mainAmount,
1447         uint colAmount,
1448         uint usdpAmount
1449     )
1450     public
1451     spawned(asset, msg.sender)
1452     nonReentrant
1453     {
1454         // check usefulness of tx
1455         require(mainAmount != 0 || colAmount != 0, "Unit Protocol: USELESS_TX");
1456 
1457         // fix 'Stack too deep'
1458         {
1459             uint debt = vault.debts(asset, msg.sender);
1460             require(debt != 0 && usdpAmount != debt, "Unit Protocol: USE_REPAY_ALL_INSTEAD");
1461 
1462             if (mainAmount != 0) {
1463                 // withdraw main collateral to the user address
1464                 vault.withdrawMain(asset, msg.sender, mainAmount);
1465             }
1466 
1467             if (colAmount != 0) {
1468                 // withdraw COL tokens to the user's address
1469                 vault.withdrawCol(asset, msg.sender, colAmount);
1470             }
1471         }
1472 
1473         uint colDeposit = vault.colToken(asset, msg.sender);
1474 
1475         // main collateral value of the position in USD
1476         uint mainUsdValue_q112 = oracle.assetToUsd(asset, vault.collaterals(asset, msg.sender));
1477 
1478         // COL token value of the position in USD
1479         uint colUsdValue_q112 = oracle.assetToUsd(vault.col(), colDeposit);
1480 
1481         if (usdpAmount != 0) {
1482             uint fee = vault.calculateFee(asset, msg.sender, usdpAmount);
1483             uint feeInCol = fee.mul(Q112).mul(colDeposit).div(colUsdValue_q112);
1484             vault.chargeFee(vault.col(), msg.sender, feeInCol);
1485             vault.repay(asset, msg.sender, usdpAmount);
1486         }
1487 
1488         vault.update(asset, msg.sender);
1489 
1490         _ensureCollateralization(asset, msg.sender, mainUsdValue_q112, colUsdValue_q112);
1491 
1492         // fire an event
1493         emit Exit(asset, msg.sender, mainAmount, colAmount, usdpAmount);
1494     }
1495 
1496     /**
1497       * @notice Tx sender must have a sufficient USDP and COL balances to pay the debt
1498       * @dev Withdraws collateral converting WETH to ETH
1499       * @dev Repays specified amount of debt paying fee in COL
1500       * @param ethAmount The amount of ETH to withdraw
1501       * @param colAmount The amount of COL token to withdraw
1502       * @param usdpAmount The amount of USDP token to repay
1503       **/
1504     function withdrawAndRepayUsingCol_Eth(
1505         uint ethAmount,
1506         uint colAmount,
1507         uint usdpAmount
1508     )
1509     public
1510     spawned(vault.weth(), msg.sender)
1511     nonReentrant
1512     {
1513         // fix 'Stack too deep'
1514         {
1515             // check usefulness of tx
1516             require(ethAmount != 0 || colAmount != 0, "Unit Protocol: USELESS_TX");
1517 
1518             uint debt = vault.debts(vault.weth(), msg.sender);
1519             require(debt != 0 && usdpAmount != debt, "Unit Protocol: USE_REPAY_ALL_INSTEAD");
1520 
1521             if (ethAmount != 0) {
1522                 // withdraw main collateral to the user address
1523                 vault.withdrawEth(msg.sender, ethAmount);
1524             }
1525 
1526             if (colAmount != 0) {
1527                 // withdraw COL tokens to the user's address
1528                 vault.withdrawCol(vault.weth(), msg.sender, colAmount);
1529             }
1530         }
1531 
1532         uint colDeposit = vault.colToken(vault.weth(), msg.sender);
1533 
1534         // main collateral value of the position in USD
1535         uint mainUsdValue_q112 = oracle.assetToUsd(vault.weth(), vault.collaterals(vault.weth(), msg.sender));
1536 
1537         // COL token value of the position in USD
1538         uint colUsdValue_q112 = oracle.assetToUsd(vault.col(), colDeposit);
1539 
1540         if (usdpAmount != 0) {
1541             uint fee = vault.calculateFee(vault.weth(), msg.sender, usdpAmount);
1542             uint feeInCol = fee.mul(Q112).mul(colDeposit).div(colUsdValue_q112);
1543             vault.chargeFee(vault.col(), msg.sender, feeInCol);
1544             vault.repay(vault.weth(), msg.sender, usdpAmount);
1545         }
1546 
1547         vault.update(vault.weth(), msg.sender);
1548 
1549         _ensureCollateralization(vault.weth(), msg.sender, mainUsdValue_q112, colUsdValue_q112);
1550 
1551         // fire an event
1552         emit Exit(vault.weth(), msg.sender, ethAmount, colAmount, usdpAmount);
1553     }
1554 
1555     function _depositAndBorrow(
1556         address asset,
1557         address user,
1558         uint mainAmount,
1559         uint colAmount,
1560         uint usdpAmount
1561     )
1562     internal
1563     {
1564         if (mainAmount != 0) {
1565             vault.depositMain(asset, user, mainAmount);
1566         }
1567 
1568         if (colAmount != 0) {
1569             vault.depositCol(asset, user, colAmount);
1570         }
1571 
1572         // mint USDP to user
1573         vault.borrow(asset, user, usdpAmount);
1574 
1575         // check collateralization
1576         _ensurePositionCollateralization(asset, user);
1577     }
1578 
1579     function _depositAndBorrow_Eth(address user, uint colAmount, uint usdpAmount) internal {
1580         if (msg.value != 0) {
1581             vault.depositEth{value:msg.value}(user);
1582         }
1583 
1584         if (colAmount != 0) {
1585             vault.depositCol(vault.weth(), user, colAmount);
1586         }
1587 
1588         // mint USDP to user
1589         vault.borrow(vault.weth(), user, usdpAmount);
1590 
1591         _ensurePositionCollateralization_Eth(user);
1592     }
1593 
1594     function _ensurePositionCollateralization(
1595         address asset,
1596         address user
1597     )
1598     internal
1599     view
1600     {
1601         // main collateral value of the position in USD
1602         uint mainUsdValue_q112 = oracle.assetToUsd(asset, vault.collaterals(asset, user));
1603 
1604         // COL token value of the position in USD
1605         uint colUsdValue_q112 = oracle.assetToUsd(vault.col(), vault.colToken(asset, user));
1606 
1607         _ensureCollateralization(asset, user, mainUsdValue_q112, colUsdValue_q112);
1608     }
1609 
1610     function _ensurePositionCollateralization_Eth(address user) internal view {
1611         // ETH value of the position in USD
1612         uint ethUsdValue_q112 = oracle.ethToUsd(vault.collaterals(vault.weth(), user).mul(Q112));
1613 
1614         // COL token value of the position in USD
1615         uint colUsdValue_q112 = oracle.assetToUsd(vault.col(), vault.colToken(vault.weth(), user));
1616 
1617         _ensureCollateralization(vault.weth(), user, ethUsdValue_q112, colUsdValue_q112);
1618     }
1619 
1620     // ensures that borrowed value is in desired range
1621     function _ensureCollateralization(
1622         address asset,
1623         address user,
1624         uint mainUsdValue_q112,
1625         uint colUsdValue_q112
1626     )
1627     internal
1628     view
1629     {
1630         uint mainUsdUtilized_q112;
1631         uint colUsdUtilized_q112;
1632 
1633         uint minColPercent = vaultManagerParameters.minColPercent(asset);
1634         if (minColPercent != 0) {
1635             // main limit by COL
1636             uint mainUsdLimit_q112 = colUsdValue_q112 * (100 - minColPercent) / minColPercent;
1637             mainUsdUtilized_q112 = Math.min(mainUsdValue_q112, mainUsdLimit_q112);
1638         } else {
1639             mainUsdUtilized_q112 = mainUsdValue_q112;
1640         }
1641 
1642         uint maxColPercent = vaultManagerParameters.maxColPercent(asset);
1643         if (maxColPercent < 100) {
1644             // COL limit by main
1645             uint colUsdLimit_q112 = mainUsdValue_q112 * maxColPercent / (100 - maxColPercent);
1646             colUsdUtilized_q112 = Math.min(colUsdValue_q112, colUsdLimit_q112);
1647         } else {
1648             colUsdUtilized_q112 = colUsdValue_q112;
1649         }
1650 
1651         // USD limit of the position
1652         uint usdLimit = (
1653             mainUsdUtilized_q112 * vaultManagerParameters.initialCollateralRatio(asset) +
1654             colUsdUtilized_q112 * vaultManagerParameters.initialCollateralRatio(vault.col())
1655         ) / Q112 / 100;
1656 
1657         // revert if collateralization is not enough
1658         require(vault.getTotalDebt(asset, user) <= usdLimit, "Unit Protocol: UNDERCOLLATERALIZED");
1659     }
1660 }