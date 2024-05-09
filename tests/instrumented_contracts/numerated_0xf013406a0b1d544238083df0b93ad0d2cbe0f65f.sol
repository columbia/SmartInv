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
40 contract WETHInterface is ERC20 {
41     function deposit() external payable;
42     function withdraw(uint256 wad) external;
43 }
44 
45 /**
46  * @title SafeMath
47  * @dev Math operations with safety checks that throw on error
48  */
49 library SafeMath {
50 
51   /**
52   * @dev Multiplies two numbers, throws on overflow.
53   */
54   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
55     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
56     // benefit is lost if 'b' is also tested.
57     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
58     if (_a == 0) {
59       return 0;
60     }
61 
62     c = _a * _b;
63     assert(c / _a == _b);
64     return c;
65   }
66 
67   /**
68   * @dev Integer division of two numbers, truncating the quotient.
69   */
70   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
71     // assert(_b > 0); // Solidity automatically throws when dividing by 0
72     // uint256 c = _a / _b;
73     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
74     return _a / _b;
75   }
76 
77   /**
78   * @dev Integer division of two numbers, rounding up and truncating the quotient
79   */
80   function divCeil(uint256 _a, uint256 _b) internal pure returns (uint256) {
81     if (_a == 0) {
82       return 0;
83     }
84 
85     return ((_a - 1) / _b) + 1;
86   }
87 
88   /**
89   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
90   */
91   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
92     assert(_b <= _a);
93     return _a - _b;
94   }
95 
96   /**
97   * @dev Adds two numbers, throws on overflow.
98   */
99   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
100     c = _a + _b;
101     assert(c >= _a);
102     return c;
103   }
104 }
105 
106 /**
107  * @title Ownable
108  * @dev The Ownable contract has an owner address, and provides basic authorization control
109  * functions, this simplifies the implementation of "user permissions".
110  */
111 contract Ownable {
112   address public owner;
113 
114 
115   event OwnershipTransferred(
116     address indexed previousOwner,
117     address indexed newOwner
118   );
119 
120 
121   /**
122    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
123    * account.
124    */
125   constructor() public {
126     owner = msg.sender;
127   }
128 
129   /**
130    * @dev Throws if called by any account other than the owner.
131    */
132   modifier onlyOwner() {
133     require(msg.sender == owner);
134     _;
135   }
136 
137   /**
138    * @dev Allows the current owner to transfer control of the contract to a newOwner.
139    * @param _newOwner The address to transfer ownership to.
140    */
141   function transferOwnership(address _newOwner) public onlyOwner {
142     _transferOwnership(_newOwner);
143   }
144 
145   /**
146    * @dev Transfers control of the contract to a newOwner.
147    * @param _newOwner The address to transfer ownership to.
148    */
149   function _transferOwnership(address _newOwner) internal {
150     require(_newOwner != address(0));
151     emit OwnershipTransferred(owner, _newOwner);
152     owner = _newOwner;
153   }
154 }
155 
156 /**
157  * @title Helps contracts guard against reentrancy attacks.
158  * @author Remco Bloemen <remco@2π.com>, Eenae <alexey@mixbytes.io>
159  * @dev If you mark a function `nonReentrant`, you should also
160  * mark it `external`.
161  */
162 contract ReentrancyGuard {
163 
164   /// @dev Constant for unlocked guard state - non-zero to prevent extra gas costs.
165   /// See: https://github.com/OpenZeppelin/openzeppelin-solidity/issues/1056
166   uint256 internal constant REENTRANCY_GUARD_FREE = 1;
167 
168   /// @dev Constant for locked guard state
169   uint256 internal constant REENTRANCY_GUARD_LOCKED = 2;
170 
171   /**
172    * @dev We use a single lock for the whole contract.
173    */
174   uint256 internal reentrancyLock = REENTRANCY_GUARD_FREE;
175 
176   /**
177    * @dev Prevents a contract from calling itself, directly or indirectly.
178    * If you mark a function `nonReentrant`, you should also
179    * mark it `external`. Calling one `nonReentrant` function from
180    * another is not supported. Instead, you can implement a
181    * `private` function doing the actual work, and an `external`
182    * wrapper marked as `nonReentrant`.
183    */
184   modifier nonReentrant() {
185     require(reentrancyLock == REENTRANCY_GUARD_FREE, "nonReentrant");
186     reentrancyLock = REENTRANCY_GUARD_LOCKED;
187     _;
188     reentrancyLock = REENTRANCY_GUARD_FREE;
189   }
190 
191 }
192 
193 contract LoanTokenization is ReentrancyGuard, Ownable {
194 
195     uint256 internal constant MAX_UINT = 2**256 - 1;
196 
197     string public name;
198     string public symbol;
199     uint8 public decimals;
200 
201     address public bZxContract;
202     address public bZxVault;
203     address public bZxOracle;
204     address public wethContract;
205 
206     address public loanTokenAddress;
207 
208     // price of token at last user checkpoint
209     mapping (address => uint256) internal checkpointPrices_;
210 }
211 
212 contract LoanTokenStorage is LoanTokenization {
213 
214     struct ListIndex {
215         uint256 index;
216         bool isSet;
217     }
218 
219     struct LoanData {
220         bytes32 loanOrderHash;
221         uint256 leverageAmount;
222         uint256 initialMarginAmount;
223         uint256 maintenanceMarginAmount;
224         uint256 maxDurationUnixTimestampSec;
225         uint256 index;
226     }
227 
228     struct TokenReserves {
229         address lender;
230         uint256 amount;
231     }
232 
233     event Borrow(
234         address indexed borrower,
235         uint256 borrowAmount,
236         uint256 interestRate,
237         address collateralTokenAddress,
238         address tradeTokenToFillAddress,
239         bool withdrawOnOpen
240     );
241 
242     event Claim(
243         address indexed claimant,
244         uint256 tokenAmount,
245         uint256 assetAmount,
246         uint256 remainingTokenAmount,
247         uint256 price
248     );
249 
250     bool internal isInitialized_ = false;
251 
252     address public tokenizedRegistry;
253 
254     uint256 public baseRate = 1000000000000000000; // 1.0%
255     uint256 public rateMultiplier = 39000000000000000000; // 39%
256 
257     // "fee percentage retained by the oracle" = SafeMath.sub(10**20, spreadMultiplier);
258     uint256 public spreadMultiplier;
259 
260     mapping (uint256 => bytes32) public loanOrderHashes; // mapping of levergeAmount to loanOrderHash
261     mapping (bytes32 => LoanData) public loanOrderData; // mapping of loanOrderHash to LoanOrder
262     uint256[] public leverageList;
263 
264     TokenReserves[] public burntTokenReserveList; // array of TokenReserves
265     mapping (address => ListIndex) public burntTokenReserveListIndex; // mapping of lender address to ListIndex objects
266     uint256 public burntTokenReserved; // total outstanding burnt token amount
267     address internal nextOwedLender_;
268 
269     uint256 public totalAssetBorrow = 0; // current amount of loan token amount tied up in loans
270 
271     uint256 internal checkpointSupply_;
272 
273     uint256 internal lastSettleTime_;
274 
275     uint256 public initialPrice;
276 }
277 
278 contract AdvancedTokenStorage is LoanTokenStorage {
279     using SafeMath for uint256;
280 
281     event Transfer(
282         address indexed from,
283         address indexed to,
284         uint256 value
285     );
286     event Approval(
287         address indexed owner,
288         address indexed spender,
289         uint256 value
290     );
291     event Mint(
292         address indexed minter,
293         uint256 tokenAmount,
294         uint256 assetAmount,
295         uint256 price
296     );
297     event Burn(
298         address indexed burner,
299         uint256 tokenAmount,
300         uint256 assetAmount,
301         uint256 price
302     );
303 
304     mapping(address => uint256) internal balances;
305     mapping (address => mapping (address => uint256)) internal allowed;
306     uint256 internal totalSupply_;
307 
308     function totalSupply()
309         public
310         view
311         returns (uint256)
312     {
313         return totalSupply_;
314     }
315 
316     function balanceOf(
317         address _owner)
318         public
319         view
320         returns (uint256)
321     {
322         return balances[_owner];
323     }
324 
325     function allowance(
326         address _owner,
327         address _spender)
328         public
329         view
330         returns (uint256)
331     {
332         return allowed[_owner][_spender];
333     }
334 }
335 
336 contract LoanToken is AdvancedTokenStorage {
337 
338     address internal target_;
339 
340     constructor(
341         address _newTarget)
342         public
343     {
344         _setTarget(_newTarget);
345     }
346 
347     function()
348         external
349         payable
350     {
351         address target = target_;
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
364     function setTarget(
365         address _newTarget)
366         public
367         onlyOwner
368     {
369         _setTarget(_newTarget);
370     }
371 
372     function _setTarget(
373         address _newTarget)
374         internal
375     {
376         require(_isContract(_newTarget), "target not a contract");
377         target_ = _newTarget;
378     }
379 
380     function _isContract(
381         address addr)
382         internal
383         view
384         returns (bool)
385     {
386         uint256 size;
387         assembly { size := extcodesize(addr) }
388         return size > 0;
389     }
390 }