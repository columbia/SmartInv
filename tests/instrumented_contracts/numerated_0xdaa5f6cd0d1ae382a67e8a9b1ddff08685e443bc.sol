1 // SPDX-License-Identifier: UNLICENSED
2 pragma solidity ^0.8.0;
3 
4 
5 /**
6  * @dev Library for reading and writing primitive types to specific storage slots.
7  *
8  * Storage slots are often used to avoid storage conflict when dealing with upgradeable contracts.
9  * This library helps with reading and writing to such slots without the need for inline assembly.
10  *
11  * The functions in this library return Slot structs that contain a `value` member that can be used to read or write.
12  *
13  * Example usage to set ERC1967 implementation slot:
14  * ```
15  * contract ERC1967 {
16  *     bytes32 internal constant _IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
17  *
18  *     function _getImplementation() internal view returns (address) {
19  *         return StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value;
20  *     }
21  *
22  *     function _setImplementation(address newImplementation) internal {
23  *         require(Address.isContract(newImplementation), "ERC1967: new implementation is not a contract");
24  *         StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value = newImplementation;
25  *     }
26  * }
27  * ```
28  *
29  * _Available since v4.1 for `address`, `bool`, `bytes32`, and `uint256`._
30  */
31 library StorageSlotUpgradeable {
32     struct AddressSlot {
33         address value;
34     }
35 
36     struct BooleanSlot {
37         bool value;
38     }
39 
40     struct Bytes32Slot {
41         bytes32 value;
42     }
43 
44     struct Uint256Slot {
45         uint256 value;
46     }
47 
48     /**
49      * @dev Returns an `AddressSlot` with member `value` located at `slot`.
50      */
51     function getAddressSlot(bytes32 slot) internal pure returns (AddressSlot storage r) {
52         assembly {
53             r.slot := slot
54         }
55     }
56 
57     /**
58      * @dev Returns an `BooleanSlot` with member `value` located at `slot`.
59      */
60     function getBooleanSlot(bytes32 slot) internal pure returns (BooleanSlot storage r) {
61         assembly {
62             r.slot := slot
63         }
64     }
65 
66     /**
67      * @dev Returns an `Bytes32Slot` with member `value` located at `slot`.
68      */
69     function getBytes32Slot(bytes32 slot) internal pure returns (Bytes32Slot storage r) {
70         assembly {
71             r.slot := slot
72         }
73     }
74 
75     /**
76      * @dev Returns an `Uint256Slot` with member `value` located at `slot`.
77      */
78     function getUint256Slot(bytes32 slot) internal pure returns (Uint256Slot storage r) {
79         assembly {
80             r.slot := slot
81         }
82     }
83 }
84 
85 
86 
87 contract Proxy
88 {
89     bytes32 private constant _IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
90     bytes32 private constant _ADMIN_SLOT = 0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103;
91 
92     constructor(address implementation)
93     {
94         StorageSlotUpgradeable.getAddressSlot(_IMPLEMENTATION_SLOT).value = implementation;
95         StorageSlotUpgradeable.getAddressSlot(_ADMIN_SLOT).value = msg.sender;
96     }
97 
98     fallback() external payable
99     {
100         _fallback();
101     }
102 
103     receive() external payable 
104     {
105         _fallback();
106     }
107 
108     function _fallback() private
109     {
110         address implementation = StorageSlotUpgradeable.getAddressSlot(_IMPLEMENTATION_SLOT).value;
111 
112         // from OpenZeppelin/contracts
113         assembly 
114         {
115             // Copy msg.data. We take full control of memory in this inline assembly
116             // block because it will not return to Solidity code. We overwrite the
117             // Solidity scratch pad at memory position 0.
118             calldatacopy(0, 0, calldatasize())
119 
120             // Call the implementation.
121             // out and outsize are 0 because we don't know the size yet.
122             let result := delegatecall(gas(), implementation, 0, calldatasize(), 0, 0)
123 
124             // Copy the returned data.
125             returndatacopy(0, 0, returndatasize())
126 
127             switch result
128             // delegatecall returns 0 on error.
129             case 0 {
130                 revert(0, returndatasize())
131             }
132             default {
133                 return(0, returndatasize())
134             }
135         }
136     }
137 }