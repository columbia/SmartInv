1 pragma solidity ^0.5.0;
2 
3 pragma experimental ABIEncoderV2;
4 
5 /**
6  * @title SafeMath
7  * @dev Unsigned math operations with safety checks that revert on error
8  */
9 library SafeMath {
10     /**
11     * @dev Multiplies two unsigned integers, reverts on overflow.
12     */
13     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
14         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
15         // benefit is lost if 'b' is also tested.
16         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
17         if (a == 0) {
18             return 0;
19         }
20 
21         uint256 c = a * b;
22         require(c / a == b);
23 
24         return c;
25     }
26 
27     /**
28     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
29     */
30     function div(uint256 a, uint256 b) internal pure returns (uint256) {
31         // Solidity only automatically asserts when dividing by 0
32         require(b > 0);
33         uint256 c = a / b;
34         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
35 
36         return c;
37     }
38 
39     /**
40     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
41     */
42     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
43         require(b <= a);
44         uint256 c = a - b;
45 
46         return c;
47     }
48 
49     /**
50     * @dev Adds two unsigned integers, reverts on overflow.
51     */
52     function add(uint256 a, uint256 b) internal pure returns (uint256) {
53         uint256 c = a + b;
54         require(c >= a);
55 
56         return c;
57     }
58 
59     /**
60     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
61     * reverts when dividing by zero.
62     */
63     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
64         require(b != 0);
65         return a % b;
66     }
67 }
68 
69 /**
70  * @title Ownable
71  * @dev The Ownable contract has an owner address, and provides basic authorization control
72  * functions, this simplifies the implementation of "user permissions".
73  */
74 contract Ownable {
75     address private _owner;
76 
77     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
78 
79     /**
80      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
81      * account.
82      */
83     constructor () internal {
84         _owner = msg.sender;
85         emit OwnershipTransferred(address(0), _owner);
86     }
87 
88     /**
89      * @return the address of the owner.
90      */
91     function owner() public view returns (address) {
92         return _owner;
93     }
94 
95     /**
96      * @dev Throws if called by any account other than the owner.
97      */
98     modifier onlyOwner() {
99         require(isOwner());
100         _;
101     }
102 
103     /**
104      * @return true if `msg.sender` is the owner of the contract.
105      */
106     function isOwner() public view returns (bool) {
107         return msg.sender == _owner;
108     }
109 
110     /**
111      * @dev Allows the current owner to relinquish control of the contract.
112      * @notice Renouncing to ownership will leave the contract without an owner.
113      * It will not be possible to call the functions with the `onlyOwner`
114      * modifier anymore.
115      */
116     function renounceOwnership() public onlyOwner {
117         emit OwnershipTransferred(_owner, address(0));
118         _owner = address(0);
119     }
120 
121     /**
122      * @dev Allows the current owner to transfer control of the contract to a newOwner.
123      * @param newOwner The address to transfer ownership to.
124      */
125     function transferOwnership(address newOwner) public onlyOwner {
126         _transferOwnership(newOwner);
127     }
128 
129     /**
130      * @dev Transfers control of the contract to a newOwner.
131      * @param newOwner The address to transfer ownership to.
132      */
133     function _transferOwnership(address newOwner) internal {
134         require(newOwner != address(0));
135         emit OwnershipTransferred(_owner, newOwner);
136         _owner = newOwner;
137     }
138 }
139 
140 /**
141  * @title ERC20 interface
142  * @dev see https://github.com/ethereum/EIPs/issues/20
143  */
144 interface IERC20 {
145     function transfer(address to, uint256 value) external returns (bool);
146 
147     function approve(address spender, uint256 value) external returns (bool);
148 
149     function transferFrom(address from, address to, uint256 value) external returns (bool);
150 
151     function totalSupply() external view returns (uint256);
152 
153     function balanceOf(address who) external view returns (uint256);
154 
155     function allowance(address owner, address spender) external view returns (uint256);
156 
157     event Transfer(address indexed from, address indexed to, uint256 value);
158 
159     event Approval(address indexed owner, address indexed spender, uint256 value);
160 }
161 
162 // The functionality that all derivative contracts expose to the admin.
163 interface AdminInterface {
164     // Initiates the shutdown process, in case of an emergency.
165     function emergencyShutdown() external;
166 
167     // A core contract method called immediately before or after any financial transaction. It pays fees and moves money
168     // between margin accounts to make sure they reflect the NAV of the contract.
169     function remargin() external;
170 }
171 
172 // This interface allows contracts to query a verified, trusted price.
173 interface OracleInterface {
174     // Requests the Oracle price for an identifier at a time. Returns the time at which a price will be available.
175     // Returns 0 is the price is available now, and returns 2^256-1 if the price will never be available.  Reverts if
176     // the Oracle doesn't support this identifier. Only contracts registered in the Registry are authorized to call this
177     // method.
178     function requestPrice(bytes32 identifier, uint time) external returns (uint expectedTime);
179 
180     // Checks whether a price has been resolved.
181     function hasPrice(bytes32 identifier, uint time) external view returns (bool hasPriceAvailable);
182 
183     // Returns the Oracle price for identifier at a time. Reverts if the Oracle doesn't support this identifier or if
184     // the Oracle doesn't have a price for this time. Only contracts registered in the Registry are authorized to call
185     // this method.
186     function getPrice(bytes32 identifier, uint time) external view returns (int price);
187 
188     // Returns whether the Oracle provides verified prices for the given identifier.
189     function isIdentifierSupported(bytes32 identifier) external view returns (bool isSupported);
190 
191     // An event fired when a request for a (identifier, time) pair is made.
192     event VerifiedPriceRequested(bytes32 indexed identifier, uint indexed time);
193 
194     // An event fired when a verified price is available for a (identifier, time) pair.
195     event VerifiedPriceAvailable(bytes32 indexed identifier, uint indexed time, int price);
196 }
197 
198 interface RegistryInterface {
199     struct RegisteredDerivative {
200         address derivativeAddress;
201         address derivativeCreator;
202     }
203 
204     // Registers a new derivative. Only authorized derivative creators can call this method.
205     function registerDerivative(address[] calldata counterparties, address derivativeAddress) external;
206 
207     // Adds a new derivative creator to this list of authorized creators. Only the owner of this contract can call
208     // this method.   
209     function addDerivativeCreator(address derivativeCreator) external;
210 
211     // Removes a derivative creator to this list of authorized creators. Only the owner of this contract can call this
212     // method.  
213     function removeDerivativeCreator(address derivativeCreator) external;
214 
215     // Returns whether the derivative has been registered with the registry (and is therefore an authorized participant
216     // in the UMA system).
217     function isDerivativeRegistered(address derivative) external view returns (bool isRegistered);
218 
219     // Returns a list of all derivatives that are associated with a particular party.
220     function getRegisteredDerivatives(address party) external view returns (RegisteredDerivative[] memory derivatives);
221 
222     // Returns all registered derivatives.
223     function getAllRegisteredDerivatives() external view returns (RegisteredDerivative[] memory derivatives);
224 
225     // Returns whether an address is authorized to register new derivatives.
226     function isDerivativeCreatorAuthorized(address derivativeCreator) external view returns (bool isAuthorized);
227 }
228 
229 contract Testable is Ownable {
230 
231     // Is the contract being run on the test network. Note: this variable should be set on construction and never
232     // modified.
233     bool public isTest;
234 
235     uint private currentTime;
236 
237     constructor(bool _isTest) internal {
238         isTest = _isTest;
239         if (_isTest) {
240             currentTime = now; // solhint-disable-line not-rely-on-time
241         }
242     }
243 
244     modifier onlyIfTest {
245         require(isTest);
246         _;
247     }
248 
249     function setCurrentTime(uint _time) external onlyOwner onlyIfTest {
250         currentTime = _time;
251     }
252 
253     function getCurrentTime() public view returns (uint) {
254         if (isTest) {
255             return currentTime;
256         } else {
257             return now; // solhint-disable-line not-rely-on-time
258         }
259     }
260 }
261 
262 contract Withdrawable is Ownable {
263     // Withdraws ETH from the contract.
264     function withdraw(uint amount) external onlyOwner {
265         msg.sender.transfer(amount);
266     }
267 
268     // Withdraws ERC20 tokens from the contract.
269     function withdrawErc20(address erc20Address, uint amount) external onlyOwner {
270         IERC20 erc20 = IERC20(erc20Address);
271         require(erc20.transfer(msg.sender, amount));
272     }
273 }
274 
275 // Implements an oracle that allows the owner to push prices for queries that have been made.
276 contract CentralizedOracle is OracleInterface, Withdrawable, Testable {
277     using SafeMath for uint;
278 
279     // This contract doesn't implement the voting routine, and naively indicates that all requested prices will be
280     // available in a week.
281     uint constant private SECONDS_IN_WEEK = 60*60*24*7;
282 
283     // Represents an available price. Have to keep a separate bool to allow for price=0.
284     struct Price {
285         bool isAvailable;
286         int price;
287         // Time the verified price became available.
288         uint verifiedTime;
289     }
290 
291     // The two structs below are used in an array and mapping to keep track of prices that have been requested but are
292     // not yet available.
293     struct QueryIndex {
294         bool isValid;
295         uint index;
296     }
297 
298     // Represents a (identifier, time) point that has been queried.
299     struct QueryPoint {
300         bytes32 identifier;
301         uint time;
302     }
303 
304     // The set of identifiers the oracle can provide verified prices for.
305     mapping(bytes32 => bool) private supportedIdentifiers;
306 
307     // Conceptually we want a (time, identifier) -> price map.
308     mapping(bytes32 => mapping(uint => Price)) private verifiedPrices;
309 
310     // The mapping and array allow retrieving all the elements in a mapping and finding/deleting elements.
311     // Can we generalize this data structure?
312     mapping(bytes32 => mapping(uint => QueryIndex)) private queryIndices;
313     QueryPoint[] private requestedPrices;
314 
315     // Registry to verify that a derivative is approved to use the Oracle.
316     RegistryInterface private registry;
317 
318     constructor(address _registry, bool _isTest) public Testable(_isTest) {
319         registry = RegistryInterface(_registry);
320     }
321 
322     // Enqueues a request (if a request isn't already present) for the given (identifier, time) pair.
323     function requestPrice(bytes32 identifier, uint time) external returns (uint expectedTime) {
324         // Ensure that the caller has been registered with the Oracle before processing the request.
325         require(registry.isDerivativeRegistered(msg.sender));
326         require(supportedIdentifiers[identifier]);
327         Price storage lookup = verifiedPrices[identifier][time];
328         if (lookup.isAvailable) {
329             // We already have a price, return 0 to indicate that.
330             return 0;
331         } else if (queryIndices[identifier][time].isValid) {
332             // We already have a pending query, don't need to do anything.
333             return getCurrentTime().add(SECONDS_IN_WEEK);
334         } else {
335             // New query, enqueue it for review.
336             queryIndices[identifier][time] = QueryIndex(true, requestedPrices.length);
337             requestedPrices.push(QueryPoint(identifier, time));
338             emit VerifiedPriceRequested(identifier, time);
339             return getCurrentTime().add(SECONDS_IN_WEEK);
340         }
341     }
342 
343     // Pushes the verified price for a requested query.
344     function pushPrice(bytes32 identifier, uint time, int price) external onlyOwner {
345         verifiedPrices[identifier][time] = Price(true, price, getCurrentTime());
346         emit VerifiedPriceAvailable(identifier, time, price);
347 
348         QueryIndex storage queryIndex = queryIndices[identifier][time];
349         require(queryIndex.isValid, "Can't push prices that haven't been requested");
350         // Delete from the array. Instead of shifting the queries over, replace the contents of `indexToReplace` with
351         // the contents of the last index (unless it is the last index).
352         uint indexToReplace = queryIndex.index;
353         delete queryIndices[identifier][time];
354         uint lastIndex = requestedPrices.length.sub(1);
355         if (lastIndex != indexToReplace) {
356             QueryPoint storage queryToCopy = requestedPrices[lastIndex];
357             queryIndices[queryToCopy.identifier][queryToCopy.time].index = indexToReplace;
358             requestedPrices[indexToReplace] = queryToCopy;
359         }
360         requestedPrices.length = requestedPrices.length.sub(1);
361     }
362 
363     // Adds the provided identifier as a supported identifier.
364     function addSupportedIdentifier(bytes32 identifier) external onlyOwner {
365         if(!supportedIdentifiers[identifier]) {
366             supportedIdentifiers[identifier] = true;
367             emit AddSupportedIdentifier(identifier);
368         }
369     }
370 
371     // Calls emergencyShutdown() on the provided derivative.
372     function callEmergencyShutdown(address derivative) external onlyOwner {
373         AdminInterface admin = AdminInterface(derivative);
374         admin.emergencyShutdown();
375     }
376 
377     // Calls remargin() on the provided derivative.
378     function callRemargin(address derivative) external onlyOwner {
379         AdminInterface admin = AdminInterface(derivative);
380         admin.remargin();
381     }
382 
383     // Checks whether a price has been resolved.
384     function hasPrice(bytes32 identifier, uint time) external view returns (bool hasPriceAvailable) {
385         // Ensure that the caller has been registered with the Oracle before processing the request.
386         require(registry.isDerivativeRegistered(msg.sender));
387         require(supportedIdentifiers[identifier]);
388         Price storage lookup = verifiedPrices[identifier][time];
389         return lookup.isAvailable;
390     }
391 
392     // Gets a price that has already been resolved.
393     function getPrice(bytes32 identifier, uint time) external view returns (int price) {
394         // Ensure that the caller has been registered with the Oracle before processing the request.
395         require(registry.isDerivativeRegistered(msg.sender));
396         require(supportedIdentifiers[identifier]);
397         Price storage lookup = verifiedPrices[identifier][time];
398         require(lookup.isAvailable);
399         return lookup.price;
400     }
401 
402     // Gets the queries that still need verified prices.
403     function getPendingQueries() external view onlyOwner returns (QueryPoint[] memory queryPoints) {
404         return requestedPrices;
405     }
406 
407     // Whether the oracle provides verified prices for the provided identifier.
408     function isIdentifierSupported(bytes32 identifier) external view returns (bool isSupported) {
409         return supportedIdentifiers[identifier];
410     }
411 
412     event AddSupportedIdentifier(bytes32 indexed identifier);
413 }