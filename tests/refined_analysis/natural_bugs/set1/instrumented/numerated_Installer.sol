1 // SPDX-License-Identifier: GPL-2.0-or-later
2 
3 pragma solidity ^0.8.0;
4 
5 import "../BaseModule.sol";
6 
7 
8 contract Installer is BaseModule {
9     constructor(bytes32 moduleGitCommit_) BaseModule(MODULEID__INSTALLER, moduleGitCommit_) {}
10 
11     modifier adminOnly {
12         address msgSender = unpackTrailingParamMsgSender();
13         require(msgSender == upgradeAdmin, "e/installer/unauthorized");
14         _;
15     }
16 
17     function getUpgradeAdmin() external view returns (address) {
18         return upgradeAdmin;
19     }
20 
21     function setUpgradeAdmin(address newUpgradeAdmin) external nonReentrant adminOnly {
22         require(newUpgradeAdmin != address(0), "e/installer/bad-admin-addr");
23         upgradeAdmin = newUpgradeAdmin;
24         emit InstallerSetUpgradeAdmin(newUpgradeAdmin);
25     }
26 
27     function setGovernorAdmin(address newGovernorAdmin) external nonReentrant adminOnly {
28         require(newGovernorAdmin != address(0), "e/installer/bad-gov-addr");
29         governorAdmin = newGovernorAdmin;
30         emit InstallerSetGovernorAdmin(newGovernorAdmin);
31     }
32 
33     function installModules(address[] memory moduleAddrs) external nonReentrant adminOnly {
34         for (uint i = 0; i < moduleAddrs.length; ++i) {
35             address moduleAddr = moduleAddrs[i];
36             uint newModuleId = BaseModule(moduleAddr).moduleId();
37             bytes32 moduleGitCommit = BaseModule(moduleAddr).moduleGitCommit();
38 
39             moduleLookup[newModuleId] = moduleAddr;
40 
41             if (newModuleId <= MAX_EXTERNAL_SINGLE_PROXY_MODULEID) {
42                 address proxyAddr = _createProxy(newModuleId);
43                 trustedSenders[proxyAddr].moduleImpl = moduleAddr;
44             }
45 
46             emit InstallerInstallModule(newModuleId, moduleAddr, moduleGitCommit);
47         }
48     }
49 }
