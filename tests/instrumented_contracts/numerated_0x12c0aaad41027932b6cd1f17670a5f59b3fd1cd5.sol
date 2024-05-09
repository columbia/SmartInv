1 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
2 pragma solidity ^0.4.24;
3 
4 
5 /**
6  * @title Ownable
7  * @dev The Ownable contract has an owner address, and provides basic authorization control
8  * functions, this simplifies the implementation of "user permissions".
9  */
10 contract Ownable {
11   address public owner;
12 
13 
14   event OwnershipRenounced(address indexed previousOwner);
15   event OwnershipTransferred(
16     address indexed previousOwner,
17     address indexed newOwner
18   );
19 
20 
21   /**
22    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
23    * account.
24    */
25   constructor() public {
26     owner = msg.sender;
27   }
28 
29   /**
30    * @dev Throws if called by any account other than the owner.
31    */
32   modifier onlyOwner() {
33     require(msg.sender == owner);
34     _;
35   }
36 
37   /**
38    * @dev Allows the current owner to relinquish control of the contract.
39    * @notice Renouncing to ownership will leave the contract without an owner.
40    * It will not be possible to call the functions with the `onlyOwner`
41    * modifier anymore.
42    */
43   function renounceOwnership() public onlyOwner {
44     emit OwnershipRenounced(owner);
45     owner = address(0);
46   }
47 
48   /**
49    * @dev Allows the current owner to transfer control of the contract to a newOwner.
50    * @param _newOwner The address to transfer ownership to.
51    */
52   function transferOwnership(address _newOwner) public onlyOwner {
53     _transferOwnership(_newOwner);
54   }
55 
56   /**
57    * @dev Transfers control of the contract to a newOwner.
58    * @param _newOwner The address to transfer ownership to.
59    */
60   function _transferOwnership(address _newOwner) internal {
61     require(_newOwner != address(0));
62     emit OwnershipTransferred(owner, _newOwner);
63     owner = _newOwner;
64   }
65 }
66 
67 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
68 
69 pragma solidity ^0.4.24;
70 
71 
72 /**
73  * @title SafeMath
74  * @dev Math operations with safety checks that throw on error
75  */
76 library SafeMath {
77 
78   /**
79   * @dev Multiplies two numbers, throws on overflow.
80   */
81   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
82     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
83     // benefit is lost if 'b' is also tested.
84     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
85     if (_a == 0) {
86       return 0;
87     }
88 
89     c = _a * _b;
90     assert(c / _a == _b);
91     return c;
92   }
93 
94   /**
95   * @dev Integer division of two numbers, truncating the quotient.
96   */
97   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
98     // assert(_b > 0); // Solidity automatically throws when dividing by 0
99     // uint256 c = _a / _b;
100     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
101     return _a / _b;
102   }
103 
104   /**
105   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
106   */
107   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
108     assert(_b <= _a);
109     return _a - _b;
110   }
111 
112   /**
113   * @dev Adds two numbers, throws on overflow.
114   */
115   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
116     c = _a + _b;
117     assert(c >= _a);
118     return c;
119   }
120 }
121 
122 // File: contracts/interfaces/ChainlinkRequestInterface.sol
123 
124 pragma solidity 0.4.24;
125 
126 interface ChainlinkRequestInterface {
127   function oracleRequest(
128     address sender,
129     uint256 payment,
130     bytes32 id,
131     address callbackAddress,
132     bytes4 callbackFunctionId,
133     uint256 nonce,
134     uint256 version,
135     bytes data
136   ) external;
137 
138   function cancelOracleRequest(
139     bytes32 requestId,
140     uint256 payment,
141     bytes4 callbackFunctionId,
142     uint256 expiration
143   ) external;
144 }
145 
146 // File: contracts/interfaces/OracleInterface.sol
147 
148 pragma solidity 0.4.24;
149 
150 interface OracleInterface {
151   function fulfillOracleRequest(
152     bytes32 requestId,
153     uint256 payment,
154     address callbackAddress,
155     bytes4 callbackFunctionId,
156     uint256 expiration,
157     bytes32 data
158   ) external returns (bool);
159   function getAuthorizationStatus(address node) external view returns (bool);
160   function setFulfillmentPermission(address node, bool allowed) external;
161   function withdraw(address recipient, uint256 amount) external;
162   function withdrawable() external view returns (uint256);
163 }
164 
165 // File: contracts/interfaces/LinkTokenInterface.sol
166 
167 pragma solidity 0.4.24;
168 
169 interface LinkTokenInterface {
170   function allowance(address owner, address spender) external returns (bool success);
171   function approve(address spender, uint256 value) external returns (bool success);
172   function balanceOf(address owner) external returns (uint256 balance);
173   function decimals() external returns (uint8 decimalPlaces);
174   function decreaseApproval(address spender, uint256 addedValue) external returns (bool success);
175   function increaseApproval(address spender, uint256 subtractedValue) external;
176   function name() external returns (string tokenName);
177   function symbol() external returns (string tokenSymbol);
178   function totalSupply() external returns (uint256 totalTokensIssued);
179   function transfer(address to, uint256 value) external returns (bool success);
180   function transferAndCall(address to, uint256 value, bytes data) external returns (bool success);
181   function transferFrom(address from, address to, uint256 value) external returns (bool success);
182 }
183 
184 // File: contracts/Oracle.sol
185 
186 pragma solidity 0.4.24;
187 
188 
189 
190 
191 
192 
193 /**
194  * @title The Chainlink Oracle contract
195  * @notice Node operators can deploy this contract to fulfill requests sent to them
196  */
197 contract Oracle is ChainlinkRequestInterface, OracleInterface, Ownable {
198   using SafeMath for uint256;
199 
200   uint256 constant public EXPIRY_TIME = 5 minutes;
201   uint256 constant private MINIMUM_CONSUMER_GAS_LIMIT = 400000;
202   // We initialize fields to 1 instead of 0 so that the first invocation
203   // does not cost more gas.
204   uint256 constant private ONE_FOR_CONSISTENT_GAS_COST = 1;
205   uint256 constant private SELECTOR_LENGTH = 4;
206   uint256 constant private EXPECTED_REQUEST_WORDS = 2;
207   // solium-disable-next-line zeppelin/no-arithmetic-operations
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
236   constructor(address _link) Ownable() public {
237     LinkToken = LinkTokenInterface(_link);
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
258     assembly {
259       // solium-disable-next-line security/no-low-level-calls
260       mstore(add(_data, 36), _sender) // ensure correct sender is passed
261       // solium-disable-next-line security/no-low-level-calls
262       mstore(add(_data, 68), _amount)    // ensure correct amount is passed
263     }
264     // solium-disable-next-line security/no-low-level-calls
265     require(address(this).delegatecall(_data), "Unable to create request"); // calls oracleRequest
266   }
267 
268   /**
269    * @notice Creates the Chainlink request
270    * @dev Stores the hash of the params as the on-chain commitment for the request.
271    * Emits OracleRequest event for the Chainlink node to detect.
272    * @param _sender The sender of the request
273    * @param _payment The amount of payment given (specified in wei)
274    * @param _specId The Job Specification ID
275    * @param _callbackAddress The callback address for the response
276    * @param _callbackFunctionId The callback function ID for the response
277    * @param _nonce The nonce sent by the requester
278    * @param _dataVersion The specified data version
279    * @param _data The CBOR payload of the request
280    */
281   function oracleRequest(
282     address _sender,
283     uint256 _payment,
284     bytes32 _specId,
285     address _callbackAddress,
286     bytes4 _callbackFunctionId,
287     uint256 _nonce,
288     uint256 _dataVersion,
289     bytes _data
290   )
291     external
292     onlyLINK
293     checkCallbackAddress(_callbackAddress)
294   {
295     bytes32 requestId = keccak256(abi.encodePacked(_sender, _nonce));
296     require(commitments[requestId] == 0, "Must use a unique ID");
297     uint256 expiration = now.add(EXPIRY_TIME);
298 
299     commitments[requestId] = keccak256(
300       abi.encodePacked(
301         _payment,
302         _callbackAddress,
303         _callbackFunctionId,
304         expiration
305       )
306     );
307 
308     emit OracleRequest(
309       _specId,
310       _sender,
311       requestId,
312       _payment,
313       _callbackAddress,
314       _callbackFunctionId,
315       expiration,
316       _dataVersion,
317       _data);
318   }
319 
320   /**
321    * @notice Called by the Chainlink node to fulfill requests
322    * @dev Given params must hash back to the commitment stored from `oracleRequest`.
323    * Will call the callback address' callback function without bubbling up error
324    * checking in a `require` so that the node can get paid.
325    * @param _requestId The fulfillment request ID that must match the requester's
326    * @param _payment The payment amount that will be released for the oracle (specified in wei)
327    * @param _callbackAddress The callback address to call for fulfillment
328    * @param _callbackFunctionId The callback function ID to use for fulfillment
329    * @param _expiration The expiration that the node should respond by before the requester can cancel
330    * @param _data The data to return to the consuming contract
331    * @return Status if the external call was successful
332    */
333   function fulfillOracleRequest(
334     bytes32 _requestId,
335     uint256 _payment,
336     address _callbackAddress,
337     bytes4 _callbackFunctionId,
338     uint256 _expiration,
339     bytes32 _data
340   )
341     external
342     onlyAuthorizedNode
343     isValidRequest(_requestId)
344     returns (bool)
345   {
346     bytes32 paramsHash = keccak256(
347       abi.encodePacked(
348         _payment,
349         _callbackAddress,
350         _callbackFunctionId,
351         _expiration
352       )
353     );
354     require(commitments[_requestId] == paramsHash, "Params do not match request ID");
355     withdrawableTokens = withdrawableTokens.add(_payment);
356     delete commitments[_requestId];
357     require(gasleft() >= MINIMUM_CONSUMER_GAS_LIMIT, "Must provide consumer enough gas");
358     // All updates to the oracle's fulfillment should come before calling the
359     // callback(addr+functionId) as it is untrusted.
360     // See: https://solidity.readthedocs.io/en/develop/security-considerations.html#use-the-checks-effects-interactions-pattern
361     return _callbackAddress.call(_callbackFunctionId, _requestId, _data); // solium-disable-line security/no-low-level-calls
362   }
363 
364   /**
365    * @notice Use this to check if a node is authorized for fulfilling requests
366    * @param _node The address of the Chainlink node
367    * @return The authorization status of the node
368    */
369   function getAuthorizationStatus(address _node) external view returns (bool) {
370     return authorizedNodes[_node];
371   }
372 
373   /**
374    * @notice Sets the fulfillment permission for a given node. Use `true` to allow, `false` to disallow.
375    * @param _node The address of the Chainlink node
376    * @param _allowed Bool value to determine if the node can fulfill requests
377    */
378   function setFulfillmentPermission(address _node, bool _allowed) external onlyOwner {
379     authorizedNodes[_node] = _allowed;
380   }
381 
382   /**
383    * @notice Allows the node operator to withdraw earned LINK to a given address
384    * @dev The owner of the contract can be another wallet and does not have to be a Chainlink node
385    * @param _recipient The address to send the LINK token to
386    * @param _amount The amount to send (specified in wei)
387    */
388   function withdraw(address _recipient, uint256 _amount)
389     external
390     onlyOwner
391     hasAvailableFunds(_amount)
392   {
393     withdrawableTokens = withdrawableTokens.sub(_amount);
394     assert(LinkToken.transfer(_recipient, _amount));
395   }
396 
397   /**
398    * @notice Displays the amount of LINK that is available for the node operator to withdraw
399    * @dev We use `ONE_FOR_CONSISTENT_GAS_COST` in place of 0 in storage
400    * @return The amount of withdrawable LINK on the contract
401    */
402   function withdrawable() external view onlyOwner returns (uint256) {
403     return withdrawableTokens.sub(ONE_FOR_CONSISTENT_GAS_COST);
404   }
405 
406   /**
407    * @notice Allows requesters to cancel requests sent to this oracle contract. Will transfer the LINK
408    * sent for the request back to the requester's address.
409    * @dev Given params must hash to a commitment stored on the contract in order for the request to be valid
410    * Emits CancelOracleRequest event.
411    * @param _requestId The request ID
412    * @param _payment The amount of payment given (specified in wei)
413    * @param _callbackFunc The requester's specified callback address
414    * @param _expiration The time of the expiration for the request
415    */
416   function cancelOracleRequest(
417     bytes32 _requestId,
418     uint256 _payment,
419     bytes4 _callbackFunc,
420     uint256 _expiration
421   ) external {
422     bytes32 paramsHash = keccak256(
423       abi.encodePacked(
424         _payment,
425         msg.sender,
426         _callbackFunc,
427         _expiration)
428     );
429     require(paramsHash == commitments[_requestId], "Params do not match request ID");
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
480     assembly {
481       // solium-disable-next-line security/no-low-level-calls
482       funcSelector := mload(add(_data, 32))
483     }
484     require(funcSelector == this.oracleRequest.selector, "Must use whitelisted functions");
485     _;
486   }
487 
488   /**
489    * @dev Reverts if the callback address is the LINK token
490    * @param _to The callback address
491    */
492   modifier checkCallbackAddress(address _to) {
493     require(_to != address(LinkToken), "Cannot callback to LINK");
494     _;
495   }
496 
497   /**
498    * @dev Reverts if the given payload is less than needed to create a request
499    * @param _data The request payload
500    */
501   modifier validRequestLength(bytes _data) {
502     require(_data.length >= MINIMUM_REQUEST_LENGTH, "Invalid request length");
503     _;
504   }
505 
506 }