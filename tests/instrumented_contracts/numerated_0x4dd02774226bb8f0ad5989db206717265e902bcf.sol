1 // SPDX-License-Identifier: LGPL-3.0-only
2 pragma solidity >=0.7.0 <0.9.0;
3 
4 /// @title IProxy - Helper interface to access masterCopy of the Proxy on-chain
5 /// @author Richard Meissner - <richard@gnosis.io>
6 interface IProxy {
7     function masterCopy() external view returns (address);
8 }
9 
10 /// @title GnosisSafeProxy - Generic proxy contract allows to execute all transactions applying the code of a master contract.
11 /// @author Stefan George - <stefan@gnosis.io>
12 /// @author Richard Meissner - <richard@gnosis.io>
13 contract GnosisSafeProxy {
14     // singleton always needs to be first declared variable, to ensure that it is at the same location in the contracts to which calls are delegated.
15     // To reduce deployment costs this variable is internal and needs to be retrieved via `getStorageAt`
16     address internal singleton;
17 
18     /// @dev Constructor function sets address of singleton contract.
19     /// @param _singleton Singleton address.
20     constructor(address _singleton) {
21         require(_singleton != address(0), "Invalid singleton address provided");
22         singleton = _singleton;
23     }
24 
25     /// @dev Fallback function forwards all transactions and returns all received return data.
26     fallback() external payable {
27         // solhint-disable-next-line no-inline-assembly
28         assembly {
29             let _singleton := and(sload(0), 0xffffffffffffffffffffffffffffffffffffffff)
30             // 0xa619486e == keccak("masterCopy()"). The value is right padded to 32-bytes with 0s
31             if eq(calldataload(0), 0xa619486e00000000000000000000000000000000000000000000000000000000) {
32                 mstore(0, _singleton)
33                 return(0, 0x20)
34             }
35             calldatacopy(0, 0, calldatasize())
36             let success := delegatecall(gas(), _singleton, 0, calldatasize(), 0, 0)
37             returndatacopy(0, 0, returndatasize())
38             if eq(success, 0) {
39                 revert(0, returndatasize())
40             }
41             return(0, returndatasize())
42         }
43     }
44 }
45 
46 /// @title Proxy Factory - Allows to create new proxy contact and execute a message call to the new proxy within one transaction.
47 /// @author Stefan George - <stefan@gnosis.pm>
48 contract GnosisSafeProxyFactory {
49     event ProxyCreation(GnosisSafeProxy proxy, address singleton);
50 
51     /// @dev Allows to create new proxy contact and execute a message call to the new proxy within one transaction.
52     /// @param singleton Address of singleton contract.
53     /// @param data Payload for message call sent to new proxy contract.
54     function createProxy(address singleton, bytes memory data) public returns (GnosisSafeProxy proxy) {
55         proxy = new GnosisSafeProxy(singleton);
56         if (data.length > 0)
57             // solhint-disable-next-line no-inline-assembly
58             assembly {
59                 if eq(call(gas(), proxy, 0, add(data, 0x20), mload(data), 0, 0), 0) {
60                     revert(0, 0)
61                 }
62             }
63         emit ProxyCreation(proxy, singleton);
64     }
65 
66     /// @dev Allows to retrieve the runtime code of a deployed Proxy. This can be used to check that the expected Proxy was deployed.
67     function proxyRuntimeCode() public pure returns (bytes memory) {
68         return type(GnosisSafeProxy).runtimeCode;
69     }
70 
71     /// @dev Allows to retrieve the creation code used for the Proxy deployment. With this it is easily possible to calculate predicted address.
72     function proxyCreationCode() public pure returns (bytes memory) {
73         return type(GnosisSafeProxy).creationCode;
74     }
75 
76     /// @dev Allows to create new proxy contact using CREATE2 but it doesn't run the initializer.
77     ///      This method is only meant as an utility to be called from other methods
78     /// @param _singleton Address of singleton contract.
79     /// @param initializer Payload for message call sent to new proxy contract.
80     /// @param saltNonce Nonce that will be used to generate the salt to calculate the address of the new proxy contract.
81     function deployProxyWithNonce(
82         address _singleton,
83         bytes memory initializer,
84         uint256 saltNonce
85     ) internal returns (GnosisSafeProxy proxy) {
86         // If the initializer changes the proxy address should change too. Hashing the initializer data is cheaper than just concatinating it
87         bytes32 salt = keccak256(abi.encodePacked(keccak256(initializer), saltNonce));
88         bytes memory deploymentData = abi.encodePacked(type(GnosisSafeProxy).creationCode, uint256(uint160(_singleton)));
89         // solhint-disable-next-line no-inline-assembly
90         assembly {
91             proxy := create2(0x0, add(0x20, deploymentData), mload(deploymentData), salt)
92         }
93         require(address(proxy) != address(0), "Create2 call failed");
94     }
95 
96     /// @dev Allows to create new proxy contact and execute a message call to the new proxy within one transaction.
97     /// @param _singleton Address of singleton contract.
98     /// @param initializer Payload for message call sent to new proxy contract.
99     /// @param saltNonce Nonce that will be used to generate the salt to calculate the address of the new proxy contract.
100     function createProxyWithNonce(
101         address _singleton,
102         bytes memory initializer,
103         uint256 saltNonce
104     ) public returns (GnosisSafeProxy proxy) {
105         proxy = deployProxyWithNonce(_singleton, initializer, saltNonce);
106         if (initializer.length > 0)
107             // solhint-disable-next-line no-inline-assembly
108             assembly {
109                 if eq(call(gas(), proxy, 0, add(initializer, 0x20), mload(initializer), 0, 0), 0) {
110                     revert(0, 0)
111                 }
112             }
113         emit ProxyCreation(proxy, _singleton);
114     }
115 
116     /// @dev Allows to create new proxy contact, execute a message call to the new proxy and call a specified callback within one transaction
117     /// @param _singleton Address of singleton contract.
118     /// @param initializer Payload for message call sent to new proxy contract.
119     /// @param saltNonce Nonce that will be used to generate the salt to calculate the address of the new proxy contract.
120     /// @param callback Callback that will be invoced after the new proxy contract has been successfully deployed and initialized.
121     function createProxyWithCallback(
122         address _singleton,
123         bytes memory initializer,
124         uint256 saltNonce,
125         IProxyCreationCallback callback
126     ) public returns (GnosisSafeProxy proxy) {
127         uint256 saltNonceWithCallback = uint256(keccak256(abi.encodePacked(saltNonce, callback)));
128         proxy = createProxyWithNonce(_singleton, initializer, saltNonceWithCallback);
129         if (address(callback) != address(0)) callback.proxyCreated(proxy, _singleton, initializer, saltNonce);
130     }
131 
132     /// @dev Allows to get the address for a new proxy contact created via `createProxyWithNonce`
133     ///      This method is only meant for address calculation purpose when you use an initializer that would revert,
134     ///      therefore the response is returned with a revert. When calling this method set `from` to the address of the proxy factory.
135     /// @param _singleton Address of singleton contract.
136     /// @param initializer Payload for message call sent to new proxy contract.
137     /// @param saltNonce Nonce that will be used to generate the salt to calculate the address of the new proxy contract.
138     function calculateCreateProxyWithNonceAddress(
139         address _singleton,
140         bytes calldata initializer,
141         uint256 saltNonce
142     ) external returns (GnosisSafeProxy proxy) {
143         proxy = deployProxyWithNonce(_singleton, initializer, saltNonce);
144         revert(string(abi.encodePacked(proxy)));
145     }
146 }
147 
148 interface IProxyCreationCallback {
149     function proxyCreated(
150         GnosisSafeProxy proxy,
151         address _singleton,
152         bytes calldata initializer,
153         uint256 saltNonce
154     ) external;
155 }