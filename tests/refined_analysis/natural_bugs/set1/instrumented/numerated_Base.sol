1 // SPDX-License-Identifier: GPL-2.0-or-later
2 
3 pragma solidity ^0.8.0;
4 //import "hardhat/console.sol"; // DEV_MODE
5 
6 import "./Storage.sol";
7 import "./Events.sol";
8 import "./Proxy.sol";
9 
10 abstract contract Base is Storage, Events {
11     // Modules
12 
13     function _createProxy(uint proxyModuleId) internal returns (address) {
14         require(proxyModuleId != 0, "e/create-proxy/invalid-module");
15         require(proxyModuleId <= MAX_EXTERNAL_MODULEID, "e/create-proxy/internal-module");
16 
17         // If we've already created a proxy for a single-proxy module, just return it:
18 
19         if (proxyLookup[proxyModuleId] != address(0)) return proxyLookup[proxyModuleId];
20 
21         // Otherwise create a proxy:
22 
23         address proxyAddr = address(new Proxy());
24 
25         if (proxyModuleId <= MAX_EXTERNAL_SINGLE_PROXY_MODULEID) proxyLookup[proxyModuleId] = proxyAddr;
26 
27         trustedSenders[proxyAddr] = TrustedSenderInfo({ moduleId: uint32(proxyModuleId), moduleImpl: address(0) });
28 
29         emit ProxyCreated(proxyAddr, proxyModuleId);
30 
31         return proxyAddr;
32     }
33 
34     function callInternalModule(uint moduleId, bytes memory input) internal returns (bytes memory) {
35         (bool success, bytes memory result) = moduleLookup[moduleId].delegatecall(input);
36         if (!success) revertBytes(result);
37         return result;
38     }
39 
40 
41 
42     // Modifiers
43 
44     modifier nonReentrant() {
45         require(reentrancyLock == REENTRANCYLOCK__UNLOCKED, "e/reentrancy");
46 
47         reentrancyLock = REENTRANCYLOCK__LOCKED;
48         _;
49         reentrancyLock = REENTRANCYLOCK__UNLOCKED;
50     }
51 
52     modifier reentrantOK() { // documentation only
53         _;
54     }
55 
56     // Used to flag functions which do not modify storage, but do perform a delegate call
57     // to a view function, which prohibits a standard view modifier. The flag is used to
58     // patch state mutability in compiled ABIs and interfaces.
59     modifier staticDelegate() {
60         _;
61     }
62 
63     // WARNING: Must be very careful with this modifier. It resets the free memory pointer
64     // to the value it was when the function started. This saves gas if more memory will
65     // be allocated in the future. However, if the memory will be later referenced
66     // (for example because the function has returned a pointer to it) then you cannot
67     // use this modifier.
68 
69     modifier FREEMEM() {
70         uint origFreeMemPtr;
71 
72         assembly {
73             origFreeMemPtr := mload(0x40)
74         }
75 
76         _;
77 
78         /*
79         assembly { // DEV_MODE: overwrite the freed memory with garbage to detect bugs
80             let garbage := 0xDEADBEEFDEADBEEFDEADBEEFDEADBEEFDEADBEEFDEADBEEFDEADBEEFDEADBEEF
81             for { let i := origFreeMemPtr } lt(i, mload(0x40)) { i := add(i, 32) } { mstore(i, garbage) }
82         }
83         */
84 
85         assembly {
86             mstore(0x40, origFreeMemPtr)
87         }
88     }
89 
90 
91 
92     // Error handling
93 
94     function revertBytes(bytes memory errMsg) internal pure {
95         if (errMsg.length > 0) {
96             assembly {
97                 revert(add(32, errMsg), mload(errMsg))
98             }
99         }
100 
101         revert("e/empty-error");
102     }
103 }
