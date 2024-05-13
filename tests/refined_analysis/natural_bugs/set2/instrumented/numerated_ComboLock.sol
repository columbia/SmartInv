1 // SPDX-License-Identifier: GNU-GPL v3.0 or later
2 
3 pragma solidity ^0.8.0;
4 
5 import "../../interfaces/IAddressRegistry.sol";
6 import "../../interfaces/IRevest.sol";
7 import "../../interfaces/ITokenVault.sol";
8 import "../../interfaces/IOracleDispatch.sol";
9 import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
10 import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
11 import '@openzeppelin/contracts/utils/introspection/ERC165.sol';
12 import "../../utils/SecuredAddressLock.sol";
13 
14 /**
15  * @title
16  * @dev
17  */
18 contract BinaryComboLock is SecuredAddressLock, ERC165  {
19 
20     string public metadataURI = "https://revest.mypinata.cloud/ipfs/QmQMVXytJCebqKVbo4iMyU4gRuG5pUAdCKgf5UbZf51tAc";
21 
22     constructor(address registry) SecuredAddressLock(registry) {}
23 
24     mapping (uint => ComboLock) private locks;
25 
26     struct ComboLock {
27         uint endTime;
28         uint unlockValue;
29         bool unlockRisingEdge;
30         bool isAnd;
31         address asset1;
32         address asset2;
33         address oracle;
34     }
35 
36     using SafeERC20 for IERC20;
37 
38     function supportsInterface(bytes4 interfaceId) public view override(ERC165, IERC165) returns (bool) {
39         return interfaceId == type(IAddressLock).interfaceId
40             || interfaceId == type(IRegistryProvider).interfaceId
41             || super.supportsInterface(interfaceId);
42     }
43 
44     function isUnlockable(uint , uint lockId) public view override returns (bool) {
45         ComboLock memory lock = locks[lockId];
46         if(lock.isAnd) {
47             return block.timestamp > lock.endTime && getLockMaturity(lockId);
48         } else {
49             // Or
50             return block.timestamp > lock.endTime || getLockMaturity(lockId);
51         }
52     }
53 
54 
55     // Create the lock within that contract DURING minting
56     // Likely will be best-practices to call this AFTER minting, once we know that fnftId is set
57     function createLock(uint, uint lockId, bytes memory arguments) external override onlyRevestController {
58         uint endTime;
59         uint unlockValue;
60         bool unlockRisingEdge;
61         bool isAnd;
62         address asset1;
63         address asset2;
64         address oracleAdd;
65         (endTime, unlockValue, unlockRisingEdge, isAnd, asset1, asset2, oracleAdd) =
66             abi.decode(arguments, (uint, uint, bool, bool, address, address, address));
67         ComboLock memory combo = ComboLock(endTime, unlockValue, unlockRisingEdge, isAnd, asset1, asset2, oracleAdd);
68         IOracleDispatch oracle = IOracleDispatch(oracleAdd);
69         bool oraclePresent = oracle.getPairHasOracle(asset1, asset2);
70         //If the oracle is not present, attempt to initialize it
71         if(!oraclePresent && oracle.oracleNeedsInitialization(asset1, asset2)) {
72             oraclePresent = oracle.initializeOracle(asset1, asset2);
73         }
74         require(oraclePresent, "E049");
75 
76         locks[lockId] = combo;
77 
78     }
79 
80     function updateLock(uint, uint lockId, bytes memory ) external override {
81         // For a combo lock, there are no arguments
82         IOracleDispatch oracle = IOracleDispatch(locks[lockId].oracle);
83         oracle.updateOracle(locks[lockId].asset1, locks[lockId].asset2);
84     }
85 
86     function needsUpdate() external pure override returns (bool) {
87         return true;
88     }
89 
90     function getDisplayValues(uint, uint lockId) external view override returns (bytes memory) {
91         ComboLock memory lockDetails = locks[lockId];
92         IOracleDispatch oracle = IOracleDispatch(locks[lockId].oracle);
93         bool needsUpdateNow = oracle.oracleNeedsUpdates(lockDetails.asset1, lockDetails.asset2);
94         if(needsUpdateNow) {
95             uint twapPrice = oracle.getValueOfAsset(lockDetails.asset1, lockDetails.asset2, lockDetails.unlockRisingEdge);
96             uint instantPrice = oracle.getInstantPrice(lockDetails.asset1, lockDetails.asset2);
97             if(lockDetails.unlockRisingEdge) {
98                 needsUpdateNow = instantPrice > lockDetails.unlockValue && twapPrice < lockDetails.unlockValue;
99             } else {
100                 needsUpdateNow = instantPrice < lockDetails.unlockValue && twapPrice > lockDetails.unlockValue;
101             }
102         }
103         return abi.encode(lockDetails.endTime, lockDetails.unlockValue, lockDetails.unlockRisingEdge, lockDetails.isAnd, lockDetails.asset1, lockDetails.asset2, lockDetails.oracle, needsUpdateNow);
104     }
105 
106     function setMetadata(string memory _metadataURI) external onlyOwner {
107         metadataURI = _metadataURI;
108     }
109 
110     function getMetadata() external view override returns (string memory) {
111         return metadataURI;
112     }
113 
114     function getValueLockMaturity(uint lockId) internal returns (bool) {
115         if(getLockMaturity(lockId)) {
116             return true;
117         } else {
118             IOracleDispatch oracle = IOracleDispatch(locks[lockId].oracle);
119             return oracle.updateOracle(locks[lockId].asset1, locks[lockId].asset2) &&
120                             getLockMaturity(lockId);
121         }
122     }
123 
124     function getLockMaturity(uint lockId) internal view returns (bool) {
125         IOracleDispatch oracle = IOracleDispatch(locks[lockId].oracle);
126         // Will not trigger an update
127         bool rising = locks[lockId].unlockRisingEdge;
128         uint currentValue = oracle.getValueOfAsset(locks[lockId].asset1, locks[lockId].asset2, rising);
129         // Perform comparison
130         if (rising) {
131             return currentValue >= locks[lockId].unlockValue;
132         } else {
133             // Only mature if current value less than unlock value
134             return currentValue < locks[lockId].unlockValue;
135         }
136     }
137 }
