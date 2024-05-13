1 // SPDX-License-Identifier: GPL-3.0-only
2 pragma solidity 0.7.6;
3 
4 import {IPowerSwitch} from "./PowerSwitch.sol";
5 
6 interface IPowered {
7     function isOnline() external view returns (bool status);
8 
9     function isOffline() external view returns (bool status);
10 
11     function isShutdown() external view returns (bool status);
12 
13     function getPowerSwitch() external view returns (address powerSwitch);
14 
15     function getPowerController() external view returns (address controller);
16 }
17 
18 /// @title Powered
19 /// @notice Helper for calling external PowerSwitch
20 contract Powered is IPowered {
21     /* storage */
22 
23     address private _powerSwitch;
24 
25     /* modifiers */
26 
27     modifier onlyOnline() {
28         _onlyOnline();
29         _;
30     }
31 
32     modifier onlyOffline() {
33         _onlyOffline();
34         _;
35     }
36 
37     modifier notShutdown() {
38         _notShutdown();
39         _;
40     }
41 
42     modifier onlyShutdown() {
43         _onlyShutdown();
44         _;
45     }
46 
47     /* initializer */
48 
49     function _setPowerSwitch(address powerSwitch) internal {
50         _powerSwitch = powerSwitch;
51     }
52 
53     /* getter functions */
54 
55     function isOnline() public view override returns (bool status) {
56         return IPowerSwitch(_powerSwitch).isOnline();
57     }
58 
59     function isOffline() public view override returns (bool status) {
60         return IPowerSwitch(_powerSwitch).isOffline();
61     }
62 
63     function isShutdown() public view override returns (bool status) {
64         return IPowerSwitch(_powerSwitch).isShutdown();
65     }
66 
67     function getPowerSwitch() public view override returns (address powerSwitch) {
68         return _powerSwitch;
69     }
70 
71     function getPowerController() public view override returns (address controller) {
72         return IPowerSwitch(_powerSwitch).getPowerController();
73     }
74 
75     /* convenience functions */
76 
77     function _onlyOnline() private view {
78         require(isOnline(), "Powered: is not online");
79     }
80 
81     function _onlyOffline() private view {
82         require(isOffline(), "Powered: is not offline");
83     }
84 
85     function _notShutdown() private view {
86         require(!isShutdown(), "Powered: is shutdown");
87     }
88 
89     function _onlyShutdown() private view {
90         require(isShutdown(), "Powered: is not shutdown");
91     }
92 }
