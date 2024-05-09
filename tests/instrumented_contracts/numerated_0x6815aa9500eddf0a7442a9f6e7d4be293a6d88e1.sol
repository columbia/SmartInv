1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.9;
3 
4 /**
5  * @title NonReceivableInitializedProxy
6  * @author Anna Carroll
7  */
8 contract NonReceivableInitializedProxy {
9     // address of logic contract
10     address public immutable logic;
11 
12     // ======== Constructor =========
13 
14     constructor(address _logic, bytes memory _initializationCalldata) {
15         logic = _logic;
16         // Delegatecall into the logic contract, supplying initialization calldata
17         (bool _ok, bytes memory returnData) = _logic.delegatecall(
18             _initializationCalldata
19         );
20         // Revert if delegatecall to implementation reverts
21         require(_ok, string(returnData));
22     }
23 
24     // ======== Fallback =========
25 
26     fallback() external payable {
27         address _impl = logic;
28         assembly {
29             let ptr := mload(0x40)
30             calldatacopy(ptr, 0, calldatasize())
31             let result := delegatecall(gas(), _impl, ptr, calldatasize(), 0, 0)
32             let size := returndatasize()
33             returndatacopy(ptr, 0, size)
34 
35             switch result
36             case 0 {
37                 revert(ptr, size)
38             }
39             default {
40                 return(ptr, size)
41             }
42         }
43     }
44 }