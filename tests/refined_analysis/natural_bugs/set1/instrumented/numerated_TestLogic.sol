1 // SPDX-License-Identifier: BUSL-1.1
2 pragma solidity 0.8.19;
3 
4 import { Upgradeable } from "../utility/Upgradeable.sol";
5 import { MAX_GAP } from "../utility/Constants.sol";
6 
7 contract TestLogic is Upgradeable {
8     bool private _initializedLogic;
9     uint256 private _data;
10     uint16 private immutable _version;
11 
12     uint256[MAX_GAP - 1] private __gap;
13 
14     event Upgraded(uint16 newVersion, uint256 arg1, bool arg2, string arg3);
15 
16     constructor(uint16 initVersion) {
17         _version = initVersion;
18     }
19 
20     function initialize() external initializer {
21         __TestLogic_init();
22     }
23 
24     // solhint-disable func-name-mixedcase
25 
26     function __TestLogic_init() internal onlyInitializing {
27         __TestLogic_init_unchained();
28     }
29 
30     function __TestLogic_init_unchained() internal onlyInitializing {
31         _initializedLogic = true;
32 
33         _data = 100;
34     }
35 
36     // solhint-enable func-name-mixedcase
37 
38     function initialized() external view returns (bool) {
39         return _initializedLogic;
40     }
41 
42     function version() public view override returns (uint16) {
43         return _version;
44     }
45 
46     function data() external view returns (uint256) {
47         return _data;
48     }
49 
50     function setData(uint16 newData) external {
51         _data = newData;
52     }
53 }
