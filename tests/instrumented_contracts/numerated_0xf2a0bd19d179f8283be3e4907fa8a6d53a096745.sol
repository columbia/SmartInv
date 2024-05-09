1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.1;
3 
4 /// @title IProxy - Helper interface to access masterCopy of the Proxy on-chain
5 /// @author Richard Meissner - <richard@gnosis.io>
6 interface IProxy {
7     function masterCopy() external view returns (address);
8 }
9 
10 /// @title YieldsterVaultProxy - Generic proxy contract allows to execute all transactions applying the code of a master contract.
11 /// @author Stefan George - <stefan@gnosis.io>
12 /// @author Richard Meissner - <richard@gnosis.io>
13 contract YieldsterVaultProxy {
14     // masterCopy always needs to be first declared variable, to ensure that it is at the same location in the contracts to which calls are delegated.
15     // To reduce deployment costs this variable is internal and needs to be retrieved via `getStorageAt`
16     address internal masterCopy;
17 
18     /// @dev Constructor function sets address of master copy contract.
19     /// @param _masterCopy Master copy address.
20     constructor(address _masterCopy)  {
21         require(
22             _masterCopy != address(0),
23             "Invalid master copy address provided"
24         );
25         masterCopy = _masterCopy;
26     }
27 
28     /// @dev Fallback function forwards all transactions and returns all received return data.
29     fallback() external payable {
30         // solium-disable-next-line security/no-inline-assembly
31         assembly {
32             let _masterCopy := and(
33                 sload(0),
34                 0xffffffffffffffffffffffffffffffffffffffff
35             )
36             // 0xa619486e == keccak("masterCopy()"). The value is right padded to 32-bytes with 0s
37             if eq(
38                 calldataload(0),
39                 0xa619486e00000000000000000000000000000000000000000000000000000000
40             ) {
41                 mstore(0, _masterCopy)
42                 return(0, 0x20)
43             }
44             calldatacopy(0, 0, calldatasize())
45             let success := delegatecall(
46                 gas(),
47                 _masterCopy,
48                 0,
49                 calldatasize(),
50                 0,
51                 0
52             )
53             returndatacopy(0, 0, returndatasize())
54             if eq(success, 0) {
55                 revert(0, returndatasize())
56             }
57             return(0, returndatasize())
58         }
59     }
60 }