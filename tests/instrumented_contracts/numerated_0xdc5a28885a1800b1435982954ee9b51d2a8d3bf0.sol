1 pragma solidity 0.7.6;
2 
3 // SPDX-License-Identifier: GPL-3.0-only
4 
5 
6 library SafeMath {
7     /**
8      * @dev Returns the addition of two unsigned integers, with an overflow flag.
9      *
10      * _Available since v3.4._
11      */
12     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
13         uint256 c = a + b;
14         if (c < a) return (false, 0);
15         return (true, c);
16     }
17 
18     /**
19      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
20      *
21      * _Available since v3.4._
22      */
23     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
24         if (b > a) return (false, 0);
25         return (true, a - b);
26     }
27 
28     /**
29      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
30      *
31      * _Available since v3.4._
32      */
33     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
34         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
35         // benefit is lost if 'b' is also tested.
36         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
37         if (a == 0) return (true, 0);
38         uint256 c = a * b;
39         if (c / a != b) return (false, 0);
40         return (true, c);
41     }
42 
43     /**
44      * @dev Returns the division of two unsigned integers, with a division by zero flag.
45      *
46      * _Available since v3.4._
47      */
48     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
49         if (b == 0) return (false, 0);
50         return (true, a / b);
51     }
52 
53     /**
54      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
55      *
56      * _Available since v3.4._
57      */
58     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
59         if (b == 0) return (false, 0);
60         return (true, a % b);
61     }
62 
63     /**
64      * @dev Returns the addition of two unsigned integers, reverting on
65      * overflow.
66      *
67      * Counterpart to Solidity's `+` operator.
68      *
69      * Requirements:
70      *
71      * - Addition cannot overflow.
72      */
73     function add(uint256 a, uint256 b) internal pure returns (uint256) {
74         uint256 c = a + b;
75         require(c >= a, "SafeMath: addition overflow");
76         return c;
77     }
78 
79     /**
80      * @dev Returns the subtraction of two unsigned integers, reverting on
81      * overflow (when the result is negative).
82      *
83      * Counterpart to Solidity's `-` operator.
84      *
85      * Requirements:
86      *
87      * - Subtraction cannot overflow.
88      */
89     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
90         require(b <= a, "SafeMath: subtraction overflow");
91         return a - b;
92     }
93 
94     /**
95      * @dev Returns the multiplication of two unsigned integers, reverting on
96      * overflow.
97      *
98      * Counterpart to Solidity's `*` operator.
99      *
100      * Requirements:
101      *
102      * - Multiplication cannot overflow.
103      */
104     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
105         if (a == 0) return 0;
106         uint256 c = a * b;
107         require(c / a == b, "SafeMath: multiplication overflow");
108         return c;
109     }
110 
111     /**
112      * @dev Returns the integer division of two unsigned integers, reverting on
113      * division by zero. The result is rounded towards zero.
114      *
115      * Counterpart to Solidity's `/` operator. Note: this function uses a
116      * `revert` opcode (which leaves remaining gas untouched) while Solidity
117      * uses an invalid opcode to revert (consuming all remaining gas).
118      *
119      * Requirements:
120      *
121      * - The divisor cannot be zero.
122      */
123     function div(uint256 a, uint256 b) internal pure returns (uint256) {
124         require(b > 0, "SafeMath: division by zero");
125         return a / b;
126     }
127 
128     /**
129      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
130      * reverting when dividing by zero.
131      *
132      * Counterpart to Solidity's `%` operator. This function uses a `revert`
133      * opcode (which leaves remaining gas untouched) while Solidity uses an
134      * invalid opcode to revert (consuming all remaining gas).
135      *
136      * Requirements:
137      *
138      * - The divisor cannot be zero.
139      */
140     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
141         require(b > 0, "SafeMath: modulo by zero");
142         return a % b;
143     }
144 
145     /**
146      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
147      * overflow (when the result is negative).
148      *
149      * CAUTION: This function is deprecated because it requires allocating memory for the error
150      * message unnecessarily. For custom revert reasons use {trySub}.
151      *
152      * Counterpart to Solidity's `-` operator.
153      *
154      * Requirements:
155      *
156      * - Subtraction cannot overflow.
157      */
158     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
159         require(b <= a, errorMessage);
160         return a - b;
161     }
162 
163     /**
164      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
165      * division by zero. The result is rounded towards zero.
166      *
167      * CAUTION: This function is deprecated because it requires allocating memory for the error
168      * message unnecessarily. For custom revert reasons use {tryDiv}.
169      *
170      * Counterpart to Solidity's `/` operator. Note: this function uses a
171      * `revert` opcode (which leaves remaining gas untouched) while Solidity
172      * uses an invalid opcode to revert (consuming all remaining gas).
173      *
174      * Requirements:
175      *
176      * - The divisor cannot be zero.
177      */
178     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
179         require(b > 0, errorMessage);
180         return a / b;
181     }
182 
183     /**
184      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
185      * reverting with custom message when dividing by zero.
186      *
187      * CAUTION: This function is deprecated because it requires allocating memory for the error
188      * message unnecessarily. For custom revert reasons use {tryMod}.
189      *
190      * Counterpart to Solidity's `%` operator. This function uses a `revert`
191      * opcode (which leaves remaining gas untouched) while Solidity uses an
192      * invalid opcode to revert (consuming all remaining gas).
193      *
194      * Requirements:
195      *
196      * - The divisor cannot be zero.
197      */
198     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
199         require(b > 0, errorMessage);
200         return a % b;
201     }
202 }
203 
204 interface IStafiFeePool {
205     function withdrawEther(address _to, uint256 _amount) external;
206 }
207 
208 
209 interface IStafiStorage {
210 
211     // Getters
212     function getAddress(bytes32 _key) external view returns (address);
213     function getUint(bytes32 _key) external view returns (uint);
214     function getString(bytes32 _key) external view returns (string memory);
215     function getBytes(bytes32 _key) external view returns (bytes memory);
216     function getBool(bytes32 _key) external view returns (bool);
217     function getInt(bytes32 _key) external view returns (int);
218     function getBytes32(bytes32 _key) external view returns (bytes32);
219 
220     // Setters
221     function setAddress(bytes32 _key, address _value) external;
222     function setUint(bytes32 _key, uint _value) external;
223     function setString(bytes32 _key, string calldata _value) external;
224     function setBytes(bytes32 _key, bytes calldata _value) external;
225     function setBool(bytes32 _key, bool _value) external;
226     function setInt(bytes32 _key, int _value) external;
227     function setBytes32(bytes32 _key, bytes32 _value) external;
228 
229     // Deleters
230     function deleteAddress(bytes32 _key) external;
231     function deleteUint(bytes32 _key) external;
232     function deleteString(bytes32 _key) external;
233     function deleteBytes(bytes32 _key) external;
234     function deleteBool(bytes32 _key) external;
235     function deleteInt(bytes32 _key) external;
236     function deleteBytes32(bytes32 _key) external;
237 
238 }
239 
240 
241 abstract contract StafiBase {
242 
243     // Version of the contract
244     uint8 public version;
245 
246     // The main storage contract where primary persistant storage is maintained
247     IStafiStorage stafiStorage = IStafiStorage(0);
248 
249 
250     /**
251     * @dev Throws if called by any sender that doesn't match a network contract
252     */
253     modifier onlyLatestNetworkContract() {
254         require(getBool(keccak256(abi.encodePacked("contract.exists", msg.sender))), "Invalid or outdated network contract");
255         _;
256     }
257 
258 
259     /**
260     * @dev Throws if called by any sender that doesn't match one of the supplied contract or is the latest version of that contract
261     */
262     modifier onlyLatestContract(string memory _contractName, address _contractAddress) {
263         require(_contractAddress == getAddress(keccak256(abi.encodePacked("contract.address", _contractName))), "Invalid or outdated contract");
264         _;
265     }
266 
267 
268     /**
269     * @dev Throws if called by any sender that isn't a trusted node
270     */
271     modifier onlyTrustedNode(address _nodeAddress) {
272         require(getBool(keccak256(abi.encodePacked("node.trusted", _nodeAddress))), "Invalid trusted node");
273         _;
274     }
275     
276     /**
277     * @dev Throws if called by any sender that isn't a super node
278     */
279     modifier onlySuperNode(address _nodeAddress) {
280         require(getBool(keccak256(abi.encodePacked("node.super", _nodeAddress))), "Invalid super node");
281         _;
282     }
283 
284 
285     /**
286     * @dev Throws if called by any sender that isn't a registered staking pool
287     */
288     modifier onlyRegisteredStakingPool(address _stakingPoolAddress) {
289         require(getBool(keccak256(abi.encodePacked("stakingpool.exists", _stakingPoolAddress))), "Invalid staking pool");
290         _;
291     }
292 
293 
294     /**
295     * @dev Throws if called by any account other than the owner.
296     */
297     modifier onlyOwner() {
298         require(roleHas("owner", msg.sender), "Account is not the owner");
299         _;
300     }
301 
302 
303     /**
304     * @dev Modifier to scope access to admins
305     */
306     modifier onlyAdmin() {
307         require(roleHas("admin", msg.sender), "Account is not an admin");
308         _;
309     }
310 
311 
312     /**
313     * @dev Modifier to scope access to admins
314     */
315     modifier onlySuperUser() {
316         require(roleHas("owner", msg.sender) || roleHas("admin", msg.sender), "Account is not a super user");
317         _;
318     }
319 
320 
321     /**
322     * @dev Reverts if the address doesn't have this role
323     */
324     modifier onlyRole(string memory _role) {
325         require(roleHas(_role, msg.sender), "Account does not match the specified role");
326         _;
327     }
328 
329 
330     /// @dev Set the main Storage address
331     constructor(address _stafiStorageAddress) {
332         // Update the contract address
333         stafiStorage = IStafiStorage(_stafiStorageAddress);
334     }
335 
336 
337     /// @dev Get the address of a network contract by name
338     function getContractAddress(string memory _contractName) internal view returns (address) {
339         // Get the current contract address
340         address contractAddress = getAddress(keccak256(abi.encodePacked("contract.address", _contractName)));
341         // Check it
342         require(contractAddress != address(0x0), "Contract not found");
343         // Return
344         return contractAddress;
345     }
346 
347 
348     /// @dev Get the name of a network contract by address
349     function getContractName(address _contractAddress) internal view returns (string memory) {
350         // Get the contract name
351         string memory contractName = getString(keccak256(abi.encodePacked("contract.name", _contractAddress)));
352         // Check it
353         require(keccak256(abi.encodePacked(contractName)) != keccak256(abi.encodePacked("")), "Contract not found");
354         // Return
355         return contractName;
356     }
357 
358 
359     /// @dev Storage get methods
360     function getAddress(bytes32 _key) internal view returns (address) { return stafiStorage.getAddress(_key); }
361     function getUint(bytes32 _key) internal view returns (uint256) { return stafiStorage.getUint(_key); }
362     function getString(bytes32 _key) internal view returns (string memory) { return stafiStorage.getString(_key); }
363     function getBytes(bytes32 _key) internal view returns (bytes memory) { return stafiStorage.getBytes(_key); }
364     function getBool(bytes32 _key) internal view returns (bool) { return stafiStorage.getBool(_key); }
365     function getInt(bytes32 _key) internal view returns (int256) { return stafiStorage.getInt(_key); }
366     function getBytes32(bytes32 _key) internal view returns (bytes32) { return stafiStorage.getBytes32(_key); }
367     function getAddressS(string memory _key) internal view returns (address) { return stafiStorage.getAddress(keccak256(abi.encodePacked(_key))); }
368     function getUintS(string memory _key) internal view returns (uint256) { return stafiStorage.getUint(keccak256(abi.encodePacked(_key))); }
369     function getStringS(string memory _key) internal view returns (string memory) { return stafiStorage.getString(keccak256(abi.encodePacked(_key))); }
370     function getBytesS(string memory _key) internal view returns (bytes memory) { return stafiStorage.getBytes(keccak256(abi.encodePacked(_key))); }
371     function getBoolS(string memory _key) internal view returns (bool) { return stafiStorage.getBool(keccak256(abi.encodePacked(_key))); }
372     function getIntS(string memory _key) internal view returns (int256) { return stafiStorage.getInt(keccak256(abi.encodePacked(_key))); }
373     function getBytes32S(string memory _key) internal view returns (bytes32) { return stafiStorage.getBytes32(keccak256(abi.encodePacked(_key))); }
374 
375     /// @dev Storage set methods
376     function setAddress(bytes32 _key, address _value) internal { stafiStorage.setAddress(_key, _value); }
377     function setUint(bytes32 _key, uint256 _value) internal { stafiStorage.setUint(_key, _value); }
378     function setString(bytes32 _key, string memory _value) internal { stafiStorage.setString(_key, _value); }
379     function setBytes(bytes32 _key, bytes memory _value) internal { stafiStorage.setBytes(_key, _value); }
380     function setBool(bytes32 _key, bool _value) internal { stafiStorage.setBool(_key, _value); }
381     function setInt(bytes32 _key, int256 _value) internal { stafiStorage.setInt(_key, _value); }
382     function setBytes32(bytes32 _key, bytes32 _value) internal { stafiStorage.setBytes32(_key, _value); }
383     function setAddressS(string memory _key, address _value) internal { stafiStorage.setAddress(keccak256(abi.encodePacked(_key)), _value); }
384     function setUintS(string memory _key, uint256 _value) internal { stafiStorage.setUint(keccak256(abi.encodePacked(_key)), _value); }
385     function setStringS(string memory _key, string memory _value) internal { stafiStorage.setString(keccak256(abi.encodePacked(_key)), _value); }
386     function setBytesS(string memory _key, bytes memory _value) internal { stafiStorage.setBytes(keccak256(abi.encodePacked(_key)), _value); }
387     function setBoolS(string memory _key, bool _value) internal { stafiStorage.setBool(keccak256(abi.encodePacked(_key)), _value); }
388     function setIntS(string memory _key, int256 _value) internal { stafiStorage.setInt(keccak256(abi.encodePacked(_key)), _value); }
389     function setBytes32S(string memory _key, bytes32 _value) internal { stafiStorage.setBytes32(keccak256(abi.encodePacked(_key)), _value); }
390 
391     /// @dev Storage delete methods
392     function deleteAddress(bytes32 _key) internal { stafiStorage.deleteAddress(_key); }
393     function deleteUint(bytes32 _key) internal { stafiStorage.deleteUint(_key); }
394     function deleteString(bytes32 _key) internal { stafiStorage.deleteString(_key); }
395     function deleteBytes(bytes32 _key) internal { stafiStorage.deleteBytes(_key); }
396     function deleteBool(bytes32 _key) internal { stafiStorage.deleteBool(_key); }
397     function deleteInt(bytes32 _key) internal { stafiStorage.deleteInt(_key); }
398     function deleteBytes32(bytes32 _key) internal { stafiStorage.deleteBytes32(_key); }
399     function deleteAddressS(string memory _key) internal { stafiStorage.deleteAddress(keccak256(abi.encodePacked(_key))); }
400     function deleteUintS(string memory _key) internal { stafiStorage.deleteUint(keccak256(abi.encodePacked(_key))); }
401     function deleteStringS(string memory _key) internal { stafiStorage.deleteString(keccak256(abi.encodePacked(_key))); }
402     function deleteBytesS(string memory _key) internal { stafiStorage.deleteBytes(keccak256(abi.encodePacked(_key))); }
403     function deleteBoolS(string memory _key) internal { stafiStorage.deleteBool(keccak256(abi.encodePacked(_key))); }
404     function deleteIntS(string memory _key) internal { stafiStorage.deleteInt(keccak256(abi.encodePacked(_key))); }
405     function deleteBytes32S(string memory _key) internal { stafiStorage.deleteBytes32(keccak256(abi.encodePacked(_key))); }
406 
407 
408     /**
409     * @dev Check if an address has this role
410     */
411     function roleHas(string memory _role, address _address) internal view returns (bool) {
412         return getBool(keccak256(abi.encodePacked("access.role", _role, _address)));
413     }
414 
415 }
416 
417 
418 // receive priority fee
419 contract StafiSuperNodeFeePool is StafiBase, IStafiFeePool {
420 
421     // Libs
422     using SafeMath for uint256;
423 
424     // Events
425     event EtherWithdrawn(string indexed by, address indexed to, uint256 amount, uint256 time);
426 
427     // Construct
428     constructor(address _stafiStorageAddress) StafiBase(_stafiStorageAddress) {
429         // Version
430         version = 1;
431     }
432 
433     // Allow receiving ETH
434     receive() payable external {}
435 
436     // Withdraws ETH to given address
437     // Only accepts calls from network contracts
438     function withdrawEther(address _to, uint256 _amount) override external onlyLatestNetworkContract {
439         // Valid amount?
440         require(_amount > 0, "No valid amount of ETH given to withdraw");
441         // Get contract name
442         string memory contractName = getContractName(msg.sender);
443         // Send the ETH
444         (bool result,) = _to.call{value: _amount}("");
445         require(result, "Failed to withdraw ETH");
446         // Emit ether withdrawn event
447         emit EtherWithdrawn(contractName, _to, _amount, block.timestamp);
448     }
449 }