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
203 contract LoanTokenizationV2 is ReentrancyGuard, Ownable {
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
218     bool public mintingPaused;
219     bool public burningPaused;
220 
221     // price of token at last user checkpoint
222     mapping (address => uint256) internal checkpointPrices_;
223 
224 
225     function pauseMinting(
226         bool _isPaused)
227         public
228         onlyOwner
229     {
230         mintingPaused = _isPaused;
231     }
232     function pauseBurning(
233         bool _isPaused)
234         public
235         onlyOwner
236     {
237         burningPaused = _isPaused;
238     }
239 }
240 
241 contract PositionTokenStorageV2 is LoanTokenizationV2 {
242 
243     bool internal isInitialized_ = false;
244 
245     address public loanTokenLender;
246     address public tradeTokenAddress;
247 
248     uint256 public leverageAmount;
249     bytes32 public loanOrderHash;
250 
251     uint256 public loanTokenDecimals;
252     uint256 public loanTokenAdjustment;
253 
254     uint256 public tradeTokenDecimals;
255     uint256 public tradeTokenAdjustment;
256 
257     uint256 public initialPrice;
258 
259     bool public shortPosition;
260 
261     mapping (address => uint256) public userSurplus;
262     mapping (address => uint256) public userDeficit;
263 
264     uint256 public totalSurplus;
265     uint256 public totalDeficit;
266 }
267 
268 contract SplittableTokenStorageV2 is PositionTokenStorageV2 {
269     using SafeMath for uint256;
270 
271     event Transfer(
272         address indexed from,
273         address indexed to,
274         uint256 value
275     );
276     event Approval(
277         address indexed owner,
278         address indexed spender,
279         uint256 value
280     );
281     event Mint(
282         address indexed minter,
283         address indexed depositAddress,
284         uint256 depositAmount,
285         uint256 tokenAmount,
286         uint256 price
287     );
288     event Burn(
289         address indexed burner,
290         address indexed withdrawalAddress,
291         uint256 withdrawalAmount,
292         uint256 tokenAmount,
293         uint256 price
294     );
295 
296     mapping(address => uint256) internal balances;
297     mapping (address => mapping (address => uint256)) internal allowed;
298     uint256 internal totalSupply_;
299 
300     uint256 public splitFactor = 10**18;
301 
302     function totalSupply()
303         public
304         view
305         returns (uint256)
306     {
307         return denormalize(totalSupply_);
308     }
309 
310     function balanceOf(
311         address _owner)
312         public
313         view
314         returns (uint256)
315     {
316         return denormalize(balances[_owner]);
317     }
318 
319     function allowance(
320         address _owner,
321         address _spender)
322         public
323         view
324         returns (uint256)
325     {
326         return denormalize(allowed[_owner][_spender]);
327     }
328 
329     function normalize(
330         uint256 _value)
331         internal
332         view
333         returns (uint256)
334     {
335         return _value
336             .mul(splitFactor)
337             .div(10**18);
338     }
339 
340     function denormalize(
341         uint256 _value)
342         internal
343         view
344         returns (uint256)
345     {
346         return _value
347             .mul(10**18)
348             .div(splitFactor);
349     }
350 }
351 
352 contract PositionTokenV2 is SplittableTokenStorageV2 {
353 
354     address internal target_;
355 
356     constructor(
357         address _newTarget)
358         public
359     {
360         _setTarget(_newTarget);
361     }
362 
363     function()
364         external
365         payable
366     {
367         address target = target_;
368         bytes memory data = msg.data;
369         assembly {
370             let result := delegatecall(gas, target, add(data, 0x20), mload(data), 0, 0)
371             let size := returndatasize
372             let ptr := mload(0x40)
373             returndatacopy(ptr, 0, size)
374             switch result
375             case 0 { revert(ptr, size) }
376             default { return(ptr, size) }
377         }
378     }
379 
380     function setTarget(
381         address _newTarget)
382         public
383         onlyOwner
384     {
385         _setTarget(_newTarget);
386     }
387 
388     function _setTarget(
389         address _newTarget)
390         internal
391     {
392         require(_isContract(_newTarget), "target not a contract");
393         target_ = _newTarget;
394     }
395 
396     function _isContract(
397         address addr)
398         internal
399         view
400         returns (bool)
401     {
402         uint256 size;
403         assembly { size := extcodesize(addr) }
404         return size > 0;
405     }
406 }