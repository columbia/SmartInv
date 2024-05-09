1 pragma solidity ^0.4.24;
2 
3 // File: node_modules/zos-lib/contracts/application/versioning/ImplementationProvider.sol
4 
5 /**
6  * @title ImplementationProvider
7  * @dev Interface for providing implementation addresses for other contracts by name.
8  */
9 interface ImplementationProvider {
10   /**
11    * @dev Abstract function to return the implementation address of a contract.
12    * @param contractName Name of the contract.
13    * @return Implementation address of the contract.
14    */
15   function getImplementation(string contractName) public view returns (address);
16 }
17 
18 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
19 
20 /**
21  * @title Ownable
22  * @dev The Ownable contract has an owner address, and provides basic authorization control
23  * functions, this simplifies the implementation of "user permissions".
24  */
25 contract Ownable {
26   address public owner;
27 
28 
29   event OwnershipRenounced(address indexed previousOwner);
30   event OwnershipTransferred(
31     address indexed previousOwner,
32     address indexed newOwner
33   );
34 
35 
36   /**
37    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
38    * account.
39    */
40   constructor() public {
41     owner = msg.sender;
42   }
43 
44   /**
45    * @dev Throws if called by any account other than the owner.
46    */
47   modifier onlyOwner() {
48     require(msg.sender == owner);
49     _;
50   }
51 
52   /**
53    * @dev Allows the current owner to relinquish control of the contract.
54    * @notice Renouncing to ownership will leave the contract without an owner.
55    * It will not be possible to call the functions with the `onlyOwner`
56    * modifier anymore.
57    */
58   function renounceOwnership() public onlyOwner {
59     emit OwnershipRenounced(owner);
60     owner = address(0);
61   }
62 
63   /**
64    * @dev Allows the current owner to transfer control of the contract to a newOwner.
65    * @param _newOwner The address to transfer ownership to.
66    */
67   function transferOwnership(address _newOwner) public onlyOwner {
68     _transferOwnership(_newOwner);
69   }
70 
71   /**
72    * @dev Transfers control of the contract to a newOwner.
73    * @param _newOwner The address to transfer ownership to.
74    */
75   function _transferOwnership(address _newOwner) internal {
76     require(_newOwner != address(0));
77     emit OwnershipTransferred(owner, _newOwner);
78     owner = _newOwner;
79   }
80 }
81 
82 // File: openzeppelin-solidity/contracts/AddressUtils.sol
83 
84 /**
85  * Utility library of inline functions on addresses
86  */
87 library AddressUtils {
88 
89   /**
90    * Returns whether the target address is a contract
91    * @dev This function will return false if invoked during the constructor of a contract,
92    * as the code is not actually created until after the constructor finishes.
93    * @param _addr address to check
94    * @return whether the target address is a contract
95    */
96   function isContract(address _addr) internal view returns (bool) {
97     uint256 size;
98     // XXX Currently there is no better way to check if there is a contract in an address
99     // than to check the size of the code at that address.
100     // See https://ethereum.stackexchange.com/a/14016/36603
101     // for more details about how this works.
102     // TODO Check this again before the Serenity release, because all addresses will be
103     // contracts then.
104     // solium-disable-next-line security/no-inline-assembly
105     assembly { size := extcodesize(_addr) }
106     return size > 0;
107   }
108 
109 }
110 
111 // File: node_modules/zos-lib/contracts/application/versioning/ImplementationDirectory.sol
112 
113 /**
114  * @title ImplementationDirectory
115  * @dev Implementation provider that stores contract implementations in a mapping.
116  */
117 contract ImplementationDirectory is ImplementationProvider, Ownable {
118   /**
119    * @dev Emitted when the implementation of a contract is changed.
120    * @param contractName Name of the contract.
121    * @param implementation Address of the added implementation.
122    */
123   event ImplementationChanged(string contractName, address implementation);
124 
125   /// @dev Mapping where the addresses of the implementations are stored.
126   mapping (string => address) internal implementations;
127 
128   /**
129    * @dev Returns the implementation address of a contract.
130    * @param contractName Name of the contract.
131    * @return Address of the implementation.
132    */
133   function getImplementation(string contractName) public view returns (address) {
134     return implementations[contractName];
135   }
136 
137   /**
138    * @dev Sets the address of the implementation of a contract in the directory.
139    * @param contractName Name of the contract.
140    * @param implementation Address of the implementation.
141    */
142   function setImplementation(string contractName, address implementation) public onlyOwner {
143     require(AddressUtils.isContract(implementation), "Cannot set implementation in directory with a non-contract address");
144     implementations[contractName] = implementation;
145     emit ImplementationChanged(contractName, implementation);
146   }
147 
148   /**
149    * @dev Removes the address of a contract implementation from the directory.
150    * @param contractName Name of the contract.
151    */
152   function unsetImplementation(string contractName) public onlyOwner {
153     implementations[contractName] = address(0);
154     emit ImplementationChanged(contractName, address(0));
155   }
156 }
157 
158 // File: node_modules/zos-lib/contracts/application/AppDirectory.sol
159 
160 /**
161  * @title AppDirectory
162  * @dev Implementation directory with a standard library as a fallback provider.
163  * If the implementation is not found in the directory, it will search in the
164  * standard library.
165  */
166 contract AppDirectory is ImplementationDirectory {
167   /**
168    * @dev Emitted when the standard library is changed.
169    * @param newStdlib Address of the new standard library.
170    */
171   event StdlibChanged(address newStdlib);
172 
173   /**
174    * @dev Provider for standard library implementations.
175    */
176   ImplementationProvider public stdlib;
177 
178   /**
179    * @dev Constructor function.
180    * @param _stdlib Provider for standard library implementations.
181    */
182   constructor(ImplementationProvider _stdlib) public {
183     stdlib = _stdlib;
184   }
185 
186   /**
187    * @dev Returns the implementation address for a given contract name.
188    * If the implementation is not found in the directory, it will search in the
189    * standard library.
190    * @param contractName Name of the contract.
191    * @return Address where the contract is implemented, or 0 if it is not
192    * found.
193    */
194   function getImplementation(string contractName) public view returns (address) {
195     address implementation = super.getImplementation(contractName);
196     if(implementation != address(0)) return implementation;
197     if(stdlib != address(0)) return stdlib.getImplementation(contractName);
198     return address(0);
199   }
200 
201   /**
202    * @dev Sets a new implementation provider for standard library contracts.
203    * @param _stdlib Standard library implementation provider.
204    */
205   function setStdlib(ImplementationProvider _stdlib) public onlyOwner {
206     stdlib = _stdlib;
207     emit StdlibChanged(_stdlib);
208   }
209 }