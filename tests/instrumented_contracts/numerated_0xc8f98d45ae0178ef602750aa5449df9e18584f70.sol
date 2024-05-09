1 pragma solidity ^0.4.24;
2 
3 // File: contracts/interfaces/IOwned.sol
4 
5 /*
6     Owned Contract Interface
7 */
8 contract IOwned {
9     function transferOwnership(address _newOwner) public;
10     function acceptOwnership() public;
11     function transferOwnershipNow(address newContractOwner) public;
12 }
13 
14 // File: contracts/utility/Owned.sol
15 
16 /*
17     This is the "owned" utility contract used by bancor with one additional function - transferOwnershipNow()
18     
19     The original unmodified version can be found here:
20     https://github.com/bancorprotocol/contracts/commit/63480ca28534830f184d3c4bf799c1f90d113846
21     
22     Provides support and utilities for contract ownership
23 */
24 contract Owned is IOwned {
25     address public owner;
26     address public newOwner;
27 
28     event OwnerUpdate(address indexed _prevOwner, address indexed _newOwner);
29 
30     /**
31         @dev constructor
32     */
33     constructor() public {
34         owner = msg.sender;
35     }
36 
37     // allows execution by the owner only
38     modifier ownerOnly {
39         require(msg.sender == owner);
40         _;
41     }
42 
43     /**
44         @dev allows transferring the contract ownership
45         the new owner still needs to accept the transfer
46         can only be called by the contract owner
47         @param _newOwner    new contract owner
48     */
49     function transferOwnership(address _newOwner) public ownerOnly {
50         require(_newOwner != owner);
51         newOwner = _newOwner;
52     }
53 
54     /**
55         @dev used by a new owner to accept an ownership transfer
56     */
57     function acceptOwnership() public {
58         require(msg.sender == newOwner);
59         emit OwnerUpdate(owner, newOwner);
60         owner = newOwner;
61         newOwner = address(0);
62     }
63 
64     /**
65         @dev transfers the contract ownership without needing the new owner to accept ownership
66         @param newContractOwner    new contract owner
67     */
68     function transferOwnershipNow(address newContractOwner) ownerOnly public {
69         require(newContractOwner != owner);
70         emit OwnerUpdate(owner, newContractOwner);
71         owner = newContractOwner;
72     }
73 
74 }
75 
76 // File: contracts/interfaces/IRegistrar.sol
77 
78 /*
79     Smart Token interface
80 */
81 contract IRegistrar is IOwned {
82     function addNewAddress(address _newAddress) public;
83     function getAddresses() public view returns (address[]);
84 }
85 
86 // File: contracts/Registrar.sol
87 
88 /**
89 @notice Contains a record of all previous and current address of a community; For upgradeability.
90 */
91 contract Registrar is Owned, IRegistrar {
92 
93     address[] addresses;
94     /// @notice Adds new community logic contract address to Registrar
95     /// @param _newAddress Address of community logic contract to upgrade to
96     function addNewAddress(address _newAddress) public ownerOnly {
97         addresses.push(_newAddress);
98     }
99 
100     /// @return Array of community logic contract addresses
101     function getAddresses() public view returns (address[]) {
102         return addresses;
103     }
104 }