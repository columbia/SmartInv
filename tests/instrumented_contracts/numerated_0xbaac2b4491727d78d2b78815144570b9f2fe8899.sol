1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.0;
3 
4 /**
5  * @title InitializedProxy
6  * @author Anna Carroll
7  */
8 contract InitializedProxy {
9     // address of logic contract
10     address public immutable logic;
11 
12     // ======== Constructor =========
13 
14     constructor(
15         address _logic,
16         bytes memory _initializationCalldata
17     ) {
18         logic = _logic;
19         // Delegatecall into the logic contract, supplying initialization calldata
20         (bool _ok, bytes memory returnData) =
21             _logic.delegatecall(_initializationCalldata);
22         // Revert if delegatecall to implementation reverts
23         require(_ok, string(returnData));
24     }
25 
26     // ======== Fallback =========
27 
28     fallback() external payable {
29         address _impl = logic;
30         assembly {
31             let ptr := mload(0x40)
32             calldatacopy(ptr, 0, calldatasize())
33             let result := delegatecall(gas(), _impl, ptr, calldatasize(), 0, 0)
34             let size := returndatasize()
35             returndatacopy(ptr, 0, size)
36 
37             switch result
38                 case 0 {
39                     revert(ptr, size)
40                 }
41                 default {
42                     return(ptr, size)
43                 }
44         }
45     }
46 
47     // ======== Receive =========
48 
49     receive() external payable {} // solhint-disable-line no-empty-blocks
50 }
51 
52 // zf was here :)