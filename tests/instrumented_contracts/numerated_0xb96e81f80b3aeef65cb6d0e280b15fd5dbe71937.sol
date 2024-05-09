1 // SPDX-License-Identifier: UNLICENSED
2 pragma solidity 0.6.0;
3 
4 /// @title GnosisSafeProxy - Generic proxy contract allows to execute all transactions applying the code of a master contract.
5 /// @author Stefan George - <stefan@gnosis.io>
6 /// @author Richard Meissner - <richard@gnosis.io>
7 contract GnosisSafeProxy {
8 
9     // masterCopy always needs to be first declared variable, to ensure that it is at the same location in the contracts to which calls are delegated.
10     // To reduce deployment costs this variable is internal and needs to be retrieved via `getStorageAt`
11     address internal masterCopy;
12 
13     /// @dev Constructor function sets address of master copy contract.
14     /// @param _masterCopy Master copy address.
15     constructor(address _masterCopy)
16         public
17     {
18         require(_masterCopy != address(0), "Invalid master copy address provided");
19         masterCopy = _masterCopy;
20     }
21 
22     /// @dev Fallback function forwards all transactions and returns all received return data.
23     fallback ()
24         external
25         payable
26     {
27         // solium-disable-next-line security/no-inline-assembly
28         assembly {
29             let mc := and(sload(0), 0xffffffffffffffffffffffffffffffffffffffff)
30             // 0xa619486e == keccak("masterCopy()"). The value is right padded to 32-bytes with 0s
31             if eq(calldataload(0), 0xa619486e00000000000000000000000000000000000000000000000000000000) {
32                 mstore(0, mc)
33                 return(0, 0x20)
34             }
35             calldatacopy(0, 0, calldatasize())
36             let success := delegatecall(gas(), mc, 0, calldatasize(), 0, 0)
37             returndatacopy(0, 0, returndatasize())
38             if eq(success, 0) { revert(0, returndatasize()) }
39             return(0, returndatasize())
40         }
41     }
42 }