1 pragma solidity ^0.4.13;
2 
3 contract Proxy {
4 
5     // masterCopy always needs to be first declared variable, to ensure that it is at the same location in the contracts to which calls are delegated.
6     address masterCopy;
7 
8     /// @dev Constructor function sets address of master copy contract.
9     /// @param _masterCopy Master copy address.
10     constructor(address _masterCopy)
11         public
12     {
13         require(_masterCopy != 0, "Invalid master copy address provided");
14         masterCopy = _masterCopy;
15     }
16 
17     /// @dev Fallback function forwards all transactions and returns all received return data.
18     function ()
19         external
20         payable
21     {
22         // solium-disable-next-line security/no-inline-assembly
23         assembly {
24             let masterCopy := and(sload(0), 0xffffffffffffffffffffffffffffffffffffffff)
25             calldatacopy(0, 0, calldatasize())
26             let success := delegatecall(gas, masterCopy, 0, calldatasize(), 0, 0)
27             returndatacopy(0, 0, returndatasize())
28             if eq(success, 0) { revert(0, returndatasize()) }
29             return(0, returndatasize())
30         }
31     }
32 
33     function implementation()
34         public
35         view
36         returns (address)
37     {
38         return masterCopy;
39     }
40 
41     function proxyType()
42         public
43         pure
44         returns (uint256)
45     {
46         return 2;
47     }
48 }