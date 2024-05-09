1 pragma solidity 0.5.11;
2 
3 
4 interface DharmaSmartWalletInterface {
5   enum ActionType {
6     Cancel, SetUserSigningKey, Generic, GenericAtomicBatch, SAIWithdrawal,
7     USDCWithdrawal, ETHWithdrawal, SetEscapeHatch, RemoveEscapeHatch,
8     DisableEscapeHatch, DAIWithdrawal, _ELEVEN, _TWELVE, _THIRTEEN,
9     _FOURTEEN, _FIFTEEN, _SIXTEEN, _SEVENTEEN, _EIGHTEEN, _NINETEEN, _TWENTY
10   }
11   function getVersion() external pure returns (uint256 version);
12 }
13 
14 
15 interface DharmaSmartWalletFactoryV1Interface {
16   function newSmartWallet(
17     address userSigningKey
18   ) external returns (address wallet);
19   
20   function getNextSmartWallet(
21     address userSigningKey
22   ) external view returns (address wallet);
23 }
24 
25 interface DharmaKeyRingFactoryV2Interface {
26   function newKeyRing(
27     address userSigningKey, address targetKeyRing
28   ) external returns (address keyRing);
29 
30   function getNextKeyRing(
31     address userSigningKey
32   ) external view returns (address targetKeyRing);
33 }
34 
35 
36 interface DharmaKeyRegistryInterface {
37   function getKeyForUser(address account) external view returns (address key);
38 }
39 
40 
41 contract DharmaDeploymentHelper {
42   DharmaSmartWalletFactoryV1Interface internal constant _WALLET_FACTORY = (
43     DharmaSmartWalletFactoryV1Interface(
44       0xfc00C80b0000007F73004edB00094caD80626d8D
45     )
46   );
47   
48   DharmaKeyRingFactoryV2Interface internal constant _KEYRING_FACTORY = (
49     DharmaKeyRingFactoryV2Interface(
50       0x2484000059004afB720000dc738434fA6200F49D
51     )
52   );
53 
54   DharmaKeyRegistryInterface internal constant _KEY_REGISTRY = (
55     DharmaKeyRegistryInterface(
56       0x000000000D38df53b45C5733c7b34000dE0BDF52
57     )
58   );
59   
60   address internal constant beacon = 0x000000000026750c571ce882B17016557279ADaa;
61 
62   // Use the smart wallet instance runtime code hash to verify expected targets.
63   bytes32 internal constant _SMART_WALLET_INSTANCE_RUNTIME_HASH = bytes32(
64     0xe25d4f154acb2394ee6c18d64fb5635959ba063d57f83091ec9cf34be16224d7
65   );
66 
67   // The keyring instance runtime code hash is used to verify expected targets.
68   bytes32 internal constant _KEY_RING_INSTANCE_RUNTIME_HASH = bytes32(
69     0xb15b24278e79e856d35b262e76ff7d3a759b17e625ff72adde4116805af59648
70   );
71   
72   // Deploy a smart wallet and call it with arbitrary data.
73   function deployWalletAndCall(
74     address userSigningKey, // the key ring
75     address smartWallet,
76     bytes calldata data
77   ) external returns (bool ok, bytes memory returnData) {
78     _deployNewSmartWalletIfNeeded(userSigningKey, smartWallet);
79     (ok, returnData) = smartWallet.call(data);
80   }
81 
82   // Deploy a key ring and a smart wallet, then call the smart wallet
83   // with arbitrary data.
84   function deployKeyRingAndWalletAndCall(
85     address initialSigningKey, // the initial key on the keyring
86     address keyRing,
87     address smartWallet,
88     bytes calldata data
89   ) external returns (bool ok, bytes memory returnData) {
90     _deployNewKeyRingIfNeeded(initialSigningKey, keyRing);
91     _deployNewSmartWalletIfNeeded(keyRing, smartWallet);
92     (ok, returnData) = smartWallet.call(data);
93   }
94  
95   // Get an actionID for the first action on a smart wallet before it
96   // has been deployed.
97   // no argument: empty string - abi.encode();
98   // one argument, like setUserSigningKey: abi.encode(argument)
99   // withdrawals: abi.encode(amount, recipient)
100   // generics: abi.encode(to, data)
101   // generic batch: abi.encode(calls) -> array of {address to, bytes data}
102   function getInitialActionID(
103     address smartWallet,
104     address initialUserSigningKey, // the key ring
105     DharmaSmartWalletInterface.ActionType actionType,
106     uint256 minimumActionGas,
107     bytes calldata arguments
108   ) external view returns (bytes32 actionID) {
109     actionID = keccak256(
110       abi.encodePacked(
111         smartWallet,
112         _getVersion(),
113         initialUserSigningKey,
114         _KEY_REGISTRY.getKeyForUser(smartWallet),
115         uint256(0), // nonce starts at 0
116         minimumActionGas,
117         actionType,
118         arguments
119       )
120     );
121   }
122  
123   function _deployNewKeyRingIfNeeded(
124     address initialSigningKey, address expectedKeyRing
125   ) internal returns (address keyRing) {
126     // Only deploy if a smart wallet doesn't already exist at expected address.
127     bytes32 hash;
128     assembly { hash := extcodehash(expectedKeyRing) }
129     if (hash != _KEY_RING_INSTANCE_RUNTIME_HASH) {
130       require(
131         _KEYRING_FACTORY.getNextKeyRing(initialSigningKey) == expectedKeyRing,
132         "Key ring to be deployed does not match expected key ring."
133       );
134       keyRing = _KEYRING_FACTORY.newKeyRing(initialSigningKey, expectedKeyRing);
135     } else {
136       // Note: the key ring at the expected address may have been modified so that
137       // the supplied user signing key is no longer a valid key - therefore, treat
138       // this helper as a way to protect against race conditions, not as a primary
139       // mechanism for interacting with key ring contracts.
140       keyRing = expectedKeyRing;
141     }
142   } 
143   
144   function _deployNewSmartWalletIfNeeded(
145     address userSigningKey, // the key ring
146     address expectedSmartWallet
147   ) internal returns (address smartWallet) {
148     // Only deploy if a smart wallet doesn't already exist at expected address.
149     bytes32 hash;
150     assembly { hash := extcodehash(expectedSmartWallet) }
151     if (hash != _SMART_WALLET_INSTANCE_RUNTIME_HASH) {
152       require(
153         _WALLET_FACTORY.getNextSmartWallet(userSigningKey) == expectedSmartWallet,
154         "Smart wallet to be deployed does not match expected smart wallet."
155       );
156       smartWallet = _WALLET_FACTORY.newSmartWallet(userSigningKey);
157     } else {
158       // Note: the smart wallet at the expected address may have been modified
159       // so that the supplied user signing key is no longer a valid key.
160       // Therefore, treat this helper as a way to protect against race
161       // conditions, not as a primary mechanism for interacting with smart
162       // wallet contracts.
163       smartWallet = expectedSmartWallet;
164     }
165   }
166 
167   function _getVersion() internal view returns (uint256 version) {
168     (, bytes memory data) = beacon.staticcall("");
169     address implementation = abi.decode(data, (address));
170     version = DharmaSmartWalletInterface(implementation).getVersion();
171   }
172 }