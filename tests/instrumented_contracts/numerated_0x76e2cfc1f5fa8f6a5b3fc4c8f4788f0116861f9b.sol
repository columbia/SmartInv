1 pragma solidity ^0.5.3;
2 
3 
4 interface IProxyCreationCallback {
5     function proxyCreated(Proxy proxy, address _mastercopy, bytes calldata initializer, uint256 saltNonce) external;
6 }
7 
8 
9 
10 /// @title IProxy - Helper interface to access masterCopy of the Proxy on-chain
11 /// @author Richard Meissner - <richard@gnosis.io>
12 interface IProxy {
13     function masterCopy() external view returns (address);
14 }
15 
16 /// @title Proxy - Generic proxy contract allows to execute all transactions applying the code of a master contract.
17 /// @author Stefan George - <stefan@gnosis.io>
18 /// @author Richard Meissner - <richard@gnosis.io>
19 contract Proxy {
20 
21     // masterCopy always needs to be first declared variable, to ensure that it is at the same location in the contracts to which calls are delegated.
22     // To reduce deployment costs this variable is internal and needs to be retrieved via `getStorageAt`
23     address internal masterCopy;
24 
25     /// @dev Constructor function sets address of master copy contract.
26     /// @param _masterCopy Master copy address.
27     constructor(address _masterCopy)
28         public
29     {
30         require(_masterCopy != address(0), "Invalid master copy address provided");
31         masterCopy = _masterCopy;
32     }
33 
34     /// @dev Fallback function forwards all transactions and returns all received return data.
35     function ()
36         external
37         payable
38     {
39         // solium-disable-next-line security/no-inline-assembly
40         assembly {
41             let masterCopy := and(sload(0), 0xffffffffffffffffffffffffffffffffffffffff)
42             // 0xa619486e == keccak("masterCopy()"). The value is right padded to 32-bytes with 0s
43             if eq(calldataload(0), 0xa619486e00000000000000000000000000000000000000000000000000000000) {
44                 mstore(0, masterCopy)
45                 return(0, 0x20)
46             }
47             calldatacopy(0, 0, calldatasize())
48             let success := delegatecall(gas, masterCopy, 0, calldatasize(), 0, 0)
49             returndatacopy(0, 0, returndatasize())
50             if eq(success, 0) { revert(0, returndatasize()) }
51             return(0, returndatasize())
52         }
53     }
54 }
55 
56 
57 
58 /// @title Proxy Factory - Allows to create new proxy contact and execute a message call to the new proxy within one transaction.
59 /// @author Stefan George - <stefan@gnosis.pm>
60 contract ProxyFactory {
61 
62     event ProxyCreation(Proxy proxy);
63 
64     /// @dev Allows to create new proxy contact and execute a message call to the new proxy within one transaction.
65     /// @param masterCopy Address of master copy.
66     /// @param data Payload for message call sent to new proxy contract.
67     function createProxy(address masterCopy, bytes memory data)
68         public
69         returns (Proxy proxy)
70     {
71         proxy = new Proxy(masterCopy);
72         if (data.length > 0)
73             // solium-disable-next-line security/no-inline-assembly
74             assembly {
75                 if eq(call(gas, proxy, 0, add(data, 0x20), mload(data), 0, 0), 0) { revert(0, 0) }
76             }
77         emit ProxyCreation(proxy);
78     }
79 
80     /// @dev Allows to retrieve the runtime code of a deployed Proxy. This can be used to check that the expected Proxy was deployed.
81     function proxyRuntimeCode() public pure returns (bytes memory) {
82         return type(Proxy).runtimeCode;
83     }
84 
85     /// @dev Allows to retrieve the creation code used for the Proxy deployment. With this it is easily possible to calculate predicted address.
86     function proxyCreationCode() public pure returns (bytes memory) {
87         return type(Proxy).creationCode;
88     }
89 
90     /// @dev Allows to create new proxy contact using CREATE2 but it doesn't run the initializer.
91     ///      This method is only meant as an utility to be called from other methods
92     /// @param _mastercopy Address of master copy.
93     /// @param initializer Payload for message call sent to new proxy contract.
94     /// @param saltNonce Nonce that will be used to generate the salt to calculate the address of the new proxy contract.
95     function deployProxyWithNonce(address _mastercopy, bytes memory initializer, uint256 saltNonce)
96         internal
97         returns (Proxy proxy)
98     {
99         // If the initializer changes the proxy address should change too. Hashing the initializer data is cheaper than just concatinating it
100         bytes32 salt = keccak256(abi.encodePacked(keccak256(initializer), saltNonce));
101         bytes memory deploymentData = abi.encodePacked(type(Proxy).creationCode, uint256(_mastercopy));
102         // solium-disable-next-line security/no-inline-assembly
103         assembly {
104             proxy := create2(0x0, add(0x20, deploymentData), mload(deploymentData), salt)
105         }
106         require(address(proxy) != address(0), "Create2 call failed");
107     }
108 
109     /// @dev Allows to create new proxy contact and execute a message call to the new proxy within one transaction.
110     /// @param _mastercopy Address of master copy.
111     /// @param initializer Payload for message call sent to new proxy contract.
112     /// @param saltNonce Nonce that will be used to generate the salt to calculate the address of the new proxy contract.
113     function createProxyWithNonce(address _mastercopy, bytes memory initializer, uint256 saltNonce)
114         public
115         returns (Proxy proxy)
116     {
117         proxy = deployProxyWithNonce(_mastercopy, initializer, saltNonce);
118         if (initializer.length > 0)
119             // solium-disable-next-line security/no-inline-assembly
120             assembly {
121                 if eq(call(gas, proxy, 0, add(initializer, 0x20), mload(initializer), 0, 0), 0) { revert(0,0) }
122             }
123         emit ProxyCreation(proxy);
124     }
125 
126     /// @dev Allows to create new proxy contact, execute a message call to the new proxy and call a specified callback within one transaction
127     /// @param _mastercopy Address of master copy.
128     /// @param initializer Payload for message call sent to new proxy contract.
129     /// @param saltNonce Nonce that will be used to generate the salt to calculate the address of the new proxy contract.
130     /// @param callback Callback that will be invoced after the new proxy contract has been successfully deployed and initialized.
131     function createProxyWithCallback(address _mastercopy, bytes memory initializer, uint256 saltNonce, IProxyCreationCallback callback)
132         public
133         returns (Proxy proxy)
134     {
135         uint256 saltNonceWithCallback = uint256(keccak256(abi.encodePacked(saltNonce, callback)));
136         proxy = createProxyWithNonce(_mastercopy, initializer, saltNonceWithCallback);
137         if (address(callback) != address(0))
138             callback.proxyCreated(proxy, _mastercopy, initializer, saltNonce);
139     }
140 
141     /// @dev Allows to get the address for a new proxy contact created via `createProxyWithNonce`
142     ///      This method is only meant for address calculation purpose when you use an initializer that would revert,
143     ///      therefore the response is returned with a revert. When calling this method set `from` to the address of the proxy factory.
144     /// @param _mastercopy Address of master copy.
145     /// @param initializer Payload for message call sent to new proxy contract.
146     /// @param saltNonce Nonce that will be used to generate the salt to calculate the address of the new proxy contract.
147     function calculateCreateProxyWithNonceAddress(address _mastercopy, bytes calldata initializer, uint256 saltNonce)
148         external
149         returns (Proxy proxy)
150     {
151         proxy = deployProxyWithNonce(_mastercopy, initializer, saltNonce);
152         revert(string(abi.encodePacked(proxy)));
153     }
154 
155 }