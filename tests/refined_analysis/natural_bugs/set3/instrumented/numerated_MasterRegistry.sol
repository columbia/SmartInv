1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.6.12;
4 pragma experimental ABIEncoderV2;
5 
6 import "@openzeppelin/contracts/access/AccessControl.sol";
7 import "../helper/BaseBoringBatchable.sol";
8 import "../interfaces/IMasterRegistry.sol";
9 
10 /**
11  * @title MasterRegistry
12  * @notice This contract holds list of other registries or contracts and its historical versions.
13  */
14 contract MasterRegistry is AccessControl, IMasterRegistry, BaseBoringBatchable {
15     /// @notice Role responsible for adding registries.
16     bytes32 public constant SADDLE_MANAGER_ROLE =
17         keccak256("SADDLE_MANAGER_ROLE");
18 
19     mapping(bytes32 => address[]) private registryMap;
20     mapping(address => ReverseRegistryData) private reverseRegistry;
21 
22     /**
23      * @notice Add a new registry entry to the master list.
24      * @param name address of the added pool
25      * @param registryAddress address of the registry
26      * @param version version of the registry
27      */
28     event AddRegistry(
29         bytes32 indexed name,
30         address registryAddress,
31         uint256 version
32     );
33 
34     constructor(address admin) public {
35         _setupRole(DEFAULT_ADMIN_ROLE, admin);
36         _setupRole(SADDLE_MANAGER_ROLE, msg.sender);
37     }
38 
39     /// @inheritdoc IMasterRegistry
40     function addRegistry(bytes32 registryName, address registryAddress)
41         external
42         payable
43         override
44     {
45         require(
46             hasRole(SADDLE_MANAGER_ROLE, msg.sender),
47             "MR: msg.sender is not allowed"
48         );
49         require(registryName != 0, "MR: name cannot be empty");
50         require(registryAddress != address(0), "MR: address cannot be empty");
51 
52         address[] storage registry = registryMap[registryName];
53         uint256 version = registry.length;
54         registry.push(registryAddress);
55         require(
56             reverseRegistry[registryAddress].name == 0,
57             "MR: duplicate registry address"
58         );
59         reverseRegistry[registryAddress] = ReverseRegistryData(
60             registryName,
61             version
62         );
63 
64         emit AddRegistry(registryName, registryAddress, version);
65     }
66 
67     /// @inheritdoc IMasterRegistry
68     function resolveNameToLatestAddress(bytes32 name)
69         external
70         view
71         override
72         returns (address)
73     {
74         address[] storage registry = registryMap[name];
75         uint256 length = registry.length;
76         require(length > 0, "MR: no match found for name");
77         return registry[length - 1];
78     }
79 
80     /// @inheritdoc IMasterRegistry
81     function resolveNameAndVersionToAddress(bytes32 name, uint256 version)
82         external
83         view
84         override
85         returns (address)
86     {
87         address[] storage registry = registryMap[name];
88         require(
89             version < registry.length,
90             "MR: no match found for name and version"
91         );
92         return registry[version];
93     }
94 
95     /// @inheritdoc IMasterRegistry
96     function resolveNameToAllAddresses(bytes32 name)
97         external
98         view
99         override
100         returns (address[] memory)
101     {
102         address[] storage registry = registryMap[name];
103         require(registry.length > 0, "MR: no match found for name");
104         return registry;
105     }
106 
107     /// @inheritdoc IMasterRegistry
108     function resolveAddressToRegistryData(address registryAddress)
109         external
110         view
111         override
112         returns (
113             bytes32 name,
114             uint256 version,
115             bool isLatest
116         )
117     {
118         ReverseRegistryData memory data = reverseRegistry[registryAddress];
119         require(data.name != 0, "MR: no match found for address");
120         name = data.name;
121         version = data.version;
122         uint256 length = registryMap[name].length;
123         require(length > 0, "MR: no version found for address");
124         isLatest = version == length - 1;
125     }
126 }
