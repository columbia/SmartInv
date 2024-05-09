1 // SPDX-License-Identifier: LGPL-3.0-or-later
2 // Taken from: https://github.com/gnosis/safe-contracts/blob/development/contracts/proxies/GnosisSafeProxy.sol
3 pragma solidity ^0.7.0;
4 
5 /// @title IProxy - Helper interface to access masterCopy of the Proxy on-chain
6 /// @author Richard Meissner - <richard@gnosis.io>
7 interface IProxy {
8     function masterCopy() external view returns (address);
9 }
10 
11 /// @title WalletProxy - Generic proxy contract allows to execute all transactions applying the code of a master contract.
12 /// @author Stefan George - <stefan@gnosis.io>
13 /// @author Richard Meissner - <richard@gnosis.io>
14 contract WalletProxy {
15 
16     // masterCopy always needs to be first declared variable, to ensure that it is at the same location in the contracts to which calls are delegated.
17     // To reduce deployment costs this variable is internal and needs to be retrieved via `getStorageAt`
18     address internal masterCopy;
19 
20     /// @dev Constructor function sets address of master copy contract.
21     /// @param _masterCopy Master copy address.
22     constructor(address _masterCopy)
23     {
24         require(_masterCopy != address(0), "Invalid master copy address provided");
25         masterCopy = _masterCopy;
26     }
27 
28     /// @dev Fallback function forwards all transactions and returns all received return data.
29     fallback()
30     payable
31     external
32     {
33         // solium-disable-next-line security/no-inline-assembly
34         assembly {
35             let _masterCopy := and(sload(0), 0xffffffffffffffffffffffffffffffffffffffff)
36         // 0xa619486e == keccak("masterCopy()"). The value is right padded to 32-bytes with 0s
37             if eq(calldataload(0), 0xa619486e00000000000000000000000000000000000000000000000000000000) {
38                 mstore(0, _masterCopy)
39                 return(0, 0x20)
40             }
41             calldatacopy(0, 0, calldatasize())
42             let success := delegatecall(gas(), _masterCopy, 0, calldatasize(), 0, 0)
43             returndatacopy(0, 0, returndatasize())
44             if eq(success, 0) { revert(0, returndatasize()) }
45             return(0, returndatasize())
46         }
47     }
48 }