1 // SPDX-License-Identifier: BUSL-1.1
2 pragma solidity 0.8.19;
3 
4 import { IVersioned } from "../utility/interfaces/IVersioned.sol";
5 import { Upgradeable } from "../utility/Upgradeable.sol";
6 
7 contract TestUpgradeable is Upgradeable {
8     uint16 private _version;
9 
10     function initialize() external initializer {
11         __TestUpgradeable_init();
12     }
13 
14     // solhint-disable func-name-mixedcase
15 
16     function __TestUpgradeable_init() internal onlyInitializing {
17         __Upgradeable_init();
18 
19         __TestUpgradeable_init_unchained();
20     }
21 
22     function __TestUpgradeable_init_unchained() internal onlyInitializing {
23         _version = 1;
24     }
25 
26     // solhint-enable func-name-mixedcase
27 
28     function version() public view override(Upgradeable) returns (uint16) {
29         return _version;
30     }
31 
32     function setVersion(uint16 newVersion) external {
33         _version = newVersion;
34     }
35 
36     function initializations() external view returns (uint16) {
37         return _initializations;
38     }
39 
40     function setInitializations(uint16 newInitializations) external {
41         _initializations = newInitializations;
42     }
43 
44     function restricted() external view onlyAdmin {}
45 }
