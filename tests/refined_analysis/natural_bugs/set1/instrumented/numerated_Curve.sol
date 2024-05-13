1 // SPDX-License-Identifier: MIT
2 
3 // This program is free software: you can redistribute it and/or modify
4 // it under the terms of the GNU General Public License as published by
5 // the Free Software Foundation, either version 3 of the License, or
6 // (at your option) any later version.
7 
8 // This program is distributed in the hope that it will be useful,
9 // but WITHOUT ANY WARRANTY; without even the implied warranty of
10 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
11 // GNU General Public License for more details.
12 
13 // You should have received a copy of the GNU General Public License
14 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
15 
16 pragma solidity ^0.7.3;
17 
18 import "./lib/ABDKMath64x64.sol";
19 
20 import "./Orchestrator.sol";
21 
22 import "./ProportionalLiquidity.sol";
23 
24 import "./Swaps.sol";
25 
26 import "./ViewLiquidity.sol";
27 
28 import "./Storage.sol";
29 
30 import "./MerkleProver.sol";
31 
32 import "./interfaces/IFreeFromUpTo.sol";
33 
34 library Curves {
35     using ABDKMath64x64 for int128;
36 
37     event Approval(address indexed _owner, address indexed spender, uint256 value);
38     event Transfer(address indexed from, address indexed to, uint256 value);
39 
40     function add(
41         uint256 x,
42         uint256 y,
43         string memory errorMessage
44     ) private pure returns (uint256 z) {
45         require((z = x + y) >= x, errorMessage);
46     }
47 
48     function sub(
49         uint256 x,
50         uint256 y,
51         string memory errorMessage
52     ) private pure returns (uint256 z) {
53         require((z = x - y) <= x, errorMessage);
54     }
55 
56     /**
57      * @dev See {IERC20-transfer}.
58      *
59      * Requirements:
60      *
61      * - `recipient` cannot be the zero address.
62      * - the caller must have a balance of at least `amount`.
63      */
64     function transfer(
65         Storage.Curve storage curve,
66         address recipient,
67         uint256 amount
68     ) external returns (bool) {
69         _transfer(curve, msg.sender, recipient, amount);
70         return true;
71     }
72 
73     /**
74      * @dev See {IERC20-approve}.
75      *
76      * Requirements:
77      *
78      * - `spender` cannot be the zero address.
79      */
80     function approve(
81         Storage.Curve storage curve,
82         address spender,
83         uint256 amount
84     ) external returns (bool) {
85         _approve(curve, msg.sender, spender, amount);
86         return true;
87     }
88 
89     /**
90      * @dev See {IERC20-transferFrom}.
91      *
92      * Emits an {Approval} event indicating the updated allowance. This is not
93      * required by the EIP. See the note at the beginning of {ERC20};
94      *
95      * Requirements:
96      * - `sender` and `recipient` cannot be the zero address.
97      * - `sender` must have a balance of at least `amount`.
98      * - the caller must have allowance for `sender`'s tokens of at least
99      * `amount`
100      */
101     function transferFrom(
102         Storage.Curve storage curve,
103         address sender,
104         address recipient,
105         uint256 amount
106     ) external returns (bool) {
107         _transfer(curve, sender, recipient, amount);
108         _approve(
109             curve,
110             sender,
111             msg.sender,
112             sub(curve.allowances[sender][msg.sender], amount, "Curve/insufficient-allowance")
113         );
114         return true;
115     }
116 
117     /**
118      * @dev Atomically increases the allowance granted to `spender` by the caller.
119      *
120      * This is an alternative to {approve} that can be used as a mitigation for
121      * problems described in {IERC20-approve}.
122      *
123      * Emits an {Approval} event indicating the updated allowance.
124      *
125      * Requirements:
126      *
127      * - `spender` cannot be the zero address.
128      */
129     function increaseAllowance(
130         Storage.Curve storage curve,
131         address spender,
132         uint256 addedValue
133     ) external returns (bool) {
134         _approve(
135             curve,
136             msg.sender,
137             spender,
138             add(curve.allowances[msg.sender][spender], addedValue, "Curve/approval-overflow")
139         );
140         return true;
141     }
142 
143     /**
144      * @dev Atomically decreases the allowance granted to `spender` by the caller.
145      *
146      * This is an alternative to {approve} that can be used as a mitigation for
147      * problems described in {IERC20-approve}.
148      *
149      * Emits an {Approval} event indicating the updated allowance.
150      *
151      * Requirements:
152      *
153      * - `spender` cannot be the zero address.
154      * - `spender` must have allowance for the caller of at least
155      * `subtractedValue`.
156      */
157     function decreaseAllowance(
158         Storage.Curve storage curve,
159         address spender,
160         uint256 subtractedValue
161     ) external returns (bool) {
162         _approve(
163             curve,
164             msg.sender,
165             spender,
166             sub(curve.allowances[msg.sender][spender], subtractedValue, "Curve/allowance-decrease-underflow")
167         );
168         return true;
169     }
170 
171     /**
172      * @dev Moves tokens `amount` from `sender` to `recipient`.
173      *
174      * This is public function is equivalent to {transfer}, and can be used to
175      * e.g. implement automatic token fees, slashing mechanisms, etc.
176      *
177      * Emits a {Transfer} event.
178      *
179      * Requirements:
180      *
181      * - `sender` cannot be the zero address.
182      * - `recipient` cannot be the zero address.
183      * - `sender` must have a balance of at least `amount`.
184      */
185     function _transfer(
186         Storage.Curve storage curve,
187         address sender,
188         address recipient,
189         uint256 amount
190     ) private {
191         require(sender != address(0), "ERC20: transfer from the zero address");
192         require(recipient != address(0), "ERC20: transfer to the zero address");
193 
194         curve.balances[sender] = sub(curve.balances[sender], amount, "Curve/insufficient-balance");
195         curve.balances[recipient] = add(curve.balances[recipient], amount, "Curve/transfer-overflow");
196         emit Transfer(sender, recipient, amount);
197     }
198 
199     /**
200      * @dev Sets `amount` as the allowance of `spender` over the `_owner`s tokens.
201      *
202      * This is public function is equivalent to `approve`, and can be used to
203      * e.g. set automatic allowances for certain subsystems, etc.
204      *
205      * Emits an {Approval} event.
206      *
207      * Requirements:
208      *
209      * - `_owner` cannot be the zero address.
210      * - `spender` cannot be the zero address.
211      */
212     function _approve(
213         Storage.Curve storage curve,
214         address _owner,
215         address spender,
216         uint256 amount
217     ) private {
218         require(_owner != address(0), "ERC20: approve from the zero address");
219         require(spender != address(0), "ERC20: approve to the zero address");
220 
221         curve.allowances[_owner][spender] = amount;
222         emit Approval(_owner, spender, amount);
223     }
224 }
225 
226 contract Curve is Storage, MerkleProver {
227     using SafeMath for uint256;
228 
229     event Approval(address indexed _owner, address indexed spender, uint256 value);
230 
231     event ParametersSet(uint256 alpha, uint256 beta, uint256 delta, uint256 epsilon, uint256 lambda);
232 
233     event AssetIncluded(address indexed numeraire, address indexed reserve, uint256 weight);
234 
235     event AssimilatorIncluded(
236         address indexed derivative,
237         address indexed numeraire,
238         address indexed reserve,
239         address assimilator
240     );
241 
242     event PartitionRedeemed(address indexed token, address indexed redeemer, uint256 value);
243 
244     event OwnershipTransfered(address indexed previousOwner, address indexed newOwner);
245 
246     event FrozenSet(bool isFrozen);
247 
248     event EmergencyAlarm(bool isEmergency);
249 
250     event WhitelistingStopped();
251 
252     event Trade(
253         address indexed trader,
254         address indexed origin,
255         address indexed target,
256         uint256 originAmount,
257         uint256 targetAmount
258     );
259 
260     event Transfer(address indexed from, address indexed to, uint256 value);
261 
262     modifier onlyOwner() {
263         require(msg.sender == owner, "Curve/caller-is-not-owner");
264         _;
265     }
266 
267     modifier nonReentrant() {
268         require(notEntered, "Curve/re-entered");
269         notEntered = false;
270         _;
271         notEntered = true;
272     }
273 
274     modifier transactable() {
275         require(!frozen, "Curve/frozen-only-allowing-proportional-withdraw");
276         _;
277     }
278 
279     modifier isEmergency() {
280         require(emergency, "Curve/emergency-only-allowing-emergency-proportional-withdraw");
281         _;
282     }
283 
284     modifier deadline(uint256 _deadline) {
285         require(block.timestamp < _deadline, "Curve/tx-deadline-passed");
286         _;
287     }
288 
289     modifier inWhitelistingStage() {
290         require(whitelistingStage, "Curve/whitelist-stage-on-going");
291         _;
292     }
293 
294     modifier notInWhitelistingStage() {
295         require(!whitelistingStage, "Curve/whitelist-stage-stopped");
296         _;
297     }
298 
299     constructor(
300         string memory _name,
301         string memory _symbol,
302         address[] memory _assets,
303         uint256[] memory _assetWeights
304     ) {
305         owner = msg.sender;
306         name = _name;
307         symbol = _symbol;
308         emit OwnershipTransfered(address(0), msg.sender);
309 
310         Orchestrator.initialize(curve, numeraires, reserves, derivatives, _assets, _assetWeights);
311     }
312 
313     /// @notice sets the parameters for the pool
314     /// @param _alpha the value for alpha (halt threshold) must be less than or equal to 1 and greater than 0
315     /// @param _beta the value for beta must be less than alpha and greater than 0
316     /// @param _feeAtHalt the maximum value for the fee at the halt point
317     /// @param _epsilon the base fee for the pool
318     /// @param _lambda the value for lambda must be less than or equal to 1 and greater than zero
319     function setParams(
320         uint256 _alpha,
321         uint256 _beta,
322         uint256 _feeAtHalt,
323         uint256 _epsilon,
324         uint256 _lambda
325     ) external onlyOwner {
326         Orchestrator.setParams(curve, _alpha, _beta, _feeAtHalt, _epsilon, _lambda);
327     }
328 
329     /// @notice excludes an assimilator from the curve
330     /// @param _derivative the address of the assimilator to exclude
331     function excludeDerivative(address _derivative) external onlyOwner {
332         for (uint256 i = 0; i < numeraires.length; i++) {
333             if (_derivative == numeraires[i]) revert("Curve/cannot-delete-numeraire");
334             if (_derivative == reserves[i]) revert("Curve/cannot-delete-reserve");
335         }
336 
337         delete curve.assimilators[_derivative];
338     }
339 
340     /// @notice view the current parameters of the curve
341     /// @return alpha_ the current alpha value
342     ///  beta_ the current beta value
343     ///  delta_ the current delta value
344     ///  epsilon_ the current epsilon value
345     ///  lambda_ the current lambda value
346     ///  omega_ the current omega value
347     function viewCurve()
348         external
349         view
350         returns (
351             uint256 alpha_,
352             uint256 beta_,
353             uint256 delta_,
354             uint256 epsilon_,
355             uint256 lambda_
356         )
357     {
358         return Orchestrator.viewCurve(curve);
359     }
360 
361     function turnOffWhitelisting() external onlyOwner {
362         emit WhitelistingStopped();
363 
364         whitelistingStage = false;
365     }
366 
367     function setEmergency(bool _emergency) external onlyOwner {
368         emit EmergencyAlarm(_emergency);
369 
370         emergency = _emergency;
371     }
372 
373     function setFrozen(bool _toFreezeOrNotToFreeze) external onlyOwner {
374         emit FrozenSet(_toFreezeOrNotToFreeze);
375 
376         frozen = _toFreezeOrNotToFreeze;
377     }
378 
379     function transferOwnership(address _newOwner) external onlyOwner {
380         require(_newOwner != address(0), "Curve/new-owner-cannot-be-zeroth-address");
381 
382         emit OwnershipTransfered(owner, _newOwner);
383 
384         owner = _newOwner;
385     }
386 
387     /// @notice swap a dynamic origin amount for a fixed target amount
388     /// @param _origin the address of the origin
389     /// @param _target the address of the target
390     /// @param _originAmount the origin amount
391     /// @param _minTargetAmount the minimum target amount
392     /// @param _deadline deadline in block number after which the trade will not execute
393     /// @return targetAmount_ the amount of target that has been swapped for the origin amount
394     function originSwap(
395         address _origin,
396         address _target,
397         uint256 _originAmount,
398         uint256 _minTargetAmount,
399         uint256 _deadline
400     ) external deadline(_deadline) transactable nonReentrant returns (uint256 targetAmount_) {
401         targetAmount_ = Swaps.originSwap(curve, _origin, _target, _originAmount, msg.sender);
402 
403         require(targetAmount_ >= _minTargetAmount, "Curve/below-min-target-amount");
404     }
405 
406     /// @notice view how much target amount a fixed origin amount will swap for
407     /// @param _origin the address of the origin
408     /// @param _target the address of the target
409     /// @param _originAmount the origin amount
410     /// @return targetAmount_ the target amount that would have been swapped for the origin amount
411     function viewOriginSwap(
412         address _origin,
413         address _target,
414         uint256 _originAmount
415     ) external view transactable returns (uint256 targetAmount_) {
416         targetAmount_ = Swaps.viewOriginSwap(curve, _origin, _target, _originAmount);
417     }
418 
419     /// @notice swap a dynamic origin amount for a fixed target amount
420     /// @param _origin the address of the origin
421     /// @param _target the address of the target
422     /// @param _maxOriginAmount the maximum origin amount
423     /// @param _targetAmount the target amount
424     /// @param _deadline deadline in block number after which the trade will not execute
425     /// @return originAmount_ the amount of origin that has been swapped for the target
426     function targetSwap(
427         address _origin,
428         address _target,
429         uint256 _maxOriginAmount,
430         uint256 _targetAmount,
431         uint256 _deadline
432     ) external deadline(_deadline) transactable nonReentrant returns (uint256 originAmount_) {
433         originAmount_ = Swaps.targetSwap(curve, _origin, _target, _targetAmount, msg.sender);
434 
435         require(originAmount_ <= _maxOriginAmount, "Curve/above-max-origin-amount");
436     }
437 
438     /// @notice view how much of the origin currency the target currency will take
439     /// @param _origin the address of the origin
440     /// @param _target the address of the target
441     /// @param _targetAmount the target amount
442     /// @return originAmount_ the amount of target that has been swapped for the origin
443     function viewTargetSwap(
444         address _origin,
445         address _target,
446         uint256 _targetAmount
447     ) external view transactable returns (uint256 originAmount_) {
448         originAmount_ = Swaps.viewTargetSwap(curve, _origin, _target, _targetAmount);
449     }
450 
451     /// @notice deposit into the pool with no slippage from the numeraire assets the pool supports
452     /// @param  index Index corresponding to the merkleProof
453     /// @param  account Address coorresponding to the merkleProof
454     /// @param  amount Amount coorresponding to the merkleProof, should always be 1
455     /// @param  merkleProof Merkle proof
456     /// @param  _deposit the full amount you want to deposit into the pool which will be divided up evenly amongst
457     ///                  the numeraire assets of the pool
458     /// @return (the amount of curves you receive in return for your deposit,
459     ///          the amount deposited for each numeraire)
460     function depositWithWhitelist(
461         uint256 index,
462         address account,
463         uint256 amount,
464         bytes32[] calldata merkleProof,
465         uint256 _deposit,
466         uint256 _deadline
467     ) external deadline(_deadline) transactable nonReentrant inWhitelistingStage returns (uint256, uint256[] memory) {
468         require(isWhitelisted(index, account, amount, merkleProof), "Curve/not-whitelisted");
469         require(msg.sender == account, "Curve/not-approved-user");
470 
471         (uint256 curvesMinted_, uint256[] memory deposits_) =
472             ProportionalLiquidity.proportionalDeposit(curve, _deposit);
473 
474         whitelistedDeposited[msg.sender] = whitelistedDeposited[msg.sender].add(curvesMinted_);
475 
476         // 10k max deposit
477         if (whitelistedDeposited[msg.sender] > 10000e18) {
478             revert("Curve/exceed-whitelist-maximum-deposit");
479         }
480 
481         return (curvesMinted_, deposits_);
482     }
483 
484     /// @notice deposit into the pool with no slippage from the numeraire assets the pool supports
485     /// @param  _deposit the full amount you want to deposit into the pool which will be divided up evenly amongst
486     ///                  the numeraire assets of the pool
487     /// @return (the amount of curves you receive in return for your deposit,
488     ///          the amount deposited for each numeraire)
489     function deposit(uint256 _deposit, uint256 _deadline)
490         external
491         deadline(_deadline)
492         transactable
493         nonReentrant
494         notInWhitelistingStage
495         returns (uint256, uint256[] memory)
496     {
497         // (curvesMinted_,  deposits_)
498         return ProportionalLiquidity.proportionalDeposit(curve, _deposit);
499     }
500 
501     /// @notice view deposits and curves minted a given deposit would return
502     /// @param _deposit the full amount of stablecoins you want to deposit. Divided evenly according to the
503     ///                 prevailing proportions of the numeraire assets of the pool
504     /// @return (the amount of curves you receive in return for your deposit,
505     ///          the amount deposited for each numeraire)
506     function viewDeposit(uint256 _deposit) external view transactable returns (uint256, uint256[] memory) {
507         // curvesToMint_, depositsToMake_
508         return ProportionalLiquidity.viewProportionalDeposit(curve, _deposit);
509     }
510 
511     /// @notice  Emergency withdraw tokens in the event that the oracle somehow bugs out
512     ///          and no one is able to withdraw due to the invariant check
513     /// @param   _curvesToBurn the full amount you want to withdraw from the pool which will be withdrawn from evenly amongst the
514     ///                        numeraire assets of the pool
515     /// @return withdrawals_ the amonts of numeraire assets withdrawn from the pool
516     function emergencyWithdraw(uint256 _curvesToBurn, uint256 _deadline)
517         external
518         isEmergency
519         deadline(_deadline)
520         nonReentrant
521         returns (uint256[] memory withdrawals_)
522     {
523         return ProportionalLiquidity.emergencyProportionalWithdraw(curve, _curvesToBurn);
524     }
525 
526     /// @notice  withdrawas amount of curve tokens from the the pool equally from the numeraire assets of the pool with no slippage
527     /// @param   _curvesToBurn the full amount you want to withdraw from the pool which will be withdrawn from evenly amongst the
528     ///                        numeraire assets of the pool
529     /// @return withdrawals_ the amonts of numeraire assets withdrawn from the pool
530     function withdraw(uint256 _curvesToBurn, uint256 _deadline)
531         external
532         deadline(_deadline)
533         nonReentrant
534         returns (uint256[] memory withdrawals_)
535     {
536         if (whitelistingStage) {
537             whitelistedDeposited[msg.sender] = whitelistedDeposited[msg.sender].sub(_curvesToBurn);
538         }
539 
540         return ProportionalLiquidity.proportionalWithdraw(curve, _curvesToBurn);
541     }
542 
543     /// @notice  views the withdrawal information from the pool
544     /// @param   _curvesToBurn the full amount you want to withdraw from the pool which will be withdrawn from evenly amongst the
545     ///                        numeraire assets of the pool
546     /// @return the amonnts of numeraire assets withdrawn from the pool
547     function viewWithdraw(uint256 _curvesToBurn) external view transactable returns (uint256[] memory) {
548         return ProportionalLiquidity.viewProportionalWithdraw(curve, _curvesToBurn);
549     }
550 
551     function supportsInterface(bytes4 _interface) public pure returns (bool supports_) {
552         supports_ =
553             this.supportsInterface.selector == _interface || // erc165
554             bytes4(0x7f5828d0) == _interface || // eip173
555             bytes4(0x36372b07) == _interface; // erc20
556     }
557 
558     /// @notice transfers curve tokens
559     /// @param _recipient the address of where to send the curve tokens
560     /// @param _amount the amount of curve tokens to send
561     /// @return success_ the success bool of the call
562     function transfer(address _recipient, uint256 _amount) public nonReentrant returns (bool success_) {
563         success_ = Curves.transfer(curve, _recipient, _amount);
564     }
565 
566     /// @notice transfers curve tokens from one address to another address
567     /// @param _sender the account from which the curve tokens will be sent
568     /// @param _recipient the account to which the curve tokens will be sent
569     /// @param _amount the amount of curve tokens to transfer
570     /// @return success_ the success bool of the call
571     function transferFrom(
572         address _sender,
573         address _recipient,
574         uint256 _amount
575     ) public nonReentrant returns (bool success_) {
576         success_ = Curves.transferFrom(curve, _sender, _recipient, _amount);
577     }
578 
579     /// @notice approves a user to spend curve tokens on their behalf
580     /// @param _spender the account to allow to spend from msg.sender
581     /// @param _amount the amount to specify the spender can spend
582     /// @return success_ the success bool of this call
583     function approve(address _spender, uint256 _amount) public nonReentrant returns (bool success_) {
584         success_ = Curves.approve(curve, _spender, _amount);
585     }
586 
587     /// @notice view the curve token balance of a given account
588     /// @param _account the account to view the balance of
589     /// @return balance_ the curve token ballance of the given account
590     function balanceOf(address _account) public view returns (uint256 balance_) {
591         balance_ = curve.balances[_account];
592     }
593 
594     /// @notice views the total curve supply of the pool
595     /// @return totalSupply_ the total supply of curve tokens
596     function totalSupply() public view returns (uint256 totalSupply_) {
597         totalSupply_ = curve.totalSupply;
598     }
599 
600     /// @notice views the total allowance one address has to spend from another address
601     /// @param _owner the address of the owner
602     /// @param _spender the address of the spender
603     /// @return allowance_ the amount the owner has allotted the spender
604     function allowance(address _owner, address _spender) public view returns (uint256 allowance_) {
605         allowance_ = curve.allowances[_owner][_spender];
606     }
607 
608     /// @notice views the total amount of liquidity in the curve in numeraire value and format - 18 decimals
609     /// @return total_ the total value in the curve
610     /// @return individual_ the individual values in the curve
611     function liquidity() public view returns (uint256 total_, uint256[] memory individual_) {
612         return ViewLiquidity.viewLiquidity(curve);
613     }
614 
615     /// @notice view the assimilator address for a derivative
616     /// @return assimilator_ the assimilator address
617     function assimilator(address _derivative) public view returns (address assimilator_) {
618         assimilator_ = curve.assimilators[_derivative].addr;
619     }
620 }
