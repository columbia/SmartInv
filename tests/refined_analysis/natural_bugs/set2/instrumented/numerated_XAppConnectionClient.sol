1 // SPDX-License-Identifier: MIT OR Apache-2.0
2 pragma solidity >=0.6.11;
3 
4 // ============ External Imports ============
5 import {Home} from "@nomad-xyz/nomad-core-sol/contracts/Home.sol";
6 import {XAppConnectionManager} from "@nomad-xyz/nomad-core-sol/contracts/XAppConnectionManager.sol";
7 import {OwnableUpgradeable} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
8 
9 abstract contract XAppConnectionClient is OwnableUpgradeable {
10     // ============ Mutable Storage ============
11 
12     XAppConnectionManager public xAppConnectionManager;
13     uint256[49] private __GAP; // gap for upgrade safety
14 
15     // ============ Modifiers ============
16 
17     /**
18      * @notice Only accept messages from an Nomad Replica contract
19      */
20     modifier onlyReplica() {
21         require(_isReplica(msg.sender), "!replica");
22         _;
23     }
24 
25     // ======== Initializer =========
26 
27     function __XAppConnectionClient_initialize(address _xAppConnectionManager)
28         internal
29         initializer
30     {
31         xAppConnectionManager = XAppConnectionManager(_xAppConnectionManager);
32         __Ownable_init();
33     }
34 
35     // ============ External functions ============
36 
37     /**
38      * @notice Modify the contract the xApp uses to validate Replica contracts
39      * @param _xAppConnectionManager The address of the xAppConnectionManager contract
40      */
41     function setXAppConnectionManager(address _xAppConnectionManager)
42         external
43         onlyOwner
44     {
45         xAppConnectionManager = XAppConnectionManager(_xAppConnectionManager);
46     }
47 
48     // ============ Internal functions ============
49 
50     /**
51      * @notice Get the local Home contract from the xAppConnectionManager
52      * @return The local Home contract
53      */
54     function _home() internal view returns (Home) {
55         return xAppConnectionManager.home();
56     }
57 
58     /**
59      * @notice Determine whether _potentialReplcia is an enrolled Replica from the xAppConnectionManager
60      * @return True if _potentialReplica is an enrolled Replica
61      */
62     function _isReplica(address _potentialReplica)
63         internal
64         view
65         returns (bool)
66     {
67         return xAppConnectionManager.isReplica(_potentialReplica);
68     }
69 
70     /**
71      * @notice Get the local domain from the xAppConnectionManager
72      * @return The local domain
73      */
74     function _localDomain() internal view virtual returns (uint32) {
75         return xAppConnectionManager.localDomain();
76     }
77 }
