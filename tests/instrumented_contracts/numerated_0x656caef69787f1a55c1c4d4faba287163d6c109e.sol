1 // File: zos-lib/contracts/application/ImplementationProvider.sol
2 
3 pragma solidity ^0.5.0;
4 
5 /**
6  * @title ImplementationProvider
7  * @dev Abstract contract for providing implementation addresses for other contracts by name.
8  */
9 contract ImplementationProvider {
10   /**
11    * @dev Abstract function to return the implementation address of a contract.
12    * @param contractName Name of the contract.
13    * @return Implementation address of the contract.
14    */
15   function getImplementation(string memory contractName) public view returns (address);
16 }
17 
18 // File: zos-lib/contracts/ownership/Ownable.sol
19 
20 pragma solidity ^0.5.0;
21 
22 /**
23  * @title Ownable
24  * @dev The Ownable contract has an owner address, and provides basic authorization control
25  * functions, this simplifies the implementation of "user permissions".
26  *
27  * Source https://raw.githubusercontent.com/OpenZeppelin/openzeppelin-solidity/v2.1.3/contracts/ownership/Ownable.sol
28  * This contract is copied here and renamed from the original to avoid clashes in the compiled artifacts
29  * when the user imports a zos-lib contract (that transitively causes this contract to be compiled and added to the
30  * build/artifacts folder) as well as the vanilla Ownable implementation from an openzeppelin version.
31  */
32 contract ZOSLibOwnable {
33     address private _owner;
34 
35     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
36 
37     /**
38      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
39      * account.
40      */
41     constructor () internal {
42         _owner = msg.sender;
43         emit OwnershipTransferred(address(0), _owner);
44     }
45 
46     /**
47      * @return the address of the owner.
48      */
49     function owner() public view returns (address) {
50         return _owner;
51     }
52 
53     /**
54      * @dev Throws if called by any account other than the owner.
55      */
56     modifier onlyOwner() {
57         require(isOwner());
58         _;
59     }
60 
61     /**
62      * @return true if `msg.sender` is the owner of the contract.
63      */
64     function isOwner() public view returns (bool) {
65         return msg.sender == _owner;
66     }
67 
68     /**
69      * @dev Allows the current owner to relinquish control of the contract.
70      * @notice Renouncing to ownership will leave the contract without an owner.
71      * It will not be possible to call the functions with the `onlyOwner`
72      * modifier anymore.
73      */
74     function renounceOwnership() public onlyOwner {
75         emit OwnershipTransferred(_owner, address(0));
76         _owner = address(0);
77     }
78 
79     /**
80      * @dev Allows the current owner to transfer control of the contract to a newOwner.
81      * @param newOwner The address to transfer ownership to.
82      */
83     function transferOwnership(address newOwner) public onlyOwner {
84         _transferOwnership(newOwner);
85     }
86 
87     /**
88      * @dev Transfers control of the contract to a newOwner.
89      * @param newOwner The address to transfer ownership to.
90      */
91     function _transferOwnership(address newOwner) internal {
92         require(newOwner != address(0));
93         emit OwnershipTransferred(_owner, newOwner);
94         _owner = newOwner;
95     }
96 }
97 
98 // File: zos-lib/contracts/utils/Address.sol
99 
100 pragma solidity ^0.5.0;
101 
102 /**
103  * Utility library of inline functions on addresses
104  *
105  * Source https://raw.githubusercontent.com/OpenZeppelin/openzeppelin-solidity/v2.1.3/contracts/utils/Address.sol
106  * This contract is copied here and renamed from the original to avoid clashes in the compiled artifacts
107  * when the user imports a zos-lib contract (that transitively causes this contract to be compiled and added to the
108  * build/artifacts folder) as well as the vanilla Address implementation from an openzeppelin version.
109  */
110 library ZOSLibAddress {
111     /**
112      * Returns whether the target address is a contract
113      * @dev This function will return false if invoked during the constructor of a contract,
114      * as the code is not actually created until after the constructor finishes.
115      * @param account address of the account to check
116      * @return whether the target address is a contract
117      */
118     function isContract(address account) internal view returns (bool) {
119         uint256 size;
120         // XXX Currently there is no better way to check if there is a contract in an address
121         // than to check the size of the code at that address.
122         // See https://ethereum.stackexchange.com/a/14016/36603
123         // for more details about how this works.
124         // TODO Check this again before the Serenity release, because all addresses will be
125         // contracts then.
126         // solhint-disable-next-line no-inline-assembly
127         assembly { size := extcodesize(account) }
128         return size > 0;
129     }
130 }
131 
132 // File: zos-lib/contracts/application/ImplementationDirectory.sol
133 
134 pragma solidity ^0.5.0;
135 
136 
137 
138 
139 /**
140  * @title ImplementationDirectory
141  * @dev Implementation provider that stores contract implementations in a mapping.
142  */
143 contract ImplementationDirectory is ImplementationProvider, ZOSLibOwnable {
144   /**
145    * @dev Emitted when the implementation of a contract is changed.
146    * @param contractName Name of the contract.
147    * @param implementation Address of the added implementation.
148    */
149   event ImplementationChanged(string contractName, address indexed implementation);
150 
151   /**
152    * @dev Emitted when the implementation directory is frozen.
153    */
154   event Frozen();
155 
156   /// @dev Mapping where the addresses of the implementations are stored.
157   mapping (string => address) internal implementations;
158 
159   /// @dev Mutability state of the directory.
160   bool public frozen;
161 
162   /**
163    * @dev Modifier that allows functions to be called only before the contract is frozen.
164    */
165   modifier whenNotFrozen() {
166     require(!frozen, "Cannot perform action for a frozen implementation directory");
167     _;
168   }
169 
170   /**
171    * @dev Makes the directory irreversibly immutable.
172    * It can only be called once, by the owner.
173    */
174   function freeze() onlyOwner whenNotFrozen public {
175     frozen = true;
176     emit Frozen();
177   }
178 
179   /**
180    * @dev Returns the implementation address of a contract.
181    * @param contractName Name of the contract.
182    * @return Address of the implementation.
183    */
184   function getImplementation(string memory contractName) public view returns (address) {
185     return implementations[contractName];
186   }
187 
188   /**
189    * @dev Sets the address of the implementation of a contract in the directory.
190    * @param contractName Name of the contract.
191    * @param implementation Address of the implementation.
192    */
193   function setImplementation(string memory contractName, address implementation) public onlyOwner whenNotFrozen {
194     require(ZOSLibAddress.isContract(implementation), "Cannot set implementation in directory with a non-contract address");
195     implementations[contractName] = implementation;
196     emit ImplementationChanged(contractName, implementation);
197   }
198 
199   /**
200    * @dev Removes the address of a contract implementation from the directory.
201    * @param contractName Name of the contract.
202    */
203   function unsetImplementation(string memory contractName) public onlyOwner whenNotFrozen {
204     implementations[contractName] = address(0);
205     emit ImplementationChanged(contractName, address(0));
206   }
207 }