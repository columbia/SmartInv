1 /**
2  *   This is an Upgradeable Contract
3  *
4 */
5 
6 pragma solidity ^0.5.3;
7 
8 /// @title Proxy - Generic proxy contract allows to execute all transactions applying the code of a master contract.
9 /// @author Stefan George - <stefan@gnosis.io>
10 /// @author Richard Meissner - <richard@gnosis.io>
11 contract Proxy {
12 
13     // masterCopy always needs to be first declared variable, to ensure that it is at the same location in the contracts to which calls are delegated.
14     // To reduce deployment costs this variable is internal and needs to be retrieved via `getStorageAt`
15     address internal masterCopy;
16 
17     /// @dev Constructor function sets address of master copy contract.
18     /// @param _masterCopy Master copy address.
19     constructor(address _masterCopy)
20         public
21     {
22         require(_masterCopy != address(0), "Invalid master copy address provided");
23         masterCopy = _masterCopy;
24     }
25 
26     /// @dev Fallback function forwards all transactions and returns all received return data.
27     function ()
28         external
29         payable
30     {
31         // solium-disable-next-line security/no-inline-assembly
32         assembly {
33             let masterCopy := and(sload(0), 0xffffffffffffffffffffffffffffffffffffffff)
34             // 0xa619486e == keccak("masterCopy()"). The value is right padded to 32-bytes with 0s
35             if eq(calldataload(0), 0xa619486e00000000000000000000000000000000000000000000000000000000) {
36                 mstore(0, masterCopy)
37                 return(0, 0x20)
38             }
39             calldatacopy(0, 0, calldatasize())
40             let success := delegatecall(gas, masterCopy, 0, calldatasize(), 0, 0)
41             returndatacopy(0, 0, returndatasize())
42             if eq(success, 0) { revert(0, returndatasize()) }
43             return(0, returndatasize())
44         }
45     }
46 }