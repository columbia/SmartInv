1 // SPDX-License-Identifier: GPL-2.0-or-later
2 
3 pragma solidity ^0.8.0;
4 
5 import "../BaseLogic.sol";
6 
7 interface ICustomError {
8     struct CustomErrorPayload {
9         uint code;
10         string message;
11     }
12 
13     error CustomError(CustomErrorPayload payload);
14 }
15 
16 contract TestModule is BaseLogic, ICustomError {
17     constructor(uint moduleId) BaseLogic(moduleId, bytes32(0)) {}
18 
19     function setModuleId(address moduleAddr, uint32 id) external {
20         trustedSenders[moduleAddr].moduleId = id;
21     }
22 
23     function setModuleImpl(address moduleAddr, address impl) external {
24         moduleLookup[trustedSenders[moduleAddr].moduleId] = impl;
25         trustedSenders[moduleAddr].moduleImpl = impl;
26     }
27 
28     function setPricingType(address eToken, uint16 val) external {
29         eTokenLookup[eToken].pricingType = val;
30     }
31 
32     function testCreateProxyOnInternalModule() external {
33         _createProxy(MAX_EXTERNAL_MODULEID + 1);
34     }
35 
36     function testDecreaseBorrow(address eToken, address account, uint amount) external {
37         AssetStorage storage assetStorage = eTokenLookup[eToken];
38         AssetCache memory assetCache = loadAssetCache(assetStorage.underlying, assetStorage);
39         amount = decodeExternalAmount(assetCache, amount);
40         decreaseBorrow(assetStorage, assetCache, assetStorage.dTokenAddress, account, amount);
41     }
42 
43     function testTransferBorrow(address eToken, address from, address to, uint amount) external {
44         AssetStorage storage assetStorage = eTokenLookup[eToken];
45         AssetCache memory assetCache = loadAssetCache(assetStorage.underlying, assetStorage);
46         amount = decodeExternalAmount(assetCache, amount);
47         transferBorrow(assetStorage, assetCache, assetStorage.dTokenAddress, from, to, amount);
48     }
49 
50     function testEmitViaProxyTransfer(address proxyAddr, address from, address to, uint value) external {
51         emitViaProxy_Transfer(proxyAddr, from, to, value);
52     }
53 
54     function testEmitViaProxyApproval(address proxyAddr, address owner, address spender, uint value) external {
55         emitViaProxy_Approval(proxyAddr, owner, spender, value);
56     }
57 
58     function testDispatchEmptyData() external {
59         trustedSenders[address(this)].moduleId = 200;
60         (bool success, bytes memory data) = address(this).call(abi.encodeWithSignature("dispatch()"));
61         if (!success) revertBytes(data);
62     }
63 
64     function testUnrecognizedETokenCaller() external {
65         (bool success, bytes memory data) = moduleLookup[MODULEID__ETOKEN].delegatecall(abi.encodeWithSelector(IERC20.totalSupply.selector));
66         if (!success) revertBytes(data);
67     }
68 
69     function testUnrecognizedDTokenCaller() external {
70         (bool success, bytes memory data) = moduleLookup[MODULEID__DTOKEN].delegatecall(abi.encodeWithSelector(IERC20.totalSupply.selector));
71         if (!success) revertBytes(data);
72     }
73 
74     function testCall() external {
75         upgradeAdmin = upgradeAdmin; // suppress visibility warning
76     }
77 
78     function testRevertBytesCustomError(uint code, string calldata message) external {
79         CustomErrorThrower thrower = new CustomErrorThrower();
80 
81         (, bytes memory data) = address(thrower).call(abi.encodeWithSelector(CustomErrorThrower.throwCustomError.selector, code, message));
82 
83         revertBytes(data);
84     } 
85 
86     function issueLogToProxy(bytes memory payload) private {
87         (, address proxyAddr) = unpackTrailingParams();
88         (bool success,) = proxyAddr.call(payload);
89         require(success, "e/log-proxy-fail");
90     }
91 
92     function testProxyLogs() external {
93         bytes memory extraData = "hello";
94 
95         issueLogToProxy(abi.encodePacked(
96                                uint8(0),
97                                extraData
98                         ));
99 
100         issueLogToProxy(abi.encodePacked(
101                                uint8(1),
102                                bytes32(uint(1)),
103                                extraData
104                         ));
105 
106         issueLogToProxy(abi.encodePacked(
107                                uint8(2),
108                                bytes32(uint(1)),
109                                bytes32(uint(2)),
110                                extraData
111                         ));
112 
113         issueLogToProxy(abi.encodePacked(
114                                uint8(3),
115                                bytes32(uint(1)),
116                                bytes32(uint(2)),
117                                bytes32(uint(3)),
118                                extraData
119                         ));
120 
121         issueLogToProxy(abi.encodePacked(
122                                uint8(4),
123                                bytes32(uint(1)),
124                                bytes32(uint(2)),
125                                bytes32(uint(3)),
126                                bytes32(uint(4)),
127                                extraData
128                         ));
129     }
130 }
131 
132 contract CustomErrorThrower is ICustomError {
133     function throwCustomError(uint code, string calldata message) external pure {
134         revert CustomError(CustomErrorPayload({
135             code: code,
136             message: message
137         }));
138     }
139 }
