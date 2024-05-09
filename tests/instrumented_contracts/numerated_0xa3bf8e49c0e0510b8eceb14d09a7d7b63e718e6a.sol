1 pragma solidity ^0.4.21;
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
18     function getAddress(bytes32 _contractName) public view returns (address);
19 }
20 
21 /*
22     Utilities & Common Modifiers
23 */
24 contract Utils {
25     /**
26         constructor
27     */
28     function Utils() public {
29     }
30 
31     // verifies that an amount is greater than zero
32     modifier greaterThanZero(uint256 _amount) {
33         require(_amount > 0);
34         _;
35     }
36 
37     // validates an address - currently only checks that it isn't null
38     modifier validAddress(address _address) {
39         require(_address != address(0));
40         _;
41     }
42 
43     // verifies that the address is different than this contract address
44     modifier notThis(address _address) {
45         require(_address != address(this));
46         _;
47     }
48 
49     // Overflow protected math functions
50 
51     /**
52         @dev returns the sum of _x and _y, asserts if the calculation overflows
53 
54         @param _x   value 1
55         @param _y   value 2
56 
57         @return sum
58     */
59     function safeAdd(uint256 _x, uint256 _y) internal pure returns (uint256) {
60         uint256 z = _x + _y;
61         assert(z >= _x);
62         return z;
63     }
64 
65     /**
66         @dev returns the difference of _x minus _y, asserts if the subtraction results in a negative number
67 
68         @param _x   minuend
69         @param _y   subtrahend
70 
71         @return difference
72     */
73     function safeSub(uint256 _x, uint256 _y) internal pure returns (uint256) {
74         assert(_x >= _y);
75         return _x - _y;
76     }
77 
78     /**
79         @dev returns the product of multiplying _x by _y, asserts if the calculation overflows
80 
81         @param _x   factor 1
82         @param _y   factor 2
83 
84         @return product
85     */
86     function safeMul(uint256 _x, uint256 _y) internal pure returns (uint256) {
87         uint256 z = _x * _y;
88         assert(_x == 0 || z / _x == _y);
89         return z;
90     }
91 }
92 
93 /*
94     Provides support and utilities for contract ownership
95 */
96 contract Owned is IOwned {
97     address public owner;
98     address public newOwner;
99 
100     event OwnerUpdate(address indexed _prevOwner, address indexed _newOwner);
101 
102     /**
103         @dev constructor
104     */
105     function Owned() public {
106         owner = msg.sender;
107     }
108 
109     // allows execution by the owner only
110     modifier ownerOnly {
111         assert(msg.sender == owner);
112         _;
113     }
114 
115     /**
116         @dev allows transferring the contract ownership
117         the new owner still needs to accept the transfer
118         can only be called by the contract owner
119 
120         @param _newOwner    new contract owner
121     */
122     function transferOwnership(address _newOwner) public ownerOnly {
123         require(_newOwner != owner);
124         newOwner = _newOwner;
125     }
126 
127     /**
128         @dev used by a new owner to accept an ownership transfer
129     */
130     function acceptOwnership() public {
131         require(msg.sender == newOwner);
132         emit OwnerUpdate(owner, newOwner);
133         owner = newOwner;
134         newOwner = address(0);
135     }
136 }
137 
138 /**
139     Contract Registry
140 
141     The contract registry keeps contract addresses by name.
142     The owner can update contract addresses so that a contract name always points to the latest version
143     of the given contract.
144     Other contracts can query the registry to get updated addresses instead of depending on specific
145     addresses.
146 
147     Note that contract names are limited to 32 bytes UTF8 strings to optimize gas costs
148 */
149 contract ContractRegistry is IContractRegistry, Owned, Utils {
150     struct RegistryItem {
151         address contractAddress;
152         uint256 nameIndex;
153         bool isSet;
154     }
155 
156     mapping (bytes32 => RegistryItem) private items;    // name -> address mapping
157     bytes32[] public names;                             // list of all registered contract names
158 
159     event AddressUpdate(bytes32 indexed _contractName, address _contractAddress);
160 
161     /**
162         @dev constructor
163     */
164     function ContractRegistry() public {
165     }
166 
167     /**
168         @dev returns the address associated with the given contract name
169 
170         @param _contractName    contract name
171 
172         @return contract address
173     */
174     function getAddress(bytes32 _contractName) public view returns (address) {
175         return items[_contractName].contractAddress;
176     }
177 
178     /**
179         @dev registers a new address for the contract name in the registry
180 
181        @param _contractName     contract name
182        @param _contractAddress  contract address
183     */
184     function registerAddress(bytes32 _contractName, address _contractAddress)
185         public
186         ownerOnly
187         validAddress(_contractAddress)
188     {
189         require(_contractName.length > 0); // validate input
190 
191         // update the address in the registry
192         items[_contractName].contractAddress = _contractAddress;
193         
194         if (!items[_contractName].isSet) {
195             // mark the item as set
196             items[_contractName].isSet = true;
197             // add the contract name to the name list and update the item's index in the list
198             items[_contractName].nameIndex = names.push(_contractName) - 1;
199         }
200 
201         // dispatch the address update event
202         emit AddressUpdate(_contractName, _contractAddress);
203     }
204 
205     /**
206         @dev removes an existing contract address from the registry
207 
208        @param _contractName contract name
209     */
210     function unregisterAddress(bytes32 _contractName) public ownerOnly {
211         require(_contractName.length > 0); // validate input
212 
213         // remove the address from the registry
214         items[_contractName].contractAddress = address(0);
215 
216         if (items[_contractName].isSet) {
217             // mark the item as empty
218             items[_contractName].isSet = false;
219             // move the last element to the deleted element's position
220             names[items[_contractName].nameIndex] = names[names.length - 1];
221             // remove the last element from the name list
222             names.length--;
223             // zero the deleted element's index
224             items[_contractName].nameIndex = 0;
225         }
226 
227         // dispatch the address update event
228         emit AddressUpdate(_contractName, address(0));
229     }
230 }