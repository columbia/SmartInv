1 pragma solidity 0.5.11; // optimization runs: 200, evm version: petersburg
2 
3 
4 interface DharmaReserveManagerV3Interface {
5   event RoleModified(Role indexed role, address account);
6   event RolePaused(Role indexed role);
7   event RoleUnpaused(Role indexed role);
8 
9   enum Role {
10     DEPOSIT_MANAGER,
11     ADJUSTER,
12     WITHDRAWAL_MANAGER,
13     PAUSER
14   }
15 
16   struct RoleStatus {
17     address account;
18     bool paused;
19   }
20 
21   function finalizeDaiDeposit(
22     address smartWallet, address initialUserSigningKey, uint256 daiAmount
23   ) external;
24 
25   function finalizeDharmaDaiDeposit(
26     address smartWallet, address initialUserSigningKey, uint256 dDaiAmount
27   ) external;
28 
29   function mint(uint256 daiAmount) external returns (uint256 dDaiMinted);
30   
31   function redeem(uint256 dDaiAmount) external returns (uint256 daiReceived);
32   
33   function tradeDDaiForUSDC(
34     uint256 daiEquivalentAmount,
35     uint256 quotedUSDCAmount
36   ) external returns (uint256 usdcReceived);
37   
38   function tradeUSDCForDDai(
39     uint256 usdcAmount,
40     uint256 quotedDaiEquivalentAmount
41   ) external returns (uint256 dDaiMinted);
42 
43   function withdrawUSDC(address recipient, uint256 usdcAmount) external;
44 
45   function withdrawDai(address recipient, uint256 daiAmount) external;
46 
47   function withdrawDharmaDai(address recipient, uint256 dDaiAmount) external;
48 
49   function withdrawUSDCToPrimaryRecipient(uint256 usdcAmount) external;
50 
51   function withdraw(
52     ERC20Interface token, address recipient, uint256 amount
53   ) external returns (bool success);
54 
55   function call(
56     address payable target, uint256 amount, bytes calldata data
57   ) external returns (bool ok, bytes memory returnData);
58   
59   function setLimit(uint256 daiAmount) external;
60 
61   function setPrimaryRecipient(address recipient) external;
62 
63   function setRole(Role role, address account) external;
64 
65   function removeRole(Role role) external;
66 
67   function pause(Role role) external;
68 
69   function unpause(Role role) external;
70 
71   function isPaused(Role role) external view returns (bool paused);
72 
73   function isRole(Role role) external view returns (bool hasRole);
74 
75   function isDharmaSmartWallet(
76     address smartWallet, address initialUserSigningKey
77   ) external view returns (bool dharmaSmartWallet);
78 
79   function getDepositManager() external view returns (address depositManager);
80 
81   function getAdjuster() external view returns (address recoverer);
82 
83   function getWithdrawalManager() external view returns (address withdrawalManager);
84 
85   function getPauser() external view returns (address pauser);
86   
87   function getReserves() external view returns (
88     uint256 dai, uint256 dDai, uint256 dDaiUnderlying
89   );
90   
91   function getLimit() external view returns (
92     uint256 daiAmount, uint256 dDaiAmount
93   );
94   
95   function getPrimaryRecipient() external view returns (
96     address recipient
97   );
98 }
99 
100 
101 interface ERC20Interface {
102   function balanceOf(address) external view returns (uint256);
103   function approve(address, uint256) external returns (bool);
104   function transfer(address, uint256) external returns (bool);
105 }
106 
107 
108 interface DTokenInterface {
109   function mint(uint256 underlyingToSupply) external returns (uint256 dTokensMinted);
110   function redeem(uint256 dTokensToBurn) external returns (uint256 underlyingReceived);
111   function redeemUnderlying(uint256 underlyingToReceive) external returns (uint256 dTokensBurned);
112   function balanceOf(address) external view returns (uint256);
113   function balanceOfUnderlying(address) external view returns (uint256);
114   function transfer(address, uint256) external returns (bool);
115   function approve(address, uint256) external returns (bool);
116   function exchangeRateCurrent() external view returns (uint256);
117 }
118 
119 
120 interface TradeHelperInterface {
121   function tradeUSDCForDDai(uint256 amountUSDC, uint256 quotedDaiEquivalentAmount) external returns (uint256 dDaiMinted);
122   function tradeDDaiForUSDC(uint256 amountDai, uint256 quotedUSDCAmount) external returns (uint256 usdcReceived);
123   function getExpectedDai(uint256 usdc) external view returns (uint256 dai);
124   function getExpectedUSDC(uint256 dai) external view returns (uint256 usdc);
125 }
126 
127 
128 library SafeMath {
129   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
130     if (a == 0) return 0;
131     uint256 c = a * b;
132     require(c / a == b, "SafeMath: multiplication overflow");
133     return c;
134   }
135 
136   function div(uint256 a, uint256 b) internal pure returns (uint256) {
137     require(b > 0, "SafeMath: division by zero");
138     return a / b;
139   }
140 }
141 
142 
143 /**
144  * @dev Contract module which provides a basic access control mechanism, where
145  * there is an account (an owner) that can be granted exclusive access to
146  * specific functions.
147  *
148  * This module is used through inheritance. It will make available the modifier
149  * `onlyOwner`, which can be aplied to your functions to restrict their use to
150  * the owner.
151  *
152  * In order to transfer ownership, a recipient must be specified, at which point
153  * the specified recipient can call `acceptOwnership` and take ownership.
154  */
155 contract TwoStepOwnable {
156   event OwnershipTransferred(
157     address indexed previousOwner,
158     address indexed newOwner
159   );
160 
161   address private _owner;
162 
163   address private _newPotentialOwner;
164 
165   /**
166    * @dev Initialize contract by setting transaction submitter as initial owner.
167    */
168   constructor() internal {
169     _owner = tx.origin;
170     emit OwnershipTransferred(address(0), _owner);
171   }
172 
173   /**
174    * @dev Allows a new account (`newOwner`) to accept ownership.
175    * Can only be called by the current owner.
176    */
177   function transferOwnership(address newOwner) external onlyOwner {
178     require(
179       newOwner != address(0),
180       "TwoStepOwnable: new potential owner is the zero address."
181     );
182 
183     _newPotentialOwner = newOwner;
184   }
185 
186   /**
187    * @dev Cancel a transfer of ownership to a new account.
188    * Can only be called by the current owner.
189    */
190   function cancelOwnershipTransfer() external onlyOwner {
191     delete _newPotentialOwner;
192   }
193 
194   /**
195    * @dev Transfers ownership of the contract to the caller.
196    * Can only be called by a new potential owner set by the current owner.
197    */
198   function acceptOwnership() external {
199     require(
200       msg.sender == _newPotentialOwner,
201       "TwoStepOwnable: current owner must set caller as new potential owner."
202     );
203 
204     delete _newPotentialOwner;
205 
206     emit OwnershipTransferred(_owner, msg.sender);
207 
208     _owner = msg.sender;
209   }
210 
211   /**
212    * @dev Returns the address of the current owner.
213    */
214   function owner() external view returns (address) {
215     return _owner;
216   }
217 
218   /**
219    * @dev Returns true if the caller is the current owner.
220    */
221   function isOwner() public view returns (bool) {
222     return msg.sender == _owner;
223   }
224 
225   /**
226    * @dev Throws if called by any account other than the owner.
227    */
228   modifier onlyOwner() {
229     require(isOwner(), "TwoStepOwnable: caller is not the owner.");
230     _;
231   }
232 }
233 
234 
235 /**
236  * @title DharmaReserveManagerV3
237  * @author 0age
238  * @notice This contract is owned by the Dharma Reserve Manager multisig and
239  * manages Dharma's reserves. It designates a collection of "roles" - these are
240  * dedicated accounts that can be modified by the owner, and that can trigger
241  * specific functionality on the manager. These roles are:
242  *  - depositManager (0): initiates token transfers to smart wallets
243  *  - adjuster (1): mints / redeems Dai, and swaps USDC, for dDai
244  *  - withdrawalManager (2): initiates usdc transfers to a recipient set by owner
245  *  - pauser (3): pauses any role (only the owner is then able to unpause it)
246  *
247  * When finalizing deposits, the deposit manager must adhere to two constraints:
248  *  - it must provide "proof" that the recipient is a smart wallet by including
249  *    the initial user signing key used to derive the smart wallet address
250  *  - it must not attempt to transfer more Dai, or more than the Dai-equivalent
251  *    value of Dharma Dai, than the current "limit" set by the owner.
252  *
253  * Reserves can be retrieved via `getReserves`, the current limit can be
254  * retrieved via `getLimit`, and "proofs" can be validated via `isSmartWallet`.
255  */
256 contract DharmaReserveManagerV3 is DharmaReserveManagerV3Interface, TwoStepOwnable {
257   using SafeMath for uint256;
258 
259   // Maintain a role status mapping with assigned accounts and paused states.
260   mapping(uint256 => RoleStatus) private _roles;
261   
262   // Maintain a maximum allowable transfer size (in Dai) for the deposit manager.
263   uint256 private _limit;
264   
265   // Maintain a "primary recipient" the withdrawal manager can transfer USDC to.
266   address private _primaryRecipient;
267 
268   // This contract interacts with USDC, Dai, and Dharma Dai.
269   ERC20Interface internal constant _USDC = ERC20Interface(
270     0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48 // mainnet
271   );
272 
273   ERC20Interface internal constant _DAI = ERC20Interface(
274     0x6B175474E89094C44Da98b954EedeAC495271d0F // mainnet
275   );
276 
277   DTokenInterface internal constant _DDAI = DTokenInterface(
278     0x00000000001876eB1444c986fD502e618c587430
279   );
280   
281   TradeHelperInterface internal constant _TRADE_HELPER = TradeHelperInterface(
282     0x9328F2Fb3e85A4d24Adc2f68F82737183e85691d
283   );
284 
285   // The "Create2 Header" is used to compute smart wallet deployment addresses.
286   bytes21 internal constant _CREATE2_HEADER = bytes21(
287     0xfffc00c80b0000007f73004edb00094cad80626d8d // control character + factory
288   );
289   
290   // The "Wallet creation code" header & footer are also used to derive wallets.
291   bytes internal constant _WALLET_CREATION_CODE_HEADER = hex"60806040526040516104423803806104428339818101604052602081101561002657600080fd5b810190808051604051939291908464010000000082111561004657600080fd5b90830190602082018581111561005b57600080fd5b825164010000000081118282018810171561007557600080fd5b82525081516020918201929091019080838360005b838110156100a257818101518382015260200161008a565b50505050905090810190601f1680156100cf5780820380516001836020036101000a031916815260200191505b5060405250505060006100e661019e60201b60201c565b6001600160a01b0316826040518082805190602001908083835b6020831061011f5780518252601f199092019160209182019101610100565b6001836020036101000a038019825116818451168082178552505050505050905001915050600060405180830381855af49150503d806000811461017f576040519150601f19603f3d011682016040523d82523d6000602084013e610184565b606091505b5050905080610197573d6000803e3d6000fd5b50506102be565b60405160009081906060906e26750c571ce882b17016557279adaa9083818181855afa9150503d80600081146101f0576040519150601f19603f3d011682016040523d82523d6000602084013e6101f5565b606091505b509150915081819061029f576040517f08c379a00000000000000000000000000000000000000000000000000000000081526004018080602001828103825283818151815260200191508051906020019080838360005b8381101561026457818101518382015260200161024c565b50505050905090810190601f1680156102915780820380516001836020036101000a031916815260200191505b509250505060405180910390fd5b508080602001905160208110156102b557600080fd5b50519392505050565b610175806102cd6000396000f3fe608060405261001461000f610016565b61011c565b005b60405160009081906060906e26750c571ce882b17016557279adaa9083818181855afa9150503d8060008114610068576040519150601f19603f3d011682016040523d82523d6000602084013e61006d565b606091505b50915091508181906100fd5760405162461bcd60e51b81526004018080602001828103825283818151815260200191508051906020019080838360005b838110156100c25781810151838201526020016100aa565b50505050905090810190601f1680156100ef5780820380516001836020036101000a031916815260200191505b509250505060405180910390fd5b5080806020019051602081101561011357600080fd5b50519392505050565b3660008037600080366000845af43d6000803e80801561013b573d6000f35b3d6000fdfea265627a7a7231582020202020202055706772616465426561636f6e50726f7879563120202020202064736f6c634300050b003200000000000000000000000000000000000000000000000000000000000000200000000000000000000000000000000000000000000000000000000000000024c4d66de8000000000000000000000000";
292   bytes28 internal constant _WALLET_CREATION_CODE_FOOTER = bytes28(
293     0x00000000000000000000000000000000000000000000000000000000
294   );
295 
296   /**
297    * @notice In the constructor, set the initial owner to the transaction
298    * submitter and initial deposit transfer limit to 1,000 Dai.
299    */
300   constructor() public {
301     // Call Dai to set an allowance for Dharma Dai in order to mint dDai.
302     require(_DAI.approve(address(_DDAI), uint256(-1)));
303     
304     // Call USDC to set an allowance for the trade helper contract.
305     require(_USDC.approve(address(_TRADE_HELPER), uint256(-1)));
306   
307     // Call dDai to set an allowance for the trade helper contract.
308     require(_DDAI.approve(address(_TRADE_HELPER), uint256(-1)));  
309     
310     // Set the initial limit to 1,000 Dai.
311     _limit = 1e21;
312   }
313 
314   /**
315    * @notice Transfer `daiAmount` Dai to `smartWallet`, providing the initial
316    * user signing key `initialUserSigningKey` as proof that the specified smart
317    * wallet is indeed a Dharma Smart Wallet - this assumes that the address is
318    * derived and deployed using the Dharma Smart Wallet Factory V1. In addition,
319    * the specified amount must be less than the configured limit amount. Only
320    * the owner or the designated deposit manager role may call this function.
321    * @param smartWallet address The smart wallet to transfer Dai to.
322    * @param initialUserSigningKey address The initial user signing key supplied
323    * when deriving the smart wallet address - this could be an EOA or a Dharma
324    * key ring address.
325    * @param daiAmount uint256 The amount of Dai to transfer - this must be less
326    * than the current limit.
327    */
328   function finalizeDaiDeposit(
329     address smartWallet, address initialUserSigningKey, uint256 daiAmount
330   ) external onlyOwnerOr(Role.DEPOSIT_MANAGER) {
331     // Ensure that the recipient is indeed a smart wallet.
332     require(
333       _isSmartWallet(smartWallet, initialUserSigningKey),
334       "Could not resolve smart wallet using provided signing key."
335     );
336     
337     // Ensure that the amount to transfer is lower than the limit.
338     require(daiAmount < _limit, "Transfer size exceeds the limit.");
339     
340     // Transfer the Dai to the specified smart wallet.
341     require(_DAI.transfer(smartWallet, daiAmount), "Dai transfer failed.");
342   }
343 
344   /**
345    * @notice Transfer `dDaiAmount` Dharma Dai to `smartWallet`, providing the
346    * initial user signing key `initialUserSigningKey` as proof that the
347    * specified smart wallet is indeed a Dharma Smart Wallet - this assumes that
348    * the address is derived and deployed using the Dharma Smart Wallet Factory
349    * V1. In addition, the Dai equivalent value of the specified dDai amount must
350    * be less than the configured limit amount. Only the owner or the designated
351    * deposit manager role may call this function.
352    * @param smartWallet address The smart wallet to transfer Dai to.
353    * @param initialUserSigningKey address The initial user signing key supplied
354    * when deriving the smart wallet address - this could be an EOA or a Dharma
355    * key ring address.
356    * @param dDaiAmount uint256 The amount of Dharma Dai to transfer - the Dai
357    * equivalent amount must be less than the current limit.
358    */
359   function finalizeDharmaDaiDeposit(
360     address smartWallet, address initialUserSigningKey, uint256 dDaiAmount
361   ) external onlyOwnerOr(Role.DEPOSIT_MANAGER) {
362     // Ensure that the recipient is indeed a smart wallet.
363     require(
364       _isSmartWallet(smartWallet, initialUserSigningKey),
365       "Could not resolve smart wallet using provided signing key."
366     );
367     
368     // Get the current dDai exchange rate.
369     uint256 exchangeRate = _DDAI.exchangeRateCurrent();
370 
371     // Ensure that an exchange rate was actually returned.
372     require(exchangeRate != 0, "Could not retrieve dDai exchange rate.");
373     
374     // Get the equivalent Dai amount of the transfer.
375     uint256 daiEquivalent = (dDaiAmount.mul(exchangeRate)) / 1e18;
376     
377     // Ensure that the amount to transfer is lower than the limit.
378     require(daiEquivalent < _limit, "Transfer size exceeds the limit.");
379 
380     // Transfer the dDai to the specified smart wallet.
381     require(_DDAI.transfer(smartWallet, dDaiAmount), "dDai transfer failed.");
382   }
383 
384   /**
385    * @notice Use `daiAmount` Dai mint Dharma Dai. Only the owner or the
386    * designated adjuster role may call this function.
387    * @param daiAmount uint256 The amount of Dai to supply when minting Dharma
388    * Dai.
389    * @return The amount of Dharma Dai minted.
390    */
391   function mint(
392     uint256 daiAmount
393   ) external onlyOwnerOr(Role.ADJUSTER) returns (uint256 dDaiMinted) {
394     // Use the specified amount of Dai to mint dDai.
395     dDaiMinted = _DDAI.mint(daiAmount);
396   }
397 
398   /**
399    * @notice Redeem `dDaiAmount` Dharma Dai for Dai. Only the owner or the
400    * designated adjuster role may call this function.
401    * @param dDaiAmount uint256 The amount of Dharma Dai to supply when redeeming
402    * for Dai.
403    * @return The amount of Dai received.
404    */ 
405   function redeem(
406     uint256 dDaiAmount
407   ) external onlyOwnerOr(Role.ADJUSTER) returns (uint256 daiReceived) {
408     // Redeem the specified amount of dDai for Dai.
409     daiReceived = _DDAI.redeem(dDaiAmount);
410   }
411   
412   /**
413    * @notice trade `usdcAmount` USDC for Dharma Dai. Only the owner or the designated
414    * adjuster role may call this function.
415    * @param usdcAmount uint256 The amount of USDC to supply when trading for Dharma Dai.
416    * @param quotedDaiEquivalentAmount uint256 The expected DAI equivalent value of the
417    * received dDai - this value is returned from the `getAndExpectedDai` view function
418    * on the trade helper.
419    * @return The amount of dDai received.
420    */ 
421   function tradeUSDCForDDai(
422     uint256 usdcAmount,
423     uint256 quotedDaiEquivalentAmount
424   ) external onlyOwnerOr(Role.ADJUSTER) returns (uint256 dDaiMinted) {
425     dDaiMinted = _TRADE_HELPER.tradeUSDCForDDai(
426        usdcAmount, quotedDaiEquivalentAmount
427     );
428   }
429 
430   /**
431    * @notice tradeDDaiForUSDC `daiEquivalentAmount` Dai amount to trade in Dharma Dai
432    * for USDC. Only the owner or the designated adjuster role may call this function.
433    * @param daiEquivalentAmount uint256 The Dai equivalent amount to supply in Dharma
434    * Dai when trading for USDC.
435    * @param quotedUSDCAmount uint256 The expected USDC received in exchange for
436    * dDai - this value is returned from the `getExpectedUSDC` view function on the
437    * trade helper.
438    * @return The amount of USDC received.
439    */ 
440   function tradeDDaiForUSDC(
441     uint256 daiEquivalentAmount,
442     uint256 quotedUSDCAmount
443   ) external onlyOwnerOr(Role.ADJUSTER) returns (uint256 usdcReceived) {
444     usdcReceived = _TRADE_HELPER.tradeDDaiForUSDC(
445       daiEquivalentAmount, quotedUSDCAmount
446     );
447   }
448   
449   /**
450    * @notice Transfer `usdcAmount` USDC for to the current primary recipient set by the
451    * owner. Only the owner or the designated withdrawal manager role may call this function.
452    * @param usdcAmount uint256 The amount of USDC to transfer to the primary recipient.
453    */ 
454   function withdrawUSDCToPrimaryRecipient(
455     uint256 usdcAmount
456   ) external onlyOwnerOr(Role.WITHDRAWAL_MANAGER) {
457     // Get the current primary recipient.
458     address primaryRecipient = _primaryRecipient;
459     require(
460       primaryRecipient != address(0), "No primary recipient currently set."
461     );
462     
463     // Transfer the supplied USDC amount to the primary recipient.
464     bool ok = _USDC.transfer(primaryRecipient, usdcAmount);
465     require(ok, "USDC transfer failed.");
466   }
467 
468   /**
469    * @notice Transfer `usdcAmount` USDC to `recipient`. Only the owner may call
470    * this function.
471    * @param recipient address The account to transfer USDC to.
472    * @param usdcAmount uint256 The amount of USDC to transfer.
473    */
474   function withdrawUSDC(
475     address recipient, uint256 usdcAmount
476   ) external onlyOwner {
477     // Transfer the USDC to the specified recipient.
478     require(_USDC.transfer(recipient, usdcAmount), "USDC transfer failed.");
479   }
480 
481   /**
482    * @notice Transfer `daiAmount` Dai to `recipient`. Only the owner may call
483    * this function.
484    * @param recipient address The account to transfer Dai to.
485    * @param daiAmount uint256 The amount of Dai to transfer.
486    */
487   function withdrawDai(
488     address recipient, uint256 daiAmount
489   ) external onlyOwner {
490     // Transfer the Dai to the specified recipient.
491     require(_DAI.transfer(recipient, daiAmount), "Dai transfer failed.");
492   }
493 
494   /**
495    * @notice Transfer `dDaiAmount` Dharma Dai to `recipient`. Only the owner may
496    * call this function.
497    * @param recipient address The account to transfer Dharma Dai to.
498    * @param dDaiAmount uint256 The amount of Dharma Dai to transfer.
499    */
500   function withdrawDharmaDai(
501     address recipient, uint256 dDaiAmount
502   ) external onlyOwner {
503     // Transfer the dDai to the specified recipient.
504     require(_DDAI.transfer(recipient, dDaiAmount), "dDai transfer failed.");
505   }
506 
507   /**
508    * @notice Transfer `amount` of ERC20 token `token` to `recipient`. Only the
509    * owner may call this function.
510    * @param token ERC20Interface The ERC20 token to transfer.
511    * @param recipient address The account to transfer the tokens to.
512    * @param amount uint256 The amount of tokens to transfer.
513    * @return A boolean to indicate if the transfer was successful - note that
514    * unsuccessful ERC20 transfers will usually revert.
515    */
516   function withdraw(
517     ERC20Interface token, address recipient, uint256 amount
518   ) external onlyOwner returns (bool success) {
519     // Transfer the token to the specified recipient.
520     success = token.transfer(recipient, amount);
521   }
522 
523   /**
524    * @notice Call account `target`, supplying value `amount` and data `data`.
525    * Only the owner may call this function.
526    * @param target address The account to call.
527    * @param amount uint256 The amount of ether to include as an endowment.
528    * @param data bytes The data to include along with the call.
529    * @return A boolean to indicate if the call was successful, as well as the
530    * returned data or revert reason.
531    */
532   function call(
533     address payable target, uint256 amount, bytes calldata data
534   ) external onlyOwner returns (bool ok, bytes memory returnData) {
535     // Call the specified target and supply the specified data.
536     (ok, returnData) = target.call.value(amount)(data);
537   }
538 
539   /**
540    * @notice Set `daiAmount` as the new limit on the size of finalized deposits.
541    * Only the owner may call this function.
542    * @param daiAmount uint256 The new limit on the size of finalized deposits.
543    */
544   function setLimit(uint256 daiAmount) external onlyOwner {
545     // Set the new limit.
546     _limit = daiAmount;
547   }
548 
549   /**
550    * @notice Set `recipient` as the new primary recipient for USDC withdrawals.
551    * Only the owner may call this function.
552    * @param recipient address The new primary recipient.
553    */
554   function setPrimaryRecipient(address recipient) external onlyOwner {
555     // Set the new primary recipient.
556     _primaryRecipient = recipient;
557   }
558 
559   /**
560    * @notice Pause a currently unpaused role and emit a `RolePaused` event. Only
561    * the owner or the designated pauser may call this function. Also, bear in
562    * mind that only the owner may unpause a role once paused.
563    * @param role The role to pause. Permitted roles are deposit manager (0),
564    * adjuster (1), and pauser (2).
565    */
566   function pause(Role role) external onlyOwnerOr(Role.PAUSER) {
567     RoleStatus storage storedRoleStatus = _roles[uint256(role)];
568     require(!storedRoleStatus.paused, "Role in question is already paused.");
569     storedRoleStatus.paused = true;
570     emit RolePaused(role);
571   }
572 
573   /**
574    * @notice Unpause a currently paused role and emit a `RoleUnpaused` event.
575    * Only the owner may call this function.
576    * @param role The role to pause. Permitted roles are deposit manager (0),
577    * adjuster (1), and pauser (2).
578    */
579   function unpause(Role role) external onlyOwner {
580     RoleStatus storage storedRoleStatus = _roles[uint256(role)];
581     require(storedRoleStatus.paused, "Role in question is already unpaused.");
582     storedRoleStatus.paused = false;
583     emit RoleUnpaused(role);
584   }
585 
586   /**
587    * @notice Set a new account on a given role and emit a `RoleModified` event
588    * if the role holder has changed. Only the owner may call this function.
589    * @param role The role that the account will be set for. Permitted roles are
590    * deposit manager (0), adjuster (1), and pauser (2).
591    * @param account The account to set as the designated role bearer.
592    */
593   function setRole(Role role, address account) external onlyOwner {
594     require(account != address(0), "Must supply an account.");
595     _setRole(role, account);
596   }
597 
598   /**
599    * @notice Remove any current role bearer for a given role and emit a
600    * `RoleModified` event if a role holder was previously set. Only the owner
601    * may call this function.
602    * @param role The role that the account will be removed from. Permitted roles
603    * are deposit manager (0), adjuster (1), and pauser (2).
604    */
605   function removeRole(Role role) external onlyOwner {
606     _setRole(role, address(0));
607   }
608 
609   /**
610    * @notice External view function to check whether or not the functionality
611    * associated with a given role is currently paused or not. The owner or the
612    * pauser may pause any given role (including the pauser itself), but only the
613    * owner may unpause functionality. Additionally, the owner may call paused
614    * functions directly.
615    * @param role The role to check the pause status on. Permitted roles are
616    * deposit manager (0), adjuster (1), and pauser (2).
617    * @return A boolean to indicate if the functionality associated with the role
618    * in question is currently paused.
619    */
620   function isPaused(Role role) external view returns (bool paused) {
621     paused = _isPaused(role);
622   }
623 
624   /**
625    * @notice External view function to check whether the caller is the current
626    * role holder.
627    * @param role The role to check for. Permitted roles are deposit manager (0),
628    * adjuster (1), and pauser (2).
629    * @return A boolean indicating if the caller has the specified role.
630    */
631   function isRole(Role role) external view returns (bool hasRole) {
632     hasRole = _isRole(role);
633   }
634 
635   /**
636    * @notice External view function to check whether a "proof" that a given
637    * smart wallet is actually a Dharma Smart Wallet, based on the initial user
638    * signing key, is valid or not. This proof only works when the Dharma Smart
639    * Wallet in question is derived using V1 of the Dharma Smart Wallet Factory.
640    * @param smartWallet address The smart wallet to check.
641    * @param initialUserSigningKey address The initial user signing key supplied
642    * when deriving the smart wallet address - this could be an EOA or a Dharma
643    * key ring address.
644    * @return A boolean indicating if the specified smart wallet account is
645    * indeed a smart wallet based on the specified initial user signing key.
646    */
647   function isDharmaSmartWallet(
648     address smartWallet, address initialUserSigningKey
649   ) external view returns (bool dharmaSmartWallet) {
650     dharmaSmartWallet = _isSmartWallet(smartWallet, initialUserSigningKey);
651   }
652 
653   /**
654    * @notice External view function to check the account currently holding the
655    * deposit manager role. The deposit manager can process standard deposit
656    * finalization via `finalizeDaiDeposit` and `finalizeDharmaDaiDeposit`, but
657    * must prove that the recipient is a Dharma Smart Wallet and adhere to the
658    * current deposit size limit.
659    * @return The address of the current deposit manager, or the null address if
660    * none is set.
661    */
662   function getDepositManager() external view returns (address depositManager) {
663     depositManager = _roles[uint256(Role.DEPOSIT_MANAGER)].account;
664   }
665 
666   /**
667    * @notice External view function to check the account currently holding the
668    * adjuster role. The adjuster can exchange Dai in reserves for Dharma Dai and
669    * vice-versa via minting or redeeming.
670    * @return The address of the current adjuster, or the null address if none is
671    * set.
672    */
673   function getAdjuster() external view returns (address adjuster) {
674     adjuster = _roles[uint256(Role.ADJUSTER)].account;
675   }
676 
677   /**
678    * @notice External view function to check the account currently holding the
679    * withdrawal manager role. The withdrawal manager can transfer USDC to the
680    * "primary recipient" address set by the owner.
681    * @return The address of the current withdrawal manager, or the null address
682    * if none is set.
683    */
684   function getWithdrawalManager() external view returns (address withdrawalManager) {
685     withdrawalManager = _roles[uint256(Role.WITHDRAWAL_MANAGER)].account;
686   }
687 
688   /**
689    * @notice External view function to check the account currently holding the
690    * pauser role. The pauser can pause any role from taking its standard action,
691    * though the owner will still be able to call the associated function in the
692    * interim and is the only entity able to unpause the given role once paused.
693    * @return The address of the current pauser, or the null address if none is
694    * set.
695    */
696   function getPauser() external view returns (address pauser) {
697     pauser = _roles[uint256(Role.PAUSER)].account;
698   }
699 
700   /**
701    * @notice External view function to check the current reserves held by this
702    * contract.
703    * @return The Dai and Dharma Dai reserves held by this contract, as well as
704    * the Dai-equivalent value of the Dharma Dai reserves.
705    */ 
706   function getReserves() external view returns (
707     uint256 dai, uint256 dDai, uint256 dDaiUnderlying
708   ) {
709     dai = _DAI.balanceOf(address(this));
710     dDai = _DDAI.balanceOf(address(this));
711     dDaiUnderlying = _DDAI.balanceOfUnderlying(address(this));
712   }
713 
714   /**
715    * @notice External view function to check the current limit on deposit amount
716    * enforced for the deposit manager when finalizing deposits, expressed in Dai
717    * and in Dharma Dai.
718    * @return The Dai and Dharma Dai limit on deposit finalization amount.
719    */  
720   function getLimit() external view returns (
721     uint256 daiAmount, uint256 dDaiAmount
722   ) {
723     daiAmount = _limit;
724     dDaiAmount = (daiAmount.mul(1e18)).div(_DDAI.exchangeRateCurrent());   
725   }
726 
727   /**
728    * @notice External view function to check the address of the current
729    * primary recipient.
730    * @return The primary recipient.
731    */  
732   function getPrimaryRecipient() external view returns (
733     address recipient
734   ) {
735     recipient = _primaryRecipient;
736   }
737 
738   /**
739    * @notice Internal function to set a new account on a given role and emit a
740    * `RoleModified` event if the role holder has changed.
741    * @param role The role that the account will be set for. Permitted roles are
742    * deposit manager (0), adjuster (1), and pauser (2).
743    * @param account The account to set as the designated role bearer.
744    */
745   function _setRole(Role role, address account) internal {
746     RoleStatus storage storedRoleStatus = _roles[uint256(role)];
747 
748     if (account != storedRoleStatus.account) {
749       storedRoleStatus.account = account;
750       emit RoleModified(role, account);
751     }
752   }
753 
754   /**
755    * @notice Internal view function to check whether the caller is the current
756    * role holder.
757    * @param role The role to check for. Permitted roles are deposit manager (0),
758    * adjuster (1), and pauser (2).
759    * @return A boolean indicating if the caller has the specified role.
760    */
761   function _isRole(Role role) internal view returns (bool hasRole) {
762     hasRole = msg.sender == _roles[uint256(role)].account;
763   }
764 
765   /**
766    * @notice Internal view function to check whether the given role is paused or
767    * not.
768    * @param role The role to check for. Permitted roles are deposit manager (0),
769    * adjuster (1), and pauser (2).
770    * @return A boolean indicating if the specified role is paused or not.
771    */
772   function _isPaused(Role role) internal view returns (bool paused) {
773     paused = _roles[uint256(role)].paused;
774   }
775 
776   /**
777    * @notice Internal view function to enforce that the given initial user signing
778    * key resolves to the given smart wallet when deployed through the Dharma Smart
779    * Wallet Factory V1.
780    * @param smartWallet address The smart wallet.
781    * @param initialUserSigningKey address The initial user signing key.
782    */
783   function _isSmartWallet(
784     address smartWallet, address initialUserSigningKey
785   ) internal pure returns (bool) {
786     // Derive the keccak256 hash of the smart wallet initialization code.
787     bytes32 initCodeHash = keccak256(
788       abi.encodePacked(
789         _WALLET_CREATION_CODE_HEADER,
790         initialUserSigningKey,
791         _WALLET_CREATION_CODE_FOOTER
792       )
793     );
794 
795     // Attempt to derive a smart wallet address that matches the one provided.
796     address target;
797     for (uint256 nonce = 0; nonce < 10; nonce++) {
798       target = address(          // derive the target deployment address.
799         uint160(                 // downcast to match the address type.
800           uint256(               // cast to uint to truncate upper digits.
801             keccak256(           // compute CREATE2 hash using all inputs.
802               abi.encodePacked(  // pack all inputs to the hash together.
803                 _CREATE2_HEADER, // pass in control character + factory address.
804                 nonce,           // pass in current nonce as the salt.
805                 initCodeHash     // pass in hash of contract creation code.
806               )
807             )
808           )
809         )
810       );
811 
812       // Exit early if the provided smart wallet matches derived target address.
813       if (target == smartWallet) {
814         return true;
815       }
816 
817       // Otherwise, increment the nonce and derive a new salt.
818       nonce++;
819     }
820 
821     // Explicity recognize no target was found matching provided smart wallet.
822     return false;
823   }
824 
825   /**
826    * @notice Modifier that throws if called by any account other than the owner
827    * or the supplied role, or if the caller is not the owner and the role in
828    * question is paused.
829    * @param role The role to require unless the caller is the owner. Permitted
830    * roles are deposit manager (0), adjuster (1), and pauser (2).
831    */
832   modifier onlyOwnerOr(Role role) {
833     if (!isOwner()) {
834       require(_isRole(role), "Caller does not have a required role.");
835       require(!_isPaused(role), "Role in question is currently paused.");
836     }
837     _;
838   }
839 }