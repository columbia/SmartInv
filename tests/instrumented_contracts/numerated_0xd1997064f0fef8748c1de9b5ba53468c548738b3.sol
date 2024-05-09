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
26     function Owned() public {
27         owner = msg.sender;
28     }
29 
30     // allows execution by the owner only
31     modifier ownerOnly {
32         assert(msg.sender == owner);
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
60     Contract Registry interface
61 */
62 contract IContractRegistry {
63     function getAddress(bytes32 _contractName) public view returns (address);
64 }
65 
66 /**
67     Contract Registry
68 
69     The contract registry keeps contract addresses by name.
70     The owner can update contract addresses so that a contract name always points to the latest version
71     of the given contract.
72     Other contracts can query the registry to get updated addresses instead of depending on specific
73     addresses.
74 
75     Note that contract names are limited to 32 bytes, UTF8 strings to optimize gas costs
76 */
77 contract ContractRegistry is IContractRegistry, Owned {
78     mapping (bytes32 => address) addresses;
79 
80     event AddressUpdate(bytes32 indexed _contractName, address _contractAddress);
81 
82     /**
83         @dev constructor
84     */
85     function ContractRegistry() public {
86     }
87 
88     /**
89         @dev returns the address associated with the given contract name
90 
91         @param _contractName    contract name
92 
93         @return contract address
94     */
95     function getAddress(bytes32 _contractName) public view returns (address) {
96         return addresses[_contractName];
97     }
98 
99     /**
100         @dev registers a new address for the contract name
101 
102        @param _contractName     contract name
103        @param _contractAddress  contract address
104     */
105     function registerAddress(bytes32 _contractName, address _contractAddress) public ownerOnly {
106         require(_contractName.length > 0); // validating input
107 
108         addresses[_contractName] = _contractAddress;
109         emit AddressUpdate(_contractName, _contractAddress);
110     }
111 }