1 // SPDX-License-Identifier: GPL-3.0-or-later
2 pragma solidity 0.8.10;
3 
4 /**
5  * @title MirrorProxy
6  * @author MirrorXYZ
7  * The MirrorProxy contract is used to deploy minimal proxies.
8  */
9 contract MirrorProxy {
10     /**
11      * @dev Storage slot with the address of the current implementation.
12      * This is the keccak-256 hash of "eip1967.proxy.implementation" subtracted by 1, and is
13      * validated in the constructor.
14      */
15     bytes32 internal constant _IMPLEMENTATION_SLOT =
16         0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
17 
18     /**
19      * @notice Initializes a proxy by delegating logic to the implementation,
20      * and reverts if the call is not successful. Stores implementation logic.
21      * @param implementation - the implementation holds the logic for all proxies
22      * @param initializationData - initialization call
23      */
24     constructor(address implementation, bytes memory initializationData) {
25         // Delegatecall into the implementation, supplying initialization calldata.
26         (bool ok, ) = implementation.delegatecall(initializationData);
27 
28         // Revert and include revert data if delegatecall to implementation reverts.
29         if (!ok) {
30             assembly {
31                 returndatacopy(0, 0, returndatasize())
32                 revert(0, returndatasize())
33             }
34         }
35 
36         assembly {
37             sstore(_IMPLEMENTATION_SLOT, implementation)
38         }
39     }
40 
41     /**
42      * @notice When any function is called on this contract, we delegate to
43      * the logic contract stored in the implementation storage slot.
44      */
45     fallback() external payable {
46         assembly {
47             let ptr := mload(0x40)
48             calldatacopy(ptr, 0, calldatasize())
49             let result := delegatecall(
50                 gas(),
51                 sload(_IMPLEMENTATION_SLOT),
52                 ptr,
53                 calldatasize(),
54                 0,
55                 0
56             )
57             let size := returndatasize()
58             returndatacopy(ptr, 0, size)
59 
60             switch result
61             case 0 {
62                 revert(ptr, size)
63             }
64             default {
65                 return(ptr, size)
66             }
67         }
68     }
69 }