1 /**
2  * Copyright 2017–2018, bZeroX, LLC. All Rights Reserved.
3  * Licensed under the Apache License, Version 2.0.
4  */
5  
6 pragma solidity 0.5.2;
7 
8 
9 /**
10  * @title Ownable
11  * @dev The Ownable contract has an owner address, and provides basic authorization control
12  * functions, this simplifies the implementation of "user permissions".
13  */
14 contract Ownable {
15   address public owner;
16 
17 
18   event OwnershipTransferred(
19     address indexed previousOwner,
20     address indexed newOwner
21   );
22 
23 
24   /**
25    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
26    * account.
27    */
28   constructor() public {
29     owner = msg.sender;
30   }
31 
32   /**
33    * @dev Throws if called by any account other than the owner.
34    */
35   modifier onlyOwner() {
36     require(msg.sender == owner);
37     _;
38   }
39 
40   /**
41    * @dev Allows the current owner to transfer control of the contract to a newOwner.
42    * @param _newOwner The address to transfer ownership to.
43    */
44   function transferOwnership(address _newOwner) public onlyOwner {
45     _transferOwnership(_newOwner);
46   }
47 
48   /**
49    * @dev Transfers control of the contract to a newOwner.
50    * @param _newOwner The address to transfer ownership to.
51    */
52   function _transferOwnership(address _newOwner) internal {
53     require(_newOwner != address(0));
54     emit OwnershipTransferred(owner, _newOwner);
55     owner = _newOwner;
56   }
57 }
58 
59 /**
60  * @title Helps contracts guard against reentrancy attacks.
61  * @author Remco Bloemen <remco@2π.com>, Eenae <alexey@mixbytes.io>
62  * @dev If you mark a function `nonReentrant`, you should also
63  * mark it `external`.
64  */
65 contract ReentrancyGuard {
66 
67   /// @dev Constant for unlocked guard state - non-zero to prevent extra gas costs.
68   /// See: https://github.com/OpenZeppelin/openzeppelin-solidity/issues/1056
69   uint256 private constant REENTRANCY_GUARD_FREE = 1;
70 
71   /// @dev Constant for locked guard state
72   uint256 private constant REENTRANCY_GUARD_LOCKED = 2;
73 
74   /**
75    * @dev We use a single lock for the whole contract.
76    */
77   uint256 private reentrancyLock = REENTRANCY_GUARD_FREE;
78 
79   /**
80    * @dev Prevents a contract from calling itself, directly or indirectly.
81    * If you mark a function `nonReentrant`, you should also
82    * mark it `external`. Calling one `nonReentrant` function from
83    * another is not supported. Instead, you can implement a
84    * `private` function doing the actual work, and an `external`
85    * wrapper marked as `nonReentrant`.
86    */
87   modifier nonReentrant() {
88     require(reentrancyLock == REENTRANCY_GUARD_FREE);
89     reentrancyLock = REENTRANCY_GUARD_LOCKED;
90     _;
91     reentrancyLock = REENTRANCY_GUARD_FREE;
92   }
93 
94 }
95 
96 contract GasTracker {
97 
98     uint256 internal gasUsed;
99 
100     modifier tracksGas() {
101         // tx call 21k gas
102         gasUsed = gasleft() + 21000;
103 
104         _; // modified function body inserted here
105 
106         gasUsed = 0; // zero out the storage so we don't persist anything
107     }
108 }
109 
110 contract BZxObjects {
111 
112     struct ListIndex {
113         uint256 index;
114         bool isSet;
115     }
116 
117     struct LoanOrder {
118         address loanTokenAddress;
119         address interestTokenAddress;
120         address collateralTokenAddress;
121         address oracleAddress;
122         uint256 loanTokenAmount;
123         uint256 interestAmount;
124         uint256 initialMarginAmount;
125         uint256 maintenanceMarginAmount;
126         uint256 maxDurationUnixTimestampSec;
127         bytes32 loanOrderHash;
128     }
129 
130     struct LoanOrderAux {
131         address makerAddress;
132         address takerAddress;
133         address feeRecipientAddress;
134         address tradeTokenToFillAddress;
135         uint256 lenderRelayFee;
136         uint256 traderRelayFee;
137         uint256 makerRole;
138         uint256 expirationUnixTimestampSec;
139         bool withdrawOnOpen;
140         string description;
141     }
142 
143     struct LoanPosition {
144         address trader;
145         address collateralTokenAddressFilled;
146         address positionTokenAddressFilled;
147         uint256 loanTokenAmountFilled;
148         uint256 loanTokenAmountUsed;
149         uint256 collateralTokenAmountFilled;
150         uint256 positionTokenAmountFilled;
151         uint256 loanStartUnixTimestampSec;
152         uint256 loanEndUnixTimestampSec;
153         bool active;
154         uint256 positionId;
155     }
156 
157     struct PositionRef {
158         bytes32 loanOrderHash;
159         uint256 positionId;
160     }
161 
162     struct LenderInterest {
163         uint256 interestOwedPerDay;
164         uint256 interestPaid;
165         uint256 interestPaidDate;
166     }
167 
168     struct TraderInterest {
169         uint256 interestOwedPerDay;
170         uint256 interestPaid;
171         uint256 interestDepositTotal;
172         uint256 interestUpdatedDate;
173     }
174 }
175 
176 contract BZxEvents {
177 
178     event LogLoanAdded (
179         bytes32 indexed loanOrderHash,
180         address adderAddress,
181         address indexed makerAddress,
182         address indexed feeRecipientAddress,
183         uint256 lenderRelayFee,
184         uint256 traderRelayFee,
185         uint256 maxDuration,
186         uint256 makerRole
187     );
188 
189     event LogLoanTaken (
190         address indexed lender,
191         address indexed trader,
192         address loanTokenAddress,
193         address collateralTokenAddress,
194         uint256 loanTokenAmount,
195         uint256 collateralTokenAmount,
196         uint256 loanEndUnixTimestampSec,
197         bool firstFill,
198         bytes32 indexed loanOrderHash,
199         uint256 positionId
200     );
201 
202     event LogLoanCancelled(
203         address indexed makerAddress,
204         uint256 cancelLoanTokenAmount,
205         uint256 remainingLoanTokenAmount,
206         bytes32 indexed loanOrderHash
207     );
208 
209     event LogLoanClosed(
210         address indexed lender,
211         address indexed trader,
212         address loanCloser,
213         bool isLiquidation,
214         bytes32 indexed loanOrderHash,
215         uint256 positionId
216     );
217 
218     event LogPositionTraded(
219         bytes32 indexed loanOrderHash,
220         address indexed trader,
221         address sourceTokenAddress,
222         address destTokenAddress,
223         uint256 sourceTokenAmount,
224         uint256 destTokenAmount,
225         uint256 positionId
226     );
227 
228     event LogWithdrawPosition(
229         bytes32 indexed loanOrderHash,
230         address indexed trader,
231         uint256 positionAmount,
232         uint256 remainingPosition,
233         uint256 positionId
234     );
235 
236     event LogPayInterestForOracle(
237         address indexed lender,
238         address indexed oracleAddress,
239         address indexed interestTokenAddress,
240         uint256 amountPaid,
241         uint256 totalAccrued
242     );
243 
244     event LogPayInterestForOrder(
245         bytes32 indexed loanOrderHash,
246         address indexed lender,
247         address indexed interestTokenAddress,
248         uint256 amountPaid,
249         uint256 totalAccrued,
250         uint256 loanCount
251     );
252 
253     event LogChangeTraderOwnership(
254         bytes32 indexed loanOrderHash,
255         address indexed oldOwner,
256         address indexed newOwner
257     );
258 
259     event LogChangeLenderOwnership(
260         bytes32 indexed loanOrderHash,
261         address indexed oldOwner,
262         address indexed newOwner
263     );
264 
265     event LogUpdateLoanAsLender(
266         bytes32 indexed loanOrderHash,
267         address indexed lender,
268         uint256 loanTokenAmountAdded,
269         uint256 loanTokenAmountFillable,
270         uint256 expirationUnixTimestampSec
271     );
272 }
273 
274 contract BZxStorage is BZxObjects, BZxEvents, ReentrancyGuard, Ownable, GasTracker {
275     uint256 internal constant MAX_UINT = 2**256 - 1;
276 
277     address public bZRxTokenContract;
278     address public bZxEtherContract;
279     address public wethContract;
280     address payable public vaultContract;
281     address public oracleRegistryContract;
282     address public bZxTo0xContract;
283     address public bZxTo0xV2Contract;
284     bool public DEBUG_MODE = false;
285 
286     // Loan Orders
287     mapping (bytes32 => LoanOrder) public orders; // mapping of loanOrderHash to on chain loanOrders
288     mapping (bytes32 => LoanOrderAux) public orderAux; // mapping of loanOrderHash to on chain loanOrder auxiliary parameters
289     mapping (bytes32 => uint256) public orderFilledAmounts; // mapping of loanOrderHash to loanTokenAmount filled
290     mapping (bytes32 => uint256) public orderCancelledAmounts; // mapping of loanOrderHash to loanTokenAmount cancelled
291     mapping (bytes32 => address) public orderLender; // mapping of loanOrderHash to lender (only one lender per order)
292 
293     // Loan Positions
294     mapping (uint256 => LoanPosition) public loanPositions; // mapping of position ids to loanPositions
295     mapping (bytes32 => mapping (address => uint256)) public loanPositionsIds; // mapping of loanOrderHash to mapping of trader address to position id
296 
297     // Lists
298     mapping (address => bytes32[]) public orderList; // mapping of lenders and trader addresses to array of loanOrderHashes
299     mapping (bytes32 => mapping (address => ListIndex)) public orderListIndex; // mapping of loanOrderHash to mapping of lenders and trader addresses to ListIndex objects
300 
301     mapping (bytes32 => uint256[]) public orderPositionList; // mapping of loanOrderHash to array of order position ids
302 
303     PositionRef[] public positionList; // array of loans that need to be checked for liquidation or expiration
304     mapping (uint256 => ListIndex) public positionListIndex; // mapping of position ids to ListIndex objects
305 
306     // Interest
307     mapping (address => mapping (address => uint256)) public tokenInterestPaid; // mapping of lender address to mapping of interest token address to amount of interest that has ever been paid to a lender
308     mapping (address => mapping (address => mapping (address => LenderInterest))) public lenderOracleInterest; // mapping of lender address to mapping of oracle to mapping of interest token to LenderInterest objects
309     mapping (bytes32 => LenderInterest) public lenderOrderInterest; // mapping of loanOrderHash to LenderInterest objects
310     mapping (uint256 => TraderInterest) public traderLoanInterest; // mapping of position ids to TraderInterest objects
311 
312     // Other Storage
313     mapping (address => address) public oracleAddresses; // mapping of oracles to their current logic contract
314     mapping (bytes32 => mapping (address => bool)) public preSigned; // mapping of hash => signer => signed
315     mapping (address => mapping (address => bool)) public allowedValidators; // mapping of signer => validator => approved
316     mapping (bytes => bytes) internal db; // general use storage container
317     mapping (bytes => bytes[]) internal dbArray; // general use storage array container
318 }
319 
320 contract BZxProxiable {
321     mapping (bytes4 => address) public targets;
322 
323     mapping (bytes4 => bool) public targetIsPaused;
324 
325     function initialize(address _target) public;
326 }
327 
328 contract BZxProxy is BZxStorage, BZxProxiable {
329     
330     constructor(
331         address _settings) 
332         public
333     {
334         (bool result,) = _settings.delegatecall.gas(gasleft())(abi.encodeWithSignature("initialize(address)", _settings));
335         require(result, "BZxProxy::constructor: failed");
336     }
337     
338     function() 
339         external
340         payable 
341     {
342         require(!targetIsPaused[msg.sig], "BZxProxy::Function temporarily paused");
343 
344         address target = targets[msg.sig];
345         require(target != address(0), "BZxProxy::Target not found");
346 
347         bytes memory data = msg.data;
348         assembly {
349             let result := delegatecall(gas, target, add(data, 0x20), mload(data), 0, 0)
350             let size := returndatasize
351             let ptr := mload(0x40)
352             returndatacopy(ptr, 0, size)
353             switch result
354             case 0 { revert(ptr, size) }
355             default { return(ptr, size) }
356         }
357     }
358 
359     function initialize(
360         address)
361         public
362     {
363         revert();
364     }
365 }