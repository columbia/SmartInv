1 pragma solidity ^0.5.0;
2 
3 contract Proxy {
4 
5     // masterCopy always needs to be first declared variable, to ensure that it is at the same location in the contracts to which calls are delegated.
6     // To reduce deployment costs this variable is internal and needs to be retrieved via `getStorageAt`
7     address internal masterCopy;
8 
9     /// @dev Constructor function sets address of master copy contract.
10     /// @param _masterCopy Master copy address.
11     constructor(address _masterCopy)
12         public
13     {
14         require(_masterCopy != address(0), "Invalid master copy address provided");
15         masterCopy = _masterCopy;
16     }
17 
18     /// @dev Fallback function forwards all transactions and returns all received return data.
19     function ()
20         external
21         payable
22     {
23         // solium-disable-next-line security/no-inline-assembly
24         assembly {
25             let masterCopy := and(sload(0), 0xffffffffffffffffffffffffffffffffffffffff)
26             calldatacopy(0, 0, calldatasize())
27             let success := delegatecall(gas, masterCopy, 0, calldatasize(), 0, 0)
28             returndatacopy(0, 0, returndatasize())
29             if eq(success, 0) { revert(0, returndatasize()) }
30             return(0, returndatasize())
31         }
32     }
33 }
34 
35 contract ProxyFactory {
36 
37     event ProxyCreation(Proxy proxy);
38 
39     /// @dev Allows to create new proxy contact and execute a message call to the new proxy within one transaction.
40     /// @param masterCopy Address of master copy.
41     /// @param data Payload for message call sent to new proxy contract.
42     function createProxy(address masterCopy, bytes memory data)
43         public
44         returns (Proxy proxy)
45     {
46         proxy = new Proxy(masterCopy);
47         if (data.length > 0)
48             // solium-disable-next-line security/no-inline-assembly
49             assembly {
50                 if eq(call(gas, proxy, 0, add(data, 0x20), mload(data), 0, 0), 0) { revert(0, 0) }
51             }
52         emit ProxyCreation(proxy);
53     }
54 
55     /// @dev Allows to retrieve the runtime code of a deployed Proxy. This can be used to check that the expected Proxy was deployed.
56     function proxyRuntimeCode() public pure returns (bytes memory) {
57         return type(Proxy).runtimeCode;
58     }
59 
60     /// @dev Allows to retrieve the creation code used for the Proxy deployment. With this it is easily possible to calculate predicted address.
61     function proxyCreationCode() public pure returns (bytes memory) {
62         return type(Proxy).creationCode;
63     }
64 
65     /// @dev Allows to create new proxy contact and execute a message call to the new proxy within one transaction.
66     /// @param _mastercopy Address of master copy.
67     /// @param initializer Payload for message call sent to new proxy contract.
68     /// @param saltNonce Nonce that will be used to generate the salt to calculate the address of the new proxy contract.
69     function createProxyWithNonce(address _mastercopy, bytes memory initializer, uint256 saltNonce)
70         public
71         returns (Proxy proxy)
72     {
73         // If the initializer changes the proxy address should change too. Hashing the initializer data is cheaper than just concatinating it
74         bytes32 salt = keccak256(abi.encodePacked(keccak256(initializer), saltNonce));
75         bytes memory deploymentData = abi.encodePacked(type(Proxy).creationCode, uint256(_mastercopy));
76         // solium-disable-next-line security/no-inline-assembly
77         assembly {
78             proxy := create2(0x0, add(0x20, deploymentData), mload(deploymentData), salt)
79         }
80         if (initializer.length > 0)
81             // solium-disable-next-line security/no-inline-assembly
82             assembly {
83                 if eq(call(gas, proxy, 0, add(initializer, 0x20), mload(initializer), 0, 0), 0) { revert(0,0) }
84             }
85         emit ProxyCreation(proxy);
86     }
87 }