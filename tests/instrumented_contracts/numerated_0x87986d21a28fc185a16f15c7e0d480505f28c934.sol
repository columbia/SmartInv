1 pragma solidity ^0.4.23;
2 
3 // File: contracts/interfaces/ContractManagerInterface.sol
4 
5 /**
6  * @title Contract Manager Interface
7  * @author Bram Hoven
8  * @notice Interface for communicating with the contract manager
9  */
10 interface ContractManagerInterface {
11   /**
12    * @notice Triggered when contract is added
13    * @param _address Address of the new contract
14    * @param _contractName Name of the new contract
15    */
16   event ContractAdded(address indexed _address, string _contractName);
17 
18   /**
19    * @notice Triggered when contract is removed
20    * @param _contractName Name of the contract that is removed
21    */
22   event ContractRemoved(string _contractName);
23 
24   /**
25    * @notice Triggered when contract is updated
26    * @param _oldAddress Address where the contract used to be
27    * @param _newAddress Address where the new contract is deployed
28    * @param _contractName Name of the contract that has been updated
29    */
30   event ContractUpdated(address indexed _oldAddress, address indexed _newAddress, string _contractName);
31 
32   /**
33    * @notice Triggered when authorization status changed
34    * @param _address Address who will gain or lose authorization to _contractName
35    * @param _authorized Boolean whether or not the address is authorized
36    * @param _contractName Name of the contract
37    */
38   event AuthorizationChanged(address indexed _address, bool _authorized, string _contractName);
39 
40   /**
41    * @notice Check whether the accessor is authorized to access that contract
42    * @param _contractName Name of the contract that is being accessed
43    * @param _accessor Address who wants to access that contract
44    */
45   function authorize(string _contractName, address _accessor) external view returns (bool);
46 
47   /**
48    * @notice Add a new contract to the manager
49    * @param _contractName Name of the new contract
50    * @param _address Address of the new contract
51    */
52   function addContract(string _contractName, address _address) external;
53 
54   /**
55    * @notice Get a contract by its name
56    * @param _contractName Name of the contract
57    */
58   function getContract(string _contractName) external view returns (address _contractAddress);
59 
60   /**
61    * @notice Remove an existing contract
62    * @param _contractName Name of the contract that will be removed
63    */
64   function removeContract(string _contractName) external;
65 
66   /**
67    * @notice Update an existing contract (changing the address)
68    * @param _contractName Name of the existing contract
69    * @param _newAddress Address where the new contract is deployed
70    */
71   function updateContract(string _contractName, address _newAddress) external;
72 
73   /**
74    * @notice Change whether an address is authorized to use a specific contract or not
75    * @param _contractName Name of the contract to which the accessor will gain authorization or not
76    * @param _authorizedAddress Address which will have its authorisation status changed
77    * @param _authorized Boolean whether the address will have access or not
78    */
79   function setAuthorizedContract(string _contractName, address _authorizedAddress, bool _authorized) external;
80 }
81 
82 // File: contracts/ContractManager.sol
83 
84 /**
85  * @title Contract Manager
86  * @author Bram Hoven
87  * @notice Contract whom manages every other contract connected to this project and the authorization
88  */
89 contract ContractManager is ContractManagerInterface {
90   // Mapping of all contracts and their name
91   mapping(string => address) private contracts;
92   // Mapping of all contracts and who has access to them
93   mapping(string => mapping(address => bool)) private authorization;
94 
95   /**
96    * @notice Triggered when contract is added
97    * @param _address Address of the new contract
98    * @param _contractName Name of the new contract
99    */
100   event ContractAdded(address indexed _address, string _contractName);
101 
102   /**
103    * @notice Triggered when contract is removed
104    * @param _contractName Name of the contract that is removed
105    */
106   event ContractRemoved(string _contractName);
107 
108   /**
109    * @notice Triggered when contract is updated
110    * @param _oldAddress Address where the contract used to be
111    * @param _newAddress Address where the new contract is deployed
112    * @param _contractName Name of the contract that has been updated
113    */
114   event ContractUpdated(address indexed _oldAddress, address indexed _newAddress, string _contractName);
115 
116   /**
117    * @notice Triggered when authorization status changed
118    * @param _address Address who will gain or lose authorization to _contractName
119    * @param _authorized Boolean whether or not the address is authorized
120    * @param _contractName Name of the contract
121    */
122   event AuthorizationChanged(address indexed _address, bool _authorized, string _contractName);
123 
124   /**
125    * @dev Throws when sender does not match contract name
126    * @param _contractName Name of the contract the sender is checked against
127    */
128   modifier onlyRegisteredContract(string _contractName) {
129     require(contracts[_contractName] == msg.sender);
130     _;
131   }
132 
133   /**
134    * @dev Throws when sender is not owner of contract manager
135    * @param _contractName Name of the contract to check the _accessor against
136    * @param _accessor Address that wants to access this specific contract
137    */
138   modifier onlyContractOwner(string _contractName, address _accessor) {
139     require(contracts[_contractName] == msg.sender || contracts[_contractName] == address(this));
140     require(_accessor != address(0));
141     require(authorization[_contractName][_accessor] == true);
142     _;
143   }
144 
145   /**
146    * @notice Constructor for creating the contract manager
147    */
148   constructor() public {
149     contracts["ContractManager"] = address(this);
150     authorization["ContractManager"][msg.sender] = true;
151   }
152 
153   /**
154    * @notice Check whether the accessor is authorized to access that contract
155    * @param _contractName Name of the contract that is being accessed
156    * @param _accessor Address who wants to access that contract
157    */
158   function authorize(string _contractName, address _accessor) external onlyContractOwner(_contractName, _accessor) view returns (bool) {
159     return true;
160   }
161 
162   /**
163    * @notice Add a new contract to the manager
164    * @param _contractName Name of the new contract
165    * @param _address Address of the new contract
166    */
167   function addContract(string _contractName, address _address) external  onlyContractOwner("ContractManager", msg.sender) {
168     bytes memory contractNameBytes = bytes(_contractName);
169 
170     require(contractNameBytes.length != 0);
171     require(contracts[_contractName] == address(0));
172     require(_address != address(0));
173 
174     contracts[_contractName] = _address;
175 
176     emit ContractAdded(_address, _contractName);
177   }
178 
179   /**
180    * @notice Get a contract by its name
181    * @param _contractName Name of the contract
182    */
183   function getContract(string _contractName) external view returns (address _contractAddress) {
184     require(contracts[_contractName] != address(0));
185 
186     _contractAddress = contracts[_contractName];
187 
188     return _contractAddress;
189   }
190 
191   /**
192    * @notice Remove an existing contract
193    * @param _contractName Name of the contract that will be removed
194    */
195   function removeContract(string _contractName) external onlyContractOwner("ContractManager", msg.sender) {
196     bytes memory contractNameBytes = bytes(_contractName);
197 
198     require(contractNameBytes.length != 0);
199     // Should not be able to remove this contract
200     require(keccak256(_contractName) != keccak256("ContractManager"));
201     require(contracts[_contractName] != address(0));
202     
203     delete contracts[_contractName];
204 
205     emit ContractRemoved(_contractName);
206   }
207 
208   /**
209    * @notice Update an existing contract (changing the address)
210    * @param _contractName Name of the existing contract
211    * @param _newAddress Address where the new contract is deployed
212    */
213   function updateContract(string _contractName, address _newAddress) external onlyContractOwner("ContractManager", msg.sender) {
214     bytes memory contractNameBytes = bytes(_contractName);
215 
216     require(contractNameBytes.length != 0);
217     require(contracts[_contractName] != address(0));
218     require(_newAddress != address(0));
219 
220     address oldAddress = contracts[_contractName];
221     contracts[_contractName] = _newAddress;
222 
223     emit ContractUpdated(oldAddress, _newAddress, _contractName);
224   }
225 
226   /**
227    * @notice Change whether an address is authorized to use a specific contract or not
228    * @param _contractName Name of the contract to which the accessor will gain authorization or not
229    * @param _authorizedAddress Address which will have its authorisation status changed
230    * @param _authorized Boolean whether the address will have access or not
231    */
232   function setAuthorizedContract(string _contractName, address _authorizedAddress, bool _authorized) external onlyContractOwner("ContractManager", msg.sender) {
233     bytes memory contractNameBytes = bytes(_contractName);
234 
235     require(contractNameBytes.length != 0);
236     require(_authorizedAddress != address(0));
237     require(authorization[_contractName][_authorizedAddress] != _authorized);
238     
239     authorization[_contractName][_authorizedAddress] = _authorized;
240 
241     emit AuthorizationChanged(_authorizedAddress, _authorized, _contractName);
242   }
243 }