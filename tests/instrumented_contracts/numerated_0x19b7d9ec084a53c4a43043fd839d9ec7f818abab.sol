1 // File: https://github.com/smartcontractkit/chainlink/evm-contracts/src/v0.4/interfaces/LinkTokenInterface.sol
2 
3 pragma solidity ^0.4.24;
4 
5 interface LinkTokenInterface {
6   function allowance(address owner, address spender) external view returns (uint256 remaining);
7   function approve(address spender, uint256 value) external returns (bool success);
8   function balanceOf(address owner) external view returns (uint256 balance);
9   function decimals() external view returns (uint8 decimalPlaces);
10   function decreaseApproval(address spender, uint256 addedValue) external returns (bool success);
11   function increaseApproval(address spender, uint256 subtractedValue) external;
12   function name() external view returns (string tokenName);
13   function symbol() external view returns (string tokenSymbol);
14   function totalSupply() external view returns (uint256 totalTokensIssued);
15   function transfer(address to, uint256 value) external returns (bool success);
16   function transferAndCall(address to, uint256 value, bytes data) external returns (bool success);
17   function transferFrom(address from, address to, uint256 value) external returns (bool success);
18 }
19 
20 // File: https://github.com/smartcontractkit/chainlink/evm-contracts/src/v0.4/interfaces/OracleInterface.sol
21 
22 pragma solidity ^0.4.24;
23 
24 interface OracleInterface {
25   function fulfillOracleRequest(
26     bytes32 requestId,
27     uint256 payment,
28     address callbackAddress,
29     bytes4 callbackFunctionId,
30     uint256 expiration,
31     bytes32 data
32   ) external returns (bool);
33   function getAuthorizationStatus(address node) external view returns (bool);
34   function setFulfillmentPermission(address node, bool allowed) external;
35   function withdraw(address recipient, uint256 amount) external;
36   function withdrawable() external view returns (uint256);
37 }
38 
39 // File: https://github.com/smartcontractkit/chainlink/evm-contracts/src/v0.4/interfaces/ChainlinkRequestInterface.sol
40 
41 pragma solidity ^0.4.24;
42 
43 interface ChainlinkRequestInterface {
44   function oracleRequest(
45     address sender,
46     uint256 payment,
47     bytes32 id,
48     address callbackAddress,
49     bytes4 callbackFunctionId,
50     uint256 nonce,
51     uint256 version,
52     bytes data
53   ) external;
54 
55   function cancelOracleRequest(
56     bytes32 requestId,
57     uint256 payment,
58     bytes4 callbackFunctionId,
59     uint256 expiration
60   ) external;
61 }
62 
63 // File: https://github.com/smartcontractkit/chainlink/evm-contracts/src/v0.4/vendor/SafeMathChainlink.sol
64 
65 pragma solidity ^0.4.11;
66 
67 
68 /**
69  * @title SafeMath
70  * @dev Math operations with safety checks that throw on error
71  */
72 library SafeMathChainlink {
73 
74   /**
75   * @dev Multiplies two numbers, throws on overflow.
76   */
77   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
78     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
79     // benefit is lost if 'b' is also tested.
80     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
81     if (_a == 0) {
82       return 0;
83     }
84 
85     c = _a * _b;
86     assert(c / _a == _b);
87     return c;
88   }
89 
90   /**
91   * @dev Integer division of two numbers, truncating the quotient.
92   */
93   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
94     // assert(_b > 0); // Solidity automatically throws when dividing by 0
95     // uint256 c = _a / _b;
96     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
97     return _a / _b;
98   }
99 
100   /**
101   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
102   */
103   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
104     assert(_b <= _a);
105     return _a - _b;
106   }
107 
108   /**
109   * @dev Adds two numbers, throws on overflow.
110   */
111   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
112     c = _a + _b;
113     assert(c >= _a);
114     return c;
115   }
116 }
117 
118 // File: https://github.com/smartcontractkit/chainlink/evm-contracts/src/v0.4/vendor/Ownable.sol
119 
120 pragma solidity ^0.4.24;
121 
122 
123 /**
124  * @title Ownable
125  * @dev The Ownable contract has an owner address, and provides basic authorization control
126  * functions, this simplifies the implementation of "user permissions".
127  */
128 contract Ownable {
129   address public owner;
130 
131 
132   event OwnershipRenounced(address indexed previousOwner);
133   event OwnershipTransferred(
134     address indexed previousOwner,
135     address indexed newOwner
136   );
137 
138 
139   /**
140    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
141    * account.
142    */
143   constructor() public {
144     owner = msg.sender;
145   }
146 
147   /**
148    * @dev Throws if called by any account other than the owner.
149    */
150   modifier onlyOwner() {
151     require(msg.sender == owner);
152     _;
153   }
154 
155   /**
156    * @dev Allows the current owner to relinquish control of the contract.
157    * @notice Renouncing to ownership will leave the contract without an owner.
158    * It will not be possible to call the functions with the `onlyOwner`
159    * modifier anymore.
160    */
161   function renounceOwnership() public onlyOwner {
162     emit OwnershipRenounced(owner);
163     owner = address(0);
164   }
165 
166   /**
167    * @dev Allows the current owner to transfer control of the contract to a newOwner.
168    * @param _newOwner The address to transfer ownership to.
169    */
170   function transferOwnership(address _newOwner) public onlyOwner {
171     _transferOwnership(_newOwner);
172   }
173 
174   /**
175    * @dev Transfers control of the contract to a newOwner.
176    * @param _newOwner The address to transfer ownership to.
177    */
178   function _transferOwnership(address _newOwner) internal {
179     require(_newOwner != address(0));
180     emit OwnershipTransferred(owner, _newOwner);
181     owner = _newOwner;
182   }
183 }
184 
185 // File: https://github.com/smartcontractkit/chainlink/evm-contracts/src/v0.4/Oracle.sol
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
199   using SafeMathChainlink for uint256;
200 
201   uint256 constant public EXPIRY_TIME = 5 minutes;
202   uint256 constant private MINIMUM_CONSUMER_GAS_LIMIT = 400000;
203   // We initialize fields to 1 instead of 0 so that the first invocation
204   // does not cost more gas.
205   uint256 constant private ONE_FOR_CONSISTENT_GAS_COST = 1;
206   uint256 constant private SELECTOR_LENGTH = 4;
207   uint256 constant private EXPECTED_REQUEST_WORDS = 2;
208   uint256 constant private MINIMUM_REQUEST_LENGTH = SELECTOR_LENGTH + (32 * EXPECTED_REQUEST_WORDS);
209 
210   LinkTokenInterface internal LinkToken;
211   mapping(bytes32 => bytes32) private commitments;
212   mapping(address => bool) private authorizedNodes;
213   uint256 private withdrawableTokens = ONE_FOR_CONSISTENT_GAS_COST;
214 
215   event OracleRequest(
216     bytes32 indexed specId,
217     address requester,
218     bytes32 requestId,
219     uint256 payment,
220     address callbackAddr,
221     bytes4 callbackFunctionId,
222     uint256 cancelExpiration,
223     uint256 dataVersion,
224     bytes data
225   );
226 
227   event CancelOracleRequest(
228     bytes32 indexed requestId
229   );
230 
231   /**
232    * @notice Deploy with the address of the LINK token
233    * @dev Sets the LinkToken address for the imported LinkTokenInterface
234    * @param _link The address of the LINK token
235    */
236   constructor(address _link) public Ownable() {
237     LinkToken = LinkTokenInterface(_link); // external but already deployed and unalterable
238   }
239 
240   /**
241    * @notice Called when LINK is sent to the contract via `transferAndCall`
242    * @dev The data payload's first 2 words will be overwritten by the `_sender` and `_amount`
243    * values to ensure correctness. Calls oracleRequest.
244    * @param _sender Address of the sender
245    * @param _amount Amount of LINK sent (specified in wei)
246    * @param _data Payload of the transaction
247    */
248   function onTokenTransfer(
249     address _sender,
250     uint256 _amount,
251     bytes _data
252   )
253     public
254     onlyLINK
255     validRequestLength(_data)
256     permittedFunctionsForLINK(_data)
257   {
258     assembly { // solhint-disable-line no-inline-assembly
259       mstore(add(_data, 36), _sender) // ensure correct sender is passed
260       mstore(add(_data, 68), _amount) // ensure correct amount is passed
261     }
262     // solhint-disable-next-line avoid-low-level-calls
263     require(address(this).delegatecall(_data), "Unable to create request"); // calls oracleRequest
264   }
265 
266   /**
267    * @notice Creates the Chainlink request
268    * @dev Stores the hash of the params as the on-chain commitment for the request.
269    * Emits OracleRequest event for the Chainlink node to detect.
270    * @param _sender The sender of the request
271    * @param _payment The amount of payment given (specified in wei)
272    * @param _specId The Job Specification ID
273    * @param _callbackAddress The callback address for the response
274    * @param _callbackFunctionId The callback function ID for the response
275    * @param _nonce The nonce sent by the requester
276    * @param _dataVersion The specified data version
277    * @param _data The CBOR payload of the request
278    */
279   function oracleRequest(
280     address _sender,
281     uint256 _payment,
282     bytes32 _specId,
283     address _callbackAddress,
284     bytes4 _callbackFunctionId,
285     uint256 _nonce,
286     uint256 _dataVersion,
287     bytes _data
288   )
289     external
290     onlyLINK
291     checkCallbackAddress(_callbackAddress)
292   {
293     bytes32 requestId = keccak256(abi.encodePacked(_sender, _nonce));
294     require(commitments[requestId] == 0, "Must use a unique ID");
295     // solhint-disable-next-line not-rely-on-time
296     uint256 expiration = now.add(EXPIRY_TIME);
297 
298     commitments[requestId] = keccak256(
299       abi.encodePacked(
300         _payment,
301         _callbackAddress,
302         _callbackFunctionId,
303         expiration
304       )
305     );
306 
307     emit OracleRequest(
308       _specId,
309       _sender,
310       requestId,
311       _payment,
312       _callbackAddress,
313       _callbackFunctionId,
314       expiration,
315       _dataVersion,
316       _data);
317   }
318 
319   /**
320    * @notice Called by the Chainlink node to fulfill requests
321    * @dev Given params must hash back to the commitment stored from `oracleRequest`.
322    * Will call the callback address' callback function without bubbling up error
323    * checking in a `require` so that the node can get paid.
324    * @param _requestId The fulfillment request ID that must match the requester's
325    * @param _payment The payment amount that will be released for the oracle (specified in wei)
326    * @param _callbackAddress The callback address to call for fulfillment
327    * @param _callbackFunctionId The callback function ID to use for fulfillment
328    * @param _expiration The expiration that the node should respond by before the requester can cancel
329    * @param _data The data to return to the consuming contract
330    * @return Status if the external call was successful
331    */
332   function fulfillOracleRequest(
333     bytes32 _requestId,
334     uint256 _payment,
335     address _callbackAddress,
336     bytes4 _callbackFunctionId,
337     uint256 _expiration,
338     bytes32 _data
339   )
340     external
341     onlyAuthorizedNode
342     isValidRequest(_requestId)
343     returns (bool)
344   {
345     bytes32 paramsHash = keccak256(
346       abi.encodePacked(
347         _payment,
348         _callbackAddress,
349         _callbackFunctionId,
350         _expiration
351       )
352     );
353     require(commitments[_requestId] == paramsHash, "Params do not match request ID");
354     withdrawableTokens = withdrawableTokens.add(_payment);
355     delete commitments[_requestId];
356     require(gasleft() >= MINIMUM_CONSUMER_GAS_LIMIT, "Must provide consumer enough gas");
357     // All updates to the oracle's fulfillment should come before calling the
358     // callback(addr+functionId) as it is untrusted.
359     // See: https://solidity.readthedocs.io/en/develop/security-considerations.html#use-the-checks-effects-interactions-pattern
360     return _callbackAddress.call(_callbackFunctionId, _requestId, _data); // solhint-disable-line avoid-low-level-calls
361   }
362 
363   /**
364    * @notice Use this to check if a node is authorized for fulfilling requests
365    * @param _node The address of the Chainlink node
366    * @return The authorization status of the node
367    */
368   function getAuthorizationStatus(address _node) external view returns (bool) {
369     return authorizedNodes[_node];
370   }
371 
372   /**
373    * @notice Sets the fulfillment permission for a given node. Use `true` to allow, `false` to disallow.
374    * @param _node The address of the Chainlink node
375    * @param _allowed Bool value to determine if the node can fulfill requests
376    */
377   function setFulfillmentPermission(address _node, bool _allowed) external onlyOwner {
378     authorizedNodes[_node] = _allowed;
379   }
380 
381   /**
382    * @notice Allows the node operator to withdraw earned LINK to a given address
383    * @dev The owner of the contract can be another wallet and does not have to be a Chainlink node
384    * @param _recipient The address to send the LINK token to
385    * @param _amount The amount to send (specified in wei)
386    */
387   function withdraw(address _recipient, uint256 _amount)
388     external
389     onlyOwner
390     hasAvailableFunds(_amount)
391   {
392     withdrawableTokens = withdrawableTokens.sub(_amount);
393     assert(LinkToken.transfer(_recipient, _amount));
394   }
395 
396   /**
397    * @notice Displays the amount of LINK that is available for the node operator to withdraw
398    * @dev We use `ONE_FOR_CONSISTENT_GAS_COST` in place of 0 in storage
399    * @return The amount of withdrawable LINK on the contract
400    */
401   function withdrawable() external view onlyOwner returns (uint256) {
402     return withdrawableTokens.sub(ONE_FOR_CONSISTENT_GAS_COST);
403   }
404 
405   /**
406    * @notice Allows requesters to cancel requests sent to this oracle contract. Will transfer the LINK
407    * sent for the request back to the requester's address.
408    * @dev Given params must hash to a commitment stored on the contract in order for the request to be valid
409    * Emits CancelOracleRequest event.
410    * @param _requestId The request ID
411    * @param _payment The amount of payment given (specified in wei)
412    * @param _callbackFunc The requester's specified callback address
413    * @param _expiration The time of the expiration for the request
414    */
415   function cancelOracleRequest(
416     bytes32 _requestId,
417     uint256 _payment,
418     bytes4 _callbackFunc,
419     uint256 _expiration
420   ) external {
421     bytes32 paramsHash = keccak256(
422       abi.encodePacked(
423         _payment,
424         msg.sender,
425         _callbackFunc,
426         _expiration)
427     );
428     require(paramsHash == commitments[_requestId], "Params do not match request ID");
429     // solhint-disable-next-line not-rely-on-time
430     require(_expiration <= now, "Request is not expired");
431 
432     delete commitments[_requestId];
433     emit CancelOracleRequest(_requestId);
434 
435     assert(LinkToken.transfer(msg.sender, _payment));
436   }
437 
438   // MODIFIERS
439 
440   /**
441    * @dev Reverts if amount requested is greater than withdrawable balance
442    * @param _amount The given amount to compare to `withdrawableTokens`
443    */
444   modifier hasAvailableFunds(uint256 _amount) {
445     require(withdrawableTokens >= _amount.add(ONE_FOR_CONSISTENT_GAS_COST), "Amount requested is greater than withdrawable balance");
446     _;
447   }
448 
449   /**
450    * @dev Reverts if request ID does not exist
451    * @param _requestId The given request ID to check in stored `commitments`
452    */
453   modifier isValidRequest(bytes32 _requestId) {
454     require(commitments[_requestId] != 0, "Must have a valid requestId");
455     _;
456   }
457 
458   /**
459    * @dev Reverts if `msg.sender` is not authorized to fulfill requests
460    */
461   modifier onlyAuthorizedNode() {
462     require(authorizedNodes[msg.sender] || msg.sender == owner, "Not an authorized node to fulfill requests");
463     _;
464   }
465 
466   /**
467    * @dev Reverts if not sent from the LINK token
468    */
469   modifier onlyLINK() {
470     require(msg.sender == address(LinkToken), "Must use LINK token");
471     _;
472   }
473 
474   /**
475    * @dev Reverts if the given data does not begin with the `oracleRequest` function selector
476    * @param _data The data payload of the request
477    */
478   modifier permittedFunctionsForLINK(bytes _data) {
479     bytes4 funcSelector;
480     assembly { // solhint-disable-line no-inline-assembly
481       funcSelector := mload(add(_data, 32))
482     }
483     require(funcSelector == this.oracleRequest.selector, "Must use whitelisted functions");
484     _;
485   }
486 
487   /**
488    * @dev Reverts if the callback address is the LINK token
489    * @param _to The callback address
490    */
491   modifier checkCallbackAddress(address _to) {
492     require(_to != address(LinkToken), "Cannot callback to LINK");
493     _;
494   }
495 
496   /**
497    * @dev Reverts if the given payload is less than needed to create a request
498    * @param _data The request payload
499    */
500   modifier validRequestLength(bytes _data) {
501     require(_data.length >= MINIMUM_REQUEST_LENGTH, "Invalid request length");
502     _;
503   }
504 
505 }
506 
507 // File: browser/gists/03a079b9055f42d993d0066d6f454c6f/Oracle.sol
508 
509 pragma solidity 0.4.24;