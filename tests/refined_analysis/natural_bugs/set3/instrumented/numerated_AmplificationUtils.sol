1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.6.12;
4 
5 import "@openzeppelin/contracts/token/ERC20/SafeERC20.sol";
6 import "./SwapUtils.sol";
7 
8 /**
9  * @title AmplificationUtils library
10  * @notice A library to calculate and ramp the A parameter of a given `SwapUtils.Swap` struct.
11  * This library assumes the struct is fully validated.
12  */
13 library AmplificationUtils {
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
36     function getA(SwapUtils.Swap storage self) external view returns (uint256) {
37         return _getAPrecise(self).div(A_PRECISION);
38     }
39 
40     /**
41      * @notice Return A in its raw precision
42      * @dev See the StableSwap paper for details
43      * @param self Swap struct to read from
44      * @return A parameter in its raw precision form
45      */
46     function getAPrecise(SwapUtils.Swap storage self)
47         external
48         view
49         returns (uint256)
50     {
51         return _getAPrecise(self);
52     }
53 
54     /**
55      * @notice Return A in its raw precision
56      * @dev See the StableSwap paper for details
57      * @param self Swap struct to read from
58      * @return A parameter in its raw precision form
59      */
60     function _getAPrecise(SwapUtils.Swap storage self)
61         internal
62         view
63         returns (uint256)
64     {
65         uint256 t1 = self.futureATime; // time when ramp is finished
66         uint256 a1 = self.futureA; // final A value when ramp is finished
67 
68         if (block.timestamp < t1) {
69             uint256 t0 = self.initialATime; // time when ramp is started
70             uint256 a0 = self.initialA; // initial A value when ramp is started
71             if (a1 > a0) {
72                 // a0 + (a1 - a0) * (block.timestamp - t0) / (t1 - t0)
73                 return
74                     a0.add(
75                         a1.sub(a0).mul(block.timestamp.sub(t0)).div(t1.sub(t0))
76                     );
77             } else {
78                 // a0 - (a0 - a1) * (block.timestamp - t0) / (t1 - t0)
79                 return
80                     a0.sub(
81                         a0.sub(a1).mul(block.timestamp.sub(t0)).div(t1.sub(t0))
82                     );
83             }
84         } else {
85             return a1;
86         }
87     }
88 
89     /**
90      * @notice Start ramping up or down A parameter towards given futureA_ and futureTime_
91      * Checks if the change is too rapid, and commits the new A value only when it falls under
92      * the limit range.
93      * @param self Swap struct to update
94      * @param futureA_ the new A to ramp towards
95      * @param futureTime_ timestamp when the new A should be reached
96      */
97     function rampA(
98         SwapUtils.Swap storage self,
99         uint256 futureA_,
100         uint256 futureTime_
101     ) external {
102         require(
103             block.timestamp >= self.initialATime.add(1 days),
104             "Wait 1 day before starting ramp"
105         );
106         require(
107             futureTime_ >= block.timestamp.add(MIN_RAMP_TIME),
108             "Insufficient ramp time"
109         );
110         require(
111             futureA_ > 0 && futureA_ < MAX_A,
112             "futureA_ must be > 0 and < MAX_A"
113         );
114 
115         uint256 initialAPrecise = _getAPrecise(self);
116         uint256 futureAPrecise = futureA_.mul(A_PRECISION);
117 
118         if (futureAPrecise < initialAPrecise) {
119             require(
120                 futureAPrecise.mul(MAX_A_CHANGE) >= initialAPrecise,
121                 "futureA_ is too small"
122             );
123         } else {
124             require(
125                 futureAPrecise <= initialAPrecise.mul(MAX_A_CHANGE),
126                 "futureA_ is too large"
127             );
128         }
129 
130         self.initialA = initialAPrecise;
131         self.futureA = futureAPrecise;
132         self.initialATime = block.timestamp;
133         self.futureATime = futureTime_;
134 
135         emit RampA(
136             initialAPrecise,
137             futureAPrecise,
138             block.timestamp,
139             futureTime_
140         );
141     }
142 
143     /**
144      * @notice Stops ramping A immediately. Once this function is called, rampA()
145      * cannot be called for another 24 hours
146      * @param self Swap struct to update
147      */
148     function stopRampA(SwapUtils.Swap storage self) external {
149         require(self.futureATime > block.timestamp, "Ramp is already stopped");
150 
151         uint256 currentA = _getAPrecise(self);
152         self.initialA = currentA;
153         self.futureA = currentA;
154         self.initialATime = block.timestamp;
155         self.futureATime = block.timestamp;
156 
157         emit StopRampA(currentA, block.timestamp);
158     }
159 }
