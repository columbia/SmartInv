1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title IRegistry
5  * @dev This contract represents the interface of a registry contract
6  */
7 interface ITwoKeySingletonesRegistry {
8 
9     /**
10     * @dev This event will be emitted every time a new proxy is created
11     * @param proxy representing the address of the proxy created
12     */
13     event ProxyCreated(address proxy);
14 
15 
16     /**
17     * @dev This event will be emitted every time a new implementation is registered
18     * @param version representing the version name of the registered implementation
19     * @param implementation representing the address of the registered implementation
20     * @param contractName is the name of the contract we added new version
21     */
22     event VersionAdded(string version, address implementation, string contractName);
23 
24     /**
25     * @dev Registers a new version with its implementation address
26     * @param version representing the version name of the new implementation to be registered
27     * @param implementation representing the address of the new implementation to be registered
28     */
29     function addVersion(string _contractName, string version, address implementation) public;
30 
31     /**
32     * @dev Tells the address of the implementation for a given version
33     * @param _contractName is the name of the contract we're querying
34     * @param version to query the implementation of
35     * @return address of the implementation registered for the given version
36     */
37     function getVersion(string _contractName, string version) public view returns (address);
38 }
39 
40 
41 /**
42  * @title Proxy
43  */
44 contract Proxy {
45 
46 
47     // Gives the possibility to delegate any call to a foreign implementation.
48 
49 
50     /**
51     * @dev Tells the address of the implementation where every call will be delegated.
52     * @return address of the implementation to which it will be delegated
53     */
54     function implementation() public view returns (address);
55 
56     /**
57     * @dev Fallback function allowing to perform a delegatecall to the given implementation.
58     * This function will return whatever the implementation call returns
59     */
60     function () payable public {
61         address _impl = implementation();
62         require(_impl != address(0));
63 
64         assembly {
65             let ptr := mload(0x40)
66             calldatacopy(ptr, 0, calldatasize)
67             let result := delegatecall(gas, _impl, ptr, calldatasize, 0, 0)
68             let size := returndatasize
69             returndatacopy(ptr, 0, size)
70 
71             switch result
72             case 0 { revert(ptr, size) }
73             default { return(ptr, size) }
74         }
75     }
76 }
77 
78 
79 /**
80  * @author Nikola Madjarevic
81  * @dev This contract holds all the necessary state variables to support the upgrade functionality
82  */
83 contract UpgradeabilityStorage {
84     // Versions registry
85     ITwoKeySingletonesRegistry internal registry;
86 
87     // Address of the current implementation
88     address internal _implementation;
89 
90     /**
91     * @dev Tells the address of the current implementation
92     * @return address of the current implementation
93     */
94     function implementation() public view returns (address) {
95         return _implementation;
96     }
97 }
98 
99 /**
100  * @title UpgradeabilityProxy
101  * @dev This contract represents a proxy where the implementation address to which it will delegate can be upgraded
102  */
103 contract UpgradeabilityProxy is Proxy, UpgradeabilityStorage {
104 
105     //TODO: Add event through event source whenever someone calls upgradeTo
106     /**
107     * @dev Constructor function
108     */
109     constructor (string _contractName, string _version) public {
110         registry = ITwoKeySingletonesRegistry(msg.sender);
111         _implementation = registry.getVersion(_contractName, _version);
112     }
113 
114     /**
115     * @dev Upgrades the implementation to the requested version
116     * @param _version representing the version name of the new implementation to be set
117     */
118     function upgradeTo(string _contractName, string _version, address _impl) public {
119         require(msg.sender == address(registry));
120         require(_impl != address(0));
121         _implementation = _impl;
122     }
123 
124 }