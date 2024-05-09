1 pragma solidity ^0.4.24;
2 
3 // File: contracts/SafeMath.sol
4 
5 /**
6  * @title SafeMath
7  * @dev Math operations with safety checks that revert on error
8  */
9 library SafeMath {
10 
11   /**
12   * @dev Multiplies two numbers, reverts on overflow.
13   */
14   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
15     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
16     // benefit is lost if 'b' is also tested.
17     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
18     if (a == 0) {
19       return 0;
20     }
21 
22     uint256 c = a * b;
23     require(c / a == b);
24 
25     return c;
26   }
27 
28   /**
29   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
30   */
31   function div(uint256 a, uint256 b) internal pure returns (uint256) {
32     require(b > 0); // Solidity only automatically asserts when dividing by 0
33     uint256 c = a / b;
34     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
35 
36     return c;
37   }
38 
39   /**
40   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
41   */
42   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
43     require(b <= a);
44     uint256 c = a - b;
45 
46     return c;
47   }
48 
49   /**
50   * @dev Adds two numbers, reverts on overflow.
51   */
52   function add(uint256 a, uint256 b) internal pure returns (uint256) {
53     uint256 c = a + b;
54     require(c >= a);
55 
56     return c;
57   }
58 
59   /**
60   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
61   * reverts when dividing by zero.
62   */
63   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
64     require(b != 0);
65     return a % b;
66   }
67 }
68 
69 // File: contracts/Ownable.sol
70 
71 /**
72  * @title Ownable
73  * @dev The Ownable contract has an owner address, and provides basic authorization control
74  * functions, this simplifies the implementation of "user permissions".
75  */
76 contract Ownable {
77   address private _owner;
78 
79   event OwnershipTransferred(
80     address indexed previousOwner,
81     address indexed newOwner
82   );
83 
84   /**
85    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
86    * account.
87    */
88   constructor() public {
89     _owner = msg.sender;
90     emit OwnershipTransferred(address(0), _owner);
91   }
92 
93   /**
94    * @return the address of the owner.
95    */
96   function owner() public view returns(address) {
97     return _owner;
98   }
99 
100   /**
101    * @dev Throws if called by any account other than the owner.
102    */
103   modifier onlyOwner() {
104     require(isOwner(msg.sender));
105     _;
106   }
107 
108   /**
109    * @return true if the account is the owner of the contract.
110    */
111   function isOwner(address account) public view returns(bool) {
112     return account == _owner;
113   }
114 
115   /**
116    * @dev Allows the current owner to transfer control of the contract to a newOwner.
117    * @param newOwner The address to transfer ownership to.
118    */
119   function transferOwnership(address newOwner)
120     public
121     onlyOwner
122   {
123     _transferOwnership(newOwner);
124   }
125 
126   /**
127    * @dev Transfers control of the contract to a newOwner.
128    * @param newOwner The address to transfer ownership to.
129    */
130   function _transferOwnership(address newOwner)
131     internal
132   {
133     require(newOwner != address(0));
134     emit OwnershipTransferred(_owner, newOwner);
135     _owner = newOwner;
136   }
137 }
138 
139 // File: contracts/Pausable.sol
140 
141 /**
142  * @title Pausable
143  * @dev Base contract which allows children to implement an emergency stop mechanism.
144  */
145 contract Pausable is Ownable {
146   event Paused();
147   event Unpaused();
148 
149   bool private _paused;
150 
151   constructor() public {
152     _paused = false;
153   }
154 
155   /**
156    * @return true if the contract is paused, false otherwise.
157    */
158   function paused() public view returns(bool) {
159     return _paused;
160   }
161 
162   /**
163    * @dev Modifier to make a function callable only when the contract is not paused.
164    */
165   modifier whenNotPaused() {
166     require(!_paused);
167     _;
168   }
169 
170   /**
171    * @dev Modifier to make a function callable only when the contract is paused.
172    */
173   modifier whenPaused() {
174     require(_paused);
175     _;
176   }
177 
178   /**
179    * @dev called by the owner to pause, triggers stopped state
180    */
181   function pause()
182     public
183     onlyOwner
184     whenNotPaused
185   {
186     _paused = true;
187     emit Paused();
188   }
189 
190   /**
191    * @dev called by the owner to unpause, returns to normal state
192    */
193   function unpause()
194     public
195     onlyOwner
196     whenPaused
197   {
198     _paused = false;
199     emit Unpaused();
200   }
201 }
202 
203 // File: contracts/Operable.sol
204 
205 /**
206  * @title Operable
207  * @dev Base contract that allows the owner to enforce access control over certain
208  * operations by adding or removing operator addresses.
209  */
210 contract Operable is Pausable {
211   event OperatorAdded(address indexed account);
212   event OperatorRemoved(address indexed account);
213 
214   mapping (address => bool) private _operators;
215 
216   constructor() public {
217     _addOperator(msg.sender);
218   }
219 
220   modifier onlyOperator() {
221     require(isOperator(msg.sender));
222     _;
223   }
224 
225   function isOperator(address account)
226     public
227     view
228     returns (bool) 
229   {
230     require(account != address(0));
231     return _operators[account];
232   }
233 
234   function addOperator(address account)
235     public
236     onlyOwner
237   {
238     _addOperator(account);
239   }
240 
241   function removeOperator(address account)
242     public
243     onlyOwner
244   {
245     _removeOperator(account);
246   }
247 
248   function _addOperator(address account)
249     internal
250   {
251     require(account != address(0));
252     _operators[account] = true;
253     emit OperatorAdded(account);
254   }
255 
256   function _removeOperator(address account)
257     internal
258   {
259     require(account != address(0));
260     _operators[account] = false;
261     emit OperatorRemoved(account);
262   }
263 }
264 
265 // File: contracts/TimestampNotary.sol
266 
267 contract TimestampNotary is Operable {
268   struct Time {
269     uint32 declared;
270     uint32 recorded;
271   }
272   mapping (bytes32 => Time) _hashTime;
273 
274   event Timestamp(
275     bytes32 indexed hash,
276     uint32 declaredTime,
277     uint32 recordedTime
278   );
279 
280   /**
281    * @dev Allows an operator to timestamp a new hash value.
282    * @param hash bytes32 The hash value to be stamped in the contract storage
283    * @param declaredTime uint The timestamp associated with the given hash value
284    */
285   function addTimestamp(bytes32 hash, uint32 declaredTime)
286     public
287     onlyOperator
288     whenNotPaused
289     returns (bool)
290   {
291     _addTimestamp(hash, declaredTime);
292     return true;
293   }
294 
295   /**
296    * @dev Registers the timestamp hash value in the contract storage, along with
297    * the current and declared timestamps.
298    * @param hash bytes32 The hash value to be registered
299    * @param declaredTime uint32 The declared timestamp of the hash value
300    */
301   function _addTimestamp(bytes32 hash, uint32 declaredTime) internal {
302     uint32 recordedTime = uint32(block.timestamp);
303     _hashTime[hash] = Time(declaredTime, recordedTime);
304     emit Timestamp(hash, declaredTime, recordedTime);
305   }
306 
307   /**
308    * @dev Allows anyone to verify the declared timestamp for any given hash.
309    */
310   function verifyDeclaredTime(bytes32 hash)
311     public
312     view
313     returns (uint32)
314   {
315     return _hashTime[hash].declared;
316   }
317 
318   /**
319    * @dev Allows anyone to verify the recorded timestamp for any given hash.
320    */
321   function verifyRecordedTime(bytes32 hash)
322     public
323     view
324     returns (uint32)
325   {
326     return _hashTime[hash].recorded;
327   }
328 }
329 
330 // File: contracts/LinkedToken.sol
331 
332 contract LinkedTokenAbstract {
333   function totalSupply() public view returns (uint256);
334   function balanceOf(address account) public view returns (uint256);
335 }
336 
337 
338 contract LinkedToken is Pausable {
339   address internal _token;
340   event TokenChanged(address indexed token);
341   
342   /**
343    * @dev Returns the address of the associated token contract.
344    */
345   function tokenAddress() public view returns (address) {
346     return _token;
347   }
348 
349   /**
350    * @dev Allows the current owner to change the address of the associated token contract.
351    * @param token address The address of the new token contract
352    */
353   function setToken(address token) 
354     public
355     onlyOwner
356     whenPaused
357     returns (bool)
358   {
359     _setToken(token);
360     emit TokenChanged(token);
361     return true;
362   }
363 
364   /**
365    * @dev Changes the address of the associated token contract
366    * @param token address The address of the new token contract
367    */
368   function _setToken(address token) internal {
369     require(token != address(0));
370     _token = token;
371   }
372 }
373 
374 // File: contracts/AssetNotary.sol
375 
376 contract AssetNotary is TimestampNotary, LinkedToken {
377   using SafeMath for uint256;
378 
379   bytes8[] private _assetList;
380   mapping (bytes8 => uint8) private _assetDecimals;
381   mapping (bytes8 => uint256) private _assetBalances;
382 
383   event AssetBalanceUpdate(
384     bytes8 indexed assetId,
385     uint256 balance
386   );
387 
388   function registerAsset(bytes8 assetId, uint8 decimals)
389     public
390     onlyOperator
391     returns (bool)
392   {
393     require(decimals > 0);
394     require(decimals <= 32);
395     _assetDecimals[assetId] = decimals;
396     _assetList.push(assetId);
397     return true;
398   }
399 
400   function assetList()
401     public
402     view
403     returns (bytes8[])
404   {
405     return _assetList;
406   }
407 
408   function getAssetId(string name)
409     public
410     pure
411     returns (bytes8)
412   {
413     return bytes8(keccak256(abi.encodePacked(name)));
414   }
415 
416   function assetDecimals(bytes8 assetId)
417     public
418     view
419     returns (uint8)
420   {
421     return _assetDecimals[assetId];
422   }
423 
424   function assetBalance(bytes8 assetId)
425     public
426     view
427     returns (uint256)
428   {
429     return _assetBalances[assetId];
430   }
431 
432   function updateAssetBalances(bytes8[] assets, uint256[] balances)
433     public
434     onlyOperator
435     whenNotPaused
436     returns (bool)
437   {
438     uint assetsLength = assets.length;
439     require(assetsLength > 0);
440     require(assetsLength == balances.length);
441     
442     for (uint i=0; i<assetsLength; i++) {
443       require(_assetDecimals[assets[i]] > 0);
444       _assetBalances[assets[i]] = balances[i];
445       emit AssetBalanceUpdate(assets[i], balances[i]);
446     }
447     return true;
448   }
449 
450   function verifyUserBalance(address user, string assetName)
451     public
452     view
453     returns (uint256)
454   {
455     LinkedTokenAbstract token = LinkedTokenAbstract(_token);
456     uint256 totalShares = token.totalSupply();
457     require(totalShares > 0);
458     uint256 userShares = token.balanceOf(user);
459     bytes8 assetId = getAssetId(assetName);
460     return _assetBalances[assetId].mul(userShares) / totalShares;
461   }
462 }
463 
464 // File: contracts/XFTNotary.sol
465 
466 contract XFTNotary is AssetNotary {
467   string public constant name = 'XFT Asset Notary';
468   string public constant version = '0.1';
469   
470   /*
471    * @dev Links the Notary contract with the Token contract.
472    */
473   constructor(address token) public {
474     _setToken(token);
475   }
476 }