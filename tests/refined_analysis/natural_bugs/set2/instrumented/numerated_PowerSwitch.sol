1 // SPDX-License-Identifier: GPL-3.0-only
2 pragma solidity 0.7.6;
3 
4 import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
5 
6 interface IPowerSwitch {
7     /* admin events */
8 
9     event PowerOn();
10     event PowerOff();
11     event EmergencyShutdown();
12 
13     /* data types */
14 
15     enum State {Online, Offline, Shutdown}
16 
17     /* admin functions */
18 
19     function powerOn() external;
20 
21     function powerOff() external;
22 
23     function emergencyShutdown() external;
24 
25     /* view functions */
26 
27     function isOnline() external view returns (bool status);
28 
29     function isOffline() external view returns (bool status);
30 
31     function isShutdown() external view returns (bool status);
32 
33     function getStatus() external view returns (State status);
34 
35     function getPowerController() external view returns (address controller);
36 }
37 
38 /// @title PowerSwitch
39 /// @notice Standalone pausing and emergency stop functionality
40 contract PowerSwitch is IPowerSwitch, Ownable {
41     /* storage */
42 
43     IPowerSwitch.State private _status;
44 
45     /* initializer */
46 
47     constructor(address owner) {
48         // sanity check owner
49         require(owner != address(0), "PowerSwitch: invalid owner");
50         // transfer ownership
51         Ownable.transferOwnership(owner);
52     }
53 
54     /* admin functions */
55 
56     /// @notice Turn Power On
57     /// access control: only admin
58     /// state machine: only when offline
59     /// state scope: only modify _status
60     /// token transfer: none
61     function powerOn() external override onlyOwner {
62         require(_status == IPowerSwitch.State.Offline, "PowerSwitch: cannot power on");
63         _status = IPowerSwitch.State.Online;
64         emit PowerOn();
65     }
66 
67     /// @notice Turn Power Off
68     /// access control: only admin
69     /// state machine: only when online
70     /// state scope: only modify _status
71     /// token transfer: none
72     function powerOff() external override onlyOwner {
73         require(_status == IPowerSwitch.State.Online, "PowerSwitch: cannot power off");
74         _status = IPowerSwitch.State.Offline;
75         emit PowerOff();
76     }
77 
78     /// @notice Shutdown Permanently
79     /// access control: only admin
80     /// state machine:
81     /// - when online or offline
82     /// - can only be called once
83     /// state scope: only modify _status
84     /// token transfer: none
85     function emergencyShutdown() external override onlyOwner {
86         require(_status != IPowerSwitch.State.Shutdown, "PowerSwitch: cannot shutdown");
87         _status = IPowerSwitch.State.Shutdown;
88         emit EmergencyShutdown();
89     }
90 
91     /* getter functions */
92 
93     function isOnline() external view override returns (bool status) {
94         return _status == State.Online;
95     }
96 
97     function isOffline() external view override returns (bool status) {
98         return _status == State.Offline;
99     }
100 
101     function isShutdown() external view override returns (bool status) {
102         return _status == State.Shutdown;
103     }
104 
105     function getStatus() external view override returns (IPowerSwitch.State status) {
106         return _status;
107     }
108 
109     function getPowerController() external view override returns (address controller) {
110         return Ownable.owner();
111     }
112 }
