1 /**
2  * Copyright 2017-2019, bZeroX, LLC. All Rights Reserved.
3  * Licensed under the Apache License, Version 2.0.
4  */
5 
6 pragma solidity 0.5.8;
7 
8 
9 /**
10  * @title ERC20Basic
11  * @dev Simpler version of ERC20 interface
12  * See https://github.com/ethereum/EIPs/issues/179
13  */
14 contract ERC20Basic {
15   function totalSupply() public view returns (uint256);
16   function balanceOf(address _who) public view returns (uint256);
17   function transfer(address _to, uint256 _value) public returns (bool);
18   event Transfer(address indexed from, address indexed to, uint256 value);
19 }
20 
21 /**
22  * @title ERC20 interface
23  * @dev see https://github.com/ethereum/EIPs/issues/20
24  */
25 contract ERC20 is ERC20Basic {
26   function allowance(address _owner, address _spender)
27     public view returns (uint256);
28 
29   function transferFrom(address _from, address _to, uint256 _value)
30     public returns (bool);
31 
32   function approve(address _spender, uint256 _value) public returns (bool);
33   event Approval(
34     address indexed owner,
35     address indexed spender,
36     uint256 value
37   );
38 }
39 
40 /**
41  * @title EIP20/ERC20 interface
42  * @dev see https://github.com/ethereum/EIPs/issues/20
43  */
44 contract EIP20 is ERC20 {
45     string public name;
46     uint8 public decimals;
47     string public symbol;
48 }
49 
50 contract WETHInterface is EIP20 {
51     function deposit() external payable;
52     function withdraw(uint256 wad) external;
53 }
54 
55 /**
56  * @title SafeMath
57  * @dev Math operations with safety checks that throw on error
58  */
59 library SafeMath {
60 
61   /**
62   * @dev Multiplies two numbers, throws on overflow.
63   */
64   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
65     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
66     // benefit is lost if 'b' is also tested.
67     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
68     if (_a == 0) {
69       return 0;
70     }
71 
72     c = _a * _b;
73     assert(c / _a == _b);
74     return c;
75   }
76 
77   /**
78   * @dev Integer division of two numbers, truncating the quotient.
79   */
80   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
81     // assert(_b > 0); // Solidity automatically throws when dividing by 0
82     // uint256 c = _a / _b;
83     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
84     return _a / _b;
85   }
86 
87   /**
88   * @dev Integer division of two numbers, rounding up and truncating the quotient
89   */
90   function divCeil(uint256 _a, uint256 _b) internal pure returns (uint256) {
91     if (_a == 0) {
92       return 0;
93     }
94 
95     return ((_a - 1) / _b) + 1;
96   }
97 
98   /**
99   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
100   */
101   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
102     assert(_b <= _a);
103     return _a - _b;
104   }
105 
106   /**
107   * @dev Adds two numbers, throws on overflow.
108   */
109   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
110     c = _a + _b;
111     assert(c >= _a);
112     return c;
113   }
114 }
115 
116 /**
117  * @title Ownable
118  * @dev The Ownable contract has an owner address, and provides basic authorization control
119  * functions, this simplifies the implementation of "user permissions".
120  */
121 contract Ownable {
122   address public owner;
123 
124 
125   event OwnershipTransferred(
126     address indexed previousOwner,
127     address indexed newOwner
128   );
129 
130 
131   /**
132    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
133    * account.
134    */
135   constructor() public {
136     owner = msg.sender;
137   }
138 
139   /**
140    * @dev Throws if called by any account other than the owner.
141    */
142   modifier onlyOwner() {
143     require(msg.sender == owner);
144     _;
145   }
146 
147   /**
148    * @dev Allows the current owner to transfer control of the contract to a newOwner.
149    * @param _newOwner The address to transfer ownership to.
150    */
151   function transferOwnership(address _newOwner) public onlyOwner {
152     _transferOwnership(_newOwner);
153   }
154 
155   /**
156    * @dev Transfers control of the contract to a newOwner.
157    * @param _newOwner The address to transfer ownership to.
158    */
159   function _transferOwnership(address _newOwner) internal {
160     require(_newOwner != address(0));
161     emit OwnershipTransferred(owner, _newOwner);
162     owner = _newOwner;
163   }
164 }
165 
166 /**
167  * @title Helps contracts guard against reentrancy attacks.
168  * @author Remco Bloemen <remco@2π.com>, Eenae <alexey@mixbytes.io>
169  * @dev If you mark a function `nonReentrant`, you should also
170  * mark it `external`.
171  */
172 contract ReentrancyGuard {
173 
174   /// @dev Constant for unlocked guard state - non-zero to prevent extra gas costs.
175   /// See: https://github.com/OpenZeppelin/openzeppelin-solidity/issues/1056
176   uint256 internal constant REENTRANCY_GUARD_FREE = 1;
177 
178   /// @dev Constant for locked guard state
179   uint256 internal constant REENTRANCY_GUARD_LOCKED = 2;
180 
181   /**
182    * @dev We use a single lock for the whole contract.
183    */
184   uint256 internal reentrancyLock = REENTRANCY_GUARD_FREE;
185 
186   /**
187    * @dev Prevents a contract from calling itself, directly or indirectly.
188    * If you mark a function `nonReentrant`, you should also
189    * mark it `external`. Calling one `nonReentrant` function from
190    * another is not supported. Instead, you can implement a
191    * `private` function doing the actual work, and an `external`
192    * wrapper marked as `nonReentrant`.
193    */
194   modifier nonReentrant() {
195     require(reentrancyLock == REENTRANCY_GUARD_FREE, "nonReentrant");
196     reentrancyLock = REENTRANCY_GUARD_LOCKED;
197     _;
198     reentrancyLock = REENTRANCY_GUARD_FREE;
199   }
200 
201 }
202 
203 contract LoanTokenization is ReentrancyGuard, Ownable {
204 
205     uint256 internal constant MAX_UINT = 2**256 - 1;
206 
207     string public name;
208     string public symbol;
209     uint8 public decimals;
210 
211     address public bZxContract;
212     address public bZxVault;
213     address public bZxOracle;
214     address public wethContract;
215 
216     address public loanTokenAddress;
217 
218     // price of token at last user checkpoint
219     mapping (address => uint256) internal checkpointPrices_;
220 }
221 
222 contract LoanTokenStorage is LoanTokenization {
223 
224     struct ListIndex {
225         uint256 index;
226         bool isSet;
227     }
228 
229     struct LoanData {
230         bytes32 loanOrderHash;
231         uint256 leverageAmount;
232         uint256 initialMarginAmount;
233         uint256 maintenanceMarginAmount;
234         uint256 maxDurationUnixTimestampSec;
235         uint256 index;
236         uint256 marginPremiumAmount;
237         address collateralTokenAddress;
238     }
239 
240     struct TokenReserves {
241         address lender;
242         uint256 amount;
243     }
244 
245     // topic: 0x86e15dd78cd784ab7788bcf5b96b9395e86030e048e5faedcfe752c700f6157e
246     event Borrow(
247         address indexed borrower,
248         uint256 borrowAmount,
249         uint256 interestRate,
250         address collateralTokenAddress,
251         address tradeTokenToFillAddress,
252         bool withdrawOnOpen
253     );
254 
255     // topic: 0x85dfc0033a3e5b3b9b3151bd779c1f9b855d66b83ff5bb79283b68d82e8e5b73
256     event Repay(
257         bytes32 indexed loanOrderHash,
258         address indexed borrower,
259         address closer,
260         uint256 amount,
261         bool isLiquidation
262     );
263 
264     // topic: 0x68e1caf97c4c29c1ac46024e9590f80b7a1f690d393703879cf66eea4e1e8421
265     event Claim(
266         address indexed claimant,
267         uint256 tokenAmount,
268         uint256 assetAmount,
269         uint256 remainingTokenAmount,
270         uint256 price
271     );
272 
273     bool internal isInitialized_ = false;
274 
275     address public tokenizedRegistry;
276 
277     uint256 public baseRate = 1000000000000000000; // 1.0%
278     uint256 public rateMultiplier = 18750000000000000000; // 18.75%
279 
280     // slot addition (non-sequential): lowUtilBaseRate = 8000000000000000000; // 8.0%
281     // slot addition (non-sequential): lowUtilRateMultiplier = 4750000000000000000; // 4.75%
282 
283     // "fee percentage retained by the oracle" = SafeMath.sub(10**20, spreadMultiplier);
284     uint256 public spreadMultiplier;
285 
286     mapping (uint256 => bytes32) public loanOrderHashes; // mapping of levergeAmount to loanOrderHash
287     mapping (bytes32 => LoanData) public loanOrderData; // mapping of loanOrderHash to LoanOrder
288     uint256[] public leverageList;
289 
290     TokenReserves[] public burntTokenReserveList; // array of TokenReserves
291     mapping (address => ListIndex) public burntTokenReserveListIndex; // mapping of lender address to ListIndex objects
292     uint256 public burntTokenReserved; // total outstanding burnt token amount
293     address internal nextOwedLender_;
294 
295     uint256 public totalAssetBorrow; // current amount of loan token amount tied up in loans
296 
297     uint256 public checkpointSupply;
298 
299     uint256 internal lastSettleTime_;
300 
301     uint256 public initialPrice;
302 }
303 
304 contract AdvancedTokenStorage is LoanTokenStorage {
305     using SafeMath for uint256;
306 
307     event Transfer(
308         address indexed from,
309         address indexed to,
310         uint256 value
311     );
312     event Approval(
313         address indexed owner,
314         address indexed spender,
315         uint256 value
316     );
317     event Mint(
318         address indexed minter,
319         uint256 tokenAmount,
320         uint256 assetAmount,
321         uint256 price
322     );
323     event Burn(
324         address indexed burner,
325         uint256 tokenAmount,
326         uint256 assetAmount,
327         uint256 price
328     );
329 
330     mapping(address => uint256) internal balances;
331     mapping (address => mapping (address => uint256)) internal allowed;
332     uint256 internal totalSupply_;
333 
334     function totalSupply()
335         public
336         view
337         returns (uint256)
338     {
339         return totalSupply_;
340     }
341 
342     function balanceOf(
343         address _owner)
344         public
345         view
346         returns (uint256)
347     {
348         return balances[_owner];
349     }
350 
351     function allowance(
352         address _owner,
353         address _spender)
354         public
355         view
356         returns (uint256)
357     {
358         return allowed[_owner][_spender];
359     }
360 }
361 
362 contract LoanToken is AdvancedTokenStorage {
363 
364     address internal target_;
365 
366     constructor(
367         address _newTarget)
368         public
369     {
370         _setTarget(_newTarget);
371     }
372 
373     function()
374         external
375         payable
376     {
377         address target = target_;
378         bytes memory data = msg.data;
379         assembly {
380             let result := delegatecall(gas, target, add(data, 0x20), mload(data), 0, 0)
381             let size := returndatasize
382             let ptr := mload(0x40)
383             returndatacopy(ptr, 0, size)
384             switch result
385             case 0 { revert(ptr, size) }
386             default { return(ptr, size) }
387         }
388     }
389 
390     function setTarget(
391         address _newTarget)
392         public
393         onlyOwner
394     {
395         _setTarget(_newTarget);
396     }
397 
398     function _setTarget(
399         address _newTarget)
400         internal
401     {
402         require(_isContract(_newTarget), "target not a contract");
403         target_ = _newTarget;
404     }
405 
406     function _isContract(
407         address addr)
408         internal
409         view
410         returns (bool)
411     {
412         uint256 size;
413         assembly { size := extcodesize(addr) }
414         return size > 0;
415     }
416 }