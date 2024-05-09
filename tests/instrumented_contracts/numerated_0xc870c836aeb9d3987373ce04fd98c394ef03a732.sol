1 pragma solidity 0.5.11; // optimization runs: 200, evm version: petersburg
2 
3 
4 interface DharmaReserveManagerV2Interface {
5   event RoleModified(Role indexed role, address account);
6   event RolePaused(Role indexed role);
7   event RoleUnpaused(Role indexed role);
8 
9   enum Role {
10     DEPOSIT_MANAGER,
11     ADJUSTER,
12     PAUSER
13   }
14 
15   struct RoleStatus {
16     address account;
17     bool paused;
18   }
19 
20   function finalizeDaiDeposit(
21     address smartWallet, address initialUserSigningKey, uint256 daiAmount
22   ) external;
23 
24   function finalizeDharmaDaiDeposit(
25     address smartWallet, address initialUserSigningKey, uint256 dDaiAmount
26   ) external;
27 
28   function mint(uint256 daiAmount) external returns (uint256 dDaiMinted);
29   
30   function redeem(uint256 dDaiAmount) external returns (uint256 daiReceived);
31   
32   function tradeDDaiForUSDC(
33     uint256 daiEquivalentAmount,
34     uint256 quotedUSDCAmount
35   ) external returns (uint256 usdcReceived);
36   
37   function tradeUSDCForDDai(
38     uint256 usdcAmount,
39     uint256 quotedDaiEquivalentAmount
40   ) external returns (uint256 dDaiMinted);
41 
42   function withdrawUSDC(address recipient, uint256 usdcAmount) external;
43 
44   function withdrawDai(address recipient, uint256 daiAmount) external;
45 
46   function withdrawDharmaDai(address recipient, uint256 dDaiAmount) external;
47 
48   function withdraw(
49     ERC20Interface token, address recipient, uint256 amount
50   ) external returns (bool success);
51 
52   function call(
53     address payable target, uint256 amount, bytes calldata data
54   ) external returns (bool ok, bytes memory returnData);
55   
56   function setLimit(uint256 daiAmount) external;
57 
58   function setRole(Role role, address account) external;
59 
60   function removeRole(Role role) external;
61 
62   function pause(Role role) external;
63 
64   function unpause(Role role) external;
65 
66   function isPaused(Role role) external view returns (bool paused);
67 
68   function isRole(Role role) external view returns (bool hasRole);
69 
70   function isDharmaSmartWallet(
71     address smartWallet, address initialUserSigningKey
72   ) external view returns (bool dharmaSmartWallet);
73 
74   function getDepositManager() external view returns (address operator);
75 
76   function getAdjuster() external view returns (address recoverer);
77 
78   function getPauser() external view returns (address pauser);
79   
80   function getReserves() external view returns (
81     uint256 dai, uint256 dDai, uint256 dDaiUnderlying
82   );
83   
84   function getLimit() external view returns (
85     uint256 daiAmount, uint256 dDaiAmount
86   );
87 }
88 
89 interface ERC20Interface {
90   function balanceOf(address) external view returns (uint256);
91   function approve(address, uint256) external returns (bool);
92   function transfer(address, uint256) external returns (bool);
93 }
94 
95 interface DTokenInterface {
96   function mint(uint256 underlyingToSupply) external returns (uint256 dTokensMinted);
97   function redeem(uint256 dTokensToBurn) external returns (uint256 underlyingReceived);
98   function redeemUnderlying(uint256 underlyingToReceive) external returns (uint256 dTokensBurned);
99   function balanceOf(address) external view returns (uint256);
100   function balanceOfUnderlying(address) external view returns (uint256);
101   function transfer(address, uint256) external returns (bool);
102   function approve(address, uint256) external returns (bool);
103   function exchangeRateCurrent() external view returns (uint256);
104 }
105 
106 interface TradeHelperInterface {
107   function tradeUSDCForDDai(uint256 amountUSDC, uint256 quotedDaiEquivalentAmount) external returns (uint256 dDaiMinted);
108   function tradeDDaiForUSDC(uint256 amountDai, uint256 quotedUSDCAmount) external returns (uint256 usdcReceived);
109   function getExpectedDai(uint256 usdc) external view returns (uint256 dai);
110   function getExpectedUSDC(uint256 dai) external view returns (uint256 usdc);
111 }
112 
113 
114 library SafeMath {
115   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
116     if (a == 0) return 0;
117     uint256 c = a * b;
118     require(c / a == b, "SafeMath: multiplication overflow");
119     return c;
120   }
121 
122   function div(uint256 a, uint256 b) internal pure returns (uint256) {
123     require(b > 0, "SafeMath: division by zero");
124     return a / b;
125   }
126 }
127 
128 
129 /**
130  * @dev Contract module which provides a basic access control mechanism, where
131  * there is an account (an owner) that can be granted exclusive access to
132  * specific functions.
133  *
134  * This module is used through inheritance. It will make available the modifier
135  * `onlyOwner`, which can be aplied to your functions to restrict their use to
136  * the owner.
137  *
138  * In order to transfer ownership, a recipient must be specified, at which point
139  * the specified recipient can call `acceptOwnership` and take ownership.
140  */
141 contract TwoStepOwnable {
142   event OwnershipTransferred(
143     address indexed previousOwner,
144     address indexed newOwner
145   );
146 
147   address private _owner;
148 
149   address private _newPotentialOwner;
150 
151   /**
152    * @dev Initialize contract by setting transaction submitter as initial owner.
153    */
154   constructor() internal {
155     _owner = tx.origin;
156     emit OwnershipTransferred(address(0), _owner);
157   }
158 
159   /**
160    * @dev Allows a new account (`newOwner`) to accept ownership.
161    * Can only be called by the current owner.
162    */
163   function transferOwnership(address newOwner) external onlyOwner {
164     require(
165       newOwner != address(0),
166       "TwoStepOwnable: new potential owner is the zero address."
167     );
168 
169     _newPotentialOwner = newOwner;
170   }
171 
172   /**
173    * @dev Cancel a transfer of ownership to a new account.
174    * Can only be called by the current owner.
175    */
176   function cancelOwnershipTransfer() external onlyOwner {
177     delete _newPotentialOwner;
178   }
179 
180   /**
181    * @dev Transfers ownership of the contract to the caller.
182    * Can only be called by a new potential owner set by the current owner.
183    */
184   function acceptOwnership() external {
185     require(
186       msg.sender == _newPotentialOwner,
187       "TwoStepOwnable: current owner must set caller as new potential owner."
188     );
189 
190     delete _newPotentialOwner;
191 
192     emit OwnershipTransferred(_owner, msg.sender);
193 
194     _owner = msg.sender;
195   }
196 
197   /**
198    * @dev Returns the address of the current owner.
199    */
200   function owner() external view returns (address) {
201     return _owner;
202   }
203 
204   /**
205    * @dev Returns true if the caller is the current owner.
206    */
207   function isOwner() public view returns (bool) {
208     return msg.sender == _owner;
209   }
210 
211   /**
212    * @dev Throws if called by any account other than the owner.
213    */
214   modifier onlyOwner() {
215     require(isOwner(), "TwoStepOwnable: caller is not the owner.");
216     _;
217   }
218 }
219 
220 
221 /**
222  * @title DharmaReserveManagerV2
223  * @author 0age
224  * @notice This contract is owned by the Dharma Reserve Manager multisig and
225  * manages Dharma's reserves. It designates a collection of "roles" - these are
226  * dedicated accounts that can be modified by the owner, and that can trigger
227  * specific functionality on the manager. These roles are:
228  *  - depositManager (0): initiates token transfers to smart wallets
229  *  - adjuster (1): mints / redeems Dai, and swaps USDC, for dDai
230  *  - pauser (2): pauses any role (only the owner is then able to unpause it)
231  *
232  * When finalizing deposits, the deposit manager must adhere to two constraints:
233  *  - it must provide "proof" that the recipient is a smart wallet by including
234  *    the initial user signing key used to derive the smart wallet address
235  *  - it must not attempt to transfer more Dai, or more than the Dai-equivalent
236  *    value of Dharma Dai, than the current "limit" set by the owner.
237  *
238  * Reserves can be retrieved via `getReserves`, the current limit can be
239  * retrieved via `getLimit`, and "proofs" can be validated via `isSmartWallet`.
240  */
241 contract DharmaReserveManagerV2 is DharmaReserveManagerV2Interface, TwoStepOwnable {
242   using SafeMath for uint256;
243 
244   // Maintain a role status mapping with assigned accounts and paused states.
245   mapping(uint256 => RoleStatus) private _roles;
246   
247   // Maintain a maximum allowable transfer size (in Dai) for the deposit manager.
248   uint256 private _limit;
249 
250   // This contract interacts with USDC, Dai, and Dharma Dai.
251   ERC20Interface internal constant _USDC = ERC20Interface(
252     0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48 // mainnet
253   );
254 
255   ERC20Interface internal constant _DAI = ERC20Interface(
256     0x6B175474E89094C44Da98b954EedeAC495271d0F // mainnet
257   );
258 
259   DTokenInterface internal constant _DDAI = DTokenInterface(
260     0x00000000001876eB1444c986fD502e618c587430
261   );
262   
263   TradeHelperInterface internal constant _TRADE_HELPER = TradeHelperInterface(
264     0x9328F2Fb3e85A4d24Adc2f68F82737183e85691d
265   );
266 
267   // The "Create2 Header" is used to compute smart wallet deployment addresses.
268   bytes21 internal constant _CREATE2_HEADER = bytes21(
269     0xfffc00c80b0000007f73004edb00094cad80626d8d // control character + factory
270   );
271   
272   // The "Wallet creation code" header & footer are also used to derive wallets.
273   bytes internal constant _WALLET_CREATION_CODE_HEADER = hex"60806040526040516104423803806104428339818101604052602081101561002657600080fd5b810190808051604051939291908464010000000082111561004657600080fd5b90830190602082018581111561005b57600080fd5b825164010000000081118282018810171561007557600080fd5b82525081516020918201929091019080838360005b838110156100a257818101518382015260200161008a565b50505050905090810190601f1680156100cf5780820380516001836020036101000a031916815260200191505b5060405250505060006100e661019e60201b60201c565b6001600160a01b0316826040518082805190602001908083835b6020831061011f5780518252601f199092019160209182019101610100565b6001836020036101000a038019825116818451168082178552505050505050905001915050600060405180830381855af49150503d806000811461017f576040519150601f19603f3d011682016040523d82523d6000602084013e610184565b606091505b5050905080610197573d6000803e3d6000fd5b50506102be565b60405160009081906060906e26750c571ce882b17016557279adaa9083818181855afa9150503d80600081146101f0576040519150601f19603f3d011682016040523d82523d6000602084013e6101f5565b606091505b509150915081819061029f576040517f08c379a00000000000000000000000000000000000000000000000000000000081526004018080602001828103825283818151815260200191508051906020019080838360005b8381101561026457818101518382015260200161024c565b50505050905090810190601f1680156102915780820380516001836020036101000a031916815260200191505b509250505060405180910390fd5b508080602001905160208110156102b557600080fd5b50519392505050565b610175806102cd6000396000f3fe608060405261001461000f610016565b61011c565b005b60405160009081906060906e26750c571ce882b17016557279adaa9083818181855afa9150503d8060008114610068576040519150601f19603f3d011682016040523d82523d6000602084013e61006d565b606091505b50915091508181906100fd5760405162461bcd60e51b81526004018080602001828103825283818151815260200191508051906020019080838360005b838110156100c25781810151838201526020016100aa565b50505050905090810190601f1680156100ef5780820380516001836020036101000a031916815260200191505b509250505060405180910390fd5b5080806020019051602081101561011357600080fd5b50519392505050565b3660008037600080366000845af43d6000803e80801561013b573d6000f35b3d6000fdfea265627a7a7231582020202020202055706772616465426561636f6e50726f7879563120202020202064736f6c634300050b003200000000000000000000000000000000000000000000000000000000000000200000000000000000000000000000000000000000000000000000000000000024c4d66de8000000000000000000000000";
274   bytes28 internal constant _WALLET_CREATION_CODE_FOOTER = bytes28(
275     0x00000000000000000000000000000000000000000000000000000000
276   );
277 
278   /**
279    * @notice In the constructor, set the initial owner to the transaction
280    * submitter and initial minimum timelock interval and default timelock
281    * expiration values.
282    */
283   constructor() public {
284     // Call Dai to set an allowance for Dharma Dai in order to mint dDai.
285     require(_DAI.approve(address(_DDAI), uint256(-1)));
286     
287     // Call USDC to set an allowance for the trade helper contract.
288     require(_USDC.approve(address(_TRADE_HELPER), uint256(-1)));
289   
290     // Call dDai to set an allowance for the trade helper contract.
291     require(_DDAI.approve(address(_TRADE_HELPER), uint256(-1)));  
292     
293     // Set the initial limit to 300 Dai.
294     _limit = 300 * 1e18;
295   }
296 
297   /**
298    * @notice Transfer `daiAmount` Dai to `smartWallet`, providing the initial
299    * user signing key `initialUserSigningKey` as proof that the specified smart
300    * wallet is indeed a Dharma Smart Wallet - this assumes that the address is
301    * derived and deployed using the Dharma Smart Wallet Factory V1. In addition,
302    * the specified amount must be less than the configured limit amount. Only
303    * the owner or the designated deposit manager role may call this function.
304    * @param smartWallet address The smart wallet to transfer Dai to.
305    * @param initialUserSigningKey address The initial user signing key supplied
306    * when deriving the smart wallet address - this could be an EOA or a Dharma
307    * key ring address.
308    * @param daiAmount uint256 The amount of Dai to transfer - this must be less
309    * than the current limit.
310    */
311   function finalizeDaiDeposit(
312     address smartWallet, address initialUserSigningKey, uint256 daiAmount
313   ) external onlyOwnerOr(Role.DEPOSIT_MANAGER) {
314     // Ensure that the recipient is indeed a smart wallet.
315     require(
316       _isSmartWallet(smartWallet, initialUserSigningKey),
317       "Could not resolve smart wallet using provided signing key."
318     );
319     
320     // Ensure that the amount to transfer is lower than the limit.
321     require(daiAmount < _limit, "Transfer size exceeds the limit.");
322     
323     // Transfer the Dai to the specified smart wallet.
324     require(_DAI.transfer(smartWallet, daiAmount), "Dai transfer failed.");
325   }
326 
327   /**
328    * @notice Transfer `dDaiAmount` Dharma Dai to `smartWallet`, providing the
329    * initial user signing key `initialUserSigningKey` as proof that the
330    * specified smart wallet is indeed a Dharma Smart Wallet - this assumes that
331    * the address is derived and deployed using the Dharma Smart Wallet Factory
332    * V1. In addition, the Dai equivalent value of the specified dDai amount must
333    * be less than the configured limit amount. Only the owner or the designated
334    * deposit manager role may call this function.
335    * @param smartWallet address The smart wallet to transfer Dai to.
336    * @param initialUserSigningKey address The initial user signing key supplied
337    * when deriving the smart wallet address - this could be an EOA or a Dharma
338    * key ring address.
339    * @param dDaiAmount uint256 The amount of Dharma Dai to transfer - the Dai
340    * equivalent amount must be less than the current limit.
341    */
342   function finalizeDharmaDaiDeposit(
343     address smartWallet, address initialUserSigningKey, uint256 dDaiAmount
344   ) external onlyOwnerOr(Role.DEPOSIT_MANAGER) {
345     // Ensure that the recipient is indeed a smart wallet.
346     require(
347       _isSmartWallet(smartWallet, initialUserSigningKey),
348       "Could not resolve smart wallet using provided signing key."
349     );
350     
351     // Get the current dDai exchange rate.
352     uint256 exchangeRate = _DDAI.exchangeRateCurrent();
353 
354     // Ensure that an exchange rate was actually returned.
355     require(exchangeRate != 0, "Could not retrieve dDai exchange rate.");
356     
357     // Get the equivalent Dai amount of the transfer.
358     uint256 daiEquivalent = (dDaiAmount.mul(exchangeRate)) / 1e18;
359     
360     // Ensure that the amount to transfer is lower than the limit.
361     require(daiEquivalent < _limit, "Transfer size exceeds the limit.");
362 
363     // Transfer the dDai to the specified smart wallet.
364     require(_DDAI.transfer(smartWallet, dDaiAmount), "dDai transfer failed.");
365   }
366 
367   /**
368    * @notice Use `daiAmount` Dai mint Dharma Dai. Only the owner or the
369    * designated adjuster role may call this function.
370    * @param daiAmount uint256 The amount of Dai to supply when minting Dharma
371    * Dai.
372    * @return The amount of Dharma Dai minted.
373    */
374   function mint(
375     uint256 daiAmount
376   ) external onlyOwnerOr(Role.ADJUSTER) returns (uint256 dDaiMinted) {
377     // Use the specified amount of Dai to mint dDai.
378     dDaiMinted = _DDAI.mint(daiAmount);
379   }
380 
381   /**
382    * @notice Redeem `dDaiAmount` Dharma Dai for Dai. Only the owner or the
383    * designated adjuster role may call this function.
384    * @param dDaiAmount uint256 The amount of Dharma Dai to supply when redeeming
385    * for Dai.
386    * @return The amount of Dai received.
387    */ 
388   function redeem(
389     uint256 dDaiAmount
390   ) external onlyOwnerOr(Role.ADJUSTER) returns (uint256 daiReceived) {
391     // Redeem the specified amount of dDai for Dai.
392     daiReceived = _DDAI.redeem(dDaiAmount);
393   }
394   
395   /**
396    * @notice tradeUSDCForDDai `usdcAmount` USDC for Dharma Dai. Only the owner or the
397    * designated adjuster role may call this function.
398    * @param usdcAmount uint256 The amount of USDC to supply when trading for Dharma Dai.
399    * @param quotedDaiEquivalentAmount uint256 The expected DAI equivalent value of the
400    * received dDai - this value is returned from the `getAndExpectedDai` view function
401    * on the trade helper.
402    * @return The amount of dDai received.
403    */ 
404   function tradeUSDCForDDai(
405     uint256 usdcAmount,
406     uint256 quotedDaiEquivalentAmount
407   ) external onlyOwnerOr(Role.ADJUSTER) returns (uint256 dDaiMinted) {
408     dDaiMinted = _TRADE_HELPER.tradeUSDCForDDai(
409        usdcAmount, quotedDaiEquivalentAmount
410     );
411   }
412 
413   /**
414    * @notice tradeDDaiForUSDC `daiEquivalentAmount` Dai amount to trade in Dharma Dai
415    * for USDC. Only the owner or the designated adjuster role may call this function.
416    * @param daiEquivalentAmount uint256 The Dai equivalent amount to supply in Dharma
417    * Dai when trading for USDC.
418    * @param quotedUSDCAmount uint256 The expected USDC received in exchange for
419    * dDai - this value is returned from the `getExpectedUSDC` view function on the
420    * trade helper.
421    * @return The amount of USDC received.
422    */ 
423   function tradeDDaiForUSDC(
424     uint256 daiEquivalentAmount,
425     uint256 quotedUSDCAmount
426   ) external onlyOwnerOr(Role.ADJUSTER) returns (uint256 usdcReceived) {
427     usdcReceived = _TRADE_HELPER.tradeDDaiForUSDC(
428        daiEquivalentAmount, quotedUSDCAmount
429     );
430   }
431 
432   /**
433    * @notice Transfer `usdcAmount` USDC to `recipient`. Only the owner may call
434    * this function.
435    * @param recipient address The account to transfer USDC to.
436    * @param usdcAmount uint256 The amount of USDC to transfer.
437    */
438   function withdrawUSDC(
439     address recipient, uint256 usdcAmount
440   ) external onlyOwner {
441     // Transfer the USDC to the specified recipient.
442     require(_USDC.transfer(recipient, usdcAmount), "USDC transfer failed.");
443   }
444 
445   /**
446    * @notice Transfer `daiAmount` Dai to `recipient`. Only the owner may call
447    * this function.
448    * @param recipient address The account to transfer Dai to.
449    * @param daiAmount uint256 The amount of Dai to transfer.
450    */
451   function withdrawDai(
452     address recipient, uint256 daiAmount
453   ) external onlyOwner {
454     // Transfer the Dai to the specified recipient.
455     require(_DAI.transfer(recipient, daiAmount), "Dai transfer failed.");
456   }
457 
458   /**
459    * @notice Transfer `dDaiAmount` Dharma Dai to `recipient`. Only the owner may
460    * call this function.
461    * @param recipient address The account to transfer Dharma Dai to.
462    * @param dDaiAmount uint256 The amount of Dharma Dai to transfer.
463    */
464   function withdrawDharmaDai(
465     address recipient, uint256 dDaiAmount
466   ) external onlyOwner {
467     // Transfer the dDai to the specified recipient.
468     require(_DDAI.transfer(recipient, dDaiAmount), "dDai transfer failed.");
469   }
470 
471   /**
472    * @notice Transfer `amount` of ERC20 token `token` to `recipient`. Only the
473    * owner may call this function.
474    * @param token ERC20Interface The ERC20 token to transfer.
475    * @param recipient address The account to transfer the tokens to.
476    * @param amount uint256 The amount of tokens to transfer.
477    * @return A boolean to indicate if the transfer was successful - note that
478    * unsuccessful ERC20 transfers will usually revert.
479    */
480   function withdraw(
481     ERC20Interface token, address recipient, uint256 amount
482   ) external onlyOwner returns (bool success) {
483     // Transfer the token to the specified recipient.
484     success = token.transfer(recipient, amount);
485   }
486 
487   /**
488    * @notice Call account `target`, supplying value `amount` and data `data`.
489    * Only the owner may call this function.
490    * @param target address The account to call.
491    * @param amount uint256 The amount of ether to include as an endowment.
492    * @param data bytes The data to include along with the call.
493    * @return A boolean to indicate if the call was successful, as well as the
494    * returned data or revert reason.
495    */
496   function call(
497     address payable target, uint256 amount, bytes calldata data
498   ) external onlyOwner returns (bool ok, bytes memory returnData) {
499     // Call the specified target and supply the specified data.
500     (ok, returnData) = target.call.value(amount)(data);
501   }
502 
503   /**
504    * @notice Set `daiAmount` as the new limit on the size of finalized deposits.
505    * Only the owner may call this function.
506    * @param daiAmount uint256 The new limit on the size of finalized deposits.
507    */
508   function setLimit(uint256 daiAmount) external onlyOwner {
509     // Set the new limit.
510     _limit = daiAmount;
511   }
512 
513   /**
514    * @notice Pause a currently unpaused role and emit a `RolePaused` event. Only
515    * the owner or the designated pauser may call this function. Also, bear in
516    * mind that only the owner may unpause a role once paused.
517    * @param role The role to pause. Permitted roles are deposit manager (0),
518    * adjuster (1), and pauser (2).
519    */
520   function pause(Role role) external onlyOwnerOr(Role.PAUSER) {
521     RoleStatus storage storedRoleStatus = _roles[uint256(role)];
522     require(!storedRoleStatus.paused, "Role in question is already paused.");
523     storedRoleStatus.paused = true;
524     emit RolePaused(role);
525   }
526 
527   /**
528    * @notice Unpause a currently paused role and emit a `RoleUnpaused` event.
529    * Only the owner may call this function.
530    * @param role The role to pause. Permitted roles are deposit manager (0),
531    * adjuster (1), and pauser (2).
532    */
533   function unpause(Role role) external onlyOwner {
534     RoleStatus storage storedRoleStatus = _roles[uint256(role)];
535     require(storedRoleStatus.paused, "Role in question is already unpaused.");
536     storedRoleStatus.paused = false;
537     emit RoleUnpaused(role);
538   }
539 
540   /**
541    * @notice Set a new account on a given role and emit a `RoleModified` event
542    * if the role holder has changed. Only the owner may call this function.
543    * @param role The role that the account will be set for. Permitted roles are
544    * deposit manager (0), adjuster (1), and pauser (2).
545    * @param account The account to set as the designated role bearer.
546    */
547   function setRole(Role role, address account) external onlyOwner {
548     require(account != address(0), "Must supply an account.");
549     _setRole(role, account);
550   }
551 
552   /**
553    * @notice Remove any current role bearer for a given role and emit a
554    * `RoleModified` event if a role holder was previously set. Only the owner
555    * may call this function.
556    * @param role The role that the account will be removed from. Permitted roles
557    * are deposit manager (0), adjuster (1), and pauser (2).
558    */
559   function removeRole(Role role) external onlyOwner {
560     _setRole(role, address(0));
561   }
562 
563   /**
564    * @notice External view function to check whether or not the functionality
565    * associated with a given role is currently paused or not. The owner or the
566    * pauser may pause any given role (including the pauser itself), but only the
567    * owner may unpause functionality. Additionally, the owner may call paused
568    * functions directly.
569    * @param role The role to check the pause status on. Permitted roles are
570    * deposit manager (0), adjuster (1), and pauser (2).
571    * @return A boolean to indicate if the functionality associated with the role
572    * in question is currently paused.
573    */
574   function isPaused(Role role) external view returns (bool paused) {
575     paused = _isPaused(role);
576   }
577 
578   /**
579    * @notice External view function to check whether the caller is the current
580    * role holder.
581    * @param role The role to check for. Permitted roles are deposit manager (0),
582    * adjuster (1), and pauser (2).
583    * @return A boolean indicating if the caller has the specified role.
584    */
585   function isRole(Role role) external view returns (bool hasRole) {
586     hasRole = _isRole(role);
587   }
588 
589   /**
590    * @notice External view function to check whether a "proof" that a given
591    * smart wallet is actually a Dharma Smart Wallet, based on the initial user
592    * signing key, is valid or not. This proof only works when the Dharma Smart
593    * Wallet in question is derived using V1 of the Dharma Smart Wallet Factory.
594    * @param smartWallet address The smart wallet to check.
595    * @param initialUserSigningKey address The initial user signing key supplied
596    * when deriving the smart wallet address - this could be an EOA or a Dharma
597    * key ring address.
598    * @return A boolean indicating if the specified smart wallet account is
599    * indeed a smart wallet based on the specified initial user signing key.
600    */
601   function isDharmaSmartWallet(
602     address smartWallet, address initialUserSigningKey
603   ) external view returns (bool dharmaSmartWallet) {
604     dharmaSmartWallet = _isSmartWallet(smartWallet, initialUserSigningKey);
605   }
606 
607   /**
608    * @notice External view function to check the account currently holding the
609    * deposit manager role. The deposit manager can process standard deposit
610    * finalization via `finalizeDaiDeposit` and `finalizeDharmaDaiDeposit`, but
611    * must prove that the recipient is a Dharma Smart Wallet and adhere to the
612    * current deposit size limit.
613    * @return The address of the current deposit manager, or the null address if
614    * none is set.
615    */
616   function getDepositManager() external view returns (address depositManager) {
617     depositManager = _roles[uint256(Role.DEPOSIT_MANAGER)].account;
618   }
619 
620   /**
621    * @notice External view function to check the account currently holding the
622    * adjuster role. The adjuster can exchange Dai in reserves for Dharma Dai and
623    * vice-versa via minting or redeeming.
624    * @return The address of the current adjuster, or the null address if none is
625    * set.
626    */
627   function getAdjuster() external view returns (address adjuster) {
628     adjuster = _roles[uint256(Role.ADJUSTER)].account;
629   }
630 
631   /**
632    * @notice External view function to check the account currently holding the
633    * pauser role. The pauser can pause any role from taking its standard action,
634    * though the owner will still be able to call the associated function in the
635    * interim and is the only entity able to unpause the given role once paused.
636    * @return The address of the current pauser, or the null address if none is
637    * set.
638    */
639   function getPauser() external view returns (address pauser) {
640     pauser = _roles[uint256(Role.PAUSER)].account;
641   }
642 
643   /**
644    * @notice External view function to check the current reserves held by this
645    * contract.
646    * @return The Dai and Dharma Dai reserves held by this contract, as well as
647    * the Dai-equivalent value of the Dharma Dai reserves.
648    */ 
649   function getReserves() external view returns (
650     uint256 dai, uint256 dDai, uint256 dDaiUnderlying
651   ) {
652     dai = _DAI.balanceOf(address(this));
653     dDai = _DDAI.balanceOf(address(this));
654     dDaiUnderlying = _DDAI.balanceOfUnderlying(address(this));
655   }
656 
657   /**
658    * @notice External view function to check the current limit on deposit amount
659    * enforced for the deposit manager when finalizing deposits, expressed in Dai
660    * and in Dharma Dai.
661    * @return The Dai and Dharma Dai limit on deposit finalization amount.
662    */  
663   function getLimit() external view returns (
664     uint256 daiAmount, uint256 dDaiAmount
665   ) {
666     daiAmount = _limit;
667     dDaiAmount = (daiAmount.mul(1e18)).div(_DDAI.exchangeRateCurrent());   
668   }
669 
670   /**
671    * @notice Internal function to set a new account on a given role and emit a
672    * `RoleModified` event if the role holder has changed.
673    * @param role The role that the account will be set for. Permitted roles are
674    * deposit manager (0), adjuster (1), and pauser (2).
675    * @param account The account to set as the designated role bearer.
676    */
677   function _setRole(Role role, address account) internal {
678     RoleStatus storage storedRoleStatus = _roles[uint256(role)];
679 
680     if (account != storedRoleStatus.account) {
681       storedRoleStatus.account = account;
682       emit RoleModified(role, account);
683     }
684   }
685 
686   /**
687    * @notice Internal view function to check whether the caller is the current
688    * role holder.
689    * @param role The role to check for. Permitted roles are deposit manager (0),
690    * adjuster (1), and pauser (2).
691    * @return A boolean indicating if the caller has the specified role.
692    */
693   function _isRole(Role role) internal view returns (bool hasRole) {
694     hasRole = msg.sender == _roles[uint256(role)].account;
695   }
696 
697   /**
698    * @notice Internal view function to check whether the given role is paused or
699    * not.
700    * @param role The role to check for. Permitted roles are deposit manager (0),
701    * adjuster (1), and pauser (2).
702    * @return A boolean indicating if the specified role is paused or not.
703    */
704   function _isPaused(Role role) internal view returns (bool paused) {
705     paused = _roles[uint256(role)].paused;
706   }
707 
708   /**
709    * @notice Internal view function to enforce that the given initial user signing
710    * key resolves to the given smart wallet when deployed through the Dharma Smart
711    * Wallet Factory V1.
712    * @param smartWallet address The smart wallet.
713    * @param initialUserSigningKey address The initial user signing key.
714    */
715   function _isSmartWallet(
716     address smartWallet, address initialUserSigningKey
717   ) internal pure returns (bool) {
718     // Derive the keccak256 hash of the smart wallet initialization code.
719     bytes32 initCodeHash = keccak256(
720       abi.encodePacked(
721         _WALLET_CREATION_CODE_HEADER,
722         initialUserSigningKey,
723         _WALLET_CREATION_CODE_FOOTER
724       )
725     );
726 
727     // Attempt to derive a smart wallet address that matches the one provided.
728     address target;
729     for (uint256 nonce = 0; nonce < 10; nonce++) {
730       target = address(          // derive the target deployment address.
731         uint160(                 // downcast to match the address type.
732           uint256(               // cast to uint to truncate upper digits.
733             keccak256(           // compute CREATE2 hash using all inputs.
734               abi.encodePacked(  // pack all inputs to the hash together.
735                 _CREATE2_HEADER, // pass in control character + factory address.
736                 nonce,           // pass in current nonce as the salt.
737                 initCodeHash     // pass in hash of contract creation code.
738               )
739             )
740           )
741         )
742       );
743 
744       // Exit early if the provided smart wallet matches derived target address.
745       if (target == smartWallet) {
746         return true;
747       }
748 
749       // Otherwise, increment the nonce and derive a new salt.
750       nonce++;
751     }
752 
753     // Explicity recognize no target was found matching provided smart wallet.
754     return false;
755   }
756 
757   /**
758    * @notice Modifier that throws if called by any account other than the owner
759    * or the supplied role, or if the caller is not the owner and the role in
760    * question is paused.
761    * @param role The role to require unless the caller is the owner. Permitted
762    * roles are deposit manager (0), adjuster (1), and pauser (2).
763    */
764   modifier onlyOwnerOr(Role role) {
765     if (!isOwner()) {
766       require(_isRole(role), "Caller does not have a required role.");
767       require(!_isPaused(role), "Role in question is currently paused.");
768     }
769     _;
770   }
771 }