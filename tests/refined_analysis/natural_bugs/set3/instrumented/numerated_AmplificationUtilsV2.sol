1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.0;
4 
5 import "@openzeppelin/contracts-4.7.3/token/ERC20/utils/SafeERC20.sol";
6 import "./SwapUtilsV2.sol";
7 
8 /**
9  * @title AmplificationUtils library
10  * @notice A library to calculate and ramp the A parameter of a given `SwapUtilsV2.Swap` struct.
11  * This library assumes the struct is fully validated.
12  */
13 library AmplificationUtilsV2 {
14     event RampA(
15         uint256 oldA,
16         uint256 newA,
17         uint256 initialTime,
18         uint256 futureTime
19     );
20     event StopRampA(uint256 currentA, uint256 time);
21 
22     // Constant values used in ramping A calculations
23     uint256 public constant A_PRECISION = 100;
24     uint256 public constant MAX_A = 10**6;
25     uint256 private constant MAX_A_CHANGE = 2;
26     uint256 private constant MIN_RAMP_TIME = 14 days;
27 
28     /**
29      * @notice Return A, the amplification coefficient * n * (n - 1)
30      * @dev See the StableSwap paper for details
31      * @param self Swap struct to read from
32      * @return A parameter
33      */
34     function getA(SwapUtilsV2.Swap storage self)
35         external
36         view
37         returns (uint256)
38     {
39         return (_getAPrecise(self) / A_PRECISION);
40     }
41 
42     /**
43      * @notice Return A in its raw precision
44      * @dev See the StableSwap paper for details
45      * @param self Swap struct to read from
46      * @return A parameter in its raw precision form
47      */
48     function getAPrecise(SwapUtilsV2.Swap storage self)
49         external
50         view
51         returns (uint256)
52     {
53         return _getAPrecise(self);
54     }
55 
56     /**
57      * @notice Return A in its raw precision
58      * @dev See the StableSwap paper for details
59      * @param self Swap struct to read from
60      * @return A parameter in its raw precision form
61      */
62     function _getAPrecise(SwapUtilsV2.Swap storage self)
63         internal
64         view
65         returns (uint256)
66     {
67         uint256 t1 = self.futureATime; // time when ramp is finished
68         uint256 a1 = self.futureA; // final A value when ramp is finished
69 
70         if (block.timestamp < t1) {
71             uint256 t0 = self.initialATime; // time when ramp is started
72             uint256 a0 = self.initialA; // initial A value when ramp is started
73             if (a1 > a0) {
74                 // a0 + (a1 - a0) * (block.timestamp - t0) / (t1 - t0)
75                 return a0 + (((a1 - a0) * (block.timestamp - t0)) / (t1 - t0));
76             } else {
77                 // a0 - (a0 - a1) * (block.timestamp - t0) / (t1 - t0)
78                 return a0 - (((a0 - a1) * (block.timestamp - t0)) / (t1 - t0));
79             }
80         } else {
81             return a1;
82         }
83     }
84 
85     /**
86      * @notice Start ramping up or down A parameter towards given futureA_ and futureTime_
87      * Checks if the change is too rapid, and commits the new A value only when it falls under
88      * the limit range.
89      * @param self Swap struct to update
90      * @param futureA_ the new A to ramp towards
91      * @param futureTime_ timestamp when the new A should be reached
92      */
93     function rampA(
94         SwapUtilsV2.Swap storage self,
95         uint256 futureA_,
96         uint256 futureTime_
97     ) external {
98         require(
99             block.timestamp >= (self.initialATime + (1 days)),
100             "Wait 1 day before starting ramp"
101         );
102         require(
103             futureTime_ >= (block.timestamp + MIN_RAMP_TIME),
104             "Insufficient ramp time"
105         );
106         require(
107             futureA_ > 0 && futureA_ < MAX_A,
108             "futureA_ must be > 0 and < MAX_A"
109         );
110 
111         uint256 initialAPrecise = _getAPrecise(self);
112         uint256 futureAPrecise = futureA_ * A_PRECISION;
113 
114         if (futureAPrecise < initialAPrecise) {
115             require(
116                 (futureAPrecise * MAX_A_CHANGE) >= initialAPrecise,
117                 "futureA_ is too small"
118             );
119         } else {
120             require(
121                 futureAPrecise <= (initialAPrecise * MAX_A_CHANGE),
122                 "futureA_ is too large"
123             );
124         }
125 
126         self.initialA = initialAPrecise;
127         self.futureA = futureAPrecise;
128         self.initialATime = block.timestamp;
129         self.futureATime = futureTime_;
130 
131         emit RampA(
132             initialAPrecise,
133             futureAPrecise,
134             block.timestamp,
135             futureTime_
136         );
137     }
138 
139     /**
140      * @notice Stops ramping A immediately. Once this function is called, rampA()
141      * cannot be called for another 24 hours
142      * @param self Swap struct to update
143      */
144     function stopRampA(SwapUtilsV2.Swap storage self) external {
145         require(self.futureATime > block.timestamp, "Ramp is already stopped");
146 
147         uint256 currentA = _getAPrecise(self);
148         self.initialA = currentA;
149         self.futureA = currentA;
150         self.initialATime = block.timestamp;
151         self.futureATime = block.timestamp;
152 
153         emit StopRampA(currentA, block.timestamp);
154     }
155 }
