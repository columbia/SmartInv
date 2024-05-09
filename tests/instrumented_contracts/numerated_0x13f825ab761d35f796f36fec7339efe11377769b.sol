1 pragma solidity ^0.4.18;
2 
3 // File: contracts/Core/Manageable.sol
4 
5 contract Manageable {
6   address public manager;
7 
8 
9   /**
10    * @dev Create a new instance of the Manageable contract.
11    * @param _manager address
12    */
13   function Manageable(address _manager) public {
14     require(_manager != 0x0);
15     manager = _manager;
16   }
17 
18   /**
19    * @dev Checks if the msg.sender is the manager.
20    */
21   modifier onlyManager() { 
22     require (msg.sender == manager && manager != 0x0);
23     _; 
24   }
25 }
26 
27 // File: contracts/Core/Activatable.sol
28 
29 contract Activatable is Manageable {
30   event ActivatedContract(uint256 activatedAt);
31   event DeactivatedContract(uint256 deactivatedAt);
32 
33   bool public active;
34   
35   /**
36    * @dev Check if the contract is active. 
37    */
38   modifier isActive() {
39     require(active);
40     _;
41   }
42 
43   /**
44    * @dev Check if the contract is not active. 
45    */
46   modifier isNotActive() {
47     require(!active);
48     _;
49   }
50 
51   /**
52    * @dev Activate the contract.
53    */
54   function activate() public onlyManager isNotActive {
55     // Set the flag to true.
56     active = true;
57 
58     // Trigger event.
59     ActivatedContract(now);
60   }
61 
62   /**
63    * @dev Deactiate the contract.
64    */
65   function deactivate() public onlyManager isActive {
66     // Set the flag to false.
67     active = false;
68 
69     // Trigger event.
70     DeactivatedContract(now);
71   }
72 }
73 
74 // File: contracts/Core/Versionable.sol
75 
76 contract Versionable is Activatable {
77   string public name;
78   string public version;
79   uint256 public identifier;
80   uint256 public createdAt;
81 
82   /**
83    * @dev Create a new intance of a Versionable contract. Sets the
84    *      createdAt unix timestamp to current block timestamp.
85    */
86   function Versionable (string _name, string _version, uint256 _identifier) public {
87     require (bytes(_name).length != 0x0 && bytes(_version).length != 0x0 && _identifier > 0);
88 
89     // Set variables.
90     name = _name;
91     version = _version;
92     identifier = _identifier;
93     createdAt = now;
94   }
95 }
96 
97 // File: zeppelin-solidity/contracts/ownership/Ownable.sol
98 
99 /**
100  * @title Ownable
101  * @dev The Ownable contract has an owner address, and provides basic authorization control
102  * functions, this simplifies the implementation of "user permissions".
103  */
104 contract Ownable {
105   address public owner;
106 
107 
108   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
109 
110 
111   /**
112    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
113    * account.
114    */
115   function Ownable() public {
116     owner = msg.sender;
117   }
118 
119 
120   /**
121    * @dev Throws if called by any account other than the owner.
122    */
123   modifier onlyOwner() {
124     require(msg.sender == owner);
125     _;
126   }
127 
128 
129   /**
130    * @dev Allows the current owner to transfer control of the contract to a newOwner.
131    * @param newOwner The address to transfer ownership to.
132    */
133   function transferOwnership(address newOwner) public onlyOwner {
134     require(newOwner != address(0));
135     OwnershipTransferred(owner, newOwner);
136     owner = newOwner;
137   }
138 
139 }
140 
141 // File: contracts/Management/ContractManagementSystem.sol
142 
143 contract ContractManagementSystem is Ownable {
144   event UpgradedContract (uint256 contractIdentifier, address indexed oldContractAddress, address indexed newContractAddress);
145   event RollbackedContract (uint256 contractIdentifier, address indexed fromContractAddress, address indexed toContractAddress);
146 
147   mapping (uint256 => mapping (address => bool)) public managedContracts;
148   mapping (uint256 => address) public activeContracts;
149   mapping (uint256 => bool) migrationLocks;
150 
151   /**
152    * @dev Ensure no locks are in place for the given contract identifier.
153    * @param contractIdentifier uint256
154    */
155   modifier onlyWithoutLock(uint256 contractIdentifier) {
156     require(!migrationLocks[contractIdentifier]);
157     _;
158   }
159 
160   /**
161    * @dev    Get the address of the active contract for the given identifier.
162    * @param  contractIdentifier uint256
163    * @return address
164    */
165   function getActiveContractAddress(uint256 contractIdentifier)
166     public
167     constant
168     onlyWithoutLock(contractIdentifier)
169     returns (address activeContract)
170   {
171     // Validate the function arguments.
172     require(contractIdentifier != 0x0);
173     
174     // Get the active contract for the given identifier.
175     activeContract = activeContracts[contractIdentifier];
176 
177     // Ensure the address is set and the contract is active.
178     require(activeContract != 0x0 && Activatable(activeContract).active());
179   }
180 
181   /**
182    * @dev    Check if the contract for the given address is managed.
183    * @param  contractIdentifier uint256
184    * @param  contractAddress    address
185    * @return bool
186    */
187   function existsManagedContract(uint256 contractIdentifier, address contractAddress)
188     public
189     constant
190     returns (bool)
191   {
192     // Validate the function arguments.
193     require(contractIdentifier != 0x0 && contractAddress != 0x0);
194 
195     return managedContracts[contractIdentifier][contractAddress];
196   }
197 
198   /**
199    * @dev    Upgrade the contract for the given contract identifier to a newer version.
200    * @dev    investigate potential race condition
201    * @param  contractIdentifier uint256
202    * @param  newContractAddress address
203    */
204   function upgradeContract(uint256 contractIdentifier, address newContractAddress)
205     public
206     onlyOwner
207     onlyWithoutLock(contractIdentifier)
208   {
209     // Validate the function arguments.
210     require(contractIdentifier != 0x0 && newContractAddress != 0x0);
211     
212     // Lock the contractIdentifier.
213     migrationLocks[contractIdentifier] = true;
214 
215     // New contract should not be active.
216     require(!Activatable(newContractAddress).active());
217 
218     // New contract should match the given contractIdentifier.
219     require(contractIdentifier == Versionable(newContractAddress).identifier());
220 
221     // Ensure the new contract is not already managed.
222     require (!existsManagedContract(contractIdentifier, newContractAddress));
223 
224     // Get the old contract address.
225     address oldContractAddress = activeContracts[contractIdentifier];
226 
227     // Ensure the old contract is not deactivated already.
228     if (oldContractAddress != 0x0) {
229       require(Activatable(oldContractAddress).active());
230     }
231 
232     // Swap the states.
233     swapContractsStates(contractIdentifier, newContractAddress, oldContractAddress);
234 
235     // Add it to the managed ones.
236     managedContracts[contractIdentifier][newContractAddress] = true;
237 
238     // Unlock the contractIdentifier.
239     migrationLocks[contractIdentifier] = false;
240     
241     // Trigger event.
242     UpgradedContract(contractIdentifier, oldContractAddress, newContractAddress);
243   }
244 
245   /**
246    * @dev Rollback the contract for the given contract identifier to the provided version.
247    * @dev investigate potential race condition
248    * @param  contractIdentifier uint256
249    * @param  toContractAddress  address
250    */
251   function rollbackContract(uint256 contractIdentifier, address toContractAddress)
252     public
253     onlyOwner
254     onlyWithoutLock(contractIdentifier)
255   {
256     // Validate the function arguments.
257     require(contractIdentifier != 0x0 && toContractAddress != 0x0);
258 
259     // Lock the contractIdentifier.
260     migrationLocks[contractIdentifier] = true;
261 
262     // To contract should match the given contractIdentifier.
263     require(contractIdentifier == Versionable(toContractAddress).identifier());
264 
265     // Rollback "to" contract should be managed and inactive.
266     require (!Activatable(toContractAddress).active() && existsManagedContract(contractIdentifier, toContractAddress));
267 
268     // Get the rollback "from" contract for given identifier. Will fail if there is no active contract.
269     address fromContractAddress = activeContracts[contractIdentifier];
270 
271     // Swap the states.
272     swapContractsStates(contractIdentifier, toContractAddress, fromContractAddress);
273 
274     // Unlock the contractIdentifier.
275     migrationLocks[contractIdentifier] = false;
276 
277     // Trigger event.
278     RollbackedContract(contractIdentifier, fromContractAddress, toContractAddress);
279   }
280   
281   /**
282    * @dev Swap the given contracts states as defined:
283    *        - newContractAddress will be activated
284    *        - oldContractAddress will be deactived
285    * @param  contractIdentifier uint256
286    * @param  newContractAddress address
287    * @param  oldContractAddress address
288    */
289   function swapContractsStates(uint256 contractIdentifier, address newContractAddress, address oldContractAddress) internal {
290     // Deactivate the old contract.
291     if (oldContractAddress != 0x0) {
292       Activatable(oldContractAddress).deactivate();
293     }
294 
295     // Activate the new contract.
296     Activatable(newContractAddress).activate();
297 
298      // Set the new contract as the active one for the given identifier.
299     activeContracts[contractIdentifier] = newContractAddress;
300   }
301 }