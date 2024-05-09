1 pragma solidity ^0.4.24;
2 
3 /*
4     Owned contract interface
5 */
6 contract IOwned {
7     // this function isn't abstract since the compiler emits automatically generated getter functions as external
8     function owner() public view returns (address) {}
9 
10     function transferOwnership(address _newOwner) public;
11     function acceptOwnership() public;
12 }
13 
14 /*
15     Provides support and utilities for contract ownership
16 */
17 contract Owned is IOwned {
18     address public owner;
19     address public newOwner;
20 
21     event OwnerUpdate(address indexed _prevOwner, address indexed _newOwner);
22 
23     /**
24         @dev constructor
25     */
26     constructor() public {
27         owner = msg.sender;
28     }
29 
30     // allows execution by the owner only
31     modifier ownerOnly {
32         require(msg.sender == owner);
33         _;
34     }
35 
36     /**
37         @dev allows transferring the contract ownership
38         the new owner still needs to accept the transfer
39         can only be called by the contract owner
40 
41         @param _newOwner    new contract owner
42     */
43     function transferOwnership(address _newOwner) public ownerOnly {
44         require(_newOwner != owner);
45         newOwner = _newOwner;
46     }
47 
48     /**
49         @dev used by a new owner to accept an ownership transfer
50     */
51     function acceptOwnership() public {
52         require(msg.sender == newOwner);
53         emit OwnerUpdate(owner, newOwner);
54         owner = newOwner;
55         newOwner = address(0);
56     }
57 }
58 
59 /*
60     Utilities & Common Modifiers
61 */
62 contract Utils {
63     /**
64         constructor
65     */
66     constructor() public {
67     }
68 
69     // verifies that an amount is greater than zero
70     modifier greaterThanZero(uint256 _amount) {
71         require(_amount > 0);
72         _;
73     }
74 
75     // validates an address - currently only checks that it isn't null
76     modifier validAddress(address _address) {
77         require(_address != address(0));
78         _;
79     }
80 
81     // verifies that the address is different than this contract address
82     modifier notThis(address _address) {
83         require(_address != address(this));
84         _;
85     }
86 
87     // Overflow protected math functions
88 
89     /**
90         @dev returns the sum of _x and _y, asserts if the calculation overflows
91 
92         @param _x   value 1
93         @param _y   value 2
94 
95         @return sum
96     */
97     function safeAdd(uint256 _x, uint256 _y) internal pure returns (uint256) {
98         uint256 z = _x + _y;
99         assert(z >= _x);
100         return z;
101     }
102 
103     /**
104         @dev returns the difference of _x minus _y, asserts if the subtraction results in a negative number
105 
106         @param _x   minuend
107         @param _y   subtrahend
108 
109         @return difference
110     */
111     function safeSub(uint256 _x, uint256 _y) internal pure returns (uint256) {
112         assert(_x >= _y);
113         return _x - _y;
114     }
115 
116     /**
117         @dev returns the product of multiplying _x by _y, asserts if the calculation overflows
118 
119         @param _x   factor 1
120         @param _y   factor 2
121 
122         @return product
123     */
124     function safeMul(uint256 _x, uint256 _y) internal pure returns (uint256) {
125         uint256 z = _x * _y;
126         assert(_x == 0 || z / _x == _y);
127         return z;
128     }
129 }
130 
131 /**
132     Id definitions for bancor contracts
133 
134     Can be used in conjunction with the contract registry to get contract addresses
135 */
136 contract ContractIds {
137     // generic
138     bytes32 public constant CONTRACT_FEATURES = "ContractFeatures";
139     bytes32 public constant CONTRACT_REGISTRY = "ContractRegistry";
140 
141     // bancor logic
142     bytes32 public constant BANCOR_NETWORK = "BancorNetwork";
143     bytes32 public constant BANCOR_FORMULA = "BancorFormula";
144     bytes32 public constant BANCOR_GAS_PRICE_LIMIT = "BancorGasPriceLimit";
145     bytes32 public constant BANCOR_CONVERTER_UPGRADER = "BancorConverterUpgrader";
146     bytes32 public constant BANCOR_CONVERTER_FACTORY = "BancorConverterFactory";
147 
148     // Ids of BNT converter and BNT token
149     bytes32 public constant BNT_TOKEN = "BNTToken";
150     bytes32 public constant BNT_CONVERTER = "BNTConverter";
151 
152     // Id of BancorX contract
153     bytes32 public constant BANCOR_X = "BancorX";
154 }
155 
156 /*
157     Contract Registry interface
158 */
159 contract IContractRegistry {
160     function addressOf(bytes32 _contractName) public view returns (address);
161 
162     // deprecated, backward compatibility
163     function getAddress(bytes32 _contractName) public view returns (address);
164 }
165 
166 /**
167     Contract Registry
168 
169     The contract registry keeps contract addresses by name.
170     The owner can update contract addresses so that a contract name always points to the latest version
171     of the given contract.
172     Other contracts can query the registry to get updated addresses instead of depending on specific
173     addresses.
174 
175     Note that contract names are limited to 32 bytes UTF8 encoded ASCII strings to optimize gas costs
176 */
177 contract ContractRegistry is IContractRegistry, Owned, Utils, ContractIds {
178     struct RegistryItem {
179         address contractAddress;    // contract address
180         uint256 nameIndex;          // index of the item in the list of contract names
181         bool isSet;                 // used to tell if the mapping element is defined
182     }
183 
184     mapping (bytes32 => RegistryItem) private items;    // name -> RegistryItem mapping
185     string[] public contractNames;                      // list of all registered contract names
186 
187     // triggered when an address pointed to by a contract name is modified
188     event AddressUpdate(bytes32 indexed _contractName, address _contractAddress);
189 
190     /**
191         @dev constructor
192     */
193     constructor() public {
194         registerAddress(ContractIds.CONTRACT_REGISTRY, address(this));
195     }
196 
197     /**
198         @dev returns the number of items in the registry
199 
200         @return number of items
201     */
202     function itemCount() public view returns (uint256) {
203         return contractNames.length;
204     }
205 
206     /**
207         @dev returns the address associated with the given contract name
208 
209         @param _contractName    contract name
210 
211         @return contract address
212     */
213     function addressOf(bytes32 _contractName) public view returns (address) {
214         return items[_contractName].contractAddress;
215     }
216 
217     /**
218         @dev registers a new address for the contract name in the registry
219 
220         @param _contractName     contract name
221         @param _contractAddress  contract address
222     */
223     function registerAddress(bytes32 _contractName, address _contractAddress)
224         public
225         ownerOnly
226         validAddress(_contractAddress)
227     {
228         require(_contractName.length > 0); // validate input
229 
230         // update the address in the registry
231         items[_contractName].contractAddress = _contractAddress;
232 
233         if (!items[_contractName].isSet) {
234             // mark the item as set
235             items[_contractName].isSet = true;
236             // add the contract name to the name list
237             uint256 i = contractNames.push(bytes32ToString(_contractName));
238             // update the item's index in the list
239             items[_contractName].nameIndex = i - 1;
240         }
241 
242         // dispatch the address update event
243         emit AddressUpdate(_contractName, _contractAddress);
244     }
245 
246     /**
247         @dev removes an existing contract address from the registry
248 
249         @param _contractName contract name
250     */
251     function unregisterAddress(bytes32 _contractName) public ownerOnly {
252         require(_contractName.length > 0); // validate input
253 
254         // remove the address from the registry
255         items[_contractName].contractAddress = address(0);
256 
257         // if there are multiple items in the registry, move the last element to the deleted element's position
258         // and modify last element's registryItem.nameIndex in the items collection to point to the right position in contractNames
259         if (contractNames.length > 1) {
260             string memory lastContractNameString = contractNames[contractNames.length - 1];
261             uint256 unregisterIndex = items[_contractName].nameIndex;
262 
263             contractNames[unregisterIndex] = lastContractNameString;
264             bytes32 lastContractName = stringToBytes32(lastContractNameString);
265             RegistryItem storage registryItem = items[lastContractName];
266             registryItem.nameIndex = unregisterIndex;
267         }
268 
269         // remove the last element from the name list
270         contractNames.length--;
271         // zero the deleted element's index
272         items[_contractName].nameIndex = 0;
273 
274         // dispatch the address update event
275         emit AddressUpdate(_contractName, address(0));
276     }
277 
278     /**
279         @dev utility, converts bytes32 to a string
280         note that the bytes32 argument is assumed to be UTF8 encoded ASCII string
281 
282         @return string representation of the given bytes32 argument
283     */
284     function bytes32ToString(bytes32 _bytes) private pure returns (string) {
285         bytes memory byteArray = new bytes(32);
286         for (uint256 i; i < 32; i++) {
287             byteArray[i] = _bytes[i];
288         }
289 
290         return string(byteArray);
291     }
292 
293     // @dev utility, converts string to bytes32
294     function stringToBytes32(string memory _string) private pure returns (bytes32) {
295         bytes32 result;
296         assembly {
297             result := mload(add(_string,32))
298         }
299         return result;
300     }
301 
302     // deprecated, backward compatibility
303     function getAddress(bytes32 _contractName) public view returns (address) {
304         return addressOf(_contractName);
305     }
306 }