1 pragma solidity 0.5.10;
2 
3 /**
4  * @title ERC20 interface
5  * @dev see https://eips.ethereum.org/EIPS/eip-20
6  */
7 interface IERC20 {
8     function transfer(address to, uint256 value) external returns (bool);
9 
10     function approve(address spender, uint256 value) external returns (bool);
11 
12     function transferFrom(address from, address to, uint256 value) external returns (bool);
13 
14     function totalSupply() external view returns (uint256);
15 
16     function balanceOf(address who) external view returns (uint256);
17 
18     function allowance(address owner, address spender) external view returns (uint256);
19 
20     event Transfer(address indexed from, address indexed to, uint256 value);
21 
22     event Approval(address indexed owner, address indexed spender, uint256 value);
23 }
24 
25 /**
26  * @title SafeMath
27  * @dev Unsigned math operations with safety checks that revert on error
28  */
29 library SafeMath {
30     /**
31      * @dev Multiplies two unsigned integers, reverts on overflow.
32      */
33     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
34         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
35         // benefit is lost if 'b' is also tested.
36         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
37         if (a == 0) {
38             return 0;
39         }
40 
41         uint256 c = a * b;
42         require(c / a == b);
43 
44         return c;
45     }
46 
47     /**
48      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
49      */
50     function div(uint256 a, uint256 b) internal pure returns (uint256) {
51         // Solidity only automatically asserts when dividing by 0
52         require(b > 0);
53         uint256 c = a / b;
54         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
55 
56         return c;
57     }
58 
59     /**
60      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
61      */
62     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
63         require(b <= a);
64         uint256 c = a - b;
65 
66         return c;
67     }
68 
69     /**
70      * @dev Adds two unsigned integers, reverts on overflow.
71      */
72     function add(uint256 a, uint256 b) internal pure returns (uint256) {
73         uint256 c = a + b;
74         require(c >= a);
75 
76         return c;
77     }
78 
79     /**
80      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
81      * reverts when dividing by zero.
82      */
83     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
84         require(b != 0);
85         return a % b;
86     }
87 }
88 
89 /**
90  * @title PayableOwnable
91  * @dev The PayableOwnable contract has an owner address, and provides basic authorization control
92  * functions, this simplifies the implementation of "user permissions".
93  * PayableOwnable is extended from open-zeppelin Ownable smart contract, with the difference of making the owner
94  * a payable address.
95  */
96 contract PayableOwnable {
97     address payable internal _owner;
98 
99     event OwnershipTransferred(
100         address indexed previousOwner,
101         address indexed newOwner
102     );
103 
104     /**
105      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
106      * account.
107      */
108     constructor() internal {
109         _owner = msg.sender;
110         emit OwnershipTransferred(address(0), _owner);
111     }
112 
113     /**
114      * @return the address of the owner.
115      */
116     function owner() public view returns (address payable) {
117         return _owner;
118     }
119 
120     /**
121      * @dev Throws if called by any account other than the owner.
122      */
123     modifier onlyOwner() {
124         require(isOwner());
125         _;
126     }
127 
128     /**
129      * @return true if `msg.sender` is the owner of the contract.
130      */
131     function isOwner() public view returns (bool) {
132         return msg.sender == _owner;
133     }
134 
135     /**
136      * @dev Allows the current owner to relinquish control of the contract.
137      * @notice Renouncing to ownership will leave the contract without an owner.
138      * It will not be possible to call the functions with the `onlyOwner`
139      * modifier anymore.
140      */
141     function renounceOwnership() public onlyOwner {
142         emit OwnershipTransferred(_owner, address(0));
143         _owner = address(0);
144     }
145 
146     /**
147      * @dev Allows the current owner to transfer control of the contract to a newOwner.
148      * @param newOwner The address to transfer ownership to.
149      */
150     function transferOwnership(address payable newOwner) public onlyOwner {
151         _transferOwnership(newOwner);
152     }
153 
154     /**
155      * @dev Transfers control of the contract to a newOwner.
156      * @param newOwner The address to transfer ownership to.
157      */
158     function _transferOwnership(address payable newOwner) internal {
159         require(newOwner != address(0));
160         emit OwnershipTransferred(_owner, newOwner);
161         _owner = newOwner;
162     }
163 }
164 
165 /// @title PumaPay Single Pull Payment - Contract that facilitates our pull payment protocol
166 /// The single pull payment smart contract allows for the amount to be defined in PMA rather than in FIAT.
167 /// This optimization reduces the gas costs that we had in place for the calculation of PMA amount from FIAT
168 /// compared to the previous versions of our smart contracts (v1 and v2). Also, we don't need to worry about PMA/FIAT rates
169 /// on the blockchain anymore since we are taking care of that on the wallet side by having the user signing the amount of PMA directly.
170 /// @author PumaPay Dev Team - <developers@pumapay.io>
171 contract SinglePullPaymentWithFunding is PayableOwnable {
172 
173     using SafeMath for uint256;
174     /// ===============================================================================================================
175     ///                                      Events
176     /// ===============================================================================================================
177 
178     event LogExecutorAdded(address executor);
179     event LogExecutorRemoved(address executor);
180     event LogSmartContractActorFunded(string actorRole, address actor, uint256 timestamp);
181     event LogPullPaymentExecuted(
182         address customerAddress,
183         address receiverAddress,
184         uint256 amountInPMA,
185         bytes32 paymentID,
186         bytes32 businessID,
187         string uniqueReferenceID
188     );
189 
190     /// ===============================================================================================================
191     ///                                      Constants
192     /// ===============================================================================================================
193     bytes32 constant private EMPTY_BYTES32 = "";
194     uint256 constant private FUNDING_AMOUNT = 0.5 ether;                           /// Amount to transfer to owner/executor
195     uint256 constant private MINIMUM_AMOUNT_OF_ETH_FOR_OPERATORS = 0.15 ether;     /// min amount of ETH for owner/executor
196 
197     /// ===============================================================================================================
198     ///                                      Members
199     /// ===============================================================================================================
200     IERC20 public token;
201     mapping(address => bool) public executors;
202     mapping(bytes32 => PullPayment) public pullPayments;
203 
204     struct PullPayment {
205         bytes32[2] paymentDetails;              /// [0] paymentID / [1] businessID
206         uint256 paymentAmount;                  /// payment amount in fiat in cents
207         address customerAddress;                /// wallet address of customer
208         address receiverAddress;                /// address which pma tokens will be transfer to on execution
209         string uniqueReferenceID;
210     }
211     /// ===============================================================================================================
212     ///                                      Modifiers
213     /// ===============================================================================================================
214     modifier isExecutor() {
215         require(executors[msg.sender], "msg.sender not an executor");
216         _;
217     }
218     modifier executorExists(address _executor) {
219         require(executors[_executor], "Executor does not exists.");
220         _;
221     }
222     modifier executorDoesNotExists(address _executor) {
223         require(!executors[_executor], "Executor already exists.");
224         _;
225     }
226     modifier isValidAddress(address _address) {
227         require(_address != address(0), "Invalid address - ZERO_ADDRESS provided");
228         _;
229     }
230     modifier isValidNumber(uint256 _amount) {
231         require(_amount > 0, "Invalid amount - Must be higher than zero");
232         _;
233     }
234     modifier isValidByte32(bytes32 _text) {
235         require(_text != EMPTY_BYTES32, "Invalid byte32 value.");
236         _;
237     }
238     modifier pullPaymentDoesNotExists(address _customerAddress, bytes32 _paymentID) {
239         require(pullPayments[_paymentID].paymentDetails[0] == EMPTY_BYTES32, "Pull payment already exists - Payment ID");
240         require(pullPayments[_paymentID].paymentDetails[1] == EMPTY_BYTES32, "Pull payment already exists - Business ID");
241         require(pullPayments[_paymentID].paymentAmount == 0, "Pull payment already exists - Payment Amount");
242         require(pullPayments[_paymentID].receiverAddress == address(0), "Pull payment already exists - Receiver Address");
243         _;
244     }
245 
246     /// ===============================================================================================================
247     ///                                      Constructor
248     /// ===============================================================================================================
249     /// @dev Contract constructor - sets the token address that the contract facilitates.
250     /// @param _token Token Address.
251     constructor(address _token)
252     public {
253         require(_token != address(0), "Invalid address for token - ZERO_ADDRESS provided");
254         token = IERC20(_token);
255     }
256 
257     // @notice Will receive any eth sent to the contract
258     function() external payable {
259     }
260     /// ===============================================================================================================
261     ///                                      Public Functions - Owner Only
262     /// ===============================================================================================================
263 
264     /// @dev Adds a new executor. - can be executed only by the owner.
265     /// @param _executor - address of the executor which cannot be zero address.
266     function addExecutor(address payable _executor)
267     public
268     onlyOwner
269     isValidAddress(_executor)
270     executorDoesNotExists(_executor)
271     {
272         executors[_executor] = true;
273         if (isFundingNeeded(_executor)) {
274             _executor.transfer(FUNDING_AMOUNT);
275             emit LogSmartContractActorFunded("executor", _executor, now);
276         }
277 
278         if (isFundingNeeded(owner())) {
279             owner().transfer(FUNDING_AMOUNT);
280             emit LogSmartContractActorFunded("owner", owner(), now);
281         }
282 
283         emit LogExecutorAdded(_executor);
284     }
285 
286     /// @dev Removes a new executor. - can be executed only by the owner.
287     /// @param _executor - address of the executor which cannot be zero address.
288     function removeExecutor(address payable _executor)
289     public
290     onlyOwner
291     isValidAddress(_executor)
292     executorExists(_executor)
293     {
294         executors[_executor] = false;
295 
296         if (isFundingNeeded(owner())) {
297             owner().transfer(FUNDING_AMOUNT);
298             emit LogSmartContractActorFunded("owner", owner(), now);
299         }
300 
301         emit LogExecutorRemoved(_executor);
302     }
303 
304     /// ===============================================================================================================
305     ///                                      Public Functions - Executors Only
306     /// ===============================================================================================================
307 
308     /// @dev Registers a new pull payment to the PumaPay Pull Payment Contract - The method can be executed only
309     /// by one of the executors of the PumaPay Pull Payment Contract.
310     /// It creates a new pull payment in the 'pullPayments' mapping and it transfers the amount
311     /// It also transfer the PMA amount from the customer address to the receiver address.
312     /// Emits 'LogPullPaymentExecuted' with customer address, receiver address, PMA amount, the paymentID, businessID and uniqueReferenceID
313     /// @param v - recovery ID of the ETH signature. - https://github.com/ethereum/EIPs/issues/155
314     /// @param r - R output of ECDSA signature.
315     /// @param s - S output of ECDSA signature.
316     /// @param _paymentDetails - all the relevant id-related details for the payment.
317     /// @param _addresses - all the relevant addresses for the payment.
318     /// @param _paymentAmount - amount in PMA to be transferred to the receiver.
319     /// @param _uniqueReferenceID - unique reference ID of the pull payment.
320     function registerPullPayment(
321         uint8 v,
322         bytes32 r,
323         bytes32 s,
324         bytes32[2] memory _paymentDetails, /// [0] paymentID, [1] businessID
325         address[2] memory _addresses, /// [0] customerAddress, [1] receiverAddress
326         uint256 _paymentAmount,
327         string memory _uniqueReferenceID
328     )
329     public
330     isExecutor()
331     isValidByte32(_paymentDetails[0])
332     isValidByte32(_paymentDetails[1])
333     isValidNumber(_paymentAmount)
334     isValidAddress(_addresses[0])
335     isValidAddress(_addresses[1])
336     pullPaymentDoesNotExists(_addresses[0], _paymentDetails[0])
337     {
338         bytes32[2] memory paymentDetails = _paymentDetails;
339 
340         pullPayments[paymentDetails[0]].paymentDetails = _paymentDetails;
341         pullPayments[paymentDetails[0]].paymentAmount = _paymentAmount;
342         pullPayments[paymentDetails[0]].customerAddress = _addresses[0];
343         pullPayments[paymentDetails[0]].receiverAddress = _addresses[1];
344         pullPayments[paymentDetails[0]].uniqueReferenceID = _uniqueReferenceID;
345 
346         require(isValidRegistration(
347                 v,
348                 r,
349                 s,
350                 pullPayments[paymentDetails[0]]),
351             "Invalid pull payment registration - ECRECOVER_FAILED"
352         );
353 
354         token.transferFrom(
355             _addresses[0],
356             _addresses[1],
357             _paymentAmount
358         );
359 
360         if (isFundingNeeded(msg.sender)) {
361             msg.sender.transfer(FUNDING_AMOUNT);
362             emit LogSmartContractActorFunded("executor", msg.sender, now);
363         }
364 
365         emit LogPullPaymentExecuted(
366             _addresses[0],
367             _addresses[1],
368             _paymentAmount,
369             paymentDetails[0],
370             paymentDetails[1],
371             _uniqueReferenceID
372         );
373     }
374 
375     /// ===============================================================================================================
376     ///                                      Internal Functions
377     /// ===============================================================================================================
378 
379     /// @dev Checks if a registration request is valid by comparing the v, r, s params
380     /// and the hashed params with the customer address.
381     /// @param v - recovery ID of the ETH signature. - https://github.com/ethereum/EIPs/issues/155
382     /// @param r - R output of ECDSA signature.
383     /// @param s - S output of ECDSA signature.
384     /// @param _pullPayment - pull payment to be validated.
385     /// @return bool - if the v, r, s params with the hashed params match the customer address
386     function isValidRegistration(
387         uint8 v,
388         bytes32 r,
389         bytes32 s,
390         PullPayment memory _pullPayment
391     )
392     internal
393     pure
394     returns (bool)
395     {
396         return ecrecover(
397             keccak256(
398                 abi.encodePacked(
399                     _pullPayment.paymentDetails[0],
400                     _pullPayment.paymentDetails[1],
401                     _pullPayment.paymentAmount,
402                     _pullPayment.customerAddress,
403                     _pullPayment.receiverAddress,
404                     _pullPayment.uniqueReferenceID
405                 )
406             ),
407             v, r, s) == _pullPayment.customerAddress;
408     }
409 
410     /// @dev Checks if the address of an owner/executor needs to be funded.
411     /// The minimum amount the owner/executors should always have is 0.15 ETH
412     /// @param _address - address of owner/executors that the balance is checked against.
413     /// @return bool - whether the address needs more ETH.
414     function isFundingNeeded(address _address)
415     private
416     view
417     returns (bool) {
418         return address(_address).balance <= MINIMUM_AMOUNT_OF_ETH_FOR_OPERATORS;
419     }
420 }