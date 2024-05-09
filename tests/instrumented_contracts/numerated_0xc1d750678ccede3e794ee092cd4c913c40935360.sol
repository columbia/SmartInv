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
65 
66 /**
67  * @title SafeMath
68  * @dev Math operations with safety checks that throw on error
69  */
70 library SafeMath {
71 
72   /**
73   * @dev Multiplies two numbers, throws on overflow.
74   */
75   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
76     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
77     // benefit is lost if 'b' is also tested.
78     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
79     if (_a == 0) {
80       return 0;
81     }
82 
83     c = _a * _b;
84     assert(c / _a == _b);
85     return c;
86   }
87 
88   /**
89   * @dev Integer division of two numbers, truncating the quotient.
90   */
91   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
92     // assert(_b > 0); // Solidity automatically throws when dividing by 0
93     // uint256 c = _a / _b;
94     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
95     return _a / _b;
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
116 
117 interface ChainlinkRequestInterface {
118   function oracleRequest(
119     address sender,
120     uint256 payment,
121     bytes32 id,
122     address callbackAddress,
123     bytes4 callbackFunctionId,
124     uint256 nonce,
125     uint256 version,
126     bytes data
127   ) external;
128 
129   function cancelOracleRequest(
130     bytes32 requestId,
131     uint256 payment,
132     bytes4 callbackFunctionId,
133     uint256 expiration
134   ) external;
135 }
136 
137 interface OracleInterface {
138   function fulfillOracleRequest(
139     bytes32 requestId,
140     uint256 payment,
141     address callbackAddress,
142     bytes4 callbackFunctionId,
143     uint256 expiration,
144     bytes32 data
145   ) external returns (bool);
146   function getAuthorizationStatus(address node) external view returns (bool);
147   function setFulfillmentPermission(address node, bool allowed) external;
148   function withdraw(address recipient, uint256 amount) external;
149   function withdrawable() external view returns (uint256);
150 }
151 
152 interface LinkTokenInterface {
153   function allowance(address owner, address spender) external view returns (uint256 remaining);
154   function approve(address spender, uint256 value) external returns (bool success);
155   function balanceOf(address owner) external view returns (uint256 balance);
156   function decimals() external view returns (uint8 decimalPlaces);
157   function decreaseApproval(address spender, uint256 addedValue) external returns (bool success);
158   function increaseApproval(address spender, uint256 subtractedValue) external;
159   function name() external view returns (string tokenName);
160   function symbol() external view returns (string tokenSymbol);
161   function totalSupply() external view returns (uint256 totalTokensIssued);
162   function transfer(address to, uint256 value) external returns (bool success);
163   function transferAndCall(address to, uint256 value, bytes data) external returns (bool success);
164   function transferFrom(address from, address to, uint256 value) external returns (bool success);
165 }
166 
167 
168 /**
169  * @title The Chainlink Oracle contract
170  * @notice Node operators can deploy this contract to fulfill requests sent to them
171  */
172 contract Oracle is ChainlinkRequestInterface, OracleInterface, Ownable {
173   using SafeMath for uint256;
174 
175   uint256 constant public EXPIRY_TIME = 5 minutes;
176   uint256 constant private MINIMUM_CONSUMER_GAS_LIMIT = 400000;
177   // We initialize fields to 1 instead of 0 so that the first invocation
178   // does not cost more gas.
179   uint256 constant private ONE_FOR_CONSISTENT_GAS_COST = 1;
180   uint256 constant private SELECTOR_LENGTH = 4;
181   uint256 constant private EXPECTED_REQUEST_WORDS = 2;
182   uint256 constant private MINIMUM_REQUEST_LENGTH = SELECTOR_LENGTH + (32 * EXPECTED_REQUEST_WORDS);
183 
184   LinkTokenInterface internal LinkToken;
185   mapping(bytes32 => bytes32) private commitments;
186   mapping(address => bool) private authorizedNodes;
187   uint256 private withdrawableTokens = ONE_FOR_CONSISTENT_GAS_COST;
188 
189   event OracleRequest(
190     bytes32 indexed specId,
191     address requester,
192     bytes32 requestId,
193     uint256 payment,
194     address callbackAddr,
195     bytes4 callbackFunctionId,
196     uint256 cancelExpiration,
197     uint256 dataVersion,
198     bytes data
199   );
200 
201   event CancelOracleRequest(
202     bytes32 indexed requestId
203   );
204 
205   /**
206    * @notice Deploy with the address of the LINK token
207    * @dev Sets the LinkToken address for the imported LinkTokenInterface
208    * @param _link The address of the LINK token
209    */
210   constructor(address _link) public Ownable() {
211     LinkToken = LinkTokenInterface(_link); // external but already deployed and unalterable
212   }
213 
214   /**
215    * @notice Called when LINK is sent to the contract via `transferAndCall`
216    * @dev The data payload's first 2 words will be overwritten by the `_sender` and `_amount`
217    * values to ensure correctness. Calls oracleRequest.
218    * @param _sender Address of the sender
219    * @param _amount Amount of LINK sent (specified in wei)
220    * @param _data Payload of the transaction
221    */
222   function onTokenTransfer(
223     address _sender,
224     uint256 _amount,
225     bytes _data
226   )
227     public
228     onlyLINK
229     validRequestLength(_data)
230     permittedFunctionsForLINK(_data)
231   {
232     assembly { // solhint-disable-line no-inline-assembly
233       mstore(add(_data, 36), _sender) // ensure correct sender is passed
234       mstore(add(_data, 68), _amount) // ensure correct amount is passed
235     }
236     // solhint-disable-next-line avoid-low-level-calls
237     require(address(this).delegatecall(_data), "Unable to create request"); // calls oracleRequest
238   }
239 
240   /**
241    * @notice Creates the Chainlink request
242    * @dev Stores the hash of the params as the on-chain commitment for the request.
243    * Emits OracleRequest event for the Chainlink node to detect.
244    * @param _sender The sender of the request
245    * @param _payment The amount of payment given (specified in wei)
246    * @param _specId The Job Specification ID
247    * @param _callbackAddress The callback address for the response
248    * @param _callbackFunctionId The callback function ID for the response
249    * @param _nonce The nonce sent by the requester
250    * @param _dataVersion The specified data version
251    * @param _data The CBOR payload of the request
252    */
253   function oracleRequest(
254     address _sender,
255     uint256 _payment,
256     bytes32 _specId,
257     address _callbackAddress,
258     bytes4 _callbackFunctionId,
259     uint256 _nonce,
260     uint256 _dataVersion,
261     bytes _data
262   )
263     external
264     onlyLINK
265     checkCallbackAddress(_callbackAddress)
266   {
267     bytes32 requestId = keccak256(abi.encodePacked(_sender, _nonce));
268     require(commitments[requestId] == 0, "Must use a unique ID");
269     // solhint-disable-next-line not-rely-on-time
270     uint256 expiration = now.add(EXPIRY_TIME);
271 
272     commitments[requestId] = keccak256(
273       abi.encodePacked(
274         _payment,
275         _callbackAddress,
276         _callbackFunctionId,
277         expiration
278       )
279     );
280 
281     emit OracleRequest(
282       _specId,
283       _sender,
284       requestId,
285       _payment,
286       _callbackAddress,
287       _callbackFunctionId,
288       expiration,
289       _dataVersion,
290       _data);
291   }
292 
293   /**
294    * @notice Called by the Chainlink node to fulfill requests
295    * @dev Given params must hash back to the commitment stored from `oracleRequest`.
296    * Will call the callback address' callback function without bubbling up error
297    * checking in a `require` so that the node can get paid.
298    * @param _requestId The fulfillment request ID that must match the requester's
299    * @param _payment The payment amount that will be released for the oracle (specified in wei)
300    * @param _callbackAddress The callback address to call for fulfillment
301    * @param _callbackFunctionId The callback function ID to use for fulfillment
302    * @param _expiration The expiration that the node should respond by before the requester can cancel
303    * @param _data The data to return to the consuming contract
304    * @return Status if the external call was successful
305    */
306   function fulfillOracleRequest(
307     bytes32 _requestId,
308     uint256 _payment,
309     address _callbackAddress,
310     bytes4 _callbackFunctionId,
311     uint256 _expiration,
312     bytes32 _data
313   )
314     external
315     onlyAuthorizedNode
316     isValidRequest(_requestId)
317     returns (bool)
318   {
319     bytes32 paramsHash = keccak256(
320       abi.encodePacked(
321         _payment,
322         _callbackAddress,
323         _callbackFunctionId,
324         _expiration
325       )
326     );
327     require(commitments[_requestId] == paramsHash, "Params do not match request ID");
328     withdrawableTokens = withdrawableTokens.add(_payment);
329     delete commitments[_requestId];
330     require(gasleft() >= MINIMUM_CONSUMER_GAS_LIMIT, "Must provide consumer enough gas");
331     // All updates to the oracle's fulfillment should come before calling the
332     // callback(addr+functionId) as it is untrusted.
333     // See: https://solidity.readthedocs.io/en/develop/security-considerations.html#use-the-checks-effects-interactions-pattern
334     return _callbackAddress.call(_callbackFunctionId, _requestId, _data); // solhint-disable-line avoid-low-level-calls
335   }
336 
337   /**
338    * @notice Use this to check if a node is authorized for fulfilling requests
339    * @param _node The address of the Chainlink node
340    * @return The authorization status of the node
341    */
342   function getAuthorizationStatus(address _node) external view returns (bool) {
343     return authorizedNodes[_node];
344   }
345 
346   /**
347    * @notice Sets the fulfillment permission for a given node. Use `true` to allow, `false` to disallow.
348    * @param _node The address of the Chainlink node
349    * @param _allowed Bool value to determine if the node can fulfill requests
350    */
351   function setFulfillmentPermission(address _node, bool _allowed) external onlyOwner {
352     authorizedNodes[_node] = _allowed;
353   }
354 
355   /**
356    * @notice Allows the node operator to withdraw earned LINK to a given address
357    * @dev The owner of the contract can be another wallet and does not have to be a Chainlink node
358    * @param _recipient The address to send the LINK token to
359    * @param _amount The amount to send (specified in wei)
360    */
361   function withdraw(address _recipient, uint256 _amount)
362     external
363     onlyOwner
364     hasAvailableFunds(_amount)
365   {
366     withdrawableTokens = withdrawableTokens.sub(_amount);
367     assert(LinkToken.transfer(_recipient, _amount));
368   }
369 
370   /**
371    * @notice Displays the amount of LINK that is available for the node operator to withdraw
372    * @dev We use `ONE_FOR_CONSISTENT_GAS_COST` in place of 0 in storage
373    * @return The amount of withdrawable LINK on the contract
374    */
375   function withdrawable() external view onlyOwner returns (uint256) {
376     return withdrawableTokens.sub(ONE_FOR_CONSISTENT_GAS_COST);
377   }
378 
379   /**
380    * @notice Allows requesters to cancel requests sent to this oracle contract. Will transfer the LINK
381    * sent for the request back to the requester's address.
382    * @dev Given params must hash to a commitment stored on the contract in order for the request to be valid
383    * Emits CancelOracleRequest event.
384    * @param _requestId The request ID
385    * @param _payment The amount of payment given (specified in wei)
386    * @param _callbackFunc The requester's specified callback address
387    * @param _expiration The time of the expiration for the request
388    */
389   function cancelOracleRequest(
390     bytes32 _requestId,
391     uint256 _payment,
392     bytes4 _callbackFunc,
393     uint256 _expiration
394   ) external {
395     bytes32 paramsHash = keccak256(
396       abi.encodePacked(
397         _payment,
398         msg.sender,
399         _callbackFunc,
400         _expiration)
401     );
402     require(paramsHash == commitments[_requestId], "Params do not match request ID");
403     // solhint-disable-next-line not-rely-on-time
404     require(_expiration <= now, "Request is not expired");
405 
406     delete commitments[_requestId];
407     emit CancelOracleRequest(_requestId);
408 
409     assert(LinkToken.transfer(msg.sender, _payment));
410   }
411 
412   // MODIFIERS
413 
414   /**
415    * @dev Reverts if amount requested is greater than withdrawable balance
416    * @param _amount The given amount to compare to `withdrawableTokens`
417    */
418   modifier hasAvailableFunds(uint256 _amount) {
419     require(withdrawableTokens >= _amount.add(ONE_FOR_CONSISTENT_GAS_COST), "Amount requested is greater than withdrawable balance");
420     _;
421   }
422 
423   /**
424    * @dev Reverts if request ID does not exist
425    * @param _requestId The given request ID to check in stored `commitments`
426    */
427   modifier isValidRequest(bytes32 _requestId) {
428     require(commitments[_requestId] != 0, "Must have a valid requestId");
429     _;
430   }
431 
432   /**
433    * @dev Reverts if `msg.sender` is not authorized to fulfill requests
434    */
435   modifier onlyAuthorizedNode() {
436     require(authorizedNodes[msg.sender] || msg.sender == owner, "Not an authorized node to fulfill requests");
437     _;
438   }
439 
440   /**
441    * @dev Reverts if not sent from the LINK token
442    */
443   modifier onlyLINK() {
444     require(msg.sender == address(LinkToken), "Must use LINK token");
445     _;
446   }
447 
448   /**
449    * @dev Reverts if the given data does not begin with the `oracleRequest` function selector
450    * @param _data The data payload of the request
451    */
452   modifier permittedFunctionsForLINK(bytes _data) {
453     bytes4 funcSelector;
454     assembly { // solhint-disable-line no-inline-assembly
455       funcSelector := mload(add(_data, 32))
456     }
457     require(funcSelector == this.oracleRequest.selector, "Must use whitelisted functions");
458     _;
459   }
460 
461   /**
462    * @dev Reverts if the callback address is the LINK token
463    * @param _to The callback address
464    */
465   modifier checkCallbackAddress(address _to) {
466     require(_to != address(LinkToken), "Cannot callback to LINK");
467     _;
468   }
469 
470   /**
471    * @dev Reverts if the given payload is less than needed to create a request
472    * @param _data The request payload
473    */
474   modifier validRequestLength(bytes _data) {
475     require(_data.length >= MINIMUM_REQUEST_LENGTH, "Invalid request length");
476     _;
477   }
478 
479 }