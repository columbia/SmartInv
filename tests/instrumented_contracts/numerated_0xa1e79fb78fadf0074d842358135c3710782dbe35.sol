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
137         address collateralTokenAddressFilled,
138         address positionTokenAddressFilled,
139         uint loanTokenAmountFilled,
140         uint collateralTokenAmountFilled,
141         uint positionTokenAmountFilled,
142         uint loanStartUnixTimestampSec,
143         bool active,
144         bytes32 indexed loanOrderHash
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
159         bytes32 indexed loanOrderHash
160     );
161 
162     event LogPositionTraded(
163         bytes32 indexed loanOrderHash,
164         address indexed trader,
165         address sourceTokenAddress,
166         address destTokenAddress,
167         uint sourceTokenAmount,
168         uint destTokenAmount
169     );
170 
171     event LogMarginLevels(
172         bytes32 indexed loanOrderHash,
173         address indexed trader,
174         uint initialMarginAmount,
175         uint maintenanceMarginAmount,
176         uint currentMarginAmount
177     );
178 
179     event LogWithdrawProfit(
180         bytes32 indexed loanOrderHash,
181         address indexed trader,
182         uint profitWithdrawn,
183         uint remainingPosition
184     );
185 
186     event LogPayInterestForOrder(
187         bytes32 indexed loanOrderHash,
188         address indexed lender,
189         uint amountPaid,
190         uint totalAccrued,
191         uint loanCount
192     );
193 
194     event LogPayInterestForPosition(
195         bytes32 indexed loanOrderHash,
196         address indexed lender,
197         address indexed trader,
198         uint amountPaid,
199         uint totalAccrued
200     );
201 
202     event LogChangeTraderOwnership(
203         bytes32 indexed loanOrderHash,
204         address indexed oldOwner,
205         address indexed newOwner
206     );
207 
208     event LogChangeLenderOwnership(
209         bytes32 indexed loanOrderHash,
210         address indexed oldOwner,
211         address indexed newOwner
212     );
213 
214     event LogIncreasedLoanableAmount(
215         bytes32 indexed loanOrderHash,
216         address indexed lender,
217         uint loanTokenAmountAdded,
218         uint loanTokenAmountFillable
219     );
220 }
221 
222 contract BZxObjects {
223 
224     struct ListIndex {
225         uint index;
226         bool isSet;
227     }
228 
229     struct LoanOrder {
230         address loanTokenAddress;
231         address interestTokenAddress;
232         address collateralTokenAddress;
233         address oracleAddress;
234         uint loanTokenAmount;
235         uint interestAmount;
236         uint initialMarginAmount;
237         uint maintenanceMarginAmount;
238         uint maxDurationUnixTimestampSec;
239         bytes32 loanOrderHash;
240     }
241 
242     struct LoanOrderAux {
243         address maker;
244         address feeRecipientAddress;
245         uint lenderRelayFee;
246         uint traderRelayFee;
247         uint makerRole;
248         uint expirationUnixTimestampSec;
249     }
250 
251     struct LoanPosition {
252         address trader;
253         address collateralTokenAddressFilled;
254         address positionTokenAddressFilled;
255         uint loanTokenAmountFilled;
256         uint loanTokenAmountUsed;
257         uint collateralTokenAmountFilled;
258         uint positionTokenAmountFilled;
259         uint loanStartUnixTimestampSec;
260         uint loanEndUnixTimestampSec;
261         bool active;
262     }
263 
264     struct PositionRef {
265         bytes32 loanOrderHash;
266         uint positionId;
267     }
268 
269     struct InterestData {
270         address lender;
271         address interestTokenAddress;
272         uint interestTotalAccrued;
273         uint interestPaidSoFar;
274     }
275 
276 }
277 
278 contract BZxStorage is BZxObjects, BZxEvents, ReentrancyGuard, Ownable, GasTracker {
279     uint internal constant MAX_UINT = 2**256 - 1;
280 
281     address public bZRxTokenContract;
282     address public vaultContract;
283     address public oracleRegistryContract;
284     address public bZxTo0xContract;
285     address public bZxTo0xV2Contract;
286     bool public DEBUG_MODE = false;
287 
288     // Loan Orders
289     mapping (bytes32 => LoanOrder) public orders; // mapping of loanOrderHash to on chain loanOrders
290     mapping (bytes32 => LoanOrderAux) public orderAux; // mapping of loanOrderHash to on chain loanOrder auxiliary parameters
291     mapping (bytes32 => uint) public orderFilledAmounts; // mapping of loanOrderHash to loanTokenAmount filled
292     mapping (bytes32 => uint) public orderCancelledAmounts; // mapping of loanOrderHash to loanTokenAmount cancelled
293     mapping (bytes32 => address) public orderLender; // mapping of loanOrderHash to lender (only one lender per order)
294 
295     // Loan Positions
296     mapping (uint => LoanPosition) public loanPositions; // mapping of position ids to loanPositions
297     mapping (bytes32 => mapping (address => uint)) public loanPositionsIds; // mapping of loanOrderHash to mapping of trader address to position id
298 
299     // Lists
300     mapping (address => bytes32[]) public orderList; // mapping of lenders and trader addresses to array of loanOrderHashes
301     mapping (bytes32 => mapping (address => ListIndex)) public orderListIndex; // mapping of loanOrderHash to mapping of lenders and trader addresses to ListIndex objects
302 
303     mapping (bytes32 => uint[]) public orderPositionList; // mapping of loanOrderHash to array of order position ids
304 
305     PositionRef[] public positionList; // array of loans that need to be checked for liquidation or expiration
306     mapping (uint => ListIndex) public positionListIndex; // mapping of position ids to ListIndex objects
307 
308     // Other Storage
309     mapping (bytes32 => mapping (uint => uint)) public interestPaid; // mapping of loanOrderHash to mapping of position ids to amount of interest paid so far to a lender
310     mapping (address => address) public oracleAddresses; // mapping of oracles to their current logic contract
311     mapping (bytes32 => mapping (address => bool)) public preSigned; // mapping of hash => signer => signed
312     mapping (address => mapping (address => bool)) public allowedValidators; // mapping of signer => validator => approved
313 }
314 
315 contract BZxProxiable {
316     mapping (bytes4 => address) public targets;
317 
318     mapping (bytes4 => bool) public targetIsPaused;
319 
320     function initialize(address _target) public;
321 }
322 
323 contract BZxProxy is BZxStorage, BZxProxiable {
324     
325     constructor(
326         address _settings) 
327         public
328     {
329         require(_settings.delegatecall(bytes4(keccak256("initialize(address)")), _settings), "BZxProxy::constructor: failed");
330     }
331     
332     function() 
333         payable 
334         public
335     {
336         require(!targetIsPaused[msg.sig], "BZxProxy::Function temporarily paused");
337 
338         address target = targets[msg.sig];
339         require(target != address(0), "BZxProxy::Target not found");
340 
341         bytes memory data = msg.data;
342         assembly {
343             let result := delegatecall(gas, target, add(data, 0x20), mload(data), 0, 0)
344             let size := returndatasize
345             let ptr := mload(0x40)
346             returndatacopy(ptr, 0, size)
347             switch result
348             case 0 { revert(ptr, size) }
349             default { return(ptr, size) }
350         }
351     }
352 
353     function initialize(
354         address)
355         public
356     {
357         revert();
358     }
359 }