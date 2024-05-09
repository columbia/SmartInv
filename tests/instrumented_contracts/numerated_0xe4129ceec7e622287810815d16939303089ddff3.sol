1 pragma solidity 0.4.24;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9   address public owner;
10 
11 
12   event OwnershipRenounced(address indexed previousOwner);
13   event OwnershipTransferred(
14     address indexed previousOwner,
15     address indexed newOwner
16   );
17 
18 
19   /**
20    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
21    * account.
22    */
23   constructor() public {
24     owner = msg.sender;
25   }
26 
27   /**
28    * @dev Throws if called by any account other than the owner.
29    */
30   modifier onlyOwner() {
31     require(msg.sender == owner);
32     _;
33   }
34 
35   /**
36    * @dev Allows the current owner to relinquish control of the contract.
37    * @notice Renouncing to ownership will leave the contract without an owner.
38    * It will not be possible to call the functions with the `onlyOwner`
39    * modifier anymore.
40    */
41   function renounceOwnership() public onlyOwner {
42     emit OwnershipRenounced(owner);
43     owner = address(0);
44   }
45 
46   /**
47    * @dev Allows the current owner to transfer control of the contract to a newOwner.
48    * @param _newOwner The address to transfer ownership to.
49    */
50   function transferOwnership(address _newOwner) public onlyOwner {
51     _transferOwnership(_newOwner);
52   }
53 
54   /**
55    * @dev Transfers control of the contract to a newOwner.
56    * @param _newOwner The address to transfer ownership to.
57    */
58   function _transferOwnership(address _newOwner) internal {
59     require(_newOwner != address(0));
60     emit OwnershipTransferred(owner, _newOwner);
61     owner = _newOwner;
62   }
63 }
64 
65 /**
66  * @title SafeMath
67  * @dev Math operations with safety checks that throw on error
68  */
69 library SafeMath {
70 
71   /**
72   * @dev Multiplies two numbers, throws on overflow.
73   */
74   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
75     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
76     // benefit is lost if 'b' is also tested.
77     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
78     if (_a == 0) {
79       return 0;
80     }
81 
82     c = _a * _b;
83     assert(c / _a == _b);
84     return c;
85   }
86 
87   /**
88   * @dev Integer division of two numbers, truncating the quotient.
89   */
90   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
91     // assert(_b > 0); // Solidity automatically throws when dividing by 0
92     // uint256 c = _a / _b;
93     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
94     return _a / _b;
95   }
96 
97   /**
98   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
99   */
100   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
101     assert(_b <= _a);
102     return _a - _b;
103   }
104 
105   /**
106   * @dev Adds two numbers, throws on overflow.
107   */
108   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
109     c = _a + _b;
110     assert(c >= _a);
111     return c;
112   }
113 }
114 
115 interface ChainlinkRequestInterface {
116   function oracleRequest(
117     address sender,
118     uint256 payment,
119     bytes32 id,
120     address callbackAddress,
121     bytes4 callbackFunctionId,
122     uint256 nonce,
123     uint256 version,
124     bytes data
125   ) external;
126 
127   function cancelOracleRequest(
128     bytes32 requestId,
129     uint256 payment,
130     bytes4 callbackFunctionId,
131     uint256 expiration
132   ) external;
133 }
134 
135 interface OracleInterface {
136   function fulfillOracleRequest(
137     bytes32 requestId,
138     uint256 payment,
139     address callbackAddress,
140     bytes4 callbackFunctionId,
141     uint256 expiration,
142     bytes32 data
143   ) external returns (bool);
144   function getAuthorizationStatus(address node) external view returns (bool);
145   function setFulfillmentPermission(address node, bool allowed) external;
146   function withdraw(address recipient, uint256 amount) external;
147   function withdrawable() external view returns (uint256);
148 }
149 
150 interface LinkTokenInterface {
151   function allowance(address owner, address spender) external returns (uint256 remaining);
152   function approve(address spender, uint256 value) external returns (bool success);
153   function balanceOf(address owner) external returns (uint256 balance);
154   function decimals() external returns (uint8 decimalPlaces);
155   function decreaseApproval(address spender, uint256 addedValue) external returns (bool success);
156   function increaseApproval(address spender, uint256 subtractedValue) external;
157   function name() external returns (string tokenName);
158   function symbol() external returns (string tokenSymbol);
159   function totalSupply() external returns (uint256 totalTokensIssued);
160   function transfer(address to, uint256 value) external returns (bool success);
161   function transferAndCall(address to, uint256 value, bytes data) external returns (bool success);
162   function transferFrom(address from, address to, uint256 value) external returns (bool success);
163 }
164 
165 /**
166  * @title The Chainlink Oracle contract
167  * @notice Node operators can deploy this contract to fulfill requests sent to them
168  */
169 contract Oracle is ChainlinkRequestInterface, OracleInterface, Ownable {
170   using SafeMath for uint256;
171 
172   uint256 constant public EXPIRY_TIME = 5 minutes;
173   uint256 constant private MINIMUM_CONSUMER_GAS_LIMIT = 400000;
174   // We initialize fields to 1 instead of 0 so that the first invocation
175   // does not cost more gas.
176   uint256 constant private ONE_FOR_CONSISTENT_GAS_COST = 1;
177   uint256 constant private SELECTOR_LENGTH = 4;
178   uint256 constant private EXPECTED_REQUEST_WORDS = 2;
179   uint256 constant private MINIMUM_REQUEST_LENGTH = SELECTOR_LENGTH + (32 * EXPECTED_REQUEST_WORDS);
180 
181   LinkTokenInterface internal LinkToken;
182   mapping(bytes32 => bytes32) private commitments;
183   mapping(address => bool) private authorizedNodes;
184   uint256 private withdrawableTokens = ONE_FOR_CONSISTENT_GAS_COST;
185 
186   event OracleRequest(
187     bytes32 indexed specId,
188     address requester,
189     bytes32 requestId,
190     uint256 payment,
191     address callbackAddr,
192     bytes4 callbackFunctionId,
193     uint256 cancelExpiration,
194     uint256 dataVersion,
195     bytes data
196   );
197 
198   event CancelOracleRequest(
199     bytes32 indexed requestId
200   );
201 
202   /**
203    * @notice Deploy with the address of the LINK token
204    * @dev Sets the LinkToken address for the imported LinkTokenInterface
205    * @param _link The address of the LINK token
206    */
207   constructor(address _link) public Ownable() {
208     LinkToken = LinkTokenInterface(_link); // external but already deployed and unalterable
209   }
210 
211   /**
212    * @notice Called when LINK is sent to the contract via `transferAndCall`
213    * @dev The data payload's first 2 words will be overwritten by the `_sender` and `_amount`
214    * values to ensure correctness. Calls oracleRequest.
215    * @param _sender Address of the sender
216    * @param _amount Amount of LINK sent (specified in wei)
217    * @param _data Payload of the transaction
218    */
219   function onTokenTransfer(
220     address _sender,
221     uint256 _amount,
222     bytes _data
223   )
224     public
225     onlyLINK
226     validRequestLength(_data)
227     permittedFunctionsForLINK(_data)
228   {
229     assembly { // solhint-disable-line no-inline-assembly
230       mstore(add(_data, 36), _sender) // ensure correct sender is passed
231       mstore(add(_data, 68), _amount) // ensure correct amount is passed
232     }
233     // solhint-disable-next-line avoid-low-level-calls
234     require(address(this).delegatecall(_data), "Unable to create request"); // calls oracleRequest
235   }
236 
237   /**
238    * @notice Creates the Chainlink request
239    * @dev Stores the hash of the params as the on-chain commitment for the request.
240    * Emits OracleRequest event for the Chainlink node to detect.
241    * @param _sender The sender of the request
242    * @param _payment The amount of payment given (specified in wei)
243    * @param _specId The Job Specification ID
244    * @param _callbackAddress The callback address for the response
245    * @param _callbackFunctionId The callback function ID for the response
246    * @param _nonce The nonce sent by the requester
247    * @param _dataVersion The specified data version
248    * @param _data The CBOR payload of the request
249    */
250   function oracleRequest(
251     address _sender,
252     uint256 _payment,
253     bytes32 _specId,
254     address _callbackAddress,
255     bytes4 _callbackFunctionId,
256     uint256 _nonce,
257     uint256 _dataVersion,
258     bytes _data
259   )
260     external
261     onlyLINK
262     checkCallbackAddress(_callbackAddress)
263   {
264     bytes32 requestId = keccak256(abi.encodePacked(_sender, _nonce));
265     require(commitments[requestId] == 0, "Must use a unique ID");
266     // solhint-disable-next-line not-rely-on-time
267     uint256 expiration = now.add(EXPIRY_TIME);
268 
269     commitments[requestId] = keccak256(
270       abi.encodePacked(
271         _payment,
272         _callbackAddress,
273         _callbackFunctionId,
274         expiration
275       )
276     );
277 
278     emit OracleRequest(
279       _specId,
280       _sender,
281       requestId,
282       _payment,
283       _callbackAddress,
284       _callbackFunctionId,
285       expiration,
286       _dataVersion,
287       _data);
288   }
289 
290   /**
291    * @notice Called by the Chainlink node to fulfill requests
292    * @dev Given params must hash back to the commitment stored from `oracleRequest`.
293    * Will call the callback address' callback function without bubbling up error
294    * checking in a `require` so that the node can get paid.
295    * @param _requestId The fulfillment request ID that must match the requester's
296    * @param _payment The payment amount that will be released for the oracle (specified in wei)
297    * @param _callbackAddress The callback address to call for fulfillment
298    * @param _callbackFunctionId The callback function ID to use for fulfillment
299    * @param _expiration The expiration that the node should respond by before the requester can cancel
300    * @param _data The data to return to the consuming contract
301    * @return Status if the external call was successful
302    */
303   function fulfillOracleRequest(
304     bytes32 _requestId,
305     uint256 _payment,
306     address _callbackAddress,
307     bytes4 _callbackFunctionId,
308     uint256 _expiration,
309     bytes32 _data
310   )
311     external
312     onlyAuthorizedNode
313     isValidRequest(_requestId)
314     returns (bool)
315   {
316     bytes32 paramsHash = keccak256(
317       abi.encodePacked(
318         _payment,
319         _callbackAddress,
320         _callbackFunctionId,
321         _expiration
322       )
323     );
324     require(commitments[_requestId] == paramsHash, "Params do not match request ID");
325     withdrawableTokens = withdrawableTokens.add(_payment);
326     delete commitments[_requestId];
327     require(gasleft() >= MINIMUM_CONSUMER_GAS_LIMIT, "Must provide consumer enough gas");
328     // All updates to the oracle's fulfillment should come before calling the
329     // callback(addr+functionId) as it is untrusted.
330     // See: https://solidity.readthedocs.io/en/develop/security-considerations.html#use-the-checks-effects-interactions-pattern
331     return _callbackAddress.call(_callbackFunctionId, _requestId, _data); // solhint-disable-line avoid-low-level-calls
332   }
333 
334   /**
335    * @notice Use this to check if a node is authorized for fulfilling requests
336    * @param _node The address of the Chainlink node
337    * @return The authorization status of the node
338    */
339   function getAuthorizationStatus(address _node) external view returns (bool) {
340     return authorizedNodes[_node];
341   }
342 
343   /**
344    * @notice Sets the fulfillment permission for a given node. Use `true` to allow, `false` to disallow.
345    * @param _node The address of the Chainlink node
346    * @param _allowed Bool value to determine if the node can fulfill requests
347    */
348   function setFulfillmentPermission(address _node, bool _allowed) external onlyOwner {
349     authorizedNodes[_node] = _allowed;
350   }
351 
352   /**
353    * @notice Allows the node operator to withdraw earned LINK to a given address
354    * @dev The owner of the contract can be another wallet and does not have to be a Chainlink node
355    * @param _recipient The address to send the LINK token to
356    * @param _amount The amount to send (specified in wei)
357    */
358   function withdraw(address _recipient, uint256 _amount)
359     external
360     onlyOwner
361     hasAvailableFunds(_amount)
362   {
363     withdrawableTokens = withdrawableTokens.sub(_amount);
364     assert(LinkToken.transfer(_recipient, _amount));
365   }
366 
367   /**
368    * @notice Displays the amount of LINK that is available for the node operator to withdraw
369    * @dev We use `ONE_FOR_CONSISTENT_GAS_COST` in place of 0 in storage
370    * @return The amount of withdrawable LINK on the contract
371    */
372   function withdrawable() external view onlyOwner returns (uint256) {
373     return withdrawableTokens.sub(ONE_FOR_CONSISTENT_GAS_COST);
374   }
375 
376   /**
377    * @notice Allows requesters to cancel requests sent to this oracle contract. Will transfer the LINK
378    * sent for the request back to the requester's address.
379    * @dev Given params must hash to a commitment stored on the contract in order for the request to be valid
380    * Emits CancelOracleRequest event.
381    * @param _requestId The request ID
382    * @param _payment The amount of payment given (specified in wei)
383    * @param _callbackFunc The requester's specified callback address
384    * @param _expiration The time of the expiration for the request
385    */
386   function cancelOracleRequest(
387     bytes32 _requestId,
388     uint256 _payment,
389     bytes4 _callbackFunc,
390     uint256 _expiration
391   ) external {
392     bytes32 paramsHash = keccak256(
393       abi.encodePacked(
394         _payment,
395         msg.sender,
396         _callbackFunc,
397         _expiration)
398     );
399     require(paramsHash == commitments[_requestId], "Params do not match request ID");
400     // solhint-disable-next-line not-rely-on-time
401     require(_expiration <= now, "Request is not expired");
402 
403     delete commitments[_requestId];
404     emit CancelOracleRequest(_requestId);
405 
406     assert(LinkToken.transfer(msg.sender, _payment));
407   }
408 
409   // MODIFIERS
410 
411   /**
412    * @dev Reverts if amount requested is greater than withdrawable balance
413    * @param _amount The given amount to compare to `withdrawableTokens`
414    */
415   modifier hasAvailableFunds(uint256 _amount) {
416     require(withdrawableTokens >= _amount.add(ONE_FOR_CONSISTENT_GAS_COST), "Amount requested is greater than withdrawable balance");
417     _;
418   }
419 
420   /**
421    * @dev Reverts if request ID does not exist
422    * @param _requestId The given request ID to check in stored `commitments`
423    */
424   modifier isValidRequest(bytes32 _requestId) {
425     require(commitments[_requestId] != 0, "Must have a valid requestId");
426     _;
427   }
428 
429   /**
430    * @dev Reverts if `msg.sender` is not authorized to fulfill requests
431    */
432   modifier onlyAuthorizedNode() {
433     require(authorizedNodes[msg.sender] || msg.sender == owner, "Not an authorized node to fulfill requests");
434     _;
435   }
436 
437   /**
438    * @dev Reverts if not sent from the LINK token
439    */
440   modifier onlyLINK() {
441     require(msg.sender == address(LinkToken), "Must use LINK token");
442     _;
443   }
444 
445   /**
446    * @dev Reverts if the given data does not begin with the `oracleRequest` function selector
447    * @param _data The data payload of the request
448    */
449   modifier permittedFunctionsForLINK(bytes _data) {
450     bytes4 funcSelector;
451     assembly { // solhint-disable-line no-inline-assembly
452       funcSelector := mload(add(_data, 32))
453     }
454     require(funcSelector == this.oracleRequest.selector, "Must use whitelisted functions");
455     _;
456   }
457 
458   /**
459    * @dev Reverts if the callback address is the LINK token
460    * @param _to The callback address
461    */
462   modifier checkCallbackAddress(address _to) {
463     require(_to != address(LinkToken), "Cannot callback to LINK");
464     _;
465   }
466 
467   /**
468    * @dev Reverts if the given payload is less than needed to create a request
469    * @param _data The request payload
470    */
471   modifier validRequestLength(bytes _data) {
472     require(_data.length >= MINIMUM_REQUEST_LENGTH, "Invalid request length");
473     _;
474   }
475 
476 }