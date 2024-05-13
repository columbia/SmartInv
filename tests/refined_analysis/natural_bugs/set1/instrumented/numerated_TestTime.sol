1 // SPDX-License-Identifier: BUSL-1.1
2 pragma solidity 0.8.19;
3 
4 import { Time } from "../utility/Time.sol";
5 
6 contract TestTime is Time {
7     uint32 private _currentTime = 1;
8 
9     function setTime(uint32 newTime) external {
10         _currentTime = newTime;
11     }
12 
13     function currentTime() external view returns (uint32) {
14         return _currentTime;
15     }
16 
17     function realTime() external view returns (uint32) {
18         return super._time();
19     }
20 
21     function _time() internal view virtual override returns (uint32) {
22         return _currentTime;
23     }
24 }
