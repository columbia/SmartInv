1 pragma solidity ^0.5.0;
2 
3 
4 /// @title Proxy - Generic proxy contract allows to execute all transactions applying the code of a master contract.
5 /// @author Stefan George - <stefan@gnosis.pm>
6 contract Proxy {
7 
8     // masterCopy always needs to be first declared variable, to ensure that it is at the same location in the contracts to which calls are delegated.
9     // To reduce deployment costs this variable is internal and needs to be retrieved via `getStorageAt`
10     address internal masterCopy;
11 
12     /// @dev Constructor function sets address of master copy contract.
13     /// @param _masterCopy Master copy address.
14     constructor(address _masterCopy)
15         public
16     {
17         require(_masterCopy != address(0), "Invalid master copy address provided");
18         masterCopy = _masterCopy;
19     }
20 
21     /// @dev Fallback function forwards all transactions and returns all received return data.
22     function ()
23         external
24         payable
25     {
26         // solium-disable-next-line security/no-inline-assembly
27         assembly {
28             let masterCopy := and(sload(0), 0xffffffffffffffffffffffffffffffffffffffff)
29             calldatacopy(0, 0, calldatasize())
30             let success := delegatecall(gas, masterCopy, 0, calldatasize(), 0, 0)
31             returndatacopy(0, 0, returndatasize())
32             if eq(success, 0) { revert(0, returndatasize()) }
33             return(0, returndatasize())
34         }
35     }
36 }