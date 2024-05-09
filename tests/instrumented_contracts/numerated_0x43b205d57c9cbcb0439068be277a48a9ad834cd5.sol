1 pragma solidity 0.4.24;
2 
3 /// @title Proxy - Generic proxy contract allows to execute all transactions applying the code of a master contract.
4 /// @author Stefan George - <stefan@gnosis.pm>
5 contract Proxy {
6 
7     // masterCopy always needs to be first declared variable, to ensure that it is at the same location in the contracts to which calls are delegated.
8     address masterCopy;
9 
10     /// @dev Constructor function sets address of master copy contract.
11     /// @param _masterCopy Master copy address.
12     constructor(address _masterCopy)
13         public
14     {
15         require(_masterCopy != 0, "Invalid master copy address provided");
16         masterCopy = _masterCopy;
17     }
18 
19     /// @dev Fallback function forwards all transactions and returns all received return data.
20     function ()
21         external
22         payable
23     {
24         // solium-disable-next-line security/no-inline-assembly
25         assembly {
26             let masterCopy := and(sload(0), 0xffffffffffffffffffffffffffffffffffffffff)
27             calldatacopy(0, 0, calldatasize())
28             let success := delegatecall(gas, masterCopy, 0, calldatasize(), 0, 0)
29             returndatacopy(0, 0, returndatasize())
30             if eq(success, 0) { revert(0, returndatasize()) }
31             return(0, returndatasize())
32         }
33     }
34 
35     function implementation()
36         public
37         view
38         returns (address)
39     {
40         return masterCopy;
41     }
42 
43     function proxyType()
44         public
45         pure
46         returns (uint256)
47     {
48         return 2;
49     }
50 }
51 
52 /// @title Proxy Factory - Allows to create new proxy contact and execute a message call to the new proxy within one transaction.
53 /// @author Stefan George - <stefan@gnosis.pm>
54 contract ProxyFactory {
55 
56     event ProxyCreation(Proxy proxy);
57 
58     /// @dev Allows to create new proxy contact and execute a message call to the new proxy within one transaction.
59     /// @param masterCopy Address of master copy.
60     /// @param data Payload for message call sent to new proxy contract.
61     function createProxy(address masterCopy, bytes data)
62         public
63         returns (Proxy proxy)
64     {
65         proxy = new Proxy(masterCopy);
66         if (data.length > 0)
67             // solium-disable-next-line security/no-inline-assembly
68             assembly {
69                 if eq(call(gas, proxy, 0, add(data, 0x20), mload(data), 0, 0), 0) { revert(0, 0) }
70             }
71         emit ProxyCreation(proxy);
72     }
73 }