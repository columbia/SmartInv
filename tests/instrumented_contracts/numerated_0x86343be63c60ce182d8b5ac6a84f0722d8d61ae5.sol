1 /*
2 
3   Copyright 2018 bZeroX, LLC
4 
5   Licensed under the Apache License, Version 2.0 (the "License");
6   you may not use this file except in compliance with the License.
7   You may obtain a copy of the License at
8 
9     http://www.apache.org/licenses/LICENSE-2.0
10 
11   Unless required by applicable law or agreed to in writing, software
12   distributed under the License is distributed on an "AS IS" BASIS,
13   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
14   See the License for the specific language governing permissions and
15   limitations under the License.
16 
17 */
18 
19 pragma solidity 0.4.24;
20 
21 /**
22  * @title Ownable
23  * @dev The Ownable contract has an owner address, and provides basic authorization control
24  * functions, this simplifies the implementation of "user permissions".
25  */
26 contract Ownable {
27   address public owner;
28 
29 
30   event OwnershipRenounced(address indexed previousOwner);
31   event OwnershipTransferred(
32     address indexed previousOwner,
33     address indexed newOwner
34   );
35 
36 
37   /**
38    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
39    * account.
40    */
41   constructor() public {
42     owner = msg.sender;
43   }
44 
45   /**
46    * @dev Throws if called by any account other than the owner.
47    */
48   modifier onlyOwner() {
49     require(msg.sender == owner);
50     _;
51   }
52 
53   /**
54    * @dev Allows the current owner to relinquish control of the contract.
55    */
56   function renounceOwnership() public onlyOwner {
57     emit OwnershipRenounced(owner);
58     owner = address(0);
59   }
60 
61   /**
62    * @dev Allows the current owner to transfer control of the contract to a newOwner.
63    * @param _newOwner The address to transfer ownership to.
64    */
65   function transferOwnership(address _newOwner) public onlyOwner {
66     _transferOwnership(_newOwner);
67   }
68 
69   /**
70    * @dev Transfers control of the contract to a newOwner.
71    * @param _newOwner The address to transfer ownership to.
72    */
73   function _transferOwnership(address _newOwner) internal {
74     require(_newOwner != address(0));
75     emit OwnershipTransferred(owner, _newOwner);
76     owner = _newOwner;
77   }
78 }
79 
80 /**
81  * @title Helps contracts guard agains reentrancy attacks.
82  * @author Remco Bloemen <remco@2π.com>
83  * @notice If you mark a function `nonReentrant`, you should also
84  * mark it `external`.
85  */
86 contract ReentrancyGuard {
87 
88   /**
89    * @dev We use a single lock for the whole contract.
90    */
91   bool private reentrancyLock = false;
92 
93   /**
94    * @dev Prevents a contract from calling itself, directly or indirectly.
95    * @notice If you mark a function `nonReentrant`, you should also
96    * mark it `external`. Calling one nonReentrant function from
97    * another is not supported. Instead, you can implement a
98    * `private` function doing the actual work, and a `external`
99    * wrapper marked as `nonReentrant`.
100    */
101   modifier nonReentrant() {
102     require(!reentrancyLock);
103     reentrancyLock = true;
104     _;
105     reentrancyLock = false;
106   }
107 
108 }
109 
110 contract GasTracker {
111 
112     uint internal gasUsed;
113 
114     modifier tracksGas() {
115         gasUsed = gasleft();
116         _;
117         gasUsed = 0;
118     }
119 }
120 
121 contract BZxObjects {
122 
123     struct LoanOrder {
124         address maker;
125         address loanTokenAddress;
126         address interestTokenAddress;
127         address collateralTokenAddress;
128         address feeRecipientAddress;
129         address oracleAddress;
130         uint loanTokenAmount;
131         uint interestAmount;
132         uint initialMarginAmount;
133         uint maintenanceMarginAmount;
134         uint lenderRelayFee;
135         uint traderRelayFee;
136         uint expirationUnixTimestampSec;
137         bytes32 loanOrderHash;
138     }
139 
140     struct LoanRef {
141         bytes32 loanOrderHash;
142         address trader;
143     }
144 
145     struct LoanPosition {
146         address lender;
147         address trader;
148         address collateralTokenAddressFilled;
149         address positionTokenAddressFilled;
150         uint loanTokenAmountFilled;
151         uint collateralTokenAmountFilled;
152         uint positionTokenAmountFilled;
153         uint loanStartUnixTimestampSec;
154         uint index;
155         bool active;
156     }
157 
158     struct InterestData {
159         address lender;
160         address interestTokenAddress;
161         uint interestTotalAccrued;
162         uint interestPaidSoFar;
163     }
164 
165     event LogLoanTaken (
166         address lender,
167         address trader,
168         address collateralTokenAddressFilled,
169         address positionTokenAddressFilled,
170         uint loanTokenAmountFilled,
171         uint collateralTokenAmountFilled,
172         uint positionTokenAmountFilled,
173         uint loanStartUnixTimestampSec,
174         bool active,
175         bytes32 loanOrderHash
176     );
177 
178     event LogLoanCancelled(
179         address maker,
180         uint cancelLoanTokenAmount,
181         uint remainingLoanTokenAmount,
182         bytes32 loanOrderHash
183     );
184 
185     event LogLoanClosed(
186         address lender,
187         address trader,
188         bool isLiquidation,
189         bytes32 loanOrderHash
190     );
191 
192     event LogPositionTraded(
193         bytes32 loanOrderHash,
194         address trader,
195         address sourceTokenAddress,
196         address destTokenAddress,
197         uint sourceTokenAmount,
198         uint destTokenAmount
199     );
200 
201     event LogMarginLevels(
202         bytes32 loanOrderHash,
203         address trader,
204         uint initialMarginAmount,
205         uint maintenanceMarginAmount,
206         uint currentMarginAmount
207     );
208 
209     event LogWithdrawProfit(
210         bytes32 loanOrderHash,
211         address trader,
212         uint profitWithdrawn,
213         uint remainingPosition
214     );
215 
216     event LogPayInterest(
217         bytes32 loanOrderHash,
218         address lender,
219         address trader,
220         uint amountPaid,
221         uint totalAccrued
222     );
223 
224     function buildLoanOrderStruct(
225         bytes32 loanOrderHash,
226         address[6] addrs,
227         uint[9] uints) 
228         internal
229         pure
230         returns (LoanOrder) {
231 
232         return LoanOrder({
233             maker: addrs[0],
234             loanTokenAddress: addrs[1],
235             interestTokenAddress: addrs[2],
236             collateralTokenAddress: addrs[3],
237             feeRecipientAddress: addrs[4],
238             oracleAddress: addrs[5],
239             loanTokenAmount: uints[0],
240             interestAmount: uints[1],
241             initialMarginAmount: uints[2],
242             maintenanceMarginAmount: uints[3],
243             lenderRelayFee: uints[4],
244             traderRelayFee: uints[5],
245             expirationUnixTimestampSec: uints[6],
246             loanOrderHash: loanOrderHash
247         });
248     }
249 }
250 
251 contract BZxStorage is BZxObjects, ReentrancyGuard, Ownable, GasTracker {
252     uint internal constant MAX_UINT = 2**256 - 1;
253 
254     address public bZRxTokenContract;
255     address public vaultContract;
256     address public oracleRegistryContract;
257     address public bZxTo0xContract;
258     bool public DEBUG_MODE = false;
259 
260     mapping (bytes32 => LoanOrder) public orders; // mapping of loanOrderHash to taken loanOrders
261     mapping (address => bytes32[]) public orderList; // mapping of lenders and trader addresses to array of loanOrderHashes
262     mapping (bytes32 => address) public orderLender; // mapping of loanOrderHash to lender address
263     mapping (bytes32 => address[]) public orderTraders; // mapping of loanOrderHash to array of trader addresses
264     mapping (bytes32 => uint) public orderFilledAmounts; // mapping of loanOrderHash to loanTokenAmount filled
265     mapping (bytes32 => uint) public orderCancelledAmounts; // mapping of loanOrderHash to loanTokenAmount cancelled
266     mapping (address => address) public oracleAddresses; // mapping of oracles to their current logic contract
267     mapping (bytes32 => mapping (address => LoanPosition)) public loanPositions; // mapping of loanOrderHash to mapping of traders to loanPositions
268     mapping (bytes32 => mapping (address => uint)) public interestPaid; // mapping of loanOrderHash to mapping of traders to amount of interest paid so far to a lender
269 
270     LoanRef[] public loanList; // array of loans that need to be checked for liquidation or expiration
271 }
272 
273 contract Proxiable {
274     mapping (bytes4 => address) public targets;
275 
276     function initialize(address _target) public;
277 
278     function _replaceContract(address _target) internal {
279         // bytes4(keccak256("initialize(address)")) == 0xc4d66de8
280         require(_target.delegatecall(0xc4d66de8, _target), "Proxiable::_replaceContract: failed");
281     }
282 }
283 
284 contract BZxProxy is BZxStorage, Proxiable {
285 
286     function() public {
287         address target = targets[msg.sig];
288         bytes memory data = msg.data;
289         assembly {
290             let result := delegatecall(gas, target, add(data, 0x20), mload(data), 0, 0)
291             let size := returndatasize
292             let ptr := mload(0x40)
293             returndatacopy(ptr, 0, size)
294             switch result
295             case 0 { revert(ptr, size) }
296             default { return(ptr, size) }
297         }
298     }
299 
300     function initialize(
301         address)
302         public
303     {
304         revert();
305     }
306 
307     /*
308      * Owner only functions
309      */
310     function replaceContract(
311         address _target)
312         public
313         onlyOwner
314     {
315         _replaceContract(_target);
316     }
317 
318     function setTarget(
319         string _funcId,  // example: "takeLoanOrderAsTrader(address[6],uint256[9],address,uint256,bytes)"
320         address _target) // logic contract address
321         public
322         onlyOwner
323         returns(bytes4)
324     {
325         bytes4 f = bytes4(keccak256(abi.encodePacked(_funcId)));
326         targets[f] = _target;
327         return f;
328     }
329 
330     function setBZxAddresses(
331         address _bZRxToken,
332         address _vault,
333         address _oracleregistry,
334         address _exchange0xWrapper) 
335         public
336         onlyOwner
337     {
338         if (_bZRxToken != address(0) && _vault != address(0) && _oracleregistry != address(0) && _exchange0xWrapper != address(0))
339         bZRxTokenContract = _bZRxToken;
340         vaultContract = _vault;
341         oracleRegistryContract = _oracleregistry;
342         bZxTo0xContract = _exchange0xWrapper;
343     }
344 
345     function setDebugMode (
346         bool _debug)
347         public
348         onlyOwner
349     {
350         if (DEBUG_MODE != _debug)
351             DEBUG_MODE = _debug;
352     }
353 
354     function setBZRxToken (
355         address _token)
356         public
357         onlyOwner
358     {
359         if (_token != address(0))
360             bZRxTokenContract = _token;
361     }
362 
363     function setVault (
364         address _vault)
365         public
366         onlyOwner
367     {
368         if (_vault != address(0))
369             vaultContract = _vault;
370     }
371 
372     function setOracleRegistry (
373         address _registry)
374         public
375         onlyOwner
376     {
377         if (_registry != address(0))
378             oracleRegistryContract = _registry;
379     }
380 
381     function setOracleReference (
382         address _oracle,
383         address _logicContract)
384         public
385         onlyOwner
386     {
387         if (oracleAddresses[_oracle] != _logicContract)
388             oracleAddresses[_oracle] = _logicContract;
389     }
390 
391     function set0xExchangeWrapper (
392         address _wrapper)
393         public
394         onlyOwner
395     {
396         if (_wrapper != address(0))
397             bZxTo0xContract = _wrapper;
398     }
399 
400     /*
401      * View functions
402      */
403 
404     function getTarget(
405         string _funcId) // example: "takeLoanOrderAsTrader(address[6],uint256[9],address,uint256,bytes)"
406         public
407         view
408         returns (address)
409     {
410         return targets[bytes4(keccak256(abi.encodePacked(_funcId)))];
411     }
412 }