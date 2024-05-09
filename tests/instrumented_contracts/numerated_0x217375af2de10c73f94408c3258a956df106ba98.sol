1 pragma solidity ^0.4.18;
2 
3 
4 /**
5  * @title Proxy
6  * @dev Gives the possibility to delegate any call to a foreign implementation.
7  */
8 contract Proxy {
9   function implementation() public view returns (address);
10 
11   /**
12   * @dev Fallback function allowing to perform a delegatecall to the given implementation.
13   * This function will return whatever the implementation call returns
14   */
15   function () payable public {
16     address impl = implementation();
17     require(impl != address(0));
18     bytes memory data = msg.data;
19 
20     assembly {
21       let result := delegatecall(gas, impl, add(data, 0x20), mload(data), 0, 0)
22       let size := returndatasize
23 
24       let ptr := mload(0x40)
25       returndatacopy(ptr, 0, size)
26 
27       switch result
28       case 0 { revert(ptr, size) }
29       default { return(ptr, size) }
30     }
31   }
32 }
33 
34 
35 /**
36  * @title Ownable
37  * @dev The Ownable contract has an owner address, and provides basic authorization control
38  * functions, this simplifies the implementation of "user permissions".
39  */
40 contract Ownable {
41   address[] public owners;
42 
43   event OwnerAdded(address indexed authorizer, address indexed newOwner, uint256 index);
44 
45   event OwnerRemoved(address indexed authorizer, address indexed oldOwner);
46 
47   /**
48    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
49    * account.
50    */
51   function Ownable() public {
52     owners.push(msg.sender);
53     OwnerAdded(0x0, msg.sender, 0);
54   }
55 
56   /**
57    * @dev Throws if called by any account other than one owner.
58    */
59   modifier onlyOwner() {
60     bool isOwner = false;
61 
62     for (uint256 i = 0; i < owners.length; i++) {
63       if (msg.sender == owners[i]) {
64         isOwner = true;
65         break;
66       }
67     }
68 
69     require(isOwner);
70     _;
71   }
72 
73   /**
74    * @dev Allows one of the current owners to add a new owner
75    * @param newOwner The address give ownership to.
76    */
77   function addOwner(address newOwner) onlyOwner public {
78     require(newOwner != address(0));
79     uint256 i = owners.push(newOwner) - 1;
80     OwnerAdded(msg.sender, newOwner, i);
81   }
82 
83   /**
84    * @dev Allows one of the owners to remove other owner
85    */
86   function removeOwner(uint256 index) onlyOwner public {
87     address owner = owners[index];
88     owners[index] = owners[owners.length - 1];
89     delete owners[owners.length - 1];
90     OwnerRemoved(msg.sender, owner);
91   }
92 
93   function ownersCount() constant public returns (uint256) {
94     return owners.length;
95   }
96 }
97 
98 
99 contract UpgradableStorage is Ownable {
100 
101   // Address of the current implementation
102   address internal _implementation;
103 
104   event NewImplementation(address implementation);
105 
106   /**
107   * @dev Tells the address of the current implementation
108   * @return address of the current implementation
109   */
110   function implementation() public view returns (address) {
111     return _implementation;
112   }
113 }
114 
115 
116 /**
117  * @title Upgradable
118  * @dev This contract represents an upgradable contract
119  */
120 contract Upgradable is UpgradableStorage {
121   function initialize() public payable { }
122 }
123 
124 
125 contract KnowledgeProxy is Proxy, UpgradableStorage {
126   /**
127   * @dev Upgrades the implementation to the requested version
128   */
129   function upgradeTo(address imp) onlyOwner public payable {
130     _implementation = imp;
131     Upgradable(this).initialize.value(msg.value)();
132 
133     NewImplementation(imp);
134   }
135 }