1 /**
2  * Copyright 2017–2018, bZeroX, LLC. All Rights Reserved.
3  * Licensed under the Apache License, Version 2.0.
4  */
5  
6 pragma solidity 0.4.24;
7 
8 
9 /**
10  * @title Helps contracts guard against reentrancy attacks.
11  * @author Remco Bloemen <remco@2π.com>, Eenae <alexey@mixbytes.io>
12  * @dev If you mark a function `nonReentrant`, you should also
13  * mark it `external`.
14  */
15 contract ReentrancyGuard {
16 
17   /// @dev Constant for unlocked guard state - non-zero to prevent extra gas costs.
18   /// See: https://github.com/OpenZeppelin/openzeppelin-solidity/issues/1056
19   uint private constant REENTRANCY_GUARD_FREE = 1;
20 
21   /// @dev Constant for locked guard state
22   uint private constant REENTRANCY_GUARD_LOCKED = 2;
23 
24   /**
25    * @dev We use a single lock for the whole contract.
26    */
27   uint private reentrancyLock = REENTRANCY_GUARD_FREE;
28 
29   /**
30    * @dev Prevents a contract from calling itself, directly or indirectly.
31    * If you mark a function `nonReentrant`, you should also
32    * mark it `external`. Calling one `nonReentrant` function from
33    * another is not supported. Instead, you can implement a
34    * `private` function doing the actual work, and an `external`
35    * wrapper marked as `nonReentrant`.
36    */
37   modifier nonReentrant() {
38     require(reentrancyLock == REENTRANCY_GUARD_FREE);
39     reentrancyLock = REENTRANCY_GUARD_LOCKED;
40     _;
41     reentrancyLock = REENTRANCY_GUARD_FREE;
42   }
43 
44 }
45 
46 /**
47  * @title Ownable
48  * @dev The Ownable contract has an owner address, and provides basic authorization control
49  * functions, this simplifies the implementation of "user permissions".
50  */
51 contract Ownable {
52   address public owner;
53 
54 
55   event OwnershipRenounced(address indexed previousOwner);
56   event OwnershipTransferred(
57     address indexed previousOwner,
58     address indexed newOwner
59   );
60 
61 
62   /**
63    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
64    * account.
65    */
66   constructor() public {
67     owner = msg.sender;
68   }
69 
70   /**
71    * @dev Throws if called by any account other than the owner.
72    */
73   modifier onlyOwner() {
74     require(msg.sender == owner);
75     _;
76   }
77 
78   /**
79    * @dev Allows the current owner to relinquish control of the contract.
80    * @notice Renouncing to ownership will leave the contract without an owner.
81    * It will not be possible to call the functions with the `onlyOwner`
82    * modifier anymore.
83    */
84   function renounceOwnership() public onlyOwner {
85     emit OwnershipRenounced(owner);
86     owner = address(0);
87   }
88 
89   /**
90    * @dev Allows the current owner to transfer control of the contract to a newOwner.
91    * @param _newOwner The address to transfer ownership to.
92    */
93   function transferOwnership(address _newOwner) public onlyOwner {
94     _transferOwnership(_newOwner);
95   }
96 
97   /**
98    * @dev Transfers control of the contract to a newOwner.
99    * @param _newOwner The address to transfer ownership to.
100    */
101   function _transferOwnership(address _newOwner) internal {
102     require(_newOwner != address(0));
103     emit OwnershipTransferred(owner, _newOwner);
104     owner = _newOwner;
105   }
106 }
107 
108 contract GasTracker {
109     uint internal gasUsed;
110 
111     modifier tracksGas() {
112         // tx call 21k gas
113         gasUsed = gasleft() + 21000;
114 
115         _; // modified function body inserted here
116 
117         gasUsed = 0; // zero out the storage so we don't persist anything
118     }
119 }
120 
121 contract BZxEvents {
122 
123     event LogLoanAdded (
124         bytes32 indexed loanOrderHash,
125         address adder,
126         address indexed maker,
127         address indexed feeRecipientAddress,
128         uint lenderRelayFee,
129         uint traderRelayFee,
130         uint maxDuration,
131         uint makerRole
132     );
133 
134     event LogLoanTaken (
135         address indexed lender,
136         address indexed trader,
137         address loanTokenAddress,
138         address collateralTokenAddress,
139         uint loanTokenAmount,
140         uint collateralTokenAmount,
141         uint loanEndUnixTimestampSec,
142         bool firstFill,
143         bytes32 indexed loanOrderHash,
144         uint positionId
145     );
146 
147     event LogLoanCancelled(
148         address indexed maker,
149         uint cancelLoanTokenAmount,
150         uint remainingLoanTokenAmount,
151         bytes32 indexed loanOrderHash
152     );
153 
154     event LogLoanClosed(
155         address indexed lender,
156         address indexed trader,
157         address loanCloser,
158         bool isLiquidation,
159         bytes32 indexed loanOrderHash,
160         uint positionId
161     );
162 
163     event LogPositionTraded(
164         bytes32 indexed loanOrderHash,
165         address indexed trader,
166         address sourceTokenAddress,
167         address destTokenAddress,
168         uint sourceTokenAmount,
169         uint destTokenAmount,
170         uint positionId
171     );
172 
173     event LogMarginLevels(
174         bytes32 indexed loanOrderHash,
175         address indexed trader,
176         uint initialMarginAmount,
177         uint maintenanceMarginAmount,
178         uint currentMarginAmount,
179         uint positionId
180     );
181 
182     event LogWithdrawProfit(
183         bytes32 indexed loanOrderHash,
184         address indexed trader,
185         uint profitWithdrawn,
186         uint remainingPosition,
187         uint positionId
188     );
189 
190     event LogPayInterestForOrder(
191         bytes32 indexed loanOrderHash,
192         address indexed lender,
193         uint amountPaid,
194         uint totalAccrued,
195         uint loanCount
196     );
197 
198     event LogPayInterestForPosition(
199         bytes32 indexed loanOrderHash,
200         address indexed lender,
201         address indexed trader,
202         uint amountPaid,
203         uint totalAccrued,
204         uint positionId
205     );
206 
207     event LogChangeTraderOwnership(
208         bytes32 indexed loanOrderHash,
209         address indexed oldOwner,
210         address indexed newOwner
211     );
212 
213     event LogChangeLenderOwnership(
214         bytes32 indexed loanOrderHash,
215         address indexed oldOwner,
216         address indexed newOwner
217     );
218 
219     event LogIncreasedLoanableAmount(
220         bytes32 indexed loanOrderHash,
221         address indexed lender,
222         uint loanTokenAmountAdded,
223         uint loanTokenAmountFillable
224     );
225 }
226 
227 contract BZxObjects {
228 
229     struct ListIndex {
230         uint index;
231         bool isSet;
232     }
233 
234     struct LoanOrder {
235         address loanTokenAddress;
236         address interestTokenAddress;
237         address collateralTokenAddress;
238         address oracleAddress;
239         uint loanTokenAmount;
240         uint interestAmount;
241         uint initialMarginAmount;
242         uint maintenanceMarginAmount;
243         uint maxDurationUnixTimestampSec;
244         bytes32 loanOrderHash;
245     }
246 
247     struct LoanOrderAux {
248         address maker;
249         address feeRecipientAddress;
250         uint lenderRelayFee;
251         uint traderRelayFee;
252         uint makerRole;
253         uint expirationUnixTimestampSec;
254     }
255 
256     struct LoanPosition {
257         address trader;
258         address collateralTokenAddressFilled;
259         address positionTokenAddressFilled;
260         uint loanTokenAmountFilled;
261         uint loanTokenAmountUsed;
262         uint collateralTokenAmountFilled;
263         uint positionTokenAmountFilled;
264         uint loanStartUnixTimestampSec;
265         uint loanEndUnixTimestampSec;
266         bool active;
267         uint positionId;
268     }
269 
270     struct PositionRef {
271         bytes32 loanOrderHash;
272         uint positionId;
273     }
274 
275     struct InterestData {
276         address lender;
277         address interestTokenAddress;
278         uint interestTotalAccrued;
279         uint interestPaidSoFar;
280         uint interestLastPaidDate;
281     }
282 
283 }
284 
285 contract BZxStorage is BZxObjects, BZxEvents, ReentrancyGuard, Ownable, GasTracker {
286     uint internal constant MAX_UINT = 2**256 - 1;
287 
288     address public bZRxTokenContract;
289     address public vaultContract;
290     address public oracleRegistryContract;
291     address public bZxTo0xContract;
292     address public bZxTo0xV2Contract;
293     bool public DEBUG_MODE = false;
294 
295     // Loan Orders
296     mapping (bytes32 => LoanOrder) public orders; // mapping of loanOrderHash to on chain loanOrders
297     mapping (bytes32 => LoanOrderAux) public orderAux; // mapping of loanOrderHash to on chain loanOrder auxiliary parameters
298     mapping (bytes32 => uint) public orderFilledAmounts; // mapping of loanOrderHash to loanTokenAmount filled
299     mapping (bytes32 => uint) public orderCancelledAmounts; // mapping of loanOrderHash to loanTokenAmount cancelled
300     mapping (bytes32 => address) public orderLender; // mapping of loanOrderHash to lender (only one lender per order)
301 
302     // Loan Positions
303     mapping (uint => LoanPosition) public loanPositions; // mapping of position ids to loanPositions
304     mapping (bytes32 => mapping (address => uint)) public loanPositionsIds; // mapping of loanOrderHash to mapping of trader address to position id
305 
306     // Lists
307     mapping (address => bytes32[]) public orderList; // mapping of lenders and trader addresses to array of loanOrderHashes
308     mapping (bytes32 => mapping (address => ListIndex)) public orderListIndex; // mapping of loanOrderHash to mapping of lenders and trader addresses to ListIndex objects
309 
310     mapping (bytes32 => uint[]) public orderPositionList; // mapping of loanOrderHash to array of order position ids
311 
312     PositionRef[] public positionList; // array of loans that need to be checked for liquidation or expiration
313     mapping (uint => ListIndex) public positionListIndex; // mapping of position ids to ListIndex objects
314 
315     // Interest
316     mapping (bytes32 => mapping (uint => uint)) public interestTotal; // mapping of loanOrderHash to mapping of position ids to total interest escrowed when the loan opens
317     mapping (bytes32 => mapping (uint => uint)) public interestPaid; // mapping of loanOrderHash to mapping of position ids to amount of interest paid so far to a lender
318     mapping (bytes32 => mapping (uint => uint)) public interestPaidDate; // mapping of loanOrderHash to mapping of position ids to timestamp of last interest pay date
319 
320     // Other Storage
321     mapping (address => address) public oracleAddresses; // mapping of oracles to their current logic contract
322     mapping (bytes32 => mapping (address => bool)) public preSigned; // mapping of hash => signer => signed
323     mapping (address => mapping (address => bool)) public allowedValidators; // mapping of signer => validator => approved
324 }
325 
326 contract BZxProxiable {
327     mapping (bytes4 => address) public targets;
328 
329     mapping (bytes4 => bool) public targetIsPaused;
330 
331     function initialize(address _target) public;
332 }
333 
334 contract BZxProxy is BZxStorage, BZxProxiable {
335     
336     constructor(
337         address _settings) 
338         public
339     {
340         require(_settings.delegatecall(bytes4(keccak256("initialize(address)")), _settings), "BZxProxy::constructor: failed");
341     }
342     
343     function() 
344         public
345         payable 
346     {
347         require(!targetIsPaused[msg.sig], "BZxProxy::Function temporarily paused");
348 
349         address target = targets[msg.sig];
350         require(target != address(0), "BZxProxy::Target not found");
351 
352         bytes memory data = msg.data;
353         assembly {
354             let result := delegatecall(gas, target, add(data, 0x20), mload(data), 0, 0)
355             let size := returndatasize
356             let ptr := mload(0x40)
357             returndatacopy(ptr, 0, size)
358             switch result
359             case 0 { revert(ptr, size) }
360             default { return(ptr, size) }
361         }
362     }
363 
364     function initialize(
365         address)
366         public
367     {
368         revert();
369     }
370 }