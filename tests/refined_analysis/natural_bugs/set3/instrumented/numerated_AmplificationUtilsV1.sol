1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.6.12;
4 
5 import "@openzeppelin/contracts/token/ERC20/SafeERC20.sol";
6 import "./SwapUtilsV1.sol";
7 
8 /**
9  * @title AmplificationUtils library
10  * @notice A library to calculate and ramp the A parameter of a given `SwapUtils.Swap` struct.
11  * This library assumes the struct is fully validated.
12  */
13 library AmplificationUtilsV1 {
14     using SafeMath for uint256;
15 
16     event RampA(
17         uint256 oldA,
18         uint256 newA,
19         uint256 initialTime,
20         uint256 futureTime
21     );
22     event StopRampA(uint256 currentA, uint256 time);
23 
24     // Constant values used in ramping A calculations
25     uint256 public constant A_PRECISION = 100;
26     uint256 public constant MAX_A = 10**6;
27     uint256 private constant MAX_A_CHANGE = 2;
28     uint256 private constant MIN_RAMP_TIME = 14 days;
29 
30     /**
31      * @notice Return A, the amplification coefficient * n * (n - 1)
32      * @dev See the StableSwap paper for details
33      * @param self Swap struct to read from
34      * @return A parameter
35      */
36     function getA(SwapUtilsV1.Swap storage self)
37         external
38         view
39         returns (uint256)
40     {
41         return _getAPrecise(self).div(A_PRECISION);
42     }
43 
44     /**
45      * @notice Return A in its raw precision
46      * @dev See the StableSwap paper for details
47      * @param self Swap struct to read from
48      * @return A parameter in its raw precision form
49      */
50     function getAPrecise(SwapUtilsV1.Swap storage self)
51         external
52         view
53         returns (uint256)
54     {
55         return _getAPrecise(self);
56     }
57 
58     /**
59      * @notice Return A in its raw precision
60      * @dev See the StableSwap paper for details
61      * @param self Swap struct to read from
62      * @return A parameter in its raw precision form
63      */
64     function _getAPrecise(SwapUtilsV1.Swap storage self)
65         internal
66         view
67         returns (uint256)
68     {
69         uint256 t1 = self.futureATime; // time when ramp is finished
70         uint256 a1 = self.futureA; // final A value when ramp is finished
71 
72         if (block.timestamp < t1) {
73             uint256 t0 = self.initialATime; // time when ramp is started
74             uint256 a0 = self.initialA; // initial A value when ramp is started
75             if (a1 > a0) {
76                 // a0 + (a1 - a0) * (block.timestamp - t0) / (t1 - t0)
77                 return
78                     a0.add(
79                         a1.sub(a0).mul(block.timestamp.sub(t0)).div(t1.sub(t0))
80                     );
81             } else {
82                 // a0 - (a0 - a1) * (block.timestamp - t0) / (t1 - t0)
83                 return
84                     a0.sub(
85                         a0.sub(a1).mul(block.timestamp.sub(t0)).div(t1.sub(t0))
86                     );
87             }
88         } else {
89             return a1;
90         }
91     }
92 
93     /**
94      * @notice Start ramping up or down A parameter towards given futureA_ and futureTime_
95      * Checks if the change is too rapid, and commits the new A value only when it falls under
96      * the limit range.
97      * @param self Swap struct to update
98      * @param futureA_ the new A to ramp towards
99      * @param futureTime_ timestamp when the new A should be reached
100      */
101     function rampA(
102         SwapUtilsV1.Swap storage self,
103         uint256 futureA_,
104         uint256 futureTime_
105     ) external {
106         require(
107             block.timestamp >= self.initialATime.add(1 days),
108             "Wait 1 day before starting ramp"
109         );
110         require(
111             futureTime_ >= block.timestamp.add(MIN_RAMP_TIME),
112             "Insufficient ramp time"
113         );
114         require(
115             futureA_ > 0 && futureA_ < MAX_A,
116             "futureA_ must be > 0 and < MAX_A"
117         );
118 
119         uint256 initialAPrecise = _getAPrecise(self);
120         uint256 futureAPrecise = futureA_.mul(A_PRECISION);
121 
122         if (futureAPrecise < initialAPrecise) {
123             require(
124                 futureAPrecise.mul(MAX_A_CHANGE) >= initialAPrecise,
125                 "futureA_ is too small"
126             );
127         } else {
128             require(
129                 futureAPrecise <= initialAPrecise.mul(MAX_A_CHANGE),
130                 "futureA_ is too large"
131             );
132         }
133 
134         self.initialA = initialAPrecise;
135         self.futureA = futureAPrecise;
136         self.initialATime = block.timestamp;
137         self.futureATime = futureTime_;
138 
139         emit RampA(
140             initialAPrecise,
141             futureAPrecise,
142             block.timestamp,
143             futureTime_
144         );
145     }
146 
147     /**
148      * @notice Stops ramping A immediately. Once this function is called, rampA()
149      * cannot be called for another 24 hours
150      * @param self Swap struct to update
151      */
152     function stopRampA(SwapUtilsV1.Swap storage self) external {
153         require(self.futureATime > block.timestamp, "Ramp is already stopped");
154 
155         uint256 currentA = _getAPrecise(self);
156         self.initialA = currentA;
157         self.futureA = currentA;
158         self.initialATime = block.timestamp;
159         self.futureATime = block.timestamp;
160 
161         emit StopRampA(currentA, block.timestamp);
162     }
163 }
