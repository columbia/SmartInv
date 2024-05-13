1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.7.6;
3 
4 // ============ External Imports ============
5 import {Address} from "@openzeppelin/contracts/utils/Address.sol";
6 
7 /**
8  * @title UpgradeBeacon
9  * @notice Stores the address of an implementation contract
10  * and allows a controller to upgrade the implementation address
11  * @dev This implementation combines the gas savings of having no function selectors
12  * found in 0age's implementation:
13  * https://github.com/dharma-eng/dharma-smart-wallet/blob/master/contracts/proxies/smart-wallet/UpgradeBeaconProxyV1.sol
14  * With the added niceties of a safety check that each implementation is a contract
15  * and an Upgrade event emitted each time the implementation is changed
16  * found in OpenZeppelin's implementation:
17  * https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/proxy/beacon/BeaconProxy.sol
18  */
19 contract UpgradeBeacon {
20     // ============ Immutables ============
21 
22     // The controller is capable of modifying the implementation address
23     address private immutable controller;
24 
25     // ============ Private Storage Variables ============
26 
27     // The implementation address is held in storage slot zero.
28     address private implementation;
29 
30     // ============ Events ============
31 
32     // Upgrade event is emitted each time the implementation address is set
33     // (including deployment)
34     event Upgrade(address indexed implementation);
35 
36     // ============ Constructor ============
37 
38     /**
39      * @notice Validate the initial implementation and store it.
40      * Store the controller immutably.
41      * @param _initialImplementation Address of the initial implementation contract
42      * @param _controller Address of the controller who can upgrade the implementation
43      */
44     constructor(address _initialImplementation, address _controller) {
45         _setImplementation(_initialImplementation);
46         controller = _controller;
47     }
48 
49     // ============ External Functions ============
50 
51     /**
52      * @notice For all callers except the controller, return the current implementation address.
53      * If called by the Controller, update the implementation address
54      * to the address passed in the calldata.
55      * Note: this requires inline assembly because Solidity fallback functions
56      * do not natively take arguments or return values.
57      */
58     fallback() external payable {
59         if (msg.sender != controller) {
60             // if not called by the controller,
61             // load implementation address from storage slot zero
62             // and return it.
63             assembly {
64                 mstore(0, sload(0))
65                 return(0, 32)
66             }
67         } else {
68             // if called by the controller,
69             // load new implementation address from the first word of the calldata
70             address _newImplementation;
71             assembly {
72                 _newImplementation := calldataload(0)
73             }
74             // set the new implementation
75             _setImplementation(_newImplementation);
76         }
77     }
78 
79     // ============ Private Functions ============
80 
81     /**
82      * @notice Perform checks on the new implementation address
83      * then upgrade the stored implementation.
84      * @param _newImplementation Address of the new implementation contract which will replace the old one
85      */
86     function _setImplementation(address _newImplementation) private {
87         // Require that the new implementation is different from the current one
88         require(implementation != _newImplementation, "!upgrade");
89         // Require that the new implementation is a contract
90         require(
91             Address.isContract(_newImplementation),
92             "implementation !contract"
93         );
94         // set the new implementation
95         implementation = _newImplementation;
96         emit Upgrade(_newImplementation);
97     }
98 }
