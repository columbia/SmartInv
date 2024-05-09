1 /**
2  *Submitted for verification at Etherscan.io on 2020-01-13
3 */
4 
5 pragma solidity ^0.5.3;
6 
7 /// @title Proxy - Generic proxy contract allows to execute all transactions applying the code of a master contract.
8 /// @author Stefan George - <stefan@gnosis.io>
9 /// @author Richard Meissner - <richard@gnosis.io>
10 contract Proxy {
11 
12     // masterCopy always needs to be first declared variable, to ensure that it is at the same location in the contracts to which calls are delegated.
13     // To reduce deployment costs this variable is internal and needs to be retrieved via `getStorageAt`
14     address internal masterCopy;
15 
16     /// @dev Constructor function sets address of master copy contract.
17     /// @param _masterCopy Master copy address.
18     constructor(address _masterCopy)
19         public
20     {
21         require(_masterCopy != address(0), "Invalid master copy address provided");
22         masterCopy = _masterCopy;
23     }
24 
25     /// @dev Fallback function forwards all transactions and returns all received return data.
26     function ()
27         external
28         payable
29     {
30         // solium-disable-next-line security/no-inline-assembly
31         assembly {
32             let masterCopy := and(sload(0), 0xffffffffffffffffffffffffffffffffffffffff)
33             // 0xa619486e == keccak("masterCopy()"). The value is right padded to 32-bytes with 0s
34             if eq(calldataload(0), 0xa619486e00000000000000000000000000000000000000000000000000000000) {
35                 mstore(0, masterCopy)
36                 return(0, 0x20)
37             }
38             calldatacopy(0, 0, calldatasize())
39             let success := delegatecall(gas, masterCopy, 0, calldatasize(), 0, 0)
40             returndatacopy(0, 0, returndatasize())
41             if eq(success, 0) { revert(0, returndatasize()) }
42             return(0, returndatasize())
43         }
44     }
45 }