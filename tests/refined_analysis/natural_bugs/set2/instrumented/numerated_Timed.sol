1 // SPDX-License-Identifier: GPL-3.0-or-later
2 pragma solidity ^0.8.4;
3 
4 /// @title an abstract contract for timed events
5 /// @author Fei Protocol
6 abstract contract Timed {
7     /// @notice the start timestamp of the timed period
8     uint256 public startTime;
9 
10     /// @notice the duration of the timed period
11     uint256 public duration;
12 
13     event DurationUpdate(uint256 oldDuration, uint256 newDuration);
14 
15     event TimerReset(uint256 startTime);
16 
17     constructor(uint256 _duration) {
18         _setDuration(_duration);
19     }
20 
21     modifier duringTime() {
22         require(isTimeStarted(), "Timed: time not started");
23         require(!isTimeEnded(), "Timed: time ended");
24         _;
25     }
26 
27     modifier afterTime() {
28         require(isTimeEnded(), "Timed: time not ended");
29         _;
30     }
31 
32     /// @notice return true if time period has ended
33     function isTimeEnded() public view returns (bool) {
34         return remainingTime() == 0;
35     }
36 
37     /// @notice number of seconds remaining until time is up
38     /// @return remaining
39     function remainingTime() public view returns (uint256) {
40         return duration - timeSinceStart(); // duration always >= timeSinceStart which is on [0,d]
41     }
42 
43     /// @notice number of seconds since contract was initialized
44     /// @return timestamp
45     /// @dev will be less than or equal to duration
46     function timeSinceStart() public view returns (uint256) {
47         if (!isTimeStarted()) {
48             return 0; // uninitialized
49         }
50         uint256 _duration = duration;
51         uint256 timePassed = block.timestamp - startTime; // block timestamp always >= startTime
52         return timePassed > _duration ? _duration : timePassed;
53     }
54 
55     function isTimeStarted() public view returns (bool) {
56         return startTime != 0;
57     }
58 
59     function _initTimed() internal {
60         startTime = block.timestamp;
61 
62         emit TimerReset(block.timestamp);
63     }
64 
65     function _setDuration(uint256 newDuration) internal {
66         require(newDuration != 0, "Timed: zero duration");
67 
68         uint256 oldDuration = duration;
69         duration = newDuration;
70         emit DurationUpdate(oldDuration, newDuration);
71     }
72 }
