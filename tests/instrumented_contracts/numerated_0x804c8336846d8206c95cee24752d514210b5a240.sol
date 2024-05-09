1 pragma solidity 0.4.25;
2 
3 
4 /**
5  * @title Ownable
6  * @dev The Ownable contract has an owner address, and provides basic authorization control
7  * functions, this simplifies the implementation of "user permissions".
8  */
9 contract Ownable {
10   address private _owner;
11 
12   event OwnershipTransferred(
13     address indexed previousOwner,
14     address indexed newOwner
15   );
16 
17   /**
18    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
19    * account.
20    */
21   constructor() internal {
22     _owner = msg.sender;
23     emit OwnershipTransferred(address(0), _owner);
24   }
25 
26   /**
27    * @return the address of the owner.
28    */
29   function owner() public view returns(address) {
30     return _owner;
31   }
32 
33   /**
34    * @dev Throws if called by any account other than the owner.
35    */
36   modifier onlyOwner() {
37     require(isOwner());
38     _;
39   }
40 
41   /**
42    * @return true if `msg.sender` is the owner of the contract.
43    */
44   function isOwner() public view returns(bool) {
45     return msg.sender == _owner;
46   }
47 
48   /**
49    * @dev Allows the current owner to relinquish control of the contract.
50    * @notice Renouncing to ownership will leave the contract without an owner.
51    * It will not be possible to call the functions with the `onlyOwner`
52    * modifier anymore.
53    */
54   function renounceOwnership() public onlyOwner {
55     emit OwnershipTransferred(_owner, address(0));
56     _owner = address(0);
57   }
58 
59   /**
60    * @dev Allows the current owner to transfer control of the contract to a newOwner.
61    * @param newOwner The address to transfer ownership to.
62    */
63   function transferOwnership(address newOwner) public onlyOwner {
64     _transferOwnership(newOwner);
65   }
66 
67   /**
68    * @dev Transfers control of the contract to a newOwner.
69    * @param newOwner The address to transfer ownership to.
70    */
71   function _transferOwnership(address newOwner) internal {
72     require(newOwner != address(0));
73     emit OwnershipTransferred(_owner, newOwner);
74     _owner = newOwner;
75   }
76 }
77 
78 
79 interface IOrbsNetworkTopology {
80 
81     /// @dev returns an array of pairs with node addresses and ip addresses.
82     function getNetworkTopology()
83         external
84         view
85         returns (bytes20[] nodeAddresses, bytes4[] ipAddresses);
86 }
87 
88 
89 interface IOrbsValidators {
90 
91     event ValidatorApproved(address indexed validator);
92     event ValidatorRemoved(address indexed validator);
93 
94     /// @dev Adds a validator to participate in network
95     /// @param validator address The address of the validators.
96     function approve(address validator) external;
97 
98     /// @dev Remove a validator from the List based on Guardians votes.
99     /// @param validator address The address of the validators.
100     function remove(address validator) external;
101 
102     /// @dev returns if an address belongs to the approved list & exists in the validators metadata registration database.
103     /// @param validator address The address of the validators.
104     function isValidator(address validator) external view returns (bool);
105 
106     /// @dev returns if an address belongs to the approved list
107     /// @param validator address The address of the validators.
108     function isApproved(address validator) external view returns (bool);
109 
110     /// @dev returns a list of all validators that have been approved and exist in the validator registration database.
111     function getValidators() external view returns (address[]);
112 
113     /// @dev returns a list of all validators that have been approved and exist in the validator registration
114     ///      database. same as getValidators but returns addresses represented as byte20.
115     function getValidatorsBytes20() external view returns (bytes20[]);
116 
117     /// @dev returns the block number in which the validator was approved.
118     /// @param validator address The address of the validators.
119     function getApprovalBlockNumber(address validator)
120         external
121         view
122         returns (uint);
123 }
124 
125 
126 interface IOrbsValidatorsRegistry {
127 
128     event ValidatorLeft(address indexed validator);
129     event ValidatorRegistered(address indexed validator);
130     event ValidatorUpdated(address indexed validator);
131 
132     /// @dev register a validator and provide registration data.
133     /// the new validator entry will be owned and identified by msg.sender.
134     /// if msg.sender is already registered as a validator in this registry the
135     /// transaction will fail.
136     /// @param name string The name of the validator
137     /// @param ipAddress bytes4 The validator node ip address. If another validator previously registered this ipAddress the transaction will fail
138     /// @param website string The website of the validator
139     /// @param orbsAddress bytes20 The validator node orbs public address. If another validator previously registered this orbsAddress the transaction will fail
140     function register(
141         string name,
142         bytes4 ipAddress,
143         string website,
144         bytes20 orbsAddress
145     )
146         external;
147 
148     /// @dev update the validator registration data entry associated with msg.sender.
149     /// msg.sender must be registered in this registry contract.
150     /// @param name string The name of the validator
151     /// @param ipAddress bytes4 The validator node ip address. If another validator previously registered this ipAddress the transaction will fail
152     /// @param website string The website of the validator
153     /// @param orbsAddress bytes20 The validator node orbs public address. If another validator previously registered this orbsAddress the transaction will fail
154     function update(
155         string name,
156         bytes4 ipAddress,
157         string website,
158         bytes20 orbsAddress
159     )
160         external;
161 
162     /// @dev deletes a validator registration entry associated with msg.sender.
163     function leave() external;
164 
165     /// @dev returns validator registration data.
166     /// @param validator address address of the validator.
167     function getValidatorData(address validator)
168         external
169         view
170         returns (
171             string name,
172             bytes4 ipAddress,
173             string website,
174             bytes20 orbsAddress
175         );
176 
177     /// @dev returns the blocks in which a validator was registered and last updated.
178     /// if validator does not designate a registered validator this method returns zero values.
179     /// @param validator address of a validator
180     function getRegistrationBlockNumber(address validator)
181         external
182         view
183         returns (uint registeredOn, uint lastUpdatedOn);
184 
185     /// @dev Checks if validator is currently registered as a validator.
186     /// @param validator address address of the validator
187     /// @return true iff validator belongs to a registered validator
188     function isValidator(address validator) external view returns (bool);
189 
190     /// @dev returns the orbs node public address of a specific validator.
191     /// @param validator address address of the validator
192     /// @return an Orbs node address
193     function getOrbsAddress(address validator)
194         external
195         view
196         returns (bytes20 orbsAddress);
197 }
198 
199 
200 contract OrbsValidators is Ownable, IOrbsValidators, IOrbsNetworkTopology {
201 
202     // The version of the current Validators smart contract.
203     uint public constant VERSION = 1;
204 
205     // Maximum number of validators.
206     uint internal constant MAX_VALIDATOR_LIMIT = 100;
207     uint public validatorsLimit;
208 
209     // The validators metadata registration database smart contract
210     IOrbsValidatorsRegistry public orbsValidatorsRegistry;
211 
212     // Array of approved validators addresses
213     address[] internal approvedValidators;
214 
215     // Mapping of address and in which block it was approved.
216     mapping(address => uint) internal approvalBlockNumber;
217 
218     /// @dev Constructor that initializes the validators smart contract with the validators metadata registration
219     ///     database smart contract.
220     /// @param registry_ IOrbsValidatorsRegistry The address of the validators metadata registration database.
221     /// @param validatorsLimit_ uint Maximum number of validators list maximum size.
222     constructor(IOrbsValidatorsRegistry registry_, uint validatorsLimit_) public {
223         require(registry_ != IOrbsValidatorsRegistry(0), "Registry contract address 0");
224         require(validatorsLimit_ > 0, "Limit must be positive");
225         require(validatorsLimit_ <= MAX_VALIDATOR_LIMIT, "Limit is too high");
226 
227         validatorsLimit = validatorsLimit_;
228         orbsValidatorsRegistry = registry_;
229     }
230 
231     /// @dev Adds a validator to participate in network
232     /// @param validator address The address of the validators.
233     function approve(address validator) external onlyOwner {
234         require(validator != address(0), "Address must not be 0!");
235         require(approvedValidators.length < validatorsLimit, "Can't add more members!");
236         require(!isApproved(validator), "Address must not be already approved");
237 
238         approvedValidators.push(validator);
239         approvalBlockNumber[validator] = block.number;
240         emit ValidatorApproved(validator);
241     }
242 
243     /// @dev Remove a validator from the List based on Guardians votes.
244     /// @param validator address The address of the validators.
245     function remove(address validator) external onlyOwner {
246         require(isApproved(validator), "Not an approved validator");
247 
248         uint approvedLength = approvedValidators.length;
249         for (uint i = 0; i < approvedLength; ++i) {
250             if (approvedValidators[i] == validator) {
251 
252                 // Replace with last element and remove from end
253                 approvedValidators[i] = approvedValidators[approvedLength - 1];
254                 approvedValidators.length--;
255 
256                 // Clear approval block height
257                 delete approvalBlockNumber[validator];
258 
259                 emit ValidatorRemoved(validator);
260                 return;
261             }
262         }
263     }
264 
265     /// @dev returns if an address belongs to the approved list & exists in the validators metadata registration database.
266     /// @param validator address The address of the validators.
267     function isValidator(address validator) public view returns (bool) {
268         return isApproved(validator) && orbsValidatorsRegistry.isValidator(validator);
269     }
270 
271     /// @dev returns if an address belongs to the approved list
272     /// @param validator address The address of the validators.
273     function isApproved(address validator) public view returns (bool) {
274         return approvalBlockNumber[validator] > 0;
275     }
276 
277     /// @dev returns a list of all validators that have been approved and exist in the validator registration database.
278     function getValidators() public view returns (address[] memory) {
279         uint approvedLength = approvedValidators.length;
280         address[] memory validators = new address[](approvedLength);
281 
282         uint pushAt = 0;
283         for (uint i = 0; i < approvedLength; i++) {
284             if (orbsValidatorsRegistry.isValidator(approvedValidators[i])) {
285                 validators[pushAt] = approvedValidators[i];
286                 pushAt++;
287             }
288         }
289 
290         return sliceArray(validators, pushAt);
291     }
292 
293     /// @dev returns a list of all validators that have been approved and exist in the validator registration
294     ///      database. same as getValidators but returns addresses represented as byte20.
295     function getValidatorsBytes20() external view returns (bytes20[]) {
296         address[] memory validatorAddresses = getValidators();
297         uint validatorAddressesLength = validatorAddresses.length;
298 
299         bytes20[] memory result = new bytes20[](validatorAddressesLength);
300 
301         for (uint i = 0; i < validatorAddressesLength; i++) {
302             result[i] = bytes20(validatorAddresses[i]);
303         }
304 
305         return result;
306     }
307 
308     /// @dev returns the block number in which the validator was approved.
309     /// @param validator address The address of the validators.
310     function getApprovalBlockNumber(address validator)
311         public
312         view
313         returns (uint)
314     {
315         return approvalBlockNumber[validator];
316     }
317 
318     /// @dev returns an array of pairs with node addresses and ip addresses.
319     function getNetworkTopology()
320         external
321         view
322         returns (bytes20[] memory nodeAddresses, bytes4[] memory ipAddresses)
323     {
324         address[] memory validators = getValidators(); // filter unregistered
325         uint validatorsLength = validators.length;
326         nodeAddresses = new bytes20[](validatorsLength);
327         ipAddresses = new bytes4[](validatorsLength);
328 
329         for (uint i = 0; i < validatorsLength; i++) {
330             bytes4 ip;
331             bytes20 orbsAddr;
332             ( , ip , , orbsAddr) = orbsValidatorsRegistry.getValidatorData(validators[i]);
333             nodeAddresses[i] = orbsAddr;
334             ipAddresses[i] = ip;
335         }
336     }
337 
338     /// @dev internal method that returns a slice of an array.
339     function sliceArray(address[] memory arr, uint len)
340         internal
341         pure
342         returns (address[] memory)
343     {
344         require(len <= arr.length, "sub array must be longer then array");
345 
346         address[] memory result = new address[](len);
347         for(uint i = 0; i < len; i++) {
348             result[i] = arr[i];
349         }
350         return result;
351     }
352 }