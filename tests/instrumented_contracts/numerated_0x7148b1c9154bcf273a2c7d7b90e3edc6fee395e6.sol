1 pragma solidity ^0.4.23;
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
15     Contract Registry interface
16 */
17 contract IContractRegistry {
18     function addressOf(bytes32 _contractName) public view returns (address);
19 
20     // deprecated, backward compatibility
21     function getAddress(bytes32 _contractName) public view returns (address);
22 }
23 
24 /*
25     Utilities & Common Modifiers
26 */
27 contract Utils {
28     /**
29         constructor
30     */
31     constructor() public {
32     }
33 
34     // verifies that an amount is greater than zero
35     modifier greaterThanZero(uint256 _amount) {
36         require(_amount > 0);
37         _;
38     }
39 
40     // validates an address - currently only checks that it isn't null
41     modifier validAddress(address _address) {
42         require(_address != address(0));
43         _;
44     }
45 
46     // verifies that the address is different than this contract address
47     modifier notThis(address _address) {
48         require(_address != address(this));
49         _;
50     }
51 
52     // Overflow protected math functions
53 
54     /**
55         @dev returns the sum of _x and _y, asserts if the calculation overflows
56 
57         @param _x   value 1
58         @param _y   value 2
59 
60         @return sum
61     */
62     function safeAdd(uint256 _x, uint256 _y) internal pure returns (uint256) {
63         uint256 z = _x + _y;
64         assert(z >= _x);
65         return z;
66     }
67 
68     /**
69         @dev returns the difference of _x minus _y, asserts if the subtraction results in a negative number
70 
71         @param _x   minuend
72         @param _y   subtrahend
73 
74         @return difference
75     */
76     function safeSub(uint256 _x, uint256 _y) internal pure returns (uint256) {
77         assert(_x >= _y);
78         return _x - _y;
79     }
80 
81     /**
82         @dev returns the product of multiplying _x by _y, asserts if the calculation overflows
83 
84         @param _x   factor 1
85         @param _y   factor 2
86 
87         @return product
88     */
89     function safeMul(uint256 _x, uint256 _y) internal pure returns (uint256) {
90         uint256 z = _x * _y;
91         assert(_x == 0 || z / _x == _y);
92         return z;
93     }
94 }
95 
96 /*
97     Provides support and utilities for contract ownership
98 */
99 contract Owned is IOwned {
100     address public owner;
101     address public newOwner;
102 
103     event OwnerUpdate(address indexed _prevOwner, address indexed _newOwner);
104 
105     /**
106         @dev constructor
107     */
108     constructor() public {
109         owner = msg.sender;
110     }
111 
112     // allows execution by the owner only
113     modifier ownerOnly {
114         assert(msg.sender == owner);
115         _;
116     }
117 
118     /**
119         @dev allows transferring the contract ownership
120         the new owner still needs to accept the transfer
121         can only be called by the contract owner
122 
123         @param _newOwner    new contract owner
124     */
125     function transferOwnership(address _newOwner) public ownerOnly {
126         require(_newOwner != owner);
127         newOwner = _newOwner;
128     }
129 
130     /**
131         @dev used by a new owner to accept an ownership transfer
132     */
133     function acceptOwnership() public {
134         require(msg.sender == newOwner);
135         emit OwnerUpdate(owner, newOwner);
136         owner = newOwner;
137         newOwner = address(0);
138     }
139 }
140 
141 /**
142     Contract Registry
143 
144     The contract registry keeps contract addresses by name.
145     The owner can update contract addresses so that a contract name always points to the latest version
146     of the given contract.
147     Other contracts can query the registry to get updated addresses instead of depending on specific
148     addresses.
149 
150     Note that contract names are limited to 32 bytes UTF8 encoded ASCII strings to optimize gas costs
151 */
152 contract ContractRegistry is IContractRegistry, Owned, Utils {
153     struct RegistryItem {
154         address contractAddress;    // contract address
155         uint256 nameIndex;          // index of the item in the list of contract names
156         bool isSet;                 // used to tell if the mapping element is defined
157     }
158 
159     mapping (bytes32 => RegistryItem) private items;    // name -> RegistryItem mapping
160     string[] public contractNames;                      // list of all registered contract names
161 
162     // triggered when an address pointed to by a contract name is modified
163     event AddressUpdate(bytes32 indexed _contractName, address _contractAddress);
164 
165     /**
166         @dev constructor
167     */
168     constructor() public {
169     }
170 
171     /**
172         @dev returns the number of items in the registry
173 
174         @return number of items
175     */
176     function itemCount() public view returns (uint256) {
177         return contractNames.length;
178     }
179 
180     /**
181         @dev returns the address associated with the given contract name
182 
183         @param _contractName    contract name
184 
185         @return contract address
186     */
187     function addressOf(bytes32 _contractName) public view returns (address) {
188         return items[_contractName].contractAddress;
189     }
190 
191     /**
192         @dev registers a new address for the contract name in the registry
193 
194         @param _contractName     contract name
195         @param _contractAddress  contract address
196     */
197     function registerAddress(bytes32 _contractName, address _contractAddress)
198         public
199         ownerOnly
200         validAddress(_contractAddress)
201     {
202         require(_contractName.length > 0); // validate input
203 
204         // update the address in the registry
205         items[_contractName].contractAddress = _contractAddress;
206         
207         if (!items[_contractName].isSet) {
208             // mark the item as set
209             items[_contractName].isSet = true;
210             // add the contract name to the name list
211             uint256 i = contractNames.push(bytes32ToString(_contractName));
212             // update the item's index in the list
213             items[_contractName].nameIndex = i - 1;
214         }
215 
216         // dispatch the address update event
217         emit AddressUpdate(_contractName, _contractAddress);
218     }
219 
220     /**
221         @dev removes an existing contract address from the registry
222 
223         @param _contractName contract name
224     */
225     function unregisterAddress(bytes32 _contractName) public ownerOnly {
226         require(_contractName.length > 0); // validate input
227 
228         // remove the address from the registry
229         items[_contractName].contractAddress = address(0);
230 
231         if (items[_contractName].isSet) {
232             // mark the item as empty
233             items[_contractName].isSet = false;
234 
235             // if there are multiple items in the registry, move the last element to the deleted element's position
236             if (contractNames.length > 1)
237                 contractNames[items[_contractName].nameIndex] = contractNames[contractNames.length - 1];
238 
239             // remove the last element from the name list
240             contractNames.length--;
241             // zero the deleted element's index
242             items[_contractName].nameIndex = 0;
243         }
244 
245         // dispatch the address update event
246         emit AddressUpdate(_contractName, address(0));
247     }
248 
249     /**
250         @dev utility, converts bytes32 to a string
251         note that the bytes32 argument is assumed to be UTF8 encoded ASCII string
252 
253         @return string representation of the given bytes32 argument
254     */
255     function bytes32ToString(bytes32 _bytes) private pure returns (string) {
256         bytes memory byteArray = new bytes(32);
257         for (uint256 i; i < 32; i++) {
258             byteArray[i] = _bytes[i];
259         }
260 
261         return string(byteArray);
262     }
263 
264     // deprecated, backward compatibility
265     function getAddress(bytes32 _contractName) public view returns (address) {
266         return addressOf(_contractName);
267     }
268 }