1 pragma solidity >=0.5.0 <0.7.0;
2 
3 /// @title IProxy - Helper interface to access masterCopy of the Proxy on-chain
4 /// @author Richard Meissner - <richard@gnosis.io>
5 interface IProxy {
6     function masterCopy() external view returns (address);
7 }
8 
9 /// @title Proxy - Generic proxy contract allows to execute all transactions applying the code of a master contract.
10 /// @author Stefan George - <stefan@gnosis.io>
11 /// @author Richard Meissner - <richard@gnosis.io>
12 contract Proxy {
13 
14     // masterCopy always needs to be first declared variable, to ensure that it is at the same location in the contracts to which calls are delegated.
15     // To reduce deployment costs this variable is internal and needs to be retrieved via `getStorageAt`
16     address internal masterCopy;
17 
18     /// @dev Constructor function sets address of master copy contract.
19     /// @param _masterCopy Master copy address.
20     constructor(address _masterCopy)
21         public
22     {
23         require(_masterCopy != address(0), "Invalid master copy address provided");
24         masterCopy = _masterCopy;
25     }
26 
27     /// @dev Fallback function forwards all transactions and returns all received return data.
28     function ()
29         external
30         payable
31     {
32         // solium-disable-next-line security/no-inline-assembly
33         assembly {
34             let masterCopy := and(sload(0), 0xffffffffffffffffffffffffffffffffffffffff)
35             // 0xa619486e == keccak("masterCopy()"). The value is right padded to 32-bytes with 0s
36             if eq(calldataload(0), 0xa619486e00000000000000000000000000000000000000000000000000000000) {
37                 mstore(0, masterCopy)
38                 return(0, 0x20)
39             }
40             calldatacopy(0, 0, calldatasize())
41             let success := delegatecall(gas, masterCopy, 0, calldatasize(), 0, 0)
42             returndatacopy(0, 0, returndatasize())
43             if eq(success, 0) { revert(0, returndatasize()) }
44             return(0, returndatasize())
45         }
46     }
47 }