1 /**
2  *Submitted for verification at Etherscan.io on 2019-07-16
3 */
4 
5 pragma solidity ^0.5.0;
6 
7 /**
8  * @title SafeMath
9  * @dev Unsigned math operations with safety checks that revert on error
10  */
11 library SafeMath {
12     /**
13     * @dev Multiplies two unsigned integers, reverts on overflow.
14     */
15     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
16         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
17         // benefit is lost if 'b' is also tested.
18         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
19         if (a == 0) {
20             return 0;
21         }
22 
23         uint256 c = a * b;
24         require(c / a == b);
25 
26         return c;
27     }
28 
29     /**
30     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
31     */
32     function div(uint256 a, uint256 b) internal pure returns (uint256) {
33         // Solidity only automatically asserts when dividing by 0
34         require(b > 0);
35         uint256 c = a / b;
36         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
37 
38         return c;
39     }
40 
41     /**
42     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
43     */
44     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
45         require(b <= a);
46         uint256 c = a - b;
47 
48         return c;
49     }
50 
51     /**
52     * @dev Adds two unsigned integers, reverts on overflow.
53     */
54     function add(uint256 a, uint256 b) internal pure returns (uint256) {
55         uint256 c = a + b;
56         require(c >= a);
57 
58         return c;
59     }
60 
61     /**
62     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
63     * reverts when dividing by zero.
64     */
65     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
66         require(b != 0);
67         return a % b;
68     }
69 }
70 
71 /**
72  * @title Roles
73  * @dev Library for managing addresses assigned to a Role.
74  */
75 library Roles {
76     struct Role {
77         mapping (address => bool) bearer;
78     }
79 
80     /**
81      * @dev give an account access to this role
82      */
83     function add(Role storage role, address account) internal {
84         require(account != address(0));
85         require(!has(role, account));
86 
87         role.bearer[account] = true;
88     }
89 
90     /**
91      * @dev remove an account's access to this role
92      */
93     function remove(Role storage role, address account) internal {
94         require(account != address(0));
95         require(has(role, account));
96 
97         role.bearer[account] = false;
98     }
99 
100     /**
101      * @dev check if an account has this role
102      * @return bool
103      */
104     function has(Role storage role, address account) internal view returns (bool) {
105         require(account != address(0));
106         return role.bearer[account];
107     }
108 }
109 
110 
111 /**
112  * @title WhitelistAdminRole
113  * @dev WhitelistAdmins are responsible for assigning and removing Whitelisted accounts.
114  */
115 contract WhitelistAdminRole {
116     using Roles for Roles.Role;
117 
118     event WhitelistAdminAdded(address indexed account);
119     event WhitelistAdminRemoved(address indexed account);
120 
121     Roles.Role private _whitelistAdmins;
122 
123     constructor () internal {
124         _addWhitelistAdmin(msg.sender);
125     }
126 
127     modifier onlyWhitelistAdmin() {
128         require(isWhitelistAdmin(msg.sender));
129         _;
130     }
131 
132     function isWhitelistAdmin(address account) public view returns (bool) {
133         return _whitelistAdmins.has(account);
134     }
135 
136     function addWhitelistAdmin(address account) public onlyWhitelistAdmin {
137         _addWhitelistAdmin(account);
138     }
139 
140     function renounceWhitelistAdmin() public {
141         _removeWhitelistAdmin(msg.sender);
142     }
143 
144     function _addWhitelistAdmin(address account) internal {
145         _whitelistAdmins.add(account);
146         emit WhitelistAdminAdded(account);
147     }
148 
149     function _removeWhitelistAdmin(address account) internal {
150         _whitelistAdmins.remove(account);
151         emit WhitelistAdminRemoved(account);
152     }
153 }
154 
155 
156 /**
157  * @title WhitelistedRole
158  * @dev Whitelisted accounts have been approved by a WhitelistAdmin to perform certain actions (e.g. participate in a
159  * crowdsale). This role is special in that the only accounts that can add it are WhitelistAdmins (who can also remove
160  * it), and not Whitelisteds themselves.
161  */
162 contract WhitelistedRole is WhitelistAdminRole {
163     using Roles for Roles.Role;
164 
165     event WhitelistedAdded(address indexed account);
166     event WhitelistedRemoved(address indexed account);
167 
168     Roles.Role private _whitelisteds;
169 
170     modifier onlyWhitelisted() {
171         require(isWhitelisted(msg.sender));
172         _;
173     }
174 
175     function isWhitelisted(address account) public view returns (bool) {
176         return _whitelisteds.has(account);
177     }
178 
179     function addWhitelisted(address account) public onlyWhitelistAdmin {
180         _addWhitelisted(account);
181     }
182 
183     function removeWhitelisted(address account) public onlyWhitelistAdmin {
184         _removeWhitelisted(account);
185     }
186 
187     function renounceWhitelisted() public {
188         _removeWhitelisted(msg.sender);
189     }
190 
191     function _addWhitelisted(address account) internal {
192         _whitelisteds.add(account);
193         emit WhitelistedAdded(account);
194     }
195 
196     function _removeWhitelisted(address account) internal {
197         _whitelisteds.remove(account);
198         emit WhitelistedRemoved(account);
199     }
200 }
201 
202 /**
203  * @title RequestHashStorage
204  * @notice This contract is the entry point to retrieve all the hashes of the request network system.
205   */
206 contract RequestHashStorage is WhitelistedRole {
207 
208   // Event to declare a new hash
209   event NewHash(string hash, address hashSubmitter, bytes feesParameters);
210 
211   /**
212    * @notice Declare a new hash
213    * @param _hash hash to store
214    * @param _feesParameters Parameters use to compute the fees. This is a bytes to stay generic, the structure is on the charge of the hashSubmitter contracts.
215    */
216   function declareNewHash(string calldata _hash, bytes calldata _feesParameters)
217     external
218     onlyWhitelisted
219   {
220     // Emit event for log
221     emit NewHash(_hash, msg.sender, _feesParameters);
222   }
223 
224   // Fallback function returns funds to the sender
225   function()
226     external
227   {
228     revert("not payable fallback");
229   }
230 }
231 
232 
233 /**
234  * @title Bytes util library.
235  * @notice Collection of utility functions to manipulate bytes for Request.
236  */
237 library Bytes {
238   /**
239     * @notice Extract a bytes32 from a bytes.
240     * @param data bytes from where the bytes32 will be extract
241     * @param offset position of the first byte of the bytes32
242     * @return address
243     */
244   function extractBytes32(bytes memory data, uint offset)
245     internal
246     pure
247     returns (bytes32 bs)
248   {
249     require(offset >= 0 && offset + 32 <= data.length, "offset value should be in the correct range");
250 
251     // solium-disable-next-line security/no-inline-assembly
252     assembly {
253         bs := mload(add(data, add(32, offset)))
254     }
255   }
256 }
257 
258 /**
259  * @title StorageFeeCollector
260  *
261  * @notice StorageFeeCollector is a contract managing the fees
262  */
263 contract StorageFeeCollector is WhitelistAdminRole {
264   using SafeMath for uint256;
265 
266   /**
267    * Fee computation for storage are based on four parameters:
268    * minimumFee (wei) fee that will be applied for any size of storage
269    * rateFeesNumerator (wei) and rateFeesDenominator (byte) define the variable fee,
270    * for each <rateFeesDenominator> bytes above threshold, <rateFeesNumerator> wei will be charged
271    *
272    * Example:
273    * If the size to store is 50 bytes, the threshold is 100 bytes and the minimum fee is 300 wei,
274    * then 300 will be charged
275    *
276    * If rateFeesNumerator is 2 and rateFeesDenominator is 1 then 2 wei will be charged for every bytes above threshold,
277    * if the size to store is 150 bytes then the fee will be 300 + (150-100)*2 = 400 wei
278    */
279   uint256 public minimumFee;
280   uint256 public rateFeesNumerator;
281   uint256 public rateFeesDenominator;
282 
283   // address of the contract that will burn req token
284   address payable public requestBurnerContract;
285 
286   event UpdatedFeeParameters(uint256 minimumFee, uint256 rateFeesNumerator, uint256 rateFeesDenominator);
287   event UpdatedMinimumFeeThreshold(uint256 threshold);
288   event UpdatedBurnerContract(address burnerAddress);
289 
290   /**
291    * @param _requestBurnerContract Address of the contract where to send the ether.
292    * This burner contract will have a function that can be called by anyone and will exchange ether to req via Kyber and burn the REQ
293    */
294   constructor(address payable _requestBurnerContract)
295     public
296   {
297     requestBurnerContract = _requestBurnerContract;
298   }
299 
300   /**
301     * @notice Sets the fees rate and minimum fee.
302     * @dev if the _rateFeesDenominator is 0, it will be treated as 1. (in other words, the computation of the fees will not use it)
303     * @param _minimumFee minimum fixed fee
304     * @param _rateFeesNumerator numerator rate
305     * @param _rateFeesDenominator denominator rate
306     */
307   function setFeeParameters(uint256 _minimumFee, uint256 _rateFeesNumerator, uint256 _rateFeesDenominator)
308     external
309     onlyWhitelistAdmin
310   {
311     minimumFee = _minimumFee;
312     rateFeesNumerator = _rateFeesNumerator;
313     rateFeesDenominator = _rateFeesDenominator;
314     emit UpdatedFeeParameters(minimumFee, rateFeesNumerator, rateFeesDenominator);
315   }
316 
317 
318   /**
319     * @notice Set the request burner address.
320     * @param _requestBurnerContract address of the contract that will burn req token (probably through Kyber)
321     */
322   function setRequestBurnerContract(address payable _requestBurnerContract)
323     external
324     onlyWhitelistAdmin
325   {
326     requestBurnerContract = _requestBurnerContract;
327     emit UpdatedBurnerContract(requestBurnerContract);
328   }
329 
330   /**
331     * @notice Computes the fees.
332     * @param _contentSize Size of the content of the block to be stored
333     * @return the expected amount of fees in wei
334     */
335   function getFeesAmount(uint256 _contentSize)
336     public
337     view
338     returns(uint256)
339   {
340     // Transactions fee
341     uint256 computedAllFee = _contentSize.mul(rateFeesNumerator);
342 
343     if (rateFeesDenominator != 0) {
344       computedAllFee = computedAllFee.div(rateFeesDenominator);
345     }
346 
347     if (computedAllFee <= minimumFee) {
348       return minimumFee;
349     } else {
350       return computedAllFee;
351     }
352   }
353 
354   /**
355     * @notice Sends fees to the request burning address.
356     * @param _amount amount to send to the burning address
357     */
358   function collectForREQBurning(uint256 _amount)
359     internal
360   {
361     // .transfer throws on failure
362     requestBurnerContract.transfer(_amount);
363   }
364 }
365 
366 /**
367  * @title RequestOpenHashSubmitter
368  * @notice Contract declares data hashes and collects the fees.
369  * @notice The hash is declared to the whole request network system through the RequestHashStorage contract.
370  * @notice Anyone can submit hashes.
371  */
372 contract RequestOpenHashSubmitter is StorageFeeCollector {
373 
374   RequestHashStorage public requestHashStorage;
375   
376   /**
377    * @param _addressRequestHashStorage contract address which manages the hashes declarations
378    * @param _addressBurner Burner address
379    */
380   constructor(address _addressRequestHashStorage, address payable _addressBurner)
381     StorageFeeCollector(_addressBurner)
382     public
383   {
384     requestHashStorage = RequestHashStorage(_addressRequestHashStorage);
385   }
386 
387   /**
388    * @notice Submit a new hash to the blockchain.
389    *
390    * @param _hash Hash of the request to be stored
391    * @param _feesParameters fees parameters used to compute the fees. Here, it is the content size in an uint256
392    */
393   function submitHash(string calldata _hash, bytes calldata _feesParameters)
394     external
395     payable
396   {
397     // extract the contentSize from the _feesParameters
398     uint256 contentSize = uint256(Bytes.extractBytes32(_feesParameters, 0));
399 
400     // Check fees are paid
401     require(getFeesAmount(contentSize) == msg.value, "msg.value does not match the fees");
402 
403     // Send fees to burner, throws on failure
404     collectForREQBurning(msg.value);
405 
406     // declare the hash to the whole system through to RequestHashStorage
407     requestHashStorage.declareNewHash(_hash, _feesParameters);
408   }
409 
410   // Fallback function returns funds to the sender
411   function()
412     external
413     payable
414   {
415     revert("not payable fallback");
416   }
417 }