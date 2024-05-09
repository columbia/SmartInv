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
236     }
237 
238     struct TokenReserves {
239         address lender;
240         uint256 amount;
241     }
242 
243     event Borrow(
244         address indexed borrower,
245         uint256 borrowAmount,
246         uint256 interestRate,
247         address collateralTokenAddress,
248         address tradeTokenToFillAddress,
249         bool withdrawOnOpen
250     );
251 
252     event Claim(
253         address indexed claimant,
254         uint256 tokenAmount,
255         uint256 assetAmount,
256         uint256 remainingTokenAmount,
257         uint256 price
258     );
259 
260     bool internal isInitialized_ = false;
261 
262     address public tokenizedRegistry;
263 
264     uint256 public baseRate = 1000000000000000000; // 1.0%
265     uint256 public rateMultiplier = 22000000000000000000; // 22%
266 
267     // "fee percentage retained by the oracle" = SafeMath.sub(10**20, spreadMultiplier);
268     uint256 public spreadMultiplier;
269 
270     mapping (uint256 => bytes32) public loanOrderHashes; // mapping of levergeAmount to loanOrderHash
271     mapping (bytes32 => LoanData) public loanOrderData; // mapping of loanOrderHash to LoanOrder
272     uint256[] public leverageList;
273 
274     TokenReserves[] public burntTokenReserveList; // array of TokenReserves
275     mapping (address => ListIndex) public burntTokenReserveListIndex; // mapping of lender address to ListIndex objects
276     uint256 public burntTokenReserved; // total outstanding burnt token amount
277     address internal nextOwedLender_;
278 
279     uint256 public totalAssetBorrow; // current amount of loan token amount tied up in loans
280 
281     uint256 public checkpointSupply;
282 
283     uint256 internal lastSettleTime_;
284 
285     uint256 public initialPrice;
286 }
287 
288 contract AdvancedTokenStorage is LoanTokenStorage {
289     using SafeMath for uint256;
290 
291     event Transfer(
292         address indexed from,
293         address indexed to,
294         uint256 value
295     );
296     event Approval(
297         address indexed owner,
298         address indexed spender,
299         uint256 value
300     );
301     event Mint(
302         address indexed minter,
303         uint256 tokenAmount,
304         uint256 assetAmount,
305         uint256 price
306     );
307     event Burn(
308         address indexed burner,
309         uint256 tokenAmount,
310         uint256 assetAmount,
311         uint256 price
312     );
313 
314     mapping(address => uint256) internal balances;
315     mapping (address => mapping (address => uint256)) internal allowed;
316     uint256 internal totalSupply_;
317 
318     function totalSupply()
319         public
320         view
321         returns (uint256)
322     {
323         return totalSupply_;
324     }
325 
326     function balanceOf(
327         address _owner)
328         public
329         view
330         returns (uint256)
331     {
332         return balances[_owner];
333     }
334 
335     function allowance(
336         address _owner,
337         address _spender)
338         public
339         view
340         returns (uint256)
341     {
342         return allowed[_owner][_spender];
343     }
344 }
345 
346 contract LoanToken is AdvancedTokenStorage {
347 
348     address internal target_;
349 
350     constructor(
351         address _newTarget)
352         public
353     {
354         _setTarget(_newTarget);
355     }
356 
357     function()
358         external
359         payable
360     {
361         address target = target_;
362         bytes memory data = msg.data;
363         assembly {
364             let result := delegatecall(gas, target, add(data, 0x20), mload(data), 0, 0)
365             let size := returndatasize
366             let ptr := mload(0x40)
367             returndatacopy(ptr, 0, size)
368             switch result
369             case 0 { revert(ptr, size) }
370             default { return(ptr, size) }
371         }
372     }
373 
374     function setTarget(
375         address _newTarget)
376         public
377         onlyOwner
378     {
379         _setTarget(_newTarget);
380     }
381 
382     function _setTarget(
383         address _newTarget)
384         internal
385     {
386         require(_isContract(_newTarget), "target not a contract");
387         target_ = _newTarget;
388     }
389 
390     function _isContract(
391         address addr)
392         internal
393         view
394         returns (bool)
395     {
396         uint256 size;
397         assembly { size := extcodesize(addr) }
398         return size > 0;
399     }
400 }