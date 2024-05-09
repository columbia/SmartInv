1 /*                                                                                           
2 *      ___ ___       ___         ___                                                             
3 *      `MM `MMb     dMM'         `MM                                                             
4 *       MM  MMM.   ,PMM           MM                                                             
5 *   ____MM  M`Mb   d'MM    ___    MM   __   ____  ___  __   ____         _____  ___  __   __     
6 *  6MMMMMM  M YM. ,P MM  6MMMMb   MM   d'  6MMMMb `MM 6MM  6MMMMb\      6MMMMMb `MM 6MM  6MMbMMM 
7 * 6M'  `MM  M `Mb d' MM 8M'  `Mb  MM  d'  6M'  `Mb MM69 " MM'    `     6M'   `Mb MM69 " 6M'`Mb   
8 * MM    MM  M  YM.P  MM     ,oMM  MM d'   MM    MM MM'    YM.          MM     MM MM'    MM  MM   
9 * MM    MM  M  `Mb'  MM ,6MM9'MM  MMdM.   MMMMMMMM MM      YMMMMb      MM     MM MM     YM.,M9   
10 * MM    MM  M   YP   MM MM'   MM  MMPYM.  MM       MM          `Mb     MM     MM MM      YMM9    
11 * YM.  ,MM  M   `'   MM MM.  ,MM  MM  YM. YM    d9 MM     L    ,MM 68b YM.   ,M9 MM     (M       
12 *  YMMMMMM__M_      _MM_`YMMM9'Yb_MM_  YM._YMMMM9 _MM_    MYMMMM9  Y89  YMMMMM9 _MM_     YMMMMb. 
13 *                                                                                       6M    Yb 
14 *                                                                                       YM.   d9 
15 *                                                                                        YMMMM9  
16 */
17 
18 pragma solidity 0.4.24;
19 
20 /**
21  * @title Ownable
22  * @dev The Ownable contract has an owner address, and provides basic authorization control
23  * functions, this simplifies the implementation of "user permissions".
24  */
25 contract Ownable {
26   address public owner;
27 
28 
29   event OwnershipRenounced(address indexed previousOwner);
30   event OwnershipTransferred(
31     address indexed previousOwner,
32     address indexed newOwner
33   );
34 
35 
36   /**
37    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
38    * account.
39    */
40   constructor() public {
41     owner = msg.sender;
42   }
43 
44   /**
45    * @dev Throws if called by any account other than the owner.
46    */
47   modifier onlyOwner() {
48     require(msg.sender == owner);
49     _;
50   }
51 
52   /**
53    * @dev Allows the current owner to relinquish control of the contract.
54    * @notice Renouncing to ownership will leave the contract without an owner.
55    * It will not be possible to call the functions with the `onlyOwner`
56    * modifier anymore.
57    */
58   function renounceOwnership() public onlyOwner {
59     emit OwnershipRenounced(owner);
60     owner = address(0);
61   }
62 
63   /**
64    * @dev Allows the current owner to transfer control of the contract to a newOwner.
65    * @param _newOwner The address to transfer ownership to.
66    */
67   function transferOwnership(address _newOwner) public onlyOwner {
68     _transferOwnership(_newOwner);
69   }
70 
71   /**
72    * @dev Transfers control of the contract to a newOwner.
73    * @param _newOwner The address to transfer ownership to.
74    */
75   function _transferOwnership(address _newOwner) internal {
76     require(_newOwner != address(0));
77     emit OwnershipTransferred(owner, _newOwner);
78     owner = _newOwner;
79   }
80 }
81 
82 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
83 
84 pragma solidity ^0.4.24;
85 
86 
87 /**
88  * @title SafeMath
89  * @dev Math operations with safety checks that throw on error
90  */
91 library SafeMath {
92 
93   /**
94   * @dev Multiplies two numbers, throws on overflow.
95   */
96   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
97     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
98     // benefit is lost if 'b' is also tested.
99     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
100     if (_a == 0) {
101       return 0;
102     }
103 
104     c = _a * _b;
105     assert(c / _a == _b);
106     return c;
107   }
108 
109   /**
110   * @dev Integer division of two numbers, truncating the quotient.
111   */
112   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
113     // assert(_b > 0); // Solidity automatically throws when dividing by 0
114     // uint256 c = _a / _b;
115     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
116     return _a / _b;
117   }
118 
119   /**
120   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
121   */
122   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
123     assert(_b <= _a);
124     return _a - _b;
125   }
126 
127   /**
128   * @dev Adds two numbers, throws on overflow.
129   */
130   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
131     c = _a + _b;
132     assert(c >= _a);
133     return c;
134   }
135 }
136 
137 // File: contracts/interfaces/ChainlinkRequestInterface.sol
138 
139 pragma solidity 0.4.24;
140 
141 interface ChainlinkRequestInterface {
142   function oracleRequest(
143     address sender,
144     uint256 payment,
145     bytes32 id,
146     address callbackAddress,
147     bytes4 callbackFunctionId,
148     uint256 nonce,
149     uint256 version,
150     bytes data
151   ) external;
152 
153   function cancelOracleRequest(
154     bytes32 requestId,
155     uint256 payment,
156     bytes4 callbackFunctionId,
157     uint256 expiration
158   ) external;
159 }
160 
161 // File: contracts/interfaces/OracleInterface.sol
162 
163 pragma solidity 0.4.24;
164 
165 interface OracleInterface {
166   function fulfillOracleRequest(
167     bytes32 requestId,
168     uint256 payment,
169     address callbackAddress,
170     bytes4 callbackFunctionId,
171     uint256 expiration,
172     bytes32 data
173   ) external returns (bool);
174   function getAuthorizationStatus(address node) external view returns (bool);
175   function setFulfillmentPermission(address node, bool allowed) external;
176   function withdraw(address recipient, uint256 amount) external;
177   function withdrawable() external view returns (uint256);
178 }
179 
180 // File: contracts/interfaces/LinkTokenInterface.sol
181 
182 pragma solidity 0.4.24;
183 
184 interface LinkTokenInterface {
185   function allowance(address owner, address spender) external returns (bool success);
186   function approve(address spender, uint256 value) external returns (bool success);
187   function balanceOf(address owner) external returns (uint256 balance);
188   function decimals() external returns (uint8 decimalPlaces);
189   function decreaseApproval(address spender, uint256 addedValue) external returns (bool success);
190   function increaseApproval(address spender, uint256 subtractedValue) external;
191   function name() external returns (string tokenName);
192   function symbol() external returns (string tokenSymbol);
193   function totalSupply() external returns (uint256 totalTokensIssued);
194   function transfer(address to, uint256 value) external returns (bool success);
195   function transferAndCall(address to, uint256 value, bytes data) external returns (bool success);
196   function transferFrom(address from, address to, uint256 value) external returns (bool success);
197 }
198 
199 // File: contracts/Oracle.sol
200 
201 pragma solidity 0.4.24;
202 
203 
204 
205 
206 
207 
208 /**
209  * @title The Chainlink Oracle contract
210  * @notice Node operators can deploy this contract to fulfill requests sent to them
211  */
212 contract Oracle is ChainlinkRequestInterface, OracleInterface, Ownable {
213   using SafeMath for uint256;
214 
215   uint256 constant public EXPIRY_TIME = 5 minutes;
216   uint256 constant private MINIMUM_CONSUMER_GAS_LIMIT = 400000;
217   // We initialize fields to 1 instead of 0 so that the first invocation
218   // does not cost more gas.
219   uint256 constant private ONE_FOR_CONSISTENT_GAS_COST = 1;
220   uint256 constant private SELECTOR_LENGTH = 4;
221   uint256 constant private EXPECTED_REQUEST_WORDS = 2;
222   // solium-disable-next-line zeppelin/no-arithmetic-operations
223   uint256 constant private MINIMUM_REQUEST_LENGTH = SELECTOR_LENGTH + (32 * EXPECTED_REQUEST_WORDS);
224 
225   LinkTokenInterface internal LinkToken;
226   mapping(bytes32 => bytes32) private commitments;
227   mapping(address => bool) private authorizedNodes;
228   uint256 private withdrawableTokens = ONE_FOR_CONSISTENT_GAS_COST;
229 
230   event OracleRequest(
231     bytes32 indexed specId,
232     address requester,
233     bytes32 requestId,
234     uint256 payment,
235     address callbackAddr,
236     bytes4 callbackFunctionId,
237     uint256 cancelExpiration,
238     uint256 dataVersion,
239     bytes data
240   );
241 
242   event CancelOracleRequest(
243     bytes32 indexed requestId
244   );
245 
246   /**
247    * @notice Deploy with the address of the LINK token
248    * @dev Sets the LinkToken address for the imported LinkTokenInterface
249    * @param _link The address of the LINK token
250    */
251   constructor(address _link) Ownable() public {
252     LinkToken = LinkTokenInterface(_link);
253   }
254 
255   /**
256    * @notice Called when LINK is sent to the contract via `transferAndCall`
257    * @dev The data payload's first 2 words will be overwritten by the `_sender` and `_amount`
258    * values to ensure correctness. Calls oracleRequest.
259    * @param _sender Address of the sender
260    * @param _amount Amount of LINK sent (specified in wei)
261    * @param _data Payload of the transaction
262    */
263   function onTokenTransfer(
264     address _sender,
265     uint256 _amount,
266     bytes _data
267   )
268     public
269     onlyLINK
270     validRequestLength(_data)
271     permittedFunctionsForLINK(_data)
272   {
273     assembly {
274       // solium-disable-next-line security/no-low-level-calls
275       mstore(add(_data, 36), _sender) // ensure correct sender is passed
276       // solium-disable-next-line security/no-low-level-calls
277       mstore(add(_data, 68), _amount)    // ensure correct amount is passed
278     }
279     // solium-disable-next-line security/no-low-level-calls
280     require(address(this).delegatecall(_data), "Unable to create request"); // calls oracleRequest
281   }
282 
283   /**
284    * @notice Creates the Chainlink request
285    * @dev Stores the hash of the params as the on-chain commitment for the request.
286    * Emits OracleRequest event for the Chainlink node to detect.
287    * @param _sender The sender of the request
288    * @param _payment The amount of payment given (specified in wei)
289    * @param _specId The Job Specification ID
290    * @param _callbackAddress The callback address for the response
291    * @param _callbackFunctionId The callback function ID for the response
292    * @param _nonce The nonce sent by the requester
293    * @param _dataVersion The specified data version
294    * @param _data The CBOR payload of the request
295    */
296   function oracleRequest(
297     address _sender,
298     uint256 _payment,
299     bytes32 _specId,
300     address _callbackAddress,
301     bytes4 _callbackFunctionId,
302     uint256 _nonce,
303     uint256 _dataVersion,
304     bytes _data
305   )
306     external
307     onlyLINK
308     checkCallbackAddress(_callbackAddress)
309   {
310     bytes32 requestId = keccak256(abi.encodePacked(_sender, _nonce));
311     require(commitments[requestId] == 0, "Must use a unique ID");
312     uint256 expiration = now.add(EXPIRY_TIME);
313 
314     commitments[requestId] = keccak256(
315       abi.encodePacked(
316         _payment,
317         _callbackAddress,
318         _callbackFunctionId,
319         expiration
320       )
321     );
322 
323     emit OracleRequest(
324       _specId,
325       _sender,
326       requestId,
327       _payment,
328       _callbackAddress,
329       _callbackFunctionId,
330       expiration,
331       _dataVersion,
332       _data);
333   }
334 
335   /**
336    * @notice Called by the Chainlink node to fulfill requests
337    * @dev Given params must hash back to the commitment stored from `oracleRequest`.
338    * Will call the callback address' callback function without bubbling up error
339    * checking in a `require` so that the node can get paid.
340    * @param _requestId The fulfillment request ID that must match the requester's
341    * @param _payment The payment amount that will be released for the oracle (specified in wei)
342    * @param _callbackAddress The callback address to call for fulfillment
343    * @param _callbackFunctionId The callback function ID to use for fulfillment
344    * @param _expiration The expiration that the node should respond by before the requester can cancel
345    * @param _data The data to return to the consuming contract
346    * @return Status if the external call was successful
347    */
348   function fulfillOracleRequest(
349     bytes32 _requestId,
350     uint256 _payment,
351     address _callbackAddress,
352     bytes4 _callbackFunctionId,
353     uint256 _expiration,
354     bytes32 _data
355   )
356     external
357     onlyAuthorizedNode
358     isValidRequest(_requestId)
359     returns (bool)
360   {
361     bytes32 paramsHash = keccak256(
362       abi.encodePacked(
363         _payment,
364         _callbackAddress,
365         _callbackFunctionId,
366         _expiration
367       )
368     );
369     require(commitments[_requestId] == paramsHash, "Params do not match request ID");
370     withdrawableTokens = withdrawableTokens.add(_payment);
371     delete commitments[_requestId];
372     require(gasleft() >= MINIMUM_CONSUMER_GAS_LIMIT, "Must provide consumer enough gas");
373     // All updates to the oracle's fulfillment should come before calling the
374     // callback(addr+functionId) as it is untrusted.
375     // See: https://solidity.readthedocs.io/en/develop/security-considerations.html#use-the-checks-effects-interactions-pattern
376     return _callbackAddress.call(_callbackFunctionId, _requestId, _data); // solium-disable-line security/no-low-level-calls
377   }
378 
379   /**
380    * @notice Use this to check if a node is authorized for fulfilling requests
381    * @param _node The address of the Chainlink node
382    * @return The authorization status of the node
383    */
384   function getAuthorizationStatus(address _node) external view returns (bool) {
385     return authorizedNodes[_node];
386   }
387 
388   /**
389    * @notice Sets the fulfillment permission for a given node. Use `true` to allow, `false` to disallow.
390    * @param _node The address of the Chainlink node
391    * @param _allowed Bool value to determine if the node can fulfill requests
392    */
393   function setFulfillmentPermission(address _node, bool _allowed) external onlyOwner {
394     authorizedNodes[_node] = _allowed;
395   }
396 
397   /**
398    * @notice Allows the node operator to withdraw earned LINK to a given address
399    * @dev The owner of the contract can be another wallet and does not have to be a Chainlink node
400    * @param _recipient The address to send the LINK token to
401    * @param _amount The amount to send (specified in wei)
402    */
403   function withdraw(address _recipient, uint256 _amount)
404     external
405     onlyOwner
406     hasAvailableFunds(_amount)
407   {
408     withdrawableTokens = withdrawableTokens.sub(_amount);
409     assert(LinkToken.transfer(_recipient, _amount));
410   }
411 
412   /**
413    * @notice Displays the amount of LINK that is available for the node operator to withdraw
414    * @dev We use `ONE_FOR_CONSISTENT_GAS_COST` in place of 0 in storage
415    * @return The amount of withdrawable LINK on the contract
416    */
417   function withdrawable() external view onlyOwner returns (uint256) {
418     return withdrawableTokens.sub(ONE_FOR_CONSISTENT_GAS_COST);
419   }
420 
421   /**
422    * @notice Allows requesters to cancel requests sent to this oracle contract. Will transfer the LINK
423    * sent for the request back to the requester's address.
424    * @dev Given params must hash to a commitment stored on the contract in order for the request to be valid
425    * Emits CancelOracleRequest event.
426    * @param _requestId The request ID
427    * @param _payment The amount of payment given (specified in wei)
428    * @param _callbackFunc The requester's specified callback address
429    * @param _expiration The time of the expiration for the request
430    */
431   function cancelOracleRequest(
432     bytes32 _requestId,
433     uint256 _payment,
434     bytes4 _callbackFunc,
435     uint256 _expiration
436   ) external {
437     bytes32 paramsHash = keccak256(
438       abi.encodePacked(
439         _payment,
440         msg.sender,
441         _callbackFunc,
442         _expiration)
443     );
444     require(paramsHash == commitments[_requestId], "Params do not match request ID");
445     require(_expiration <= now, "Request is not expired");
446 
447     delete commitments[_requestId];
448     emit CancelOracleRequest(_requestId);
449 
450     assert(LinkToken.transfer(msg.sender, _payment));
451   }
452 
453   // MODIFIERS
454 
455   /**
456    * @dev Reverts if amount requested is greater than withdrawable balance
457    * @param _amount The given amount to compare to `withdrawableTokens`
458    */
459   modifier hasAvailableFunds(uint256 _amount) {
460     require(withdrawableTokens >= _amount.add(ONE_FOR_CONSISTENT_GAS_COST), "Amount requested is greater than withdrawable balance");
461     _;
462   }
463 
464   /**
465    * @dev Reverts if request ID does not exist
466    * @param _requestId The given request ID to check in stored `commitments`
467    */
468   modifier isValidRequest(bytes32 _requestId) {
469     require(commitments[_requestId] != 0, "Must have a valid requestId");
470     _;
471   }
472 
473   /**
474    * @dev Reverts if `msg.sender` is not authorized to fulfill requests
475    */
476   modifier onlyAuthorizedNode() {
477     require(authorizedNodes[msg.sender] || msg.sender == owner, "Not an authorized node to fulfill requests");
478     _;
479   }
480 
481   /**
482    * @dev Reverts if not sent from the LINK token
483    */
484   modifier onlyLINK() {
485     require(msg.sender == address(LinkToken), "Must use LINK token");
486     _;
487   }
488 
489   /**
490    * @dev Reverts if the given data does not begin with the `oracleRequest` function selector
491    * @param _data The data payload of the request
492    */
493   modifier permittedFunctionsForLINK(bytes _data) {
494     bytes4 funcSelector;
495     assembly {
496       // solium-disable-next-line security/no-low-level-calls
497       funcSelector := mload(add(_data, 32))
498     }
499     require(funcSelector == this.oracleRequest.selector, "Must use whitelisted functions");
500     _;
501   }
502 
503   /**
504    * @dev Reverts if the callback address is the LINK token
505    * @param _to The callback address
506    */
507   modifier checkCallbackAddress(address _to) {
508     require(_to != address(LinkToken), "Cannot callback to LINK");
509     _;
510   }
511 
512   /**
513    * @dev Reverts if the given payload is less than needed to create a request
514    * @param _data The request payload
515    */
516   modifier validRequestLength(bytes _data) {
517     require(_data.length >= MINIMUM_REQUEST_LENGTH, "Invalid request length");
518     _;
519   }
520 
521 }