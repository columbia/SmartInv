1 // SPDX-License-Identifier: GPL-2.0-or-later
2 
3 pragma solidity ^0.8.0;
4 
5 import "./Base.sol";
6 
7 
8 /// @notice Main storage contract for the Euler system
9 contract Euler is Base {
10     constructor(address admin, address installerModule) {
11         emit Genesis();
12 
13         reentrancyLock = REENTRANCYLOCK__UNLOCKED;
14         upgradeAdmin = admin;
15         governorAdmin = admin;
16 
17         moduleLookup[MODULEID__INSTALLER] = installerModule;
18         address installerProxy = _createProxy(MODULEID__INSTALLER);
19         trustedSenders[installerProxy].moduleImpl = installerModule;
20     }
21 
22     string public constant name = "Euler Protocol";
23 
24     /// @notice Lookup the current implementation contract for a module
25     /// @param moduleId Fixed constant that refers to a module type (ie MODULEID__ETOKEN)
26     /// @return An internal address specifies the module's implementation code
27     function moduleIdToImplementation(uint moduleId) external view returns (address) {
28         return moduleLookup[moduleId];
29     }
30 
31     /// @notice Lookup a proxy that can be used to interact with a module (only valid for single-proxy modules)
32     /// @param moduleId Fixed constant that refers to a module type (ie MODULEID__MARKETS)
33     /// @return An address that should be cast to the appropriate module interface, ie IEulerMarkets(moduleIdToProxy(2))
34     function moduleIdToProxy(uint moduleId) external view returns (address) {
35         return proxyLookup[moduleId];
36     }
37 
38     function dispatch() external reentrantOK {
39         uint32 moduleId = trustedSenders[msg.sender].moduleId;
40         address moduleImpl = trustedSenders[msg.sender].moduleImpl;
41 
42         require(moduleId != 0, "e/sender-not-trusted");
43 
44         if (moduleImpl == address(0)) moduleImpl = moduleLookup[moduleId];
45 
46         uint msgDataLength = msg.data.length;
47         require(msgDataLength >= (4 + 4 + 20), "e/input-too-short");
48 
49         assembly {
50             let payloadSize := sub(calldatasize(), 4)
51             calldatacopy(0, 4, payloadSize)
52             mstore(payloadSize, shl(96, caller()))
53 
54             let result := delegatecall(gas(), moduleImpl, 0, add(payloadSize, 20), 0, 0)
55 
56             returndatacopy(0, 0, returndatasize())
57 
58             switch result
59                 case 0 { revert(0, returndatasize()) }
60                 default { return(0, returndatasize()) }
61         }
62     }
63 }
