1 // File: contracts/I_Curve.sol
2 
3 pragma solidity 0.5.0;
4 
5 /**
6  * @title   Interface Curve
7  * @notice  This contract acts as an interface to the curve contract. For
8  *          documentation please see the curve smart contract.
9  */
10 interface I_Curve {
11     
12     // -------------------------------------------------------------------------
13     // View functions
14     // -------------------------------------------------------------------------
15 
16     /**
17      * @notice This function is only callable after the curve contract has been
18      *         initialized.
19      * @param  _amount The amount of tokens a user wants to buy
20      * @return uint256 The cost to buy the _amount of tokens in the collateral
21      *         currency (see collateral token).
22      */
23     function buyPrice(uint256 _amount)
24         external
25         view
26         returns (uint256 collateralRequired);
27 
28     /**
29      * @notice This function is only callable after the curve contract has been
30      *         initialized.
31      * @param  _amount The amount of tokens a user wants to sell
32      * @return collateralReward The reward for selling the _amount of tokens in the
33      *         collateral currency (see collateral token).
34      */
35     function sellReward(uint256 _amount)
36         external
37         view
38         returns (uint256 collateralReward);
39 
40     /**
41       * @return If the curve is both active and initialised.
42       */
43     function isCurveActive() external view returns (bool);
44 
45     /**
46       * @return The address of the collateral token (DAI)
47       */
48     function collateralToken() external view returns (address);
49 
50     /**
51       * @return The address of the bonded token (BZZ).
52       */
53     function bondedToken() external view returns (address);
54 
55     /**
56       * @return The required collateral amount (DAI) to initialise the curve.
57       */
58     function requiredCollateral(uint256 _initialSupply)
59         external
60         view
61         returns (uint256);
62 
63     // -------------------------------------------------------------------------
64     // State modifying functions
65     // -------------------------------------------------------------------------
66 
67     /**
68      * @notice This function initializes the curve contract, and ensure the
69      *         curve has the required permissions on the token contract needed
70      *         to function.
71      */
72     function init() external;
73 
74     /**
75       * @param  _amount The amount of tokens (BZZ) the user wants to buy.
76       * @param  _maxCollateralSpend The max amount of collateral (DAI) the user is
77       *         willing to spend in order to buy the _amount of tokens.
78       * @return The status of the mint. Note that should the total cost of the
79       *         purchase exceed the _maxCollateralSpend the transaction will revert.
80       */
81     function mint(uint256 _amount, uint256 _maxCollateralSpend)
82         external
83         returns (bool success);
84 
85     /**
86       * @param  _amount The amount of tokens (BZZ) the user wants to buy.
87       * @param  _maxCollateralSpend The max amount of collateral (DAI) the user is
88       *         willing to spend in order to buy the _amount of tokens.
89       * @param  _to The address to send the tokens to.
90       * @return The status of the mint. Note that should the total cost of the
91       *         purchase exceed the _maxCollateralSpend the transaction will revert.
92       */
93     function mintTo(
94         uint256 _amount, 
95         uint256 _maxCollateralSpend, 
96         address _to
97     )
98         external
99         returns (bool success);
100 
101     /**
102       * @param  _amount The amount of tokens (BZZ) the user wants to sell.
103       * @param  _minCollateralReward The min amount of collateral (DAI) the user is
104       *         willing to receive for their tokens.
105       * @return The status of the burn. Note that should the total reward of the
106       *         burn be below the _minCollateralReward the transaction will revert.
107       */
108     function redeem(uint256 _amount, uint256 _minCollateralReward)
109         external
110         returns (bool success);
111 
112     /**
113       * @notice Shuts down the curve, disabling buying, selling and both price
114       *         functions. Can only be called by the owner. Will renounce the
115       *         minter role on the bonded token.
116       */
117     function shutDown() external;
118 }
119 
120 // File: contracts/I_router_02.sol
121 
122 pragma solidity 0.5.0;
123 
124 /**
125   * Please note that this interface was created as IUniswapV2Router02 uses
126   * Solidity >= 0.6.2, and the BZZ infastructure uses 0.5.0. 
127   */
128 interface I_router_02 {
129     // Views & Pure
130     function WETH() external pure returns (address);
131 
132     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
133    
134     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
135 
136     // State modifying
137     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
138         external
139         payable
140         returns (uint[] memory amounts);
141 
142     function swapExactTokensForETH(
143         uint amountIn, 
144         uint amountOutMin, 
145         address[] calldata path, 
146         address to, 
147         uint deadline
148     )
149         external
150         returns (uint[] memory amounts);
151 }
152 
153 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
154 
155 pragma solidity ^0.5.0;
156 
157 /**
158  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
159  * the optional functions; to access them see {ERC20Detailed}.
160  */
161 interface IERC20 {
162     /**
163      * @dev Returns the amount of tokens in existence.
164      */
165     function totalSupply() external view returns (uint256);
166 
167     /**
168      * @dev Returns the amount of tokens owned by `account`.
169      */
170     function balanceOf(address account) external view returns (uint256);
171 
172     /**
173      * @dev Moves `amount` tokens from the caller's account to `recipient`.
174      *
175      * Returns a boolean value indicating whether the operation succeeded.
176      *
177      * Emits a {Transfer} event.
178      */
179     function transfer(address recipient, uint256 amount) external returns (bool);
180 
181     /**
182      * @dev Returns the remaining number of tokens that `spender` will be
183      * allowed to spend on behalf of `owner` through {transferFrom}. This is
184      * zero by default.
185      *
186      * This value changes when {approve} or {transferFrom} are called.
187      */
188     function allowance(address owner, address spender) external view returns (uint256);
189 
190     /**
191      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
192      *
193      * Returns a boolean value indicating whether the operation succeeded.
194      *
195      * IMPORTANT: Beware that changing an allowance with this method brings the risk
196      * that someone may use both the old and the new allowance by unfortunate
197      * transaction ordering. One possible solution to mitigate this race
198      * condition is to first reduce the spender's allowance to 0 and set the
199      * desired value afterwards:
200      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
201      *
202      * Emits an {Approval} event.
203      */
204     function approve(address spender, uint256 amount) external returns (bool);
205 
206     /**
207      * @dev Moves `amount` tokens from `sender` to `recipient` using the
208      * allowance mechanism. `amount` is then deducted from the caller's
209      * allowance.
210      *
211      * Returns a boolean value indicating whether the operation succeeded.
212      *
213      * Emits a {Transfer} event.
214      */
215     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
216 
217     /**
218      * @dev Emitted when `value` tokens are moved from one account (`from`) to
219      * another (`to`).
220      *
221      * Note that `value` may be zero.
222      */
223     event Transfer(address indexed from, address indexed to, uint256 value);
224 
225     /**
226      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
227      * a call to {approve}. `value` is the new allowance.
228      */
229     event Approval(address indexed owner, address indexed spender, uint256 value);
230 }
231 
232 // File: contracts/Eth_broker.sol
233 
234 pragma solidity 0.5.0;
235 
236 
237 
238 
239 contract Eth_broker {
240     // The instance of the curve
241     I_Curve internal curve_;
242     // The instance of the Uniswap router
243     I_router_02 internal router_;
244     // The instance of the DAI token
245     IERC20 internal dai_;
246     // The address for the underlying token address
247     IERC20 internal bzz_;
248     // Mutex guard for state modifying functions
249     uint256 private status_;
250     // States for the guard 
251     uint256 private constant _NOT_ENTERED = 1;
252     uint256 private constant _ENTERED = 2;
253 
254     // -------------------------------------------------------------------------
255     // Events
256     // -------------------------------------------------------------------------
257 
258     // Emitted when tokens are minted
259     event mintTokensWithEth(
260         address indexed buyer,      // The address of the buyer
261         uint256 amount,             // The amount of bonded tokens to mint
262         uint256 priceForTokensDai,  // The price in DAI for the token amount
263         uint256 EthTradedForDai,    // The ETH amount sold for DAI
264         uint256 maxSpendDai         // The max amount of DAI to spend
265     );
266     // Emitted when tokens are minted
267     event mintTokensToWithEth(
268         address indexed buyer,      // The address of the buyer
269         address indexed receiver,   // The address of the receiver of the tokens
270         uint256 amount,             // The amount of bonded tokens to mint
271         uint256 priceForTokensDai,  // The price in DAI for the token amount
272         uint256 EthTradedForDai,    // The ETH amount sold for DAI
273         uint256 maxSpendDai         // The max amount of DAI to spend
274     );
275     // Emitted when tokens are burnt
276     event burnTokensWithEth(
277         address indexed seller,     // The address of the seller
278         uint256 amount,             // The amount of bonded tokens to burn
279         uint256 rewardReceivedDai,  // The amount of DAI received for selling
280         uint256 ethReceivedForDai,  // How much ETH the DAI was traded for
281         uint256 minRewardDai        // The min amount of DAI to sell for
282     );
283 
284     // -------------------------------------------------------------------------
285     // Modifiers
286     // -------------------------------------------------------------------------
287 
288     /**
289       * @notice Checks if the curve is active (may be redundant).
290       */
291     modifier isCurveActive() {
292         require(curve_.isCurveActive(), "Curve inactive");
293         _;
294     }
295 
296     /**
297       * @notice Protects against re-entrancy attacks
298       */
299     modifier mutex() {
300         require(status_ != _ENTERED, "ReentrancyGuard: reentrant call");
301         // Any calls to non Reentrant after this point will fail
302         status_ = _ENTERED;
303         // Function executes
304         _;
305         // Status set to not entered
306         status_ = _NOT_ENTERED;
307     }
308 
309     // -------------------------------------------------------------------------
310     // Constructor
311     // -------------------------------------------------------------------------
312 
313     constructor(
314         address _bzzCurve, 
315         address _collateralToken, 
316         address _router02
317     ) 
318         public 
319     {
320         require(
321             _bzzCurve != address(0) &&
322             _collateralToken != address(0) &&
323             _router02 != address(0),
324             "Addresses of contracts cannot be 0x address"
325         );
326         curve_ = I_Curve(_bzzCurve);
327         dai_ = IERC20(_collateralToken);
328         router_ = I_router_02(_router02);
329         // Setting the address of the underlying token (BZZ)
330         bzz_ = IERC20(curve_.bondedToken());
331     }
332 
333     // -------------------------------------------------------------------------
334     // View functions
335     // -------------------------------------------------------------------------
336 
337     /**
338      * @notice This function is only callable after the curve contract has been
339      *         initialized.
340      * @param  _amount The amount of tokens a user wants to buy
341      * @return uint256 The cost to buy the _amount of tokens in ETH
342      */
343     function buyPrice(uint256 _amount)
344         public
345         view
346         isCurveActive()
347         returns (uint256)
348     {
349         // Getting the current DAI cost for token amount
350         uint256 daiCost = curve_.buyPrice(_amount);
351         // Returning the required ETH to buy DAI amount
352         return router_.getAmountsIn(
353             daiCost, 
354             getPath(true)
355         )[0];
356     }
357 
358     /**
359      * @notice This function is only callable after the curve contract has been
360      *         initialized.
361      * @param  _amount The amount of tokens a user wants to sell
362      * @return uint256 The reward for selling the _amount of tokens in ETH
363      */
364     function sellReward(uint256 _amount)
365         public
366         view
367         isCurveActive()
368         returns (uint256)
369     {
370         // Getting the current DAI reward for token amount
371         uint256 daiReward = curve_.sellReward(_amount);
372         // Returning the ETH reward for token sale
373         return router_.getAmountsIn(
374             daiReward, 
375             getPath(true)
376         )[0];
377     }
378     
379     /**
380       * @param  _daiAmount The amount of dai to be traded for ETH
381       * @return uint256 The amount of ETH that can be traded for given the
382       *         dai amount
383       */
384     function sellRewardDai(uint256 _daiAmount)
385         public
386         view
387         isCurveActive()
388         returns (uint256)
389     {
390         // Returning the ETH reward for the dai amount
391         return router_.getAmountsIn(
392             _daiAmount, 
393             getPath(true)
394         )[0];
395     }
396     
397     /**
398       * @param  _buy If the path is for a buy or sell transaction
399       * @return address[] The path for the transaction
400       */
401     function getPath(bool _buy) public view returns(address[] memory) {
402         address[] memory buyPath = new address[](2);
403         if(_buy) {
404             buyPath[0] = router_.WETH();
405             buyPath[1] = address(dai_);
406         } else {
407             buyPath[0] = address(dai_);
408             buyPath[1] = router_.WETH();
409         }
410         
411         return buyPath;
412     }
413     
414     /**
415       * @return Gets the current time
416       */
417     function getTime() public view returns(uint256) {
418         return now;
419     }
420 
421     // -------------------------------------------------------------------------
422     // State modifying functions
423     // -------------------------------------------------------------------------
424 
425     /**
426       * @param  _tokenAmount The amount of BZZ tokens the user would like to
427       *         buy from the curve.
428       * @param  _maxDaiSpendAmount The max amount of collateral (DAI) the user
429       *         is willing to spend to buy the amount of tokens.
430       * @param  _deadline Unix timestamp after which the transaction will 
431       *         revert. - Taken from Uniswap documentation: 
432       *         https://uniswap.org/docs/v2/smart-contracts/router02/#swapethforexacttokens
433       * @return bool If the transaction completed successfully.
434       * @notice Before this function is called the caller does not need to
435       *         approve the spending of anything. Please assure that the amount
436       *         of ETH sent with this transaction is sufficient by first calling
437       *         `buyPrice` with the same token amount. Add your % slippage to
438       *         the max dai spend amount (you can get the expected amount by 
439       *         calling `buyPrice` on the curve contract).
440       */
441     function mint(
442         uint256 _tokenAmount, 
443         uint256 _maxDaiSpendAmount, 
444         uint _deadline
445     )
446         external
447         payable
448         isCurveActive()
449         mutex()
450         returns (bool)
451     {
452         (uint256 daiNeeded, uint256 ethReceived) = _commonMint(
453             _tokenAmount,
454             _maxDaiSpendAmount,
455             _deadline,
456             msg.sender
457         );
458         // Emitting event with all important info
459         emit mintTokensWithEth(
460             msg.sender, 
461             _tokenAmount, 
462             daiNeeded, 
463             ethReceived, 
464             _maxDaiSpendAmount
465         );
466         // Returning that the mint executed successfully
467         return true;
468     }
469 
470     /**
471       * @param  _tokenAmount The amount of BZZ tokens the user would like to
472       *         buy from the curve.
473       * @param  _maxDaiSpendAmount The max amount of collateral (DAI) the user
474       *         is willing to spend to buy the amount of tokens.
475       * @param  _deadline Unix timestamp after which the transaction will 
476       *         revert. - Taken from Uniswap documentation: 
477       *         https://uniswap.org/docs/v2/smart-contracts/router02/#swapethforexacttokens
478       * @return bool If the transaction completed successfully.
479       * @notice Before this function is called the caller does not need to
480       *         approve the spending of anything. Please assure that the amount
481       *         of ETH sent with this transaction is sufficient by first calling
482       *         `buyPrice` with the same token amount. Add your % slippage to
483       *         the max dai spend amount (you can get the expected amount by 
484       *         calling `buyPrice` on the curve contract).
485       */
486     function mintTo(
487         uint256 _tokenAmount, 
488         uint256 _maxDaiSpendAmount, 
489         uint _deadline,
490         address _to
491     )
492         external
493         payable
494         isCurveActive()
495         mutex()
496         returns (bool)
497     {
498         (uint256 daiNeeded, uint256 ethReceived) = _commonMint(
499             _tokenAmount,
500             _maxDaiSpendAmount,
501             _deadline,
502             _to
503         );
504         // Emitting event with all important info
505         emit mintTokensToWithEth(
506             msg.sender, 
507             _to,
508             _tokenAmount, 
509             daiNeeded, 
510             ethReceived, 
511             _maxDaiSpendAmount
512         );
513         // Returning that the mint executed successfully
514         return true;
515     }
516 
517     /**
518       * @notice The user needs to have approved this contract as a spender of
519       *         of the desired `_tokenAmount` to sell before calling this
520       *         transaction. Failure to do so will result in the call reverting.
521       *         This function is payable to receive ETH from internal calls.
522       *         Please do not send ETH to this function.
523       * @param  _tokenAmount The amount of BZZ tokens the user would like to
524       *         sell.
525       * @param  _minDaiSellValue The min value of collateral (DAI) the user
526       *         is willing to sell their tokens for.
527       * @param  _deadline Unix timestamp after which the transaction will 
528       *         revert. - Taken from Uniswap documentation: 
529       *         https://uniswap.org/docs/v2/smart-contracts/router02/#swapexacttokensforeth
530       * @return bool If the transaction completed successfully.
531       */
532     function redeem(
533         uint256 _tokenAmount, 
534         uint256 _minDaiSellValue,
535         uint _deadline
536     )
537         external
538         payable
539         isCurveActive()
540         mutex()
541         returns (bool)
542     {
543         // Gets the current reward for selling the amount of tokens
544         uint256 daiReward = curve_.sellReward(_tokenAmount);
545         // The check that the dai reward amount is not more than the min sell 
546         // amount happens in the curve.
547 
548         // Transferring _amount of tokens into this contract
549         require(
550             bzz_.transferFrom(
551                 msg.sender,
552                 address(this),
553                 _tokenAmount
554             ),
555             "Transferring BZZ failed"
556         );
557         // Approving the curve as a spender
558         require(
559             bzz_.approve(
560                 address(curve_),
561                 _tokenAmount
562             ),
563             "BZZ approve failed"
564         );
565         // Selling tokens for DAI
566         require(
567             curve_.redeem(
568                 _tokenAmount,
569                 daiReward
570             ),
571             "Curve burn failed"
572         );
573         // Getting expected ETH for DAI
574         uint256 ethMin = sellRewardDai(_minDaiSellValue);
575         // Approving the router as a spender
576         require(
577             dai_.approve(
578                 address(router_),
579                 daiReward
580             ),
581             "DAI approve failed"
582         );
583         // Selling DAI received for ETH
584         router_.swapExactTokensForETH(
585             daiReward, 
586             ethMin, 
587             getPath(false), 
588             msg.sender, 
589             _deadline
590         );
591         // Emitting event with all important info
592         emit burnTokensWithEth(
593             msg.sender, 
594             _tokenAmount, 
595             daiReward, 
596             ethMin, 
597             _minDaiSellValue
598         );
599         // Returning that the burn executed successfully
600         return true;
601     }
602 
603     function() external payable {
604         require(
605             msg.sender == address(router_),
606             "ETH not accepted outside router"
607         );
608     }
609 
610 
611     // -------------------------------------------------------------------------
612     // Internal functions
613     // -------------------------------------------------------------------------
614 
615     /**
616       * @param  _tokenAmount The amount of BZZ tokens the user would like to
617       *         buy from the curve.
618       * @param  _maxDaiSpendAmount The max amount of collateral (DAI) the user
619       *         is willing to spend to buy the amount of tokens.
620       * @param  _deadline Unix timestamp after which the transaction will 
621       *         revert. - Taken from Uniswap documentation: 
622       *         https://uniswap.org/docs/v2/smart-contracts/router02/#swapethforexacttokens
623       * @return uint256 The dai needed to buy the tokens.
624       * @return uint256 The Ether received from the user for the trade.
625       * @notice Before this function is called the caller does not need to
626       *         approve the spending of anything. Please assure that the amount
627       *         of ETH sent with this transaction is sufficient by first calling
628       *         `buyPrice` with the same token amount. Add your % slippage to
629       *         the max dai spend amount (you can get the expected amount by 
630       *         calling `buyPrice` on the curve contract).
631       */
632     function _commonMint(
633         uint256 _tokenAmount, 
634         uint256 _maxDaiSpendAmount, 
635         uint _deadline,
636         address _to
637     )
638         internal
639         returns(
640             uint256 daiNeeded,
641             uint256 ethReceived
642         )
643     {
644         // Getting the exact needed amount of DAI for desired token amount
645         daiNeeded = curve_.buyPrice(_tokenAmount);
646         // Checking that this amount is not more than the max spend amount
647         require(
648             _maxDaiSpendAmount >= daiNeeded,
649             "DAI required for trade above max"
650         );
651         // Swapping sent ETH for exact amount of DAI needed
652         router_.swapETHForExactTokens.value(msg.value)(
653             daiNeeded, 
654             getPath(true), 
655             address(this), 
656             _deadline
657         );
658         // Getting the amount of ETH received
659         ethReceived = address(this).balance;
660         // Approving the curve as a spender
661         require(
662             dai_.approve(address(curve_), daiNeeded),
663             "DAI approve failed"
664         );
665         // Buying tokens (BZZ) against the curve
666         require(
667             curve_.mintTo(_tokenAmount, daiNeeded, _to),
668             "BZZ mintTo failed"
669         );
670         // Refunding user excess ETH
671         msg.sender.transfer(ethReceived);
672     }
673 }