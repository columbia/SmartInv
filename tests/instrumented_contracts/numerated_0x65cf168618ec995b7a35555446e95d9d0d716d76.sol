1 pragma solidity ^0.4.24;
2 
3 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
4 
5 /**
6  * @title Ownable
7  * @dev The Ownable contract has an owner address, and provides basic authorization control
8  * functions, this simplifies the implementation of "user permissions".
9  */
10 contract Ownable {
11   address public owner;
12 
13 
14   event OwnershipRenounced(address indexed previousOwner);
15   event OwnershipTransferred(
16     address indexed previousOwner,
17     address indexed newOwner
18   );
19 
20 
21   /**
22    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
23    * account.
24    */
25   constructor() public {
26     owner = msg.sender;
27   }
28 
29   /**
30    * @dev Throws if called by any account other than the owner.
31    */
32   modifier onlyOwner() {
33     require(msg.sender == owner);
34     _;
35   }
36 
37   /**
38    * @dev Allows the current owner to relinquish control of the contract.
39    */
40   function renounceOwnership() public onlyOwner {
41     emit OwnershipRenounced(owner);
42     owner = address(0);
43   }
44 
45   /**
46    * @dev Allows the current owner to transfer control of the contract to a newOwner.
47    * @param _newOwner The address to transfer ownership to.
48    */
49   function transferOwnership(address _newOwner) public onlyOwner {
50     _transferOwnership(_newOwner);
51   }
52 
53   /**
54    * @dev Transfers control of the contract to a newOwner.
55    * @param _newOwner The address to transfer ownership to.
56    */
57   function _transferOwnership(address _newOwner) internal {
58     require(_newOwner != address(0));
59     emit OwnershipTransferred(owner, _newOwner);
60     owner = _newOwner;
61   }
62 }
63 
64 // File: contracts/NameRegistry.sol
65 
66 contract NameRegistry is Ownable {
67   mapping(address => bool) registrar;
68 
69   // Index event by address, for reverse look up
70   event NameSet(address indexed addr, string name);
71   event NameFinalized(address indexed addr, bytes32 namehash);
72 
73   // External services should honour the NameRemoved event, and remove name-address pair from index.
74   event NameRemoved(address indexed addr, bytes32 namehash, bool forced);
75 
76   // lookup of address by name hash
77   mapping(bytes32 => address) public namehashAddresses;
78 
79   mapping(bytes32 => bool) public namehashFinalized;
80 
81   function registerName(address addr, string name) public onlyRegistrar {
82     require(bytes(name).length != 0);
83     require(addr != address(0));
84 
85     bytes32 namehash = keccak256(bytes(name));
86     require(namehashAddresses[namehash] == address(0));
87 
88     namehashAddresses[namehash] = addr;
89     emit NameSet(addr, name);
90   }
91 
92   function finalizeName(address addr, string name) public onlyRegistrar {
93     require(bytes(name).length != 0);
94     require(addr != address(0));
95 
96     bytes32 namehash = keccak256(bytes(name));
97     require(!namehashFinalized[namehash]);
98 
99     address nameOwner = namehashAddresses[namehash];
100 
101     if (nameOwner != addr) {
102       namehashAddresses[namehash] = addr;
103 
104       if (nameOwner != address(0)) {
105         emit NameRemoved(nameOwner, namehash, true);
106       }
107       emit NameSet(addr, name);
108     }
109 
110     namehashFinalized[namehash] = true;
111     emit NameFinalized(addr, namehash);
112   }
113 
114   function transferName(address addr, string name) public {
115     require(bytes(name).length != 0);
116     require(addr != address(0));
117 
118     bytes32 namehash = keccak256(bytes(name));
119     require(namehashAddresses[namehash] == msg.sender);
120 
121     namehashAddresses[namehash] = addr;
122 
123     emit NameRemoved(msg.sender, namehash, false);
124     emit NameSet(addr, name);
125   }
126 
127   function removeName(bytes32 namehash) public {
128     require(namehashAddresses[namehash] == msg.sender);
129     namehashAddresses[namehash] = address(0);
130     emit NameRemoved(msg.sender, namehash, false);
131   }
132 
133   function addRegistrar(address addr) public onlyOwner {
134     registrar[addr] = true;
135   }
136 
137   function isRegistrar(address addr) public view returns(bool) {
138     return registrar[addr];
139   }
140 
141   function removeRegistrar(address addr) public onlyOwner {
142     registrar[addr] = false;
143   }
144 
145   modifier onlyRegistrar {
146     require(registrar[msg.sender]);
147     _;
148   }
149 }