1 /**
2  * Copyright 2017–2018, bZeroX, LLC. All Rights Reserved.
3  * Licensed under the Apache License, Version 2.0.
4  */
5  
6 pragma solidity 0.5.3;
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
17   event OwnershipTransferred(
18     address indexed previousOwner,
19     address indexed newOwner
20   );
21 
22   /**
23    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
24    * account.
25    */
26   constructor() public {
27     owner = msg.sender;
28   }
29 
30   /**
31    * @dev Throws if called by any account other than the owner.
32    */
33   modifier onlyOwner() {
34     require(msg.sender == owner);
35     _;
36   }
37 
38   /**
39    * @dev Allows the current owner to transfer control of the contract to a newOwner.
40    * @param _newOwner The address to transfer ownership to.
41    */
42   function transferOwnership(address _newOwner) public onlyOwner {
43     _transferOwnership(_newOwner);
44   }
45 
46   /**
47    * @dev Transfers control of the contract to a newOwner.
48    * @param _newOwner The address to transfer ownership to.
49    */
50   function _transferOwnership(address _newOwner) internal {
51     require(_newOwner != address(0));
52     emit OwnershipTransferred(owner, _newOwner);
53     owner = _newOwner;
54   }
55 }
56 
57 /**
58  * @title Helps contracts guard against reentrancy attacks.
59  * @author Remco Bloemen <remco@2π.com>, Eenae <alexey@mixbytes.io>
60  * @dev If you mark a function `nonReentrant`, you should also
61  * mark it `external`.
62  */
63 contract ReentrancyGuard {
64 
65   /// @dev Constant for unlocked guard state - non-zero to prevent extra gas costs.
66   /// See: https://github.com/OpenZeppelin/openzeppelin-solidity/issues/1056
67   uint256 private constant REENTRANCY_GUARD_FREE = 1;
68 
69   /// @dev Constant for locked guard state
70   uint256 private constant REENTRANCY_GUARD_LOCKED = 2;
71 
72   /**
73    * @dev We use a single lock for the whole contract.
74    */
75   uint256 private reentrancyLock = REENTRANCY_GUARD_FREE;
76 
77   /**
78    * @dev Prevents a contract from calling itself, directly or indirectly.
79    * If you mark a function `nonReentrant`, you should also
80    * mark it `external`. Calling one `nonReentrant` function from
81    * another is not supported. Instead, you can implement a
82    * `private` function doing the actual work, and an `external`
83    * wrapper marked as `nonReentrant`.
84    */
85   modifier nonReentrant() {
86     require(reentrancyLock == REENTRANCY_GUARD_FREE);
87     reentrancyLock = REENTRANCY_GUARD_LOCKED;
88     _;
89     reentrancyLock = REENTRANCY_GUARD_FREE;
90   }
91 
92 }
93 
94 contract GasTracker {
95 
96     uint256 internal gasUsed;
97 
98     modifier tracksGas() {
99         // tx call 21k gas
100         gasUsed = gasleft() + 21000;
101 
102         _; // modified function body inserted here
103 
104         gasUsed = 0; // zero out the storage so we don't persist anything
105     }
106 }
107 
108 contract BZxObjects {
109 
110     struct ListIndex {
111         uint256 index;
112         bool isSet;
113     }
114 
115     struct LoanOrder {
116         address loanTokenAddress;
117         address interestTokenAddress;
118         address collateralTokenAddress;
119         address oracleAddress;
120         uint256 loanTokenAmount;
121         uint256 interestAmount;
122         uint256 initialMarginAmount;
123         uint256 maintenanceMarginAmount;
124         uint256 maxDurationUnixTimestampSec;
125         bytes32 loanOrderHash;
126     }
127 
128     struct LoanOrderAux {
129         address makerAddress;
130         address takerAddress;
131         address feeRecipientAddress;
132         address tradeTokenToFillAddress;
133         uint256 lenderRelayFee;
134         uint256 traderRelayFee;
135         uint256 makerRole;
136         uint256 expirationUnixTimestampSec;
137         bool withdrawOnOpen;
138         string description;
139     }
140 
141     struct LoanPosition {
142         address trader;
143         address collateralTokenAddressFilled;
144         address positionTokenAddressFilled;
145         uint256 loanTokenAmountFilled;
146         uint256 loanTokenAmountUsed;
147         uint256 collateralTokenAmountFilled;
148         uint256 positionTokenAmountFilled;
149         uint256 loanStartUnixTimestampSec;
150         uint256 loanEndUnixTimestampSec;
151         bool active;
152         uint256 positionId;
153     }
154 
155     struct PositionRef {
156         bytes32 loanOrderHash;
157         uint256 positionId;
158     }
159 
160     struct LenderInterest {
161         uint256 interestOwedPerDay;
162         uint256 interestPaid;
163         uint256 interestPaidDate;
164     }
165 
166     struct TraderInterest {
167         uint256 interestOwedPerDay;
168         uint256 interestPaid;
169         uint256 interestDepositTotal;
170         uint256 interestUpdatedDate;
171     }
172 }
173 
174 contract BZxEvents {
175 
176     event LogLoanAdded (
177         bytes32 indexed loanOrderHash,
178         address adderAddress,
179         address indexed makerAddress,
180         address indexed feeRecipientAddress,
181         uint256 lenderRelayFee,
182         uint256 traderRelayFee,
183         uint256 maxDuration,
184         uint256 makerRole
185     );
186 
187     event LogLoanTaken (
188         address indexed lender,
189         address indexed trader,
190         address loanTokenAddress,
191         address collateralTokenAddress,
192         uint256 loanTokenAmount,
193         uint256 collateralTokenAmount,
194         uint256 loanEndUnixTimestampSec,
195         bool firstFill,
196         bytes32 indexed loanOrderHash,
197         uint256 positionId
198     );
199 
200     event LogLoanCancelled(
201         address indexed makerAddress,
202         uint256 cancelLoanTokenAmount,
203         uint256 remainingLoanTokenAmount,
204         bytes32 indexed loanOrderHash
205     );
206 
207     event LogLoanClosed(
208         address indexed lender,
209         address indexed trader,
210         address loanCloser,
211         bool isLiquidation,
212         bytes32 indexed loanOrderHash,
213         uint256 positionId
214     );
215 
216     event LogPositionTraded(
217         bytes32 indexed loanOrderHash,
218         address indexed trader,
219         address sourceTokenAddress,
220         address destTokenAddress,
221         uint256 sourceTokenAmount,
222         uint256 destTokenAmount,
223         uint256 positionId
224     );
225 
226     event LogWithdrawPosition(
227         bytes32 indexed loanOrderHash,
228         address indexed trader,
229         uint256 positionAmount,
230         uint256 remainingPosition,
231         uint256 positionId
232     );
233 
234     event LogPayInterestForOracle(
235         address indexed lender,
236         address indexed oracleAddress,
237         address indexed interestTokenAddress,
238         uint256 amountPaid,
239         uint256 totalAccrued
240     );
241 
242     event LogPayInterestForOrder(
243         bytes32 indexed loanOrderHash,
244         address indexed lender,
245         address indexed interestTokenAddress,
246         uint256 amountPaid,
247         uint256 totalAccrued,
248         uint256 loanCount
249     );
250 
251     event LogChangeTraderOwnership(
252         bytes32 indexed loanOrderHash,
253         address indexed oldOwner,
254         address indexed newOwner
255     );
256 
257     event LogChangeLenderOwnership(
258         bytes32 indexed loanOrderHash,
259         address indexed oldOwner,
260         address indexed newOwner
261     );
262 
263     event LogUpdateLoanAsLender(
264         bytes32 indexed loanOrderHash,
265         address indexed lender,
266         uint256 loanTokenAmountAdded,
267         uint256 loanTokenAmountFillable,
268         uint256 expirationUnixTimestampSec
269     );
270 }
271 
272 contract BZxStorage is BZxObjects, BZxEvents, ReentrancyGuard, Ownable, GasTracker {
273     uint256 internal constant MAX_UINT = 2**256 - 1;
274 
275     address public bZRxTokenContract;
276     address public bZxEtherContract;
277     address public wethContract;
278     address payable public vaultContract;
279     address public oracleRegistryContract;
280     address public bZxTo0xContract;
281     address public bZxTo0xV2Contract;
282     bool public DEBUG_MODE = false;
283 
284     // Loan Orders
285     mapping (bytes32 => LoanOrder) public orders; // mapping of loanOrderHash to on chain loanOrders
286     mapping (bytes32 => LoanOrderAux) public orderAux; // mapping of loanOrderHash to on chain loanOrder auxiliary parameters
287     mapping (bytes32 => uint256) public orderFilledAmounts; // mapping of loanOrderHash to loanTokenAmount filled
288     mapping (bytes32 => uint256) public orderCancelledAmounts; // mapping of loanOrderHash to loanTokenAmount cancelled
289     mapping (bytes32 => address) public orderLender; // mapping of loanOrderHash to lender (only one lender per order)
290 
291     // Loan Positions
292     mapping (uint256 => LoanPosition) public loanPositions; // mapping of position ids to loanPositions
293     mapping (bytes32 => mapping (address => uint256)) public loanPositionsIds; // mapping of loanOrderHash to mapping of trader address to position id
294 
295     // Lists
296     mapping (address => bytes32[]) public orderList; // mapping of lenders and trader addresses to array of loanOrderHashes
297     mapping (bytes32 => mapping (address => ListIndex)) public orderListIndex; // mapping of loanOrderHash to mapping of lenders and trader addresses to ListIndex objects
298 
299     mapping (bytes32 => uint256[]) public orderPositionList; // mapping of loanOrderHash to array of order position ids
300 
301     PositionRef[] public positionList; // array of loans that need to be checked for liquidation or expiration
302     mapping (uint256 => ListIndex) public positionListIndex; // mapping of position ids to ListIndex objects
303 
304     // Interest
305     mapping (address => mapping (address => uint256)) public tokenInterestOwed; // mapping of lender address to mapping of interest token address to amount of interest owed for all loans (assuming they go to full term)
306     mapping (address => mapping (address => mapping (address => LenderInterest))) public lenderOracleInterest; // mapping of lender address to mapping of oracle to mapping of interest token to LenderInterest objects
307     mapping (bytes32 => LenderInterest) public lenderOrderInterest; // mapping of loanOrderHash to LenderInterest objects
308     mapping (uint256 => TraderInterest) public traderLoanInterest; // mapping of position ids to TraderInterest objects
309 
310     // Other Storage
311     mapping (address => address) public oracleAddresses; // mapping of oracles to their current logic contract
312     mapping (bytes32 => mapping (address => bool)) public preSigned; // mapping of hash => signer => signed
313     mapping (address => mapping (address => bool)) public allowedValidators; // mapping of signer => validator => approved
314 
315     // General Purpose
316     mapping (bytes => uint256) internal dbUint256;
317     mapping (bytes => uint256[]) internal dbUint256Array;
318     mapping (bytes => address) internal dbAddress;
319     mapping (bytes => address[]) internal dbAddressArray;
320     mapping (bytes => bool) internal dbBool;
321     mapping (bytes => bool[]) internal dbBoolArray;
322     mapping (bytes => bytes32) internal dbBytes32;
323     mapping (bytes => bytes32[]) internal dbBytes32Array;
324     mapping (bytes => bytes) internal dbBytes;
325     mapping (bytes => bytes[]) internal dbBytesArray;
326 }
327 
328 contract BZxProxiable {
329     mapping (bytes4 => address) public targets;
330 
331     mapping (bytes4 => bool) public targetIsPaused;
332 
333     function initialize(address _target) public;
334 }
335 
336 contract BZxProxy is BZxStorage, BZxProxiable {
337     
338     constructor(
339         address _settings) 
340         public
341     {
342         (bool result,) = _settings.delegatecall.gas(gasleft())(abi.encodeWithSignature("initialize(address)", _settings));
343         require(result, "BZxProxy::constructor: failed");
344     }
345     
346     function() 
347         external
348         payable 
349     {
350         require(!targetIsPaused[msg.sig], "BZxProxy::Function temporarily paused");
351 
352         address target = targets[msg.sig];
353         require(target != address(0), "BZxProxy::Target not found");
354 
355         bytes memory data = msg.data;
356         assembly {
357             let result := delegatecall(gas, target, add(data, 0x20), mload(data), 0, 0)
358             let size := returndatasize
359             let ptr := mload(0x40)
360             returndatacopy(ptr, 0, size)
361             switch result
362             case 0 { revert(ptr, size) }
363             default { return(ptr, size) }
364         }
365     }
366 
367     function initialize(
368         address)
369         public
370     {
371         revert();
372     }
373 }