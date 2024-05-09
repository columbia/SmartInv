1 // SPDX-License-Identifier: LGPL-3.0-only
2 pragma solidity >=0.7.0 <0.9.0;
3 
4 /**
5  * @title IProxy - Helper interface to access the singleton address of the Proxy on-chain.
6  * @author Richard Meissner - @rmeissner
7  */
8 interface IProxy {
9     function masterCopy() external view returns (address);
10 }
11 
12 /**
13  * @title SafeProxy - Generic proxy contract allows to execute all transactions applying the code of a master contract.
14  * @author Stefan George - <stefan@gnosis.io>
15  * @author Richard Meissner - <richard@gnosis.io>
16  */
17 contract ButterSafeProxy {
18     // Singleton always needs to be first declared variable, to ensure that it is at the same location in the contracts to which calls are delegated.
19     // To reduce deployment costs this variable is internal and needs to be retrieved via `getStorageAt`
20     address internal singleton;
21 
22     /**
23      * @notice Constructor function sets address of singleton contract.
24      * @param _singleton Singleton address.
25      */
26     constructor(address _singleton) {
27         require(_singleton != address(0), "Invalid singleton address provided");
28         singleton = _singleton;
29     }
30 
31     /// @dev Fallback function forwards all transactions and returns all received return data.
32     fallback() external payable {
33         // solhint-disable-next-line no-inline-assembly
34         assembly {
35             let _singleton := and(sload(0), 0xffffffffffffffffffffffffffffffffffffffff)
36             // 0xa619486e == keccak("masterCopy()"). The value is right padded to 32-bytes with 0s
37             if eq(calldataload(0), 0xa619486e00000000000000000000000000000000000000000000000000000000) {
38                 mstore(0, _singleton)
39                 return(0, 0x20)
40             }
41             calldatacopy(0, 0, calldatasize())
42             let success := delegatecall(gas(), _singleton, 0, calldatasize(), 0, 0)
43             returndatacopy(0, 0, returndatasize())
44             if eq(success, 0) {
45                 revert(0, returndatasize())
46             }
47             return(0, returndatasize())
48         }
49     }
50 
51     receive() external payable {
52       revert();
53     }
54 }