1 pragma solidity ^0.5.16;
2 
3 import "./ComptrollerInterface.sol";
4 import "./InterestRateModel.sol";
5 import "./ERC3156FlashBorrowerInterface.sol";
6 
7 contract CTokenStorage {
8     /**
9      * @dev Guard variable for re-entrancy checks
10      */
11     bool internal _notEntered;
12 
13     /**
14      * @notice EIP-20 token name for this token
15      */
16     string public name;
17 
18     /**
19      * @notice EIP-20 token symbol for this token
20      */
21     string public symbol;
22 
23     /**
24      * @notice EIP-20 token decimals for this token
25      */
26     uint8 public decimals;
27 
28     /**
29      * @notice Maximum borrow rate that can ever be applied (.0005% / block)
30      */
31 
32     uint256 internal constant borrowRateMaxMantissa = 0.0005e16;
33 
34     /**
35      * @notice Maximum fraction of interest that can be set aside for reserves
36      */
37     uint256 internal constant reserveFactorMaxMantissa = 1e18;
38 
39     /**
40      * @notice Administrator for this contract
41      */
42     address payable public admin;
43 
44     /**
45      * @notice Pending administrator for this contract
46      */
47     address payable public pendingAdmin;
48 
49     /**
50      * @notice Contract which oversees inter-cToken operations
51      */
52     ComptrollerInterface public comptroller;
53 
54     /**
55      * @notice Model which tells what the current interest rate should be
56      */
57     InterestRateModel public interestRateModel;
58 
59     /**
60      * @notice Initial exchange rate used when minting the first CTokens (used when totalSupply = 0)
61      */
62     uint256 internal initialExchangeRateMantissa;
63 
64     /**
65      * @notice Fraction of interest currently set aside for reserves
66      */
67     uint256 public reserveFactorMantissa;
68 
69     /**
70      * @notice Block number that interest was last accrued at
71      */
72     uint256 public accrualBlockNumber;
73 
74     /**
75      * @notice Accumulator of the total earned interest rate since the opening of the market
76      */
77     uint256 public borrowIndex;
78 
79     /**
80      * @notice Total amount of outstanding borrows of the underlying in this market
81      */
82     uint256 public totalBorrows;
83 
84     /**
85      * @notice Total amount of reserves of the underlying held in this market
86      */
87     uint256 public totalReserves;
88 
89     /**
90      * @notice Total number of tokens in circulation
91      */
92     uint256 public totalSupply;
93 
94     /**
95      * @notice Official record of token balances for each account
96      */
97     mapping(address => uint256) internal accountTokens;
98 
99     /**
100      * @notice Approved token transfer amounts on behalf of others
101      */
102     mapping(address => mapping(address => uint256)) internal transferAllowances;
103 
104     /**
105      * @notice Container for borrow balance information
106      * @member principal Total balance (with accrued interest), after applying the most recent balance-changing action
107      * @member interestIndex Global borrowIndex as of the most recent balance-changing action
108      */
109     struct BorrowSnapshot {
110         uint256 principal;
111         uint256 interestIndex;
112     }
113 
114     /**
115      * @notice Mapping of account addresses to outstanding borrow balances
116      */
117     mapping(address => BorrowSnapshot) internal accountBorrows;
118 }
119 
120 contract CErc20Storage {
121     /**
122      * @notice Underlying asset for this CToken
123      */
124     address public underlying;
125 
126     /**
127      * @notice Implementation address for this contract
128      */
129     address public implementation;
130 }
131 
132 contract CSupplyCapStorage {
133     /**
134      * @notice Internal cash counter for this CToken. Should equal underlying.balanceOf(address(this)) for CERC20.
135      */
136     uint256 public internalCash;
137 }
138 
139 contract CCollateralCapStorage {
140     /**
141      * @notice Total number of tokens used as collateral in circulation.
142      */
143     uint256 public totalCollateralTokens;
144 
145     /**
146      * @notice Record of token balances which could be treated as collateral for each account.
147      *         If collateral cap is not set, the value should be equal to accountTokens.
148      */
149     mapping(address => uint256) public accountCollateralTokens;
150 
151     /**
152      * @notice Check if accountCollateralTokens have been initialized.
153      */
154     mapping(address => bool) public isCollateralTokenInit;
155 
156     /**
157      * @notice Collateral cap for this CToken, zero for no cap.
158      */
159     uint256 public collateralCap;
160 }
161 
162 /*** Interface ***/
163 
164 contract CTokenInterface is CTokenStorage {
165     /**
166      * @notice Indicator that this is a CToken contract (for inspection)
167      */
168     bool public constant isCToken = true;
169 
170     /*** Market Events ***/
171 
172     /**
173      * @notice Event emitted when interest is accrued
174      */
175     event AccrueInterest(uint256 cashPrior, uint256 interestAccumulated, uint256 borrowIndex, uint256 totalBorrows);
176 
177     /**
178      * @notice Event emitted when tokens are minted
179      */
180     event Mint(address minter, uint256 mintAmount, uint256 mintTokens);
181 
182     /**
183      * @notice Event emitted when tokens are redeemed
184      */
185     event Redeem(address redeemer, uint256 redeemAmount, uint256 redeemTokens);
186 
187     /**
188      * @notice Event emitted when underlying is borrowed
189      */
190     event Borrow(address borrower, uint256 borrowAmount, uint256 accountBorrows, uint256 totalBorrows);
191 
192     /**
193      * @notice Event emitted when a borrow is repaid
194      */
195     event RepayBorrow(
196         address payer,
197         address borrower,
198         uint256 repayAmount,
199         uint256 accountBorrows,
200         uint256 totalBorrows
201     );
202 
203     /**
204      * @notice Event emitted when a borrow is liquidated
205      */
206     event LiquidateBorrow(
207         address liquidator,
208         address borrower,
209         uint256 repayAmount,
210         address cTokenCollateral,
211         uint256 seizeTokens
212     );
213 
214     /*** Admin Events ***/
215 
216     /**
217      * @notice Event emitted when pendingAdmin is changed
218      */
219     event NewPendingAdmin(address oldPendingAdmin, address newPendingAdmin);
220 
221     /**
222      * @notice Event emitted when pendingAdmin is accepted, which means admin is updated
223      */
224     event NewAdmin(address oldAdmin, address newAdmin);
225 
226     /**
227      * @notice Event emitted when comptroller is changed
228      */
229     event NewComptroller(ComptrollerInterface oldComptroller, ComptrollerInterface newComptroller);
230 
231     /**
232      * @notice Event emitted when interestRateModel is changed
233      */
234     event NewMarketInterestRateModel(InterestRateModel oldInterestRateModel, InterestRateModel newInterestRateModel);
235 
236     /**
237      * @notice Event emitted when the reserve factor is changed
238      */
239     event NewReserveFactor(uint256 oldReserveFactorMantissa, uint256 newReserveFactorMantissa);
240 
241     /**
242      * @notice Event emitted when the reserves are added
243      */
244     event ReservesAdded(address benefactor, uint256 addAmount, uint256 newTotalReserves);
245 
246     /**
247      * @notice Event emitted when the reserves are reduced
248      */
249     event ReservesReduced(address admin, uint256 reduceAmount, uint256 newTotalReserves);
250 
251     /**
252      * @notice EIP20 Transfer event
253      */
254     event Transfer(address indexed from, address indexed to, uint256 amount);
255 
256     /**
257      * @notice EIP20 Approval event
258      */
259     event Approval(address indexed owner, address indexed spender, uint256 amount);
260 
261     /**
262      * @notice Failure event
263      */
264     event Failure(uint256 error, uint256 info, uint256 detail);
265 
266     /*** User Interface ***/
267 
268     function transfer(address dst, uint256 amount) external returns (bool);
269 
270     function transferFrom(
271         address src,
272         address dst,
273         uint256 amount
274     ) external returns (bool);
275 
276     function approve(address spender, uint256 amount) external returns (bool);
277 
278     function allowance(address owner, address spender) external view returns (uint256);
279 
280     function balanceOf(address owner) external view returns (uint256);
281 
282     function balanceOfUnderlying(address owner) external returns (uint256);
283 
284     function getAccountSnapshot(address account)
285         external
286         view
287         returns (
288             uint256,
289             uint256,
290             uint256,
291             uint256
292         );
293 
294     function borrowRatePerBlock() external view returns (uint256);
295 
296     function supplyRatePerBlock() external view returns (uint256);
297 
298     function totalBorrowsCurrent() external returns (uint256);
299 
300     function borrowBalanceCurrent(address account) external returns (uint256);
301 
302     function borrowBalanceStored(address account) public view returns (uint256);
303 
304     function exchangeRateCurrent() public returns (uint256);
305 
306     function exchangeRateStored() public view returns (uint256);
307 
308     function getCash() external view returns (uint256);
309 
310     function accrueInterest() public returns (uint256);
311 
312     function seize(
313         address liquidator,
314         address borrower,
315         uint256 seizeTokens
316     ) external returns (uint256);
317 
318     /*** Admin Functions ***/
319 
320     function _setPendingAdmin(address payable newPendingAdmin) external returns (uint256);
321 
322     function _acceptAdmin() external returns (uint256);
323 
324     function _setComptroller(ComptrollerInterface newComptroller) public returns (uint256);
325 
326     function _setReserveFactor(uint256 newReserveFactorMantissa) external returns (uint256);
327 
328     function _reduceReserves(uint256 reduceAmount) external returns (uint256);
329 
330     function _setInterestRateModel(InterestRateModel newInterestRateModel) public returns (uint256);
331 }
332 
333 contract CErc20Interface is CErc20Storage {
334     /*** User Interface ***/
335 
336     function mint(uint256 mintAmount) external returns (uint256);
337 
338     function redeem(uint256 redeemTokens) external returns (uint256);
339 
340     function redeemUnderlying(uint256 redeemAmount) external returns (uint256);
341 
342     function borrow(uint256 borrowAmount) external returns (uint256);
343 
344     function repayBorrow(uint256 repayAmount) external returns (uint256);
345 
346     function repayBorrowBehalf(address borrower, uint256 repayAmount) external returns (uint256);
347 
348     function liquidateBorrow(
349         address borrower,
350         uint256 repayAmount,
351         CTokenInterface cTokenCollateral
352     ) external returns (uint256);
353 
354     function _addReserves(uint256 addAmount) external returns (uint256);
355 }
356 
357 contract CWrappedNativeInterface is CErc20Interface {
358     /**
359      * @notice Flash loan fee ratio
360      */
361     uint256 public constant flashFeeBips = 3;
362 
363     /*** Market Events ***/
364 
365     /**
366      * @notice Event emitted when a flashloan occured
367      */
368     event Flashloan(address indexed receiver, uint256 amount, uint256 totalFee, uint256 reservesFee);
369 
370     /*** User Interface ***/
371 
372     function mintNative() external payable returns (uint256);
373 
374     function redeemNative(uint256 redeemTokens) external returns (uint256);
375 
376     function redeemUnderlyingNative(uint256 redeemAmount) external returns (uint256);
377 
378     function borrowNative(uint256 borrowAmount) external returns (uint256);
379 
380     function repayBorrowNative() external payable returns (uint256);
381 
382     function repayBorrowBehalfNative(address borrower) external payable returns (uint256);
383 
384     function liquidateBorrowNative(address borrower, CTokenInterface cTokenCollateral)
385         external
386         payable
387         returns (uint256);
388 
389     function flashLoan(
390         ERC3156FlashBorrowerInterface receiver,
391         address initiator,
392         uint256 amount,
393         bytes calldata data
394     ) external returns (bool);
395 
396     function _addReservesNative() external payable returns (uint256);
397 
398     function collateralCap() external view returns (uint256);
399 
400     function totalCollateralTokens() external view returns (uint256);
401 }
402 
403 contract CCapableErc20Interface is CErc20Interface, CSupplyCapStorage {
404     /**
405      * @notice Flash loan fee ratio
406      */
407     uint256 public constant flashFeeBips = 3;
408 
409     /*** Market Events ***/
410 
411     /**
412      * @notice Event emitted when a flashloan occured
413      */
414     event Flashloan(address indexed receiver, uint256 amount, uint256 totalFee, uint256 reservesFee);
415 
416     /*** User Interface ***/
417 
418     function gulp() external;
419 }
420 
421 contract CCollateralCapErc20Interface is CCapableErc20Interface, CCollateralCapStorage {
422     /*** Admin Events ***/
423 
424     /**
425      * @notice Event emitted when collateral cap is set
426      */
427     event NewCollateralCap(address token, uint256 newCap);
428 
429     /**
430      * @notice Event emitted when user collateral is changed
431      */
432     event UserCollateralChanged(address account, uint256 newCollateralTokens);
433 
434     /*** User Interface ***/
435 
436     function registerCollateral(address account) external returns (uint256);
437 
438     function unregisterCollateral(address account) external;
439 
440     function flashLoan(
441         ERC3156FlashBorrowerInterface receiver,
442         address initiator,
443         uint256 amount,
444         bytes calldata data
445     ) external returns (bool);
446 
447     /*** Admin Functions ***/
448 
449     function _setCollateralCap(uint256 newCollateralCap) external;
450 }
451 
452 contract CDelegatorInterface {
453     /**
454      * @notice Emitted when implementation is changed
455      */
456     event NewImplementation(address oldImplementation, address newImplementation);
457 
458     /**
459      * @notice Called by the admin to update the implementation of the delegator
460      * @param implementation_ The address of the new implementation for delegation
461      * @param allowResign Flag to indicate whether to call _resignImplementation on the old implementation
462      * @param becomeImplementationData The encoded bytes data to be passed to _becomeImplementation
463      */
464     function _setImplementation(
465         address implementation_,
466         bool allowResign,
467         bytes memory becomeImplementationData
468     ) public;
469 }
470 
471 contract CDelegateInterface {
472     /**
473      * @notice Called by the delegator on a delegate to initialize it for duty
474      * @dev Should revert if any issues arise which make it unfit for delegation
475      * @param data The encoded bytes data for any initialization
476      */
477     function _becomeImplementation(bytes memory data) public;
478 
479     /**
480      * @notice Called by the delegator on a delegate to forfeit its responsibility
481      */
482     function _resignImplementation() public;
483 }
484 
485 /*** External interface ***/
486 
487 /**
488  * @title Flash loan receiver interface
489  */
490 interface IFlashloanReceiver {
491     function executeOperation(
492         address sender,
493         address underlying,
494         uint256 amount,
495         uint256 fee,
496         bytes calldata params
497     ) external;
498 }
