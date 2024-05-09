1 pragma solidity ^0.5.0;
2 
3 // File: contracts/proxies/Proxy.sol
4 
5 /// @title Proxy - Generic proxy contract allows to execute all transactions applying the code of a master contract.
6 /// @author Stefan George - <stefan@gnosis.pm>
7 contract Proxy {
8 
9     // masterCopy always needs to be first declared variable, to ensure that it is at the same location in the contracts to which calls are delegated.
10     address masterCopy;
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
36 
37     function implementation()
38         public
39         view
40         returns (address)
41     {
42         return masterCopy;
43     }
44 
45     function proxyType()
46         public
47         pure
48         returns (uint256)
49     {
50         return 2;
51     }
52 }
53 
54 // File: contracts/proxies/ProxyFactory.sol
55 
56 /// @title Proxy Factory - Allows to create new proxy contact and execute a message call to the new proxy within one transaction.
57 /// @author Stefan George - <stefan@gnosis.pm>
58 contract ProxyFactory {
59 
60     event ProxyCreation(Proxy proxy);
61 
62     /// @dev Allows to create new proxy contact and execute a message call to the new proxy within one transaction.
63     /// @param masterCopy Address of master copy.
64     /// @param data Payload for message call sent to new proxy contract.
65     function createProxy(address masterCopy, bytes memory data)
66         public
67         returns (Proxy proxy)
68     {
69         proxy = new Proxy(masterCopy);
70         if (data.length > 0)
71             // solium-disable-next-line security/no-inline-assembly
72             assembly {
73                 if eq(call(gas, proxy, 0, add(data, 0x20), mload(data), 0, 0), 0) { revert(0, 0) }
74             }
75         emit ProxyCreation(proxy);
76     }
77 }