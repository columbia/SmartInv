1 // File: contracts/application/ImplementationProvider.sol
2 
3 pragma solidity ^0.4.24;
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
20 pragma solidity ^0.4.23;
21 
22 
23 /**
24  * @title Ownable
25  * @dev The Ownable contract has an owner address, and provides basic authorization control
26  * functions, this simplifies the implementation of "user permissions".
27  */
28 contract Ownable {
29   address public owner;
30 
31 
32   event OwnershipRenounced(address indexed previousOwner);
33   event OwnershipTransferred(
34     address indexed previousOwner,
35     address indexed newOwner
36   );
37 
38 
39   /**
40    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
41    * account.
42    */
43   constructor() public {
44     owner = msg.sender;
45   }
46 
47   /**
48    * @dev Throws if called by any account other than the owner.
49    */
50   modifier onlyOwner() {
51     require(msg.sender == owner);
52     _;
53   }
54 
55   /**
56    * @dev Allows the current owner to relinquish control of the contract.
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
84 pragma solidity ^0.4.23;
85 
86 
87 /**
88  * Utility library of inline functions on addresses
89  */
90 library AddressUtils {
91 
92   /**
93    * Returns whether the target address is a contract
94    * @dev This function will return false if invoked during the constructor of a contract,
95    *  as the code is not actually created until after the constructor finishes.
96    * @param addr address to check
97    * @return whether the target address is a contract
98    */
99   function isContract(address addr) internal view returns (bool) {
100     uint256 size;
101     // XXX Currently there is no better way to check if there is a contract in an address
102     // than to check the size of the code at that address.
103     // See https://ethereum.stackexchange.com/a/14016/36603
104     // for more details about how this works.
105     // TODO Check this again before the Serenity release, because all addresses will be
106     // contracts then.
107     // solium-disable-next-line security/no-inline-assembly
108     assembly { size := extcodesize(addr) }
109     return size > 0;
110   }
111 
112 }
113 
114 // File: contracts/application/ImplementationDirectory.sol
115 
116 pragma solidity ^0.4.24;
117 
118 
119 
120 
121 /**
122  * @title ImplementationDirectory
123  * @dev Implementation provider that stores contract implementations in a mapping.
124  */
125 contract ImplementationDirectory is ImplementationProvider, Ownable {
126   /**
127    * @dev Emitted when the implementation of a contract is changed.
128    * @param contractName Name of the contract.
129    * @param implementation Address of the added implementation.
130    */
131   event ImplementationChanged(string contractName, address indexed implementation);
132 
133   /**
134    * @dev Emitted when the implementation directory is frozen.
135    */
136   event Frozen();
137 
138   /// @dev Mapping where the addresses of the implementations are stored.
139   mapping (string => address) internal implementations;
140 
141   /// @dev Mutability state of the directory.
142   bool public frozen;
143 
144   /**
145    * @dev Modifier that allows functions to be called only before the contract is frozen.
146    */
147   modifier whenNotFrozen() {
148     require(!frozen, "Cannot perform action for a frozen implementation directory");
149     _;
150   }
151 
152   /**
153    * @dev Makes the directory irreversibly immutable.
154    * It can only be called once, by the owner.
155    */
156   function freeze() onlyOwner whenNotFrozen public {
157     frozen = true;
158     emit Frozen();
159   }
160 
161   /**
162    * @dev Returns the implementation address of a contract.
163    * @param contractName Name of the contract.
164    * @return Address of the implementation.
165    */
166   function getImplementation(string contractName) public view returns (address) {
167     return implementations[contractName];
168   }
169 
170   /**
171    * @dev Sets the address of the implementation of a contract in the directory.
172    * @param contractName Name of the contract.
173    * @param implementation Address of the implementation.
174    */
175   function setImplementation(string contractName, address implementation) public onlyOwner whenNotFrozen {
176     require(AddressUtils.isContract(implementation), "Cannot set implementation in directory with a non-contract address");
177     implementations[contractName] = implementation;
178     emit ImplementationChanged(contractName, implementation);
179   }
180 
181   /**
182    * @dev Removes the address of a contract implementation from the directory.
183    * @param contractName Name of the contract.
184    */
185   function unsetImplementation(string contractName) public onlyOwner whenNotFrozen {
186     implementations[contractName] = address(0);
187     emit ImplementationChanged(contractName, address(0));
188   }
189 }