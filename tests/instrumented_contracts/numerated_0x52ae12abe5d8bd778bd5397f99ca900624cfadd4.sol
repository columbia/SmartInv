1 pragma solidity ^0.4.24;
2 
3 // File: contracts/utility/interfaces/IOwned.sol
4 
5 /*
6     Owned contract interface
7 */
8 contract IOwned {
9     // this function isn't abstract since the compiler emits automatically generated getter functions as external
10     function owner() public view returns (address) {}
11 
12     function transferOwnership(address _newOwner) public;
13     function acceptOwnership() public;
14 }
15 
16 // File: contracts/utility/Owned.sol
17 
18 /*
19     Provides support and utilities for contract ownership
20 */
21 contract Owned is IOwned {
22     address public owner;
23     address public newOwner;
24 
25     event OwnerUpdate(address indexed _prevOwner, address indexed _newOwner);
26 
27     /**
28         @dev constructor
29     */
30     constructor() public {
31         owner = msg.sender;
32     }
33 
34     // allows execution by the owner only
35     modifier ownerOnly {
36         require(msg.sender == owner);
37         _;
38     }
39 
40     /**
41         @dev allows transferring the contract ownership
42         the new owner still needs to accept the transfer
43         can only be called by the contract owner
44 
45         @param _newOwner    new contract owner
46     */
47     function transferOwnership(address _newOwner) public ownerOnly {
48         require(_newOwner != owner);
49         newOwner = _newOwner;
50     }
51 
52     /**
53         @dev used by a new owner to accept an ownership transfer
54     */
55     function acceptOwnership() public {
56         require(msg.sender == newOwner);
57         emit OwnerUpdate(owner, newOwner);
58         owner = newOwner;
59         newOwner = address(0);
60     }
61 }
62 
63 // File: contracts/utility/Utils.sol
64 
65 /*
66     Utilities & Common Modifiers
67 */
68 contract Utils {
69     /**
70         constructor
71     */
72     constructor() public {
73     }
74 
75     // verifies that an amount is greater than zero
76     modifier greaterThanZero(uint256 _amount) {
77         require(_amount > 0);
78         _;
79     }
80 
81     // validates an address - currently only checks that it isn't null
82     modifier validAddress(address _address) {
83         require(_address != address(0));
84         _;
85     }
86 
87     // verifies that the address is different than this contract address
88     modifier notThis(address _address) {
89         require(_address != address(this));
90         _;
91     }
92 
93     // Overflow protected math functions
94 
95     /**
96         @dev returns the sum of _x and _y, asserts if the calculation overflows
97 
98         @param _x   value 1
99         @param _y   value 2
100 
101         @return sum
102     */
103     function safeAdd(uint256 _x, uint256 _y) internal pure returns (uint256) {
104         uint256 z = _x + _y;
105         assert(z >= _x);
106         return z;
107     }
108 
109     /**
110         @dev returns the difference of _x minus _y, asserts if the subtraction results in a negative number
111 
112         @param _x   minuend
113         @param _y   subtrahend
114 
115         @return difference
116     */
117     function safeSub(uint256 _x, uint256 _y) internal pure returns (uint256) {
118         assert(_x >= _y);
119         return _x - _y;
120     }
121 
122     /**
123         @dev returns the product of multiplying _x by _y, asserts if the calculation overflows
124 
125         @param _x   factor 1
126         @param _y   factor 2
127 
128         @return product
129     */
130     function safeMul(uint256 _x, uint256 _y) internal pure returns (uint256) {
131         uint256 z = _x * _y;
132         assert(_x == 0 || z / _x == _y);
133         return z;
134     }
135 }
136 
137 // File: contracts/utility/interfaces/IContractRegistry.sol
138 
139 /*
140     Contract Registry interface
141 */
142 contract IContractRegistry {
143     function addressOf(bytes32 _contractName) public view returns (address);
144 
145     // deprecated, backward compatibility
146     function getAddress(bytes32 _contractName) public view returns (address);
147 }
148 
149 // File: contracts/ContractIds.sol
150 
151 /**
152     Id definitions for bancor contracts
153 
154     Can be used in conjunction with the contract registry to get contract addresses
155 */
156 contract ContractIds {
157     // generic
158     bytes32 public constant CONTRACT_FEATURES = "ContractFeatures";
159     bytes32 public constant CONTRACT_REGISTRY = "ContractRegistry";
160 
161     // bancor logic
162     bytes32 public constant BANCOR_NETWORK = "BancorNetwork";
163     bytes32 public constant BANCOR_FORMULA = "BancorFormula";
164     bytes32 public constant BANCOR_GAS_PRICE_LIMIT = "BancorGasPriceLimit";
165     bytes32 public constant BANCOR_CONVERTER_UPGRADER = "BancorConverterUpgrader";
166     bytes32 public constant BANCOR_CONVERTER_FACTORY = "BancorConverterFactory";
167 
168     // Ids of BNT converter and BNT token
169     bytes32 public constant BNT_TOKEN = "BNTToken";
170     bytes32 public constant BNT_CONVERTER = "BNTConverter";
171 
172     // Id of BancorX contract
173     bytes32 public constant BANCOR_X = "BancorX";
174 }
175 
176 // File: contracts/utility/ContractRegistry.sol
177 
178 /**
179     Contract Registry
180 
181     The contract registry keeps contract addresses by name.
182     The owner can update contract addresses so that a contract name always points to the latest version
183     of the given contract.
184     Other contracts can query the registry to get updated addresses instead of depending on specific
185     addresses.
186 
187     Note that contract names are limited to 32 bytes UTF8 encoded ASCII strings to optimize gas costs
188 */
189 contract ContractRegistry is IContractRegistry, Owned, Utils, ContractIds {
190     struct RegistryItem {
191         address contractAddress;    // contract address
192         uint256 nameIndex;          // index of the item in the list of contract names
193         bool isSet;                 // used to tell if the mapping element is defined
194     }
195 
196     mapping (bytes32 => RegistryItem) private items;    // name -> RegistryItem mapping
197     string[] public contractNames;                      // list of all registered contract names
198 
199     // triggered when an address pointed to by a contract name is modified
200     event AddressUpdate(bytes32 indexed _contractName, address _contractAddress);
201 
202     /**
203         @dev constructor
204     */
205     constructor() public {
206         registerAddress(ContractIds.CONTRACT_REGISTRY, address(this));
207     }
208 
209     /**
210         @dev returns the number of items in the registry
211 
212         @return number of items
213     */
214     function itemCount() public view returns (uint256) {
215         return contractNames.length;
216     }
217 
218     /**
219         @dev returns the address associated with the given contract name
220 
221         @param _contractName    contract name
222 
223         @return contract address
224     */
225     function addressOf(bytes32 _contractName) public view returns (address) {
226         return items[_contractName].contractAddress;
227     }
228 
229     /**
230         @dev registers a new address for the contract name in the registry
231 
232         @param _contractName     contract name
233         @param _contractAddress  contract address
234     */
235     function registerAddress(bytes32 _contractName, address _contractAddress)
236         public
237         ownerOnly
238         validAddress(_contractAddress)
239     {
240         require(_contractName.length > 0); // validate input
241 
242         // update the address in the registry
243         items[_contractName].contractAddress = _contractAddress;
244 
245         if (!items[_contractName].isSet) {
246             // mark the item as set
247             items[_contractName].isSet = true;
248             // add the contract name to the name list
249             uint256 i = contractNames.push(bytes32ToString(_contractName));
250             // update the item's index in the list
251             items[_contractName].nameIndex = i - 1;
252         }
253 
254         // dispatch the address update event
255         emit AddressUpdate(_contractName, _contractAddress);
256     }
257 
258     /**
259         @dev removes an existing contract address from the registry
260 
261         @param _contractName contract name
262     */
263     function unregisterAddress(bytes32 _contractName) public ownerOnly {
264         require(_contractName.length > 0); // validate input
265 
266         // remove the address from the registry
267         items[_contractName].contractAddress = address(0);
268 
269         // if there are multiple items in the registry, move the last element to the deleted element's position
270         // and modify last element's registryItem.nameIndex in the items collection to point to the right position in contractNames
271         if (contractNames.length > 1) {
272             string memory lastContractNameString = contractNames[contractNames.length - 1];
273             uint256 unregisterIndex = items[_contractName].nameIndex;
274 
275             contractNames[unregisterIndex] = lastContractNameString;
276             bytes32 lastContractName = stringToBytes32(lastContractNameString);
277             RegistryItem storage registryItem = items[lastContractName];
278             registryItem.nameIndex = unregisterIndex;
279         }
280 
281         // remove the last element from the name list
282         contractNames.length--;
283         // zero the deleted element's index
284         items[_contractName].nameIndex = 0;
285 
286         // dispatch the address update event
287         emit AddressUpdate(_contractName, address(0));
288     }
289 
290     /**
291         @dev utility, converts bytes32 to a string
292         note that the bytes32 argument is assumed to be UTF8 encoded ASCII string
293 
294         @return string representation of the given bytes32 argument
295     */
296     function bytes32ToString(bytes32 _bytes) private pure returns (string) {
297         bytes memory byteArray = new bytes(32);
298         for (uint256 i; i < 32; i++) {
299             byteArray[i] = _bytes[i];
300         }
301 
302         return string(byteArray);
303     }
304 
305     // @dev utility, converts string to bytes32
306     function stringToBytes32(string memory _string) private pure returns (bytes32) {
307         bytes32 result;
308         assembly {
309             result := mload(add(_string,32))
310         }
311         return result;
312     }
313 
314     // deprecated, backward compatibility
315     function getAddress(bytes32 _contractName) public view returns (address) {
316         return addressOf(_contractName);
317     }
318 }