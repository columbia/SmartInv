1 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
2 
3 pragma solidity ^0.4.24;
4 
5 
6 /**
7  * @title Ownable
8  * @dev The Ownable contract has an owner address, and provides basic authorization control
9  * functions, this simplifies the implementation of "user permissions".
10  */
11 contract Ownable {
12   address public owner;
13 
14 
15   event OwnershipRenounced(address indexed previousOwner);
16   event OwnershipTransferred(
17     address indexed previousOwner,
18     address indexed newOwner
19   );
20 
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
39    * @dev Allows the current owner to relinquish control of the contract.
40    * @notice Renouncing to ownership will leave the contract without an owner.
41    * It will not be possible to call the functions with the `onlyOwner`
42    * modifier anymore.
43    */
44   function renounceOwnership() public onlyOwner {
45     emit OwnershipRenounced(owner);
46     owner = address(0);
47   }
48 
49   /**
50    * @dev Allows the current owner to transfer control of the contract to a newOwner.
51    * @param _newOwner The address to transfer ownership to.
52    */
53   function transferOwnership(address _newOwner) public onlyOwner {
54     _transferOwnership(_newOwner);
55   }
56 
57   /**
58    * @dev Transfers control of the contract to a newOwner.
59    * @param _newOwner The address to transfer ownership to.
60    */
61   function _transferOwnership(address _newOwner) internal {
62     require(_newOwner != address(0));
63     emit OwnershipTransferred(owner, _newOwner);
64     owner = _newOwner;
65   }
66 }
67 
68 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
69 
70 pragma solidity ^0.4.24;
71 
72 
73 /**
74  * @title SafeMath
75  * @dev Math operations with safety checks that throw on error
76  */
77 library SafeMath {
78 
79   /**
80   * @dev Multiplies two numbers, throws on overflow.
81   */
82   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
83     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
84     // benefit is lost if 'b' is also tested.
85     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
86     if (_a == 0) {
87       return 0;
88     }
89 
90     c = _a * _b;
91     assert(c / _a == _b);
92     return c;
93   }
94 
95   /**
96   * @dev Integer division of two numbers, truncating the quotient.
97   */
98   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
99     // assert(_b > 0); // Solidity automatically throws when dividing by 0
100     // uint256 c = _a / _b;
101     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
102     return _a / _b;
103   }
104 
105   /**
106   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
107   */
108   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
109     assert(_b <= _a);
110     return _a - _b;
111   }
112 
113   /**
114   * @dev Adds two numbers, throws on overflow.
115   */
116   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
117     c = _a + _b;
118     assert(c >= _a);
119     return c;
120   }
121 }
122 
123 // File: contracts/interfaces/ChainlinkRequestInterface.sol
124 
125 pragma solidity 0.4.24;
126 
127 interface ChainlinkRequestInterface {
128   function oracleRequest(
129     address sender,
130     uint256 payment,
131     bytes32 id,
132     address callbackAddress,
133     bytes4 callbackFunctionId,
134     uint256 nonce,
135     uint256 version,
136     bytes data
137   ) external;
138 
139   function cancelOracleRequest(
140     bytes32 requestId,
141     uint256 payment,
142     bytes4 callbackFunctionId,
143     uint256 expiration
144   ) external;
145 }
146 
147 // File: contracts/interfaces/OracleInterface.sol
148 
149 pragma solidity 0.4.24;
150 
151 interface OracleInterface {
152   function fulfillOracleRequest(
153     bytes32 requestId,
154     uint256 payment,
155     address callbackAddress,
156     bytes4 callbackFunctionId,
157     uint256 expiration,
158     bytes32 data
159   ) external returns (bool);
160   function getAuthorizationStatus(address node) external view returns (bool);
161   function setFulfillmentPermission(address node, bool allowed) external;
162   function withdraw(address recipient, uint256 amount) external;
163   function withdrawable() external view returns (uint256);
164 }
165 
166 // File: contracts/interfaces/LinkTokenInterface.sol
167 
168 pragma solidity 0.4.24;
169 
170 interface LinkTokenInterface {
171   function allowance(address owner, address spender) external returns (bool success);
172   function approve(address spender, uint256 value) external returns (bool success);
173   function balanceOf(address owner) external returns (uint256 balance);
174   function decimals() external returns (uint8 decimalPlaces);
175   function decreaseApproval(address spender, uint256 addedValue) external returns (bool success);
176   function increaseApproval(address spender, uint256 subtractedValue) external;
177   function name() external returns (string tokenName);
178   function symbol() external returns (string tokenSymbol);
179   function totalSupply() external returns (uint256 totalTokensIssued);
180   function transfer(address to, uint256 value) external returns (bool success);
181   function transferAndCall(address to, uint256 value, bytes data) external returns (bool success);
182   function transferFrom(address from, address to, uint256 value) external returns (bool success);
183 }
184 
185 // File: contracts/Oracle.sol
186 
187 pragma solidity 0.4.24;
188 
189 
190 
191 
192 
193 
194 /**
195  * @title The Chainlink Oracle contract
196  * @notice Node operators can deploy this contract to fulfill requests sent to them
197  */
198 contract Oracle is ChainlinkRequestInterface, OracleInterface, Ownable {
199   using SafeMath for uint256;
200 
201   uint256 constant public EXPIRY_TIME = 5 minutes;
202   uint256 constant private MINIMUM_CONSUMER_GAS_LIMIT = 400000;
203   // We initialize fields to 1 instead of 0 so that the first invocation
204   // does not cost more gas.
205   uint256 constant private ONE_FOR_CONSISTENT_GAS_COST = 1;
206   uint256 constant private SELECTOR_LENGTH = 4;
207   uint256 constant private EXPECTED_REQUEST_WORDS = 2;
208   // solium-disable-next-line zeppelin/no-arithmetic-operations
209   uint256 constant private MINIMUM_REQUEST_LENGTH = SELECTOR_LENGTH + (32 * EXPECTED_REQUEST_WORDS);
210 
211   LinkTokenInterface internal LinkToken;
212   mapping(bytes32 => bytes32) private commitments;
213   mapping(address => bool) private authorizedNodes;
214   uint256 private withdrawableTokens = ONE_FOR_CONSISTENT_GAS_COST;
215 
216   event OracleRequest(
217     bytes32 indexed specId,
218     address requester,
219     bytes32 requestId,
220     uint256 payment,
221     address callbackAddr,
222     bytes4 callbackFunctionId,
223     uint256 cancelExpiration,
224     uint256 dataVersion,
225     bytes data
226   );
227 
228   event CancelOracleRequest(
229     bytes32 indexed requestId
230   );
231 
232   /**
233    * @notice Deploy with the address of the LINK token
234    * @dev Sets the LinkToken address for the imported LinkTokenInterface
235    * @param _link The address of the LINK token
236    */
237   constructor(address _link) Ownable() public {
238     LinkToken = LinkTokenInterface(_link);
239   }
240 
241   /**
242    * @notice Called when LINK is sent to the contract via `transferAndCall`
243    * @dev The data payload's first 2 words will be overwritten by the `_sender` and `_amount`
244    * values to ensure correctness. Calls oracleRequest.
245    * @param _sender Address of the sender
246    * @param _amount Amount of LINK sent (specified in wei)
247    * @param _data Payload of the transaction
248    */
249   function onTokenTransfer(
250     address _sender,
251     uint256 _amount,
252     bytes _data
253   )
254     public
255     onlyLINK
256     validRequestLength(_data)
257     permittedFunctionsForLINK(_data)
258   {
259     assembly {
260       // solium-disable-next-line security/no-low-level-calls
261       mstore(add(_data, 36), _sender) // ensure correct sender is passed
262       // solium-disable-next-line security/no-low-level-calls
263       mstore(add(_data, 68), _amount)    // ensure correct amount is passed
264     }
265     // solium-disable-next-line security/no-low-level-calls
266     require(address(this).delegatecall(_data), "Unable to create request"); // calls oracleRequest
267   }
268 
269   /**
270    * @notice Creates the Chainlink request
271    * @dev Stores the hash of the params as the on-chain commitment for the request.
272    * Emits OracleRequest event for the Chainlink node to detect.
273    * @param _sender The sender of the request
274    * @param _payment The amount of payment given (specified in wei)
275    * @param _specId The Job Specification ID
276    * @param _callbackAddress The callback address for the response
277    * @param _callbackFunctionId The callback function ID for the response
278    * @param _nonce The nonce sent by the requester
279    * @param _dataVersion The specified data version
280    * @param _data The CBOR payload of the request
281    */
282   function oracleRequest(
283     address _sender,
284     uint256 _payment,
285     bytes32 _specId,
286     address _callbackAddress,
287     bytes4 _callbackFunctionId,
288     uint256 _nonce,
289     uint256 _dataVersion,
290     bytes _data
291   )
292     external
293     onlyLINK
294     checkCallbackAddress(_callbackAddress)
295   {
296     bytes32 requestId = keccak256(abi.encodePacked(_sender, _nonce));
297     require(commitments[requestId] == 0, "Must use a unique ID");
298     uint256 expiration = now.add(EXPIRY_TIME);
299 
300     commitments[requestId] = keccak256(
301       abi.encodePacked(
302         _payment,
303         _callbackAddress,
304         _callbackFunctionId,
305         expiration
306       )
307     );
308 
309     emit OracleRequest(
310       _specId,
311       _sender,
312       requestId,
313       _payment,
314       _callbackAddress,
315       _callbackFunctionId,
316       expiration,
317       _dataVersion,
318       _data);
319   }
320 
321   /**
322    * @notice Called by the Chainlink node to fulfill requests
323    * @dev Given params must hash back to the commitment stored from `oracleRequest`.
324    * Will call the callback address' callback function without bubbling up error
325    * checking in a `require` so that the node can get paid.
326    * @param _requestId The fulfillment request ID that must match the requester's
327    * @param _payment The payment amount that will be released for the oracle (specified in wei)
328    * @param _callbackAddress The callback address to call for fulfillment
329    * @param _callbackFunctionId The callback function ID to use for fulfillment
330    * @param _expiration The expiration that the node should respond by before the requester can cancel
331    * @param _data The data to return to the consuming contract
332    * @return Status if the external call was successful
333    */
334   function fulfillOracleRequest(
335     bytes32 _requestId,
336     uint256 _payment,
337     address _callbackAddress,
338     bytes4 _callbackFunctionId,
339     uint256 _expiration,
340     bytes32 _data
341   )
342     external
343     onlyAuthorizedNode
344     isValidRequest(_requestId)
345     returns (bool)
346   {
347     bytes32 paramsHash = keccak256(
348       abi.encodePacked(
349         _payment,
350         _callbackAddress,
351         _callbackFunctionId,
352         _expiration
353       )
354     );
355     require(commitments[_requestId] == paramsHash, "Params do not match request ID");
356     withdrawableTokens = withdrawableTokens.add(_payment);
357     delete commitments[_requestId];
358     require(gasleft() >= MINIMUM_CONSUMER_GAS_LIMIT, "Must provide consumer enough gas");
359     // All updates to the oracle's fulfillment should come before calling the
360     // callback(addr+functionId) as it is untrusted.
361     // See: https://solidity.readthedocs.io/en/develop/security-considerations.html#use-the-checks-effects-interactions-pattern
362     return _callbackAddress.call(_callbackFunctionId, _requestId, _data); // solium-disable-line security/no-low-level-calls
363   }
364 
365   /**
366    * @notice Use this to check if a node is authorized for fulfilling requests
367    * @param _node The address of the Chainlink node
368    * @return The authorization status of the node
369    */
370   function getAuthorizationStatus(address _node) external view returns (bool) {
371     return authorizedNodes[_node];
372   }
373 
374   /**
375    * @notice Sets the fulfillment permission for a given node. Use `true` to allow, `false` to disallow.
376    * @param _node The address of the Chainlink node
377    * @param _allowed Bool value to determine if the node can fulfill requests
378    */
379   function setFulfillmentPermission(address _node, bool _allowed) external onlyOwner {
380     authorizedNodes[_node] = _allowed;
381   }
382 
383   /**
384    * @notice Allows the node operator to withdraw earned LINK to a given address
385    * @dev The owner of the contract can be another wallet and does not have to be a Chainlink node
386    * @param _recipient The address to send the LINK token to
387    * @param _amount The amount to send (specified in wei)
388    */
389   function withdraw(address _recipient, uint256 _amount)
390     external
391     onlyOwner
392     hasAvailableFunds(_amount)
393   {
394     withdrawableTokens = withdrawableTokens.sub(_amount);
395     assert(LinkToken.transfer(_recipient, _amount));
396   }
397 
398   /**
399    * @notice Displays the amount of LINK that is available for the node operator to withdraw
400    * @dev We use `ONE_FOR_CONSISTENT_GAS_COST` in place of 0 in storage
401    * @return The amount of withdrawable LINK on the contract
402    */
403   function withdrawable() external view onlyOwner returns (uint256) {
404     return withdrawableTokens.sub(ONE_FOR_CONSISTENT_GAS_COST);
405   }
406 
407   /**
408    * @notice Allows requesters to cancel requests sent to this oracle contract. Will transfer the LINK
409    * sent for the request back to the requester's address.
410    * @dev Given params must hash to a commitment stored on the contract in order for the request to be valid
411    * Emits CancelOracleRequest event.
412    * @param _requestId The request ID
413    * @param _payment The amount of payment given (specified in wei)
414    * @param _callbackFunc The requester's specified callback address
415    * @param _expiration The time of the expiration for the request
416    */
417   function cancelOracleRequest(
418     bytes32 _requestId,
419     uint256 _payment,
420     bytes4 _callbackFunc,
421     uint256 _expiration
422   ) external {
423     bytes32 paramsHash = keccak256(
424       abi.encodePacked(
425         _payment,
426         msg.sender,
427         _callbackFunc,
428         _expiration)
429     );
430     require(paramsHash == commitments[_requestId], "Params do not match request ID");
431     require(_expiration <= now, "Request is not expired");
432 
433     delete commitments[_requestId];
434     emit CancelOracleRequest(_requestId);
435 
436     assert(LinkToken.transfer(msg.sender, _payment));
437   }
438 
439   // MODIFIERS
440 
441   /**
442    * @dev Reverts if amount requested is greater than withdrawable balance
443    * @param _amount The given amount to compare to `withdrawableTokens`
444    */
445   modifier hasAvailableFunds(uint256 _amount) {
446     require(withdrawableTokens >= _amount.add(ONE_FOR_CONSISTENT_GAS_COST), "Amount requested is greater than withdrawable balance");
447     _;
448   }
449 
450   /**
451    * @dev Reverts if request ID does not exist
452    * @param _requestId The given request ID to check in stored `commitments`
453    */
454   modifier isValidRequest(bytes32 _requestId) {
455     require(commitments[_requestId] != 0, "Must have a valid requestId");
456     _;
457   }
458 
459   /**
460    * @dev Reverts if `msg.sender` is not authorized to fulfill requests
461    */
462   modifier onlyAuthorizedNode() {
463     require(authorizedNodes[msg.sender] || msg.sender == owner, "Not an authorized node to fulfill requests");
464     _;
465   }
466 
467   /**
468    * @dev Reverts if not sent from the LINK token
469    */
470   modifier onlyLINK() {
471     require(msg.sender == address(LinkToken), "Must use LINK token");
472     _;
473   }
474 
475   /**
476    * @dev Reverts if the given data does not begin with the `oracleRequest` function selector
477    * @param _data The data payload of the request
478    */
479   modifier permittedFunctionsForLINK(bytes _data) {
480     bytes4 funcSelector;
481     assembly {
482       // solium-disable-next-line security/no-low-level-calls
483       funcSelector := mload(add(_data, 32))
484     }
485     require(funcSelector == this.oracleRequest.selector, "Must use whitelisted functions");
486     _;
487   }
488 
489   /**
490    * @dev Reverts if the callback address is the LINK token
491    * @param _to The callback address
492    */
493   modifier checkCallbackAddress(address _to) {
494     require(_to != address(LinkToken), "Cannot callback to LINK");
495     _;
496   }
497 
498   /**
499    * @dev Reverts if the given payload is less than needed to create a request
500    * @param _data The request payload
501    */
502   modifier validRequestLength(bytes _data) {
503     require(_data.length >= MINIMUM_REQUEST_LENGTH, "Invalid request length");
504     _;
505   }
506 
507 }